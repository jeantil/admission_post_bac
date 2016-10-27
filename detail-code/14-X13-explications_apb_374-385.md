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
***CETTE PARTIE N'A **EN PRINCIPE** PAS D'INFLUENCE SUR LA MANIERE DONT LE RANG EST AFFECTE A CHAQUE CANDIDAT***

Comme au bloc précédent, la valeur retour prend la valeur de retour d'une fonction, `valid_classement_formation(...)`.

A nouveau, si l'opération se passe mal (retour différent de 0), tout est annulé.

## Remarque
Cela fait trois fonctions dont nous ignorons le fonctionnement (en plus de la fonction `six_voeu_L1` de la ligne 102).

