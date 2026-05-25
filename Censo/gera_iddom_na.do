* ================================================
* Configurações
* ================================================

local x_path    "C:\Users\felip\OneDrive\Documentos\PUC\Data Zoom\Censo\1991\tarefa_18mai\municipios_inconsistentes.dta"
local input_dir "C:\Users\felip\OneDrive\Documentos\PUC\Data Zoom\Censo\1991\dbf\dados\todos"
local out_dir   "C:\Users\felip\OneDrive\Documentos\PUC\Data Zoom\Censo\1991\tarefa_25mai"

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

        replace id_dom = sum((ESPECIE != ESPECIE[_n-1]) | ///
            (PARENDOM == 20) | ///
            ((RDOMICIV != RDOMICIV[_n-1]) | (ALUGUEL != ALUGUEL[_n-1]) | ///
            (PESO != PESO[_n-1]) | (DEMODORM != DEMODORM[_n-1]) | ///
            (COMBCOZI != COMBCOZI[_n-1])))

    }
    else {

        di "Municípios problemáticos encontrados. Aplicando NA onde necessário..."

        replace id_dom = sum((ESPECIE != ESPECIE[_n-1]) | ///
            (PARENDOM == 20) | ///
            ((RDOMICIV != RDOMICIV[_n-1]) | (ALUGUEL != ALUGUEL[_n-1]) | ///
            (PESO != PESO[_n-1]) | (DEMODORM != DEMODORM[_n-1]) | ///
            (COMBCOZI != COMBCOZI[_n-1]))) if ruins != 1

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