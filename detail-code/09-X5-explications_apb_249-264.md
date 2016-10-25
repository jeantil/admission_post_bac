# Code fourni, lignes 249 à 264
``` 
-- on vérifie l'état de pointage des dossiers sion est en prod, on est obligé d'accepter
-- des dossiers non reçus, pour les vérifs de diplômes
X:='05';
SELECT COUNT(*) INTO dummy
FROM i_ins i
WHERE g_ti_cod=o_g_ti_cod
AND g_gf_cod=o_c_gp_cod
AND i_is_val=1
AND i_ep_cod NOT IN (0, 2, 3, 7);

IF dummy > 0
  THEN mess_aff:='Pb, des dossiers ne sont pas pointés : étab :'
  || o_g_ea_cod_ins || ', for :' || o_g_ti_cod || ', grp : ' || o_c_gp_cod;
  ROLLBACK;
  RETURN 1;
END IF;
``` 

# Explication détaillée
A nouveau, rupture possible du traitement.

On compte les lignes de la table `i_ins` (inscriptions ?) qui correspondent à la formation et au groupe, pour lesquels `is_val` est à 1 (non encore classé, cf. ligne 44), mais `i_ep_code` n'est pas égal à 0,2,3,7. Selon le début du code, seuls les non encore classés sont traités (voir les conditions sur les définitions des curseurs). Or là on semble bloquer dès qu'un des ces non encore classés possède un i_ep_cod particulier. D'après le message d'erreur, cela note les dossiers non pointés.

# Résumé
Dès qu'un dossier non encore classé n'est pas pointé, on rompt le traitement.