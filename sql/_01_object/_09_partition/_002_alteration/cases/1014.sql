--test deleting one partition(char type) using ALTER TABLE command.
create table list_test(id int ,
			test_int int,
			test_char char(50),
			test_varchar varchar(2000),
			test_datetime timestamp, primary key(id, test_char))
PARTITION BY LIST (test_char) (
    PARTITION p0 VALUES IN ('aaa','bbb','ccc','ddd'),
    PARTITION p1 VALUES IN ('eee','fff','ggg','hhh',null),
    PARTITION p2 VALUES IN ('iii','jjj')
    
);

insert into list_test values (1,1,'aaa','aaa','2000-01-01 09:00:00');
insert into list_test values (2,2,'bbb','bbb','2000-01-02 09:00:00');
insert into list_test values (3,3,'ccc','ccc','2000-01-03 09:00:00');
insert into list_test values (4,11,'ddd','ddd','2000-02-01 09:00:00');
insert into list_test values (5,12,'eee','eee','2000-02-02 09:00:00');
insert into list_test values (6,13,'fff','fff','2000-02-03 09:00:00');
insert into list_test values (7,21,'ggg','ggg','2000-03-01 09:00:00');
insert into list_test values (8,22,'hhh','hhh','2000-03-02 09:00:00');
insert into list_test values (9,23,'iii','iii','2000-03-03 09:00:00');
insert into list_test values (10,31,'jjj','jjj','2000-04-01 09:00:00');



ALTER TABLE list_test drop partition p1;

select * from db_partition where class_name = 'list_test' order by partition_name;

select * from list_test order by 1;
select * from list_test__p__p0 order by 1;
select * from list_test__p__p2 order by 1;

drop table list_test;
