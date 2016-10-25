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
	g_tg_cod, c_gp_flg_sel, 
	g_ea_cod_ges, ja.c_ja_cod, 
	c_tj_cod, NVL(g_ti_flh_sel, g_fr_flg_sel), 
	c_gp_eta_cla
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
A nouveau un cas de rupture du traitement, si on ne parvient pas à joindre les tables utilisées et à tester la présence de la formation et du groupe. Informellement, les conditions suivantes doivent être cumulées : 
* le groupe et la formation passés en paramètres possèdent une juridiction administrative identique ;
* `ti.g_fr_cod_ins=fr.g_fr_cod` : ???
Le message ne semble pas recouvrir tous les cas qui mènent à un result set vide.

Si les conditions sont satisfaites, les variables `l_g_tg_cod`, `l_c_gp_flg_sel`, `l_g_ea_cod_ges`, `l_c_ja_cod`, `l_c_tj_cod`, `l_g_flh_sel`, `l_c_gp_eta_cla` se voient affecter les valeurs sélectionnées.

A noter en particulier la valeur `NVL(g_ti_flh_sel, g_fr_flg_sel)` qui est affectée à `l_g_flh_sel`. Elle vaut `g_tri_ins.g_ti_flh_sel`, ou si cette valeur est nulle, `g_for.g_fr_flg_sel` (fonction `NVL`). Si cette valeur doit être à 0 pour que le code passe en prod. Cela signifie peut-être que la formation n'est pas sélective (je manque d'infos métier à ce niveau).

# Résumé
Si la formation et le groupe sont trouvés (à la fois dans les tables qui les contiennent et en tant que référence dans d'autres tables utiles), on continue le traitement.