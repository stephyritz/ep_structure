/*EP*/
/* Création de vues sur les données éclairage public*/
/* Objectif : Offrir la possibilité de visualiser les données globales dans GCE (impossible via des vues matéralisées) via des jointures entre tables relationnelles pour répondre aux enjeux de gestion par la Communauté de Commune Thann-Cernay (CCTC)*/
/*Auteur : Stéphane Ritzenthaler*/

/***************************************************************************************************************/
/******                                           SCHEMA                                               ******/
/**************************************************************************************************************/

CREATE SCHEMA IF NOT EXISTS ep_apps;
GRANT USAGE ON SCHEMA ep_apps TO "SIG";

/******************************************/
/*    VUE ARMOIRES    */
/******************************************/
CREATE VIEW ep_apps.EP_armoires AS
	SELECT
	o.id_objet,
    o.idsimpl_objet,
    o.datemaj_objet,
	o.observation_objet,
	o.gestionnaire_objet,
	o.anpose_objet,
	o.dim_objet,
    o.photo_objet,
    o.sourattrib_objet,
    o.materiau_objet,
	ma.valeur AS "materiau_v",
    CASE WHEN o.access_objet = 't' THEN 'Oui'
		 WHEN o.access_objet = 't' THEN 'Non'
		 ELSE 'Indéterminé' END AS "acces_v",
    o.etat_objet,
	eta.valeur AS "etat_v",
    o.type_objet,
	obj.valeur AS "typeobjet_v",
	CASE WHEN o.enservice_objet = 't' THEN 'Oui'
		 WHEN o.enservice_objet = 'f' THEN 'Non'
		 ELSE 'Indéterminé' END AS "enservice_v",
	o.id_plan,
	a.id_armoire,
	a.puissancesou_armoire,
    a.puissanceth_armoire,
    a.puissancemes_armoire,
    a.nbdeplibre_armoire,
    a.nbdeptotal_armoire,
    a.typeferm_armoire,
    a.typealim_armoire,
    a.protection_armoire, 
    a.typecompteur_armoire,
    a.numcompteur_armoire,
    a.terre_armoire,
    a.confip2x_armoire,
    a.confcalibre_armoire,
    a.differentiel_armoire,
    a.commande_armoire,
	com.valeur AS "commandearmoire_v",
    a.num_pdl_armoire,
    a.nomposte_armoire,
    a.coupure_armoire,
    a.fixation_armoire,
    a.cosphi_armoire,
    a.tarifedf_armoire,
    a.tension_armoire,
	n.id_noeud,
    n.idgce_noeud,
    n.adrue_noeud,
	n.x_noeud,
    n.y_noeud,
    n.z_noeud,
    n.prof_noeud,
    n.insee_noeud,
	ins.nom AS "ville_v",
    n.origeoloc_noeud,
	ori.valeur AS "originegeoloc_v",
    n.qualglocxy_noeud,
	xy.valeur AS "qualglocxy_v",
    n.qualglocz_noeud,
	z.valeur AS "qualglocz_v",
    n.id_tronc,
    n.geom
	
	FROM ep.armoire a 
	LEFT JOIN ep.objet o ON o.id_objet = a.id_objet
	LEFT JOIN ep.geo_noeud n ON o.id_noeud = n.id_noeud
	LEFT JOIN ep.val_materiau ma ON o.materiau_objet = ma.code
	LEFT JOIN ep.val_etat eta ON o.etat_objet = eta.code
	LEFT JOIN ep.val_typeobjet obj ON o.type_objet = obj.code
	LEFT JOIN ep.val_typecommande com ON a.commande_armoire = com.code
	LEFT JOIN ep.val_commune ins ON n.insee_noeud = ins.insee
	LEFT JOIN ep.val_origine_geoloc ori ON n.origeoloc_noeud = ori.code
	LEFT JOIN ep.val_qualite_geoloc xy ON n.qualglocxy_noeud = xy.code
	LEFT JOIN ep.val_qualite_geoloc z ON n.qualglocz_noeud = z.code

	ORDER BY o.id_objet;

