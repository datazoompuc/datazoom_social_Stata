* VERSION 1.2
program datazoom_poftrs_02
syntax , trs(string) original(string) saving(string)

cd "`saving'"

tokenize `trs'
di "`*'"
qui while "`*'"~="" {
	findfile pof2002_`1'_en.dct

	if "`1'"=="tr1" {
		infile using `"`r(fn)'"', using("`original'/T_DOMICILIO.txt") clear
	}
	if "`1'"=="tr2" {
		infile using `"`r(fn)'"', using("`original'/T_MORADOR.txt") clear
	}
	if "`1'"=="tr3" {
		infile using `"`r(fn)'"', using("`original'/T_CONDICOES_DE_VIDA.txt") clear
	}
	if "`1'"=="tr4" {
		infile using `"`r(fn)'"', using("`original'/T_INVENTARIO.txt") clear
	}
	if "`1'"=="tr5" {
		infile using `"`r(fn)'"', using("`original'/T_DESPESA_90DIAS.txt") clear
	}
	if "`1'"=="tr6" {
		infile using `"`r(fn)'"', using("`original'/T_DESPESA_12MESES.txt") clear
	}
	if "`1'"=="tr7" {
		infile using `"`r(fn)'"', using("`original'/T_OUTRAS_DESPESAS.txt") clear
	}
	if "`1'"=="tr8" {
		infile using `"`r(fn)'"', using("`original'/T_SERVICO_DOMS.txt") clear
	}
	if "`1'"=="tr9" {
		infile using `"`r(fn)'"', using("`original'/T_CADERNETA_DESPESA.txt") clear
	}
	if "`1'"=="tr10" {
		infile using `"`r(fn)'"', using("`original'/T_DESPESA.txt") clear
	}
	if "`1'"=="tr11" {
		infile using `"`r(fn)'"', using("`original'/T_DESPESA_VEICULO.txt") clear
	}
	if "`1'"=="tr12" {
		infile using `"`r(fn)'"', using("`original'/T_RENDIMENTOS1.txt") clear
	}
	if "`1'"=="tr13" {
		infile using `"`r(fn)'"', using("`original'/T_OUTROS_RECI.txt") clear
	}
	if "`1'"=="tr14" {
		infile using `"`r(fn)'"', using("`original'/T_DESPESA_ESP.txt") clear
	}

	save pof2002_`1', replace
	macro shift
}
display as result "The databases were saved in the following folder `c(pwd)'"

end
