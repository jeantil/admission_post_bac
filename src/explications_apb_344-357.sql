/* Code fourni, lignes 344 à 357 */
-- le classement est marqué terminé
Х:='11';
retour:=pk_new_classement_commun.MAJ_etat_classement(
  l_g_ea_cod_ges, o_g_ea_cod_ins, o_g_ti_cod,
  l_c_ja_cod, l_c_tj_cod, o_c_gp_cod,
  2, 5,
  login, type_login, mode_dev,
  confirm, saio, niр,
  0, indic,
  mess_err, mess_aff);
IF retour!=0
  THEN ROLLBACK;
  RETURN retour;
END IF;

/*
Explication détaillée :
La variable retour se voir affecter le valeur de retour de la fonction "pk_new_classement_commun.MAJ_etat_classement(...)" avec un lot de paramètres. Cette fonction a-t-elle des effets de bord ? Plutôt probable étant donné son nom (qui commence MAJ). Donc il est possible que la table c_can_grp, qui contient le rang c_cg_ran soit encore modifié à ce niveau, même si ça ne semble pas évident. La présence d'un login, paramètre de la fonction principale, plaide plutôt en faveur d'un accès à quelque chose de protégé (des tables de la même base ? Je ne connais pas assez Oracle pour le dire). D'après le commentaire, il s'aagit de marquer comme terminé le classement, ce qui doit nécessiter une habilitation.
En tout cas, si l'opération MAJ_etat_classement se passe mal (retour différent de 0), tout est annulé.
*/

