# Code fourni, lignes 236 à 247
```
-- on vérifie les Conditions de traitement du groupe
IF IS_prod=0 -- Base de test
  OR -- Ou
  -- en prod pour les classements formation non sélectives ou les AEFE
  (IS_prod=1 AND indic=10 AND l_g_flh_sel=0)
  THEN NULL; -- on laisse passer. Dans tous les autre cas, c'est une erreur.
ELSE mess_aff:='On ne peut traiter ce type de classement aléatoire dans ces conditions :
  '||
  'ls_prod : ' || IS_prod || ', indic : ' || indic || 'Flag Sel : '|| l_c_gp_flg_sel;
  ROLLBACK;
  RETURN 1;
END IF;
```

# Explication détaillée
***CETTE PARTIE N'A PAS D'INFLUENCE SUR LA MANIERE DONT LE RANG EST AFFECTE A CHAQUE CANDIDAT***

Les principales parties de ce bloc ont déjà été vues.

On rompt le traitement si on est en prod (`IS_prod = 1` et, par définition, ligne 163, `indic=10`) et que `l_g_flh_sel` est null ou différent de 0. 

# Résumé
Il faut être soit sur le serveur de dev, soit en présence d'une formation non sélective.