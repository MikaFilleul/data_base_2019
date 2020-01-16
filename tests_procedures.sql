set SERVEROUTPUT on;

/*Définir une fonction qui convertit au format csv
 (colonnes csv dans le même ordre que celles de la table) une activité d’un calendrier.
 Le résultat sera renvoyé sous la forme d’une chaîne de caractère*/
declare
returnvalue varchar(4000);
begin
    activite_csv(3, returnvalue);
    dbms_output.put_line(returnvalue);
end;
/


/*Définir une procédure qui permet de fusionner plusieurs agendas,
 c’est à dire à partir de N agendas, créer un nouvel agenda.*/
begin
    fusion_ag(ag_arr(2,4,5));
end;
/

/*
Définir une procédure qui créé une activité inférée à partir
d’agendas existants. Comme par exemple reporter au week-end
l’achat d’objets sortis aux cours de la semaine ou
reporter au soir le visionnage d’une émission sortie 
au cours de la journée.
*/
begin
report_activite(1, '19-10-2014 17:50:00', 4);
end; 
/

/*Définir une procédure qui archive les agendas dont toutes les dates sont passées.*/
begin 
    archive_agendas();
end;
/