COMMENT ON VIEW ep_apps.EP_armoires
  IS 'Vue permettant l''affichage des informations liées aux armoire du réseau d''éclairage public';

GRANT ALL ON TABLE ep_apps.EP_armoires TO "SIG";

/******************************************/
/*    VUE MOBILIER   */
/******************************************/
CREATE VIEW ep_apps.EP_mobiliers AS
	SELECT
	o.id_objet,
    o.idsimpl_objet,
    o.datemaj_objet,
	o.observation_objet,
	o.gestionnaire_objet,
	o.anpose_objet,
	o.dim_objet,
    o.photo_objet,
    o.sourattrib_objet,
    o.materiau_objet,
	ma.valeur AS "materiau_v",
    CASE WHEN o.access_objet = 't' THEN 'Oui'
		 WHEN o.access_objet = 't' THEN 'Non'
		 ELSE 'Indéterminé' END AS "acces_v",
    o.etat_objet,
	eta.valeur AS "etat_v",
    o.type_objet,
	obj.valeur AS "typeobjet_v",
	CASE WHEN o.enservice_objet = 't' THEN 'Oui'
		 WHEN o.enservice_objet = 'f' THEN 'Non'
		 ELSE 'Indéterminé' END AS "enservice_v",
	o.id_plan,
	m.id_mobilier,
	m.type_mobilier,
	mob.valeur AS "typemobilier_v",
	n.id_noeud,
    n.idgce_noeud,
    n.adrue_noeud,
	n.x_noeud,
    n.y_noeud,
    n.z_noeud,
    n.prof_noeud,
    n.insee_noeud,
	ins.nom AS "ville_v",
    n.origeoloc_noeud,
	ori.valeur AS "originegeoloc_v",
    n.qualglocxy_noeud,
	xy.valeur AS "qualglocxy_v",
    n.qualglocz_noeud,
	z.valeur AS "qualglocz_v",
    n.id_tronc,
    n.geom
	
	FROM ep.mobilier m 
	LEFT JOIN ep.objet o ON o.id_objet = m.id_objet
	LEFT JOIN ep.geo_noeud n ON o.id_noeud = n.id_noeud
	LEFT JOIN ep.val_materiau ma ON o.materiau_objet = ma.code
	LEFT JOIN ep.val_etat eta ON o.etat_objet = eta.code
	LEFT JOIN ep.val_typeobjet obj ON o.type_objet = obj.code
	LEFT JOIN ep.val_typemobilier mob ON m.type_mobilier = mob.code
	LEFT JOIN ep.val_commune ins ON n.insee_noeud = ins.insee
	LEFT JOIN ep.val_origine_geoloc ori ON n.origeoloc_noeud = ori.code
	LEFT JOIN ep.val_qualite_geoloc xy ON n.qualglocxy_noeud = xy.code
	LEFT JOIN ep.val_qualite_geoloc z ON n.qualglocz_noeud = z.code

	ORDER BY o.id_objet;

COMMENT ON VIEW ep_apps.EP_mobiliers
  IS 'Vue permettant l''affichage des informations liées aux mobiliers du réseau d''éclairage public';

GRANT ALL ON TABLE ep_apps.EP_mobiliers TO "SIG";

