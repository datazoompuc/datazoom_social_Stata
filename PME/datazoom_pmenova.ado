******************************************************
*				  datazoom_pmenova.ado				 *
******************************************************
* VERSION 1.3
program define datazoom_pmenova

syntax, years(numlist) original(str) saving(str) [nid idbas idrs english]

cd "`saving'"

di "`original'"

if "`english'" != "" local lang "_en"
	
/* Deflator */

findfile deflator_pmenova.dta
use "`r(fn)'"
rename ano v075
rename mes v070
sort v070 v075

tempfile deflator
save `deflator', replace
	
/*Abre Bases de Dados da PME Nova*/

tokenize `years'
findfile pmenova`lang'.dct
loc dic = r(fn)

while "`*'" != "" {
	local y`1' = ""

	foreach mm in 01 02 03 04 05 06 07 08 09 10 11 12 {
		if `1'==2002 & (`mm'==01 | `mm'==02) continue
		/* Extração do arquivo de 07/2009, cujo nome está em formato diferente */
		if `1'==2009 &`mm'==07 { 
		di as input "Extraindo arquivo `mm'/`1'  ..."
		cap infile using "`dic'", using("`original'/pmenova_`mm'`1'.txt") clear
		if _rc == 601 {
			cap infile using "`dic'", using("`original'/pmenova.`mm'`1'.txt") clear
			}
		if _rc == 0 {
			local y`1' = "`y`1'' `mm'"
				
			/*Utilização do deflator para variaveis monetarias*/
			merge m:1 v070 v075 using `deflator', keep(match) nogen
			foreach var in v4182 vI4182 v4191 vI4191 v4231 vI4231 v4241 vI4241 ///
				v4302 vI4302 v4312 vI4312 vD23 vD24 vD25 vD26 {
				gen `var'df = `var'/(deflator*converter) if `var' ~= 999999999
				lab var `var'df "`var' deflacionada"
			}
			tempfile pme`1'`mm'
			save `pme`1'`mm'', replace
		}
		continue
		}
		
		if `1'==2015 &`mm'==01 { 
		di as input "Extraindo arquivo `mm'/`1'  ..."
		cap infile using "`dic'", using("`original'/pmenova_`mm'`1'.txt") clear
		if _rc == 601 {
			cap infile using "`dic'", using("`original'/pmenova.`mm'`1'.txt") clear
			}
		if _rc == 0 {
			local y`1' = "`y`1'' `mm'"
				
			/*Utilização do deflator para variaveis monetarias*/
			merge m:1 v070 v075 using `deflator', keep(match) nogen
			foreach var in v4182 vI4182 v4191 vI4191 v4231 vI4231 v4241 vI4241 ///
				v4302 vI4302 v4312 vI4312 vD23 vD24 vD25 vD26 {
				gen `var'df = `var'/(deflator*converter) if `var' ~= 999999999
				lab var `var'df "`var' deflacionada"
			}
			tempfile pme`1'`mm'
			save `pme`1'`mm'', replace
		}
		continue
		}
		
		/* Extração dos demais arquivos*/
		di as input "Extraindo arquivo `mm'/`1'  ..."
		cap infile using "`dic'", using("`original'/pmenova.`mm'`1'.txt") clear
		if _rc == 0 {
			local y`1' = "`y`1'' `mm'"
				
			/*Utilização do deflator para variaveis monetarias*/
			merge m:1 v070 v075 using `deflator', keep(match) nogen
			foreach var in v4182 vI4182 v4191 vI4191 v4231 vI4231 v4241 vI4241 ///
				v4302 vI4302 v4312 vI4312 vD23 vD24 vD25 vD26 {
				gen `var'df = `var'/(deflator*converter) if `var' ~= 999999999
				lab var `var'df "`var' deflacionada"
			}
			tempfile pme`1'`mm'
			save `pme`1'`mm'', replace
		}
		else continue, break
	}
	if _rc != 0 continue, break
	macro shift
}
if _rc==901 exit	/* finaliza se não houver memória suficiente (necessário até stata 11) */


