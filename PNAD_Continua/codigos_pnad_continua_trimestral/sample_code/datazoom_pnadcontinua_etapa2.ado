******************************************************
*             datazoom_pnadcontinua.ado              *
******************************************************
*version stata 14.2
program define datazoom_pnadcontinua

syntax, years(numlist) original(str) saving(str) [nid idbas idrs]

/* Pastas para guardar arquivos da sessão */
cd "`saving'"

di "`original'"
	
/* Dicionário */
findfile pnadcontinua.dct
loc dic = r(fn)

/* Extração dos arquivos */
tokenize `years'

local y`1' = ""
	
foreach year in `years'{
	foreach trim in 01 02 03 04 {
			if (`year' == 2020) {
			di as input "Extraindo arquivo PNADC_`trim'`year'  ..."
				cap infile using "`dic'", using("`original'/PNADC_`trim'`year'.txt") clear
				if _rc == 0 {
					qui capture egen hous_id = concat(UPA V1008 V1014), format(%14.0g)
					qui destring hous_id, replace
					qui capture egen ind_id = concat(UPA V1008 V1014 V2003), format(%16.0g)
					qui destring ind_id, replace
					tempfile PNADC_`trim'`year'
					save `PNADC_`trim'`year'', replace
					}
				else continue, break
			}	
			else if (`trim' == 04 & `year' == 2019) {
			di as input "Extraindo arquivo PNADC_`trim'`year'  ..."
				cap infile using "`dic'", using("`original'/PNADC_`trim'`year'.txt") clear
				if _rc == 0 {
					qui capture egen hous_id = concat(UPA V1008 V1014), format(%14.0g)
					qui destring hous_id, replace
					qui capture egen ind_id = concat(UPA V1008 V1014 V2003), format(%16.0g)
					qui destring ind_id, replace
					tempfile PNADC_`trim'`year'
					save `PNADC_`trim'`year'', replace
					}
				else continue, break
			}			
			else if (`trim' == 03 & `year' == 2019) {
			di as input "Extraindo arquivo PNADC_`trim'`year'  ..."
				cap infile using "`dic'", using("`original'/PNADC_`trim'`year'.txt") clear
				if _rc == 0 {
					qui capture egen hous_id = concat(UPA V1008 V1014), format(%14.0g)
					qui destring hous_id, replace
					qui capture egen ind_id = concat(UPA V1008 V1014 V2003), format(%16.0g)
					qui destring ind_id, replace
					tempfile PNADC_`trim'`year'
					save `PNADC_`trim'`year'', replace
					}
				else continue, break
			}
			else if (`trim' == 02 & `year' == 2019) {
			di as input "Extraindo arquivo PNADC_`trim'`year'  ..."
				cap infile using "`dic'", using("`original'/PNADC_`trim'`year'.txt") clear
				if _rc == 0 {
					qui capture egen hous_id = concat(UPA V1008 V1014), format(%14.0g)
					qui destring hous_id, replace
					qui capture egen ind_id = concat(UPA V1008 V1014 V2003), format(%16.0g)
					qui destring ind_id, replace
					tempfile PNADC_`trim'`year'
					save `PNADC_`trim'`year'', replace
					}
				else continue, break
			}						
			else  {
			di as input "Extraindo arquivo PNADC_`trim'`year'  ..."
				cap infile using "`dic'", using("`original'/PNADC_`trim'`year'_20190729.txt") clear
				if _rc == 0 {
					qui capture egen hous_id = concat(UPA V1008 V1014), format(%14.0g)
					qui destring hous_id, replace
					qui capture egen ind_id = concat(UPA V1008 V1014 V2003), format(%16.0g)
					qui destring ind_id, replace
					tempfile PNADC_`trim'`year'
					save `PNADC_`trim'`year'', replace
					}
				else continue, break
			}
			}

	}	

if _rc==901 exit	

********************************************************************
*                            Painel                                
********************************************************************

/* Criando pastas para guardar arquivos da sessão */
capture mkdir pnadcontinua
if _rc == 693 {
   tempname numpasta
   local numpasta = 0
   while _rc == 693 {
      capture mkdir "pnadcontinua_`++numpasta'"
   }
   cd "pnadcontinua_`numpasta'"
}
else {
   cd "pnadcontinua"
}

loc caminhoprin = c(pwd)


* juntando os trimestres de cada ano

