# Code fourni, lignes 359 à 372
```
-- On vérifie que le classement soit valide. la Trace est mise par cette PS
X:='12';
retour:=pk_new_classement_commun.valid_classement_def(
  l_g_ea_cod_ges, o_g_ea_cod_ins, o_g_ti_cod,
  l_c_ja_cod, l_c_tj_cod, o_c_gp_cod,
  5,
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
Comme au bloc précédent, la valeur retour prend la valeur de retour d'une fonction, `valid_classement_def(...)`. Le nom fait moins penser à un effet de bord, mais c'est à nouveau une possiblité.

A nouveau, si l'opération se passe mal (retour différent de 0), tout est annulé.
