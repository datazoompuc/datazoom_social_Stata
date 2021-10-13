******************************************************
*		 		  datazoom_ecinf.ado				 	 *
******************************************************
* VERSION 1.0

program define datazoom_ecinf
syntax, year(numlist) original(str) saving(str) tipo(str) [merged english]

cd "`saving'"

load_ecinf, year(`year') original(`original') saving(`saving') tipo(`tipo') `merged' `english'

end

program load_ecinf
syntax, year(numlist) original(str) saving(str) tipo(str) [merged english]

if "`english'" != "" local lang "_en"

loc n = 1
tokenize `tipo'

while "`*'" != "" {
	di _newline as input "Extraindo arquivo `year' `1' ..."
	
	tempfile dic

	findfile dict.dta

	read_compdct, compdct("`r(fn)'") dict_name("ecinf`year'_`1'`lang'") out("`dic'")
	
	if "`year'"=="2003" {
		qui infile using `dic', using("`original'/`1'.txt") clear
	}
	qui else {
		if "`1'"=="domicilios" infile using `dic', using("`original'/DOMICÍLIOS.txt") clear
		if "`1'"=="moradores" infile using `dic', using("`original'/MORADORES.txt") clear
		if "`1'"=="trabrend" infile using `dic', using("`original'/TRABALHO e  RENDIMENTO.txt") clear
		if "`1'"=="uecon" infile using `dic', using("`original'/UNIDADE ECONÔNICA.txt") clear
		if "`1'"=="pesocup" infile using `dic', using("`original'/PESSOAL OCUPADO.txt") clear
		if "`1'"=="indprop" infile using `dic', using("`original'/CARACTERÍSTICAS DOS PROPRIETÁRIOS.txt") clear
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
