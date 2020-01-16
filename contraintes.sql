/*
pour une raison que j'ignore il arrive parfois que les triggers fassent crasher sql developper :
ORA-00603
ORA-00600
ORA-00001
*/


begin
    bool_recursif.my_var := 0;
end;
/
/*quand on ajoute une activite avec plusieurs occurences := creere automatiquement les nouvelles activites*/
create or replace trigger nb_occu_ac
    before insert on activite
    for each row
declare
    nouv_date_debut_v timestamp;
    nouv_date_fin_v timestamp;
    nb_occu_v integer;
begin
    if bool_recursif.my_var = 0
    then 
        bool_recursif.my_var := 1;

        nb_occu_v := :new.nb_occu;
        nouv_date_debut_v := :new.date_debut;
        nouv_date_fin_v := :new.date_fin;

        if(nb_occu_v > 1)
        then 
            for i in 1.. nb_occu_v-1
            loop    
                if :new.periodicite = 'j'
                then 
                    nouv_date_debut_v := nouv_date_debut_v + 1;
                    nouv_date_fin_v := nouv_date_fin_v + 1;
                elsif :new.periodicite = 'h'
                then
                    nouv_date_debut_v := nouv_date_debut_v + 7;
                    nouv_date_fin_v := nouv_date_fin_v + 7;
                elsif :new.periodicite = 'm'
                then
                    nouv_date_debut_v := add_months(nouv_date_debut_v, 1);
                    nouv_date_fin_v := add_months(nouv_date_fin_v, 1);
                elsif :new.periodicite = 'a'
                then
                    nouv_date_debut_v := add_months(nouv_date_debut_v, 12);
                    nouv_date_fin_v := add_months(nouv_date_fin_v, 12);

                else 
                    raise_application_error(-20200, 'la periodicite n est pas bonne');
                end if;
                insert into activite (titre, descriptif, date_debut, date_fin, pause, priorite, nb_occu, periodicite, inscription, commentaire) values (
                    :new.titre,
                    :new.descriptif,
                    nouv_date_debut_v,
                    nouv_date_fin_v,
                    :new.pause,
                    :new.priorite,
                    :new.nb_occu,
                    :new.periodicite,
                    :new.inscription,
                    :new.commentaire
                );
            end loop;
        end if;
            bool_recursif.my_var := 0;
    end if;
end;
/


/*
1.Un agenda comportera au maximum 50 activités par semaine.
*/

create or replace trigger ag_max_cinquante
before insert or update on activite_agenda
for each row  
declare

    cursor c_activite_agenda is
    select ac_ag.id_ag, ac_ag.id_ac, ac.date_debut, ac.date_fin from activite_agenda ac_ag
    join activite ac on ac_ag.id_ac = ac.id_ac;

    debut_nouv_ac timestamp;
    fin_nouv_ac timestamp;
    cpt integer;

begin
    cpt := 0;

    select date_debut into debut_nouv_ac from activite where id_ac = :new.id_ac;
    select date_fin into fin_nouv_ac from activite where id_ac = :new.id_ac;

    for cur_ac_ag in c_activite_agenda
    loop
        if(cur_ac_ag.id_ag = :new.id_ag)
        then 
            if((cur_ac_ag.date_debut - 7) < debut_nouv_ac and (cur_ac_ag.date_debut + 7) > debut_nouv_ac)
            then 
                cpt := cpt +1 ;

            elsif ((cur_ac_ag.date_fin - 7) < debut_nouv_ac and (cur_ac_ag.date_fin + 7) > debut_nouv_ac)
            then 
                cpt := cpt +1 ;

            elsif ((cur_ac_ag.date_debut - 7) < fin_nouv_ac and (cur_ac_ag.date_debut + 7) > fin_nouv_ac)
            then 
                cpt := cpt +1 ;

            elsif ((cur_ac_ag.date_fin - 7) > fin_nouv_ac and (cur_ac_ag.date_fin + 7) > fin_nouv_ac)
            then 
                cpt := cpt +1 ;
            end if;

        end if;
    end loop;

    if(cpt >= 50)
    then 
        --souleverUneException
        raise_application_error(-20200, 'il y a trop d activites dans l agenda');
    end if;

end;
/

/*
2. Les agendas et les activités supprimées seront 
archivés pour pouvoir être récupérés si nécessaire.
*/

/*suppresion activites*/
create or replace trigger archivage_ac
    after delete on activite
    for each row
begin
    insert into activite_archive (id_ac, titre, descriptif, date_debut, date_fin, date_suppression, pause, priorite, inscription) values(
        :old.id_ac,
        :old.titre,
        :old.descriptif,
        :old.date_debut,
        :old.date_fin,
        sysdate,
        :old.pause,
        :old.priorite,
        :old.inscription
    );

end;
/


/*suppression agenda*/
create or replace trigger archivage_ag
    after delete on agenda
    for each row
begin
    insert into agenda_archive (id_ag, titre, categorie, superposition, date_suppression, priorite) values (
        :old.id_ag,
        :old.titre,
        :old.categorie,
        :old.superposition,
        sysdate,
        :old.priorite
    );
end;
/

/*archive le lien entre activite_agenda et activite_agenda_archive*/
create or replace trigger archivage_ac_ag
    after delete on activite_agenda
    for each row
declare
    cursor c_ac_ag_arc is 
    select * from activite_agenda_archive;

    bool integer;
begin
/*bool : teste si l'activite et l'agenda sont deja dans la table de liaison
faut tester si ca marche*/
    bool := 0;
    for cur_ac_ag in c_ac_ag_arc
    loop
        if(cur_ac_ag.id_ac = :old.id_ac and cur_ac_ag.id_ag = :old.id_ag)
        then
            bool := 1;
        end if;
    end loop;

    if(bool = 0)
    then
        insert into activite_agenda_archive(id_ac, id_ag) values(
            :old.id_ac,
            :old.id_ag
        );
    end if;
