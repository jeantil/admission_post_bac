-- Structure de la base avec les champs tirés du script abp.sql
-- Les informations complémentaires proviennent des diagrammes de classes.

DROP TABLE c_grp; -- avec Oracle, pas de IF EXISTS
CREATE TABLE c_grp
(	
	c_gp_cod			NUMBER(8) PRIMARY KEY, -- c_can_grp.c_gp_cod est probablement une FK pointant vers cette PK
	g_tg_cod			NUMBER(8), -- pas d'info extérieure, mais tous les codes sont des NUMBER(8), FK ?
	c_ja_cod			NUMBER(8) FOREIGN KEY REFERENCES c_jur_adm(c_ja_cod), -- pas d'info extérieure, mais tous les codes sont des NUMBER(8), FK ?
	c_gp_eta_cla		NUMBER(3), -- pas d'info extérieure, un entier d'état, NUMBER(3) par prudence
	c_gp_flg_sel		NUMBER(1), -- pas d'info extérieure, mais un flg (flag)
	c_gp_flg_cla_oto 	NUMBER(1), -- pas d'info extérieure, mais un flg (flag)
);

DROP TABLE sp_g_tri_ins;
CREATE TABLE sp_g_tri_ins
(	
	g_flh_sel	NUMBER(1), -- pas d'info extérieure, mais seule l'égalité à 0 est utilisée. Flag ?
);

DROP TABLE g_for;
CREATE TABLE g_for -- document Etablissements.pdf
(	
	g_fr_cod		NUMBER(6) PRIMARY KEY, -- g_tri_ins.g_fr_cod_ins est une FK pointant vers cette PK
	g_fr_reg_for	NUMBER(3),
	g_fr_flg_sel	NUMBER(1),
);

DROP TABLE g_tri_ins;
CREATE TABLE g_tri_ins -- document Etablissements.pdf
(	
	g_ti_cod			NUMBER(8) PRIMARY KEY,
	g_ti_flg_rec_idf	NUMBER(3),
	g_ti_flh_sel		NUMBER(1),
	g_fr_cod_ins		NUMBER(6) FOREIGN KEY REFERENCES g_for(g_fr_cod),
	g_ea_cod_ges		VARCHAR2 (8 CHAR)
);

DROP TABLE c_jur_adm;
CREATE TABLE c_jur_adm
(	
	c_ja_cod	NUMBER(8) PRIMARY KEY, -- pas d'info, mais semble la PK
	c_tj_cod	NUMBER(8), -- pas d'info
	g_ti_cod	NUMBER(8) FOREIGN KEY REFERENCES g_tri_ins (g_ti_cod) -- FK ?
);

DROP TABLE g_can;
CREATE TABLE g_can -- document Candidats.pdf
(	
	g_cn_cod	NUMBER(8) PRIMARY KEY,
	g_ic_cod	NUMBER(3),
	g_cn_flg_aefe		NUMBER(1),
	g_cn_flg_int_aca	NUMBER(1),
	g_aa_cod_bac_int	NUMBER(3)
);

DROP TABLE i_ins;
CREATE TABLE i_ins -- document Voeux.pdf
(	
	g_cn_cod	NUMBER(8) FOREIGN KEY REFERENCES g_can(g_cn_cod),
	g_ti_cod	NUMBER(8) PRIMARY KEY,
	g_gf_cod	NUMBER(6),
	i_ep_cod	NUMBER(3),
	i_is_val	NUMBER(1),
	i_is_dip_val 	NUMBER(3) -- étonnant pour un is (= booléen résumé)
);

DROP TABLE a_rec;
CREATE TABLE a_rec -- document Etablissements.pdf
(	
	g_ti_cod	NUMBER(8) FOREIGN KEY REFERENCES g_tri_ins(g_ti_cod),
	g_ta_cod	NUMBER(8) FOREIGN KEY REFERENCES g_tri_aff(g_ta_cod)
);

DROP TABLE a_voe;
CREATE TABLE a_voe -- document Voeux.pdf
(	
	g_cn_cod	NUMBER(8) PRIMARY KEY, -- on attendrait : FOREIGN KEY REFERENCES g_can(g_cn_cod), mais absent
	g_ta_cod	NUMBER(8) PRIMARY KEY, --  on attendrait : FOREIGN KEY REFERENCES g_tri_aff(g_ta_cod), mais absent
	a_ve_ord_vg_rel 	NUMBER(3),
	a_ve_ord_aff		NUMBER(3),
	a_vg_ord			NUMBER(3)
);

DROP TABLE c_can_grp;
CREATE TABLE c_can_grp
(	
	g_cn_cod	NUMBER(8) FOREIGN KEY REFERENCES g_can(g_cn_cod), -- SPECULATIF
	c_gp_cod	NUMBER(8) FOREIGN KEY REFERENCES c_grp(g_cp_cod), -- SPECULATIF
	i_ip_cod	NUMBER(8),
	c_cg_ran	NUMBER(8)
);
