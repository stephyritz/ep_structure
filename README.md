# Eclairage public - Structuration des données

Déploiement d'un modèle de données pour la gestion de l'éclairage public dans Postgresql. Travail réalisé pour la Communauté de Communes Cernay-Thann.

Cette série de scripts sql permet de traduire un modèle de données conceptuel en un système de tables relationnelles sous postgresql/postgis.

C'est une première étape nécessaire qui va offir un lieu de stockage aux données qui vont ensuite être importées depuis le SIG GeoConcept par le biais d'un job FME.

1. Le modèle conceptuel de données

![Slide1](https://user-images.githubusercontent.com/34446202/121888744-a2d96f00-cd18-11eb-87cb-2d706e343b57.jpg)



2. Le dictionnaire de données

Les tables et leurs contenus attributaires sont décrits à travers des fichiers .csv dans https://github.com/stephyritz/ep_structure/tree/main/dictionnaire_donnees

3. Les scripts permettant l'écriture des tables dans Postgresql

Il y a deux scripts publiés dans ce projet (https://github.com/stephyritz/ep_structure/tree/main/scripts_sql)

- "ep_init" permet de créer l'ensemble du schéma et des tables liées à la gestion de l'éclairage public. Il doit être executé dans une base de données précédemment créée.
- "ep_creatview" permet de générer des vues matérialisées dans un schema spécifique. L'idée est de pouvoir ensuite exploiter ces "vues" à travers un client lourd type QGIS ou par le biais d'application web.

Dans le processus général mis en place au sein de la Communauté de Communes Cernay-Thann, un job FME est executé entre ces deux scripts afin de populer la base de données à partir des données métiers qui sont stockées dans un autre logiciel SIG (GeoConcept).
