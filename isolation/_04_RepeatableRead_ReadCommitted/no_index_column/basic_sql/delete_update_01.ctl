/*
Test Case: delete & update
Priority: 1
Reference case:
Author: Ray

Test Plan: 
Test DELETE/UPDATE locks (X_LOCK on instance) if the instances of the transactions are not overlapped

Test Scenario:
C1 delete, C2 update, the affected rows are not overlapped
C1 commit, C2 commit
Metrics: data size = small, where clause = simple, schema = single table

Test Point:
1) C1 and C2 will not be waiting 
2) C1 instances should be deleted, C2 instances should be update

NUM_CLIENTS = 3
C1: delete from table t1;   
C2: update table t1;
C3: select on table t1; C3 is used to check the updated result
*/

MC: setup NUM_CLIENTS = 3;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS t1;
C1: CREATE TABLE t1(id INT, col VARCHAR(10));
C1: INSERT INTO t1 VALUES(1,'abc');INSERT INTO t1 VALUES(2,'def');INSERT INTO t1 VALUES(3,'ghi');INSERT INTO t1 VALUES(4,'jkl');INSERT INTO t1 VALUES(5,'mno');INSERT INTO t1 VALUES(6,'pqr');INSERT INTO t1 VALUES(7,'abc');
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM t1 WHERE id > 5; 
MC: wait until C1 ready;

C2: UPDATE t1 SET col = 'abcd' WHERE col = 'def' or col = 'ghi';
/* expect: no transactions need to wait */
MC: wait until C2 ready;
/* expect: C1 select - id = 6,7 are deleted */
C1: SELECT * FROM t1 order by 1,2;
MC: wait until C1 ready;

/* expect: C2 select - id = 2,3 are updated */
C2: SELECT * FROM t1 order by 1,2;
MC: wait until C2 ready;

C1: commit;
MC: wait until C1 ready;

C2: commit;
MC: wait until C2 ready;

/* expect: the instances of id = 6,7 are deleted & id = 2,3 are updated */
C3: select * from t1 order by 1,2;
MC: wait until C3 ready;


C3: commit;
C1: quit;
C2: quit;
C3: quit;
