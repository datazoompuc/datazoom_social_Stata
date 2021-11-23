/* Cria um arquivo txt com o código para criar os locals identificadores dos bens do datazoom_pof2017.ado */

cd F:/Dados/POF/2017

file open alimentacao using "alimentacao.txt", write replace
file write alimentacao "* Nível 3" _n

import excel "F:\Dados\POF\2017\Tradutor_Alimentação.xls", sheet("Planilha1") firstrow clear

/* Códigos de itens de Alimentação */

levelsof Descricao_2, local(categorias)

foreach categoria in `categorias'{

file write alimentacao _n "* `categoria'" _n

levelsof Descricao_3, local(itens)

foreach item in `itens'{
	
	local novo_nums ""

	qui preserve
	
	qui keep if Descricao_2 == "`categoria'" & Descricao_3 == "`item'"
	
	qui levelsof Codigo, local(nums)
	if "`nums'" == ""{
	qui restore
	continue
	}
	
	local n: word count `nums'
	local min: word 1 of `nums'
	local max: word `n' of `nums'
	local mini `min'
	local maxi `min'
	local maxx = `max' + 1
	forvalues i = `min'/`maxx'{ // Algoritmo maluco que encurta numlists: 1 2 3 4 6 7 -> 1/4 6/7.
	
		local test = strpos("`nums'", "`i'")
		if "`test'" != "0"{
			local maxi `i'
			local z = 0
		}
		else{
			local z = `z' + 1
			local numi = "`mini'/`maxi'"
			local mini = `i' + 1
			if `z' == 1 local novo_nums "`novo_nums' `numi'" 
		}
	}
	
	local nums "`novo_nums'"
	
	qui local nome_item = subinstr("`item'", " ", "_", .)
	
	qui levelsof Nivel_3, local(codigos)
	
	qui local codigo: word 1 of `codigos'
	
	di as result "local `nome_item' v_DA_`codigo' `nums'"
	
	file write alimentacao "local `nome_item' v_DA_`codigo' `nums'" _n
	
	qui restore

} // Retorna locais da forma local Feijão "da1011 numlist"
}

import excel "F:\Dados\POF\2017\Tradutor_Alimentação.xls", sheet("Planilha1") firstrow clear

/* Códigos dos grupos de alimentação */
file write alimentacao _n "* Nível 2" _n

levelsof Descricao_1, local(categorias)

foreach categoria in `categorias'{

file write alimentacao _n "* `categoria'" _n

levelsof Descricao_2, local(itens)

foreach item in `itens'{
	
	local novo_nums ""
	
	qui preserve
	
	qui keep if Descricao_1 == "`categoria'" & Descricao_2 == "`item'"
	
	qui levelsof Codigo, local(nums)
	if "`nums'" == ""{
	qui restore
	continue
	}
	
		local n: word count `nums'
	local min: word 1 of `nums'
	local max: word `n' of `nums'
	local mini `min'
	local maxi `min'
	local maxx = `max' + 1
	forvalues i = `min'/`maxx'{ // Algoritmo maluco que encurta numlists: 1 2 3 4 6 7 -> 1/4 6/7.
	
		local test = strpos("`nums'", "`i'")
		if "`test'" != "0"{
			local maxi `i'
			local z = 0
		}
		else{
			local z = `z' + 1
			local numi = "`mini'/`maxi'"
			local mini = `i' + 1
			if `z' == 1 local novo_nums "`novo_nums' `numi'" 
		}
	}
	
	local nums "`novo_nums'"
	
	qui local nome_item = subinstr("`item'", " ", "_", .)
	
	qui levelsof Nivel_2, local(codigos)
	
	qui local codigo: word 1 of `codigos'
	
	di as result "local `nome_item' v_DA_`codigo' `nums'"
	
	file write alimentacao "local `nome_item' v_DA_`codigo' `nums'" _n
	
	qui restore

}
}

import excel "F:\Dados\POF\2017\Tradutor_Alimentação.xls", sheet("Planilha1") firstrow clear

/* Códigos dos grandes grupos de alimentação */
file write alimentacao _n "* Nível 1" _n

levelsof Descricao_0, local(categorias)

foreach categoria in `categorias'{

file write alimentacao _n "* `categoria'" _n

levelsof Descricao_1, local(itens)

foreach item in `itens'{
	
	local novo_nums ""
	
	qui preserve
	
	qui keep if Descricao_0 == "`categoria'" & Descricao_1 == "`item'"
	
	qui levelsof Codigo, local(nums)
	if "`nums'" == ""{
	qui restore
	continue
	}
	
		local n: word count `nums'
	local min: word 1 of `nums'
	local max: word `n' of `nums'
	local mini `min'
	local maxi `min'
	local maxx = `max' + 1
	forvalues i = `min'/`maxx'{ // Algoritmo maluco que encurta numlists: 1 2 3 4 6 7 -> 1/4 6/7.
	
		local test = strpos("`nums'", "`i'")
		if "`test'" != "0"{
			local maxi `i'
			local z = 0
		}
		else{
			local z = `z' + 1
			local numi = "`mini'/`maxi'"
			local mini = `i' + 1
			if `z' == 1 local novo_nums "`novo_nums' `numi'" 
		}
	}
	
	local nums "`novo_nums'"
	
	qui local nome_item = subinstr("`item'", " ", "_", .)
	
	qui levelsof Nivel_1, local(codigos)
	
	qui local codigo: word 1 of `codigos'
	
	di as result "local `nome_item' v_DA_`codigo' `nums'"
	
	file write alimentacao "local `nome_item' v_DA_`codigo' `nums'" _n
	
	qui restore

}
}

/* Grupo geral */

file write alimentacao _n "* Nível 0" _n

import excel "F:\Dados\POF\2017\Tradutor_Alimentação.xls", sheet("Planilha1") firstrow clear
local novo_nums ""
levelsof Codigo, local(nums)

	local n: word count `nums'
	local min: word 1 of `nums'
	local max: word `n' of `nums'
	local mini `min'
	local maxi `min'
	local maxx = `max' + 1
	forvalues i = `min'/`maxx'{ // Algoritmo maluco que encurta numlists: 1 2 3 4 6 7 -> 1/4 6/7.
	
		local test = strpos("`nums'", "`i'")
		if "`test'" != "0"{
			local maxi `i'
			local z = 0
		}
		else{
			local z = `z' + 1
			local numi = "`mini'/`maxi'"
			local mini = `i' + 1
			if `z' == 1 local novo_nums "`novo_nums' `numi'" 
		}
	}
	
	local nums "`novo_nums'"

di as result "local Alimentação v_DA_0 `nums'"

file write alimentacao "local Alimentação v_DA_0 `nums'" _n

/* Tradutor de Despesa Geral */

file open despesa using "despesa.txt", write replace
file write despesa "* Nível 5" _n

import excel "F:\Dados\POF\2017\Tradutor_Despesa_Geral.xls", sheet("Planilha1") firstrow clear
drop if Descricao_3 == "Alimentacao"

levelsof Descricao_4, local(categorias)

foreach categoria in `categorias'{

file write despesa _n "* `categoria'" _n

levelsof Descricao_5, local(itens)

foreach item in `itens'{
	
	local novo_nums ""
	
	qui preserve
	
	qui keep if Descricao_4 == "`categoria'" & Descricao_5 == "`item'"
	
	qui levelsof Codigo, local(nums)
	if "`nums'" == ""{
	qui restore
	continue
	}
	
		local n: word count `nums'
	local min: word 1 of `nums'
	local max: word `n' of `nums'
	local mini `min'
	local maxi `min'
	local maxx = `max' + 1
	forvalues i = `min'/`maxx'{ // Algoritmo maluco que encurta numlists: 1 2 3 4 6 7 -> 1/4 6/7.
	
		local test = strpos("`nums'", "`i'")
		if "`test'" != "0"{
			local maxi `i'
			local z = 0
		}
		else{
			local z = `z' + 1
			local numi = "`mini'/`maxi'"
			local mini = `i' + 1
			if `z' == 1 local novo_nums "`novo_nums' `numi'" 
		}
	}
	
	local nums "`novo_nums'"
	
	qui local nome_item = subinstr("`item'", " ", "_", .)
	
	qui levelsof Nivel_5, local(codigos)
	
	qui local codigo: word 1 of `codigos'
	
	di as result "local `nome_item' v_DT_`codigo' `nums'"
	
	file write despesa "local `nome_item' v_DT_`codigo' `nums'" _n
	
	qui restore

}
}

import excel "F:\Dados\POF\2017\Tradutor_Despesa_Geral.xls", sheet("Planilha1") firstrow clear
drop if Descricao_3 == "Alimentacao"

file write despesa "* Nível 4" _n
levelsof Descricao_3, local(categorias)

foreach categoria in `categorias'{

file write despesa _n "* `categoria'" _n

levelsof Descricao_4, local(itens)

foreach item in `itens'{
	local novo_nums ""
	qui preserve
	
	qui keep if Descricao_3 == "`categoria'" & Descricao_4 == "`item'"
	
	qui levelsof Codigo, local(nums)
	if "`nums'" == ""{
	qui restore
	continue
	}
	
		local n: word count `nums'
	local min: word 1 of `nums'
	local max: word `n' of `nums'
	local mini `min'
	local maxi `min'
	local maxx = `max' + 1
	forvalues i = `min'/`maxx'{ // Algoritmo maluco que encurta numlists: 1 2 3 4 6 7 -> 1/4 6/7.
	
		local test = strpos("`nums'", "`i'")
		if "`test'" != "0"{
			local maxi `i'
			local z = 0
		}
		else{
			local z = `z' + 1
			local numi = "`mini'/`maxi'"
			local mini = `i' + 1
			if `z' == 1 local novo_nums "`novo_nums' `numi'" 
		}
	}
	
	local nums "`novo_nums'"
	
	qui local nome_item = subinstr("`item'", " ", "_", .)
	
	qui levelsof Nivel_4, local(codigos)
	
	qui local codigo: word 1 of `codigos'
	
	di as result "local `nome_item' v_DT_`codigo' `nums'"
	
	file write despesa "local `nome_item' v_DT_`codigo' `nums'" _n
	
	qui restore

}
}

import excel "F:\Dados\POF\2017\Tradutor_Despesa_Geral.xls", sheet("Planilha1") firstrow clear
drop if Descricao_3 == "Alimentacao"

file write despesa "* Nível 3" _n
levelsof Descricao_2, local(categorias)

foreach categoria in `categorias'{

file write despesa _n "* `categoria'" _n

levelsof Descricao_3, local(itens)

foreach item in `itens'{
	local novo_nums ""
	qui preserve
	
	qui keep if Descricao_2 == "`categoria'" & Descricao_3 == "`item'"
	
	qui levelsof Codigo, local(nums)
	if "`nums'" == ""{
	qui restore
	continue
	}
	
		local n: word count `nums'
	local min: word 1 of `nums'
	local max: word `n' of `nums'
	local mini `min'
	local maxi `min'
	local maxx = `max' + 1
	forvalues i = `min'/`maxx'{ // Algoritmo maluco que encurta numlists: 1 2 3 4 6 7 -> 1/4 6/7.
	
		local test = strpos("`nums'", "`i'")
		if "`test'" != "0"{
			local maxi `i'
			local z = 0
		}
		else{
			local z = `z' + 1
			local numi = "`mini'/`maxi'"
			local mini = `i' + 1
			if `z' == 1 local novo_nums "`novo_nums' `numi'" 
		}
	}
	
	local nums "`novo_nums'"
	
	qui local nome_item = subinstr("`item'", " ", "_", .)
	
	qui levelsof Nivel_3, local(codigos)
	
	qui local codigo: word 1 of `codigos'
	
	di as result "local `nome_item' v_DT_`codigo' `nums'"
	
	file write despesa "local `nome_item' v_DT_`codigo' `nums'" _n
	
	qui restore

}
}

import excel "F:\Dados\POF\2017\Tradutor_Despesa_Geral.xls", sheet("Planilha1") firstrow clear
drop if Descricao_3 == "Alimentacao"

file write despesa "* Nível 2" _n
levelsof Descricao_1, local(categorias)

foreach categoria in `categorias'{

file write despesa _n "* `categoria'" _n

levelsof Descricao_2, local(itens)

foreach item in `itens'{
	local novo_nums ""
	qui preserve
	
	qui keep if Descricao_1 == "`categoria'" & Descricao_2 == "`item'"
	
	qui levelsof Codigo, local(nums)
	if "`nums'" == ""{
	qui restore
	continue
	}
	
		local n: word count `nums'
	local min: word 1 of `nums'
	local max: word `n' of `nums'
	local mini `min'
	local maxi `min'
	local maxx = `max' + 1
	forvalues i = `min'/`maxx'{ // Algoritmo maluco que encurta numlists: 1 2 3 4 6 7 -> 1/4 6/7.
	
		local test = strpos("`nums'", "`i'")
		if "`test'" != "0"{
			local maxi `i'
			local z = 0
		}
		else{
			local z = `z' + 1
			local numi = "`mini'/`maxi'"
			local mini = `i' + 1
			if `z' == 1 local novo_nums "`novo_nums' `numi'" 
		}
	}
	
	local nums "`novo_nums'"
	
	qui local nome_item = subinstr("`item'", " ", "_", .)
	
	qui levelsof Nivel_2, local(codigos)
	
	qui local codigo: word 1 of `codigos'
	
	di as result "local `nome_item' v_DT_`codigo' `nums'"
	
	file write despesa "local `nome_item' v_DT_`codigo' `nums'" _n
	
	qui restore

}
}

import excel "F:\Dados\POF\2017\Tradutor_Despesa_Geral.xls", sheet("Planilha1") firstrow clear
drop if Descricao_3 == "Alimentacao"

file write despesa "* Nível 1" _n
levelsof Descricao_0, local(categorias)

foreach categoria in `categorias'{

file write despesa _n "* `categoria'" _n

levelsof Descricao_1, local(itens)

foreach item in `itens'{
	local novo_nums ""
	qui preserve
	
	qui keep if Descricao_0 == "`categoria'" & Descricao_1 == "`item'"
	
	qui levelsof Codigo, local(nums)
	if "`nums'" == ""{
	qui restore
	continue
	}
	
		local n: word count `nums'
	local min: word 1 of `nums'
	local max: word `n' of `nums'
	local mini `min'
	local maxi `min'
	local maxx = `max' + 1
	forvalues i = `min'/`maxx'{ // Algoritmo maluco que encurta numlists: 1 2 3 4 6 7 -> 1/4 6/7.
	
		local test = strpos("`nums'", "`i'")
		if "`test'" != "0"{
			local maxi `i'
			local z = 0
		}
		else{
			local z = `z' + 1
			local numi = "`mini'/`maxi'"
			local mini = `i' + 1
			if `z' == 1 local novo_nums "`novo_nums' `numi'" 
		}
	}
	
	local nums "`novo_nums'"
	
	qui local nome_item = subinstr("`item'", " ", "_", .)
	
	qui levelsof Nivel_1, local(codigos)
	
	qui local codigo: word 1 of `codigos'
	
	di as result "local `nome_item' v_DT_`codigo' `nums'"
	
	file write despesa "local `nome_item' v_DT_`codigo' `nums'" _n
	
	qui restore

}
}

import excel "F:\Dados\POF\2017\Tradutor_Despesa_Geral.xls", sheet("Planilha1") firstrow clear
drop if Descricao_3 == "Alimentacao"

file write despesa "* Nível 0" _n
levelsof Descricao_0, local(itens)

foreach item in `itens'{
	local novo_nums ""
	qui preserve
	
	qui keep if Descricao_0 == "`item'"
	
	qui levelsof Codigo, local(nums)
	
		local n: word count `nums'
	local min: word 1 of `nums'
	local max: word `n' of `nums'
	local mini `min'
	local maxi `min'
	local maxx = `max' + 1
	forvalues i = `min'/`maxx'{ // Algoritmo maluco que encurta numlists: 1 2 3 4 6 7 -> 1/4 6/7.
	
		local test = strpos("`nums'", "`i'")
		if "`test'" != "0"{
			local maxi `i'
			local z = 0
		}
		else{
			local z = `z' + 1
			local numi = "`mini'/`maxi'"
			local mini = `i' + 1
			if `z' == 1 local novo_nums "`novo_nums' `numi'" 
		}
	}
	
	local nums "`novo_nums'"
	
	qui local nome_item = subinstr("`item'", " ", "_", .)
	
	qui levelsof Nivel_0, local(codigos)
	
	qui local codigo: word 1 of `codigos'
	
	di as result "local `nome_item' v_DT_`codigo' `nums'"
	
	file write despesa "local `nome_item' v_DT_`codigo' `nums'" _n
	
	qui restore

}

/* Tradutor de Rendimentos */

cd F:/Dados/POF/2017

file open rendimento using "rendimento.txt", write replace

import excel "F:\Dados\POF\2017\Tradutor_Rendimento.xls", firstrow clear
drop if Codigo == "Ver arquivo Rendimento Não Monetário" | Codigo == "Ver arquivo Variação Patrimonial"
destring Codigo, replace

file write rendimento "* Nível 3" _n
levelsof Descricao_2, local(categorias)

foreach categoria in `categorias'{

file write rendimento _n "* `categoria'" _n

levelsof Descricao_3, local(itens)

foreach item in `itens'{
	local novo_nums ""
	qui preserve
	
	qui keep if Descricao_2 == "`categoria'" & Descricao_3 == "`item'"
	
	qui levelsof Codigo, local(nums)
	if "`nums'" == ""{
	qui restore
	continue
	}
	
		local n: word count `nums'
	local min: word 1 of `nums'
	local max: word `n' of `nums'
	local mini `min'
	local maxi `min'
	local maxx = `max' + 1
	forvalues i = `min'/`maxx'{ // Algoritmo maluco que encurta numlists: 1 2 3 4 6 7 -> 1/4 6/7.
	
		local test = strpos("`nums'", "`i'")
		if "`test'" != "0"{
			local maxi `i'
			local z = 0
		}
		else{
			local z = `z' + 1
			local numi = "`mini'/`maxi'"
			local mini = `i' + 1
			if `z' == 1 local novo_nums "`novo_nums' `numi'" 
		}
	}
	
	local nums "`novo_nums'"
	
	qui local nome_item = subinstr("`item'", " ", "_", .)
	
	qui levelsof Nivel_3, local(codigos)
	
	qui local codigo: word 1 of `codigos'
	
	di as result "local `nome_item' v_RE_`codigo' `nums'"
	
	file write rendimento "local `nome_item' v_RE_`codigo' `nums'" _n
	
	qui restore

}
}

import excel "F:\Dados\POF\2017\Tradutor_Rendimento.xls", firstrow clear
drop if Codigo == "Ver arquivo Rendimento Não Monetário" | Codigo == "Ver arquivo Variação Patrimonial"
destring Codigo, replace

file write rendimento _n "* Nível 2" _n
levelsof Descricao_1, local(categorias)

foreach categoria in `categorias'{

file write rendimento _n "* `categoria'" _n

levelsof Descricao_2, local(itens)

foreach item in `itens'{
	local novo_nums ""
	qui preserve
	
	qui keep if Descricao_1 == "`categoria'" & Descricao_2 == "`item'"
	
	qui levelsof Codigo, local(nums)
	if "`nums'" == ""{
	qui restore
	continue
	}
	
		local n: word count `nums'
	local min: word 1 of `nums'
	local max: word `n' of `nums'
	local mini `min'
	local maxi `min'
	local maxx = `max' + 1
	forvalues i = `min'/`maxx'{ // Algoritmo maluco que encurta numlists: 1 2 3 4 6 7 -> 1/4 6/7.
	
		local test = strpos("`nums'", "`i'")
		if "`test'" != "0"{
			local maxi `i'
			local z = 0
		}
		else{
			local z = `z' + 1
			local numi = "`mini'/`maxi'"
			local mini = `i' + 1
			if `z' == 1 local novo_nums "`novo_nums' `numi'" 
		}
	}
	
	local nums "`novo_nums'"
	
	qui local nome_item = subinstr("`item'", " ", "_", .)
	
	qui levelsof Nivel_2, local(codigos)
	
	qui local codigo: word 1 of `codigos'
	
	di as result "local `nome_item' v_RE_`codigo' `nums'"
	
	file write rendimento "local `nome_item' v_RE_`codigo' `nums'" _n
	
	qui restore

}
}

import excel "F:\Dados\POF\2017\Tradutor_Rendimento.xls", firstrow clear
drop if Codigo == "Ver arquivo Rendimento Não Monetário" | Codigo == "Ver arquivo Variação Patrimonial"
destring Codigo, replace

file write rendimento _n "* Nível 1" _n
levelsof Descricao_0, local(categorias)

foreach categoria in `categorias'{

file write rendimento _n "* `categoria'" _n

levelsof Descricao_1, local(itens)

foreach item in `itens'{
	local novo_nums ""
	qui preserve
	
	qui keep if Descricao_0 == "`categoria'" & Descricao_1 == "`item'"
	
	qui levelsof Codigo, local(nums)
	if "`nums'" == ""{
	qui restore
	continue
	}
	
		local n: word count `nums'
	local min: word 1 of `nums'
	local max: word `n' of `nums'
	local mini `min'
	local maxi `min'
	local maxx = `max' + 1
	forvalues i = `min'/`maxx'{ // Algoritmo maluco que encurta numlists: 1 2 3 4 6 7 -> 1/4 6/7.
	
		local test = strpos("`nums'", "`i'")
		if "`test'" != "0"{
			local maxi `i'
			local z = 0
		}
		else{
			local z = `z' + 1
			local numi = "`mini'/`maxi'"
			local mini = `i' + 1
			if `z' == 1 local novo_nums "`novo_nums' `numi'" 
		}
	}
	
	local nums "`novo_nums'"
	
	qui local nome_item = subinstr("`item'", " ", "_", .)
	
	qui levelsof Nivel_1, local(codigos)
	
	qui local codigo: word 1 of `codigos'
	
	di as result "local `nome_item' v_RE_`codigo' `nums'"
	
	file write rendimento "local `nome_item' v_RE_`codigo' `nums'" _n
	
	qui restore

}
}
