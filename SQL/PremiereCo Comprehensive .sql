-- ============================================================================
-- Class 4 — PremiereCo Comprehensive Lab (Answers)
-- Refined Format: rich explanations + usage on every question
-- Database: PREMIERECO

-- ============================================================================

USE PREMIERECO;
GO

/* ==========================================================================
SECTION A) DATE FUNCTIONS (DATEDIFF, YEAR/MONTH/DAY, DATEADD, GETDATE, DATENAME, DATEPART)
-------------------------------------------------------------------------------------------
Overview / Permutations you'll encounter:
  • GETDATE(), SYSDATETIME()                                   -- current timestamp
  • DATEADD(<part>, n, <date>)                                 -- shift a date by n units
  • DATEDIFF(<part>, <start>, <end>)                           -- boundaries crossed (year, month, day…)
  • YEAR(d), MONTH(d), DAY(d)                                  -- numeric components
  • DATEPART(part, d), DATENAME(part, d)                       -- numeric / name components
  • EOMONTH(d [,offset])                                       -- last day of month
Common parts: year, quarter, month, day, week, hour, minute, second
Notes:
  • DATEDIFF counts boundaries crossed; for exact ages consider month/day logic if needed.
  • BETWEEN for dates is inclusive; for day ranges, you can also do >= start AND < DATEADD(day,1,end).
============================================================================= */

-- Q A.1: Employee tenure in full years as of today.
-- Concept Recap: Years employed = DATEDIFF(year, HireDate, today).
-- Syntax: DATEDIFF(year, start_date, end_date)
-- Example (Answer):
SELECT E.FNAME, E.LNAME,
       DATEDIFF(year, E.HIRE_Date, CAST(GETDATE() AS date)) AS YearsEmployed
FROM dbo.EMPLOYEE AS E;

--  >>>>>>  Lab Question A.1: Also show months employed (total, not modulo 12).
-- Concept Recap: Use DATEDIFF(month, HireDate, today).
-- Syntax: DATEDIFF(month, start_date, end_date)
-- Answer:
SELECT E.FNAME, E.LNAME,
       DATEDIFF(month, E.HIRE_Date, GETDATE()) AS YearsEmployed
FROM dbo.EMPLOYEE AS E;


-- Q A.2: Current age of each employee and the name of their birth month.
-- Concept Recap: Age in years via DATEDIFF(year, BirthDate, today); month name via DATENAME(month, BirthDate).
-- Syntax: DATEDIFF(year, d1, d2), DATENAME(month, d)
-- Example (Answer):
SELECT E.FNAME, E.LNAME,
       DATEDIFF(year, E.BirthDate, CAST(GETDATE() AS date)) AS AgeNow,
       DATENAME(month, E.BirthDate) AS BirthMonthName
FROM dbo.EMPLOYEE AS E;

-- Lab Question A.2: For each order, add 14 days as a follow-up date; show (year, month number).
-- Concept Recap: DATEADD for +14 days, YEAR/MONTH extractors.
-- Syntax: DATEADD(day, n, date), YEAR(d), MONTH(d)
-- Answer:
SELECT  ORDER_NUM, ORDER_DATE,
   DATEADD(DAY , 14, ORDER_DATE) AS DelayedDate,
   YEAR(ORDER_DATE),
   MONTH(ORDER_DATE)
   FROM ORDERS



/* ==========================================================================
SECTION B) STRING CONCATENATION & STRING FUNCTIONS
--------------------------------------------------
Overview / Common operators & function permutations:
  • Concatenation: +      (NULL propagates)        |  CONCAT(a,b,...) (treats NULL as '')
  • ISNULL(expr, default) / COALESCE(a,b,...)      -- default for NULLs
  • SUBSTRING(s, start, length)                    -- 1-based
  • UPPER(s)/LOWER(s)                              -- case conversion
  • LEN(s) vs DATALENGTH(expr)                     -- char count vs bytes stored
  • LTRIM/RTRIM/TRIM(s)                            -- whitespace cleanup
  • CHARINDEX(sub, s [,start]) / PATINDEX('%pat%', s)
Notes:
  • Prefer CONCAT when mixing potential NULLs.
============================================================================= */

