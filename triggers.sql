/*auto incrermentation*/
create or replace trigger ac
before insert on activite
for each row
begin
select ac_id_new.nextval
into :new.id_ac
from dual;
end;
/

create or replace trigger ag
before insert on agenda
for each row
begin
select ag_id_new.nextval
into :new.id_ag
from dual;
end;
/

create or replace trigger ut
before insert on utilisateur
for each row
begin
select ut_id_new.nextval
into :new.id_ut
from dual;
end;
/

