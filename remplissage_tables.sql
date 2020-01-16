begin
    bool_recursif.my_var := 0;
end;
/
/*insertion activites*/

insert into activite( titre, descriptif, date_debut, date_fin, pause, priorite, nb_occu, periodicite, inscription, commentaire) values (
    'piscine',
    'on enchaine les longueurs',
    '20-01-2019 17:50:00',
    '19-10-2019 18:50:00',
    0,
    1,
    5,
    'm',
    1,
    'ah zut il a oublie son maillot'
);
/

insert into activite( titre, descriptif, date_debut, date_fin, priorite, nb_occu, periodicite, inscription, commentaire) values (
    'revision',
    'champagne et python',
    '19-10-2014 17:50:00',
    '28-01-2020 18:50:00',
    3,
    2,
    'a',
    1,
    'quand est ce que ca s arrete - orelsan'
);
/

insert into activite(titre, descriptif, date_debut, date_fin, pause, priorite, nb_occu, periodicite, inscription) values (
    'zumba dab',
    'comme de la jumba mais tu dabs sur les haters',
    '17-06-2018 12:10:00',
    '17-06-2018 13:10:00',
    0,
    5,
    3,
    'h',
    1
)
/

insert into activite( titre, descriptif, date_debut, date_fin, pause, priorite, inscription, commentaire) values (
    'catch',
    'il saute de la 3eme corde!!',
    '20-02-2017 14:50:00',
    '20-02-2017 16:30:00',
    0,
    1,
    1,
    'c etait claque au sol'
);
/

insert into activite(titre, descriptif, date_debut, date_fin, pause, priorite, inscription) values (
    'revision studieuse et  enrichissante',
    'etre derriere un ordi pendant des heures',
    '17-06-2018 12:10:00',
    '16-07-2019 01:35:55',
    0,
    5,
    1
);
/

insert into activite( titre, descriptif, date_debut, date_fin, pause, priorite, inscription, commentaire) values (
    'projet jeux video',
    'ah bah ca bosse pepouze a la bu hein',
    '20-01-2019 17:50:00',
    '19-10-2019 18:50:00',
    0,
    1,
    1,
    'ea sport tsitsihinegaime'
);
/

/*insertion agenda*/

insert into agenda( titre, categorie, superposition, priorite) values (
    'agenda de adonis',
    'travail',
    1,
    5
);
/

insert into agenda( titre, categorie, superposition) values (
    'agenda de mika',
    'loisir',
    1
);
/

insert into agenda( titre, categorie, superposition) values (
    'agenda de toi plus moi',
    'sport',
    0
);
/

insert into agenda( titre, categorie, superposition) values (
    'agenda de tous ceux qui le veulent',
    'chanson',
    0
);
/


/*insertion utilisateurs*/
insert into utilisateur( nom, prenom, login, adresse, droit) values(
    'bob',
    'marley',
    'bob_marley',
    '420 rue du zion',
    1
);
/

insert into utilisateur( nom, prenom, login, adresse, droit) values(
    'bob',
    'dylan',
    'bob_dylan',
    '5 avenue des bobs',
    2
);
/

insert into utilisateur( nom, prenom, login, adresse, droit) values(
    'bob',
    'leponge',
    'bob_leponge',
    'l ananas au fond de l ocean',
    3
);
/

insert into utilisateur( nom, prenom, login, adresse, droit) values(
    'bob',
    'ross',
    'bob_ross',
    '42 impasse rougier et ple',
    3
);
/

insert into utilisateur( nom, prenom, login, adresse, droit) values(
    'bob',
    'lennon',
    'bob_lennon',
    '404 boulevard youtube',
    2
);
/

insert into utilisateur( nom, prenom, login, adresse, droit) values(
    'bob',
    'sinclar',
    'bob_sinclar',
    '3 rue du jaiplusdidee',
    1
);
/

/*liaison activite agenda*/
insert into activite_agenda (id_ac, id_ag) values (
    1,
    1
);
/

insert into activite_agenda (id_ac, id_ag) values (
    2,
    2
);

insert into activite_agenda (id_ac, id_ag) values (
    3,
    3
);