-- Q B.1: Build 'Last, First — City, ST' safely even if some fields are NULL.
-- Concept Recap: Use ISNULL around + concatenation or use CONCAT which treats NULL as empty.
-- Syntax: ISNULL(expr,'') + ..., or CONCAT(expr, ...)
-- Example (Answer):
SELECT E.EMP_Num,
       CONCAT(ISNULL(E.LNAME,''), ', ', ISNULL(E.FNAME,''), ' — ',
              ISNULL(E.CITY,''), ', ', RTRIM(ISNULL(E.EMP_STATE,''))) AS MailingLabel
FROM dbo.EMPLOYEE AS E;


SELECT E.EMP_Num,
       CONCAT(E.LNAME,', ', E.FNAME, ' — ',
              E.CITY, ', ', RTRIM(ISNULL(E.EMP_STATE,''))) AS MailingLabel
FROM dbo.EMPLOYEE AS E;


-- >>> Lab Question B.1: For each part, show a label: '(<PART_NUM>) <PART_DESCRIPTION>' in UPPER, plus its length.
-- Concept Recap: UPPER for case, CONCAT or +, LEN for character count.
-- Syntax: UPPER(s), CONCAT(a,b), LEN(s)
-- Answer:
 SELECT CONCAT(UPPER(PART_NUM), ',', UPPER(PART_DESCRIPTION))
 AS PartDescription , LEN(PART_DESCRIPTION) AS [length of part description]
 FROM PART


-- Q B.2: First initial '.' Last initial '.' from EMPLOYEE names (e.g., 'V.K.').
-- Concept Recap: SUBSTRING(field,1,1) to get initial; use + or CONCAT to join.
-- Syntax: SUBSTRING(s,1,1) + '.' + SUBSTRING(s,1,1) + '.'
-- Example (Answer):
SELECT E.EMP_Num,
       SUBSTRING(E.FNAME,1,1) + '.' + SUBSTRING(E.LNAME,1,1) + '.' AS Initials
FROM dbo.EMPLOYEE AS E;

-- Lab Question B.2: Show the position of 'Shop' (if present) within each customer name.
-- Concept Recap: CHARINDEX returns 0 if not found; PATINDEX supports LIKE patterns.
-- Syntax: CHARINDEX('Shop', CUST_NAME)
-- Answer:
SELECT CUST_NAME, 
     CHARINDEX('SHOP',CUST_NAME) AS ['SHOP'Position]
	 FROM CUSTOMER



/* ==========================================================================
SECTION C) CASE EXPRESSIONS
---------------------------
Overview / Permutations:
  • Simple CASE: CASE col WHEN value THEN x ... END
  • Searched_NAME  CASE: CASE WHEN condition THEN x ... ELSE y END
Use-cases: value mapping, banding, human-friendly flags.
NAME */

-- Q C.1: Map EmpType to text (1=Sales, 2=Manager, 3=Clerk, else Other).
-- Concept Recap: Simple CASE on EmpType.
-- Syntax: CASE EmpType WHEN 1 THEN 'Sales' ... END
-- Example (Answer):
SELECT E.EMP_Num, E.FNAME, E.LNAME, E.EmpType,
       CASE E.EmpType
         WHEN 1 THEN 'Sales'
         WHEN 2 THEN 'Manager'
         WHEN 3 THEN 'Clerk'
         ELSE 'Other'
       END AS EmpTypeText
FROM dbo.EMPLOYEE AS E;

SELECT *FROM ORDERS
-- Lab Question C.1: Band parts by price: <200 'Budget', 200–499 'Mid', else 'High'.
-- Concept Recap: Searched CASE with comparisons.
-- Syntax: CASE WHEN PRICE < 200 THEN ... WHEN PRICE < 500 THEN ... ELSE ... END
-- Answer:
SELECT PART_NUM, PRICE, 
   CASE
       WHEN PRICE < 200 THEN 'Budget'
	   WHEN PRICE < 500 THEN ' Mid'
	   ELSE 'High'

   END AS [Price of item]
   FROM PART



/* ==========================================================================
SECTION D) MATH OPERATORS (+, -, *, /)
--------------------------------------
Overview:
  • Use * for line revenue (qty * price), / for rates (watch integer division).
  • Cast to decimal if needed to avoid integer division.
============================================================================= */

