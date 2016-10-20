/* Code fourni, lignes 48 à 96 */
-- classement aléatoire sur voeu 1 groupé relatif

CURSOR classement_aleatoire_efe IS
-- on traite d'abord les candidats AEFE s'il y en a
SELECT c.g_cn_cod,

a_ve_ord_vg_rel, -- Ordre du voeu avec voeux groupés relatifs licence
a_ve_ord_aff,    -- Ordre du voeu avec voeux groupé relatif licence et tous les autres voeux
a_vg_ord,        -- Ordre du sous-voeu dans le voeu groupé
DBMS_RANDOM.value(1,999999),
i.i_ep_cod

FROM g_can c, i_ins i, a_rec r, a_voe v
WHERE i.g_ti_cod=o_g_ti_cod
AND g_gf_cod=o_c_gp_cod
AND i.g_cn_cod=c.g_cn_cod
AND c.g_ic_cod > 0
AND NVL(g_cn_flg_aefe, 0)=1 -- Bac EFE
AND i_ep_cod IN (2, 3)      -- Pointés recu (complet ou incomplet)
AND i.i_is_val=1            -- non encore classé
AND NOT EXISTS (SELECT 1 FROM c_can_grp
  WHERE i.g_cn_cod=g_cn_cod
  AND i.g_gf_cod=c_gp_cod
  AND i_ip_cod IN (4, 5))          -- Permet de récupérer les AC
AND i.g_ti_cod=r.g_ti_cod
AND c.g_cn_cod=v.g_cn_cod
AND r.g_ta_cod=v.g_ta_cod
UNION
-- les candidats EFE qui n'ont au final pas classé la formation dans leur liste ordonnée. Ils sont classé, mais en dernier.
SELECT c.g_cn_cod,
0,
0,
0,
DBMS_RANDOM.value(1,999999),
i.i_ep_cod
FROM g_can c, i_ins i, a_rec r
WHERE i.g_ti_cod=o_g_ti_cod
AND g_gf_cod=o_c_gp_cod
AND i.g_cn_cod=c.g_cn_cod
AND c.g_ic_cod > 0
AND NVL(g_cn_flg_aefe, 0)=1 -- BaC EFE
AND i_ep_cod IN (2, 3)      -- Pointés recu (complet ou incomplet)
AND i.i_is_val=1            -- non encore classé
-- non encore classé
AND NOT EXISTS (SELECT 1 FROM c_can_grp
  WHERE i.g_cn_cod=g_cn_cod
  AND i.g_gf_cod=c_gp_cod
  AND i_ip_cod IN (4, 5))   -- Permet de récupérer les AC
AND i.g_ti_cod=r.g_ti_cod
AND NOT EXISTS (SELECT 1 FROM a_voe v WHERE c.g_cn_cod=v.g_cn_cod AND r.g_ta_cod=v.g_ta_cod)
ORDER BY 2, 3, 4, 5;

/* Code mis en forme :
Il paraît plus simple de faire un LEFT JOIN sur la table a_voe, et de mettre certaines valeurs à 0 lorsque la jointure ne s'est pas faite */
-- DO NOT USE !!!
-- classement aléatoire sur voeu 1 groupé relatif
CURSOR classement_aleatoire_efe IS
-- on traite d'abord les candidats AEFE s'il y en a
SELECT c.g_cn_cod,
	(CASE WHEN v.g_cn_cod IS NULL THEN 0 ELSE a_ve_ord_vg_rel END), -- Ordre du voeu avec voeux groupés relatifs licence, 0 si pas de voeu
	(CASE WHEN v.g_cn_cod IS NULL THEN 0 ELSE a_ve_ord_aff END), -- Ordre du voeu avec voeux groupé relatif licence et tous les autres voeux, 0 si pas de voeu
	(CASE WHEN v.g_cn_cod IS NULL THEN 0 ELSE a_vg_ord END), -- Ordre du sous-voeu dans le voeu groupé, 0 si pas de voeu
	DBMS_RANDOM.value(1,999999),
	i.i_ep_cod
