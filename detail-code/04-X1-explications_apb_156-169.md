# Code fourni, lignes 156 à 169
```
  BEGIN
    SELECT DISTINCT 1 INTO dummy
    FROM all_catalog
    WHERE OWNER IN ('XXXXXX');
    -- on est en prod
    IS_prod:=1;
    -- on ne laisse passer qu'en indic = 10
    IF NVL(indic, 0) NOT IN (10)
      THEN mess_aff:='On ne peut forcer un classement sur la base d''exploitation.';
      ROLLBACK;
      RETURN 1;
  END IF;
  EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
END;
```

# Explication détaillée
Le `SELECT` sur la table all_catalog doit renvoyer zéro ou une ligne, selon que l'utilisateur courant a accès ou non aux tables possédées par 'XXXXXX' (modifié avant scan pour transmission PDF ?).
Il semble que 'XXXXXX' possède les tables sur le serveur de prod, mais pas sur celui de dev, ce qui est utilisé pour différencier les deux serveurs.
* Soit l'utilisateur a accès à ces tables, et on met `IS_prod` à `1`. Ensuite :
	* si le paramètre `indic` est nul ou différent de `10` : fin de la fonction principale;
	* sinon, on continue.
* Soit l'utilisateur n'y a pas accès, `NO_DATA_FOUND` et on continue (`IS_prod` à `0`).

# Résumé :
1. Hypothèse: sur le serveur de prod, 'XXXXXX' est propriétaire des tables utilisées, mais pas sur le serveur de dev.
2. Conséquence: si je suis sur le serveur de prod, que j'ai accès aux tables utilisées et que `indic` est à 10, alors la valeur `IS_prod` est `1`, sinon cette valeur est `0` ou bien la fonction principale s'arrête.

Par la suite, lorsque cette valeur est `1` (en prod), la fonction principale est arrêtée si la valeur de `l_g_flh_sel` à la ligne 240 est différente de 0 (on sait déjà que `indic` est à 10), c'est-à-dire avant toute modification des tables.