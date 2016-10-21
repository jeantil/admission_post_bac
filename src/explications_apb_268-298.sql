/* Code fourni, lignes 268 à 298 */
X:='61';
FOR c_rec IN classement_aleatoire_efe
  LOOP BEGIN
    INSERT INTO c_can_grp(
      g_cn_cod, c_gp_cod,
      i_ip_cod, c_cg_ran)
    VALUES (
      c_rec.g_cn_cod, o_c_gp_cod,
      5, i);
    EXCEPTION -- Si le candidat est déjà indiqué à classer, on met à jour le i_ip_cod et le rang sur la ligne existante
  WHEN UNIQUE_CONSTRAINT
    THEN
    X:='07';
    UPDATE c_can_grp
    SET i_ip_cod=5,
    c_cg_ran=i
    WHERE g_cn_cod=c_rec.g_cn_cod
    AND c_gp_cod=o_c_gp_cod
    AND i_ip_cod=6;
    IF SQL%ROWCOUNT!=1
      THEN mess_err:='pk_generation_classement.gen_class_alea_V1_relatif_grp
      X : (' || Х || ')'
      ||'Erreur traitement d''un candidat AC pour l''étab'
      || o_g_ea_cod_ins ||' et la formation '|| o_g_ti_cod||':'|| o_c_gp_cod ||', le candidat'||c_rec.g_cn_cod
      ||' et le groupe : '||o_c_gp_cod||', rg :'||i;
      ROLLBACK;
      RETURN -1;
  END IF;
END;
i:= i+1;
END LOOP;

/*
Explication détaillée :
Enfin on passe aux EFE, dans l'ordre des voeux croissants (cf. ligne 96). La variable i, qui sert à FIXER LE RANG de 1 à N, a été mise à 1 à la ligne 266.
On parcourt les candidats EFE, et on réalise les opérations suivates :
* si le lien entre le candidat et le groupe n'a pas été fait, on le fait en donnant le cn_cod (code d'inscription du candidat) et gp_cod (code du groupe, paramètre de la fonction), puis un i_ip_cod toujours à 5 (classé) et enfin le c_cg_ran (le rang) courant i.
* si le lien a déjà été fait, et que le i_ip_cod est à 6 (candidat à classer), on met à jour ce lien avec le i_ip_cod à 5 et le rang courant. On peut supposer que le rang était nul avant.
* si le lien a dajà été fait, mais qu'on a un i_ip_cod différent de 6 (par ex. 5 si on avait un doublon dans le SELECT du curseur), on arrêté le traitement et ROLLBACK.
Après chaque candidat, le rang courant est incrémenté.

En résumé, deux types de cas peuvent se présenter : le candidat n'est pas présent dans la table de liens entre candidats et groupes (auquel cas on lui donne le rang courant, selon l'ordre prévu ligne 96), soit le candidat est présent, mais c'est un candidat à classer, pas un candidat classé. Tout autre cas annule le traitement.

Après ce traitement, il est garanti que les candidats ne sont pas à classer, que les indices de rang se suivent. Il est possible d'avoir "recasé" des candidats à classer.
*/