insert into activite_agenda (id_ac, id_ag) values (
    4,
    4
);

insert into activite_agenda (id_ac, id_ag) values (
    5,
    1
);

insert into activite_agenda (id_ac, id_ag) values (
    6,
    2
);

insert into activite_agenda (id_ac, id_ag) values (
    1,
    3
);

insert into activite_agenda (id_ac, id_ag) values (
    2,
    4
);
/

insert into activite_agenda (id_ac, id_ag) values (
    3,
    1
);
/

/*liaison activite utilisateurs*/

insert into activite_utilisateur(id_ac, id_ut) values (
    1,
    4
);
/

insert into activite_utilisateur(id_ac, id_ut) values (
    2,
    4
);
/

insert into activite_utilisateur(id_ac, id_ut) values (
    3,
    1
);
/

insert into activite_utilisateur(id_ac, id_ut) values (
    4,
    2
);
/

insert into activite_utilisateur(id_ac, id_ut) values (
    4,
    6
);
/

insert into activite_utilisateur(id_ac, id_ut) values (
    12,
    4
);
/

/*liaison agenda utilisateurs*/

insert into agenda_utilisateur(id_ag, id_ut) values (
    1,
    1
);
/

insert into agenda_utilisateur(id_ag, id_ut) values (
    10,
    2
);
/

insert into agenda_utilisateur(id_ag, id_ut) values (
    3,
    3
);
/

insert into agenda_utilisateur(id_ag, id_ut) values (
    4,
    3
);
/

insert into agenda_utilisateur(id_ag, id_ut) values (
    9,
    3
);
/

insert into agenda_utilisateur(id_ag, id_ut) values (
    2,
    3
);
/

/*note activites*/

insert into note_ac (id_ac, id_ut, date_note, note) values (
    1,
    1,
    '19-10-2020 07:50:00',
    0
);
/

insert into note_ac (id_ac, id_ut, date_note, note) values (
    2,
    2,
    '19-10-1999 15:30:00',
    0
);
/

insert into note_ac (id_ac, id_ut, date_note, note) values (
    3,
    3,
    '19-10-2019 18:50:00',
    1
);
/

insert into note_ac (id_ac, id_ut, date_note, note) values (
    3,
    4,
    '18-05-2019 17:50:00',
    2
);
/

insert into note_ac (id_ac, id_ut, date_note, note) values (
    4,
    5,
    '25-12-2019 05:50:00',
    1
);
/

insert into note_ac (id_ac, id_ut, date_note, note) values (
    5,
    6,
    '19-10-2020 07:50:00',
    4
);
/

insert into note_ac (id_ac, id_ut, date_note, note) values (
    3,
    3,
    '19-10-199 15:30:00',
    17
);
/

insert into note_ac (id_ac, id_ut, date_note, note) values (
    3,
    4,
    '19-10-2019 18:50:00',
    10
);
/

insert into note_ac (id_ac, id_ut, date_note, note) values (
    5,
    4,
    '18-05-2019 17:50:00',
    2
);
/

insert into note_ac (id_ac, id_ut, date_note, note) values (
    5,
    3,
    '25-12-2019 05:50:00',
    1
);
/


/*note agenda*/

insert into note_ag (id_ag, id_ut, date_note, note) values (
    1,
    6,
    '19-10-2019 12:50:00',
    15
);
/

insert into note_ag (id_ag, id_ut, date_note, note) values (
    1,
    5,
    '19-08-2019 07:50:00',
    12
);
/

insert into note_ag (id_ag, id_ut, date_note, note) values (
    1,
    4,
    '23-10-2019 17:50:00',
    04
);
/

insert into note_ag (id_ag, id_ut, date_note, note) values (
    2,
    6,
    '19-10-2019 20:20:00',
    04
);
/

insert into note_ag (id_ag, id_ut, date_note, note) values (
    2,
    1,
    '11-05-2019 05:28:00',
    01
);
/

insert into note_ag (id_ag, id_ut, date_note, note) values (
    2,
    3,
    '13-07-2019 18:20:00',
    0
);
/