/******************************************/
/*    VUE CHAMBRES    */
/******************************************/
CREATE VIEW ep_apps.EP_chambres AS
	SELECT
	o.id_objet,
    o.idsimpl_objet,
    o.datemaj_objet,
	o.observation_objet,
	o.gestionnaire_objet,
	o.anpose_objet,
	o.dim_objet,
    o.photo_objet,
    o.sourattrib_objet,
    o.materiau_objet,
	ma.valeur AS "materiau_v",
    CASE WHEN o.access_objet = 't' THEN 'Oui'
		 WHEN o.access_objet = 't' THEN 'Non'
		 ELSE 'Indéterminé' END AS "acces_v",
    o.etat_objet,
	eta.valeur AS "etat_v",
    o.type_objet,
	obj.valeur AS "typeobjet_v",
	CASE WHEN o.enservice_objet = 't' THEN 'Oui'
		 WHEN o.enservice_objet = 'f' THEN 'Non'
		 ELSE 'Indéterminé' END AS "enservice_v",
	o.id_plan,
	c.id_chambre,
	c.type_chambre,
	cha.valeur AS "typechambre",
	c.couv_chambre,
	coc.valeur AS "typecouvercle",
	c.class_couv_chambre,
	ccc.valeur AS "classecouvercle",
	n.id_noeud,
    n.idgce_noeud,
    n.adrue_noeud,
	n.x_noeud,
    n.y_noeud,
    n.z_noeud,
    n.prof_noeud,
    n.insee_noeud,
	ins.nom AS "ville_v",
    n.origeoloc_noeud,
	ori.valeur AS "originegeoloc_v",
    n.qualglocxy_noeud,
	xy.valeur AS "qualglocxy_v",
    n.qualglocz_noeud,
	z.valeur AS "qualglocz_v",
    n.id_tronc,
    n.geom
	
	FROM ep.chambre c 
	LEFT JOIN ep.objet o ON o.id_objet = c.id_objet
	LEFT JOIN ep.geo_noeud n ON o.id_noeud = n.id_noeud
	LEFT JOIN ep.val_materiau ma ON o.materiau_objet = ma.code
	LEFT JOIN ep.val_etat eta ON o.etat_objet = eta.code
	LEFT JOIN ep.val_typeobjet obj ON o.type_objet = obj.code
	LEFT JOIN ep.val_typechambre cha ON c.type_chambre = cha.code
	LEFT JOIN ep.val_typecouvercle coc ON c.couv_chambre = coc.code
	LEFT JOIN ep.val_classecouvercle ccc ON c.class_couv_chambre = ccc.code
	LEFT JOIN ep.val_commune ins ON n.insee_noeud = ins.insee
	LEFT JOIN ep.val_origine_geoloc ori ON n.origeoloc_noeud = ori.code
	LEFT JOIN ep.val_qualite_geoloc xy ON n.qualglocxy_noeud = xy.code
	LEFT JOIN ep.val_qualite_geoloc z ON n.qualglocz_noeud = z.code

	ORDER BY o.id_objet;

COMMENT ON VIEW ep_apps.EP_chambres
  IS 'Vue permettant l''affichage des informations liées aux chambres du réseau d''éclairage public';

GRANT ALL ON TABLE ep_apps.EP_chambres TO "SIG";