foreach aa in `years' {	
	use `PNADC_01`aa'', clear
	foreach trim in 02 03 04 {
	capture append using `PNADC_`trim'`aa''
		if _rc != 0 {
		continue, break	
		}
	}
	if "`nid'"~="" {
		save PNADC_trimestral_`aa' 
		exit
	}
	else {
		tempfile PNADC`aa'
		save PNADC`aa', replace
	}
}


**********
*junta paineis 
 	*Combinações

*tokenize `years'
foreach aa in `years' {
foreach pa in 1 2 3 4 5 6 7{
	use PNADC`aa', clear
	keep if V1014 == `pa'
	tempfile PNADC_Painel`pa'temp`aa'
	save `PNADC_Painel`pa'temp`aa'', replace
}
}


foreach pa in 1 2 3 4 5 6 7{
foreach aa in `years' {
	append using `PNADC_Painel`pa'temp`aa''
	keep if V1014 == `pa'
	}
tempfile PNADC_Painel`pa'	
save `PNADC_Painel`pa'', replace	
}

global panels = ""
forvalues pa = 1(1)7{
	use `PNADC_Painel`pa'', clear
	qui count
	if r(N) != 0 { 
		global panels = "$panels `pa'" /* Coleta os paineis existentes */
	}
}

display "$panels"


