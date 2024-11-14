--+ server-message on
-- Verifies CBRD-25273, CBRD-25303
-- Test cases for adddate() and addtime() 

--  CBRD-25273 (Should not return null erroneously)
evaluate 'Case 1: adddate() error input';

create or replace procedure add_date as
    a datetime := datetime'2013-10-09 01:02:03.456';
begin
    dbms_output.put_line(nvl(adddate(a, 1), 'null'));
end;

call add_date();


--  CBRD-25273 Call of ADDTIME() should not return 'Invalid XASL tree node content'
evaluate 'Case 2: addtime() error input';

create or replace procedure add_time() as
begin
    dbms_output.put_line(ADDTIME(TO_DATETIME('1999-01-08'), NULL));
    dbms_output.put_line(ADDTIME(TO_DATE('1999-01-08'), NULL));
    dbms_output.put_line(ADDTIME(TO_TIME('12:00:00'), NULL));
    dbms_output.put_line(ADDTIME(NULL, TO_TIME('02:30:52')));
    dbms_output.put_line(ADDTIME(TO_DATETIME('1999-01-08'), TO_TIME('02:30:52')));
    dbms_output.put_line(ADDTIME(TO_DATE('1999-01-08'), TO_TIME('02:30:52')));
    dbms_output.put_line(ADDTIME(TO_TIME('12:00:00'), TO_TIME('02:30:52')));
    dbms_output.put_line(ADDTIME(TIMESTAMP('1999-01-08 12:00:00'), TO_TIME('02:30:52')));
end;

call add_time();

drop procedure add_date;
drop procedure add_time;

--+ server-message off
