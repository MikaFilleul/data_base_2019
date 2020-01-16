
/*
1.Un agenda comportera au maximum 50 activités par semaine.
*/
begin 
    for i in 1..51
    loop
        insert into activite_agenda values (2, 2);
    end loop;
end;
/

begin 
    for i in 1..30
    loop 
        insert into activite_agenda values (1, 3);

end ;

select * from activite_agenda;

/*
2. Les agendas et les activités supprimées seront 
archivés pour pouvoir être récupérés si nécessaire.
*/
delete from activite where id_ac = 1;
delete from agenda where id_ag = 1;

select * from activite;
select * from agenda;

/*
3. Le nombre d’activités présentes dans l’agenda et
la périodicité indiquée pour l’activité correspondent strictement.
*/

select ac_ag.id_ac, ac.id_ag, ac.date_debut, ac.date_fin, ac.nb_occu, ac.periodicite from activite_agenda ac_ag join
    activite ac on ac_ag.id_ac = ac.id_ac where id_ac = 3;


/*
4. Pour les agendas où la simultanéité d’activité n’est pas autorisée,
 interdire que deux activités aient une intersection non nulle de leur créneau.
 */

select id_ac, date_debut, date_fin from activite where id_ac in (2, 3);

insert into activite_agenda values (3, 2);
insert into activite_agenda values (3, 3);

 /*
 5. Afin de limiter le spam d'évaluation, 
un utilisateur enregistré depuis moins d'un semaine
ne pourra écrire une évaluation que toutes les 5 minutes.
*/

insert into utilisateur( nom, prenom, login, adresse, droit) values(
    'bob',
    'a fett',
    'boba_fett',
    '2 place de l etoile, dans une galaxie lointaine tres lointaine',
    1
);
/

declare
max_id_ut integer;
begin 
    select max(id_ut) into max_id_ut from utilisateur;

    insert into note_ac (id_ut, id_ac, date_note, note) values (
        max_id_ut,
        3,
        sysdate,
        15
    );

        insert into note_ac (id_ut, id_ac, date_note, note) values (
        max_id_ut,
        4,
        sysdate,
        12
    );
end;