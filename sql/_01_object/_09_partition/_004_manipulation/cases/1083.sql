--test update(date) for list partition(have NULL value) with correct values within range
create table list_test(id int,	
				test_time time,
				test_date date,
				test_timestamp timestamp, primary key(id,test_date))
		PARTITION BY LIST (test_date) (
		PARTITION p0 VALUES IN ('2006-01-01',NULL,'2006-02-01','2006-03-01')
	);

	insert into list_test values(1,'06:00:00','2006-01-01','2006-01-01 09:00:00');
	insert into list_test values(2,'07:00:00','2006-02-01','2006-02-01 09:00:00');
	insert into list_test values(3,'09:00:00','2006-03-01','2006-03-01 09:00:00');
	insert into list_test values(4,'06:00:00','2006-01-01','2006-01-01 09:00:00');
	insert into list_test values(5,'07:00:00','2006-02-01','2006-02-01 09:00:00');
	insert into list_test values(6,'09:00:00','2006-03-01','2006-03-01 09:00:00');
	insert into list_test values(7,NULL,NULL,NULL);
update list_test set test_date      = '2006-02-01' where test_date      = '2006-03-01';

select * from list_test order by id;


drop table list_test;
