--+ holdcas on;
---- ALTER TABLE ...  CHANGE COLUMN  , type change : INT to CHAR
-- constraints : no constraints
-- ordering : no order defined
-- name : same name or changed

set system parameters 'allow_truncated_string=yes';
set system parameters 'alter_table_change_type_strict=yes';
set system parameters 'error_log_level=warning';
set system parameters 'error_log_warning=yes';


-------------- INT 1 : to VARCHAR , enough precision
create table t1 (i1 int);
insert into t1 values (1),(-2147483648),(2147483647);

-- should fail (range)
insert into t1 values (2147483648);

select * from t1 order by 1;
show columns in t1;

alter table t1 change i1 s1 varchar(11);
-- should be ok 
insert into t1 values ('-9999999999');

insert into t1 values ('abcdef');
select * from t1  order by 1;
show columns in t1;

drop table t1;

-------------- INT 2 : to CHAR , enough precision, unique
create table t1 (i1 int unique);
insert into t1 values (1),(-2147483648),(2147483647);

-- should fail (range)
insert into t1 values (2147483648);
-- should fail (unique)
insert into t1 values (1);

select * from t1 order by 1;
show columns in t1;

alter table t1 change i1 s1 varchar(11) unique;
-- should be ok 
insert into t1 values ('32768');

insert into t1 values ('abcdef');
-- should fail (unique)
insert into t1 values ('abcdef');

select * from t1  order by 1;
show columns in t1;

drop table t1;


-------------- INT 3 : to CHAR , not enough precision
create table t1 (i1 int);
insert into t1 values (1),(-2147483648),(2147483647);

-- should fail (range)
insert into t1 values (2147483648);

select * from t1 order by 1;
show columns in t1;

-- should fail
alter table t1 change i1 s1 varchar(10);
-- should fail
insert into t1 values ('a12345');

select * from t1  order by 1;
show columns in t1;

drop table t1;


-------------- INT 4 : to VARCHAR , precision not specified
create table t1 (i1 int);
insert into t1 values (1),(-2147483648),(2147483647);

-- should fail (range)
insert into t1 values (2147483648);

select * from t1 order by 1;
show columns in t1;

alter table t1 change i1 s1 varchar;
-- should be ok 
insert into t1 values ('-99999');

insert into t1 values ('12345678901234567890');
select * from t1  order by 1;
show columns in t1;

drop table t1;


-------------- INT 1 : to VARNCHAR , enough precision
create table t1 (i1 int);
insert into t1 values (1),(-2147483648),(2147483647);

-- should fail (range)
insert into t1 values (2147483648);

select * from t1 order by 1;
show columns in t1;

alter table t1 change i1 s1 nchar varying(11);
-- should be ok 
insert into t1 values (n'-9999999999');

insert into t1 values (n'abcdef');
select * from t1  order by 1;
show columns in t1;

drop table t1;

-------------- INT 2 : to VARNCHAR , enough precision, unique
create table t1 (i1 int unique);
insert into t1 values (1),(-2147483648),(2147483647);

-- should fail (range)
insert into t1 values (2147483648);
-- should fail (unique)
insert into t1 values (1);

select * from t1 order by 1;
show columns in t1;

alter table t1 change i1 s1 nchar varying(11) unique;
-- should be ok 
insert into t1 values (n'2147483648');

insert into t1 values (n'abcdef');
-- should fail (unique)
insert into t1 values (n'abcdef');

select * from t1  order by 1;
show columns in t1;

drop table t1;


-------------- INT 3 : to VARNCHAR , not enough precision
create table t1 (i1 int);
insert into t1 values (1),(-2147483648),(2147483647);

-- should fail (range)
insert into t1 values (2147483648);

select * from t1 order by 1;
show columns in t1;

-- should fail
alter table t1 change i1 s1 nchar varying(10);
-- should fail
insert into t1 values (n'12345');

select * from t1  order by 1;
show columns in t1;

drop table t1;


-------------- INT 4 : to VARNCHAR , precision not specified
create table t1 (i1 int);
insert into t1 values (1),(-2147483648),(2147483647);

-- should fail (range)
insert into t1 values (2147483648);

select * from t1 order by 1;
show columns in t1;

alter table t1 change i1 s1 nchar varying;
-- should be ok 
insert into t1 values (n'-9999999999');

insert into t1 values (n'12345678901234567890');
select * from t1  order by 1;
show columns in t1;

drop table t1;




set system parameters 'allow_truncated_string=no';
set system parameters 'alter_table_change_type_strict=yes';
commit;
--+ holdcas off;
