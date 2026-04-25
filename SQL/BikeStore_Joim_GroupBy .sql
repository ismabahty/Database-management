USE BikeStores

---Orders per year (only orders after 2015; keep customers with ≥3 orders overall)

SELECT YEAR(o.order_date) AS order_year,
       COUNT(*) AS orders_count
FROM sales.orders AS o
WHERE o.order_date >= '2016-01-01'
  AND o.customer_id IN 
        SELECT customer_id
        FROM sales.orders
        GROUP BY customer_id
        HAVING COUNT(*) >= 3
GROUP BY YEAR(o.order_date)
ORDER BY order_year;

---Customer spending (SUM/AVG/MAX), keep total > 5000 and avg > 200
-- per-order totals

SELECT o.customer_id,
       SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_spent,
       AVG(oi.quantity * oi.list_price * (1 - oi.discount)) AS avg_order,
       MIN(oi.quantity * oi.list_price * (1 - oi.discount)) AS min_order,
       MAX(oi.quantity * oi.list_price * (1 - oi.discount)) AS max_order
FROM sales.orders o
JOIN sales.order_items oi
  ON o.order_id = oi.order_id
GROUP BY o.customer_id
HAVING SUM(oi.quantity * oi.list_price * (1 - oi.discount)) > 5000
   AND AVG(oi.quantity * oi.list_price * (1 - oi.discount)) > 200
ORDER BY total_spent DESC;


---Total revenue per category (only after 2018; need ≥5 distinct products sold)

SELECT p.category_id,
       SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue,
       COUNT(DISTINCT oi.product_id) AS distinct_products_sold
FROM sales.orders AS o
JOIN sales.order_items AS oi ON oi.order_id = o.order_id
JOIN production.products AS p ON p.product_id = oi.product_id
WHERE o.order_date >= '2019-01-01'        -- after 2018
GROUP BY p.category_id
HAVING COUNT(DISTINCT oi.product_id) >= 5
ORDER BY total_revenue DESC;

-- Average discount per order status (only statuses with ≥5 orders)

SELECT o.order_status,
       AVG(oi.discount) AS avg_discount
FROM sales.orders AS o
JOIN sales.order_items AS oi ON oi.order_id = o.order_id
GROUP BY o.order_status
HAVING COUNT(DISTINCT o.order_id) >= 5
ORDER BY o.order_status;


----Top & bottom selling products by units (exclude <5 and >1000)

  SELECT oi.product_id,
         SUM(oi.quantity) AS total_units
  FROM sales.order_items AS oi
  GROUP BY oi.product_id
  HAVING SUM(oi.quantity) BETWEEN 5 AND 1000


--- top 10

SELECT TOP (10) u.product_id, p.product_name, u.total_units
FROM units AS u
JOIN production.products AS p ON p.product_id = u.product_id
ORDER BY u.total_units DESC;



-- bottom 10

SELECT TOP (10) u.product_id, p.product_name, u.total_units
FROM units AS u
JOIN production.products AS p ON p.product_id = u.product_id
ORDER BY u.total_units ASC;



---Revenue per quarter (CASE WHEN + SUM)

SELECT YEAR(o.order_date) AS order_year,
       CASE
         WHEN MONTH(o.order_date) BETWEEN 1 AND 3  THEN 'Q1'
         WHEN MONTH(o.order_date) BETWEEN 4 AND 6  THEN 'Q2'
         WHEN MONTH(o.order_date) BETWEEN 7 AND 9  THEN 'Q3'
         ELSE 'Q4'
       END AS quarter_label,
       SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue
FROM sales.orders AS o
JOIN sales.order_items AS oi ON oi.order_id = o.order_id
GROUP BY YEAR(o.order_date),
         CASE
           WHEN MONTH(o.order_date) BETWEEN 1 AND 3  THEN 'Q1'
           WHEN MONTH(o.order_date) BETWEEN 4 AND 6  THEN 'Q2'
           WHEN MONTH(o.order_date) BETWEEN 7 AND 9  THEN 'Q3'
           ELSE 'Q4'
         END


 ---High-value products (> $10,000) — 

use only
sales.order_items



SELECT oi.product_id,
       SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_sales
FROM sales.order_items AS oi
GROUP BY oi.product_id
HAVING SUM(oi.quantity * oi.list_price * (1 - oi.discount)) > 10000
ORDER BY total_sales DESC;

---DELETE orders before 2015-01-01 (child rows first)
BEGIN TRANSACTION;

 DELETE oi
FROM sales.order_items oi
JOIN sales.orders o ON oi.order_id = o.order_id
WHERE o.order_date < '2015-01-01';

COMMIT TRANSACTION;

DELETE o
FROM sales.orders o
WHERE o.order_date < '2015-01-01';


---UPDATE: raise prices +10% for 

model_year <= 2018



BEGIN TRANSACTION;

  UPDATE p
  SET p.list_price = p.list_price * 1.10
  FROM production.products AS p
  WHERE p.model_year <= 2018;


COMMIT TRANSACTION;

---INSERT: add a new customer

INSERT INTO sales.customers
  (first_name, last_name, phone, email, street, city, state, zip_code)
VALUES
  ('Ariana', 'Rivera', '212-555-0188', 'ariana.rivera@example.com','123 Willow Ave', 'Brooklyn', 'NY', '11235');


--- DELETE: customers with 

no orders and non-store email

DELETE FROM sales.customers
WHERE customer_id NOT IN (SELECT customer_id FROM sales.orders)
  AND email NOT LIKE '@bikestores.com';


---- INSERT: new order for customer 105 (status=1 Pending) + 2 items



DECLARE @new_order_id INT;



BEGIN TRANSACTION;

  INSERT INTO sales.orders
    (customer_id, order_status, order_date, required_date, shipped_date, store_id, staff_id)
  VALUES
    (105, 1, GETDATE(), DATEADD(DAY, 7, GETDATE()), NULL, 1, 1);
  SET @new_order_id = SCOPE_IDENTITY();



  -- add two products (change product_id if needed)

  INSERT INTO sales.order_items (order_id, item_id, product_id, quantity, list_price, discount)
  SELECT @new_order_id, 1, p1.product_id, 2, p1.list_price, 0.05
  FROM production.products AS p1
  WHERE p1.product_id = 1;



  INSERT INTO sales.order_items (order_id, item_id, product_id, quantity, list_price, discount)
  SELECT @new_order_id, 2, p2.product_id, 1, p2.list_price, 0.00
  FROM production.products AS p2
  WHERE p2.product_id = 2;


COMMIT TRANSACTION;


---DELETE (same as #11): never-ordered & not 

@bikestores.co

DELETE c
FROM sales.customers c
LEFT JOIN sales.orders o 
    ON o.customer_id = c.customer_id
WHERE o.customer_id IS NULL
  AND c.email NOT LIKE '@bikestores.com';