/* Criando pastas para guardar arquivos da sessão */
capture mkdir pmenova
if _rc == 693 {
   tempname numpasta
   local numpasta = 0
   while _rc == 693 {
      capture mkdir "pmenova_`++numpasta'"
   }
   cd "pmenova_`numpasta'"
}
else {
   cd "pmenova"
}
loc caminhoprin = c(pwd)

* juntando os meses de cada ano

foreach aa in `years' {
	gettoken first y`aa': y`aa'
	use `pme`aa'`first'', clear
	foreach mm of local y`aa' {
		append using `pme`aa'`mm''
	}
	if "`nid'"~="" {
		save pmenova`aa', replace
		exit
	}
	else {
		tempfile pme`aa'
		save `pme`aa'', replace
	}
}



tokenize `years'
foreach pa in A B C D E F G H I J K L M N O P Q R S T U V W X{
	use `pme`1'', clear
	keep if v060 == "`pa'"
	tempfile PME_Painel`pa'temp
	save `PME_Painel`pa'temp'
}

macro shift

while "`*'" != "" {
	foreach pa in A B C D E F G H I J K L M N O P Q R S T U V W X{
		use `pme`1'', clear
		keep if v060 == "`pa'"
		append using `PME_Painel`pa'temp'
		save `PME_Painel`pa'temp', replace
	}
	macro shift
}	


global panels = ""
foreach pa in A B C D E F G H I J K L M N O P Q R S T U V W X{
	use `PME_Painel`pa'temp', clear
	qui count
	if r(N) != 0 { 
		global panels = "$panels `pa'" /* Coleta os paineis existentes */
	}
}


	
	
	/*Executa a identificação básica*/
