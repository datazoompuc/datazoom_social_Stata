******************************************************
*		 		  datazoom_ecinf.ado				 	 *
******************************************************
* VERSION 1.0

program define datazoom_ecinf

syntax, year(numlist) original(str) saving(str) tipo(str) [merged]

cd "`saving'"

loc n = 1
tokenize `tipo'

while "`*'" != "" {
	di _newline as input "Extracting `year' `1' datafile ..."
	findfile ecinf`year'_`1'_en.dct
	if "`year'"=="2003" {
		qui infile using `"`r(fn)'"', using("`original'/`1'.txt") clear
	}
	qui else {
		if "`1'"=="domicilios" infile using `"`r(fn)'"', using("`original'/DOMICÍLIOS.txt") clear
		if "`1'"=="moradores" infile using `"`r(fn)'"', using("`original'/MORADORES.txt") clear
		if "`1'"=="trabrend" infile using `"`r(fn)'"', using("`original'/TRABALHO e  RENDIMENTO.txt") clear
		if "`1'"=="uecon" infile using `"`r(fn)'"', using("`original'/UNIDADE ECONÔNICA.txt") clear
		if "`1'"=="pesocup" infile using `"`r(fn)'"', using("`original'/PESSOAL OCUPADO.txt") clear
		if "`1'"=="indprop" infile using `"`r(fn)'"', using("`original'/CARACTERÍSTICAS DOS PROPRIETÁRIOS.txt") clear
	}
	if "`1'"=="moradores" & `year'==2003 {
			sort v02 v04, stable
			by v02 v04: replace ordem = ordem[_n-1]+1 if ordem==.
	}
	save ecinf`year'_`1', replace
	macro shift
	loc n = `n' + 1
}

end
