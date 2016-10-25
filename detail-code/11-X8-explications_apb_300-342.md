# Code fourni, lignes 300 à 342
```
X:='08';

FOR c_rec IN class_aleatoire_autres_cddts
  LOOP    -- diplôme non validé => non classé
    IF c_rec.i_is_dip_val=1
      THEN BEGIN
      INSERT INTO c_can_grp (
        g_cn_cod, c_gp_cod,
        i_ip_cod, c_cg_ran)
      VALUES ( c_rec.g_cn_cod, o_c_gp_cod,4,NULL );
      EXCEPTION -- Si le candidat est déjà non classé, on ne met à jour
    WHEN UNIQUE_CONSTRAINT
      THEN NULL;
  END;
ELSE
  BEGIN
    Х:='09';
    INSERT INTO c_can_grp (g_cn_cod, c_gp_cod,
      i_ip_cod, c_cg_ran)
    VALUES (c_rec.g_cn_cod, o_c_gp_cod,5, i);
    EXCEPTION -- Si le candidat est déjà à classer, on ne met à jour
      WHEN UNIQUE_CONSTRAINT
        THEN X:='10';
        UPDATE c_can_grp
        SET i_ip_cod=5,
        c_cg_ran=i
        WHERE g_cn_cod=c_rec.g_cn_cod
        AND c_gp_cod=o_c_gp_cod
        AND i_ip_cod=6;
        IF SQL%ROWCOUNT!=1
          THEN
          mess_err:='pk_generation_classement.gen_class_alea_V1_relatif_grp X: ('||X||')'
          ||'Erreur traitement d''un candidat AC pour l''étab'
          || o_g_ea_cod_ins||' et la formation
          '|| o_g_ti_cod||': ' ||o_C_gp_cod||', le candidat ' || c_rec.g_Cn_Cod
          ||'et le groupe : '||o_c_gp_cod||', rg:'||i;
          ROLLBACK;
          RETURN -1;
    END IF;
  END;
  i:=i+1;
END IF;
END LOOP;
```

# Explication détaillée
Le fonctionnement de ce bloc est semblable à celui du bloc précédent. La variable i est conservée depuis ledit bloc, donc les EFE ont bien un rang inférieur aux autres.

Le traitement est le suivant :
* tous les candidats dont le diplôme n'est pas validé (`i_is_dip_val` = 1) se voient attribuer un état `i_ip_cod` 4, c'est-à-dire "à classer" et un rang nul (si possible).
* les autres candidats sont traités comme dans le bloc EFE, mais après les EFE. Pour mémoire :
	* si le lien entre le candidat et le groupe n'a pas été fait, on le fait en donnant le cn_cod (code d'inscription du candidat) et `gp_cod` (code du groupe, paramètre de la fonction), puis un `i_ip_cod` toujours à 5 et enfin le `c_cg_ran` (le rang) courant `i`.
	* si le lien a déjà été fait, et que le `i_ip_cod` est à 6 (candidat à classer), on met à jour ce lien avec le `i_ip_cod` à 5 et le rang courant. Ce qui signifie que le candidat a un rang plus élevé.
	* si le lien a dajà été fait, mais qu'on a un `i_ip_cod` différent de 6 (par ex. 5 si on avait un doublon dans le `SELECT` du curseur), on arrêté le traitement et `ROLLBACK`.
Après chaque candidat, le rang courant est incrémenté.

# Résumé
Trois types de cas peuvent se présenter : le diplôme n'est pas validé, le candidat devient AC (à classer), avec un rang indéfini. Sinon, soit le candidat n'est pas présent dans la table de liens entre candidats et groupes (auquel cas on lui donne le rang courant, selon l'ordre prévu ligne 96), soit le candidat est présent, mais c'est un candidat à classer, pas un candidat classé. Tout autre cas de figure annule le traitement.