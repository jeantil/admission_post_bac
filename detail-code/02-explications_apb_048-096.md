# Code fourni, lignes 48 à 96
```
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
```

# Code mis en forme :
Il paraît plus naturel de faire un `LEFT JOIN` sur la table `a_voe`, et de mettre certaines valeurs à 0 lorsque la jointure ne s'est pas faite
```
-- classement aléatoire sur voeu 1 groupé relatif
CURSOR classement_aleatoire_efe IS
-- on traite d'abord les candidats AEFE s'il y en a
SELECT candidat.g_cn_cod,
	IFNULL(voeu.g_cn_cod, 0, voeu.a_ve_ord_vg_rel), -- Ordre du voeu avec voeux groupés relatifs licence, 0 si pas de voeu
	IFNULL(voeu.g_cn_cod, 0, voeu.a_ve_ord_aff), -- Ordre du voeu avec voeux groupé relatif licence et tous les autres voeux, 0 si pas de voeu
	IFNULL(voeu.g_cn_cod, 0, voeu.a_vg_ord), -- Ordre du sous-voeu dans le voeu groupé, 0 si pas de voeu
	DBMS_RANDOM.value(1,999999),
	i.i_ep_cod
FROM g_can candidat
INNER JOIN i_ins i ON i.g_cn_cod=candidat.g_cn_cod
INNER JOIN a_rec r ON i.g_ti_cod=r.g_ti_cod
LEFT JOIN a_voe voeu ON candidat.g_cn_cod=voeu.g_cn_cod AND r.g_ta_cod=voeu.g_ta_cod
WHERE 
	i.g_ti_cod=o_g_ti_cod
	AND i.g_gf_cod=o_c_gp_cod
	AND candidat.g_ic_cod > 0
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
```
		
# Questions en suspens 
* la question de l'absence de voeu pour cette formation, qui devrait mettre le candidat à la fin du classement, mais en fait le met apparemment avant les autres.
* quelle est la fonction de la table `a_rec`, liée au voeu et à l'inscription ?
* quand la variable `i_ins.i_is_val` est-elle mise à jour ?