-- Q D.1: Compute ItemRevenue = QTY_ORDERED * QUOTED_PRICE per order line.
-- Concept Recap: Multiply numeric columns; alias the result.
-- Syntax: (QTY_ORDERED * QUOTED_PRICE) AS ItemRevenue
-- Example (Answer):
SELECT OL.ORDER_NUM, OL.PART_NUM,
       OL.QTY_ORDERED * OL.QUOTED_PRICE AS ItemRevenue
FROM dbo.ORDER_LINE AS OL;

-- Lab Question D.1: Show list price and a 5% discount price for each part.
-- Concept Recap: Multiply by 0.95 for a 5% reduction (display only).
-- Syntax: PRICE * 0.95
-- Answer:
SELECT PART_NUM, Price as ListPrice,
     (Price * .95) as [5 % discount]
	 FROM PART

SELECT PART_NUM, Price as ListPrice,
     CONCAT ('$', CAST(CAST((Price * .95) as DECIMAL(10,2)) AS VARCHAR(20))) AS [5 % discount]
	 FROM PART


/* ==========================================================================
SECTION E) DISTINCT
-------------------
Overview:
  • DISTINCT removes duplicate rows from the projection.
  • Use with ORDER BY for consistent output ordering.
============================================================================= */

-- Q E.1: List unique employee cities.
-- Concept Recap: DISTINCT on a single column.
-- Syntax: SELECT DISTINCT CITY FROM EMPLOYEE
-- Example (Answer):
SELECT DISTINCT E.CITY
FROM dbo.EMPLOYEE AS E
ORDER BY E.CITY;

-- Lab Question E.1: List distinct ORDER years.
-- Concept Recap: Project YEAR(ORDER_DATE) then DISTINCT.
-- Syntax: SELECT DISTINCT YEAR(ORDER_DATE) FROM ORDERS
-- Answer:
SELECT DISTINCT YEAR(ORDER_DATE)
FROM ORDERS;


/* ==========================================================================
SECTION F) WHERE — FILTERING MODES
----------------------------------
Overview / Permutations & Options (beyond the examples below):
  • Comparison: =, <>, <, <=, >, >=
  • Range: BETWEEN a AND b (inclusive); alternative: col >= a AND col < DATEADD(day,1,b)
  • Set membership: IN (...), NOT IN (...)
  • Pattern matching (LIKE): 
        %  any length; _ single char; [abc] set; [a-c] range; [^a] not; ESCAPE for literal %/_
        Also: PATINDEX('%pat%', s) for position; CHARINDEX('sub', s) without wildcards
  • NULL checks: IS NULL / IS NOT NULL
  • Other useful filters (not all exercised below): EXISTS / NOT EXISTS, TOP (with ORDER BY),
        OFFSET ... FETCH, ANY/ALL (with subqueries), CROSS APPLY/OUTER APPLY for inline filters.
============================================================================= */

-- Comparison
-- Q F.1: Employees hired on/after 2016-01-01.
-- Concept Recap: Use >= date literal (ISO format yyyy-mm-dd).
-- Syntax: WHERE HIRE_Date >= '2016-01-01'
-- Example (Answer):
SELECT E.FNAME, E.LNAME, E.HIRE_Date
FROM dbo.EMPLOYEE AS E
WHERE E.HIRE_Date >= '2016-01-01';

-- Lab Question F.1: Parts priced strictly under 300.
-- Concept Recap: Use < with numeric comparison.
-- Syntax: WHERE PRICE < 300
-- Answer:
SELECT *
FROM PART
WHERE price <300


-- Range
-- Q F.2: Orders placed from 2015-12-20 through 2016-01-10 inclusive.
-- Concept Recap: BETWEEN is inclusive; dates in ISO are safe.
-- Syntax: WHERE ORDER_DATE BETWEEN '2015-12-20' AND '2016-01-10'
-- Example (Answer):
SELECT O.ORDER_NUM, O.ORDER_DATE
FROM dbo.ORDERS AS O
WHERE O.ORDER_DATE BETWEEN '2015-12-20' AND '2016-01-10'
ORDER BY O.ORDER_DATE;

