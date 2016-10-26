# Code fourni, lignes 98 à 149
```
CURSOR class_aleatoire_autres_cddts IS
-- les candidats non classés par la requête ci-dessus : les autre bac que EEE

SELECT c.g_cn_cod,
DECODE(l_six_voe, 1, six_voeu_L1(c.g_cn_cod, g_aa_cod_bac_int, g_cn_flg_int_aca, o_g_tg_cod), 0),
a_ve_ord_vg_rel,  -- Ordre du voeu avec voeux groupés relatifs licence
a_ve_ord_aff,     -- Ordre du voeu avec Voeux groupé relatif licence et tous les autres voeux
a_vg_ord,         -- Ordre du sous-voeu dans le voeu groupé
DBMS_RANDOM.value(1,999999),
i.i_ep_cod,
i.i_is_dip_val    -- Pour ceux-ci on prend en plus en compte la validité du diplôme
FROM g_can c, i_ins i, a_rec r, a_voe v
WHERE i.g_ti_cod=o_g_ti_cod
AND i.g_gf_cod=o_c_gp_cod
AND i_ep_cod IN (2, 3)    -- Pointés recu (complet ou incomplet)
AND i.g_cn_cod=c.g_cn_cod
-- TODO2016 => Traiter les groupes néo-réeo ensemble différement (voir correction_classements_neo-reo.sql dans exploit/admissions/simulation/pb ponctuels)
AND c.g_ic_cod > 0
AND i.i_is_val=1
-- non encore classé
AND NOT EXISTS (SELECT 1 FROM c_can_grp
  WHERE i.g_cn_cod=g_cn_cod
  AND i.g_gf_cod=c_gp_cod
  AND i_ip_cod IN (4, 5)) -- Permet de récupérer les AC
AND i.g_ti_cod=r.g_ti_cod
AND c.g_cn_cod=v.g_cn_cod
AND r.g_ta_cod=v.g_ta_cod
UNION
-- les candidats qui n'ont au final pas classé la formation dans leur liste ordonnée. Ils sont classé, mais en dernier.
SELECT  c.g_cn_cod,
0,
0,
0,
0,
DBMS_RANDOM.value(1,999999),
i.i_ep_cod,
i.i_is_dip_val  -- Pour ceux-ci on prend en plus en compte la validité du diplôme
FROM g_can c, i_ins i, a_rec r
WHERE i.g_ti_cod=o_g_ti_cod
AND i.g_gf_cod=o_c_gp_cod
AND i_ep_cod IN (2, 3)  -- Pointés recu (complet ou incomplet)
AND i.g_cn_cod=c.g_cn_cod
AND c.g_ic_cod > 0
AND i.i_is_val=1
-- non encore classé
AND NOT EXISTS (SELECT 1 FROM c_can_grp
  WHERE i.g_cn_cod=g_cn_cod
  AND i.g_gf_cod=c_gp_cod
  AND i_ip_cod IN (4, 5)) -- Permet de récupérer les AC
AND i.g_ti_cod=r.g_ti_cod
AND NOT EXISTS (SELECT 1 FROM a_voe v WHERE c.g_cn_cod=v.g_cn_cod AND r.g_ta_cod=v.g_ta_cod)
ORDER BY 2 desc, 3, 4, 5, 6;
```

# Code mis en forme :
Il paraît plus naturel de faire un `LEFT JOIN` sur la table `a_voe`, et de mettre certaines valeurs à 0 lorsque la jointure ne s'est pas faite

```
CURSOR class_aleatoire_autres_cddts IS
	-- les candidats non classés par la requête ci-dessus : les autre bac que EEE
	SELECT c.g_cn_cod,
		DECODE(l_six_voe, 1, six_voeu_L1(c.g_cn_cod, g_aa_cod_bac_int, g_cn_flg_int_aca, o_g_tg_cod), 0),
		(CASE WHEN v.g_cn_cod IS NULL THEN 0 ELSE a_ve_ord_vg_rel END), -- Ordre du voeu avec voeux groupés relatifs licence
		(CASE WHEN v.g_cn_cod IS NULL THEN 0 ELSE a_ve_ord_aff END), -- Ordre du voeu avec Voeux groupé relatif licence et tous les autres voeux
		(CASE WHEN v.g_cn_cod IS NULL THEN 0 ELSE a_vg_ord END), -- Ordre du sous-voeu dans le voeu groupé
		DBMS_RANDOM.value(1,999999),
		i.i_ep_cod,
		i.i_is_dip_val -- Pour ceux-ci on prend en plus en compte la validité du diplôme
	FROM g_can c INNER JOIN i_ins i ON i.g_cn_cod=c.g_cn_cod
	INNER JOIN a_rec r ON i.g_ti_cod=r.g_ti_cod
	LEFT JOIN a_voe v ON c.g_cn_cod=v.g_cn_cod AND r.g_ta_cod=v.g_ta_cod
	WHERE 
		i.g_ti_cod=o_g_ti_cod
		AND i.g_gf_cod=o_c_gp_cod
		AND c.g_ic_cod > 0
		AND i_ep_cod IN (2, 3) -- Pointés recu (complet ou incomplet)
		-- TODO2016 => Traiter les groupes néo-réeo ensemble différement (voir correction_classements_neo-reo.sql dans exploit/admissions/simulation/pb ponctuels)
		AND i.i_is_val=1
		-- non encore classé
		AND NOT EXISTS (
			SELECT 1 FROM c_can_grp
			WHERE i.g_cn_cod=g_cn_cod
			AND i.g_gf_cod=c_gp_cod
			AND i_ip_cod IN (4, 5)
		) -- Permet de récupérer les AC
	ORDER BY 2 desc, 3, 4, 5, 6;
```
# Questions en suspens
* voir 02-explications_abp_048-096.md ;
* Quel est le code de la fonction `six_voeu_L1` ?
		
# Explication détaillée
**Remarque générale : *Voir l'explication sur 02-explications_abp_048-096.md***

## Remarques complémentaires
Les candidats EFE ne sont pas explicitement écartés, mais il le seront de fait au moment du parcours de ce curseur, du fait des enregistrements insérés dans la table `c_can_grp` (voir les explications sur le `NOT EXISTS` 02-explications_abp_048-096.md).

Même point surprenant que précédemment : on ne voit pas la mise à jour de i_is_val dans le code.

## Ordre de sélection des candidats
Il y a une différence importante avec les EFE : le groupe et la formation ont déterminé une valeur de `l_six_voe` (voir lignes 172 à 186). Si cette valeur vaut 1, on prend en compte une mystérieuse fonction `six_voeu_L1(c.g_cn_cod, g_aa_cod_bac_int, g_cn_flg_int_aca, o_g_tg_cod)` avant d'appliquer les mêmes règles que pour le EFE. Si cette valeur vaut 0, le tri suit les mêmes règles qu'auparavant.

# Résumé
Il y des formations et groupes pour lesquelles le tri est réalisé prioritairement sur la base d'une fonction absente du code fourni. Si la formation ne fait pas partie de cette catégorie, ou si les valeurs de cette fonction sont les mêmes pour deux candidats, ils seront triés par ordre de voeux comme les EFE.