# Explication détaillée
Il s'agit de construire un curseur sur un ensemble de candidats (`g_can`), inscriptions à des formations (`i_ins`), `a_rec` (?), voeux (`a_voe`) reliés entre eux.
IL FAUT PRÊTER ATTENTION AU FAIT QUE LES CANDIDATS SONT FILTRÉS À CE NIVEAU POUR DÉTERMINER CEUX POUR LESQUELS LE TRAITEMENT SUIVANT (ATTRIBUTION D'UN RANG) AURA LIEU.

## Explication préliminaire
Le code suivant est utilisé 4 fois (2 fois ici et 2 fois plus loin). C'EST UN FILTRE SUR LES CANDIDATS POUR LESQUELS LE TRAITEMENT AURA LIEU :

```
NOT EXISTS (SELECT 1 FROM c_can_grp
WHERE i.g_cn_cod=g_cn_cod,
AND i.g_gf_cod=c_gp_cod
AND i_ip_cod IN (4, 5))
```

La table `c_can_grp` contient la relation entre les candidats et les groupes. Si elle contient une correspondance entre notre groupe et un candidat avec un `c_can_grp.i_ip_cod` valant 4 (NC = non classé, typiquement lorsque le bac n'est pas validé) ou 5 (C = classé), c'est que ce candidat est déjà passé par les étapes suivantes (voir lignes 269 et suivantes). Un candidat pour lequel il existe une correspondance candidat-groupe mais pour lequel `i_ip_cod` vaut 6 (AC = à classer) est conservé.

Cela permet également de se prémunir contre les doublons éventuels au niveau des curseurs.

**Le code précédent exclut donc les candidats pour lesquels il y a eu affectation d'un rang dans un groupe, sauf s'ils sont encore "à classer"**.

## La relation entre candidats, inscriptions, reçus, voeux
La relation entre candidat et ordre du voeu est simple : elle se fait sur le `g_cn_cod`, le code du candidat. Cela permet de récupérer l'ordre de tous les voeux du candidat.

La suite est plus compliquée :
* CANDIDATS : seuls les candidats avec un `g_ic_cod` > 0 sont considérés (= il y a eu une inscriptions), et parmi ceux là seuls ceux qui ont passé un bac EFE.

* INSCRIPTIONS : on vérifie que le candidat possède au moins une inscription (`i.g_cn_cod=c.g_cn_cod`) qui satisfait les critères cumulatifs suivants :
    * c'est un dossier d'inscription qui concerne une formation passée en paramètre (`o_g_ti_cod` + `o_c_gp_cod`) ;
    * le dossier d'inscription est pointé reçu, mais pas encore classé ;
    * déjà mentionné : il n'y pas eu de rang attribué pour ce groupe et ce candidat, sauf si "à classer"
Le point surprenant est qu'on ne voit pas la mise à jour de `i_is_val` dans le code. Cela est peut-être réalisé dans une des fonctions de mise à jour du classement à la fin du code.

* A_REC : la table a_rec n'intervient pas au niveau des critères, mais de la jointure. On peut passer du candidat à l'ordre des voeux, en mettant des conditions sur le dossier d'inscription qui lie l'un à l'autre. Mais pour qu'un candidat soit considéré, il faut également que la formation correspondant au dossier d'inscription ait une correspondance dans `a_rec`, et que l'ordre des voeux ait une correspondance sur le `g_ta_cod` (table `g_tri_aff`) dans `a_rec`. La table pourrait représenter le fait d'être reçu à un diplôme qui permet de prétendre à une formation.

# Ordre de sélection des candidats
***ATTENTION, IL NE S'AGIT PAS DU RANG ATTRIBUE, MAIS D'UNE OPERATION PREALABLE.***

Ce sont les ordres de voeux, du plus petit au plus grand numéro d'ordre. Le tri est fait en comparant les candidats un à un selon les règles suivantes :
* le plus petit `voeu.a_ve_ord_vg_rel` est premier ;
* si `voeu.a_ve_ord_vg_rel` est identique, le plus petit `voeu.a_ve_ord_aff` est premier ;
* si `voeu.a_ve_ord_vg_rel` et `voeu.a_ve_ord_aff` sont identiques, le plus petit `voeu.a_vg_ord` est premier ;
* si `voeu.a_ve_ord_vg_rel`, `voeu.a_ve_ord_aff` et `voeu.a_vg_ord` sont identiques, un tirage au sort départage les candidats.

Les commentaires et le document transmis par l'EN en mai 2016 permettent de conclure que :
* `voeu.a_ve_ord_vg_rel` est le numéro d'ordre du voeu par rapport aux autres voeux groupés licence (= voeu portant sur une filière et une académie) ;
* `voeu.a_ve_ord_aff` est le numéro d'ordre absolu du voeu par rapport à tous les autres voeux ;
* `voeu.a_vg_ord` est le numéro d'ordre du voeu dans le groupe formé par le voeu groupé.

## Cas des candidats qui n'ont pas classé la formation
Les trois variables d'ordre de voeu sont mises à 0, donc *avant* les autres (cela a été noté plusieurs fois). Pour autant, il doit exister un mécanisme qui les exclus des autres candidats lors du couplage candidat-formation, afin de les mettre réellement en dernier.

## Points à noter 
1. puisque les valeurs de l'ordre des voeux (`voeu.a_ve_ord_vg_rel`, `voeu.a_ve_ord_aff`, `voeu.a_vg_ord`) sont inscrites dans la table a_voe, *rien n'empeche que des incohérences apparaissent dans la base*. On n'a pas la sécurité d'un `AUTO INCREMENT` sur une table de relation entre candidats et voeux qui viendrait en bout de course pour éviter qu'un candidat ait plusieurs voeux n°1. Par ailleurs, le modèle possède d'autres champs concernant l'ordre du voeu, ici inutilisés, qu'il serait intéressant de connaître.
2. Le nombre aléatoire n'est pas stocké mais généré à chaque passage. Impossible donc pour un candidat de savoir quel nombre le sort lui a accordé (problème de contrôle *a posteriori* ?).
3. Il peut y avoir collision entre deux nombres aléatoires identiques. En général, dans ce genre de cas, on réessaie de tirer des nombres aléatoires jusqu'à en trouver deux différents. Ici la collsion est possible, auquel cas l'ordre est fixé par le SGBD, pas l'algorithme.