/******************************************/
/*    VUE SUPPORTS    */
/******************************************/
CREATE VIEW ep_apps.EP_supports AS
	SELECT
	o.id_objet,
    o.idsimpl_objet,
    o.datemaj_objet,
	o.observation_objet,
	o.gestionnaire_objet,
	o.anpose_objet,
	o.dim_objet,
    o.photo_objet,
    o.sourattrib_objet,
    o.materiau_objet,
	ma.valeur AS "materiau_v",
    CASE WHEN o.access_objet = 't' THEN 'Oui'
		 WHEN o.access_objet = 't' THEN 'Non'
		 ELSE 'Indéterminé' END AS "acces_v",
    o.etat_objet,
	eta.valeur AS "etat_v",
    o.type_objet,
	obj.valeur AS "typeobjet_v",
	CASE WHEN o.enservice_objet = 't' THEN 'Oui'
		 WHEN o.enservice_objet = 'f' THEN 'Non'
		 ELSE 'Indéterminé' END AS "enservice_v",
	o.id_plan,
	s.id_support,
    s.modele_support,
    s.nbfoyer_support,
    s.depart_support,
    s.typeboitier_support,
    s.hauteur_support,
    s.ral_support,
    s.zonage_support,
	zon.valeur AS "zonage_v",
    s.massif_support,
	mas.valeur AS "typemassifsupport_v",
    s.regallumage_support,
	reg.valeur AS "regimeallumage_v",
    s.type_support,
	sup.valeur AS "typesupport_v",
    s.forme_support,
	fsup.valeur AS "formesupport_v",
    CASE WHEN s.protectpied_support = 't' THEN 'Oui'
		 WHEN s.protectpied_support = 't' THEN 'Non'
		 ELSE 'Indéterminé' END AS "protectpied_v",
    s.protec_support,
	pro.valeur AS "protectionsupport_v",
    CASE WHEN s.terre_support = 't' THEN 'Oui'
		 WHEN s.terre_support = 't' THEN 'Non'
		 ELSE 'Indéterminé' END AS "terre_v",
	s.arm_support,
	n.id_noeud,
    n.idgce_noeud,
    n.adrue_noeud,
	n.x_noeud,
    n.y_noeud,
    n.z_noeud,
    n.prof_noeud,
    n.insee_noeud,
	ins.nom AS "ville_v",
    n.origeoloc_noeud,
	ori.valeur AS "originegeoloc_v",
    n.qualglocxy_noeud,
	xy.valeur AS "qualglocxy_v",
    n.qualglocz_noeud,
	z.valeur AS "qualglocz_v",
    n.id_tronc,
    n.geom
	
	FROM ep.support s 
	LEFT JOIN ep.objet o ON o.id_objet = s.id_objet
	LEFT JOIN ep.geo_noeud n ON o.id_noeud = n.id_noeud
	LEFT JOIN ep.val_materiau ma ON o.materiau_objet = ma.code
	LEFT JOIN ep.val_etat eta ON o.etat_objet = eta.code
	LEFT JOIN ep.val_typeobjet obj ON o.type_objet = obj.code
	LEFT JOIN ep.val_zonagesupport zon ON s.zonage_support = zon.code
	LEFT JOIN ep.val_massifsupport mas ON s.massif_support = mas.code
	LEFT JOIN ep.val_regallumage reg ON s.regallumage_support = reg.code
	LEFT JOIN ep.val_typesupport sup ON s.type_support = sup.code
	LEFT JOIN ep.val_formesupport fsup ON s.forme_support = fsup.code
	LEFT JOIN ep.val_typeprotec pro ON s.protec_support = pro.code
	LEFT JOIN ep.val_commune ins ON n.insee_noeud = ins.insee
	LEFT JOIN ep.val_origine_geoloc ori ON n.origeoloc_noeud = ori.code
	LEFT JOIN ep.val_qualite_geoloc xy ON n.qualglocxy_noeud = xy.code
	LEFT JOIN ep.val_qualite_geoloc z ON n.qualglocz_noeud = z.code

	ORDER BY o.id_objet;

COMMENT ON VIEW ep_apps.EP_supports
  IS 'Vue permettant l''affichage des informations liées aux supports du réseau d''éclairage public';

GRANT ALL ON TABLE ep_apps.EP_supports TO "SIG";

/******************************************/
/*    VUE TRONCONS   */
/******************************************/