end;
/



/*
3. Le nombre d’activités présentes dans l’agenda et
la périodicité indiquée pour l’activité correspondent strictement.
*/

create or replace trigger periodicite
before insert or update on activite_agenda
for each row 
declare
    cursor ac_c is
        select * from activite;

    cursor ac_ag_c is
       select * from activite_agenda;
    
    cpt integer;
    cpt2 integer;
    descriptif_v varchar(120);
    titre_v varchar(60);
    tab_ac_v ac_arr := ac_arr();
    tab_ac_ag_v ac_arr := ac_arr();
    nb_occu_v integer;
begin
    if bool_recursif.my_var = 0
    then
        bool_recursif.my_var := 1;

        select descriptif into descriptif_v from activite where id_ac = :new.id_ac;
        select titre into titre_v from activite where id_ac = :new.id_ac;
        select nb_occu into nb_occu_v from activite where id_ac = :new.id_ac;

        cpt := 0;
        cpt2 := 0;

        for cur in ac_c
        loop
            if cur.titre = titre_v and cur.descriptif = descriptif_v and cur.id_ac != :new.id_ac
            then
                cpt := cpt + 1;
                tab_ac_v.extend(1);
                tab_ac_v(cpt) := cur.id_ac;
            end if;
        end loop;

        for cur in ac_ag_c 
        loop
            if cur.id_ag = :new.id_ag
            then 
                cpt2 := cpt2 + 1;
                tab_ac_ag_v.extend(1);
                tab_ac_ag_v(cpt2) := cur.id_ac;
            end if;
        end loop;


        for i in 1..tab_ac_v.count
        loop
            if not (tab_ac_v(i) member of tab_ac_ag_v)
            then
                insert into activite_agenda (id_ac, id_ag) values(
                    tab_ac_v(i),
                    :new.id_ag
                );
            end if;
        end loop;
        bool_recursif.my_var := 0;
    end if;
end;
/

create or replace sup_ac_periodicite
before delete on activite_agenda
for each row
declare
    cursor ac_c is
        select titre, descriptif, id_ac from activite;

    descriptif_v varchar(120);
    titre_v varchar(60);
    tab_ac_v ac_arr := ac_arr;
    cpt integer;
begin
    if bool_recursif.my_var = 0
    then
        bool_recursif.my_var := 1;
        select titre into titre_v from activite where id_ac = :new.id_ac;
        select descriptif into descriptif_v from activite where id_ac = :new.id_ac;
        
        for cur in ac_c
        loop
            if cur.titre = titre_v and cur.descriptif = cur.descriptif_v and cur.id_ac != :new.id_ac
            then
                delete from activite where id_ac = cur.id_ac;
            end if;
        end loop;
        bool_recursif.my_var := 0;
    end if;
end;
        




/*
4. Pour les agendas où la simultanéité d’activité n’est pas autorisée,
 interdire que deux activités aient une intersection non nulle de leur créneau.
 */

create or replace trigger simultaneite_ac
    before insert or update on activite_agenda
    for each row
declare
    cursor date_ac is
        select ag.id_ag, ac_ag.id_ac, ac.date_debut, ac.date_fin from agenda ag
        join activite_agenda ac_ag on ag.id_ag = ac_ag.id_ag
        join activite ac on ac.id_ac = ac_ag.id_ac; 

        superposition_bool integer;
        fin_ac timestamp;
        deb_ac timestamp;
begin
 
    select superposition into superposition_bool from agenda where id_ag = :new.id_ag;
    select date_fin into fin_ac from activite where id_ac = :new.id_ac;
    select date_debut into deb_ac from activite where id_ac = :new.id_ac;

    if(superposition_bool = 0)
    then
        for c_date in date_ac
        loop
            if((c_date.id_ag = :new.id_ag) and (c_date.id_ac != :new.id_ac))
            then 
                if not(deb_ac > c_date.date_fin or fin_ac < c_date.date_debut)
                then
                    raise_application_error(-20200, 'il y a plusieurs activites simultanement');
                end if;
            end if;
        end loop; 
    end if;      
end;
/

 /*
 5. Afin de limiter le spam d'évaluation, 
un utilisateur enregistré depuis moins d'un semaine
ne pourra écrire une évaluation que toutes les 5 minutes.
*/
/* note activites*/
create or replace trigger nouv_ut_restriction 
    before insert or update on note_ac
    for each row
declare 
    date_inscr timestamp;
    cursor c_note is
    select id_ut, date_note from note_ac;
begin 
    select date_inscription into date_inscr from utilisateur where id_ut = :new.id_ut;    
    if(date_inscr > (sysdate-7))
    then 
        for cur in c_note
        loop
            if(cur.id_ut = :new.id_ut and  cur.date_note > sysdate - 5/1440)
            then                  
                raise_application_error(-20200, 'l utilisateur doit attendre 5 min');
            end if;
        end loop;
    end if;
end;
/
        
/*note agenda*/
create or replace trigger nouv_ut_restriction_ag 
    before insert or update on note_ag
    for each row
declare 
    date_inscr timestamp;
    cursor c_note is
    select id_ut, date_note from note_ag;
begin 
    select date_inscription into date_inscr from utilisateur where id_ut = :new.id_ut;    
    if(date_inscr > (sysdate-7))
    then 
        for cur in c_note
        loop
            if(cur.id_ut = :new.id_ut and  cur.date_note > sysdate - 5/1440)
            then                  
                raise_application_error(-20200, 'l utilisateur doit attendre 5 min');
            end if;
        end loop;
    end if;
end;
/