-- Lab Question F.2: Parts whose UNITS_ON_HAND are between 8 and 25 (inclusive).
-- Concept Recap: BETWEEN lower AND upper.
-- Syntax: WHERE UNITS_ON_HAND BETWEEN 8 AND 25
-- Answer:
SELECT *
FROM PART
WHERE UNITS_ON_HAND BETWEEN 8 AND 25;


-- Set Membership
-- Q F.3: Customers from cities Grove, Sheldon, or Fillmore.
-- Concept Recap: IN list.
-- Syntax: WHERE CUST_CITY IN ('Grove','Sheldon','Fillmore')
-- Example (Answer):
SELECT C.CUST_NUM, C.CUST_NAME, C.CUST_CITY
FROM dbo.CUSTOMER AS C
WHERE C.CUST_CITY IN ('Grove','Sheldon','Fillmore');

-- Lab Question F.3: Orders from years 2015 or 2018 only.
-- Concept Recap: Apply IN to YEAR(ORDER_DATE).
-- Syntax: WHERE YEAR(ORDER_DATE) IN (2015,2018)
-- Answer:
SELECT *
FROM ORDERS 
WHERE YEAR(ORDER_DATE) IN (2015, 2018);

-- Pattern Matching
-- Q F.4: Employees whose last name begins with 'M' and second letter is not a vowel.
-- Concept Recap: LIKE with character class and negation; vowels set [AEIOUaeiou].
-- Syntax: WHERE LNAME LIKE 'M[^AEIOUaeiou]%'
-- Example (Answer):
SELECT E.EMP_Num, E.LNAME, E.FNAME
FROM dbo.EMPLOYEE AS E
WHERE E.LNAME LIKE 'M[^AEIOUaeiou]%';

-- Lab Question F.4: Customers whose names contain 'Store' or end with 'Shop' (either).
-- Concept Recap: OR across LIKE predicates; % wildcard.
-- Syntax: WHERE CUST_NAME LIKE '%Store%' OR CUST_NAME LIKE '%Shop'
-- Answer:
SELECT CUST_NAME, CUST_NUM
FROM CUSTOMER
WHERE CUST_NAME  LIKE '%STORE%' OR  CUST_NAME LIKE '%SHOP%'

-- NULL
-- Q F.5: Customers missing a PHONE.
-- Concept Recap: IS NULL checks absence of value (different from empty string).
-- Syntax: WHERE PHONE IS NULL
-- Example (Answer):
SELECT C.CUST_NUM, C.CUST_NAME, C.PHONE
FROM dbo.CUSTOMER AS C
WHERE C.PHONE IS NULL;

-- Lab Question F.5: Customers that DO have a phone (NOT NULL).
-- Concept Recap: Inverse check.
-- Syntax: WHERE PHONE IS NOT NULL
-- Answer:
SELECT C.CUST_NUM, C.CUST_NAME, C.PHONE
FROM dbo.CUSTOMER AS C
WHERE C.PHONE IS NOT NULL;


/* ==========================================================================
SECTION G) ORDER BY (SORTING)
-----------------------------
Overview / Options:
  • Single or multi-column; ASC/DESC per column.
  • Sort by expressions: ORDER BY YEAR(date), LEN(name), etc.
  • Ties: add secondary/tertiary keys for deterministic order.
============================================================================= */

-- Q G.1: Employees sorted by last name ASC, then first name ASC.
-- Concept Recap: Multi-key ORDER BY.
-- Syntax: ORDER BY LNAME ASC, FNAME ASC
-- Example (Answer):
SELECT E.FNAME, E.LNAME
FROM dbo.EMPLOYEE AS E
ORDER BY E.LNAME, E.FNAME;

-- Lab Question G.1: Parts sorted by PRICE DESC then PART_NUM ASC.
-- Concept Recap: Mixed directions.
-- Syntax: ORDER BY PRICE DESC, PART_NUM ASC
-- Answer:
SELECT PART_NUM , PRICE 
FROM PART 
ORDER BY PART_NUM ASC


/* ==========================================================================
SECTION H) AGGREGATES (NO GROUP BY) — sum(), count(), max(), min(), avg()
--------------------------------------------------------------------------
Overview / Permutations:
  • COUNT(*) vs COUNT(col) vs COUNT(DISTINCT col)
  • DISTINCT inside aggregates: SUM(DISTINCT x)
  • Casting for AVG on INT to avoid integer semantics.
============================================================================= */