CREATE VIEW ep_apps.EP_troncons AS
	SELECT
	o.id_objet,
    o.idsimpl_objet,
    o.datemaj_objet,
	o.observation_objet,
	o.gestionnaire_objet,
	o.anpose_objet,
	o.dim_objet,
    o.photo_objet,
    o.sourattrib_objet,
    o.materiau_objet,
	ma.valeur AS "materiau_v",
    CASE WHEN o.access_objet = 't' THEN 'Oui'
		 WHEN o.access_objet = 't' THEN 'Non'
		 ELSE 'Indéterminé' END AS "acces_v",
    o.etat_objet,
	eta.valeur AS "etat_v",
    o.type_objet,
	obj.valeur AS "typeobjet_v",
	CASE WHEN o.enservice_objet = 't' THEN 'Oui'
		 WHEN o.enservice_objet = 'f' THEN 'Non'
		 ELSE 'Indéterminé' END AS "enservice_v",
	o.id_plan,
	t.id_tronc,
    t.idgce_tronc,
    t.adrue_tronc,
    t.longcalc_tronc,
    t.longmes_tronc,
    t.insee_tronc,
	ins.nom AS "ville_v",
    t.fonction_tronc,
	fon.valeur AS "fonction_v",
    t.typeres_tronc,
	res.valeur AS "typereseau_v",
    t.typegaine_tronc,
	gai.valeur AS "typegaine_v",
    t.typecable_tronc,
	cab.valeur AS "typecable_v",
    t.origeoloc_tronc,
	ori.valeur AS "originegeoloc_v",
    t.qualglocxy_tronc,
	xy.valeur AS "qualglocxy_v",
    t.qualglocz_tronc,
	z.valeur AS "qualglocz_v",
	t.arm_tronc,
    t.geom

	FROM ep.geo_tronc t 
	LEFT JOIN ep.objet o ON t.id_tronc = o.id_tronc
	LEFT JOIN ep.val_commune ins ON t.insee_tronc = ins.insee
	LEFT JOIN ep.val_materiau ma ON o.materiau_objet = ma.code
	LEFT JOIN ep.val_etat eta ON o.etat_objet = eta.code
	LEFT JOIN ep.val_typeobjet obj ON o.type_objet = obj.code
	LEFT JOIN ep.val_foncreseau fon ON t.fonction_tronc = fon.code
	LEFT JOIN ep.val_typeres res on t.typeres_tronc = res.code
	LEFT JOIN ep.val_typegaine gai ON t.typegaine_tronc = gai.code
	LEFT JOIN ep.val_typecable cab ON t.typecable_tronc = cab.code
	LEFT JOIN ep.val_origine_geoloc ori ON t.origeoloc_tronc = ori.code
	LEFT JOIN ep.val_qualite_geoloc xy ON t.qualglocxy_tronc = xy.code
	LEFT JOIN ep.val_qualite_geoloc z ON t.qualglocz_tronc = z.code

	ORDER BY t.id_tronc;

COMMENT ON VIEW ep_apps.EP_troncons
  IS 'Vue permettant l''affichage des informations liées aux tronçons du réseau d''éclairage public';

GRANT ALL ON TABLE ep_apps.EP_troncons TO "SIG";

/******************************************/
/*    VUE POINTS LUMINEUX   */
/******************************************/

