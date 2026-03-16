import dbase using "C:\Users\felip\OneDrive\Documentos\PUC\Data Zoom\Censo\1991\dbf\dados\Região Norte\CD91AMOUP14.DBF", clear

destring NUMFAM ESPECIE PARENDOM, replace force
gen long id_dom = sum((((NUMFAM == 1 | NUMFAM == 2) | NUMFAM == 3) & PARENDOM == 1) | ///
						(ESPECIE == 3 & ESPECIE[_n-1] != 3) | ///
						(NUMFAM == 1 & NUMFAM[_n-1] != 1 & ESPECIE != 3))

/* v006 - condição da familia (unica, principal, secundaria...)
v007 - espécie (particular//coletivo)
v025 - relacao chefe familia

numfam - unica == 1
especie - particular - permanente == 1
parendom - chefe == 1

/* Gera identificacao do domicilio, da familia e numero de ordem das pessoas */
				destring v007 v008 v009, replace force
				gen long id_dom = sum(((v006 == 1 | v006 == 2) & v025 == 1) | /// chefe
                      (v007 == 1 & v007[_n-1] == 0) | /// dom particular -> coletivo
                      (v006 == 0 & v006[_n-1] ~= 0 & v007[_n-1] ~= 1) /// idem
						)
				tostring id_dom, replace
				lab var id_dom "identificação do domicílio" */