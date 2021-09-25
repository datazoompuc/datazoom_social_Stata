* VERSION 1.2
program datazoom_poftrs_08
syntax , trs(string) original(string) saving(string) [english]

if "`english'" != "" local lang "_en"

cd "`saving'"

tokenize `trs'
di "`*'"
while "`*'"~="" {
	
	tempfile dic

	findfile dict.dta

	read_compdct, compdct("`r(fn)'") dict_name("pof2008_`1'`lang'") out("`dic'")

	if "`1'"=="tr1" {
		qui cap infile using `dic', using("`original'/T_DOMICILIO_S.txt") clear
	}
	if "`1'"=="tr2" {
		qui cap infile using `dic', using("`original'/T_MORADOR_S.txt") clear
	}
	if "`1'"=="tr3" {
		qui cap infile using `dic', using("`original'/T_MORADOR_IMPUT_S.txt") clear
	}
	if "`1'"=="tr4" {
		qui cap infile using `dic', using("`original'/T_CONDICOES_DE_VIDA_S.txt") clear
	}
	if "`1'"=="tr5" {
		qui cap infile using `dic', using("`original'/T_INVENTARIO_S.txt") clear
	}
	if "`1'"=="tr6" {
		qui cap infile using `dic', using("`original'/T_DESPESA_90DIAS_S.txt") clear
	}
	if "`1'"=="tr7" {
		qui cap infile using `dic', using("`original'/T_DESPESA_12MESES_S.txt") clear
	}
	if "`1'"=="tr8" {
		qui cap infile using `dic', using("`original'/T_OUTRAS_DESPESAS_S.txt") clear
	}
	if "`1'"=="tr9" {
		qui cap infile using `dic', using("`original'/T_SERVICO_DOMS_S.txt") clear
	}
	if "`1'"=="tr10" {
		qui cap infile using `dic', using("`original'/T_ALUGUEL_ESTIMADO_S.txt") clear
	}
	if "`1'"=="tr11" {
		qui cap infile using `dic', using("`original'/T_CADERNETA_DESPESA_S.txt") clear
	}
	if "`1'"=="tr12" {
		qui cap infile using `dic', using("`original'/T_DESPESA_INDIVIDUAL_S.txt") clear
	}
	if "`1'"=="tr13" {
		qui cap infile using `dic', using("`original'/T_DESPESA_VEICULO_S.txt") clear
	}
	if "`1'"=="tr14" {
		qui cap infile using `dic', using("`original'/T_RENDIMENTOS_S.txt") clear
	}
	if "`1'"=="tr15" {
		qui cap infile using `dic', using("`original'/T_OUTROS_RECI_S.txt") clear
	}
	if "`1'"=="tr16" {
		qui cap infile using `dic', using("`original'/T_CONSUMO_S.txt") clear
	}

	save pof2008_`1', replace
	macro shift
}

end