CREATE VIEW ep_apps.EP_pointslumineux AS
	SELECT
	p.id_pl,
    p.marque_pl,
	mar.valeur AS "marquepl_v",
    p.modele_pl,
    p.type_pl,
	tpl.valeur AS "typepl_v",
    p.ral_pl,
    p.class_pl,
	cla.valeur AS "classepl_v",
	p.typebal_pl,
	bal.valeur AS "typeballast_v",
    p.typesour_pl,
	sou.valeur AS "typesourcelumiere_v",
    p.refsour_pl,
    p.couleursour_pl,
    p.puisour_pl,
	p.angle_pl,
    p.culosour_pl,
    p.typefix_pl,
	fix.valeur AS "typefixation_v",
    p.modelefix_pl,
    p.hauteur_pl,
    p.saillie_pl,
    p.etat_pl,
	etat.valeur AS "etatpl_v",
    p.dateposebal_pl,
    p.dateposesour_pl,
    p.id_support,
	o.id_objet,
    o.idsimpl_objet,
    o.datemaj_objet,
	o.observation_objet,
	o.gestionnaire_objet,
	o.anpose_objet,
	o.dim_objet,
    o.photo_objet,
    o.sourattrib_objet,
    o.materiau_objet,
	ma.valeur AS "materiau_v",
    CASE WHEN o.access_objet = 't' THEN 'Oui'
		 WHEN o.access_objet = 't' THEN 'Non'
		 ELSE 'Indéterminé' END AS "acces_v",
    o.etat_objet,
	eta.valeur AS "etat_v",
    o.type_objet,
	obj.valeur AS "typeobjet_v",
	CASE WHEN o.enservice_objet = 't' THEN 'Oui'
		 WHEN o.enservice_objet = 'f' THEN 'Non'
		 ELSE 'Indéterminé' END AS "enservice_v",
	o.id_plan,
    s.modele_support,
    s.nbfoyer_support,
    s.depart_support,
    s.typeboitier_support,
    s.hauteur_support,
    s.ral_support,
    s.zonage_support,
	zon.valeur AS "zonage_v",
    s.massif_support,
	mas.valeur AS "typemassifsupport_v",
    s.regallumage_support,
	reg.valeur AS "regimeallumage_v",
    s.type_support,
	sup.valeur AS "typesupport_v",
    s.forme_support,
	fsup.valeur AS "formesupport_v",
    CASE WHEN s.protectpied_support = 't' THEN 'Oui'
		 WHEN s.protectpied_support = 't' THEN 'Non'
		 ELSE 'Indéterminé' END AS "protectpied_v",
    s.protec_support,
	pro.valeur AS "protectionsupport_v",
    CASE WHEN s.terre_support = 't' THEN 'Oui'
		 WHEN s.terre_support = 't' THEN 'Non'
		 ELSE 'Indéterminé' END AS "terre_v",
	n.id_noeud,
    n.idgce_noeud,
    n.adrue_noeud,
	n.x_noeud,
    n.y_noeud,
    n.z_noeud,
    n.prof_noeud,
    n.insee_noeud,
	ins.nom AS "ville_v",
    n.origeoloc_noeud,
	ori.valeur AS "originegeoloc_v",
    n.qualglocxy_noeud,
	xy.valeur AS "qualglocxy_v",
    n.qualglocz_noeud,
	z.valeur AS "qualglocz_v",
    n.id_tronc,
    n.geom

	FROM ep.pointlumineux p
	LEFT JOIN ep.support s ON s.id_support = p.id_support
	LEFT JOIN ep.val_marquepl mar ON p.marque_pl = mar.code
	LEFT JOIN ep.val_typepl tpl ON p.type_pl = tpl.code
	LEFT JOIN ep.val_classepl cla ON p.class_pl = cla.code
	LEFT JOIN ep.val_typebalpl bal ON p.typebal_pl = bal.code
	LEFT JOIN ep.val_typesourpl sou ON p.typesour_pl = sou.code
	LEFT JOIN ep.val_typefixationpl fix ON p.typefix_pl = fix.code
	LEFT JOIN ep.val_etat etat ON p.etat_pl = etat.code
	LEFT JOIN ep.objet o ON o.id_objet = s.id_objet
	LEFT JOIN ep.geo_noeud n ON o.id_noeud = n.id_noeud
	LEFT JOIN ep.val_materiau ma ON o.materiau_objet = ma.code
	LEFT JOIN ep.val_etat eta ON o.etat_objet = eta.code
	LEFT JOIN ep.val_typeobjet obj ON o.type_objet = obj.code
	LEFT JOIN ep.val_zonagesupport zon ON s.zonage_support = zon.code
	LEFT JOIN ep.val_massifsupport mas ON s.massif_support = mas.code
	LEFT JOIN ep.val_regallumage reg ON s.regallumage_support = reg.code
	LEFT JOIN ep.val_typesupport sup ON s.type_support = sup.code
	LEFT JOIN ep.val_formesupport fsup ON s.forme_support = fsup.code
	LEFT JOIN ep.val_typeprotec pro ON s.protec_support = pro.code
	LEFT JOIN ep.val_commune ins ON n.insee_noeud = ins.insee
	LEFT JOIN ep.val_origine_geoloc ori ON n.origeoloc_noeud = ori.code
	LEFT JOIN ep.val_qualite_geoloc xy ON n.qualglocxy_noeud = xy.code
	LEFT JOIN ep.val_qualite_geoloc z ON n.qualglocz_noeud = z.code

	ORDER BY p.id_pl;

COMMENT ON VIEW ep_apps.EP_pointslumineux
  IS 'Vue permettant l''affichage des informations liées aux points lumineux du réseau d''éclairage public';

GRANT ALL ON TABLE ep_apps.EP_pointslumineux TO "SIG";

/******************************************/
/*    VUE ACCESSOIRES   */
/******************************************/

