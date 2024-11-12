--+ server-message on
-- Verifies CBRD-25573
-- Checks SP call semantics considering default values ​​of SP arguments

evaluate 'Test Case 1: Default Parameter Handling in Simple SP Call';
create or replace procedure test_proc1(a int := 1)
as
begin
    dbms_output.put_line('proc1 param: ' || a);
end;

create or replace procedure test_proc2()
as
begin
    dbms_output.put_line('calling test_proc1 without parameters');
    test_proc1();  -- this should compile without errors
end;

-- Execute test_proc2 to verify default parameter handling
execute procedure test_proc2();


evaluate 'Test Case 2: Default Parameter with Explicit Argument';
create or replace procedure test_proc2()
as
begin
    dbms_output.put_line('calling test_proc1 with parameter 5');
    test_proc1(5);  -- explicitly passing 5 as argument
end;

-- Execute test_proc2 to verify explicit parameter handling
execute procedure test_proc2();

evaluate 'Test Case 3: Multiple Parameters with Some Defaulted';
create or replace procedure test_proc3(a int, b int := 10, c int := 20)
as
begin
    dbms_output.put_line('proc3 params: a=' || a || ', b=' || b || ', c=' || c);
end;

-- Call test_proc3 with only the non-defaulted argument
execute procedure test_proc3(1);  -- only 'a' is provided; 'b' and 'c' should use defaults


evaluate 'Test Case 4: Semantic Check Failure When Parameters Are Missing';
create or replace procedure test_proc4(a int, b int := 10)
as
begin
    dbms_output.put_line('proc4 params: a=' || a || ', b=' || b);
end;

-- Attempt to call test_proc4 without providing the required argument 'a'
execute procedure test_proc4();  -- should raise an error for missing 'a'


evaluate 'Test Case 5: Chained SP Calls with Default Parameter Propagation';
create or replace procedure test_proc5()
as
begin
    dbms_output.put_line('calling test_proc1 from test_proc5 without parameter');
    test_proc1();  -- should use default value of 'a'
end;

-- Execute test_proc5 to verify default propagation
execute procedure test_proc5();

evaluate 'Test END';
drop procedure test_proc1;
drop procedure test_proc2;
drop procedure test_proc3;
drop procedure test_proc4;
drop procedure test_proc5;

--+ server-message off
