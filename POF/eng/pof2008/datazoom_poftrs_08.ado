* VERSION 1.2
program datazoom_poftrs_08
syntax , trs(string) original(string) saving(string)

cd "`saving'"

tokenize `trs'
di "`*'"
qui while "`*'"~="" {
	findfile pof2008_`1'_en.dct

	if "`1'"=="tr1" {
		infile using `"`r(fn)'"', using("`original'/T_DOMICILIO_S.txt") clear
	}
	if "`1'"=="tr2" {
		infile using `"`r(fn)'"', using("`original'/T_MORADOR_S.txt") clear
	}
	if "`1'"=="tr3" {
		infile using `"`r(fn)'"', using("`original'/T_MORADOR_IMPUT_S.txt") clear
	}
	if "`1'"=="tr4" {
		infile using `"`r(fn)'"', using("`original'/T_CONDICOES_DE_VIDA_S.txt") clear
	}
	if "`1'"=="tr5" {
		infile using `"`r(fn)'"', using("`original'/T_INVENTARIO_S.txt") clear
	}
	if "`1'"=="tr6" {
		infile using `"`r(fn)'"', using("`original'/T_DESPESA_90DIAS_S.txt") clear
	}
	if "`1'"=="tr7" {
		infile using `"`r(fn)'"', using("`original'/T_DESPESA_12MESES_S.txt") clear
	}
	if "`1'"=="tr8" {
		infile using `"`r(fn)'"', using("`original'/T_OUTRAS_DESPESAS_S.txt") clear
	}
	if "`1'"=="tr9" {
		infile using `"`r(fn)'"', using("`original'/T_SERVICO_DOMS_S.txt") clear
	}
	if "`1'"=="tr10" {
		infile using `"`r(fn)'"', using("`original'/T_ALUGUEL_ESTIMADO_S.txt") clear
	}
	if "`1'"=="tr11" {
		infile using `"`r(fn)'"', using("`original'/T_CADERNETA_DESPESA_S.txt") clear
	}
	if "`1'"=="tr12" {
		infile using `"`r(fn)'"', using("`original'/T_DESPESA_INDIVIDUAL_S.txt") clear
	}
	if "`1'"=="tr13" {
		infile using `"`r(fn)'"', using("`original'/T_DESPESA_VEICULO_S.txt") clear
	}
	if "`1'"=="tr14" {
		infile using `"`r(fn)'"', using("`original'/T_RENDIMENTOS_S.txt") clear
	}
	if "`1'"=="tr15" {
		infile using `"`r(fn)'"', using("`original'/T_OUTROS_RECI_S.txt") clear
	}
	if "`1'"=="tr16" {
		infile using `"`r(fn)'"', using("`original'/T_CONSUMO_S.txt") clear
	}

	save pof2008_`1', replace
	macro shift
}
display as result "The databases were saved in the following folder `c(pwd)'"

end
