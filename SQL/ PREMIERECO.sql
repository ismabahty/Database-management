use PREMIERECO

COUNT

﻿--Aggregrates: compression on the data: and sometimes its the entire data.
﻿--Sometimes it's by group

SELECT COUNT (*) AS Total_employees
From EMPLOYEE;

SELECT * FROM EMPLOYEE;

﻿SELECT COUNT (LNAME)
FROM EMPLOYEE

﻿--Distinct with count

SELECT COUNT(DISTINCT EMP_STATE) AS Unique_City
FROM EMPLOYEE;

--- GROUP BY

-- QQQQ count the orders have customers placed

SELECT * FROM ORDERS

SELECT O.CUST_NUM, C.CUST_NAME
      COUNT(ORDER_NUM) as [Total Orders]
   FROM ORDERS O
   JOIN CUSTOMER C ON O.CUST_NUM = C.CUST_NUM
   GROUP BY 0.CUST_NUM , C.Cust_Name
   ORDER BY [Total Orders] DESC;

---LAB 4B QQQ : Find how many products exist in each category

 SELECT CATEGORY, COUNT(CATEGORY) AS [PRODUCT COUNT]
 FROM PART
 GROUP BY CATEGORY;

---LAB 482 Q00 Find total customers in each state :
SELECT CUST_STATE, COUNT (CUST_STATE) AS [TOTAL CUSTOMER]
FROM CUSTOMER 
GROUP BY CUST_STATE;


SELECT * FROM CUSTOMER

-- 4C Lets count how many employees per role

SELECT
COUNT (*)AS [total employees per role]
FROM EMPLOYEE
GROUP BY EmpType;

-- CASE WHEN

We can count the conditionals with case when

--QQQQ : how may sales people =1, managerst and clerks

SELECT 
    COUNT (CASE WHEN EmpType =1 THEN 1 END) AS SalesPeople,
	COUNT (CASE WHEN EmpType =2 THEN 2 END) AS Manager,
	COUNT (CASE WHEN EmpType =3 THEN 3 END) AS Clerk
FROM EMPLOYEE

---Cotegorizing what they are selling -- merchandise

SELECT
   CASE 
       WHEN CATEGORY = 'AP' THEN 'Appliance'
	   WHEN CATEGORY = 'HW' THEN 'Housewares'
	   WHEN CATEGORY = 'SG' THEN 'Sporting Goods'
	   ELSE 'Other'
	END AS Category_name
	FROM PART
GROUP BY 
CASE
       WHEN CATEGORY = 'AP' THEN 'Appliance'
	   WHEN CATEGORY = 'HW' THEN 'Housewares'
	   WHEN CATEGORY = 'SG' THEN 'Sporting Goods'
	   ELSE 'Other'
	END;



---lets use case.. when with range Hiring dates
1990- 1999 then they are 'old timers'
2000 - 2009 they are 'newbies'
YEAR(HIRE DATE) BETWEEN one year and The next year

SELECT
CASE
    WHEN YEAR(HIRE_Date)BETWEEN 1990 AND 1999 THEN 'Old timer'
    WHEN YEAR(HIRE_Date)BETWEEN 2000 AND 2009 THEN 'Newbie'
    ELSE 'Just Hired'

END AS [Hire decade],
COUNT (*) [Count of Employees]
FROM EMPLOYEE
GROUP BY
CASE
    WHEN YEAR(HIRE_Date)BETWEEN 1990 AND 1999 THEN 'Old timer'
    WHEN YEAR(HIRE_Date)BETWEEN 2000 AND 2009 THEN 'Newbie'
    ELSE 'Just Hired'
END;

-- range of prices for a given product :
Price less than $100 then'Low Price'
between 100 and 500 then 'medium price'
otherwise 'high price'
SELECT
CASE
    WHEN PRICE < 100 THEN 'Low Price'
	WHEN PRICE BETWEEN  100 AND 500 THEN 'Medium Price'

    ELSE 'High Price'

END as [price range]
COUNT(*) AS [Product Count]
FROM PART
GROUP BY
CASE
    WHEN PRICE < 100 THEN 'Low Price'
	WHEN PRICE BETWEEN  100 AND 500 THEN 'Medium Price'
	ELSE 'High Price'
END


-- WHERE :: off the select is filtered

﻿- Count orders in a specific date range COUNT with WHERE
﻿- 2000-01-01 and 2020-12-31
7A Count customers who have placed orders

-- group by customer number

 SELECT CUST_NUM, COUNT (ORDER_NUM) AS Total_orders
 FROM ORDERS
 GROUP BY CUST_NUM
 HAVING COUNT (ORDER_NUM) > 3


-- find all sales reps who have more than 3 customers

SELECT REP_NUM, COUNT (CUST_NUM) AS [TOTAL CUSTOMER] 
FROM CUSTOMER 
GROUP BY REP_ NUM
HAVING COUNT (CUST_NUM) > 3;





