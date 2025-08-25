#!/bin/sh
. $init_path/init.sh
init test

dbname=cbrd_26165
cubrid deletedb $dbname

cubrid_createdb -r $dbname --db-volume-size=20M --log-volume-size=20M
cubrid server start $dbname
cubrid broker start

csql -u dba $dbname -i test_commit.sql > output.log 2>&1
format_csql_output output.log
compare_result_between_files output.log test_commit.answer

cubrid service stop $dbname
cubrid deletedb $dbname

rm -rf $dbname
rm -rf *.log

finish
