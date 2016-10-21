/* Code fourni, lignes 236 à 247 */
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

/*
Explication détaillée :
Les principales parties de ce bloc ont déjà été vues.
On rompt le traitement si on est en prod (IS_prod = 1 et, par définition, ligne 163, indic=10) et que l_g_flh_sel est null ou différent de 0. Pour mémoire, l_g_flh_sel vaut à ce point NVL(g_ti_flh_sel, g_fr_flg_sel), ce qui signifie peut-être que la formation n'est pas sélective (je manque d'infos métier à ce niveau).

Mais le message d'erreur concerne une autre variable, l_c_gp_flg_sel, qui a été initialisée dans le bloc précédent et qui marque un groupe sélectif.
*/
