* VERSION 1.2
program datazoom_poftrs_02
syntax , trs(string) original(string) saving(string) [english]

if "`english'" != "" local lang "_en"

cd "`saving'"

tokenize `trs'
di "`*'"
while "`*'"~="" {
	
	tempfile dic

	findfile dict.dta

	read_compdct, compdct("`r(fn)'") dict_name("pof2002_`1'`lang'") out("`dic'")

	if "`1'"=="tr1" {
		qui cap infile using `dic', using("`original'/T_DOMICILIO.txt") clear
	}
	if "`1'"=="tr2" {
		qui cap infile using `dic', using("`original'/T_MORADOR.txt") clear
	}
	if "`1'"=="tr3" {
		qui cap infile using `dic', using("`original'/T_CONDICOES_DE_VIDA.txt") clear
	}
	if "`1'"=="tr4" {
		qui cap infile using `dic', using("`original'/T_INVENTARIO.txt") clear
	}
	if "`1'"=="tr5" {
		qui cap infile using `dic', using("`original'/T_DESPESA_90DIAS.txt") clear
	}
	if "`1'"=="tr6" {
		qui cap infile using `dic', using("`original'/T_DESPESA_12MESES.txt") clear
	}
	if "`1'"=="tr7" {
		qui cap infile using `dic', using("`original'/T_OUTRAS_DESPESAS.txt") clear
	}
	if "`1'"=="tr8" {
		qui cap infile using `dic', using("`original'/T_SERVICO_DOMS.txt") clear
	}
	if "`1'"=="tr9" {
		qui cap infile using `dic', using("`original'/T_CADERNETA_DESPESA.txt") clear
	}
	if "`1'"=="tr10" {
		qui cap infile using `dic', using("`original'/T_DESPESA.txt") clear
	}
	if "`1'"=="tr11" {
		qui cap infile using `dic', using("`original'/T_DESPESA_VEICULO.txt") clear
	}
	if "`1'"=="tr12" {
		qui cap infile using `dic', using("`original'/T_RENDIMENTOS1.txt") clear
	}
	if "`1'"=="tr13" {
		qui cap infile using `dic', using("`original'/T_OUTROS_RECI.txt") clear
	}
	if "`1'"=="tr14" {
		qui cap infile using `dic', using("`original'/T_DESPESA_ESP.txt") clear
	}

	save pof2002_`1', replace
	macro shift
}

end
