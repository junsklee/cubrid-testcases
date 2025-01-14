--+ holdcas on;
--test interpreter variable many select queries and into clause.
set system parameters 'create_table_reuseoid=no';

create class DML_0001
( 	int_col int not null,
var_col varchar(20),
set_col set (int,varchar(20)));

create class DML_0002 	
(	int_col int not null,
var_col varchar(20),
set_col set (int, varchar(20)),
ref_col DML_0001,
set_ref_col set of DML_0001);

create class DML_0003 under DML_0001
( 	int_col1 int not null);
insert into DML_0001 values (1,'test1', {1,'test1'});
insert into DML_0001 values (2,'test1', {1,'test1'});
insert into DML_0001 values (3,'test2', {1,'test2'});
insert into DML_0001 values (4,'test1', {2,'test1'});
insert into DML_0001 values (5,'test2', {2,'test2'});

select DML_0001 into a from DML_0001 where int_col = 1;
insert into DML_0002 values (1, 'test1', {1,'test1'}, a , {a});
select DML_0001 into :a from DML_0001 where int_col = 1;
insert into DML_0002 values (1, 'test1', {1,'test1'}, :a , {:a});
select DML_0001 into :a from DML_0001 where int_col = 1;
insert into DML_0002 values (1, 'test1', {1,'test1'}, a , {a});
select int_col,var_col,DML_0001 into a,b,c from DML_0001 where int_col = 1;
insert into DML_0002 values (1, 'test1', {a,b}, c , {c});



drop class DML_0001;
drop class DML_0002, DML_0003;
drop variable a;

set system parameters 'create_table_reuseoid=yes';
--+ holdcas off;
