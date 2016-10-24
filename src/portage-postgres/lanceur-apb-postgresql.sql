-- Lanceur gen_class_alea_V1_relatif_grp

CREATE OR REPLACE FUNCTION six_voeu_L1(
	g_cn_cod INTEGER, 
	g_aa_cod_bac_int INTEGER, 
	g_cn_flg_int_aca INTEGER, 
	o_g_tg_cod INTEGER) 
RETURNS INTEGER AS $$
BEGIN
	RETURN 1;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION pk_new_classement_commun_MAJ_etat_classement(
  l_g_ea_cod_ges CHARACTER VARYING, 
  o_g_ea_cod_ins CHARACTER VARYING, 
  o_g_ti_cod INTEGER,
  l_c_ja_cod INTEGER, 
  l_c_tj_cod INTEGER, 
  o_c_gp_cod INTEGER,
  a INTEGER, 
  b INTEGER,
  login CHARACTER VARYING, 
  type_login INTEGER, 
  mode_dev INTEGER,
  confirm INTEGER, 
  saio INTEGER, 
  nip CHARACTER VARYING,
  c INTEGER, 
  indic INTEGER,
  retour OUT INTEGER,
  mess_err OUT CHARACTER VARYING, 
  mess_aff OUT CHARACTER VARYING)
RETURNS RECORD AS $$
BEGIN
	retour := 0;
	mess_err := '';
	mess_aff := 'passé par MAJ_etat_classement';
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION pk_new_classement_commun_valid_classement_def(
  l_g_ea_cod_ges CHARACTER VARYING, 
  o_g_ea_cod_ins CHARACTER VARYING, 
  o_g_ti_cod INTEGER,
  l_c_ja_cod INTEGER, 
  l_c_tj_cod INTEGER, 
  o_c_gp_cod INTEGER,
  e INTEGER, 
  login CHARACTER VARYING,
  type_login INTEGER, 
  mode_dev INTEGER,
  confirm INTEGER, 
  saio INTEGER, 
  nip CHARACTER VARYING,
  f INTEGER, 
  indic INTEGER,
  retour OUT INTEGER,
  mess_err OUT CHARACTER VARYING, 
  mess_aff OUT CHARACTER VARYING)
RETURNS RECORD AS $$
BEGIN
	retour := 0;
	mess_err := '';
	mess_aff := 'passé par valid_classement_def';
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION pk_new_classement_commun_valid_classement_formation(
  l_g_ea_cod_ges CHARACTER VARYING, 
  o_g_ea_cod_ins CHARACTER VARYING, 
  o_g_ti_cod INTEGER,
  g INTEGER, 
  login CHARACTER VARYING, 
  type_login INTEGER, 
  mode_dev INTEGER,
  confirm INTEGER, 
  saio INTEGER, 
  nip CHARACTER VARYING,
  h INTEGER, 
  indic INTEGER,
  retour OUT INTEGER,
  mess_err OUT CHARACTER VARYING, 
  mess_aff OUT CHARACTER VARYING)
RETURNS RECORD AS $$
BEGIN
	retour := 0;
	mess_err := '';
	mess_aff := 'passé valid_classement_formation';
END;
$$ LANGUAGE plpgsql;

SELECT * FROM gen_class_alea_V1_relatif_grp(
  'a',
  1,
  1,
  1,

  'login',
  1,
  1,
  1,

  1,
  'nip',
  10
);