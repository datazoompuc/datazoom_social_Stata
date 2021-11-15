cd F:/Dados/POF/2017

file open alimentacao using "alimentacao.txt", write replace
file write alimentacao "* Nível 3" _n

import excel "F:\Dados\POF\2017\Tradutor_Alimentação.xls", sheet("Planilha1") firstrow clear

/* Códigos de itens de Alimentação */

levelsof Descricao_3, local(itens)

foreach item in `itens'{

	qui preserve
	
	qui keep if Descricao_3 == "`item'"
	
	qui levelsof Codigo, local(nums)
	
	qui local nome_item = subinstr("`item'", " ", "_", .)
	
	qui levelsof Nivel_3, local(codigos)
	
	qui local codigo: word 1 of `codigos'
	
	di as result "local `nome_item' v_DA_`codigo' `nums'"
	
	file write alimentacao "local `nome_item' v_DA_`codigo' `nums'" _n
	
	qui restore

} // Retorna locais da forma local Feijão "da1011 numlist"

import excel "F:\Dados\POF\2017\Tradutor_Alimentação.xls", sheet("Planilha1") firstrow clear

/* Códigos dos grupos de alimentação */
file write alimentacao _n "* Nível 2" _n

levelsof Descricao_2, local(itens)

foreach item in `itens'{
	
	qui preserve
	
	qui keep if Descricao_2 == "`item'"
	
	qui levelsof Codigo, local(nums)
	
	qui local nome_item = subinstr("`item'", " ", "_", .)
	
	qui levelsof Nivel_2, local(codigos)
	
	qui local codigo: word 1 of `codigos'
	
	di as result "local `nome_item' v_DA_`codigo' `nums'"
	
	file write alimentacao "local `nome_item' v_DA_`codigo' `nums'" _n
	
	qui restore

}

import excel "F:\Dados\POF\2017\Tradutor_Alimentação.xls", sheet("Planilha1") firstrow clear

/* Códigos dos grandes grupos de alimentação */
file write alimentacao _n "* Nível 1" _n

levelsof Descricao_1, local(itens)

foreach item in `itens'{
	
	qui preserve
	
	qui keep if Descricao_1 == "`item'"
	
	qui levelsof Codigo, local(nums)
	
	qui local nome_item = subinstr("`item'", " ", "_", .)
	
	qui levelsof Nivel_1, local(codigos)
	
	qui local codigo: word 1 of `codigos'
	
	di as result "local `nome_item' v_DA_`codigo' `nums'"
	
	file write alimentacao "local `nome_item' v_DA_`codigo' `nums'" _n
	
	qui restore

}

/* Grupo geral */

file write alimentacao _n "* Nível 0" _n

import excel "F:\Dados\POF\2017\Tradutor_Alimentação.xls", sheet("Planilha1") firstrow clear

levelsof Codigo, local(nums)

di as result "local Alimentação v_DA_0 `nums'"

file write alimentacao "local Alimentação v_DA_0 `nums'" _n

/* Tradutor de Despesa Geral */

file open despesa using "despesa.txt", write replace
file write despesa "* Nível 5" _n

import excel "F:\Dados\POF\2017\Tradutor_Despesa_Geral.xls", sheet("Planilha1") firstrow clear
drop if Descricao_3 == "Alimentacao"

levelsof Descricao_5, local(itens)