FROM g_can c 
INNER JOIN i_ins i ON i.g_cn_cod=c.g_cn_cod
INNER JOIN a_rec r ON i.g_ti_cod=r.g_ti_cod
LEFT JOIN ON a_voe v ON c.g_cn_cod=v.g_cn_cod AND r.g_ta_cod=v.g_ta_cod -- que se passe-t-il si l'un des deux est vrai (cela vaut pour le code initial également) ?
WHERE 
	i.g_ti_cod=o_g_ti_cod
	AND i.g_gf_cod=o_c_gp_cod
	AND c.g_ic_cod > 0
	AND NVL(g_cn_flg_aefe, 0)=1 -- Bac EFE
	AND i_ep_cod IN (2, 3) -- Pointés recu (complet ou incomplet)
	AND i.i_is_val=1 -- non encore classé
	AND NOT EXISTS (
		SELECT 1 FROM c_can_grp
		WHERE i.g_cn_cod=g_cn_cod
		AND i.g_gf_cod=c_gp_cod
		AND i_ip_cod IN (4, 5)
	) -- Permet de récupérer les AC
ORDER BY 2, 3, 4, 5;
		
/* Explication détaillée :
Il s'agit de construire un curseur sur un ensemble de candidats, inscriptions, rec ,, voeux. 

Explication préliminaire
------------------------
Le code suivant est utilisé 4 fois (2 fois ici et 2 fois plus loin) :

NOT EXISTS (SELECT 1 FROM c_can_grp
WHERE i.g_cn_cod=g_cn_cod -- i est la table des inscrits, 
AND i.g_gf_cod=c_gp_cod
AND i_ip_cod IN (4, 5))

La table "c_can_grp" contient tous les candidats déjà passés par les étapes suivantes, avec des c_can_grp.i_ip_cod valant 4 ou 5 pour chacun d'eux (voir lignes 269 et suivantes).
Le code suivant exclut donc les candidats déjà passés par la moulinette des lignes 269 et suivantes.

Critères de sélection des candidats
-----------------------------------
Les codes i_ins.g_ti_cod et i_ins.g_gf_cod correspondent aux paramètres o_g_ti_cod (formation ?) et o_c_gp_cod (groupe ?) de l'appel de la fonction. On retient (et ne retient que) les inscriptions dont le groupe et la formation correspondent. Le lien avec le candidat se fait sur le g_cn_cod.

Les condition sont cumulatives :
* g_can.g_ic_cod > 0 : ?? ;
* NVL(g_cn_flg_aefe, 0)=1 : le commentaire indique un bac EFE. g_cn_flg_aefe doit probablement appartenir à la table g_can ;
* i_ep_cod IN (2, 3) : le commentaire indique pointés recu (complet ou incomplet). i_ep_cod doit probablement appartenir à la table i_ins ;
* i.i_is_val=1 : le commentaire indique non encore classé. Même table. Mais la valeur n'est pas mise à jour dans le code fourni.
* pas un candidat déjà passé par la moulinette des lignes 269 et suivantes.

Résumé : il faut cumuler une inscrption à la formation et au groupe paramètres de la fonction, ne pas être déjà passé à la moulinette, deux conditions de forme (g_ic_cod > 0 et i_is_val=1) et surtout un Bac EFE et être pointé-reçu.

Le point surprenant est qu'on ne voit pas la mise à jour de i_is_val dans le code.

Ordre de sélection des candidats
--------------------------------
Ce sont les ordres de voeux, du plus petit au plus grand numéro d'ordre. Les voeux ayant un numéro 0 sont les derniers, ce qui tend à montrer que les numéros d'ordre sont négatifs (??). Le classement est fait en comparant les candidats un à un selon les règles suivantes :
* le plus petit numéro d'ordre du voeu avec voeux groupés relatifs licence (0 si pas de voeu) est premier ;
* si le numéro d'ordre du voeu avec voeux groupés relatifs licence est identique, le plus petit ordre du voeu avec voeux groupé relatif licence et tous les autres voeux (0 si pas de voeu) est premier ;
* si le numéro d'ordre du voeu avec voeux groupé relatif licence et tous les autres voeux est identique, le plus petit ordre du sous-voeu dans le voeu groupé (0 si pas de voeu) ;
* si le numéro d'ordre du sous-voeu dans le voeu groupé est identique, un tirage au sort départage les candidats.