CREATE VIEW ep_apps.EP_accessoires AS
	SELECT
	a.id_accessoire,
	a.type_accessoire,
	acc.valeur AS "typeaccessoire_v",
	a.details_accessoire,
	a.id_support,
	o.id_objet,
    o.idsimpl_objet,
    o.datemaj_objet,
	o.observation_objet,
	o.gestionnaire_objet,
	o.anpose_objet,
	o.dim_objet,
    o.photo_objet,
    o.sourattrib_objet,
    o.materiau_objet,
	ma.valeur AS "materiau_v",
    CASE WHEN o.access_objet = 't' THEN 'Oui'
		 WHEN o.access_objet = 't' THEN 'Non'
		 ELSE 'Indéterminé' END AS "acces_v",
    o.etat_objet,
	eta.valeur AS "etat_v",
    o.type_objet,
	obj.valeur AS "typeobjet_v",
	CASE WHEN o.enservice_objet = 't' THEN 'Oui'
		 WHEN o.enservice_objet = 'f' THEN 'Non'
		 ELSE 'Indéterminé' END AS "enservice_v",
	o.id_plan,
    s.modele_support,
    s.nbfoyer_support,
    s.depart_support,
    s.typeboitier_support,
    s.hauteur_support,
    s.ral_support,
    s.zonage_support,
	zon.valeur AS "zonage_v",
    s.massif_support,
	mas.valeur AS "typemassifsupport_v",
    s.regallumage_support,
	reg.valeur AS "regimeallumage_v",
    s.type_support,
	sup.valeur AS "typesupport_v",
    s.forme_support,
	fsup.valeur AS "formesupport_v",
    CASE WHEN s.protectpied_support = 't' THEN 'Oui'
		 WHEN s.protectpied_support = 't' THEN 'Non'
		 ELSE 'Indéterminé' END AS "protectpied_v",
    s.protec_support,
	pro.valeur AS "protectionsupport_v",
    CASE WHEN s.terre_support = 't' THEN 'Oui'
		 WHEN s.terre_support = 't' THEN 'Non'
		 ELSE 'Indéterminé' END AS "terre_v",
	n.id_noeud,
    n.idgce_noeud,
    n.adrue_noeud,
	n.x_noeud,
    n.y_noeud,
    n.z_noeud,
    n.prof_noeud,
    n.insee_noeud,
	ins.nom AS "ville_v",
    n.origeoloc_noeud,
	ori.valeur AS "originegeoloc_v",
    n.qualglocxy_noeud,
	xy.valeur AS "qualglocxy_v",
    n.qualglocz_noeud,
	z.valeur AS "qualglocz_v",
    n.id_tronc,
    n.geom

	FROM ep.accessoire a
	LEFT JOIN ep.support s ON s.id_support = a.id_support
	LEFT JOIN ep.val_typeaccessoire acc ON a.type_accessoire = acc.code
	LEFT JOIN ep.objet o ON o.id_objet = s.id_objet
	LEFT JOIN ep.geo_noeud n ON o.id_noeud = n.id_noeud
	LEFT JOIN ep.val_materiau ma ON o.materiau_objet = ma.code
	LEFT JOIN ep.val_etat eta ON o.etat_objet = eta.code
	LEFT JOIN ep.val_typeobjet obj ON o.type_objet = obj.code
	LEFT JOIN ep.val_zonagesupport zon ON s.zonage_support = zon.code
	LEFT JOIN ep.val_massifsupport mas ON s.massif_support = mas.code
	LEFT JOIN ep.val_regallumage reg ON s.regallumage_support = reg.code
	LEFT JOIN ep.val_typesupport sup ON s.type_support = sup.code
	LEFT JOIN ep.val_formesupport fsup ON s.forme_support = fsup.code
	LEFT JOIN ep.val_typeprotec pro ON s.protec_support = pro.code
	LEFT JOIN ep.val_commune ins ON n.insee_noeud = ins.insee
	LEFT JOIN ep.val_origine_geoloc ori ON n.origeoloc_noeud = ori.code
	LEFT JOIN ep.val_qualite_geoloc xy ON n.qualglocxy_noeud = xy.code
	LEFT JOIN ep.val_qualite_geoloc z ON n.qualglocz_noeud = z.code

	ORDER BY a.id_accessoire;

COMMENT ON VIEW ep_apps.EP_accessoires
  IS 'Vue permettant l''affichage des informations liées aux accessoires du réseau d''éclairage public';

GRANT ALL ON TABLE ep_apps.EP_accessoires TO "SIG";