foreach item in `itens'{

	qui preserve
	
	qui keep if Descricao_5 == "`item'"
	
	qui levelsof Codigo, local(nums)
	
	qui local nome_item = subinstr("`item'", " ", "_", .)
	
	qui levelsof Nivel_5, local(codigos)
	
	qui local codigo: word 1 of `codigos'
	
	di as result "local `nome_item' v_DT_`codigo' `nums'"
	
	file write despesa "local `nome_item' v_DT_`codigo' `nums'" _n
	
	qui restore

}

import excel "F:\Dados\POF\2017\Tradutor_Despesa_Geral.xls", sheet("Planilha1") firstrow clear
drop if Descricao_3 == "Alimentacao"

file write despesa "* Nível 4" _n
levelsof Descricao_4, local(itens)

foreach item in `itens'{

	qui preserve
	
	qui keep if Descricao_4 == "`item'"
	
	qui levelsof Codigo, local(nums)
	
	qui local nome_item = subinstr("`item'", " ", "_", .)
	
	qui levelsof Nivel_4, local(codigos)
	
	qui local codigo: word 1 of `codigos'
	
	di as result "local `nome_item' v_DT_`codigo' `nums'"
	
	file write despesa "local `nome_item' v_DT_`codigo' `nums'" _n
	
	qui restore

}

import excel "F:\Dados\POF\2017\Tradutor_Despesa_Geral.xls", sheet("Planilha1") firstrow clear
drop if Descricao_3 == "Alimentacao"

file write despesa "* Nível 3" _n
levelsof Descricao_3, local(itens)

foreach item in `itens'{

	qui preserve
	
	qui keep if Descricao_3 == "`item'"
	
	qui levelsof Codigo, local(nums)
	
	qui local nome_item = subinstr("`item'", " ", "_", .)
	
	qui levelsof Nivel_3, local(codigos)
	
	qui local codigo: word 1 of `codigos'
	
	di as result "local `nome_item' v_DT_`codigo' `nums'"
	
	file write despesa "local `nome_item' v_DT_`codigo' `nums'" _n
	
	qui restore

}

import excel "F:\Dados\POF\2017\Tradutor_Despesa_Geral.xls", sheet("Planilha1") firstrow clear
drop if Descricao_3 == "Alimentacao"

file write despesa "* Nível 2" _n
levelsof Descricao_2, local(itens)

foreach item in `itens'{

	qui preserve
	
	qui keep if Descricao_2 == "`item'"
	
	qui levelsof Codigo, local(nums)
	
	qui local nome_item = subinstr("`item'", " ", "_", .)
	
	qui levelsof Nivel_2, local(codigos)
	
	qui local codigo: word 1 of `codigos'
	
	di as result "local `nome_item' v_DT_`codigo' `nums'"
	
	file write despesa "local `nome_item' v_DT_`codigo' `nums'" _n
	
	qui restore

}

import excel "F:\Dados\POF\2017\Tradutor_Despesa_Geral.xls", sheet("Planilha1") firstrow clear
drop if Descricao_3 == "Alimentacao"

file write despesa "* Nível 1" _n
levelsof Descricao_1, local(itens)

foreach item in `itens'{

	qui preserve
	
	qui keep if Descricao_1 == "`item'"
	
	qui levelsof Codigo, local(nums)
	
	qui local nome_item = subinstr("`item'", " ", "_", .)
	
	qui levelsof Nivel_1, local(codigos)
	
	qui local codigo: word 1 of `codigos'
	
	di as result "local `nome_item' v_DT_`codigo' `nums'"
	
	file write despesa "local `nome_item' v_DT_`codigo' `nums'" _n
	
	qui restore

}

import excel "F:\Dados\POF\2017\Tradutor_Despesa_Geral.xls", sheet("Planilha1") firstrow clear
drop if Descricao_3 == "Alimentacao"

file write despesa "* Nível 0" _n
levelsof Descricao_0, local(itens)

foreach item in `itens'{

	qui preserve
	
	qui keep if Descricao_0 == "`item'"
	
	qui levelsof Codigo, local(nums)
	
	qui local nome_item = subinstr("`item'", " ", "_", .)
	
	qui levelsof Nivel_0, local(codigos)
	
	qui local codigo: word 1 of `codigos'
	
	di as result "local `nome_item' v_DT_`codigo' `nums'"
	
	file write despesa "local `nome_item' v_DT_`codigo' `nums'" _n
	
	qui restore

}