-- ==============================
-- COUNT()
-- ==============================

-- Q H.1 (Example): How many employees are in the database?
-- Concept Recap: COUNT(*) counts rows; COUNT(col) ignores NULLs.
-- Syntax: SELECT COUNT(*) FROM <table>
SELECT COUNT(*) AS NumEmployees
FROM dbo.EMPLOYEE;

-- Lab Question H.1: How many orders are in the database?
-- Concept Recap: COUNT(*) on ORDERS table.
-- Syntax: SELECT COUNT(*) FROM ORDERS
-- Answer:
SELECT COUNT (*) AS [Num of orders]
FROM ORDERS


-- ==============================
-- SUM()
-- ==============================

-- Q H.2 (Example): What is the total number of units ordered across all order lines?
-- Concept Recap: SUM aggregates numeric values.
-- Syntax: SELECT SUM(column) FROM <table>
SELECT SUM(OL.QTY_ORDERED) AS TotalUnitsOrdered
FROM dbo.ORDER_LINE AS OL;

-- Lab Question H.2: What is the total of all part prices in the PART table?
-- Concept Recap: SUM over PRICE column.
-- Syntax: SELECT SUM(PRICE) FROM PART
-- Answer:
SELECT SUM(OL.QTY_ORDERED) AS TotalUnitsOrdered
FROM dbo.ORDER_LINE AS OL;


-- ==============================
-- MAX()
-- ==============================

-- Q H.3 (Example): What is the maximum part price in the database?
-- Concept Recap: MAX finds the single highest value in the column.
-- Syntax: SELECT MAX(column) FROM <table>
SELECT MAX(P.PRICE) AS MaxPartPrice
FROM dbo.PART AS P;

-- Lab Question H.3: What is the latest (most recent) hire date among employees?
-- Concept Recap: MAX works on date values too.
-- Syntax: SELECT MAX(date_column) FROM EMPLOYEE
-- Answer:


select * from employee
-- ==============================
-- MIN()
-- ==============================

-- Q H.4 (Example): What is the oldest person across employees?
-- Concept Recap: MIN finds the lowest value.
-- Syntax: SELECT MIN(column) FROM <table>
SELECT MIN(E.BirthDate) AS OldestPerson
FROM dbo.EMPLOYEE AS E;

-- Lab Question H.4: What is the earliest order date in the ORDERS table?
-- Concept Recap: MIN works on dates as well.
-- Syntax: SELECT MIN(date_column) FROM ORDERS
-- Answer:
SELECT MIN(ORDER_DATE) AS EarliestOrderDate
FROM ORDERS



-- ==============================
-- AVG()
-- ==============================

-- Q H.5 (Example): What is the average quoted price across all order lines?
-- Concept Recap: AVG finds the mean; cast to decimal to avoid integer truncation.
-- Syntax: SELECT AVG(CAST(column AS decimal(10,2))) FROM <table>
SELECT CAST(AVG(CAST(OL.QUOTED_PRICE AS decimal(10,2))) AS decimal(10,2)) AS AvgQuotedPrice
FROM dbo.ORDER_LINE AS OL;


-- Lab Question H.5: What is the average age across employees?
-- Concept Recap: Calculate each employee’s age with DATEDIFF(year, BirthDate, today),
--                then take AVG of that derived value. CAST to decimal for clarity.
-- Syntax: AVG(CAST(DATEDIFF(year, BirthDate, GETDATE()) AS decimal(10,2)))

-- Answer:

SELECT CAST(AVG(CAST(OL.QUOTED_PRICE AS decimal (10,2))) as decimal (10,2)) as AvgQuotedPrice
From dbo.ORDER_LINE AS OL;



/* ==========================================================================
SECTION I) FILTERED AGGREGATES (WHERE + aggregates)
--------------------------------------------------- */

-- Q I.1: Total units ordered for part 'AT94'
-- Concept Recap: Aggregation + WHERE filter on the same table (ORDER_LINE only).
-- Syntax: SUM(QTY_ORDERED) with WHERE PART_NUM='AT94'

-- Example (Answer):
SELECT SUM(OL.QTY_ORDERED) AS TotalUnits_AT94
FROM dbo.ORDER_LINE AS OL
WHERE OL.PART_NUM = 'AT94';



