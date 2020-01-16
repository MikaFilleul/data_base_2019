/*nombre d'activites des agendas par categorie et par utilisateur */

select u.login, ag.categorie, count(aa.id_ac)
from agenda ag
    inner join activite_agenda aa on ag.id_ag = aa.id_ag
    inner join activite_utilisateur au on aa.id_ac = au.id_ac
    inner join utilisateur u on u.id_ut = au.id_ut
group by u.login, ag.categorie;



/* Nombre d’évaluations totales pour les utilisateurs actifs (utilisateurs ayant édité un agenda au cours des trois derniers mois). */

select u.login, count(n.id_ac)
from utilisateur u
    join note_ac n on (n.id_ut) = u.id_ut
where add_months(date_note,3) >= sysdate
group by u.login;



/*Les agendas ayant eu au moins cinq évaluations et dont la note moyenne est inférieure à trois.*/


select n.id_ag, n.av, n.cnt from (select id_ag, avg(note) as av, count(id_ag) cnt from note_ag group by id_ag) n where n.av < 3 and n.cnt >= 5;

/*L’agenda ayant le plus grand nombre d’activités en moyenne par semaine.*/

select m.id_ag from (
    select ag.id_ag as id_ag,  count(ac.id_ac) / months_between( max(ac.date_fin), min(ac.date_debut)) as nb_ac_par_mois from activite ac
        join activite_agenda aa on aa.id_ac = ac.id_ac
        join agenda ag on ag.id_ag = aa.id_ag
    group by ag.id_ag) m
    join
    (select max(n.nb_ac_par_mois) max_date from (
    select ag.id_ag as id_ag, count(ac.id_ac) / months_between( max(ac.date_fin), min(ac.date_debut)) as nb_ac_par_mois from activite ac
        join activite_agenda aa on aa.id_ac = ac.id_ac
        join agenda ag on ag.id_ag = aa.id_ag
    group by ag.id_ag) n) o on o.max_date = m.nb_ac_par_mois;

/*  Pour chaque utilisateur, son login, son nom, son prénom, son adresse, son nombre d’agendas, son nombre d’activités et son nombre d’évaluation */

select test.id_ut, test.nom, test.prenom, test.login, test.adresse, test.nb_Activite, test.nb_Agenda, nac.nb_Note from (
    select u.id_ut as id_ut, u.login as login, u.nom as nom, u.prenom as prenom, u.adresse as adresse, count(ac.id_ac) as nb_Activite, count(ag.id_ag) as nb_Agenda
    from utilisateur u
        left join activite_utilisateur acu on acu.id_ut = u.id_ut
        left join activite ac on acu.id_ac = ac.id_ac
        left join agenda_utilisateur au on au.id_ut = u.id_ut
        left join agenda ag on ag.id_ag = au.id_ag
    group by u.id_ut, u.login, u.prenom, u.nom, u.adresse) test
join (
    select id_ut, count(id_ac) as nb_Note from note_ac GROUP BY id_ut
) nac on test.id_ut = nac.id_ut
order by (test.id_ut);


/*NN et 0N dans les relations */
