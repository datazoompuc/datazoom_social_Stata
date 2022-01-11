cd F:/Dados/PNADC/Trimestral

import excel "dicionario_PNADC_microdados_trimestral.xls", sheet("dicionário pnad contínua ") cellrange(A2:E957) firstrow clear

destring Posiçãoinicial, replace force

drop if missing(Posiçãoinicial)

drop Quesito

file open dic_pnad using "dicionario_pnadc.txt", write replace
file write dic_pnad "dictionary {" _n

forvalues i = 1/`=_N'{
	
	local p `= Posiçãoinicial[`i']'
	
	local tam `= Tamanho[`i']'
	
	local cod `= Códigodavariável[`i']'
	
	local des `= E[`i']'
	
	/* 1a coluna: _column(x) */
	
	local pos "_column(`p')"

	/* 2a coluna: tipo */
	
	if `tam' <= 2 local tipo byte
	else if `tam' <= 4 local tipo int
	else if `tam' <= 9 local tipo long
	else local tipo float
	
	/* 3a coluna: codigo */
	
	/* 4a coluna: formato */
	
	local fmt "%`tam'f"
	
	if `p' >= 477 local fmt "%6.8f"
	
	/* 5a coluna: label */
	
	***
	
	local linha 
	
	file write dic_pnad `"`pos' `tipo' `cod' `fmt' `"`des'"'"'_n
}

file write dic_pnad "}"