-- Lab Question I.1: -- Total revenue (qty*price) for orders placed in 2016
SELECT SUM (QTY_ORDERED * QUOTED_PRICE)
FROM ORDER_LINE AS OL
JOIN ORDERS AS O ON O.ORDER_NUM = OL.ORDER_NUM
WHERE YEAR(ORDER_DATE) = 2016




/* ==========================================================================
SECTION J) GROUP BY (Aggregating groups of rows)
-----------------------------------------------
Overview / Permutations & Options:
  • GROUP BY one or multiple columns, or by expressions (e.g., YEAR(OrderDate)).
  • HAVING filters groups; WHERE filters detail rows before grouping.
  • Extended grouping (advanced): GROUPING SETS, ROLLUP, CUBE (not used here).
============================================================================= */

-- Q J.1: For each order, total revenue.
-- Concept Recap: GROUP BY ORDER_NUM; SUM line revenue.
-- Syntax: SELECT ORDER_NUM, SUM(QTY*PRICE) ... GROUP BY ORDER_NUM
-- Example (Answer):
SELECT OL.ORDER_NUM,
       SUM(OL.QTY_ORDERED * OL.QUOTED_PRICE) AS OrderRevenue
FROM dbo.ORDER_LINE AS OL
GROUP BY OL.ORDER_NUM
ORDER BY OL.ORDER_NUM;

-- Lab Question J.1: For each part, total quantity ordered across all order lines.
-- Concept Recap: GROUP BY PART_NUM with SUM(QTY_ORDERED).
-- Syntax: SELECT PART_NUM, SUM(QTY_ORDERED) ... GROUP BY PART_NUM
-- Answer:
SELECT PART_NUM, SUM(QTY_ORDERED) AS TotalQuantityOrdered
FROM ORDER_LINE
GROUP BY PART_NUM;

-- Q J.2: For each order year, how many orders?
-- Concept Recap: GROUP BY YEAR(ORDER_DATE).
-- Syntax: SELECT YEAR(ORDER_DATE), COUNT(*) ... GROUP BY YEAR(ORDER_DATE)
-- Example (Answer):



/* ==========================================================================
SECTION K) HAVING (Restricting groups after GROUP BY)
-----------------------------------------------------
Overview / Options:
  • HAVING applies conditions to aggregate results.
  • Typical pattern: GROUP BY ... HAVING COUNT(*) >= n
============================================================================= */

-- Q K.1: Years with at least 3 orders.
-- Concept Recap: GROUP BY year; HAVING COUNT(*) >= 3.
-- Syntax: ... GROUP BY YEAR(ORDER_DATE) HAVING COUNT(*) >= 3
-- Example (Answer):
SELECT YEAR(O.ORDER_DATE) AS OrderYear,
       COUNT(*)           AS NumOrders
FROM dbo.ORDERS AS O
GROUP BY YEAR(O.ORDER_DATE)
HAVING COUNT(*) >= 3
ORDER BY OrderYear;

-- Lab Question K.1: Parts whose total ordered quantity is at least 3.
-- Concept Recap: HAVING after GROUP BY PART_NUM.
-- Syntax: ... GROUP BY PART_NUM HAVING SUM(QTY_ORDERED) >= 3
-- Answer:
SELECT PART_NUM, SUM(QTY_ORDERED) AS TotalQuantityOrdered
FROM ORDER_LINE
GROUP BY PART_NUM 
HAVING SUM (QTY_ORDERED) >=3;

/* ==========================================================================
K.x (Additional Example 1) — ORDER_LINE
Goal: Keep parts whose grouped metrics meet multiple thresholds.
Uses: WHERE (pre-filter), GROUP BY, HAVING with SUM/AVG/COUNT, ORDER BY
============================================================================= */

-- Q K.x.1 (Example): For each part, show
--   • Total revenue = SUM(QTY_ORDERED * QUOTED_PRICE)
--   • Avg quoted price
--   • Lines count
-- Keep only groups where:
--   • SUM(revenue) >= 500
--   • AVG(QUOTED_PRICE) >= 100
--   • COUNT(*) >= 2
-- Then sort by total revenue DESC.

