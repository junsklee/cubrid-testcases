--+ server-message on
-- Verifies CBRD-25435
-- Extended test cases for varchar to time/timestamp conversions

evaluate 'Case 1: Default parameter with time conversion';
create or replace procedure test_time_default (
        a time := '12:32:46'
) as
begin
    DBMS_OUTPUT.put_line(a);
end;

call test_time_default();
call test_time_default('12:32:46');
call test_time_default('23:45:59');  -- Additional test: 24-hour time format
call test_time_default('00:00:00');  -- Edge case: Midnight in 24-hour format

evaluate 'Case 2: Time conversion with variable declaration';
create or replace procedure test_time_variable () as
    a time := '11:32:46';
begin
    DBMS_OUTPUT.put_line(a);
end;

call test_time_variable();

evaluate 'Case 3: Explicit parameterized timestamp conversion';
create or replace procedure test_timestamp_explicit (
        a timestamp := '07:28 pm 09-30'
) as
begin
    DBMS_OUTPUT.put_line(a);
end;

call test_timestamp_explicit('07:28 pm 09-30');
call test_timestamp_explicit('10:15 am 12-25');  -- Additional test: morning timestamp
call test_timestamp_explicit('11:59 pm 12-31');  -- Edge case: one minute before midnight

evaluate 'Case 4: Converting various AM/PM datetime formats';
create or replace procedure test_datetime_varied_formats as
    d datetime := datetime'12:00:00 AM 01/01/0001';
begin
    DBMS_OUTPUT.put_line(d);
end;

call test_datetime_varied_formats(); -- Default AM time on a specific date

evaluate 'Case 5: Midnight and noon edge cases';
create or replace procedure test_midnight_noon (
    d datetime := datetime'12:00:00 PM 01/01/2000'
) as
begin
    DBMS_OUTPUT.put_line(d);
end;

call test_midnight_noon();
call test_midnight_noon('12:00:00 AM 01/01/2000');  -- Midnight
call test_midnight_noon('12:00:00 PM 01/01/2000');  -- Noon

evaluate 'Case 6: Edge case with year extremes';
create or replace procedure test_year_edge as
    d datetime := datetime'12:30:00 AM 12/31/0001';
begin
    DBMS_OUTPUT.put_line(d);
end;

call test_year_edge();
call test_year_edge('11:59:59 PM 12/31/9999'); -- Edge case with far future date

evaluate 'Case 7: Mixed time formats without seconds';
create or replace procedure test_time_no_seconds (
        a time := '07:30 PM'
) as
begin
    DBMS_OUTPUT.put_line(a);
end;

call test_time_no_seconds('07:30 PM');  -- PM with no seconds
call test_time_no_seconds('11:15 AM');  -- AM with no seconds

evaluate 'Case 8: Invalid format handling';
create or replace procedure test_invalid_time () as
    a time := '25:61:61';  -- Invalid time format
begin
    DBMS_OUTPUT.put_line(a);
end;

-- Expected to fail due to invalid time format
call test_invalid_time();

evaluate 'Case 9: Handling of default timestamp with seconds and AM/PM';
create or replace procedure test_timestamp_seconds (
        a timestamp := '07:28:15 pm 09-30'
) as
begin
    DBMS_OUTPUT.put_line(a);
end;

call test_timestamp_seconds();
call test_timestamp_seconds('05:22:10 am 06-15'); -- Additional AM timestamp

evaluate 'Case 10: Extreme values for time';
create or replace procedure test_extreme_time () as
    a time := '23:59:59';  -- Maximum valid time in 24-hour format
begin
    DBMS_OUTPUT.put_line(a);
end;

call test_extreme_time();
call test_extreme_time('00:00:01'); -- Minimum valid time in 24-hour format

--+ server-message off
