# Code fourni, lignes 4 à 44
```
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
```

# Questions en suspens
* De quelle manière la fonction est appelée ?
* De quelle manière les groupes de formations sont constitués ?
* Quel est le sens précis des différents paramètres ?
* Comment, à partir du rang, est réalisé le couplage candidat-formation ?

# Explication détaillée
C'est la déclaration des paramètres de la fonction, des variables locales et d'une constante. Il est évidemment impossible de déterminer avec certitude la signification de toutes ces variables.

## Les paramètres
Il y a des paramètres d'entrée (`IN`) et de sortie (`OUT`), en plus de la valeur de retour qui sera à 0 si tout s'est bien déroulé. 

Pour les paramètres de sortie, c'est assez simple : mess_err contiendra, après appel de la fonction, le message à afficher en erreur ; mess_aff contiendra, après appel de la fonction, le message à afficher en sortie standard. 
Certains paramètres d'entrée ne sont utilisés que dans la construction de ces messages :
* `o_g_ea_cod_ins` (le code établissement de l'inscription, cf. commentaire ligne 261) ;
Certains paramètres d'entrée sont utilisés que pour la construction de la valeur de retour, via des fonctions : 
* `login`, `type_login`, `mode_dev`, `confirm`, `saio` et `nip` apparaissent aux lignes 346 et suivantes, puis 361 et suivantes et 375 et suivantes, au niveau d'une validation (`MAJ_etat_classement`, `valid_classement_def`, `valid_classement_formation`) :
	* `saio` : service administratif d'information et d'orientation.
* `indic` est nécessaire pour déterminer si le traitement va avoir lieu. Intervient également dans les valeurs de retour
* le reste :
    * `o_g_ti_cod` : code de la formation visée par les candidats (cf. ligne 261)
	* `o_c_gp_cod` : code du groupe (= en gros filière + académie) auquel appartient la formation (cf. ligne 206). La fonction attribue un rang dans ce groupe (cf. lignes 271 sqq).
    * `o_g_tg_cod` : qualifie la nature du groupe. Ce paramètre intervient pour déterminer si on utilisera la fonction `six_voeu_L1`, `o_g_tg_cod IN (21, 25, 26, 41, 45, 46)` devant signifier, d'après les commentaires, que le groupe (de formations) est "concerné par des néo d'Île de France".
	
## Les variables locales
* `retour` : la valeur de retour
* `X` : l'étape courante, utilisé pour les messages en cas de rupture du traitement
* `dummy` et `dummy2`, pour tester si une requête sur la base renvoie un résultat vide.
* les variables suivantes sont utilisées dans des `SELECT ... INTO`, afin de stocker le résultat d'une requête.
* `i` : le rang courant, au cours de l'affectation d'un rang à chaque candidat
* `IS_prod` : à 1 si le traitement se fait sur le serveur de prod (= "pour de vrai").
* `l_six_voe` : à 1 s'il faut utiliser la fonction `six_voeu_L1` pour départager les candidats.

## La constante
`UNIQUE_CONSTRAINT` sert à intercepter les violations de la contrainte d'unicité d'un enregistrement, c'est-à-dire lorsqu'on cherche à insérer dans une table un enregistrement qui à le même identifiant (PK). Le traitement utilise cette technique au moment de l'insertion dans la table `c_can_grp`, qui contient le classement de chaque candidat. Si une insertion aa déjà été faite auparavant, le traitement le détecte et s'adapte.

# Résumé
On verra que cette fonction attribue un rang à chaque candidat pour une formation déterminée par les paramètres.

Trois paramètres interviennent de manière essentielle au niveau du traitement réalisé dans la fonction principale `o_g_ti_cod`, `o_c_gp_cod` et `o_g_tg_cod` :
* `o_g_ti_cod` et `o_c_gp_cod` déterminent une formation à laquelle est inscrit un candidat : formation précise, liée à un établissement + filère & académie (le triplet détermine une inscription).
* `o_g_tg_cod` qualifie la nature du groupe et intervient pour déterminer si on utilisera la fonction `six_voeu_L1` avant l'ordre des voeux.