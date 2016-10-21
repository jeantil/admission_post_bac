/* Code fourni, lignes 172 à 186 */
-- On vérifie si le groupe est issu d''une formation de type IDF 2, 3, 5 ou 6 et s'il concerné par des néo d'IDF
-- alors, on utilisera les six voeux dans le classement sur ordre des voeux
BEGIN
	Х:='02';
	SELECT 1
	INTO l_six_voe
	FROM g_tri_ins ti
	WHERE g_ti_cod=o_g_ti_cod
		AND NVL(g_ti_flg_rec_idf, 0) IN (2, 3, 5, 6)
		AND o_g_tg_cod IN (21, 25, 26, 41, 45, 46);
	EXCEPTION
	WHEN NO_DATA_FOUND
	THEN l_six_voe:=0; -- pour les autres groupes, on n'utilise pas les 6 voeux
END;

/* 
Explication détaillée :

Met la variable "l_six_voe" à 0 ou 1. Cette valeur ne dépend que du groupe et de la formation, PAS DU CANDIDAT.
On considère les lignes de la table `g_tri_ins` qui correspondent à la formation (paramètre o_g_ti_cod).
l_six_voe vaut 1 si les conditions cumulatives sont satisfaites :
* le paramètre de la fonction principale o_g_tg_cod est compris dans les valeurs 21,25,26,41,45,46 : d'après le commentaire, groupe néo concerné par des néo d'IDF (??).
* g_tri_ins.g_ti_flg_rec_idf est égale à 2,3,5,6 : d'après le commentaire, formation type idf.
Sinon le paramètre est à 0.

Ce paramètre joue un rôle important dans le tri des non EFE, puisqu'il active un tri sur la mystérieuse fonction "six_voeu_L1" de la ligne 102
*/