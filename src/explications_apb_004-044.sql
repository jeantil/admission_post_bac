/* Code fourni, lignes 4 à 44 */
FUNCTION gen_class_alea_V1_relatif_grp(
  o_g_ea_cod_ins IN VARCHAR2,
  o_g_ti_cod IN NUMBER,
  o_c_gp_cod IN NUMBER,
  o_g_tg_cod IN NUMBER,

  login IN VARCHAR2,
  type_login IN NUMBER,
  mode_dev IN NUMBER,
  confirm IN NUMBER,

  saio IN NUMBER,
  nip IN VARCHAR2,
  indic IN NUMBER,
  mess_err OUT VARCHAR2,
  mess_aff OUT VARCHAR2
)
RETURN          NUMBER IS

retour          NUMBER;
X               VARCHAR2(2);
dummy           NUMBER;
dummy2          NUMBER;

l_c_gp_flg_sel  c_grp.c_gp_flg_sel%TYPE;
l_g_tg_cod      c_grp.g_tg_cod%TYPE;
l_c_gp_eta_cla  c_grp.c_gp_eta_cla%TYPE;
l_g_flh_sel     sp_g_tri_ins.g_flh_sel%TYPE;

l_g_fr_reg_for  g_for.g_fr_reg_for%TYPE;
l_g_ea_cod_ges  g_tri_ins.g_ea_cod_ges%TYPE;
l_c_ja_cod      c_jur_adm.c_ja_cod%TYPE;
l_c_tj_cod      c_jur_adm.c_tj_cod%TYPE;

i               NUMBER;
IS_prod         NUMBER;
l_six_voe       NUMBER;

UNIQUE_CONSTRAINT EXCEPTION;

PRAGMA EXCEPTION_INIT (UNIQUE_CONSTRAINT, -00001);

/*
Explication détaillée :
C'est la déclaration des paramètres de la fonction, des variables locales et d'une constante. Il est évidemment impossible de déterminer avec certitude la signification de toutes ces variables.

Paramètres
**********
Il y a des paramètres d'entrée (IN) et de sortie (OUT), en plus de la valeur de retour qui sera à 0 si tout s'est bien déroulé. 

Pour les paramètres de sortie, c'est assez simple : mess_err contiendra, après appel de la fonction, le message à afficher en erreur ; mess_aff contiendra, après appel de la fonction, le message à afficher en sortie standard. 
Certains paramètres d'entrée ne sont utilisés que dans la construction de ces messages, soit "o_g_ea_cod_ins" (ligne 207 etc.).
Certains paramètres d'entrée sont utilisés que pour la construction de la valeur de retour, via des fonctions : 
* login, type_login, mode_dev et confirm, saio, nip apparaissent aux lignes 346 et suivantes, puis 361 et suivantes et 375 et suivantes, au niveau d'une validation (MAJ_etat_classement, valid_classement_def, valid_classement_formation).
* indic est nécessaire pour déterminer si le traitement va avoir lieu. Intervient également dans les valeurs de retour
* le reste :
** o_g_ti_cod : code de la formation, o_c_gp_cod code du groupe,
** o_g_tg_cod intervient pour déterminer si on utilisera la fonction six_voeu_L1, o_g_tg_cod IN (21, 25, 26, 41, 45, 46) doit signifier, d'après les commentaires, que le groupe  concerné par des néo d'IDF.

Les variables locales
*********************
* retour : la valeur de retour
* X : l'étape courante, utilisé en cas de rupture du traitement
* dummy et dummy2, pour tester si une requête sur la base renvoie un résultat vide.
* les variables suivantes sont utilisées dans des SELECT INTO, afin de stocker le résultat d'une requête.
* i : le rang courant, au cours de l'affectation d'un rang à chaque candidat
* IS_prod : à 1 si le traitement se fait sur le serveur de prod (= "pour de vrai").
* l_six_voe : à 1 s'il faut utiliser la fonction six_voeu_L1 pour départager les candidats.

La constante
************
UNIQUE_CONSTRAINT sert à intercepter les violations de la contrainte d'unicité d'un enregistrement, c'est-à-dire lorsqu'on cherche à insérer dans une table un enregistrement qui à le même identifiant (PK). Le traitement utilise cette technique au moment de l'insertion dans la table c_can_grp, qui contient le classement de chaque candidat. Si une insertion aa déjà été faite auparavant, le traitement le détecte et s'adapte.
*/