/*_______________________________________________________________________*/
/*______________________Executa a identificação Básica___________________*/
/*_______________________________________________________________________*/
qui if "`idbas'" != "" {
	noi display as result "Executando Identificação Básica ..."
	foreach pa in $panels {
		noi display as result "Painel `pa'"
		use `PNADC_Painel`pa'', clear
		gen painel =.
		/*Algoritmo Básico*/
		****************************************************************
		* Variáveis do painel
		****************************************************************
		*definindo a primeira entrevista
		egen id_dom =group(UPA V1008 V1014)
		egen id_chefe=group(UPA V1008 V1014 V2005)
		replace id_chefe=. if V2005~=1
		sort id_chefe id_dom Ano Trimestre
		bysort id_chefe: gen n_p_aux = _n
		replace n_p_aux=. if V2005~=1
		bysort id_dom Ano Trimestre: egen n_p = mean(n_p_aux)
		tab n_p, m

		* Variávei de identificação da pessoa no painel
		g p201 = V2003 if n_p == 1 /* definido com base na 1a entrevista */
		
		* Variaveis que identificam o emparelhamento
		g back = . /* com uma entrevista anterior */
		g forw = . /* com uma entrevista posterior */
		
		****************************************************************
		* Emparelhamento - 1a loop
		****************************************************************
		* Emparelhamento para cada par de entrevista por vez
		forvalues i = 1/4 {
		****************************************************************
		* Emparelhamento-padrão- se a data de nascimento está correta
		****************************************************************
		* Ordenando cada indivÃ­duo pelo período (trimestre) de entrevista
			sort UF UPA V1008 V1014 V2007 V2008 V20081 V20082 Ano Trimestre V2003  
		* Loop para procurar a mesma pessoa em uma posição anterior
			loc j = 1 /* j determina a posição anterior na base */
			loc stop = 0 /* se stop=1, a loop para */
			loc count = 0
			while `stop' == 0 {
				loc lastcount = `count'
				count if p201 == . & n_p == `i'+1 /* observações não emparelhadas */
				loc count = r(N)
				if `count' == `lastcount' {
		* Parar caso a loop não esteja emparelhando mais
					loc stop = 1
				}
				else {
					if r(N) != 0 {
		* Captando a identificação p201 da observação anterior
						replace p201 = p201[_n - `j'] if /*
		identificação do domicilio
						*/	UF == UF[_n - `j'] & ///
						UPA == UPA[_n - `j'] & ///
						V1008 == V1008[_n - `j'] & ///
						V1014 == V1014[_n - `j'] & /*
						diferença entre períodos */ n_p == `i'+1 & n_p[_n - `j'] == `i' /*
						excluir emparelhados */ & p201 ==. & forw[_n - `j'] != 1 & /*
						Caracteristicas individuais
						Sexo */ V2007 == V2007[_n - `j'] & /*
						Dia de nascimento */ V2008 == V2008[_n - `j'] & /*
						Mês de nascimento */ V20081 == V20081[_n - `j'] & /*
						Ano de nascimento */ V20082 == V20082[_n - `j'] & /*
						Informação observada */ V2008!=99 & V20081!=99 & V20082!=9999
						
		* identificação de emparelhamento para quem está frente
						replace forw = 1 if UF == UF[_n + `j'] & ///
						UPA == UPA[_n + `j'] & ///
						V1008 == V1008[_n + `j'] & ///
						V1014 == V1014[_n + `j'] & ///
						p201 == p201[_n + `j'] & ///
						n_p == `i' & n_p[_n + `j']==`i'+1 ///
						& forw != 1
						loc j = `j' + 1 /* passando para a prÃ³xima observação */
					}
					else {
		* Parar se não há observaçoes para emparelhar
						loc stop = 1
					}
				}
			}
		* Recodificar varaveis de identificação do emparelhamento
			replace back = p201 !=. if n_p == `i'+1
			replace forw = 0 if forw != 1 & n_p == `i'
		* identificação para quem estava ausente na Ãºltima entrevista
			replace p201 = `i'00 + V2003 if p201 == . & n_p == `i'+1
		}
		
		tempvar a b c d
		tostring UF, g(`a')
		tostring UPA, g(`b') format(%09.0f)
		tostring V1008, g(`c') format(%03.0f)
		tostring p201, g(`d') format(%03.0f)
		egen idind = concat(V1014 `a' `b' `c' `d')
		replace idind = "" if p201 ==.
		replace idind = "" if V2008==99 | V20081==99 | V20082==9999
		lab var idind "identificacao do individuo"
		drop __* back forw hous_id ind_id id_dom id_chefe n_p_aux n_p p201
		replace painel=`pa'
		save PNAD_painel_`pa'_basic, replace
	}
}


/*_______________________________________________________________________*/
/*___________________Executa a identificação Ribas Soares________________*/
/*_______________________________________________________________________*/
qui if "`idrs'" != "" {
	noi display as result "Executando Identificação Avançada ..."
	foreach pa in $panels {
		noi display as result "Painel `pa'"
		use `PNADC_Painel`pa'', clear
	    gen painel =.
		/*Algoritmo de Ribas e Soares*/
		****************************************************************
		* Variaveis do painel
		****************************************************************
		*definindo a primeira entrevista
		egen id_dom = group(UPA V1008 V1014)
		egen id_chefe=  group(UPA V1008 V1014 V2005)
		replace id_chefe=. if V2005~=1
		sort id_chefe id_dom Ano Trimestre
		bysort id_chefe: gen n_p_aux = _n
		replace n_p_aux=. if V2005~=1
		bysort id_dom Ano Trimestre: egen n_p = mean(n_p_aux)
		tab n_p, m
		
		* Variavel de identificação da pessoa no painel
		g p201 = V2003 if n_p == 1 /* definido com base na 1a entrevista */
		* Variavei que identificam o emparelhamento
		g back = . /* com uma entrevista anterior */
		g forw = . /* com uma entrevista posterior */
		
		****************************************************************
		* Emparelhamento - 1a loop
		****************************************************************
		* Emparelhamento para cada par de entrevista por vez
		forvalues i = 1/4 {
			****************************************************************
			* Emparelhamento-padrão- se a data de nascimento está correta
			****************************************************************
			* Ordenando cada indivÃ­duo pelo período (trimestre) de entrevista
			sort UF UPA V1008 V1014 V2007 V2008 V20081 V20082 Ano Trimestre V2003 	
			* Loop para procurar a mesma pessoa em uma posição anterior
			loc j = 1 /* j determina a posição anterior na base */
			loc stop = 0 /* se stop=1, a loop para */
			loc count = 0
			while `stop' == 0 {
				loc lastcount = `count'
				count if p201 == . & n_p == `i'+1 /* observações não emparelhadas */
				loc count = r(N)
				if `count' == `lastcount' {
				* Parar caso a loop não esteja emparelhando mais
					loc stop = 1
				}
				else {
					if r(N) != 0 {
						* Captando a identificação p201 da observação anterior
						replace p201 = p201[_n - `j'] if /*
						identificação do domicilio
						*/ UF == UF[_n - `j'] & ///
						UPA == UPA[_n - `j'] & ///
						V1008 == V1008[_n - `j'] & ///
						V1014 == V1014[_n - `j'] & /*
						diferenças entre períodos */ n_p == `i'+1 & n_p[_n - `j'] == `i' /*
						excluir emparelhados */ & p201 ==. & forw[_n - `j'] != 1 & /*
						CaracterÃ­sicas individuais
						Sexo */ V2007 == V2007[_n - `j'] & /*
						Dia de nascimento */ V2008 == V2008[_n - `j'] & /*
						MÃªs de nascimento */ V20081 == V20081[_n - `j'] & /*
						Ano de nascimento */ V20082 == V20082[_n - `j'] & /*
						Informação observada */ V2008!=99 & V20081!=99 & V20082!=9999
						* identificação de emparelhamento para quem está¡  frente
						replace forw = 1 if UF == UF[_n + `j'] & ///
						UPA == UPA[_n + `j'] & ///
						V1008 == V1008[_n + `j'] & ///
						V1014 == V1014[_n + `j'] & ///
						p201 == p201[_n + `j'] & ///
						n_p == `i' & n_p[_n + `j']==`i'+1 ///
						& forw != 1
						loc j = `j' + 1 /* passando para a próxima observação */
					}
					else {
						* Parar se não há observações para emparelhar
						loc stop = 1
					}
				}
			}
			* Recodificar variáveis de identificação do emparelhamento
			replace back = p201 !=. if n_p == `i'+1
			replace forw = 0 if forw != 1 & n_p == `i'
		
	
			****************************************************************
			* Emparelhamento avançado
			****************************************************************
			* Se sexo e ano de nascimento não estiverem corretos
			* Isolando observações ja emparelhadas
			tempvar aux
			g `aux' = (forw==1 & (n_p==1 | back==1)) | (back==1 & n_p==5)
			* Ordenando cada indivÃ­duo pelo trimestre de entrevista
			sort `aux' UF UPA V1008 V1014 V2007 V2008 V20081 V2003 Ano Trimestre 
			* Loop para procurar a mesma pessoa em uma posição anterior
			loc j = 1 /* j determina a posição anterior na base */
			loc stop = 0 /* se stop=1, a loop para */
			loc count = 0
			while `stop' == 0 {
				loc lastcount = `count'
				count if p201 == . & n_p == `i'+1 /* observações não emparelhadas */
				loc count = r(N)
				if `count' == `lastcount' {
				* Parar caso a loop não esteja emparelhando mais
					loc stop = 1
				}
				else {
					if r(N) != 0 {
						* Captando a identificação  p201 da observação anterior
						replace p201 = p201[_n - `j'] if /*
						identificação do domicilio
						*/ UF == UF[_n - `j'] & ///
						UPA == UPA[_n - `j'] & ///
						V1008 == V1008[_n - `j'] & ///
						V1014 == V1014[_n - `j'] & /*
						diferença entre períodos */ n_p == `i'+1 & n_p[_n - `j'] == `i' /*
						excluir emparelhados */ & p201 ==. & forw[_n - `j'] != 1 & /*
						Caracteristicas individuais
						Dia de nascimento */ V2008 == V2008[_n - `j'] & /*
						MÃªs de nascimento */ V20082 == V20082[_n - `j'] & /*
						Mesmo nÃºmeroo de ordem */ V2003 == V2003[_n - `j'] & /*
						Informação observada */ V2008!=99 & V20081!=99
						* Identificaè¤¯ de emparelhamento para quem está¡  frente
						replace forw = 1 if UF == UF[_n + `j'] & ///
						UPA == UPA[_n + `j'] & ///
						V1008 == V1008[_n + `j'] & ///
						V1014 == V1014[_n + `j'] & ///
						p201 == p201[_n + `j'] & ///
						n_p == `i' & n_p[_n + `j']==`i'+1 ///
						& forw != 1
						loc j = `j' + 1 /* passando para a próxima observação */
					}

					else {
						* Parar se não há observações para emparelhar
						loc stop = 1
					}
				}
			}
		}
	tempvar a b c d
	tostring UF, g(`a')
	tostring UPA, g(`b') format(%09.0f)
	tostring V1008, g(`c') format(%03.0f)
	tostring p201, g(`d') format(%03.0f)
	egen idind = concat(V1014 `a' `b' `c' `d')
	replace idind = "" if p201 ==.
	*replace idind = "" if V2008==99 | V20081==99 | V20082==9999
	lab var idind "identificacao do individuo"
	*drop __* back forw hous_id ind_id id_dom id_chefe n_p_aux n_p p201
	replace painel=`pa'
	save PNAD_painel_`pa'_rs, replace
	}
}

********************************************************************
di _newline "Esta versão do pacote datazoom_pnadcontinua é compatí­vel com a última versão dos microdados da PNAD Contínua divulgados em 19/09/2019"
di _newline "As bases de dados foram salvas em `c(pwd)'"
end
