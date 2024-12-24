-- This test case verifies the following issue: CBRD-25746.
-- When a stored procedure is included in the GROUP BY clause with rollup (e.g., GROUP BY test_fc(dept_no), name WITH ROLLUP),
-- ensure that the aggregated rows for some grouping levels no longer show NULL values instead of the expected aggregated values.

CREATE OR REPLACE FUNCTION test_fc_int(i INT) RETURN INT AS LANGUAGE JAVA NAME 'SpTest7.typetestint(int) return int';
CREATE OR REPLACE FUNCTION test_fc_str(i string) RETURN string as language java name 'SpTest7.typeteststring(java.lang.String) return java.lang.String';

CREATE TABLE sales_tbl
(
    dept_no INT,
    name VARCHAR(20),
    sales_month INT,
    sales_amount INT DEFAULT 100,
    PRIMARY KEY (dept_no, name, sales_month)
);

INSERT INTO sales_tbl VALUES (201, 'George', 1, 450);
INSERT INTO sales_tbl VALUES (202, 'Alice', 1, 550);

evaluate 'Test Case 1: Using ROUND function in GROUP BY with WITH ROLLUP';
SELECT ROUND(dept_no), name, AVG(sales_amount)
FROM sales_tbl
WHERE sales_amount > 100
GROUP BY dept_no, name WITH ROLLUP;

evaluate 'Test Case 2: Using stored procedure in GROUP BY with WITH ROLLUP';
SELECT dept_no, name, AVG(sales_amount)
FROM sales_tbl
WHERE sales_amount > 100
GROUP BY test_fc_int(dept_no), name WITH ROLLUP;

evaluate 'Test Case 3: Including non-numeric columns in GROUP BY';
SELECT dept_no, name, AVG(sales_amount)
FROM sales_tbl
WHERE sales_amount > 100
GROUP BY dept_no, test_fc_str(name) WITH ROLLUP;

evaluate 'Test Case 4: Using stored procedure in WHERE clause';
SELECT dept_no, name, AVG(sales_amount)
FROM sales_tbl
WHERE test_fc_int(dept_no) > 200
GROUP BY test_fc_int(dept_no), name WITH ROLLUP;

evaluate 'Test Case 5: Using multiple stored procedures in GROUP BY';
SELECT dept_no, AVG(sales_month), SUM(sales_amount)
FROM sales_tbl
WHERE sales_amount > 100
GROUP BY test_fc_int(dept_no), test_fc_int(sales_month) WITH ROLLUP;

evaluate 'Test Case 6: Using HAVING clause with stored procedure';
SELECT dept_no, name, AVG(sales_amount)
FROM sales_tbl
WHERE sales_amount > 100
GROUP BY test_fc_int(dept_no), name WITH ROLLUP
HAVING AVG(sales_amount) > 100;

evaluate 'Cleanup';
DROP FUNCTION test_fc_int;
DROP FUNCTION test_fc_str;
DROP TABLE sales_tbl;
