--+ server-message on

-- normal: basic usage of a builtin function call

create or replace procedure t () as
begin
    dbms_output.put_line(MID(NULL, 6, 0));
    dbms_output.put_line(MID('12345abcdeabcde', 6, 0));
    dbms_output.put_line(MID('12345abcdeabcde', 0, 4));
    dbms_output.put_line(MID('12345abcdeabcde', 6, 4));
    dbms_output.put_line(MID('12345abcdeabcde', -6, 4));
    dbms_output.put_line(MID('12345abcdeabcde', 6, -4));
    dbms_output.put_line(MID('12345abcdeabcde', NULL, -4.0));
    dbms_output.put_line(MID('12345abcdeabcde', -6.0, NULL));
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off
