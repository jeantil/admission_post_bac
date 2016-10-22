# Tous les mots du script apb.sql
Enumération et interprétation (lorsque c'est possible) de **tous** les mots présents dans le fichier apb.sql.

Mot | Type ou table de rattachement si champ | Signification | Commentaire | Validé par le schéma #29 (Nom du fichier)
--- | --- | --- | --- | ----
0 | nombre ||||
00001 | nombre ||||
1 | nombre ||||
10 | nombre ||||
2 | nombre ||||
21 | nombre ||||
25 | nombre ||||
26 | nombre ||||
3 | nombre ||||
4 | nombre ||||
41 | nombre ||||
45 | nombre ||||
46 | nombre ||||
5 | nombre ||||
6 | nombre ||||
7 | nombre ||||
9 | nombre ||||
999999 | nombre ||||
AND | mot clé SQL ou PL/SQL ||||
BEGIN | mot clé SQL ou PL/SQL ||||
BY | mot clé SQL ou PL/SQL ||||
COMMIT | mot clé SQL ou PL/SQL ||||
COUNT | mot clé SQL ou PL/SQL ||||
CURSOR | mot clé SQL ou PL/SQL ||||
DBMS_RANDOM | mot clé SQL ou PL/SQL | cf. value |||
DECODE | mot clé SQL ou PL/SQL ||||
DISTINCT | mot clé SQL ou PL/SQL ||||
ELSE | mot clé SQL ou PL/SQL ||||
END | mot clé SQL ou PL/SQL ||||
EXCEPTION | mot clé SQL ou PL/SQL ||||
EXCEPTION_INIT | mot clé SQL ou PL/SQL ||||
EXISTS | mot clé SQL ou PL/SQL ||||
FOR | mot clé SQL ou PL/SQL ||||
FROM | mot clé SQL ou PL/SQL ||||
FUNCTION | mot clé SQL ou PL/SQL ||||
IF | mot clé SQL ou PL/SQL ||||
IN | mot clé SQL ou PL/SQL ||||
INSERT | mot clé SQL ou PL/SQL ||||
INTO | mot clé SQL ou PL/SQL ||||
IS | mot clé SQL ou PL/SQL ||||
IS_prod | variable locale | à 1 si le traitement a lieu sur le serveur de production, 0 pour le développement |||
LOOP | mot clé SQL ou PL/SQL ||||
MAJ_etat_classement | fonction du script | cf. pk_new_classement_commun |||
NOT | mot clé SQL ou PL/SQL ||||
NO_DATA_FOUND | mot clé SQL ou PL/SQL ||||
NULL | mot clé SQL ou PL/SQL ||||
NUMBER | mot clé SQL ou PL/SQL ||||
NVL | mot clé SQL ou PL/SQL ||||
OR | mot clé SQL ou PL/SQL ||||
ORDER | mot clé SQL ou PL/SQL ||||
OTHERS | mot clé SQL ou PL/SQL ||||
OUT | mot clé SQL ou PL/SQL ||||
OWNER | mot clé SQL ou PL/SQL ||||
PRAGMA | mot clé SQL ou PL/SQL ||||
RETURN | mot clé SQL ou PL/SQL ||||
ROLLBACK | mot clé SQL ou PL/SQL ||||
ROWCOUNT | mot clé SQL ou PL/SQL ||||
SELECT | mot clé SQL ou PL/SQL ||||
SET | mot clé SQL ou PL/SQL ||||
SQL | mot clé SQL ou PL/SQL ||||
THEN | mot clé SQL ou PL/SQL ||||
TO_CHAR | mot clé SQL ou PL/SQL ||||
TYPE | mot clé SQL ou PL/SQL ||||
UNION | mot clé SQL ou PL/SQL ||||
UNIQUE_CONSTRAINT | mot clé SQL ou PL/SQL ||||
UPDATE | mot clé SQL ou PL/SQL ||||
VALUES | mot clé SQL ou PL/SQL ||||
VARCHAR2 | mot clé SQL ou PL/SQL ||||
WHEN | mot clé SQL ou PL/SQL ||||
WHERE | mot clé SQL ou PL/SQL ||||
X | variable locale | avancement du traitement |||
a_rec | table | lié à l'étblissement | alias r || Voeux
a_ve_ord_aff | a_voe | ordre du voeu avec voeux groupé relatif licence et tous les autres voeux || Voeux
a_ve_ord_vg_rel | a_voe | ordre du voeu avec voeux groupés relatifs licence || Voeux
a_vg_ord | a_voe | ordre du sous-voeu dans le voeu groupé || Voeux
a_voe | table | les voeux des candidats et leur ordre | alias v | Voeux
all_catalog | mot clé SQL ou PL/SQL ||||
c | alias pour la table g_can
c_can_grp | table | relation entre les groupes et les candidats | alias cg | NON
c_cg_ran | c_can_grp | rang du candidat dans le groupe | propriété de la relation entre candidat et groupe | NON
c_gp_cod | champ de la table c_grp, clé étrangère | code du groupe || NON
c_gp_eta_cla | champ de la table c_grp ||| NON
c_gp_flg_cla_oto | champ de la table c_grp ||| NON
c_gp_flg_sel | champ de la table c_grp ||| NON
c_grp | table | les groupes || NON
c_ja_cod | c_jur_adm, c_grp | ? || Voeux
c_jur_adm | table | juridiction administrative ? || NON
c_rec | table ||| NON
c_tj_cod | c_jur_adm ||| NON 
cg | alias pour c_can_grp
class_aleatoire_autres_cddts | curseur
classement_aleatoire_efe | curseur
confirm | paramètre de la fonction principale
desc | mot clé SQL ou PL/SQL ||||
dummy | variable locale
dummy2 | variable locale
fr | alias pour la table g_for
g | alias pour la table c_grp
g_aa_cod_bac_int | g_can | code bac || Candidat
g_can | table | candidats || Candidat
g_cn_cod | g_can (PK) | code du candidat || Candidat
g_cn_flg_aefe | g_can | candidat AEFE || Candidat
g_cn_flg_int_aca | g_can |  || Candidat
g_ea_cod_ges | g_tri_ins | code de gestion ? || Candidat
g_flh_sel | sp_g_tri_ins | formation sélective si <> 0 ||| NON
g_for | table | ?? || Etablissement
g_fr_cod | g_tri_ins ||| NON
g_fr_cod_ins | g_tri_ins ||| NON
g_fr_flg_sel | g_for | || Etablissement
g_fr_reg_for | g_for | || Etablissement
g_gf_cod | i_ins | || Candidat
g_ic_cod | g_can | || Candidat
g_ta_cod | a_rec, a_adm | || Candidat
g_tg_cod | c_grp | ???? || NON
g_ti_cod | g_tri_ins (PK) i_ins (PK), a_rec (PK, FK) ||| Etablissement, Candidat, Propositions, Voeux
g_ti_flg_rec_idf | g_tri_ins | formation de type IDF || Etablissement
g_ti_flh_sel | g_tri_ins | formation sélective || Etablissement
g_tri_ins | table | || Etablissement
gen_class_alea_V1_relatif_grp | fonction principale
gp | alias pour la table c_grp
i | variable locale, compteur pour le rang
i_ep_cod | i_ins ||| Voeux
i_ins | table ||| Voeux
i_ip_cod | c_can_grp ||| Candidat, Voeux
i_is_dip_val | i_ins ||| Voeux
i_is_val | i_ins ||| Voeux
indic | paramètre de la fonction | utilisé pour décider s'il faut procéder au traitement
ja | c_jur_adm | || NON
l_c_gp_eta_cla | variable locale | cf. c_gp_eta_cla
l_c_gp_flg_sel | variable locale | cf. c_gp_flg_sel
l_c_ja_cod | variable locale | cf. c_ja_cod
l_c_tj_cod | variable locale | cf. c_tj_cod
l_g_ea_cod_ges | variable locale | cf. g_ea_cod_ges
l_g_flh_sel | variable locale | cf. g_flh_sel
l_g_fr_reg_for | variable locale | cf. g_fr_reg_for
l_g_tg_cod| variable locale | cf. g_tg_cod
l_six_voe | variable locale | à 1 si on utilise la fonction six_voeu_L1
login | paramètre de la fonction principale | identifiant ou mot de passe ?
mess_aff | paramètre de la fonction principale | message à afficher après l'appel en sortie standard 
mess_err | paramètre de la fonction principale | message à afficher après l'appel en sortie d'erreur
mode_dev | paramètre de la fonction principale
nip | paramètre de la fonction principale
o_c_gp_cod | paramètre de la fonction principale | détermine le groupe considéré
o_g_ea_cod_ins | paramètre de la fonction principale | indique l'établissement considéré ??
o_g_tg_cod | paramètre de la fonction principale | cf. néo d'IDF
o_g_ti_cod | paramètre de la fonction principale | détermine la formation considérée
pk_new_classement_commun | schéma SQL des fonctions MAJ_etat_classement, valid_classement_def, valid_classement_formation
r | alias pour la table a_rec
retour | variable locale pour le retour de la fonction principale | 0 si le traitement a fonctionné correctement
saio | paramètre de la fonction principale 
six_voeu_L1 | fonction mystère du script | rem. dans le même schéma
sp_g_tri_ins | table |||| NON
sqlcode | mot clé SQL ou PL/SQL | code d'erreur WHEN OTHERS |||
sqlerrm | mot clé SQL ou PL/SQL | message d'erreur WHEN OTHERS |||
ti | alias pour la table g_tri_ins
type_login | paramètre de la fonction principale
v | alias pour la table a_voe
valid_classement_def | fonction | cf. pk_new_classement_commun
valid_classement_formation | fonction | cf. pk_new_classement_commun
value | mot clé SQL ou PL/SQL | cf. DBMS_RANDOM |||
