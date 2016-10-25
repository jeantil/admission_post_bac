/* Code fourni, lignes 387 à 404 */
-- on indique que le classement est fait de manière automatique
-- et on gère le cas particulier des AC/NC eta_cla passe de 3 à 4

X:='14';
UPDATE c_grp SET c_gp_flg_cla_oto=1,
c_gp_eta_cla=DECODE(l_c_gp_eta_cla, 3, 4, c_gp_eta_cla)
WHERE c_gp_cod=o_c_gp_cod
AND c_gp_eta_cla=2;
COMMIT;
RETURN 0;
EXCEPTION
WHEN OTHERS
  THEN mess_err:='pk_generation_classement.gen_class_alea_V1_relatif_grp X: ('||X||')'
  ||'Erreur ORACLE'||TO_CHAR(sqlcode)||''||sqlerrm||' pour l''étab'
  ||o_g_ea_cod_ins||' et la formation'|| o_g_ti_cod||': '||o_c_gp_cod;
  ROLLBACK;
  RETURN -9;
END gen_class_alea_V1_relatif_grp;

/*
Explication détaillée :
Mise à jour de la table des groupes. Pour le groupe passé en paramètre, et si c_gp_eta_cla (état du classement du groupe) vaut 2, la mise à jour suivante est réalisée :
* c_gp_flg_cla_oto est mis à 1 ;
* si l_c_gp_eta_cla (cf. ligne 221) est à 3, c_gp_eta_cla passe à 4 (quelle est la différence entre les deux ?). Sinon il n'est pas modifié.

Cela signifie que c_gp_eta_cla a pu être modifié, probablement par une des fonctions en 11, 12 ou 13. 
S'il est passé de 3 (l_c_gp_eta_cla fixé à la ligne 221 d'après c_gp_eta_cla) à 2 (condition actuelle), alors on le met à 4 (??). S'il n'était pas à 3, il n'est pas modifié.

Le message d'erreur porte apparement sur l'ensemble du processus, avec un message d'erreur qui rappelle X, soit l'étape courante. En cas d'erreur, annulation (ROLLBACK) et retour de la valeur -9 
*/
