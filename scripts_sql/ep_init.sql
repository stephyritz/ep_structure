/*EP*/
/* Initialisation de la structure des données éclairage public*/
/* Objectif : Créer une structure de tables relationnelles répondant aux enjeux de gestion par la Communauté de Commune Thann-Cernay (CCTC)*/
/*Auteur : Stéphane Ritzenthaler*/


-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                      DATABASE                                                                ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################
-- Database: eclairage_public
-- DROP DATABASE eclairage_public;
/*
Création de la database à réaliser avant le déploiement du reste de la requête
CREATE DATABASE "BD_EP";
COMMENT ON DATABASE "BD_EP"
  IS 'Base de données permettant la gestion de l''éclairage public';
 */ 

-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                       SCHEMA                                                                 ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################
-- Schema: ep
-- DROP SCHEMA ep;
/* La suite du script est à executer dans l'éditeur de requête propre à la nouvelle base créée précédemment*/
CREATE SCHEMA ep;
COMMENT ON SCHEMA ep
  IS 'Schema contenant les tables relationnelles utilisées pour la gestion de l''éclairage public';
CREATE EXTENSION postgis;

-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                DOMAINES DE VALEURS                                                           ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################

-- Table: ep.val_commune
-- DROP TABLE ep.val_commune;
CREATE TABLE ep.val_commune
(
  insee character varying(5) NOT NULL,
  cp character varying(5),
  nom character varying(100) NOT NULL,
  CONSTRAINT ep_commune_pkey PRIMARY KEY (insee)
);

COMMENT ON TABLE ep.val_commune
  IS 'Liste des communes du territoire CCTC';
COMMENT ON COLUMN ep.val_commune.insee IS 'Numéro INSEE de la commune';
COMMENT ON COLUMN ep.val_commune.cp IS 'Code postal de la commune';
COMMENT ON COLUMN ep.val_commune.nom IS 'Nom de la commune';

INSERT INTO ep.val_commune(
            insee,cp,nom)
    VALUES
('68063','68700','Cernay'),
('68180','68800','Leimbach'),
('68261','68800','Rammersmatt'),
('68279','68800','Roderen'),
('68302','68520','Schweighouse-Thann'),
('68322','68700','Steinbach'),
('68334','68800','Thann'),
('68342','68700','Uffholtz'),
('68348','68800','Vieux-Thann'),
('68359','68700','Wattwiller'),
('68372','68760','Willer-sur-Thur'),
('68011','68700','Aspach-le-Bas'),
('68012','68700','Aspach-Michelbach'),
('68040','68620','Bitschwiller-lès-Thann'),
('68045','68290','Bourbach-le-Bas'),
('68046','68290','Bourbach-le-Haut');


-- Table: ep.val_qualite_geoloc
-- DROP TABLE ep.val_qualite_geolocc;
CREATE TABLE ep.val_qualite_geoloc
(
  code character varying(2) NOT NULL,
  valeur character varying(80) NOT NULL,
  definition character varying(255),
  CONSTRAINT ep_qualite_geoloc_pkey PRIMARY KEY (code)
);

COMMENT ON TABLE ep.val_qualite_geoloc
  IS 'Classe de précision au sens de l''arrêté interministériel du 15 février 2012 modifié (DT-DICT)';
COMMENT ON COLUMN ep.val_qualite_geoloc.code IS 'Code de la liste énumérée relative à la classe de précision au sens de l''arrêté interministériel du 15 février 2012 modifié (DT-DICT)';
COMMENT ON COLUMN ep.val_qualite_geoloc.valeur IS 'Valeur de la liste énumérée relative à la classe de précision au sens de l''arrêté interministériel du 15 février 2012 modifié (DT-DICT)';
COMMENT ON COLUMN ep.val_qualite_geoloc.definition IS 'Définition de la liste énumérée relative à la classe de précision au sens de l''arrêté interministériel du 15 février 2012 modifié (DT-DICT)';

INSERT INTO ep.val_qualite_geoloc(
            code, valeur, definition)
    VALUES
('00','Indéterminé','Classe de précision indéterminée'),
('01','Classe A','Classe de précision inférieure 40 cm'),
('02','Classe B','Classe de précision supérieure à 40 cm et inférieure à 1,50 m'),
('03','Classe C','Classe de précision supérieure à 1,50 m');


-- Table: ep.val_origine_geoloc
-- DROP TABLE ep.val_origine_geoloc;
CREATE TABLE ep.val_origine_geoloc
(
  code character varying(2) NOT NULL,
  valeur character varying(80) NOT NULL,
  definition character varying(255),
  CONSTRAINT ep_origine_geoloc_pkey PRIMARY KEY (code)
);

COMMENT ON TABLE ep.val_origine_geoloc
  IS 'Qualité de l''information de géoréférencement d''un équipement';
COMMENT ON COLUMN ep.val_origine_geoloc.code IS 'Code de la liste énumérée relative à la qualité de l''information de géoréférencement d''un équipement';
COMMENT ON COLUMN ep.val_origine_geoloc.valeur IS 'Valeur de la liste énumérée relative à la qualité de l''information de géoréférencement d''un équipement';
COMMENT ON COLUMN ep.val_origine_geoloc.definition IS 'Définition de la liste énumérée relative à la qualité de l''information de géoréférencement d''un équipement';

INSERT INTO ep.val_origine_geoloc(
            code, valeur, definition)
    VALUES
('00','Indéterminé','Information ou qualité de l''information inconnue'),
('01','Papier','Données issues de la numérisation des plans papiers'),
('02','Récolement','Données reprises sur plans de récolement'),
('03','Géoréférencement','Données issues d''une campagne de géoréférencement'),
('04','Mémoire','Données issues de souvenir(s) individuel(s)'),
('05','Déduite','Données numérisées déduites à partir d''informations externes');

