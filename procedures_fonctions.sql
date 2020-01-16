/*Définir une fonction qui convertit au format csv
 (colonnes csv dans le même ordre que celles de la table) une activité d’un calendrier.
 Le résultat sera renvoyé sous la forme d’une chaîne de caractère*/

/*pb privilege*/
/*create or replace directory extract_dir as '/temp/';
grant read, write on directory extract_dir to public;
grant execute on utl_file to public;*/
create or replace procedure activite_csv (arg_id_ac in integer,  v_string out varchar2) as 
    cursor c_donnee is 
    select * from activite where id_ac = arg_id_ac;

  /*  v_fic utl_file.file_type;   */
begin
    /*v_fic := utl_file.fopen('extract_dir', 'activite.txt', 'W');*/

    v_string := 'id_ac, titre   , descriptif,   date_debut,     date_fin,   pause,  priorite,   inscription,    commentaire';
    /*utl_file.put_line(v_fic, v_string);*/

    for cur in c_donnee
    loop
        v_string :=
            cur.id_ac
            || ','
            || cur.titre
            ||','
            || cur.descriptif
            ||','
            ||cur.date_debut
            ||','
            ||cur.date_fin
            ||','
            ||cur.pause
            ||','
            ||cur.priorite
            ||','
            ||cur.inscription
            ||','
            ||cur.commentaire;
    end loop;   
   
    dbms_output.put_line(v_string);
    /*utl_file.put_line(v_fic, v_string);
    
    utl_file.fclose(v_fic);*/
end;
/
  
/*Définir une procédure qui permet de fusionner plusieurs agendas,
 c’est à dire à partir de N agendas, créer un nouvel agenda.*/
create or replace procedure fusion_ag (arg_id_ag in ag_arr) as           
    cursor c_ac_fusion is                                            
    select id_ac, id_ag from activite_agenda;
    
    cursor titre is select titre, id_ag from agenda;

    id_ag_v integer;
    nouv_titre varchar(60); /* nouv titre = concatenation autre titres*/
begin
    nouv_titre := 'fusion';

    for cur_t in titre
    loop
        for i in 1..arg_id_ag.count
        loop
            if(arg_id_ag(i) = cur_t.id_ag)
            then
                nouv_titre := nouv_titre || '_' || cur_t.id_ag;
            end if;
        end loop;
    end loop; 
    
    insert into agenda( titre, categorie, superposition, priorite) values (
        nouv_titre,
        'autre',
        0,
        5
    );

    select max(id_ag) into id_ag_v from agenda;

    for cur in c_ac_fusion
    loop
        for i in 1..arg_id_ag.count
        loop
        if(cur.id_ag = arg_id_ag(i))
        then
            insert into activite_agenda (id_ac, id_ag) values (
                cur.id_ac,
                id_ag_v
            );
        end if;
        end loop; 

    end loop;

end;

/*
Définir une procédure qui créé une activité inférée à partir
d’agendas existants. Comme par exemple reporter au week-end
l’achat d’objets sortis aux cours de la semaine ou
reporter au soir le visionnage d’une émission sortie 
au cours de la journée.
*/
create or replace procedure report_activite (arg_id_ac integer , arg_nouv_date timestamp, arg_id_ag integer)as
    cursor ac_c is  
    select * from activite where id_ac = arg_id_ac;
    nouv_date_fin timestamp;
    nouv_titre varchar2(300);
    nouv_id_ac integer;
begin
    for cur in ac_c
    loop

        nouv_date_fin := arg_nouv_date + (cur.date_fin -   cur.date_debut);
        nouv_titre := cur.titre || '_report';

        insert into activite( titre, descriptif, date_debut,    date_fin, pause, priorite, inscription, commentaire)   values (
            nouv_titre,
            cur.descriptif,
            arg_nouv_date,
            nouv_date_fin,
            cur.pause,
            cur.priorite,
            cur.inscription,
            cur.commentaire
        );
    end loop;

    select max(id_ac) into nouv_id_ac from activite;
    insert into activite_agenda(id_ac, id_ag) values(
        nouv_id_ac,
        arg_id_ag
    );

    
end;
/

/*Définir une procédure qui archive les agendas dont toutes les dates sont passées.*/
create or replace procedure archive_agendas as
    cursor ag_c is 
    select ag.id_ag, ag.titre, ag.categorie, ag.superposition, ag.priorite from agenda ag 
        join activite_agenda ac_ag on  ac_ag.id_ag = ag.id_ag
        join activite ac on ac_ag.id_ac = ac.id_ac
        group by ag.id_ag, ag.titre, ag.categorie, ag.superposition, ag.priorite
    having max(ac.date_fin) < sysdate;

    cursor ac_ag_c is
    select * from activite_agenda;

    type cur1 is ref cursor;
    ac_c cur1;

begin
    /*comme la suppression de l'agenda a lieu apres qu'il est ete archive, il y a un probleme
    avec le trigger d'archivage car les id sont uniques. Le trigger est donc arrete le temps de
    la procedure*/
    EXECUTE Immediate 'alter trigger archivage_ag disable';
    for cur_ag in ag_c
    loop
        insert into agenda_archive (id_ag, titre, categorie, superposition, priorite) values(
            cur_ag.id_ag,
            cur_ag.titre,
            cur_ag.categorie,
            cur_ag.superposition,
            cur_ag.priorite
        );


        for cur_ac_ag in ac_ag_c
        loop
            if (cur_ac_ag.id_ag = cur_ag.id_ag) then
                insert into activite_agenda_archive (id_ac, id_ag) values(
                    cur_ac_ag.id_ac,
                    cur_ac_ag.id_ag
                );
            end if;
        end loop;
         
        delete from agenda where id_ag = cur_ag.id_ag;

    end loop;
    EXECUTE Immediate 'alter trigger archivage_ag enable';

end;
/