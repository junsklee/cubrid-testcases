--create range partition table with time data type and three partitions having maxvalue,then insert data to this table,the inserted separator field values contain null value

create table range_test(id int not null ,	
				   test_time time,
				   test_date date,
				   test_timestamp timestamp,
                                   primary key (id, test_time))
		PARTITION BY RANGE (test_time) (
		PARTITION p0 VALUES LESS THAN ('09:00:00'),
		PARTITION p1 VALUES LESS THAN ('10:00:00'),
		PARTITION p2 VALUES LESS THAN MAXVALUE
	);
	insert into range_test values(1,'08:10:00','2006-01-01','2006-01-01 08:10:00');
	insert into range_test values(2,'08:20:00','2006-01-11','2006-01-11 08:20:00');
	insert into range_test values(3,'09:10:00','2006-02-01','2006-02-01 09:10:00');
	insert into range_test values(4,'09:20:00','2006-02-11','2006-02-11 09:20:00');
	insert into range_test values(5,'09:30:00','2006-02-21','2006-02-21 09:30:00');
	insert into range_test values(6,'10:10:00','2006-03-01','2006-03-01 09:40:00');
	insert into range_test values(7,'10:20:00','2006-03-11','2006-03-11 09:50:00');

	insert into range_test values(8,NULL,'2006-04-01','2006-04-01 10:00:00');


select * from range_test order by 1;


drop table range_test;
