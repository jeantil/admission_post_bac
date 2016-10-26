# Code fourni, lignes 374 à 385
```
X:='13';
retour:=pk_new_classement_commun.valid_classement_formation(
  l_g_ea_cod_ges, o_g_ea_cod_ins, o_g_ti_cod, 5,
  login, type_login, mode_dev,
  confirm, saio, niр,
  0, indic,
  mess_err, mess_aff);

IF retour!=0
  THEN ROLLBACK;
  RETURN retour;
END IF;
```

# Explication détaillée
Comme au bloc précédent, la valeur retour prend la valeur de retour d'une fonction, `valid_classement_formation(...)`. Le nom fait moins penser à un effet de bord, mais c'est à nouveau une possiblité.

Cela fait trois fonctions dont nous ignorons le fonctionnement (en plus de la fonction `six_voeu_L1` de la ligne 102) et qui peuvent éventuellement intervenir au niveau du rang (en tout cas rien n'interdit que ce soit le cas).
A nouveau, si l'opération se passe mal (retour différent de 0), tout est annulé.
