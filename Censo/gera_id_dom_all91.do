local in  "C:\Users\felip\OneDrive\Documentos\PUC\Data Zoom\Censo\1991\dat\tarefa\testa_id_dom_70"
local out "C:\Users\felip\OneDrive\Documentos\PUC\Data Zoom\Censo\1991\dat\tarefa\com_id_dom_70"

capture mkdir "`out'"

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