--+ server-message on

-- normal: basic usage of a builtin function call

create or replace procedure t () as
begin
    dbms_output.put_line(TO_DATETIME(NULL, 'MM/DD/YYYY'));
    dbms_output.put_line(TO_DATETIME('01/11/1999', NULL));

    dbms_output.put_line('-- TO_DATETIME(date input)');
    dbms_output.put_line(TO_DATETIME('01/11/1999', 'MM/DD/YYYY'));
    dbms_output.put_line(TO_DATETIME('1/11/99', 'MM/DD/YYYY'));
    dbms_output.put_line(TO_DATETIME('1999-01-11', 'YYYY-MM-DD'));
    dbms_output.put_line(TO_DATETIME('99-1-11', 'YYYY-MM-DD'));
    dbms_output.put_line(TO_DATETIME('1999-1-11', 'YYYY-MM-DD'));
    dbms_output.put_line(TO_DATETIME('19990111', 'YYYYMMDD'));

    dbms_output.put_line('-- TO_DATETIME(date with time input)');
    dbms_output.put_line(TO_DATETIME('01/11/1999 184153.733', 'MM/DD/YYYY HH24MISS.FF'));
    dbms_output.put_line(TO_DATETIME('01/11/1999 18:41:53.733', 'MM/DD/YYYY HH24:MI:SS.FF'));
    dbms_output.put_line(TO_DATETIME('1/11/1999 18:41:53.733', 'MM/DD/YYYY HH24:MI:SS.FF'));
    dbms_output.put_line(TO_DATETIME('01/11/1999 6:41:53.733 PM', 'MM/DD/YYYY HH12:MI:SS.FF PM'));
    dbms_output.put_line(TO_DATETIME('1/11/1999 6:41:53.733', 'MM/DD/YYYY HH:MI:SS.FF'));
    dbms_output.put_line(TO_DATETIME('1/11/99 6:41:53.733', 'MM/DD/YY HH:MI:SS.FF'));

    dbms_output.put_line('-- TO_DATETIME(extra)');
    dbms_output.put_line(TO_DATETIME('DATE: 12-25-2008 TIME: 13:10:30.999', '"DATE:" MM-DD-YYYY "TIME:" HH24:MI:SS.FF'));
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t();


-- CBRD-25302: TO_DATETIME 3rd arg parse error
create or replace procedure t () as
begin
    dbms_output.put_line('-- TO_DATETIME(2 arguments): intl_date_lang=en_US');
    dbms_output.put_line(TO_DATETIME('01/11/1999 6:41:53.733', 'MM/DD/YYYY HH:MI:SS.FF'));
    dbms_output.put_line('-- TO_DATETIME(3 arguments): intl_date_lang=en_US');
    dbms_output.put_line(TO_DATETIME('01/11/1999 6:41:53.733', 'MM/DD/YYYY HH:MI:SS.FF', 'en_US'));
    dbms_output.put_line(TO_DATETIME('01/11/1999 6:41:53.733', 'MM/DD/YYYY HH:MI:SS.FF', 'ko_KR'));
end;

call t();


set system parameters 'intl_date_lang=ko_KR';

create or replace procedure t () as
begin
    dbms_output.put_line('-- TO_DATETIME(2 arguments): intl_date_lang=ko_KR');
    dbms_output.put_line(TO_DATETIME('01/11/1999 6:41:53.733', 'MM/DD/YYYY HH:MI:SS.FF'));
    dbms_output.put_line('-- TO_DATETIME(3 arguments): intl_date_lang=ko_KR');
    dbms_output.put_line(TO_DATETIME('01/11/1999 6:41:53.733', 'MM/DD/YYYY HH:MI:SS.FF', 'en_US'));
    dbms_output.put_line(TO_DATETIME('01/11/1999 6:41:53.733', 'MM/DD/YYYY HH:MI:SS.FF', 'ko_KR'));
end;

call t();

set system parameters 'intl_date_lang=en_US';

drop procedure t;

-- CBRD-25302
prepare st from 'select to_datetime(?, ?, ?) from dual';
execute st using '01/11/1999 6:41:53.733', 'MM/DD/YYYY HH:MI:SS.FF', 'en_US';
drop prepare st;

--+ server-message off
