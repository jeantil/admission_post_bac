/* Code fourni, lignes 188 à 211 */
X:='03';
-- on vérifie que le classement ne soit pas déjà passé (pas de candidats classés dans c_can_grp)
BEGIN
  -- Si le groupe est non sélectif, aucun candidat ne doit avoir été traité
  SELECT DISTINCT 1
  INTO dummy
  FROM c_can_grp cg, c_grp g
  WHERE g.c_gp_cod=o_c_gp_cod
  AND g.c_gp_cod=cg.c_gp_cod
  AND NVL(c_gp_flg_sel, 0)=0
  UNION
  -- Si le groupe est sélecif ou à pré-requis, on peut avoir des Candidats NC ou AC
  SELECT DISTINCT 1
  FROM c_can_grp cg, c_grp g
  WHERE g.c_gp_cod=o_c_gp_cod
  AND g.c_gp_cod=cg.c_gp_cod
  AND NVL(c_gp_flg_sel, 0) IN (1, 2)
  AND i_ip_cod NOT IN (4, 6);
  mess_aff:='Un classement a déjà été saisi pour le groupe de cette formation :'
  ||o_g_ea_cod_ins||','||o_g_ti_cod||','|| o_c_gp_cod;
  ROLLBACK;
  RETURN 1;
  EXCEPTION WHEN NO_DATA_FOUND THEN NULL;   -- ok
END;

/* Code mis en forme :
Il paraît plus simple de faire un OR, puisque c'est un SELECT DISTINCT. A vérifier, ce type de refactoring est DELICAT !! */
-- DO NOT USE !!!
BEGIN
  SELECT DISTINCT 1 INTO dummy
  FROM c_can_grp cg INNER JOIN c_grp g ON g.c_gp_cod=cg.c_gp_cod
  WHERE g.c_gp_cod=o_c_gp_cod
  AND (
	NVL(c_grp.c_gp_flg_sel, 0)=0 -- groupe non séléctif
	OR
	NVL(c_grp.c_gp_flg_sel, 0) IN (1, 2) AND i_ip_cod NOT IN (4, 6) -- groupe sélectif et au moins un candidat non NC ou AC.
	);
  mess_aff:='Un classement a déjà été saisi pour le groupe de cette formation :'
  ||o_g_ea_cod_ins||','||o_g_ti_cod||','|| o_c_gp_cod;
  ROLLBACK;
  RETURN 1;
  EXCEPTION WHEN NO_DATA_FOUND THEN NULL;   -- ok
END;


/*
Explication détaillée :
Ce bloc de code rompt le traitement dans les cas suivants, en se fondant sur les tables c_grp (les groupes) et c_can_grp (lien n-n entre les candidats et les groupes). Si l'une des conditions suivantes est satisfaite, on arrête :
* le groupe o_c_gp_cod (paramètre de la fonction) est non sélectif (c_gp_flg_sel = 0), AU MOINS UN candidat et son code apparait dans les liens groupes-candidats. Cela signifie que le groupe a déjà été traité.
* le groupe est sélectif (c_gp_flg_sel = 1 ou 2), et on trouve AU MOINS UN candidat qui n'est pas NC ou AC (donc i_ip_cod = 5, classé). Cela signifie que le groupe a déjà été traité.

Deux remarques :
1. Cela parait un peu tard dans le script pour se poser la question, mais pourquoi pas ?
2. La valeur i_ip_cod a du être initialisée à 4 ou 6 pour les groupes sélectifs, mais ailleurs...

En résumé : on ne retraite pas un groupe déjà traité.
*/