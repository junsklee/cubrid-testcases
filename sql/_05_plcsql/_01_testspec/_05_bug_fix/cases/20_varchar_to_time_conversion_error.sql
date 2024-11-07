--+ server-message on
-- Verifies CBRD-25435
-- bug fix: error no longer occurs when converting varchar to time/timestamp on pl/csql



evaluate 'Case 1: Converting varchar to time on pl/csql';
-- default parameter
create or replace procedure test_time1 (
        a time := '12:32:46'
) as
begin
    DBMS_OUTPUT.put_line(a);
end;

create or replace procedure test_time2 (
        a time := '11:32:46'
) as
begin
    DBMS_OUTPUT.put_line(a);
end;

-- variable call
create or replace procedure test_time3 () as
    a time := '12:32:46';
begin
    DBMS_OUTPUT.put_line(a);
end;

call test_time1();
call test_time1('12:32:46');
call test_time2();
call test_time2('11:32:46');
call test_time3();


evaluate 'Case 2: Converting varchar to timestamp on pl/csql';
create or replace procedure test_timestamp (
        a timestamp := '07:28 pm 09-30'
) as
begin
    DBMS_OUTPUT.put_line(a);
end;

call test_timestamp('07:28 pm 09-30');
call test_timestamp();


evaluate 'Case 3: Converting varchar to timestamp on pl/csql';
create or replace procedure test_12_am as
    d datetime := datetime'12:00:00 AM 12/30/0001';
begin
    dbms_output.put_line(d);
end;

create or replace procedure test_12_pm as
    d datetime := datetime'12:00:00 PM 12/30/0001';
begin
    dbms_output.put_line(d);
end;

call test_12_am('12:00:00 AM 12/30/0001');
call test_12_am();

call test_12_pm('12:00:00 PM 12/30/0001');
call test_12_pm();

--+ server-message off
