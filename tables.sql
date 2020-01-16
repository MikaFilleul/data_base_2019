create table activite
(   id_ac integer not null,
    titre varchar(60) not null,
    descriptif varchar(140) not null,
    date_debut timestamp not null,
    date_fin timestamp not null,
    pause integer, /* 0 faux, sinon vrai*/
    priorite integer,
    nb_occu integer default 1, /*nombre de fois que cette activite a lieu*/
    periodicite varchar(1) default 'j', /*j : journalier, h : hebdomadaire, m : mensuel, a : annuel*/
    inscription integer, /* 0 faux, sinon vrai*/
    commentaire varchar(140),
    Primary key(id_ac)
);

create table activite_archive
(
    id_ac integer not null,
    titre varchar(60) not null,
    descriptif varchar(140),
    date_debut timestamp not null,
    date_fin timestamp,
    date_suppression timestamp,
    pause integer, /* 0 faux, sinon vrai*/
    priorite integer,
    nb_occu integer, /*nombre de fois que cette activite a lieu*/
    periodicite varchar(1), /*j : journalier, h : hebdomadaire, m : mensuel, a : annuel*/
    inscription integer, /* 0 faux, sinon vrai*/
    Primary key(id_ac)
);

create table agenda
(
    id_ag integer not null,
    titre varchar(60) not null,
    categorie varchar(60) not null,
    superposition integer, /* 0 faux, sinon vrai*/
    priorite integer,
    Primary key(id_ag)
);

create table agenda_archive(
    id_ag integer not null,
    titre varchar(60) not null,
    categorie varchar(60) not null,
    superposition integer, /* 0 faux, sinon vrai*/
    date_suppression timestamp,
    priorite integer,
    Primary key(id_ag)
);

create table utilisateur
(
    id_ut integer not null ,
    nom varchar(60) not null,
    prenom varchar(60) not null,
    login varchar(60) not null,
    adresse varchar(200),
    droit integer default 1,
    date_inscription timestamp default systimestamp,
    Primary key(id_ut)
);
/


create table note_ac
(
    id_ac integer not null,
    id_ut integer not null,
    date_note timestamp default systimestamp,
    note integer not null,
    foreign key (id_ac) references activite(id_ac) on delete cascade,
    foreign key (id_ut) references utilisateur(id_ut)
);

create table note_ag
(
    id_ag integer not null,
    id_ut integer not null,
    date_note timestamp default systimestamp,
    note integer not null,
    foreign key (id_ag) references agenda(id_ag) on delete cascade,
    foreign key (id_ut) references utilisateur(id_ut)
);


/* tables de liaison */

create table activite_agenda
(
    id_ac integer not null,
    id_ag integer not null,
    foreign key (id_ac) references activite(id_ac) on delete cascade,
    foreign key (id_ag) references agenda(id_ag) on delete cascade
);

create table activite_utilisateur
(
    id_ac integer not null,
    id_ut integer not null,
    foreign key (id_ac) references activite(id_ac) on delete cascade,
    foreign key (id_ut) references utilisateur(id_ut) on delete cascade
);

create table agenda_utilisateur
(
    id_ag integer not null,
    id_ut integer not null,
    foreign key (id_ut) references utilisateur(id_ut) on delete cascade,
    foreign key (id_ag) references agenda(id_ag) on delete cascade
);

/*il n'y a pas de clefs etrangeres car id_ag peut referencer les agendas qui ne sont pas 
archiver. Il en va de meme pour id_ac.
(on peut archiver une activite sans que l'agenda lie ne soit archive*/
create table activite_agenda_archive
(
    id_ac integer not null ,
    id_ag integer not null
);