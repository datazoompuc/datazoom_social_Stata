program datazoom_pof2008
syntax, [trs(string)] [id(string)] [sel(string)] [std] original(string) saving(string) [english]

if "`sel'" != "" & "`id'" != "pess"{
	local trs tr5 tr6 tr7 tr8 tr9 tr10 tr11 tr12 tr13 tr14 // Apenas TRs de despesas e rendimentos
}
else if "`sel'" != "" & "`id'" == "pess"{
	local trs tr10 tr11 tr12 tr13 tr14 // Mantém somente os TRs individuais
}	
else if "`std'" != ""{
	local trs tr5 tr6 tr7 tr8 tr9 tr10 tr11 tr12 tr13 tr14 // Para std
}
else if "`trs'" == "" local trs tr1 tr2 tr3 tr4 tr5 tr6 tr7 tr8 tr9 tr10 tr11 tr12 tr13 tr14 tr15 tr16

foreach tr in `trs'{
	tempfile base_`tr' // Temps têm que ser criadas fora da função de load para serem recuperadas
	local bases `bases' `base_`tr'' // Local que armazena todas essas bases
}

load_pof08, trs(`trs') temps(`bases') original(`original') `english'

* Caso só se queira os TRs crus, acaba por aqui
if "`sel'" == "" & "`std'" == ""{
	
	cd "`saving'"

	foreach tr in `trs'{
		use `base_`tr'', clear
		save pof2008_`tr', replace
	}
}

* Caso contrário, falta aplicar a função de bases selecionadas ou a de bases padronizadas

else if "`sel'" != ""{
	pofsel_08, id(`id') sel(`sel') trs(`trs') temps(`bases') original(`original') `english'
	
	cd "`saving'"
	save pof2008_`id'_custom, replace
}
else{
	foreach type in `id'{
		pofstd_08, id(`type') trs(`trs') temps(`bases') original(`original') `english'
	
		cd "`saving'"
		save "pof2008_`type'_standard", replace
	}
}

di as result "As bases foram salvas em `saving'"

end

program load_pof08 // Armazena as bases nas temps fornecidas
syntax, temps(string) original(string) trs(string) [english]

if "`english'" != "" local lang "_en"

cd "`original'"

local registros "DOMICILIO MORADOR MORADOR_IMPUT CONDICOES_DE_VIDA INVENTARIO DESPESA_90DIAS DESPESA_12MESES OUTRAS_DESPESAS SERVICO_DOMS ALUGUEL_ESTIMADO CADERNETA_DESPESA DESPESA_INDIVIDUAL DESPESA_VEICULO RENDIMENTOS OUTROS_RECI CONSUMO"

forvalues i = 1/`: word count `trs''{
	
	local tr: word `i' of `trs'
	local base: word `i' of `temps'
	
	local num = substr("`tr'", 3, .) // tr1 -> 1, tr11 -> 11
	local registro: word `num' of `registros'
	
	di as input "Extraindo TR`num': `registro'"
	
	tempfile dic

	findfile dict.dta

	read_compdct, compdct("`r(fn)'") dict_name("pof2008_`tr'`lang'") out("`dic'")
	
	qui infile using `dic', using("`original'/T_`registro'_S.txt") clear
	
	qui save `base', replace // Salva o TR na tempfile destinada a ele
}

end
