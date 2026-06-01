local in  "C:\Users\felip\OneDrive\Documentos\PUC\Data Zoom\Censo\1991\dbf\dados\todos"
local out "C:\Users\felip\OneDrive\Documentos\PUC\Data Zoom\Censo\1991\dbf\tarefa\01jun"

capture mkdir "`out'"

/* para leitura de arquivos dbf */

local arquivos : dir "`in'" files "*.dbf"


foreach arq of local arquivos {

    import dbase using "`in'/`arq'", clear

destring NUMFAM ESPECIE PARENDOM, replace force
gen long id_dom = sum((ESPECIE != ESPECIE[_n-1]) | ///
					(PARENDOM == 20) | ///
					((RDOMICIV != RDOMICIV[_n-1]) | (ALUGUEL != ALUGUEL[_n-1]) | (PESO != PESO[_n-1]) | (DEMODORM != DEMODORM[_n-1]) | (COMBCOZI != COMBCOZI[_n-1]) | ///
					(AGUA != AGUA[_n-1]) | (ALUGUEFX != ALUGUEFX[_n-1]) | (ASPIRPO != ASPIRPO[_n-1]) | ///
					(AUTPART != AUTPART[_n-1]) | (AUTTRAB != AUTTRAB[_n-1]) | (BANHEIRO != BANHEIRO[_n-1]) | ///
					(CD107 != CD107[_n-1]) | (COBERTUR != COBERTUR[_n-1]) | (COMODOR != COMODOR[_n-1]) | ///
					(COMODOS != COMODOS[_n-1]) | (CONDOCUP != CONDOCUP[_n-1]) | (DEMOCOFX != DEMOCOFX[_n-1]) | ///
					(DEMOCOMO != DEMOCOMO[_n-1]) | (DEMODOFX != DEMODOFX[_n-1]) | (FILTRO != FILTRO[_n-1]) | ///
					(FREEZER != FREEZER[_n-1]) | (GELADEIR != GELADEIR[_n-1]) | (ILUMINA != ILUMINA[_n-1]) | ///
					(LIXO != LIXO[_n-1]) | (LOCALIZA != LOCALIZA[_n-1]) | (MAQLAVAR != MAQLAVAR[_n-1]) | ///
					(PAREDES != PAREDES[_n-1]) | (RADIO != RADIO[_n-1]) | (RDONOMIF != RDONOMIF[_n-1]) | ///
					(RDOREALF != RDOREALF[_n-1]) | (SANESCOA != SANESCOA[_n-1]) | (SANUSO != SANUSO[_n-1]) | ///
					(TELEFONE != TELEFONE[_n-1]) | (TVCORES != TVCORES[_n-1]) | (TVPRETO != TVPRETO[_n-1])))
						
						
				tostring id_dom, replace
				lab var id_dom "identificação do domicílio"

    save "`out'/`arq'", replace
}


/* para leitura de arquivos dta

local arquivos : dir "`in'" files "*.dta"


foreach arq of local arquivos {

    use "`in'/`arq'", clear

destring v0303 v0304 v0201, replace force
gen long id_dom = sum(((v0201 != v0201[_n-1]) | ///
						(v0302 == 20) | ///
						(v0302 == 1))) ///
						
				tostring id_dom, replace
				lab var id_dom "identificação do domicílio"

    save "`out'/`arq'", replace
}
*/