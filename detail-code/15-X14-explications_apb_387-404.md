# Code fourni, lignes 387 à 404
```
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
```

# Explication détaillée
***CETTE PARTIE N'A PAS D'INFLUENCE SUR LA MANIERE DONT LE RANG EST AFFECTE A CHAQUE CANDIDAT***

Mise à jour de la table des groupes. Pour le groupe passé en paramètre, et si `c_gp_eta_cla` (état du classement du groupe) vaut 2, la mise à jour suivante est réalisée :
* `c_gp_flg_cla_oto` est mis à 1 (un classement automatique a eu lieu) ;
* si `l_c_gp_eta_cla` (cf. ligne 221) est à 3, `c_gp_eta_cla` passe à 4 : le groupe de formations possède un classement des candidats. Sinon il n'est pas modifié.

Le bloc d'exception concerne l'ensemble de la fonction. Il produit un message d'erreur qui rappelle `X`, soit l'étape courante, la nature de l'erreur, le groupe et la formation. En cas d'erreur, annulation (`ROLLBACK`) et retour de la valeur -9.
