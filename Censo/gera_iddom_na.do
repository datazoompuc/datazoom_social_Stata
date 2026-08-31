* ================================================
* Configurações
* ================================================

local x_path    "C:\Users\felip\OneDrive\Documentos\PUC\Data Zoom\Censo\1991\tarefa_1jun\municipios_inconsistentes.dta"
local input_dir "C:\Users\felip\OneDrive\Documentos\PUC\Data Zoom\Censo\1991\dbf\dados\todos"
local out_dir   "C:\Users\felip\OneDrive\Documentos\PUC\Data Zoom\Censo\1991\tarefa_1jun\dta_gerado_pelo_stata_comNA"

* ================================================
* Lê o dataframe x e salva como tempfile
* ================================================

use "`x_path'", clear
tempfile muns_ruins
save `muns_ruins'

* ================================================
* Loop pelos arquivos DBF
* ================================================

local files : dir "`input_dir'" files "CD91AMOUP*.DBF"

foreach f of local files {

    * Extrai o número da UF do nome do arquivo
    local uf = substr("`f'", length("CD91AMOUP")+1, 2)

    di "========================"
    di "UF: `uf'"

    * Lê o arquivo DBF
    import dbase using "`input_dir'\\`f'", clear

    * ------------------------------------------------
    * Cria chave composta UF + MUNICNUM no arquivo DBF
    * ------------------------------------------------

	gen chave = "`uf'" + MUNICNUM

    * ------------------------------------------------
    * Cria flag de município problemático via merge
    * ------------------------------------------------

    preserve
        use `muns_ruins', clear
        keep if UF == "`uf'"
        gen chave = UF + MUNICNUM
        keep chave
        gen ruins = 1
        tempfile ruins_uf
        save `ruins_uf'
    restore

    merge m:1 chave using `ruins_uf', keep(master match) nogen
	cap gen ruins = .
    * ------------------------------------------------
    * Gera id_dom
    * ------------------------------------------------

    destring NUMFAM ESPECIE PARENDOM, replace force
    gen long id_dom = .

    quietly count if ruins == 1
	if r(N) == 0 {

        di "Nenhum município problemático. Rodando fórmula para UF inteira..."

        destring NUMFAM ESPECIE PARENDOM, replace force
		replace id_dom = sum((ESPECIE != ESPECIE[_n-1]) | ///
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
    }
    else {

        di "Municípios problemáticos encontrados. Aplicando NA onde necessário..."

		destring NUMFAM ESPECIE PARENDOM, replace force
        replace id_dom = sum((ESPECIE != ESPECIE[_n-1]) | ///
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
					(TELEFONE != TELEFONE[_n-1]) | (TVCORES != TVCORES[_n-1]) | (TVPRETO != TVPRETO[_n-1]))) if ruins != 1

    }

    * ------------------------------------------------
    * Remove variáveis auxiliares e salva como .dta
    * ------------------------------------------------

    drop chave ruins

	local outname = subinstr("`f'", ".dbf", ".dta", 1)
	di "`outname'"
    save "`out_dir'\\`outname'", replace

    di "Salvo: `outname'"
}

di "========================"
di "Processamento concluído."