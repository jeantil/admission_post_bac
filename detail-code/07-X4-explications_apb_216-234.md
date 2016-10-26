# Code fourni, lignes 216 à 234
```
-- c'est ok, on va générer. On commence par récupérer des infos en base
BEGIN
  X:='04';
  SELECT g_tg_cod, c_gp_flg_sel,
  g_ea_cod_ges, ja.c_ja_cod, c_tj_cod,
  NVL(g_ti_flh_sel, g_fr_flg_sel), c_gp_eta_cla
  INTO l_g_tg_cod, l_c_gp_flg_sel,
  l_g_ea_cod_ges, l_c_ja_cod, l_c_tj_cod,
  l_g_flh_sel, l_c_gp_eta_cla
  FROM g_for fr, g_tri_ins ti, c_jur_adm ja, c_grp gp
  WHERE ti.g_ti_cod=o_g_ti_cod
  AND ti.g_fr_cod_ins=fr.g_fr_cod
  AND ti.g_ti_cod=ja.g_ti_cod
  AND ja.c_ja_cod=gp.c_ja_cod
  AND gp.c_gp_cod=o_c_gp_cod;
  EXCEPTION
  WHEN NO_DATA_FOUND
    THEN mess_aff:='Erreur de traitement, la ligne groupe n''existe pas : c_gp_cod : '
    || o_c_gp_cod;
    ROLLBACK;
    RETURN 1;
END;
```

# Code mis en forme
Avec jointure
```
BEGIN
  X:='04';
  SELECT 
	gp.g_tg_cod, gp.c_gp_flg_sel, 
	ti.g_ea_cod_ges, ja.c_ja_cod, 
	ja.c_tj_cod, NVL(ti.g_ti_flh_sel, fr.g_fr_flg_sel), 
	gp.c_gp_eta_cla
  INTO 
	l_g_tg_cod, l_c_gp_flg_sel,
	l_g_ea_cod_ges, l_c_ja_cod, 
	l_c_tj_cod, l_g_flh_sel, 
	l_c_gp_eta_cla
  FROM 
	g_for fr 
	INNER JOIN g_tri_ins ti ON ti.g_fr_cod_ins=fr.g_fr_cod
	INNER JOIN c_jur_adm ja ON ti.g_ti_cod=ja.g_ti_cod
	INNER JOIN c_grp gp ON ja.c_ja_cod=gp.c_ja_cod
  WHERE 
	ti.g_ti_cod=o_g_ti_cod
	gp.c_gp_cod=o_c_gp_cod;
	
  EXCEPTION
  WHEN NO_DATA_FOUND
    THEN mess_aff:='Erreur de traitement, la ligne groupe n''existe pas : c_gp_cod : '
    || o_c_gp_cod;
    ROLLBACK;
    RETURN 1;
END;
```
		
# Explication détaillée
***CETTE PARTIE N'A PAS D'INFLUENCE SUR LA MANIERE DONT LE RANG EST AFFECTE A CHAQUE CANDIDAT***

A nouveau un cas de rupture du traitement, si on ne parvient pas à joindre les tables utilisées et à tester la présence de la formation et du groupe de formations. Informellement, les conditions suivantes doivent être cumulées : 
* le groupe de formation passé en paramètre doit exister dans la base, ainsi que la formation passée en paramètre ;
* le groupe possède un unique jury d'admission pour cette formation ;
* la formation (objet d'inscription) existe dans les formations.

Le message pourraît ne pas couvrir tous les cas qui mènent à un result set vide.

## Variable locales
Si les conditions sont satisfaites, les variables `l_g_tg_cod`, `l_c_gp_flg_sel`, `l_g_ea_cod_ges`, `l_c_ja_cod`, `l_c_tj_cod`, `l_g_flh_sel`, `l_c_gp_eta_cla` se voient affecter les valeurs sélectionnées.
* `l_g_tg_cod` : inutilisé ;
* `l_c_gp_flg_sel` : apparaît dans un message précédé de "Flag Sel" ;
* `l_g_ea_cod_ges` : code d'établissement, paramètre des trois fonctions de la fin mais inutilisé ailleurs ;
* `l_c_ja_cod` : code du jury d'admission, paramètre des trois fonctions de la fin mais inutilisé ailleurs ;
* `l_c_tj_cod` : indéterminé, paramètre des trois fonctions de la fin mais inutilisé ailleurs ;
* `l_g_flh_sel` : signifie probablement que le groupe ou la formation sont sélectifs. Le traitement sera interrompu à l'étape suivante.
* `l_c_gp_eta_cla` : l'état du classement pour ce groupe de formations. Mis à jour en fin de traitement.

# Résumé
Si la formation et le groupe doivent être trouvés et certaines informations récupérées dans la base pour continuer le traitement.