qui if "`idbas'" != "" {
	noi display as result "Executando Identificação Básica ..."
	foreach pa in $panels {
		noi display as result "Painel `pa'"
		use `PME_Painel`pa'temp', clear
		
		/*Algoritmo Básico*/
		****************************************************************
		* Nota
		****************************************************************
		/* Este algoritmo pode ser aplicado tanto à nova quanto à antiga
		PME. As variáveis utilizadas a seguir são as da nova pesquisa.
		Para utilizar o algoritmo com a antiga PME basta substituir
		as seguintes variáveis:
		Na nova Na antiga
		v035 = Região Metropolitana = v010
		v040 = Número de controle 	= v102
		v050 = Número de série 		= v103
		v060 = Painel 				= deve ser construída
		v063 = Grupo rotacional 	= v106
		v070 = Mês da pesquisa 		= v105
		v075 = Ano da pesquisa 		= deve ser construída
		v072 = Número da pesquisa no domicílio = deve ser construída
		v201 = Número de ordem 		= v201
		v203 = Sexo 				= v202
		v204 = Dia de nascimento 	= v206
		v214 = Mês de nascimento 	= v236
		v224 = Ano de nascimento 	= v246
		v234 = Idade calculada 		= v256
		v205 = Condição no domicílio = v203
		vDAE1= Anos de estudo I 	= deve ser construída
		Recomenda-se rodá-lo com arquivos pequenos. Para PME, a sugestão
		é de um arquivo por painel (variável PAINEL) */
		****************************************************************
		* Variáveis do painel
		****************************************************************
		* Variável de identificação da pessoa no painel
		g p201 = v201 if v072 == 1 /* definido com base na 1a entrevista */
		* Variáveis que identificam o emparelhamento
		g back = . /* com uma entrevista anterior */
		g forw = . /* com uma entrevista posterior */
		****************************************************************
		* Emparelhamento - 1a loop
		****************************************************************
		* Emparelhamento para cada par de entrevista por vez
		forvalues i = 1/7 {
		****************************************************************
		* Emparelhamento-padrão - se a data de nascimento está correta
		****************************************************************
		* Ordenando cada indivíduo pelo mês de entrevista
			sort v035 v040 v050 v060 v063 v203 v204 v214 v224 v075 v070 v201
		* Loop para procurar a mesma pessoa em uma posição anterior
			loc j = 1 /* j determina a posição anterior na base */
			loc stop = 0 /* se stop=1, a loop para */
			loc count = 0
			while `stop' == 0 {
				loc lastcount = `count'
				count if p201 == . & v072 == `i'+1 /* observações não
		emparelhadas */
				loc count = r(N)
				if `count' == `lastcount' {
		* Parar caso a loop não esteja emparelhando mais
					loc stop = 1
				}
				else {
					if r(N) != 0 {
		* Captando a identificação p201 da observação anterior
						replace p201 = p201[_n - `j'] if /*
		Identificação do domicílio
		*/ v035 == v035[_n - `j'] & ///
		v040 == v040[_n - `j'] & ///
		v050 == v050[_n - `j'] & ///
		v060 == v060[_n - `j'] & ///
		v063 == v063[_n - `j'] & /*
		diferença entre períodos */ v072 == `i'+1 & v072[_n - `j'] == `i' /*
		excluir emparelhados */ & p201 ==. & forw[_n - `j'] != 1 & /*
		Características individuais
		Sexo */ v203 == v203[_n - `j'] & /*
		Dia de nascimento */ v204 == v204[_n - `j'] & /*
		Mês de nascimento */ v214 == v214[_n - `j'] & /*
		Ano de nascimento */ v224 == v224[_n - `j'] & /*
		Informação observada */ v204!=99 & v214!=99 & v224!=9999
		* Identificação de emparelhamento para quem está à frente
						replace forw = 1 if v035 == v035[_n + `j'] & ///
		v040 == v040[_n + `j'] & ///
		v050 == v050[_n + `j'] & ///
		v060 == v060[_n + `j'] & ///
		v063 == v063[_n + `j'] & ///
		p201 == p201[_n + `j'] & ///
		v072 == `i' & v072[_n + `j']==`i'+1 ///
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
			replace back = p201 !=. if v072 == `i'+1
			replace forw = 0 if forw != 1 & v072 == `i'
		* Identificação para quem estava ausente na última entrevista
			replace p201 = `i'00 + v201 if p201 == . & v072 == `i'+1
		}
		tempvar a b c d
		tostring v035, g(`a')
		tostring v040, g(`b') format(%08.0f)
		tostring v050, g(`c') format(%03.0f)
		tostring p201, g(`d') format(%03.0f)
		egen idind = concat(v060 `a' `b' `c' `d')
		lab var p201 "numero de ordem correto"
		lab var idind "identificacao do individuo"
		drop __* back forw
		save pmenova_painel_`pa'_basic, replace
	}
}

/*Executa a identificação de Ribas & Soares*/
qui if "`idrs'" != "" {
	noi display as result "Executando Identificação Ribas-Soares ..."
	foreach pa in $panels {
		noi display as result "Painel `pa'"
		use `PME_Painel`pa'temp'
		
		/*Algoritmo de Ribas e Soares*/
		****************************************************************
		* Nota
		****************************************************************
		/* Este algoritmo pode ser aplicado tanto à nova quanto à antiga
		PME. As variáveis utilizadas a seguir são as da nova pesquisa.
		Para utilizar o algoritmo com a antiga PME basta substituir
		as seguintes variáveis:
		Na nova Na antiga
		v035 = Região Metropolitana = v010
		v040 = Número de controle 	= v102
		v050 = Número de série 		= v103
		v060 = Painel 				= deve ser construída
		v063 = Grupo rotacional 	= v106
		v070 = Mês da pesquisa 		= v105
		v075 = Ano da pesquisa 		= deve ser construída
		v072 = Número da pesquisa no domicílio = deve ser construída
		v201 = Número de ordem 		= v201
		v203 = Sexo 				= v202
		v204 = Dia de nascimento 	= v206
		v214 = Mês de nascimento 	= v236
		v224 = Ano de nascimento 	= v246
		v234 = Idade calculada 		= v256
		v205 = Condição no domicílio = v203
		vDAE1= Anos de estudo I = deve ser construída
		Recomenda-se rodá-lo com arquivos pequenos. Para PME, a sugestão
		é de um arquivo por painel (variável PAINEL) */
		****************************************************************
		* Variáveis do painel
		****************************************************************
		* Variável de identificação da pessoa no painel
		g p201 = v201 if v072 == 1 /* definido com base na 1a entrevista */
		* Variáveis que identificam o emparelhamento
		g back = . /* com uma entrevista anterior */
		g forw = . /* com uma entrevista posterior */
		****************************************************************
		* Emparelhamento - 1a loop
		****************************************************************
		* Emparelhamento para cada par de entrevista por vez
		forvalues i = 1/7 {
		****************************************************************
		* Emparelhamento-padrão - se a data de nascimento está correta
		****************************************************************
		* Ordenando cada indivíduo pelo mês de entrevista
			sort v035 v040 v050 v060 v063 v203 v204 v214 v224 v075 v070 v201
		* Loop para procurar a mesma pessoa em uma posição anterior
			loc j = 1 /* j determina a posição anterior na base */
			loc stop = 0 /* se stop=1, a loop para */
			loc count = 0
			while `stop' == 0 {
				loc lastcount = `count'
				count if p201 == . & v072 == `i'+1 /* observações não
		emparelhadas */
				loc count = r(N)
				if `count' == `lastcount' {
		* Parar caso a loop não esteja emparelhando mais
					loc stop = 1
				}
				else {
					if r(N) != 0 {
		* Captando a identificação p201 da observação anterior
						replace p201 = p201[_n - `j'] if /*
		Identificação do domicílio
		*/ v035 == v035[_n - `j'] & ///
		v040 == v040[_n - `j'] & ///
		v050 == v050[_n - `j'] & ///
		v060 == v060[_n - `j'] & ///
		v063 == v063[_n - `j'] & /*
		diferença entre períodos */ v072 == `i'+1 & v072[_n - `j'] == `i' /*
		excluir emparelhados */ & p201 ==. & forw[_n - `j'] != 1 & /*
		Características individuais
		Sexo */ v203 == v203[_n - `j'] & /*
		Dia de nascimento */ v204 == v204[_n - `j'] & /*
		Mês de nascimento */ v214 == v214[_n - `j'] & /*
		Ano de nascimento */ v224 == v224[_n - `j'] & /*
		Informação observada */ v204!=99 & v214!=99 & v224!=9999
		* Identificação de emparelhamento para quem está à frente
						replace forw = 1 if v035 == v035[_n + `j'] & ///
		v040 == v040[_n + `j'] & ///
		v050 == v050[_n + `j'] & ///
		v060 == v060[_n + `j'] & ///
		v063 == v063[_n + `j'] & ///
		p201 == p201[_n + `j'] & ///
		v072 == `i' & v072[_n + `j']==`i'+1 ///
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
			replace back = p201 !=. if v072 == `i'+1
			replace forw = 0 if forw != 1 & v072 == `i'
		****************************************************************
		* Emparelhamento avançado
		****************************************************************
		* Se sexo e ano de nascimento não estiverem corretos
		* Isolando observações já emparelhadas
			tempvar aux
			g `aux' = (forw==1 & (v072==1 | back==1)) | (back==1 & v072==8)
		* Ordenando cada indivíduo pelo mês de entrevista
			sort `aux' v035 v040 v050 v060 v063 v204 v214 v201 v075 v070
		* Loop para procurar a mesma pessoa em uma posição anterior
			loc j = 1 /* j determina a posição anterior na base */
			loc stop = 0 /* se stop=1, a loop para */
			loc count = 0
			while `stop' == 0 {
				loc lastcount = `count'
				count if p201 == . & v072 == `i'+1 /* observações não
		emparelhadas */
				loc count = r(N)
				if `count' == `lastcount' {
		* Parar caso a loop não esteja emparelhando mais
					loc stop = 1
				}
				else {
					if r(N) != 0 {
		* Captando a identificação p201 da observação anterior
						replace p201 = p201[_n - `j'] if /*
		Identificação do domicílio
		*/ v035 == v035[_n - `j'] & ///
		v040 == v040[_n - `j'] & ///
		v050 == v050[_n - `j'] & ///
		v060 == v060[_n - `j'] & ///
		v063 == v063[_n - `j'] & /*
		diferença entre períodos */ v072 == `i'+1 & v072[_n - `j'] == `i' /*
		excluir emparelhados */ & p201 ==. & forw[_n - `j'] != 1 & /*
		Características individuais
		Dia de nascimento */ v204 == v204[_n - `j'] & /*
		Mês de nascimento */ v214 == v214[_n - `j'] & /*
		Mesmo número de ordem */ v201 == v201[_n - `j'] & /*
		Informação observada */ v204!=99 & v214!=99
		* Identificação de emparelhamento para quem está à frente
						replace forw = 1 if v035 == v035[_n + `j'] & ///
		v040 == v040[_n + `j'] & ///
		v050 == v050[_n + `j'] & ///
		v060 == v060[_n + `j'] & ///
		v063 == v063[_n + `j'] & ///
		p201 == p201[_n + `j'] & ///
		v072 == `i' & v072[_n + `j']==`i'+1 ///
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
		* Somente para chefes, cônjuges e filhos adultos
			tempvar ager aux
		* Função de erro na idade presumida
			g `ager' = cond(v234>=25 & v234<999, exp(v234/30), 2)
		* Isolando observações já emparelhadas
			g `aux' = (forw==1 & (v072==1 | back==1)) | (back==1 & v072==8)
		* Ordenando cada família pelo mês de entrevista
			sort `aux' v035 v040 v050 v060 v063 v203 v075 v070 v234 vDAE1 v201
		* Loop para procurar a mesma pessoa em uma posição anterior
			loc j = 1
			loc stop = 0
			loc count = 0
			while `stop' == 0 {
				loc lastcount = `count'
				count if p201==. & v072==`i'+1 & ///
		(v205<=2 | (v205==3 & v234>=25 ///
		& v234<999)) /* observações não emparelhadas */
				loc count = r(N)
				if `count' == `lastcount' {
					loc stop = 1
				}
				else {
					if r(N) != 0 {
						replace p201 = p201[_n - `j'] if /*
		Identificação do domicílio
		*/ v035 == v035[_n - `j'] & ///
		v040 == v040[_n - `j'] & ///
		v050 == v050[_n - `j'] & ///
		v060 == v060[_n - `j'] & ///
		v063 == v063[_n - `j'] & /*
		Diferença entre períodos */ v072 == `i'+1 & v072[_n - `j'] == `i' /*
		Excluir emparelhados */ & p201 ==. & forw[_n - `j'] != 1 & /*
		Características individuais
		Sexo */ v203 == v203[_n - `j'] & /*
		Diferença na idade */ abs(v234 - v234[_n - `j'])<=`ager' & /*
		Idade observada */ v234!=999 & /*
		Se chefe ou cônjuge */ ((v205<=2 & v205[_n - `j']<=2) | /*
		ou filho com mais de 25 */ (v234>=25 & v234[_n - `j']>=25 & ///
		v205==3 & v205[_n - `j']==3)) & /*
		Até 4 dias de erro na data */ ((abs(v204 - v204[_n - `j'])<=4 & /*
		Até 2 meses de erro na data*/ abs(v214 - v214[_n - `j'])<=2 & /*
		Informação observada */ v204!=99 & v214!=99) /*
		ou */ | /*
		1 ciclo de erro na educação*/ (abs(vDAE1 - vDAE1[_n - `j'])<=1 /*
		e */ & /*
		Até 2 meses de erro na data*/ ((abs(v214 - v214[_n - `j'])<=2 & /*
		Informação observada */ v214!=99 & /*
		Informação não observada */ (v204==99 | v204[_n-`j']==99)) /*
		ou */ | /*
		até 4 dias de erro na data */ (abs(v204 - v204[_n - `j'])<=4 & /*
		Informação observada */ v204!=99 & /*
		Informação não-observada */ (v214==99 | v214[_n - `j']==99)) /*
		ou */ | /*
		informações não-observadas */ ((v204==99 | v204[_n - `j']==99) & ///
		(v214==99 | v214[_n - `j']==99)))))
						replace forw = 1 if v035 == v035[_n + `j'] & ///
		v040 == v040[_n + `j'] & ///
		v050 == v050[_n + `j'] & ///
		v060 == v060[_n + `j'] & ///
		v063 == v063[_n + `j'] & ///
		p201 == p201[_n + `j'] & ///
		v072 == `i' & v072[_n + `j']==`i'+1 ///
		& forw != 1
						loc j = `j' + 1
					}
					else {
						loc stop = 1
					}
				}
			}
			replace back = p201 !=. if v072 == `i'+1
			replace forw = 0 if forw != 1 & v072 == `i'
		****************************************************************
		* Emparelhamento avançado
		****************************************************************
		* Somente em domicílio onde alguém já emparelhou
		* Quantas pessoas emparelharam no domicílio
			tempvar dom
			bys v075 v070 v035 v040 v050 v060 v063: egen `dom' = sum(back)
		* Loop com os critérios de emparelhamento
			foreach w in /*mesma idade*/ "0" /*erro na idade = 1*/ "1" /*
		erro na idade = 2*/ "2" /*erro na idade = f(idade)*/ "`ager'" /*
		2xf(idade)*/ "2*`ager' & v234>=25" {
		* Isolando observações já emparelhadas
				tempvar aux
				g `aux' = (forw==1 & (v072==1 | back==1)) | ///
		(back==1 & v072==8) | (`dom'==0 & v072==`i'+1)
				sort `aux' v035 v040 v050 v060 v063 v203 v075 v070 v234 ///
		vDAE1 v201
				loc j = 1
				loc stop = 0
				loc count = 0
				while `stop' == 0 {
					loc lastcount = `count'
					count if p201 == . & v072 == `i'+1 & `dom'>0 & `dom'!=.
					loc count = r(N)
					if `count' == `lastcount' {
						loc stop = 1
					}
					else {
						if r(N) != 0 {
							replace p201 = p201[_n - `j'] if /*
		Identificação do domicílio
		*/ v035 == v035[_n - `j'] & ///
		v040 == v040[_n - `j'] & ///
		v050 == v050[_n - `j'] & ///
		v060 == v060[_n - `j'] & ///
		v063 == v063[_n - `j'] & /*
		Diferença entre períodos */ v072 == `i'+1 & v072[_n-`j'] == `i' /*
		excluir emparelhados */ & p201 ==. & forw[_n - `j'] != 1 & /*
		há emparelhados no domicílio*/ `dom' > 0 & `dom'!=. & /*
		Características individuais
		Sexo */ v203 == v203[_n - `j'] & /*
		Critérios mudam com a loop */ ((abs(v234-v234[_n - `j'])<=`w' & /*
		se a idade é observada */ v234!=999) /*
		caso contrário */ | /*
		Mesma escolaridade */ (vDAE1==vDAE1[_n - `j'] & /*
		Mesma condição no domicílio */ v205==v205[_n - `j'] & /*
		Idade não observada */ (v234==999 | v234[_n - `j']==999)))
							replace forw = 1 if v035 == v035[_n + `j'] & ///
		v040 == v040[_n + `j'] & ///
		v050 == v050[_n + `j'] & ///
		v060 == v060[_n + `j'] & ///
		v063 == v063[_n + `j'] & ///
		p201 == p201[_n + `j'] & ///
		v072 ==`i' & v072[_n+`j']==`i'+1 ///
		& forw != 1
							loc j = `j' + 1
						}
						else {
							loc stop = 1
						}
					}
				}
			}
			replace back = p201 !=. if v072 == `i'+1
			replace forw = 0 if forw != 1 & v072 == `i'
		* Identificação para quem estava ausente na última entrevista
			replace p201 = `i'00 + v201 if p201 == . & v072 == `i'+1
		}
		****************************************************************
		* Recuperar quem saiu e retornou para o painel - 2a loop
		****************************************************************
		* Variável temporária identificando o emparelhamento à frente
		tempvar fill
		g `fill' = forw
		* Loop retrospectivo por entrevista
		foreach i in 7 6 5 4 3 2 1 {
			tempvar ncode1 ncode2 aux max ager
		* Função de erro na idade presumida
			g `ager' = cond(v234>=25 & v234<999, exp(v234/30), 2)
		* Variável que preserva o antigo número
			bys v035 v040 v050 v060 v063 p201: g `ncode1' = p201
		* Isolando observações emparelhadas
			g `aux' = ((`fill'==1 & (v072==1 | back==1)) | (back==1 & v072==8))
		* Variável identificando a última entrevista
			bys v035 v040 v050 v060 v063 p201: egen `max' = max(v072)
			sort `aux' v035 v040 v050 v060 v063 v203 v072 v201 p201
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
		Identificação do domicílio
		*/ v035 == v035[_n - `j'] & ///
		v040 == v040[_n - `j'] & ///
		v050 == v050[_n - `j'] & ///
		v060 == v060[_n - `j'] & ///
		v063 == v063[_n - `j'] & /*
		Quem entrou na entrevista i*/ p201>`i'00 & p201<`i'99 & /*
		Não emparelhado */ back==0 & `fill'[_n - `j']!=1 & /*
		Uma entrev. de diferença */ `max'[_n - `j']<`i' & ///
		p201[_n - `j']<`i'00-100 & /*
		Sexo */ v203 == v203[_n - `j'] & /*
		Diferença na idade */ ((abs(v234 - v234[_n - `j'])<=`ager' & /*
		Idade observada */ v234!=999 & /*
		Até 4 dias de erro na data */ ((abs(v204 - v204[_n - `j'])<=4 & /*
		Até 2 meses de erro na data*/ abs(v214 - v214[_n - `j'])<=2 & /*
		informação observada */ v204!=99 & v214!=99) /*
		ou */ | /*
		1 ciclo de erro na educação*/ (abs(vDAE1 - vDAE1[_n - `j'])<=1 /*
		e */ & /*
		Até 2 meses de erro na data*/ ((abs(v214 - v214[_n - `j'])<=2 & /*
		Informação observada */ v214!=99 & /*
		Informação não-observada */ (v204==99 | v204[_n - `j']==99)) /*
		ou */ | /*
		até 4 dias de erro na data */ (abs(v204 - v204[_n - `j'])<=4 & /*
		Informação observada */ v204!=99 & /*
		Informação não-observada */ (v214==99 | v214[_n - `j']==99)) /*
		ou */ | /*
		nada é observado */ ((v204==99 | v204[_n - `j']==99) & ///
		(v214==99 | v214[_n - `j']==99)))))) /*
		ou */ | /*
		mesma escolaridade */ (vDAE1==vDAE1[_n - `j'] & /*
		e número de ordem */ v205==v205[_n - `j'] /*
		Se idade não é observada */ & (v234==999 | v234[_n - `j']==999)))
		* Identificação de emparelhamento para quem está à frente
						replace `fill' = 1 if v035 == v035[_n + `j'] & ///
		v040 == v040[_n + `j'] & ///
		v050 == v050[_n + `j'] & ///
		v060 == v060[_n + `j'] & ///
		v063 == v063[_n + `j'] & ///
		p201 == p201[_n + `j'] & ///
		`fill' == 0 & `max'<`i' & ///
		(v072[_n + `j'] - v072)>=2
						loc j = `j' + 1
					}
					else {
						loc stop = 1
					}
				}
			}
		* Igualando o número de quem era igual
			bys v035 v040 v050 v060 v063 `ncode1': egen `ncode2' = min(p201)
			replace p201 = `ncode2'
		}
		tempvar a b c d
		tostring v035, g(`a')
		tostring v040, g(`b') format(%08.0f)
		tostring v050, g(`c') format(%03.0f)
		tostring p201, g(`d') format(%03.0f)
		egen idind = concat(v060 `a' `b' `c' `d')
		lab var p201 "numero de ordem correto"
		lab var idind "identificacao do individuo"
		drop __* back forw
		save pmenova_painel_`pa'_rs, replace
	}
}
di _newline "As bases de dados foram salvas em `caminhoprin'"
cd "`saving'"
end
