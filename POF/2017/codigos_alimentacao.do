import excel "F:\Dados\POF\2017\Tradutor_Alimentação.xls", sheet("Planilha1") firstrow clear

/* Códigos de itens de Alimentação */

levelsof Descricao_3, local(itens)

foreach item in `itens'{

	qui preserve
	
	qui keep if Descricao_3 == "`item'"
	
	qui levelsof Codigo, local(codigos)
	
	qui local nome_item = subinstr("`item'", " ", "_", .)
	
	di as result "local `nome_item' `codigos'"
	
	qui restore

}

import excel "F:\Dados\POF\2017\Tradutor_Alimentação.xls", sheet("Planilha1") firstrow clear

/* Nomes dos grupos de alimentação */

levelsof Descricao_2, local(itens)

foreach item in `itens'{

	qui preserve
	
	qui keep if Descricao_2 == "`item'"
	
	gen back = "`"
	gen front = "'"
	
	egen rep = concat(back Descricao_3 front), punct("")
	
	replace Descricao_3 = rep
	
	qui levelsof Descricao_3, local(nomes)
	
	qui local nome_item = subinstr("`item'", " ", "_", .)
	
	di as result "local `nome_item' `nomes'"
	
	qui restore

}