-- Table: ep.val_etat
-- DROP TABLE ep.val_etat;
CREATE TABLE ep.val_etat
(
  code character varying(2) NOT NULL, -- code de la liste
  valeur character varying(80) NOT NULL, -- valeur de la liste
  definition character varying(255), --définition
  CONSTRAINT val_etat_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE ep.val_etat
  IS 'Liste décrivant l''état de l''objet du réseau';
COMMENT ON COLUMN ep.val_etat.code IS 'Code interne de la liste énumérée relative à l''état de l''objet du réseau';
COMMENT ON COLUMN ep.val_etat.valeur IS 'Valeur de la liste énumérée relative à l''état de l''objet du réseau';
COMMENT ON COLUMN ep.val_etat.definition IS 'Définition de la liste énumérée relative à l''état de l''objet du réseau';

INSERT INTO ep.val_etat(code,
            valeur, definition)
    VALUES
('00','Indéterminé','Etat inconnu'),
('01','Bon','Objet en bon état'),
('02','Défectueux','Objet défectueux'),
('03','En panne','Objet en panne pour raison inconnue'),
('04','Mis hors service','Objet mis hors service volontairement'),
('05','Abandonné','Objet ancien qui est actuellement abandonné'),
('99','Autre','Objet dont l''état ne figure pas dans la liste ci-dessus');


-- Table: ep.val_typeres
-- DROP TABLE ep.val_typeres;
CREATE TABLE ep.val_typeres
(
  code character varying(2) NOT NULL, -- code de la liste
  valeur character varying(80) NOT NULL, -- valeur de la liste
  CONSTRAINT val_typeres_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE ep.val_typeres
  IS 'Liste décrivant le type des objets du réseau';
COMMENT ON COLUMN ep.val_typeres.code IS 'Code interne de la liste énumérée relative au type de réseau de l''objet';
COMMENT ON COLUMN ep.val_typeres.valeur IS 'Valeur de la liste énumérée relative au type de réseau de l''objet';

INSERT INTO ep.val_typeres(code,
            valeur)
    VALUES
('00','Indéterminé'),
('01','Strictement souterrain'),
('02','Strictement aérien'),
('03','Aérien et souterrain');


-- Table: ep.val_foncreseau
-- DROP TABLE ep.val_foncreseau;
CREATE TABLE ep.val_foncreseau
(
  code character varying(2) NOT NULL, -- code de la liste
  valeur character varying(80) NOT NULL, -- valeur de la liste
  CONSTRAINT val_foncreseau_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE ep.val_foncreseau
  IS 'Liste décrivant la fonction du tronçon du réseau';
COMMENT ON COLUMN ep.val_foncreseau.code IS 'Code interne de la liste énumérée relative à la fonction du tronçon';
COMMENT ON COLUMN ep.val_foncreseau.valeur IS 'Valeur de la liste énumérée relative à la fonction du tronçon';

INSERT INTO ep.val_foncreseau(code,
            valeur)
    VALUES
('00','Indéterminé'),
('01','Transport'),
('02','Distribution'),
('03','Réseau Led'),
('99','Autre');


-- Table: ep.val_typegaine
-- DROP TABLE ep.val_typegaine;
CREATE TABLE ep.val_typegaine
(
  code character varying(2) NOT NULL, -- code de la liste
  valeur character varying(80) NOT NULL, -- valeur de la liste
  CONSTRAINT val_typegaine_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE ep.val_typegaine
  IS 'Liste décrivant le type de gaine utilisées sur les objets du réseau';
COMMENT ON COLUMN ep.val_typegaine.code IS 'Code interne de la liste énumérée relative au type de gaine';
COMMENT ON COLUMN ep.val_typegaine.valeur IS 'Valeur de la liste énumérée relative au type de gaine';

INSERT INTO ep.val_typegaine(code,
            valeur)
    VALUES
('00','Indéterminé'),
('01','DN63 TPC'),
('02','DN63 TPC + Cu nu'),
('03','DN63 PVC'),
('04','DN63'),
('05','DN40 TPC + Cu nu'),
('06','DN90 TPC'),
('07','DN50 TPC'),
('08','DN110 TPC'),
('09','DN75 TPC'),
('99','Autre');


-- Table: ep.val_typecable
-- DROP TABLE ep.val_typecable;
CREATE TABLE ep.val_typecable
(
  code character varying(2) NOT NULL, -- code de la liste
  valeur character varying(80) NOT NULL, -- valeur de la liste
  CONSTRAINT val_typecable_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE ep.val_typecable
  IS 'Liste décrivant le type de cables utilisés sur les objets du réseau';
COMMENT ON COLUMN ep.val_typecable.code IS 'Code interne de la liste énumérée relative au type de cable';
COMMENT ON COLUMN ep.val_typecable.valeur IS 'Valeur de la liste énumérée relative au type de cable';

INSERT INTO ep.val_typecable(code,
            valeur)
    VALUES
('00','Indéterminé'),
('01','3x10 Cu'),
('02','3G6 Cu'),
('03','4x16 Cu'),
('04','4G16 Cu'),
('05','3x6 Cu'),
('06','3x16 Cu'),
('07','3G10 Cu'),
('08','2x10 Cu'),
('09','3G25 Cu'),
('10','2x6 Cu'),
('11','3G2,5'),
('12','4x10 Cu'),
('13','3G16'),
('14','3G4 Cu'),
('15','3G16 Cu'),
('16','4x6 Cu'),
('17','5G16 Cu'),
('18','2x16 Al'),
('19','3G2,5 Cu'),
('20','2x4 Cu'),
('21','3x4 Cu'),
('22','2x16 Cu'),
('23','4x4 Cu'),
('24','4G6 Cu'),
('25','4G10 Cu'),
('26','5G6 Cu'),
('27','4x16 Al'),
('28','3x25 Cu'),
('29','2x1.5'),
('99','Autre');


-- Table: ep.val_boolean
-- DROP TABLE ep.val_boolean;
CREATE TABLE ep.val_boolean
(
  code character varying(1) NOT NULL, -- code de la liste
  valeur character varying(80) NOT NULL, -- valeur de la liste
  definition character varying(255), --définition
  CONSTRAINT val_boolean_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE ep.val_boolean
  IS 'Liste de faux booléen';
COMMENT ON COLUMN ep.val_boolean.code IS 'Code interne de la liste énumérée relative au faux booléen';
COMMENT ON COLUMN ep.val_boolean.valeur IS 'Valeur de la liste énumérée relative au faux booléen';
COMMENT ON COLUMN ep.val_boolean.definition IS 'Définition de la liste énumérée relative au faux booléen';

INSERT INTO ep.val_boolean(code,
            valeur, definition)
    VALUES
('0','Indéterminé','Etat inconnu'),
('t','Oui','True'),
('f','Non','False');

-- Table: ep.val_typeferm
-- DROP TABLE ep.val_typeferm;
CREATE TABLE ep.val_typeferm
(
  code character varying(2) NOT NULL, -- code de la liste
  valeur character varying(80) NOT NULL, -- valeur de la liste
  CONSTRAINT typeferm_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE ep.val_typeferm
  IS 'Liste des types de fermetures';
COMMENT ON COLUMN ep.val_typeferm.code IS 'Code interne de la liste des types de fermetures';
COMMENT ON COLUMN ep.val_typeferm.valeur IS 'Valeur de la liste des types de fermetures';

INSERT INTO ep.val_typeferm(code,
            valeur)
    VALUES
('00','Indéterminé'),
('01','Clé triangle'),
('02','Alène'),
('03','Serrure'),
('04','Boulon'),
('05','Charnière'),
('99','Autre');

-- Table: ep.val_typealim
-- DROP TABLE ep.val_typealim;
CREATE TABLE ep.val_typealim
(
  code character varying(2) NOT NULL, -- code de la liste
  valeur character varying(80) NOT NULL, -- valeur de la liste
  CONSTRAINT typealim_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE ep.val_typealim
  IS 'Liste des types d''alimentations';
COMMENT ON COLUMN ep.val_typealim.code IS 'Code interne de la liste des types d''alimentations';
COMMENT ON COLUMN ep.val_typealim.valeur IS 'Valeur de la liste des types d''alimentations';

INSERT INTO ep.val_typealim(code,
            valeur)
    VALUES
('00','Indéterminé'),
('01','Monophasé'),
('02','Triphasé'),
('99','Autre');

-- Table: ep.val_typeprotec
-- DROP TABLE ep.val_typeprotec;
CREATE TABLE ep.val_typeprotec
(
  code character varying(2) NOT NULL, -- code de la liste
  valeur character varying(80) NOT NULL, -- valeur de la liste
  CONSTRAINT typeprotec_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE ep.val_typeprotec
  IS 'Liste des types de protection des armoires';
COMMENT ON COLUMN ep.val_typeprotec.code IS 'Code interne de la liste des types de protection des armoires';
COMMENT ON COLUMN ep.val_typeprotec.valeur IS 'Valeur de la liste des types de protection des armoires';

INSERT INTO ep.val_typeprotec(code,
            valeur)
    VALUES
('00','Indéterminé'),
('01','Fusible'),
('02','Disjoncteur'),
('99','Absent');

-- Table: ep.val_typecompteur
-- DROP TABLE ep.val_typecompteur;
CREATE TABLE ep.val_typecompteur
(
  code character varying(2) NOT NULL, -- code de la liste
  valeur character varying(80) NOT NULL, -- valeur de la liste
  CONSTRAINT typecompteur_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE ep.val_typecompteur
  IS 'Liste des types de compteur dans les armoires';
COMMENT ON COLUMN ep.val_typecompteur.code IS 'Code interne de la liste des types de compteur dans les armoires';
COMMENT ON COLUMN ep.val_typecompteur.valeur IS 'Valeur de la liste des types de compteur dans les armoires';

INSERT INTO ep.val_typecompteur(code,
            valeur)
    VALUES
('00','Indéterminé'),
('01','Electromécanique'),
('02','Electronique'),
('03','Forfait'),
('99','Autre');

-- Table: ep.val_materiau
-- DROP TABLE ep.val_materiau;
CREATE TABLE ep.val_materiau
(
  code character varying(5) NOT NULL, -- code de la liste
  categorie character varying(2) NOT NULL, -- catégorie de la liste
  valeur character varying(80) NOT NULL, -- valeur de la liste
  CONSTRAINT materiau_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE ep.val_materiau
  IS 'Liste des types de matériau';
COMMENT ON COLUMN ep.val_materiau.code IS 'Code interne de la liste des types de matériau';
COMMENT ON COLUMN ep.val_materiau.valeur IS 'Valeur de la liste des types de matériau';

INSERT INTO ep.val_materiau(code,categorie,valeur)
    VALUES
('00-00','00','Indéterminé'),
('01-00','01','Polyester'),
('02-00','02','Métal'),
('02-01','02','Métal - Aluminium'),
('02-02','02','Métal - Fonte'),
('02-03','02','Métal - Acier'),
('03-01','03','Composite - Fibre de verre'),
('04-00','04','Béton'),
('05-00','05','Bois'), 
('99-00','99','Autre');

-- Table: ep.val_typesupport
-- DROP TABLE ep.val_typesupport;
CREATE TABLE ep.val_typesupport
(
  code character varying(2) NOT NULL, -- code de la liste
  valeur character varying(80) NOT NULL, -- valeur de la liste
  CONSTRAINT typesupport_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE ep.val_typesupport
  IS 'Liste des types de support';
COMMENT ON COLUMN ep.val_typesupport.code IS 'Code interne de la liste des types de support';
COMMENT ON COLUMN ep.val_typesupport.valeur IS 'Valeur de la liste des types de support';

INSERT INTO ep.val_typesupport(code,
            valeur)
    VALUES
('00','Indéterminé'),
('01','Mât'),
('02','Facade'),
('03','Poteau'),
('04','Encastré'),
('05','Toiture'),
('06','Borne'),
('99','Autre');

-- Table: ep.val_formesupport
-- DROP TABLE ep.val_formesupport;
CREATE TABLE ep.val_formesupport
(
  code character varying(2) NOT NULL, -- code de la liste
  valeur character varying(80) NOT NULL, -- valeur de la liste
  CONSTRAINT formesupport_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE ep.val_formesupport
  IS 'Liste des formes possible pour le support';
COMMENT ON COLUMN ep.val_typesupport.code IS 'Code interne de la liste des formes de support';
COMMENT ON COLUMN ep.val_typesupport.valeur IS 'Valeur de la liste des formes de support';

INSERT INTO ep.val_formesupport(code,
            valeur)
    VALUES
('00','Indéterminé'),
('01','Cylindrique'),
('02','Cylindro-conique'),
('03','Octogonal'),
('04','Octo-conique'),
('05','Canelé-conique'),
('99','Autre');

-- Table: ep.val_typeobjet
-- DROP TABLE ep.val_typeobjet;
CREATE TABLE ep.val_typeobjet
(
  code character varying(2) NOT NULL, -- code de la liste
  valeur character varying(80) NOT NULL, -- valeur de la liste
  CONSTRAINT typeobjet_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE ep.val_typeobjet
  IS 'Liste des types d''objets';
COMMENT ON COLUMN ep.val_typesupport.code IS 'Code interne de la liste des types d''objets';
COMMENT ON COLUMN ep.val_typesupport.valeur IS 'Valeur de la liste des types d''objets';

INSERT INTO ep.val_typeobjet(code,
            valeur)
    VALUES
('00','Indéterminé'),
('01','Armoire'),
('02','Support'),
('03','Mobilier'),
('04','Chambre'),
('05','Semis de points'),
('06','Jonction gaine'),
('07','Tronçon'),
('99','Autre');

-- Table: ep.val_typemobilier
-- DROP TABLE ep.val_typemobilier;
CREATE TABLE ep.val_typemobilier
(
  code character varying(2) NOT NULL, -- code de la liste
  valeur character varying(80) NOT NULL, -- valeur de la liste
  CONSTRAINT typemobilier_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE ep.val_typemobilier
  IS 'Liste des types de mobilier';
COMMENT ON COLUMN ep.val_typemobilier.code IS 'Code interne de la liste des types de mobilier';
COMMENT ON COLUMN ep.val_typemobilier.valeur IS 'Valeur de la liste des types de mobilier';

INSERT INTO ep.val_typemobilier(code,
            valeur)
    VALUES
('00','Indéterminé'),
('01','Radar pédagogique'),
('02','Cabine téléphonique'),
('03','Abris bus'),
('04','Panneau de signalisation'),
('05','Prise électrique'),
('06','Feu de signalisation'),
('07','Panneau d''information'),
('08','Jalonnement dynamique'),
('99','Autre');

-- Table: ep.val_typeaccessoire
-- DROP TABLE ep.val_typeaccessoire;
CREATE TABLE ep.val_typeaccessoire
(
  code character varying(2) NOT NULL, -- code de la liste
  valeur character varying(80) NOT NULL, -- valeur de la liste
  CONSTRAINT typeaccessoire_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE ep.val_typeaccessoire
  IS 'Liste des types d''accessoire';
COMMENT ON COLUMN ep.val_typeaccessoire.code IS 'Code interne de la liste des types d''accessoire';
COMMENT ON COLUMN ep.val_typeaccessoire.valeur IS 'Valeur de la liste des types d''accessoire';

INSERT INTO ep.val_typeaccessoire(code,
            valeur)
    VALUES
('00','Indéterminé'),
('01','Oriflamme'),
('02','Potence pour jardinière'),
('03','Caméra'),
('04','Panneau de signalisation'),
('05','Panneau divers'),
('06','Prise électique'),
('07','Radar pédagogique'),
('08','Lumandar'),
('09','Parafoudre'),
('10','Miroir'),
('11','Varistance'),
('12','Prise illumination'),
('13','Support ilmumination'),
('14','Ancrage RCE'),
('15','Réseau aéro-souterrain RCE'),
('99','Autre');

-- Table: ep.val_typecommande
-- DROP TABLE ep.val_typecommande;
CREATE TABLE ep.val_typecommande
(
  code character varying(2) NOT NULL, -- code de la liste
  valeur character varying(80) NOT NULL, -- valeur de la liste
  CONSTRAINT typecommande_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE ep.val_typecommande
  IS 'Liste des types de commandes liées aux armoires';
COMMENT ON COLUMN ep.val_typecommande.code IS 'Code interne de la liste des types de commandes liées aux armoires';
COMMENT ON COLUMN ep.val_typecommande.valeur IS 'Valeur de la liste des types de commandes liées aux armoires';

INSERT INTO ep.val_typecommande(code,
            valeur)
    VALUES
('00','Indéterminé'),
('01','Cellule photoélectrique'),
('02','Horloge astronomique'),
('03','Horloge'),
('04','Fibre'),
('05','Lumandar'),
('99','Autre');

-- Table: ep.val_typefixation
-- DROP TABLE ep.val_typefixation;
CREATE TABLE ep.val_typefixation
(
  code character varying(2) NOT NULL, -- code de la liste
  valeur character varying(80) NOT NULL, -- valeur de la liste
  CONSTRAINT typefixation_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE ep.val_typefixation
  IS 'Liste des types de fixations liées aux armoires';
COMMENT ON COLUMN ep.val_typefixation.code IS 'Code interne de la liste des types de fixations liées aux armoires';
COMMENT ON COLUMN ep.val_typefixation.valeur IS 'Valeur de la liste des types de fixations liées aux armoires';

INSERT INTO ep.val_typefixation(code,
            valeur)
    VALUES
('00','Indéterminé'),
('01','Sol'),
('02','Poteau'),
('03','Saillie'),
('04','Façade'),
('05','Encastré'),
('99','Autre');

-- Table: ep.val_typetarif
-- DROP TABLE ep.val_typetarif
CREATE TABLE ep.val_typetarif
(
  code character varying(2) NOT NULL, -- code de la liste
  valeur character varying(80) NOT NULL, -- valeur de la liste
  CONSTRAINT typetarif_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE ep.val_typetarif
  IS 'Liste des types de tarifs edf liés aux armoires';
COMMENT ON COLUMN ep.val_typetarif.code IS 'Code interne de la liste des types de tarifs edf liés aux armoires';
COMMENT ON COLUMN ep.val_typetarif.valeur IS 'Valeur de la liste des types de tarifs edf liés aux armoires';

INSERT INTO ep.val_typetarif(code,
            valeur)
    VALUES
('00','Indéterminé'),
('01','Bleu'),
('02','Jaune'),
('99','Autre');

-- Table: ep.val_tension
-- DROP TABLE ep.val_tension
CREATE TABLE ep.val_tension
(
  code character varying(2) NOT NULL, -- code de la liste
  valeur character varying(80) NOT NULL, -- valeur de la liste
  CONSTRAINT tension_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE ep.val_tension
  IS 'Liste des types de tensions liées aux armoires';
COMMENT ON COLUMN ep.val_tension.code IS 'Code interne de la liste des types de tensions liées aux armoires';
COMMENT ON COLUMN ep.val_tension.valeur IS 'Valeur de la liste des types de tensions liées aux armoires';

INSERT INTO ep.val_tension(code,
            valeur)
    VALUES
('00','Indéterminé'),
('01','230v'),
('02','240v'),
('03','380v'),
('04','400v'),
('99','Autre');

-- Table: ep.val_typechambre
-- DROP TABLE ep.val_typechambre
CREATE TABLE ep.val_typechambre
(
  code character varying(2) NOT NULL, -- code de la liste
  valeur character varying(80) NOT NULL, -- valeur de la liste
  CONSTRAINT typechambre_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE ep.val_typechambre
  IS 'Liste des types de chambres';
COMMENT ON COLUMN ep.val_typechambre.code IS 'Code interne de la liste des types de chambres';
COMMENT ON COLUMN ep.val_typechambre.valeur IS 'Valeur de la liste des types de chambres';

INSERT INTO ep.val_typechambre(code,
            valeur)
    VALUES
('00','Indéterminé'),
('01','L0T'),
('02','L1T'),
('03','L2T'),
('04','L3T'),
('05','L4T'),
('06','Regard béton'),
('99','Autre');

-- Table: ep.val_typecouvercle
-- DROP TABLE ep.val_typecouvercle
CREATE TABLE ep.val_typecouvercle
(
  code character varying(2) NOT NULL, -- code de la liste
  valeur character varying(80) NOT NULL, -- valeur de la liste
  CONSTRAINT typecouvercle_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE ep.val_typecouvercle
  IS 'Liste des types de couvercles pour les chambres';
COMMENT ON COLUMN ep.val_typecouvercle.code IS 'Code interne de la liste des types de couvercles pour les chambres';
COMMENT ON COLUMN ep.val_typecouvercle.valeur IS 'Valeur de la liste des types de couvercles pour les chambres';

INSERT INTO ep.val_typecouvercle(code,
            valeur)
    VALUES
('00','Indéterminé'),
('01','Béton'),
('02','Fonte'),
('99','Autre');

-- Table: ep.val_classecouvercle
-- DROP TABLE ep.val_classecouvercle
CREATE TABLE ep.val_classecouvercle
(
  code character varying(2) NOT NULL, -- code de la liste
  valeur character varying(80) NOT NULL, -- valeur de la liste
  CONSTRAINT classecouvercle_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE ep.val_classecouvercle
  IS 'Liste des différentes classes de couvercles pour les chambres';
COMMENT ON COLUMN ep.val_classecouvercle.code IS 'Code interne de la liste des différentes classes de couvercles pour les chambres';
COMMENT ON COLUMN ep.val_classecouvercle.valeur IS 'Valeur de la liste des différentes classes de couvercles pour les chambres';

INSERT INTO ep.val_classecouvercle(code,
            valeur)
    VALUES
('00','Indéterminé'),
('01','125'),
('02','250'),
('03','400'),
('99','Autre');

-- Table: ep.val_typeintervention
-- DROP TABLE ep.val_typeintervention
CREATE TABLE ep.val_typeintervention
(
  code character varying(2) NOT NULL, -- code de la liste
  valeur character varying(80) NOT NULL, -- valeur de la liste
  CONSTRAINT typeintervention_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE ep.val_typeintervention
  IS 'Liste des différents types d''interventions réalisées sur le réseau d''éclairage public';
COMMENT ON COLUMN ep.val_typeintervention.code IS 'Code interne de la liste des différents types d''interventions';
COMMENT ON COLUMN ep.val_typeintervention.valeur IS 'Valeur de la liste des différents types d''interventions';

INSERT INTO ep.val_typeintervention(code,
            valeur)
    VALUES
('00','Indéterminé'),
('01','Réparation'),
('02','Remplacement'),
('03','Contrôle'),
('99','Autre');

-- Table: ep.val_marquepl
-- DROP TABLE ep.val_marquepl
CREATE TABLE ep.val_marquepl
(
  code character varying(2) NOT NULL, -- code de la liste
  valeur character varying(80) NOT NULL, -- valeur de la liste
  CONSTRAINT marquepl_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE ep.val_marquepl
  IS 'Liste des différentes marques de points lumineux';
COMMENT ON COLUMN ep.val_marquepl.code IS 'Code interne de la liste des différentes marques de points lumineux';
COMMENT ON COLUMN ep.val_marquepl.valeur IS 'Valeur de la liste des différentes marques de points lumineux';

INSERT INTO ep.val_marquepl(code,
            valeur)
    VALUES
('00','Indéterminé'),
('01','Comatelec'),
('02','Philips'),
('03','GHM'),
('04','Vulkanlux'),
('05','VHM'),
('06','Thorn'),
('07','Rohl'),
('08','Ragni'),
('09','Mazda'),
('10','Ligman'),
('11','Lenzi'),
('12','Indal'),
('13','Eclatec'),
('14','City Design'),
('15','Europhane'),
('16','Iguzzini'),
('99','Autre');

-- Table: ep.val_typepl
-- DROP TABLE ep.val_typepl
CREATE TABLE ep.val_typepl
(
  code character varying(2) NOT NULL, -- code de la liste
  valeur character varying(80) NOT NULL, -- valeur de la liste
  CONSTRAINT typepl_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE ep.val_typepl
  IS 'Liste des différentes types de points lumineux';
COMMENT ON COLUMN ep.val_typepl.code IS 'Code interne de la liste des différentes types de points lumineux';
COMMENT ON COLUMN ep.val_typepl.valeur IS 'Valeur de la liste des différentes types de points lumineux';

INSERT INTO ep.val_typepl(code,
            valeur)
    VALUES
('00','Indéterminé'),
('01','Ouvert'),
('02','Fermé'),
('03','Projecteur'),
('99','Autre');

-- Table: ep.val_classepl
-- DROP TABLE ep.val_classepl
CREATE TABLE ep.val_classepl
(
  code character varying(2) NOT NULL, -- code de la liste
  valeur character varying(80) NOT NULL, -- valeur de la liste
  CONSTRAINT classepl_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE ep.val_classepl
  IS 'Liste des différentes classes éléctriques des points lumineux';
COMMENT ON COLUMN ep.val_classepl.code IS 'Code interne de la liste des différentes classes éléctriques des points lumineux';
COMMENT ON COLUMN ep.val_classepl.valeur IS 'Valeur de la liste des différentes classes éléctriques des points lumineux';

INSERT INTO ep.val_classepl(code,
            valeur)
    VALUES
('00','Indéterminé'),
('01','Classe I'),
('02','Classe II'),
('03','Classe III'),
('99','Autre');

-- Table: ep.val_typebalpl
-- DROP TABLE ep.val_typebalpl
CREATE TABLE ep.val_typebalpl
(
  code character varying(2) NOT NULL, -- code de la liste
  valeur character varying(80) NOT NULL, -- valeur de la liste
  CONSTRAINT typebalpl_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE ep.val_typebalpl
  IS 'Liste des différents types de ballast associés aux points lumineux';
COMMENT ON COLUMN ep.val_typebalpl.code IS 'Code interne de la liste des différents types de ballast associés aux points lumineux';
COMMENT ON COLUMN ep.val_typebalpl.valeur IS 'Valeur de la liste des différents types de ballast associés aux points lumineux';

INSERT INTO ep.val_typebalpl(code,
            valeur)
    VALUES
('00','Indéterminé'),
('01','Ferromagnétique'),
('02','Electronique'),
('99','Autre');

-- Table: ep.val_typesourpl
-- DROP TABLE ep.val_typesourpl
CREATE TABLE ep.val_typesourpl
(
  code character varying(2) NOT NULL, -- code de la liste
  valeur character varying(80) NOT NULL, -- valeur de la liste
  CONSTRAINT typesourpl_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE ep.val_typesourpl
  IS 'Liste des différents types de sources lumineuses associées aux points lumineux';
COMMENT ON COLUMN ep.val_typesourpl.code IS 'Code interne de la liste des différents types de sources lumineuses associées aux points lumineux';
COMMENT ON COLUMN ep.val_typesourpl.valeur IS 'Valeur de la liste des différents types de sources lumineuses associées aux points lumineux';

INSERT INTO ep.val_typesourpl(code,
            valeur)
    VALUES
('00','Indéterminé'),
('01','Iodure Métallique (IM)'),
('02','Cosmopolis'),
('03','Sodium Haute Pression (SHP)'),
('04','Sodium Basse Pression (SBP)'),
('05','Ballon Fluorescent (BF)'),
('06','LED'),
('07','Fluo Compact (FC)'),
('08','Halogène'),
('99','Autre');

-- Table: ep.val_typefixationpl
-- DROP TABLE ep.val_typefixationpl
CREATE TABLE ep.val_typefixationpl
(
  code character varying(2) NOT NULL, -- code de la liste
  valeur character varying(80) NOT NULL, -- valeur de la liste
  CONSTRAINT typefixationpl_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE ep.val_typefixationpl
  IS 'Liste des différents types de fixations des points lumineux au support';
COMMENT ON COLUMN ep.val_typefixationpl.code IS 'Code interne de la liste des différents types de fixations des points lumineux au support';
COMMENT ON COLUMN ep.val_typefixationpl.valeur IS 'Valeur de la liste des différents types de fixations des points lumineux au support';

INSERT INTO ep.val_typefixationpl(code,
            valeur)
    VALUES
('00','Indéterminé'),
('01','Vis'),
('99','Autre');

-- Table: ep.val_massifsupport
-- DROP TABLE ep.val_massifsupport
CREATE TABLE ep.val_massifsupport
(
  code character varying(2) NOT NULL, -- code de la liste
  valeur character varying(80) NOT NULL, -- valeur de la liste
  CONSTRAINT massifsupport_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE ep.val_massifsupport
  IS 'Liste des différents massifs liés au support';
COMMENT ON COLUMN ep.val_massifsupport.code IS 'Code interne de la liste des différents massifs liés au support';
COMMENT ON COLUMN ep.val_massifsupport.valeur IS 'Valeur de la liste des différents massifs liés au support';

INSERT INTO ep.val_massifsupport(code,
            valeur)
    VALUES
('00','Indéterminé'),
('01','Préfabriqué'),
('02','Coulé sur place'),
('99','Inexistant');

-- Table: ep.val_regallumage
-- DROP TABLE ep.val_regallumage
CREATE TABLE ep.val_regallumage
(
  code character varying(2) NOT NULL, -- code de la liste
  valeur character varying(80) NOT NULL, -- valeur de la liste
  CONSTRAINT regallumage_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE ep.val_regallumage
  IS 'Liste des différents régimes d''allumage liés au support';
COMMENT ON COLUMN ep.val_regallumage.code IS 'Code interne de la liste des différents régimes d''allumage liés au support';
COMMENT ON COLUMN ep.val_regallumage.valeur IS 'Valeur de la liste des différents régimes d''allumage liés au support';

INSERT INTO ep.val_regallumage(code,
            valeur)
    VALUES
('00','Indéterminé'),
('01','Nuit'),
('02','Demi-nuit'),
('99','Autre');

-- Table: ep.val_zonagesupport
-- DROP TABLE ep.val_zonagesupport
CREATE TABLE ep.val_zonagesupport
(
  code character varying(2) NOT NULL, -- code de la liste
  valeur character varying(80) NOT NULL, -- valeur de la liste
  CONSTRAINT zonagesupport_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE ep.val_zonagesupport
  IS 'Liste des différents zonages dans lesquels peuvent se trouver les supports';
COMMENT ON COLUMN ep.val_zonagesupport.code IS 'Code interne de la liste des différents régimes d''allumage liés au support';
COMMENT ON COLUMN ep.val_zonagesupport.valeur IS 'Valeur de la liste des différents régimes d''allumage liés au support';

INSERT INTO ep.val_zonagesupport(code,
            valeur)
    VALUES
('00','Indéterminé'),
('01','Routier'),
('02','Centre-ville'),
('03','Résidentiel'),
('04','Piéton'),
('99','Autre');




-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                     SEQUENCE                                                                 ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################
-- Identifiants générés au sein du job FME dans le cadre de ce projet
/*
--Sequence: ep.ep_idtronc
-- DROP SEQUENCE ep.ep_idtronc;
CREATE SEQUENCE ep.ep_idtronc
  INCREMENT 1
  MINVALUE 0
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
  
  -- Sequence: ep.ep_idnoeud
-- DROP SEQUENCE ep.ep_idnoeud;
CREATE SEQUENCE ep.ep_idnoeud
  INCREMENT 1
  MINVALUE 0
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
  
    -- Sequence: ep.ep_idobjet
-- DROP SEQUENCE ep.ep_idobjet;
CREATE SEQUENCE ep.ep_idobjet
  INCREMENT 1
  MINVALUE 0
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
  
      -- Sequence: ep.ep_idaccessoire
-- DROP SEQUENCE ep.ep_idaccessoire;
CREATE SEQUENCE ep.ep_idaccessoire
  INCREMENT 1
  MINVALUE 0
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
  
        -- Sequence: ep.ep_idarmoire
-- DROP SEQUENCE ep.ep_idarmoire;
CREATE SEQUENCE ep.ep_idarmoire
  INCREMENT 1
  MINVALUE 0
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
  
          -- Sequence: ep.ep_idchambre
-- DROP SEQUENCE ep.ep_idchambre;
CREATE SEQUENCE ep.ep_idchambre
  INCREMENT 1
  MINVALUE 0
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
  
            -- Sequence: ep.ep_idintervention
-- DROP SEQUENCE ep.ep_idintervention;
CREATE SEQUENCE ep.ep_idintervention
  INCREMENT 1
  MINVALUE 0
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
  
              -- Sequence: ep.ep_idmobilier
-- DROP SEQUENCE ep.ep_idmobilier;
CREATE SEQUENCE ep.ep_idmobilier
  INCREMENT 1
  MINVALUE 0
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
  
                -- Sequence: ep.ep_idpl
-- DROP SEQUENCE ep.ep_idpl;
CREATE SEQUENCE ep.ep_idpl
  INCREMENT 1
  MINVALUE 0
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
  
                  -- Sequence: ep.ep_idsupport
-- DROP SEQUENCE ep.ep_idsupport;
CREATE SEQUENCE ep.ep_idsupport
  INCREMENT 1
  MINVALUE 0
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
*/
  -- ##################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                TABLES METIER                                                                 ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################

-- Table: ep.geo_tronc
-- DROP TABLE ep.geo_tronc;
CREATE TABLE ep.geo_tronc
(
  id_tronc character varying(100) NOT NULL,
  idgce_tronc integer,
  adrue_tronc character varying(100),
  longcalc_tronc numeric(6,2),
  longmes_tronc numeric(6,2),
  insee_tronc character varying(5),
  arm_tronc character varying (50),
  fonction_tronc character varying(2),
  typeres_tronc character varying(2),
  typegaine_tronc character varying(2),
  typecable_tronc character varying(2),
  origeoloc_tronc character varying(2),
  qualglocxy_tronc character varying(2),
  qualglocz_tronc character varying(2),
  geom geometry(LineString,3948),
  CONSTRAINT geo_tronc_pkey PRIMARY KEY (id_tronc)  
)
WITH (
  OIDS=FALSE
);
COMMENT ON TABLE ep.geo_tronc
  IS 'Tronçons du réseau d''éclairage public';
COMMENT ON COLUMN ep.geo_tronc.id_tronc  IS 'Identifiant du tronçon du réseau';
COMMENT ON COLUMN ep.geo_tronc.idgce_tronc IS 'Identifiant originel du réseau issu de geoconcept';
COMMENT ON COLUMN ep.geo_tronc.adrue_tronc IS 'Adresse approximative du tronçon';
COMMENT ON COLUMN ep.geo_tronc.longcalc_tronc IS 'Longueur calculée du tronçon (en mètres)';
COMMENT ON COLUMN ep.geo_tronc.longmes_tronc IS 'Longueur mesurée sur le terrain du tronçon (en mètres)';
COMMENT ON COLUMN ep.geo_tronc.insee_tronc IS 'Code INSEE de la commune sur laquelle se trouve le réseau';
COMMENT ON COLUMN ep.geo_tronc.arm_tronc IS 'Armoire reliée au tronçon';
COMMENT ON COLUMN ep.geo_tronc.fonction_tronc IS 'Fonction du tronçon';
COMMENT ON COLUMN ep.geo_tronc.typeres_tronc IS 'Type de réseau du tronçon';
COMMENT ON COLUMN ep.geo_tronc.typegaine_tronc IS 'Type de gaine du tronçon';
COMMENT ON COLUMN ep.geo_tronc.typecable_tronc IS 'Type de cable du tronçon';
COMMENT ON COLUMN ep.geo_tronc.origeoloc_tronc  IS 'Qualité de l''information de géoréférencement d''un équipement';
COMMENT ON COLUMN ep.geo_tronc.qualglocxy_tronc IS 'Classe de précision pour le géoréférencement planimétrique au sens de l''arrêté interministériel du 15 février 2012 modifié (DT-DICT)';
COMMENT ON COLUMN ep.geo_tronc.qualglocz_tronc  IS 'Classe de précision pour le géoréférencement altimétrique au sens de l''arrêté interministériel du 15 février 2012 modifié (DT-DICT)';
COMMENT ON COLUMN ep.geo_tronc.geom IS 'Géométrie linéaire de l''objet';

--ALTER TABLE ep.geo_tronc ALTER COLUMN id_tronc SET DEFAULT nextval('ep.ep_idtronc'::regclass);


-- Table: ep.geo_noeud
-- DROP TABLE ep.geo_noeud;
CREATE TABLE ep.geo_noeud
(
  id_noeud character varying(100) NOT NULL,
  idgce_noeud integer,
  adrue_noeud character varying(100),
  x_noeud numeric (10,3),
  y_noeud numeric (10,3),
  z_noeud numeric (7,2),
  prof_noeud numeric (5,2),
  insee_noeud character varying(5),
  origeoloc_noeud character varying(2),
  qualglocxy_noeud character varying(2),
  qualglocz_noeud character varying(2),
  id_tronc character varying(100),
  geom geometry(Point,3948),
  CONSTRAINT geo_noeud_pkey PRIMARY KEY (id_noeud)  
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE ep.geo_noeud
  IS 'Noeuds du réseau d''éclairage public';
COMMENT ON COLUMN ep.geo_noeud.id_noeud  IS 'Identifiant du noeud du réseau';
COMMENT ON COLUMN ep.geo_noeud.idgce_noeud IS 'Identifiant d''origine du point issu de geoconcept';
COMMENT ON COLUMN ep.geo_noeud.adrue_noeud IS 'Adresse approximative du noeud';
COMMENT ON COLUMN ep.geo_noeud.x_noeud IS 'Coordonnées x du noeud';
COMMENT ON COLUMN ep.geo_noeud.y_noeud IS 'Coordonnées y du noeud';
COMMENT ON COLUMN ep.geo_noeud.z_noeud IS 'Coordonnées z du noeud';
COMMENT ON COLUMN ep.geo_noeud.prof_noeud IS 'Profondeur du noeud par rapport à la surface du sol';
COMMENT ON COLUMN ep.geo_noeud.insee_noeud IS 'Code INSEE de la commune sur laquelle se trouve le noeud';
COMMENT ON COLUMN ep.geo_noeud.origeoloc_noeud  IS 'Qualité de l''information de géoréférencement du noeud';
COMMENT ON COLUMN ep.geo_noeud.qualglocxy_noeud IS 'Classe de précision pour le géoréférencement planimétrique au sens de l''arrêté interministériel du 15 février 2012 modifié (DT-DICT)';
COMMENT ON COLUMN ep.geo_noeud.qualglocz_noeud  IS 'Classe de précision pour le géoréférencement altimétrique au sens de l''arrêté interministériel du 15 février 2012 modifié (DT-DICT)';
COMMENT ON COLUMN ep.geo_noeud.id_tronc IS 'Identifiant du tronçon auquel appartient le noeud';
COMMENT ON COLUMN ep.geo_noeud.geom IS 'Géométrie linéaire de l''objet';

--ALTER TABLE ep.geo_noeud ALTER COLUMN id_noeud SET DEFAULT nextval('ep.ep_idnoeud'::regclass);


-- Table: ep.objet
-- DROP TABLE ep.objet;
CREATE TABLE ep.objet
(
  id_objet character varying(100) NOT NULL,
  idsimpl_objet character varying(50),
  datemaj_objet date,
  observation_objet character varying(254),
  gestionnaire_objet character varying(100),
  proprietaire_objet character varying(100),
  anpose_objet date,
  dim_objet character varying(50),
  photo_objet character varying(254),
  angle_objet numeric(5,2),
  sourattrib_objet character varying(50),
  materiau_objet character varying(5),
  access_objet character varying(1),
  etat_objet character varying(2),
  type_objet character varying(2),
  id_noeud character varying(100),
  id_tronc character varying(100),
  id_plan integer,
  CONSTRAINT objet_pkey PRIMARY KEY (id_objet)  
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE ep.objet
  IS 'Objets ponctuels faisant partie du réseau d''éclairage public';
COMMENT ON COLUMN ep.objet.id_objet IS 'Identifiant de l''objet';
COMMENT ON COLUMN ep.objet.idsimpl_objet IS 'Identifiant simplifié de l''objet facilement lisible , composé d''une numérotation continue par type d''objet et du code fantoir de la rue';
COMMENT ON COLUMN ep.objet.datemaj_objet IS 'Date de mlise à jour des attributs de l''objet';
COMMENT ON COLUMN ep.objet.observation_objet IS 'Commentaire sur l''objet';
COMMENT ON COLUMN ep.objet.gestionnaire_objet IS 'Gestionnaire de l''objet';
COMMENT ON COLUMN ep.objet.proprietaire_objet IS 'Propriétaire de l''objet';
COMMENT ON COLUMN ep.objet.anpose_objet IS 'Année de pose de l''objet';
COMMENT ON COLUMN ep.objet.dim_objet IS 'Dimension de l''objet en cm (...x...x...)';
COMMENT ON COLUMN ep.objet.photo_objet IS 'Lien vers une photo de l''objet';
COMMENT ON COLUMN ep.objet.angle_objet IS 'Valeur de l''angle permettant la rotation du symbole de l''objet';
COMMENT ON COLUMN ep.objet.sourattrib_objet IS 'Source des données attributaires';
COMMENT ON COLUMN ep.objet.materiau_objet IS 'Matériau de l''objet';
COMMENT ON COLUMN ep.objet.access_objet IS 'Accessibilité de l''objet (O/N)';
COMMENT ON COLUMN ep.objet.etat_objet IS 'Etat de l''objet';
COMMENT ON COLUMN ep.objet.type_objet IS 'Type d''objet';
COMMENT ON COLUMN ep.objet.id_noeud IS 'Identifiant du noeud auquel est rattaché l''objet';
COMMENT ON COLUMN ep.objet.id_tronc IS 'Identifiant du tronc auquel est rattaché l''objet';
COMMENT ON COLUMN ep.objet.id_plan IS 'Identifiant faisant référence au plan d''origine de l''objet';

--ALTER TABLE ep.objet ALTER COLUMN id_objet SET DEFAULT nextval('ep.ep_idobjet'::regclass);

-- Table: ep.support
-- DROP TABLE ep.support;
CREATE TABLE ep.support
(
  id_support character varying(100) NOT NULL,
  modele_support character varying (100),
  nbfoyer_support integer,
  depart_support integer,
  typeboitier_support character varying(100),
  hauteur_support numeric (4,2),
  ral_support integer,
  zonage_support character varying (2),
  massif_support character varying(2),
  regallumage_support character varying(2), 
  type_support character varying(2),
  forme_support character varying(2),
  protectpied_support character varying(1),
  protec_support character varying(2),
  terre_support character varying(1),
  arm_support character varying (50),
  id_objet character varying(100),
  CONSTRAINT support_pkey PRIMARY KEY (id_support)  
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE ep.support
  IS 'Support faisant partie du réseau d''éclairage public';
COMMENT ON COLUMN ep.support.id_support IS 'Identifiant du support';
COMMENT ON COLUMN ep.support.modele_support IS 'Modèle du support';
COMMENT ON COLUMN ep.support.nbfoyer_support IS 'Nombre de foyer du support';
COMMENT ON COLUMN ep.support.depart_support IS 'Référence du départ lié au support';
COMMENT ON COLUMN ep.support.typeboitier_support IS 'Marque et type de boîte de raccordement';
COMMENT ON COLUMN ep.support.hauteur_support IS 'Hauteur du support en mètres';
COMMENT ON COLUMN ep.support.ral_support IS 'Code RAL du support';
COMMENT ON COLUMN ep.support.zonage_support IS 'Zone spécifique de gestion dans laquelle se trouve le support';
COMMENT ON COLUMN ep.support.massif_support IS 'Type de massif associé au support';
COMMENT ON COLUMN ep.support.regallumage_support IS 'Régime d''allumage du support';
COMMENT ON COLUMN ep.support.type_support IS 'Type de support';
COMMENT ON COLUMN ep.support.forme_support IS 'Forme du support';
COMMENT ON COLUMN ep.support.protectpied_support IS 'Présence d''une protection au pied du support (O/N)';
COMMENT ON COLUMN ep.support.protec_support IS 'Protection éléctrique du support (par ex. présence d''un disjoncteur)';
COMMENT ON COLUMN ep.support.terre_support IS 'Mise à la terre du support (O/N)';
COMMENT ON COLUMN ep.support.arm_support IS 'Armoire de rattachement du support';
COMMENT ON COLUMN ep.support.id_objet IS 'Identifiant de l''objet auquel est rattaché le support';

--ALTER TABLE ep.support ALTER COLUMN id_support SET DEFAULT nextval('ep.ep_idsupport'::regclass);

-- Table: ep.pointlumineux
-- DROP TABLE ep.pointlumineux;
CREATE TABLE ep.pointlumineux
(
  id_pl character varying(100) NOT NULL,
  marque_pl character varying(2),
  modele_pl character varying (100),
  type_pl character varying(2),
  ral_pl integer,
  class_pl character varying(2),
  typebal_pl character varying(2),
  typesour_pl character varying(2),
  refsour_pl character varying(50),
  couleursour_pl integer,
  puisour_pl integer,
  culosour_pl character varying(50),
  typefix_pl character varying(2),
  modelefix_pl character varying(50),
  hauteur_pl numeric (4,2),
  saillie_pl numeric (4,2),
  etat_pl character varying(2),
  dateposebal_pl date,
  dateposesour_pl date,
  id_support character varying(100),
  CONSTRAINT pl_pkey PRIMARY KEY (id_pl)  
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE ep.pointlumineux
  IS 'Point lumineux associé à un support';
COMMENT ON COLUMN ep.pointlumineux.id_pl IS 'Identifiant du point lumineux';
COMMENT ON COLUMN ep.pointlumineux.marque_pl IS 'Marque du point lumineux';
COMMENT ON COLUMN ep.pointlumineux.modele_pl IS 'Modèle du point lumineux';
COMMENT ON COLUMN ep.pointlumineux.type_pl IS 'Type de point lumineux (ouvert/fermé)';
COMMENT ON COLUMN ep.pointlumineux.ral_pl IS 'Code RAL du point lumineux';
COMMENT ON COLUMN ep.pointlumineux.class_pl IS 'Classe électrique du point lumineux';
COMMENT ON COLUMN ep.pointlumineux.typebal_pl IS 'Type de ballast';
COMMENT ON COLUMN ep.pointlumineux.typesour_pl IS 'Type de source lumineuse';
COMMENT ON COLUMN ep.pointlumineux.refsour_pl IS 'Référence de la source lumineuse';
COMMENT ON COLUMN ep.pointlumineux.couleursour_pl IS 'Couleur de la source lumineuse. Température en Kelvin';
COMMENT ON COLUMN ep.pointlumineux.puisour_pl IS 'Puissance de la source lumineuse en Watt';
COMMENT ON COLUMN ep.pointlumineux.culosour_pl IS 'Type de culot de la source lumineuse';
COMMENT ON COLUMN ep.pointlumineux.typefix_pl IS 'Type de fixation du point lumineux';
COMMENT ON COLUMN ep.pointlumineux.modelefix_pl IS 'Modèle de fixation du point lumineux';
COMMENT ON COLUMN ep.pointlumineux.hauteur_pl IS 'Hauteur du point lumineux en mètres';
COMMENT ON COLUMN ep.pointlumineux.saillie_pl IS 'Distance traduisant le décalage entre le point lumineux et le support en mètres';
COMMENT ON COLUMN ep.pointlumineux.etat_pl IS 'Etat propre au point lumineux';
COMMENT ON COLUMN ep.pointlumineux.dateposebal_pl IS 'Date de pose du ballast';
COMMENT ON COLUMN ep.pointlumineux.dateposesour_pl IS 'Date de pose de la source lumineuse';
COMMENT ON COLUMN ep.pointlumineux.id_support IS 'Identifiant du support auquel est rattaché le point lumineux';

--ALTER TABLE ep.pointlumineux ALTER COLUMN id_pl SET DEFAULT nextval('ep.ep_idpl'::regclass);

-- Table: ep.armoire
-- DROP TABLE ep.armoire;
CREATE TABLE ep.armoire
(
  id_armoire character varying(100) NOT NULL,
  puissancesou_armoire numeric(4,2),
  puissanceth_armoire numeric(4,2),
  puissancemes_armoire numeric(4,2),
  nbdeplibre_armoire integer,
  nbdeptotal_armoire integer,
  typeferm_armoire character varying(2),
  typealim_armoire character varying(2),
  protection_armoire character varying(2), 
  typecompteur_armoire character varying(2),
  numcompteur_armoire integer,
  terre_armoire character varying(1),
  confip2x_armoire character varying(1),
  confcalibre_armoire character varying(1),
  differentiel_armoire character varying(1),
  commande_armoire character varying(2),
  num_pdl_armoire character varying(50),
  nomposte_armoire character varying(50),
  coupure_armoire character varying(1),
  fixation_armoire character varying(2),
  cosphi_armoire numeric(3,2),
  tarifedf_armoire character varying(2),
  tension_armoire character varying(2),
  id_objet character varying(100),
  CONSTRAINT armoire_pkey PRIMARY KEY (id_armoire)  
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE ep.armoire
  IS 'Armoire faisant partie du réseau d''éclairage public';
COMMENT ON COLUMN ep.armoire.id_armoire IS 'Identifiant de l''armoire';
COMMENT ON COLUMN ep.armoire.puissanceth_armoire IS 'Puissance théorique de l''armoire en kW';
COMMENT ON COLUMN ep.armoire.puissancemes_armoire IS 'Puissance mesurée de l''armoire en kW';
COMMENT ON COLUMN ep.armoire.nbdeplibre_armoire IS 'Nombre de départs libres de l''armoire';
COMMENT ON COLUMN ep.armoire.nbdeptotal_armoire IS 'Nombre total de départs de l''armoire';
COMMENT ON COLUMN ep.armoire.typeferm_armoire IS 'Type de fermeture de l''armoire';
COMMENT ON COLUMN ep.armoire.typealim_armoire IS 'Type d''alimentation de l''armoire';
COMMENT ON COLUMN ep.armoire.protection_armoire IS 'Protection générale de l''armoire';
COMMENT ON COLUMN ep.armoire.typecompteur_armoire IS 'Type de compteur de l''armoire';
COMMENT ON COLUMN ep.armoire.numcompteur_armoire IS 'Numéro de compteur de l''armoire';
COMMENT ON COLUMN ep.armoire.terre_armoire IS 'Mise à terre de l''armoire (O/N)';
COMMENT ON COLUMN ep.armoire.confip2x_armoire IS 'Conformité IP2X (O/N)';
COMMENT ON COLUMN ep.armoire.confcalibre_armoire IS 'Conformité du calibre de l''armoire (O/N)';
COMMENT ON COLUMN ep.armoire.differentiel_armoire IS 'Présence d''un disjoncteur différentiel dans l''armoire (O/N)';
COMMENT ON COLUMN ep.armoire.confcalibre_armoire IS 'Conformité du calibre de l''armoire (O/N)';
COMMENT ON COLUMN ep.armoire.commande_armoire IS 'Type de commande de l''armoire';
COMMENT ON COLUMN ep.armoire.num_pdl_armoire IS 'Numéroe PDL de l''armoire';
COMMENT ON COLUMN ep.armoire.nomposte_armoire IS 'Nom du poste qui contient l''armoire';
COMMENT ON COLUMN ep.armoire.coupure_armoire IS 'Possibilité de couper le courant dans l''armoire (O/N)';
COMMENT ON COLUMN ep.armoire.fixation_armoire IS 'Type de fixation de l''armoire';
COMMENT ON COLUMN ep.armoire.cosphi_armoire IS 'Cosphi de l''armoire';
COMMENT ON COLUMN ep.armoire.tarifedf_armoire IS 'Tarif fixé par EDF pour l''armoire';
COMMENT ON COLUMN ep.armoire.tension_armoire IS 'Tension présente dans l''armoire';
COMMENT ON COLUMN ep.armoire.id_objet IS 'Identifiant de l''objet auquel est rattachée l''armoire';

--ALTER TABLE ep.armoire ALTER COLUMN id_armoire SET DEFAULT nextval('ep.ep_idarmoire'::regclass);

-- Table: ep.chambre
-- DROP TABLE ep.chambre;
CREATE TABLE ep.chambre
(
  id_chambre character varying(100) NOT NULL,
  type_chambre character varying(2),
  couv_chambre character varying(2),
  class_couv_chambre character varying (2),
  id_objet character varying(100),
  CONSTRAINT chambre_pkey PRIMARY KEY (id_chambre)  
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE ep.chambre
  IS 'Chambre d''éclairage public';
COMMENT ON COLUMN ep.chambre.id_chambre IS 'Identifiant de la chambre';
COMMENT ON COLUMN ep.chambre.type_chambre IS 'Type de chambre';
COMMENT ON COLUMN ep.chambre.couv_chambre IS 'Type de couvercle recouvrant la chambre';
COMMENT ON COLUMN ep.chambre.class_couv_chambre IS 'Classification du couvercle de la chambre';
COMMENT ON COLUMN ep.chambre.id_objet IS 'Identifiant de l''objet auquel se rattache la chambre';

--ALTER TABLE ep.chambre ALTER COLUMN id_chambre SET DEFAULT nextval('ep.ep_idchambre'::regclass);

-- Table: ep.accessoire
-- DROP TABLE ep.accessoire;
CREATE TABLE ep.accessoire
(
  id_accessoire character varying(100) NOT NULL,
  type_accessoire character varying(2),
  details_accessoire character varying(100),
  id_support character varying(100),
  CONSTRAINT accessoire_pkey PRIMARY KEY (id_accessoire)  
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE ep.accessoire
  IS 'Accessoires associés aux supports d''éclairage public';
COMMENT ON COLUMN ep.accessoire.id_accessoire IS 'Identifiant de l''accessoire';
COMMENT ON COLUMN ep.accessoire.type_accessoire IS 'Type d''accessoire';
COMMENT ON COLUMN ep.accessoire.id_support IS 'Identifiant du support auquel se rattache l''accessoire';

--ALTER TABLE ep.accessoire ALTER COLUMN id_accessoire SET DEFAULT nextval('ep.ep_idaccessoire'::regclass);

-- Table: ep.mobilier
-- DROP TABLE ep.mobilier;
CREATE TABLE ep.mobilier
(
  id_mobilier character varying(100) NOT NULL,
  type_mobilier character varying(2),
  id_objet character varying(100),
  CONSTRAINT mobilier_pkey PRIMARY KEY (id_mobilier)  
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE ep.mobilier
  IS 'Mobilier associé au réseau d''éclairage public';
COMMENT ON COLUMN ep.mobilier.id_mobilier IS 'Identifiant du mobilier';
COMMENT ON COLUMN ep.mobilier.type_mobilier IS 'Type de mobilier';
COMMENT ON COLUMN ep.mobilier.id_objet IS 'Identifiant de l''objet auquel se rattache le mobilier';

--ALTER TABLE ep.mobilier ALTER COLUMN id_mobilier SET DEFAULT nextval('ep.ep_idmobilier'::regclass);

-- Table: ep.plan
-- DROP TABLE ep.plan;
CREATE TABLE ep.plan
(
  id_plan integer NOT NULL,
  nom_plan character varying(100),
  date_plan date,
  CONSTRAINT plan_pkey PRIMARY KEY (id_plan)  
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE ep.plan
  IS 'Plans intégrés dans le SIG, import depuis la base de données de gestion des plans';
COMMENT ON COLUMN ep.plan.id_plan IS 'Identifiant du plan';
COMMENT ON COLUMN ep.plan.nom_plan IS 'Nom du plan';
COMMENT ON COLUMN ep.plan.date_plan IS 'Année de réalisation du plan';

-- Table: ep.intervention
-- DROP TABLE ep.intervention;
CREATE TABLE ep.intervention
(
  id_intervention integer NOT NULL,
  type_intervention character varying(2),
  date_intervention date,
  auteur_intervention character varying (100),
  observation_intervention character varying (254),
  CONSTRAINT intervention_pkey PRIMARY KEY (id_intervention)  
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE ep.intervention
  IS 'Interventions réalisées sur des éléments de l''éclairage public';
COMMENT ON COLUMN ep.intervention.id_intervention IS 'Identifiant de l''intervention';
COMMENT ON COLUMN ep.intervention.type_intervention IS 'Type d''intervention';
COMMENT ON COLUMN ep.intervention.date_intervention IS 'Date de l''intervention';
COMMENT ON COLUMN ep.intervention.auteur_intervention IS 'Auteur de l''intervention';
COMMENT ON COLUMN ep.intervention.observation_intervention IS 'Commentaires et observations liés à l''intervention';

--ALTER TABLE ep.intervention ALTER COLUMN id_intervention SET DEFAULT nextval('ep.ep_idintervention'::regclass);

-- Table: ep.intervention_objet
-- DROP TABLE ep.intervention_objet;
CREATE TABLE ep.intervention_objet
(
  id_io integer NOT NULL,
  id_objet character varying(100),
  id_intervention integer,
  CONSTRAINT intervention_objet_pkey PRIMARY KEY (id_io)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE ep.intervention_objet
  IS 'Table de liaison entre les objets et les interventions réalisées sur des éléments de l''éclairage public';
COMMENT ON COLUMN ep.intervention_objet.id_io IS 'Identifiant intervention/objet';
COMMENT ON COLUMN ep.intervention_objet.id_objet IS 'Identifiant de l''objet ayant subit une intervention';
COMMENT ON COLUMN ep.intervention_objet.id_intervention IS 'Identifiant de l''intervention';


--ALTER TABLE ep.intervention_objet ALTER COLUMN id_io SET DEFAULT nextval('ep.ep_idio'::regclass);


-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                           FKEY (clé étrangère)                                                               ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################


ALTER TABLE ep.geo_tronc
  
  ADD CONSTRAINT val_commune_fkey FOREIGN KEY (insee_tronc)
      REFERENCES ep.val_commune (insee) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  ADD CONSTRAINT val_foncreseau_fkey FOREIGN KEY (fonction_tronc)
      REFERENCES ep.val_foncreseau (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  ADD CONSTRAINT val_origine_geoloc_fkey FOREIGN KEY (origeoloc_tronc)
      REFERENCES ep.val_origine_geoloc (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  ADD CONSTRAINT val_qualite_geoloc_xy_fkey FOREIGN KEY (qualglocxy_tronc)
      REFERENCES ep.val_qualite_geoloc (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,         
  ADD CONSTRAINT val_qualite_geoloc_z_fkey FOREIGN KEY (qualglocz_tronc)
      REFERENCES ep.val_qualite_geoloc (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,  	  
  ADD CONSTRAINT val_typeres_fkey FOREIGN KEY (typeres_tronc)
      REFERENCES ep.val_typeres (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  ADD CONSTRAINT val_typegaine_fkey FOREIGN KEY (typegaine_tronc)
      REFERENCES ep.val_typegaine (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,	  
  ADD CONSTRAINT val_typecable_fkey FOREIGN KEY (typecable_tronc)
      REFERENCES ep.val_typecable (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;	  

	   
	  
ALTER TABLE ep.geo_noeud
  
  ADD CONSTRAINT val_commune_fkey FOREIGN KEY (insee_noeud)
      REFERENCES ep.val_commune (insee) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  ADD CONSTRAINT val_origine_geoloc_fkey FOREIGN KEY (origeoloc_noeud)
      REFERENCES ep.val_origine_geoloc (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  ADD CONSTRAINT val_qualite_geoloc_xy_fkey FOREIGN KEY (qualglocxy_noeud)
      REFERENCES ep.val_qualite_geoloc (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,         
  ADD CONSTRAINT val_qualite_geoloc_z_fkey FOREIGN KEY (qualglocz_noeud)
      REFERENCES ep.val_qualite_geoloc (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,  	  	   
  ADD CONSTRAINT geo_tronc_fkey FOREIGN KEY (id_tronc)
      REFERENCES ep.geo_tronc(id_tronc) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;
	  
ALTER TABLE ep.objet
  
  ADD CONSTRAINT val_materiau_fkey FOREIGN KEY (materiau_objet)
      REFERENCES ep.val_materiau (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  ADD CONSTRAINT val_access_fkey FOREIGN KEY (access_objet)
      REFERENCES ep.val_boolean (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  ADD CONSTRAINT val_etat_fkey FOREIGN KEY (etat_objet)
      REFERENCES ep.val_etat (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,         
  ADD CONSTRAINT val_typeobjet_fkey FOREIGN KEY (type_objet)
      REFERENCES ep.val_typeobjet (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,  	  	   
  ADD CONSTRAINT geo_noeud_fkey FOREIGN KEY (id_noeud)
      REFERENCES ep.geo_noeud (id_noeud) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  ADD CONSTRAINT geo_tronc_fkey FOREIGN KEY (id_tronc)
      REFERENCES ep.geo_tronc(id_tronc) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  ADD CONSTRAINT plan_fkey FOREIGN KEY (id_plan)
      REFERENCES ep.plan (id_plan) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;	  
	  
ALTER TABLE ep.accessoire
  
  ADD CONSTRAINT val_typeaccessoire_fkey FOREIGN KEY (type_accessoire)
      REFERENCES ep.val_typeaccessoire (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  ADD CONSTRAINT support_fkey FOREIGN KEY (id_support)
      REFERENCES ep.support(id_support) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE ep.armoire
  
  ADD CONSTRAINT val_typeferm_fkey FOREIGN KEY (typeferm_armoire)
      REFERENCES ep.val_typeferm(code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  ADD CONSTRAINT val_typealim_fkey FOREIGN KEY (typealim_armoire)
      REFERENCES ep.val_typealim(code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  ADD CONSTRAINT val_protection_fkey FOREIGN KEY (protection_armoire)
      REFERENCES ep.val_typeprotec(code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,	  
  ADD CONSTRAINT val_typecompteur_fkey FOREIGN KEY (typecompteur_armoire)
      REFERENCES ep.val_typecompteur(code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,	  
  ADD CONSTRAINT val_terre_armoire_fkey FOREIGN KEY (terre_armoire)
      REFERENCES ep.val_boolean (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  ADD CONSTRAINT val_confip2x_armoire_fkey FOREIGN KEY (confip2x_armoire)
      REFERENCES ep.val_boolean (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,	  
  ADD CONSTRAINT val_confcalibre_armoire_fkey FOREIGN KEY (confcalibre_armoire)
      REFERENCES ep.val_boolean (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,		    
  ADD CONSTRAINT val_differentiel_armoire_fkey FOREIGN KEY (differentiel_armoire)
      REFERENCES ep.val_boolean (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,	
  ADD CONSTRAINT val_typecommande_fkey FOREIGN KEY (commande_armoire)
      REFERENCES ep.val_typecommande(code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  ADD CONSTRAINT val_coupure_armoire_fkey FOREIGN KEY (coupure_armoire)
      REFERENCES ep.val_boolean (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  ADD CONSTRAINT val_typefixation_fkey FOREIGN KEY (fixation_armoire)
      REFERENCES ep.val_typefixation(code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  ADD CONSTRAINT val_tarifedf_armoire_fkey FOREIGN KEY (tarifedf_armoire)
      REFERENCES ep.val_typetarif(code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,	  
  ADD CONSTRAINT val_tension_armoire_fkey FOREIGN KEY (tension_armoire)
      REFERENCES ep.val_tension(code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,	
  ADD CONSTRAINT objet_fkey FOREIGN KEY (id_objet)
      REFERENCES ep.objet(id_objet) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;	  
 
 ALTER TABLE ep.chambre
  
  ADD CONSTRAINT val_typechambre_fkey FOREIGN KEY (type_chambre)
      REFERENCES ep.val_typechambre (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  ADD CONSTRAINT val_couv_chambre_fkey FOREIGN KEY (couv_chambre)
      REFERENCES ep.val_typecouvercle(code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  ADD CONSTRAINT val_class_couv_chambre_fkey FOREIGN KEY (class_couv_chambre)
      REFERENCES ep.val_classecouvercle(code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,	  
  ADD CONSTRAINT objet_fkey FOREIGN KEY (id_objet)
      REFERENCES ep.objet(id_objet) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;	

 ALTER TABLE ep.intervention_objet
  ADD CONSTRAINT objet_fkey FOREIGN KEY (id_objet)
      REFERENCES ep.objet(id_objet) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  ADD CONSTRAINT intervention_fkey FOREIGN KEY (id_intervention)
      REFERENCES ep.intervention(id_intervention) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;	  

 ALTER TABLE ep.mobilier
  
  ADD CONSTRAINT val_typemobilier_fkey FOREIGN KEY (type_mobilier)
      REFERENCES ep.val_typemobilier (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  ADD CONSTRAINT objet_fkey FOREIGN KEY (id_objet)
      REFERENCES ep.objet(id_objet) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;
	  
 ALTER TABLE ep.pointlumineux
  
  ADD CONSTRAINT val_marquepl_fkey FOREIGN KEY (marque_pl)
      REFERENCES ep.val_marquepl (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  ADD CONSTRAINT val_typepl_fkey FOREIGN KEY (type_pl)
      REFERENCES ep.val_typepl (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  ADD CONSTRAINT val_classepl_fkey FOREIGN KEY (class_pl)
      REFERENCES ep.val_classepl (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  ADD CONSTRAINT val_typebalpl_fkey FOREIGN KEY (typebal_pl)
      REFERENCES ep.val_typebalpl (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  ADD CONSTRAINT val_typesourpl_fkey FOREIGN KEY (typesour_pl)
      REFERENCES ep.val_typesourpl (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  ADD CONSTRAINT val_etat_fkey FOREIGN KEY (etat_pl)
      REFERENCES ep.val_etat (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  ADD CONSTRAINT val_typefixationpl_fkey FOREIGN KEY (typefix_pl)
      REFERENCES ep.val_typefixationpl(code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,	  
  ADD CONSTRAINT support_fkey FOREIGN KEY (id_support)
      REFERENCES ep.support(id_support) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;
	  
 ALTER TABLE ep.support

  ADD CONSTRAINT val_zonagesupport_fkey FOREIGN KEY (zonage_support)
      REFERENCES ep.val_zonagesupport (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,  
  ADD CONSTRAINT val_massifsupport_fkey FOREIGN KEY (massif_support)
      REFERENCES ep.val_massifsupport (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  ADD CONSTRAINT val_regallumage_fkey FOREIGN KEY (regallumage_support)
      REFERENCES ep.val_regallumage (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  ADD CONSTRAINT val_typesupport_fkey FOREIGN KEY (type_support)
      REFERENCES ep.val_typesupport (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  ADD CONSTRAINT val_formesupport_fkey FOREIGN KEY (forme_support)
      REFERENCES ep.val_formesupport(code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,	 
  ADD CONSTRAINT val_protectpiedsupport_fkey FOREIGN KEY (protectpied_support)
      REFERENCES ep.val_boolean (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  ADD CONSTRAINT val_typeprotecsupport_fkey FOREIGN KEY (protec_support)
      REFERENCES ep.val_typeprotec (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  ADD CONSTRAINT val_terresupport_fkey FOREIGN KEY (terre_support)
      REFERENCES ep.val_boolean (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  ADD CONSTRAINT objet_fkey FOREIGN KEY (id_objet)
      REFERENCES ep.objet(id_objet) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;	

	  



-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                GESTION DES DROITS (GRANT)                                                    ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################

/*Gestion de l'accès aux tables à un rôle
--GRANT SELECT ON ALL TABLES IN SCHEMA ep TO SIG;
--GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA ep TO SIG;
*/