-- Concept Recap: HAVING filters aggregated groups; WHERE filters detail rows first.
-- Syntax:
--   SELECT PART_NUM, SUM(...), AVG(...), COUNT(*)
--   FROM ORDER_LINE
--   WHERE <row-level conditions>
--   GROUP BY PART_NUM
--   HAVING SUM(...) >= ... AND AVG(...) >= ... AND COUNT(*) >= ...
--   ORDER BY SUM(...) DESC

SELECT
  OL.PART_NUM,
  SUM(OL.QTY_ORDERED * OL.QUOTED_PRICE) AS TotalRevenue,
  CAST(AVG(CAST(OL.QUOTED_PRICE AS decimal(10,2))) AS decimal(10,2)) AS AvgQuotedPrice,
  COUNT(*) AS LineCount
FROM dbo.ORDER_LINE AS OL
WHERE OL.QTY_ORDERED > 0              -- row-level filter (optional but typical)
GROUP BY OL.PART_NUM
HAVING
  SUM(OL.QTY_ORDERED * OL.QUOTED_PRICE) >= 500
  AND AVG(OL.QUOTED_PRICE) >= 100
  AND COUNT(*) >= 2
ORDER BY TotalRevenue DESC;


/* ==========================================================================
K.x (Additional Example 2) — EMPLOYEE
Goal: Cities with enough employees and a high average age (derived from BirthDate).
Uses: WHERE (pre-filter by HireDate), GROUP BY, HAVING with COUNT and AVG of an expression
============================================================================= */

-- Q K.x.2 (Example): For each city, compute
--   • Employee count
--   • Average employee age (in years)
-- Keep only cities where:
--   • COUNT(*) >= 2
--   • AVG(age) >= 40
-- Only consider employees hired on/after 2010-01-01 to make the sample interesting.

-- Concept Recap: HAVING can use aggregates over expressions (e.g., AVG(DATEDIFF(...))).
-- Syntax:
--   SELECT CITY, COUNT(*), AVG(DATEDIFF(year, BirthDate, GETDATE()))
--   FROM EMPLOYEE
--   WHERE HIRE_Date >= '2010-01-01'
--   GROUP BY CITY
--   HAVING COUNT(*) >= 2 AND AVG(DATEDIFF(year, BirthDate, GETDATE())) >= 40
--   ORDER BY COUNT(*) DESC

SELECT
  E.CITY,
  COUNT(*) AS NumEmployees,
  CAST(AVG(CAST(DATEDIFF(year, E.BirthDate, GETDATE()) AS decimal(10,2))) AS decimal(10,2)) AS AvgAgeYears
FROM dbo.EMPLOYEE AS E
WHERE E.HIRE_Date >= '2010-01-01'
GROUP BY E.CITY
HAVING
  COUNT(*) >= 2
  AND AVG(DATEDIFF(year, E.BirthDate, GETDATE())) >= 40
ORDER BY NumEmployees DESC, E.CITY;


/* ==========================================================================
K.x (Additional Example 3) — PART
Goal: Categories with healthy inventory and sufficient average price.
Uses: GROUP BY category, HAVING with SUM and AVG, ORDER BY
============================================================================= */

-- Q K.x.3 (Example): For each category, show
--   • Total units on hand
--   • Average price
-- Keep only categories where:
--   • SUM(UNITS_ON_HAND) BETWEEN 3 AND 20
--   • AVG(PRICE) >= 10
-- Sort by category.

-- Concept Recap: HAVING supports ranges (e.g., BETWEEN) on aggregates.
-- Syntax:
--   SELECT CATEGORY, SUM(UNITS_ON_HAND), AVG(PRICE)
--   FROM PART
--   GROUP BY CATEGORY
--   HAVING SUM(UNITS_ON_HAND) BETWEEN 50 AND 200 AND AVG(PRICE) >= 100
--   ORDER BY CATEGORY

SELECT
  P.CATEGORY,
  SUM(P.UNITS_ON_HAND) AS TotalUnitsOnHand,
  CAST(AVG(CAST(P.PRICE AS decimal(10,2))) AS decimal(10,2)) AS AvgPrice
FROM dbo.PART AS P
GROUP BY P.CATEGORY
HAVING
  SUM(P.UNITS_ON_HAND) BETWEEN 3 AND 20
  AND AVG(P.PRICE) >= 10
ORDER BY P.CATEGORY;
