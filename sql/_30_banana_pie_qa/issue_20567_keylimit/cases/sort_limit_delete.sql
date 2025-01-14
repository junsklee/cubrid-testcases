drop if exists u,t;
CREATE TABLE t(i int PRIMARY KEY, j int, k int);
CREATE TABLE u(i int, j int, k int);
ALTER TABLE u ADD constraint fk_t_u_i FOREIGN KEY(i) REFERENCES t(i);
CREATE INDEX i_u_j ON u(j);
INSERT INTO t SELECT ROWNUM, ROWNUM, ROWNUM FROM db_root connect by level<=100;
INSERT INTO u SELECT 1+(ROWNUM % 100), ROWNUM, ROWNUM FROM db_root connect by level<=100;
delete  FROM u  WHERE  u.j > 10 using index i_u_j keyLIMIT 5;
select * from u WHERE  u.j > 10 order by 1,2,3 limit 10;
prepare stmt from 'delete  FROM u  WHERE  u.j > 10 using index i_u_j keyLIMIT ?-?,?/?;';
execute stmt using 2,1,10,2;
select * from u WHERE  u.j > 10 order by 1,2,3 limit 10;
deallocate prepare stmt;
prepare stmt from 'delete  FROM u  WHERE  u.j > 10 using index i_u_j keyLIMIT ?-?,?*?;';
execute stmt using 2,1,5,1;
select * from u WHERE  u.j > 10 order by 1,2,3 limit 10;
deallocate prepare stmt;
prepare stmt from 'delete  FROM u  WHERE  u.j > 10 using index i_u_j keyLIMIT ?+?,?*?;';
execute stmt using 2,1,5,1;
select * from u WHERE  u.j > 10 order by 1,2,3 limit 10;
deallocate prepare stmt;
delete  FROM u  WHERE  u.j > 10 using index i_u_j keyLIMIT 0, 5;
delete  FROM u  WHERE  u.j > 10 using index i_u_j keyLIMIT 2-2,5;
delete  FROM u  WHERE  u.j > 10 using index i_u_j keyLIMIT 2-1,5*1;
delete  FROM u  WHERE  u.j > 10 using index i_u_j keyLIMIT 2-1,10/2;
delete  FROM u  WHERE  u.j > 10 using index i_u_j keyLIMIT 5;
delete  FROM u  WHERE  u.j > 10 using index i_u_j keyLIMIT 0, 5;
delete  FROM u  WHERE  u.j > 10 using index i_u_j keyLIMIT 2-2,5;
delete  FROM u  WHERE  u.j > 10 using index i_u_j keyLIMIT 2-1,5*1;
delete  FROM u  WHERE  u.j > 10 using index i_u_j keyLIMIT 2-1,10/2;
delete  FROM u  WHERE  u.j > 10 using index i_u_j keyLIMIT 2-1,10/2;
select count(*) from u;
drop if exists u,t;
