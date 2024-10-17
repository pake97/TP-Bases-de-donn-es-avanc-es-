-- Script de création de la base du club de danse 

rollback;
drop schema if exists club_de_danse cascade;
create schema club_de_danse;
set search_path to club_de_danse;

--Entité professeur
create table professeurs(
	num_prof 		integer primary key,
	nom_prof		text,
	prenom_prof		text,
	tel_prof		text
	);

-- Entité salariés spécialisation de professeurs (clé primaire et étrangère à la fois)
create table salaries(
	num_salarie 			integer primary key,
	dateembauche_salarie	date,
	echelon_salarie			integer,
	salaire_salarie			decimal,

	constraint fk_sal_prof foreign key (num_salarie) references professeurs(num_prof) on delete cascade on update cascade
	-- Si un professeur salarie est supprimé ou modifié dans professeurs, il est supprimé ou modifié dans salaries
);

-- Entité vacataires spécialisation de professeurs (clé primaire et étrangère à la fois)

create table vacataires(
	num_vacataire 				integer primary key,
	statut_vacataire			text, -- par exemple auto-entrepreneur, étudiant, sans-emploi...
	constraint fk_vac_prof foreign key (num_vacataire) references professeurs(num_prof) on delete cascade on update cascade
	-- Si un professeur vacataire est supprimé ou modifié dans professeurs, il est supprimé ou modifié dans vacataires

);

-- Entité Contrat, entité faible de Vacataire. L'identifiant local (pour un vacataire donné) est la date du contrat.
create table contrats(
	num_vacataire 		integer references vacataires(num_vacataire) on delete cascade on update cascade,
-- Si un vacataire est supprimé, tous ses contrats seront supprimés.
	date_contrat		date,
	salaire_h_contrat	decimal,
	
	primary key (num_vacataire,date_contrat)

);

-- La table des cours. Contient l'association (1-N) 'Est Responsable' sous la forme d'une clé étrangère vers
-- le professeur responsable. La participation de chaque cours ) cette association est obligatoire (NOT NULL).
create type niveau as enum('Débutant','Avancé','Expert');
create table cours(
	code_cours				integer primary key,
	intitule_cours			text,
	numresponsable_cours	integer not null references professeurs(num_prof) on update cascade,
-- ici, pas de 'on update delete' : si un professeur est supprimé, on ne supprime pas les cours dont il est responsable.
-- donc la suppression d'un professeur sera interdite s'il est responsable d'au moins un cours.
	niveau_cours			niveau
);


-- Table qui traduit l'association (N-N) 'Intervient' entre les professeurs et les cours.
create table prof_intervient_cours(
	num_prof		integer references professeurs(num_prof) on update cascade on delete cascade,
	code_cours		integer references cours(code_cours) on update cascade on delete cascade,
-- Si un prof est supprimé, ses interventions seront supprimées d'office.
-- Si un cours est supprimé, les interventions le concernant son supprimées d'office.

	primary key(num_prof,code_cours)

);

