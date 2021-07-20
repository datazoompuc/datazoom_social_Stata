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
		if (`year' == 2021) {
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
	foreach pa in 1 2 3 4 5 6 7 8{
	use PNADC`aa', clear
	keep if V1014 == `pa'
	tempfile PNADC_Painel`pa'temp`aa'
	save `PNADC_Painel`pa'temp`aa'', replace
	}
}


foreach pa in 1 2 3 4 5 6 7 8{
	foreach aa in `years' {
		append using `PNADC_Painel`pa'temp`aa''
		keep if V1014 == `pa'
	}
	tempfile PNADC_Painel`pa'	
	save `PNADC_Painel`pa'', replace	
}

global panels = ""
forvalues pa = 1(1)8{
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
							Mês de nascimento */ V20081 == V20081[_n - `j'] & /*
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
			****************************************************************
			* Emparelhamento avançado
			****************************************************************
			* Somente para chefes, conjuges e filhos adultos
			tempvar ager aux
			* Função de erro na idade presumida
			g `ager' = cond(V2009>=25 & V2009<999, exp(V2009/30), 2)
			* Isolando observaçõess ja emparelhadas
			g `aux' = (forw==1 & (n_p==1 | back==1)) | (back==1 & n_p==5)
			* Ordenando cada famÃ­lia pelo prÃ­doso (trimestre) de entrevista
			sort `aux' UF UPA V1008 V1014 V2007 Ano Trimestre V2009 VD3004 V2003 
			* Loop para procurar a mesma pessoa em uma posição anterior
			loc j = 1
			loc stop = 0
			loc count = 0
			while `stop' == 0 {
				loc lastcount = `count'
				count if p201==. & n_p==`i'+1 & ///
				(V2005<=3 | (V2005==4 & V2009>=25 ///
				& V2009<999)) /* observações não emparelhadas */
				loc count = r(N)
				if `count' == `lastcount' {
					loc stop = 1
				}
				else {
					if r(N) != 0 {
						replace p201 = p201[_n - `j'] if /*
							identificação do domicilio
							*/ UF == UF[_n - `j'] & ///
							UPA == UPA[_n - `j'] & ///
							V1008 == V1008[_n - `j'] & ///
							V1014 == V1014[_n - `j'] & /*
							Diferença entre períodos */ n_p == `i'+1 & n_p[_n - `j'] == `i' /*
							Excluir emparelhados */ & p201 ==. & forw[_n - `j'] != 1 & /*
							Caracteristicas individuais
							Sexo */ V2007 == V2007[_n - `j'] & /*
							Diferença na idade */ abs(V2009 - V2009[_n - `j'])<=`ager' & /*
							Idade observada */ V2009!=999 & /*
							Se chefe ou conjuge */ ((V2005<=3 & V2005[_n - `j']<=3) | /*
							ou filho com mais de 25 */ (V2009>=25 & V2009[_n - `j']>=25 & ///
							V2005==4 & V2005[_n - `j']==4)) & /*
							Ate 4 dias de erro na data */ ((abs(V2008 - V2008[_n - `j'])<=4 & /*
							Ate 2 meses de erro na data*/ abs(V20081 - V20081[_n - `j'])<=2 & /*
							Informação observada */ V2008!=99 & V20081!=99) /*
							ou */ | /*
							1 ciclo de erro na educação*/ (abs(VD3004 - VD3004[_n - `j'])<=1 /*
							e */ & /*
							Ate 2 meses de erro na data*/ ((abs(V20081 - V20081[_n - `j'])<=2 & /*
							Informação observada */ V20081!=99 & /*
							Informação não observada */ (V2008==99 | V2008[_n-`j']==99)) /*
							ou */ | /*
							Ate 4 dias de erro na data */ (abs(V2008 - V2008[_n - `j'])<=4 & /*
							InformaÃ£o observada */ V2008!=99 & /*
							Informação não observada */ (V20081==99 | V20081[_n - `j']==99)) /*
							ou */ | /*
							informaçoes não observadas */ ((V2008==99 | V2008[_n - `j']==99) & ///
							(V20081==99 | V20081[_n - `j']==99)))))
						replace forw = 1 if UF == UF[_n + `j'] & ///
							UPA == UPA[_n + `j'] & ///
							V1008 == V1008[_n + `j'] & ///
							V1014 == V1014[_n + `j'] & ///
							p201 == p201[_n + `j'] & ///
							n_p == `i' & n_p[_n + `j']==`i'+1 ///
							& forw != 1
						loc j = `j' + 1
					}
					else {
						loc stop = 1
					}
				}
			}
			replace back = p201 !=. if n_p == `i'+1
			replace forw = 0 if forw != 1 & n_p == `i'

			****************************************************************
			* Emparelhamento avançado
			****************************************************************
			* Somente em domicilio onde alguÃ©m ja emparelhou
			* Quantas pessoas emparelharam no domicilio
			tempvar dom
			bys Ano Trimestre UF UPA V1008 V1014: egen `dom' = sum(back)
			* Loop com os critê³©os de emparelhamento
			foreach w in /*mesma idade*/ "0" /*erro na idade = 1*/ "1" /*
			erro na idade = 2*/ "2" /*erro na idade = f(idade)*/ "`ager'" /*
			2xf(idade)*/ "2*`ager' & V2009>=25" {
			* Isolando observações ja mparelhadas
				tempvar aux
				g `aux' = (forw==1 & (n_p==1 | back==1)) | ///
				(back==1 & n_p==5) | (`dom'==0 & n_p==`i'+1)
				sort `aux' UF UPA V1008 V1014 V2007 Ano Trimestre V2009 ///
				VD3004 V2003
				loc j = 1
				loc stop = 0
				loc count = 0
				while `stop' == 0 {
					loc lastcount = `count'
					count if p201 == . & n_p == `i'+1 & `dom'>0 & `dom'!=.
					loc count = r(N)
					if `count' == `lastcount' {
						loc stop = 1
					}
					else {
						if r(N) != 0 {
							replace p201 = p201[_n - `j'] if /*
								identificação do domicilio
								*/ UF == UF[_n - `j'] & ///
								UPA == UPA[_n - `j'] & ///
								V1008 == V1008[_n - `j'] & ///
								V1014 == V1014[_n - `j'] & /*
								Diferença entre periodos */ n_p == `i'+1 & n_p[_n-`j'] == `i' /*
								excluir emparelhados */ & p201 ==. & forw[_n - `j'] != 1 & /*
								h emparelhados no domicilio*/ `dom' > 0 & `dom'!=. & /*
								Caracteristicas individuais
								Sexo */ V2007 == V2007[_n - `j'] & /*
								Criterio mudam com a loop */ ((abs(V2009-V2009[_n - `j'])<=`w' & /*
								se a idade observada */ V2009!=999) /*
								caso contrario */ | /*
								Mesma escolaridade */ (VD3004==VD3004[_n - `j'] & /*
								Mesma condição no domicilio */ V2005==V2005[_n - `j'] & /*
								Idade não observada */ (V2009==999 | V2009[_n - `j']==999)))
							replace forw = 1 if UF == UF[_n + `j'] & ///
								UPA == UPA[_n + `j'] & ///
								V1008 == V1008[_n + `j'] & ///
								V1014 == V1014[_n + `j'] & ///
								p201 == p201[_n + `j'] & ///
								n_p ==`i' & n_p[_n+`j']==`i'+1 ///
								& forw != 1
							loc j = `j' + 1
						}
						else {
							loc stop = 1
						}
					}
				}
			}
			replace back = p201 !=. if n_p == `i'+1
			replace forw = 0 if forw != 1 & n_p == `i'
			* identificação para quem estava ausente na Ãºltima entrevista
			replace p201 = `i'00 + V2003 if p201 == . & n_p == `i'+1
		}

		****************************************************************
		* Recuperar quem saiu e retornou para o painel - 2a loop
		****************************************************************
		* Variavel temporaria identificando o emparelhamento à¡¦rente
		tempvar fill
		g `fill' = forw
		* Loop retrospectivo por entrevista
		foreach i in 4 3 2 1 {
			tempvar ncode1 ncode2 aux max ager
			* Funçao de erro na idade presumida
			g `ager' = cond(V2009>=25 & V2009<999, exp(V2009/30), 2)
			* Variável que preserva o antigo nò­¥²o
			bys UF UPA V1008 V1014 p201: g `ncode1' = p201
			* Isolando observações emparelhadas
			g `aux' = ((`fill'==1 & (n_p==1 | back==1)) | (back==1 & n_p==5))
			* Variavel identificando a proxima entrevista
			bys UF UPA V1008 V1014 p201: egen `max' = max(n_p)
			sort `aux' UF UPA V1008 V1014 V2007 n_p V2003 p201
			loc j = 1
			loc stop = 0
			loc count = 0
			while `stop' == 0 {
				loc lastcount = `count'
				count if p201>`i'00 & p201<`i'99 & back==0
				loc count = r(N)
				if `count' == `lastcount' {
					loc stop = 1
				}
				else {
					if r(N) != 0 {
						replace p201 = p201[_n - `j'] if /*
							identificação do domicilio
							*/ UF == UF[_n - `j'] & ///
							UPA == UPA[_n - `j'] & ///
							V1008 == V1008[_n - `j'] & ///
							V1014 == V1014[_n - `j'] & /*
							Quem entrou na entrevista i*/ p201>`i'00 & p201<`i'99 & /*
							não emparelhado */ back==0 & `fill'[_n - `j']!=1 & /*
							Uma entrev. de diferença*/ `max'[_n - `j']<`i' & ///
							p201[_n - `j']<`i'00-100 & /*
							Sexo */ V2007 == V2007[_n - `j'] & /*
							Diferença na idade */ ((abs(V2009 - V2009[_n - `j'])<=`ager' & /*
							Idade observada */ V2009!=999 & /*
							Ate 4 dias de erro na data */ ((abs(V2008 - V2008[_n - `j'])<=4 & /*
							Ate 2 meses de erro na data*/ abs(V20081 - V20081[_n - `j'])<=2 & /*
							informação observada */ V2008!=99 & V20081!=99) /*
							ou */ | /*
							1 ciclo de erro na educação*/ (abs(VD3004 - VD3004[_n - `j'])<=1 /*
							e */ & /*
							Ate 2 meses de erro na data*/ ((abs(V20081 - V20081[_n - `j'])<=2 & /*
							Informação observada */ V20081!=99 & /*
							Informação não observada */ (V2008==99 | V2008[_n - `j']==99)) /*
							ou */ | /*
							Ate 4 dias de erro na data */ (abs(V2008 - V2008[_n - `j'])<=4 & /*
							Informação observada */ V2008!=99 & /*
							Informação não observada */ (V20081==99 | V20081[_n - `j']==99)) /*
							ou */ | /*
							nada observado */ ((V2008==99 | V2008[_n - `j']==99) & ///
							(V20081==99 | V20081[_n - `j']==99)))))) /*
							ou */ | /*
							mesma escolaridade */ (VD3004==VD3004[_n - `j'] & /*
							e nÃºmero de ordem */ V2005==V2005[_n - `j'] /*
							Se idade não observada */ & (V2009==999 | V2009[_n - `j']==999)))
						* identificação de emparelhamento para quem está frente
						replace `fill' = 1 if UF == UF[_n + `j'] & ///
							UPA == UPA[_n + `j'] & ///
							V1008 == V1008[_n + `j'] & ///
							V1014 == V1014[_n + `j'] & ///
							p201 == p201[_n + `j'] & ///
							`fill' == 0 & `max'<`i' & ///
							(n_p[_n + `j'] - n_p)>=2
						loc j = `j' + 1
					}
					else {
						loc stop = 1
					}
				}
			}
			* Igualando o número de quem era igual
			bys UF UPA V1008 V1014 `ncode1': egen `ncode2' = min(p201)
			replace p201 = `ncode2'
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
	drop __* back forw hous_id ind_id id_dom id_chefe n_p_aux n_p p201
	replace painel=`pa'
	save PNAD_painel_`pa'_rs, replace
	}
}

********************************************************************
di _newline "Esta versão do pacote datazoom_pnadcontinua é compatí­vel com a última versão dos microdados da PNAD Contínua divulgados em 08/02/2021"
di _newline "As bases de dados foram salvas em `c(pwd)'"
end
