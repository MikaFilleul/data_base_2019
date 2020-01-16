create sequence ac_id_new start with 1;
create sequence ag_id_new start with 1;
create sequence ut_id_new start with 1;
/

create or replace type ac_arr
    is table of number;
/

create  or replace type ag_arr
    is table of number;
/

create  or replace package bool_recursif is 
    my_var number;
end;
/

begin
    bool_recursif.my_var := 0;
end;
/