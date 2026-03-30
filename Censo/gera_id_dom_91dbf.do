



/* para dat/txt

variaveis
v0304 - Tipo de Família(1 - única, 2 - dom coletivo, 3 - 1a familia)
v0303 - condicao na familia(1 - chefe, 20 - individual)
v0201 - especie do domicilio(1 - particular, 2 - particular improvisado, 3 - coletivo)
*/

/* mais proximo do metodo do censo 70 (encontra apenas 5420)*/ 
/*
destring v0303 v0304 v0201, replace force
gen long id_dom = sum(((v0304 == 1 | v0304 == 3) & v0303 == 1) | ///
						(v0201 == 3 & v0201[_n-1] != 3) | ///
						(v0303 == 20 & v0303[_n-1] != 20 & v0201 != 3))
				tostring id_dom, replace
				lab var id_dom "identificação do domicílio" */
	
/* método alternativo 2 */	
/*
destring v0201 v0302 v0209 v2012 v2121 v7300, replace force
gen long id_dom = sum((v0201 != v0201[_n-1]) | ///
						(v0302 == 20) | ///
						((v2012 != v2012[_n-1]) | (v0209 != v0209[_n-1]) | (v7300 != v7300[_n-1]) | (v2121 != v2121[_n-1]) | (v0210 != v0210[_n-1]))) ///
						
				tostring id_dom, replace
				lab var id_dom "identificação do domicílio"
*/		
		
				
/*
/* método alternativo 1 */	
destring v0303 v0304 v0201, replace force
gen long id_dom = sum(((v0201 != v0201[_n-1]) | ///
						(v0302 == 20) | ///
						(v0302 == 1))) ///
						
				tostring id_dom, replace
				lab var id_dom "identificação do domicílio"
*/				

				
						
/* dbf (com método alternativo 2) */

						
import dbase using "C:\Users\felip\OneDrive\Documentos\PUC\Data Zoom\Censo\1991\dbf\dados\Região Norte\CD91AMOUP11.DBF", clear

destring NUMFAM ESPECIE PARENDOM, replace force
gen long id_dom = sum((ESPECIE != ESPECIE[_n-1]) | ///
						(PARENDOM == 20) | ///
						((RDOMICIV != RDOMICIV[_n-1]) | (ALUGUEL != ALUGUEL[_n-1]) | (PESO != PESO[_n-1]) | (DEMODORM != DEMODORM[_n-1]) | (COMBCOZI != COMBCOZI[_n-1])))						



/* dbf (com método alternativo 1) */

/*
import dbase using "C:\Users\felip\OneDrive\Documentos\PUC\Data Zoom\Censo\1991\dbf\dados\Região Norte\CD91AMOUP14.DBF", clear

destring NUMFAM ESPECIE PARENDOM, replace force
gen long id_dom = sum((ESPECIE != ESPECIE[_n-1]) | ///
						(PARENDOM == 20) | ///
						(PARENDOM == 1))
						
*/
						
						
/*
numfam - unica == 1
especie - particular - permanente == 1
parendom - chefe == 1
*/
					
/*					
CENSO 70
v006 - condição da familia (pessoa só, unica, principal, secundaria...)
v007 - espécie (particular//coletivo)
v025 - relacao chefe familia

/* Gera identificacao do domicilio, da familia e numero de ordem das pessoas */
				destring v007 v008 v009, replace force
				gen long id_dom = sum(((v006 == 1 | v006 == 2) & v025 == 1) | /// chefe
                      (v007 == 1 & v007[_n-1] == 0) | /// dom particular -> coletivo
                      (v006 == 0 & v006[_n-1] ~= 0 & v007[_n-1] ~= 1) /// idem
						)
				tostring id_dom, replace
				lab var id_dom "identificação do domicílio" */