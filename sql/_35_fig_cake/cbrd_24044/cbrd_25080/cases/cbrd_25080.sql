-- This test case verifies the following issue: CBRD-25080.
-- Ensure that the cardinality of a subquery from having a LIMIT clause
-- to outputting the value of the LIMIT clause. Also, when a LIMIT clause
-- exists, it follows a more rule-based optimization formula.
-- Lastly, ensure SSCAN_DEFULT_CARD is changed from 1000 to 100 (sscan limit)

-- Set the cardinality of the subquery having LIMIT clause to value of LIMIT clause.
DROP TABLE IF EXISTS t111;
CREATE TABLE t111 (
    col1 VARCHAR(20),
    col2 VARCHAR(20),
    col3 VARCHAR(20),
    col4 VARCHAR(20),
    col5 NUMERIC(20,10),
    col6 VARCHAR(20),
    col7 VARCHAR(20),
    col8 VARCHAR(20)
);

INSERT INTO t111 
SELECT rownum, 1, MOD(rownum,10), LPAD(TO_CHAR(MOD(rownum,100)),20,'0'), MOD(rownum,1000), LPAD(TO_CHAR(MOD(rownum,10000)),20,'0'), LPAD(TO_CHAR(MOD(rownum,100000)),20,'0'), LPAD(TO_CHAR(MOD(rownum,100000)),20,'0')
FROM db_class a, db_class b, db_class c, db_class d, db_class f, db_class g 
LIMIT 100000;

CREATE INDEX idx1 ON t111(col1,col3); 
CREATE INDEX idx3 ON t111(col3); 

SET OPTIMIZATION LEVEL 513;
UPDATE STATISTICS ON t111;

-- check card of node. 6000
SELECT /*+ recompile */ COUNT(*) 
FROM (
    SELECT /*+ no_merge */ *
    FROM t111
    WHERE col1 IS NOT NULL
    LIMIT 6000
) a
WHERE a.col2 = 1;
/*
    Join graph nodes:
    node[0]: a(6000/30) (sargs 0) (loc 0)
*/

-- check card of node. 120
SELECT /*+ recompile */ COUNT(*) 
FROM (
    SELECT /*+ no_merge */ *
    FROM t111
    WHERE col1 IS NOT NULL
    LIMIT 120 OFFSET 10000
) a
WHERE a.col2 = 1;
/*
    Join graph nodes:
    node[0]: a(120/1) (sargs 0) (loc 0)
*/
--If there is a LIMIT clause, it optimizes more rule-based.
--  If LIMIT exists, proceed with order by skip plan
--  otherwise, should proceed with index scan
SELECT /*+ recompile */ * 
FROM t111
WHERE col3 = '11' AND col1 IS NOT NULL
ORDER BY col1
LIMIT 10;
/*
Query plan:
    iscan
        class: t111 node[0]
        index: idx1
        filtr: term[0] AND term[1]
        sort:  1 asc
        cost:  513 card 9900
    */

-- no limit, index scan
SELECT /*+ recompile */ * 
FROM t111
WHERE col3 = '11' AND col1 IS NOT NULL
ORDER BY col1;
/*
    Query plan:
    temp(order by)
        subplan: iscan
                    class: t111 node[0]
                    index: idx3 term[0]
                    sargs: term[1]
                    cost:  137 card 9900
        sort:  1 asc
        cost:  217 card 9900
*/

-- return number of rows
SELECT /*+ recompile */ COUNT(*) 
FROM t111
WHERE col3 = '11' AND col1 IS NOT NULL
ORDER BY col1
LIMIT 10;
/*
    Query plan:
    iscan
        class: t111 node[0]
        index: idx3 term[0]
        sargs: term[1]
        cost:  137 card 9900
*/

#Cleanup
DROP TABLE t111;