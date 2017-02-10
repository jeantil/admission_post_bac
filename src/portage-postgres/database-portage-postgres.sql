-- Structure de la base avec les champs tirés du script abp.sql
-- Les informations complémentaires proviennent des diagrammes de classes.

DROP TABLE IF EXISTS c_grp CASCADE;
DROP TABLE IF EXISTS sp_g_tri_ins CASCADE;
DROP TABLE IF EXISTS g_for CASCADE;
DROP TABLE IF EXISTS g_tri_ins CASCADE;
DROP TABLE IF EXISTS c_jur_adm CASCADE;
DROP TABLE IF EXISTS g_can CASCADE;
DROP TABLE IF EXISTS i_ins;
DROP TABLE IF EXISTS a_rec;
DROP TABLE IF EXISTS a_voe;
DROP TABLE IF EXISTS c_can_grp;

CREATE TABLE  sp_g_tri_ins
(	
	g_flh_sel			INTEGER
);

CREATE TABLE  g_for
(	
	g_fr_cod			INTEGER PRIMARY KEY,
	g_fr_flg_sel		INTEGER,
	g_fr_reg_for		INTEGER
);

CREATE TABLE  g_tri_ins
(	
	g_ti_cod			INTEGER PRIMARY KEY,
	g_ti_flg_rec_idf	INTEGER,
	g_ti_flh_sel		INTEGER,
	g_fr_cod_ins		INTEGER REFERENCES g_for(g_fr_cod),
	g_ea_cod_ges		VARCHAR(8)
);

CREATE TABLE  c_jur_adm
(	
	c_ja_cod			INTEGER PRIMARY KEY,
	c_tj_cod			INTEGER,
	g_ti_cod			INTEGER REFERENCES g_tri_ins(g_ti_cod)
);

CREATE TABLE c_grp
(	
	c_gp_cod 			INTEGER PRIMARY KEY,
	g_tg_cod			INTEGER,
	c_ja_cod 			INTEGER REFERENCES c_jur_adm(c_ja_cod),
	c_gp_eta_cla		INTEGER,
	c_gp_flg_sel		INTEGER,
	c_gp_flg_cla_oto 	INTEGER
);

CREATE TABLE  g_can
(	
	g_cn_cod			INTEGER PRIMARY KEY,
	g_ic_cod			INTEGER,
	g_cn_flg_aefe		INTEGER,
	g_cn_flg_int_aca	INTEGER,
	g_aa_cod_bac_int	INTEGER
);

CREATE TABLE  i_ins
(	
	g_cn_cod			INTEGER REFERENCES g_can(g_cn_cod),
	g_ti_cod			INTEGER NOT NULL,
	g_gf_cod			INTEGER,
	i_ep_cod			INTEGER,
	i_is_val			INTEGER,
	i_is_dip_val 			INTEGER,
	PRIMARY KEY(g_cn_cod, g_ti_cod)
);

CREATE TABLE  a_rec
(	
	g_ti_cod			INTEGER REFERENCES g_tri_ins(g_ti_cod),
	g_ta_cod			INTEGER, -- REFERENCES g_tri_aff(g_ta_cod),
	PRIMARY KEY(g_ti_cod, g_ta_cod)
);

CREATE TABLE  a_voe
(
	g_cn_cod			INTEGER,
	g_ta_cod			INTEGER,
	a_ve_ord_vg_rel 		INTEGER,
	a_ve_ord_aff			INTEGER,
	a_vg_ord			INTEGER,
	PRIMARY KEY(g_cn_cod, g_ta_cod)
);

CREATE TABLE  c_can_grp
(	
	g_cn_cod			INTEGER REFERENCES g_can(g_cn_cod), 
	c_gp_cod			INTEGER REFERENCES c_grp(c_gp_cod),
	i_ip_cod			INTEGER,
	c_cg_ran			INTEGER,
	PRIMARY KEY(g_cn_cod, c_gp_cod)
);
