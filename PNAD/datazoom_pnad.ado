******************************************************
*                   datazoom_pnad.ado                  *
******************************************************
* version 1.4
program define datazoom_pnad

syntax, years(numlist) original(str) saving(str) [pes dom both ncomp comp81 comp92 english]

if "`english'" != "" local lang "_en"

if "`pes'"~="" & "`dom'"=="" {
	display as result _newline "Obtendo arquivo de pessoas da PNAD"
	loc register = "pes"
}
if "`dom'"~="" & "`pes'"=="" {
	display as result _newline "Obtendo arquivo de domicílios da PNAD"
	loc register = "dom"
}
if ("`pes'"~="" & "`dom'"~="") | "`both'"~="" {
	display as result _newline "Obtendo arquivos de domicílios e pessoas da PNAD"
	loc both = "both"
	loc pes = "pes"
	loc dom = "dom"
	loc register = "pes dom"
}
if "`pes'"=="" & "`dom'"=="" & "`both'"=="" {
	display as result _newline "Nenhum tipo de registro escolhido: obtendo arquivo de pessoas da PNAD"
	loc register = "pes"
}

/*	Opcoes de compatibilizacao */

if "`ncomp'"~="" {
	display as result _newline "Obtendo microdados não compatibilizados"
}


* se não escolheu nenhuma compatibilização, default = noncompatible
if "`ncomp'"=="" & "`comp81'"=="" & "`comp92'"=="" {
	local ncomp = "ncomp"
	display as result _newline "Nenhuma opção de compatibilização escolhida: obtendo microdados não compatibilizados"
}



/* Pastas para guardar arquivos da sessão */
cd `"`saving'"'

loc q = 0 // vai indicar se pes já foi realizado

/* Abrindo bases no Stata e salvando em arquivos temporários com formato ".dta" */
display as input "Anos selecionados: `years'"

foreach name of local register {
	if "`name'"=="pes" di _newline as result "Gerando bases de pessoas ..."
	else {
		di _newline as result "Gerando bases de domicílios ..."
		loc q = 1
	}
	
	foreach ano in `years'{
		
		if `ano' <= 1990 & "`comp92'"~="" {
			display as error "Opção 'comp92' não se aplica à decada de 1980"
			exit, clear
		}
		
				/* 
		Match entre ano/registro e nome do arquivo
										*/
										
		grab_name, ano(`ano') name(`name')
		
		local file_name = r(base`ano'`name')
		
			/*
		Carregamento dos dados
							*/
		
		tempfile base
		
		/* 83 e 88 vêm quebrados em 8 arquivos */
		foreach file in `file_name'{
			
			load_pnad, file("`file'") original("`original'") dict_name("pnad`ano'`name'`lang'")
			
			cap append using `base'
			
			save `base', replace
		}
		
		treat_pnad, ano(`ano') name(`name') base("`base'") `pes' `dom' `both' `ncomp' `comp81' `comp92'
	}
}	

display as result "As bases de dados foram salvas na pasta `c(pwd)' - compatível com a última versão dos microdados divulgados em 13/03/2020"

end

program grab_name, rclass /* retorna um local como r(file_name) */
syntax, ano(int) name(string)

if `ano' == 1981 | `ano' == 1982 | `ano' == 1984{
	
	/* por exemplo: PNAD81BR.TXT */
	local digitos = substr("`ano'", 3, 2)
	local file_name PNAD`digitos'BR.TXT
	
}
else if `ano' == 1983 | `ano' == 1988{
	
	// por exemplo: PND83RM1.DAT, RM2, RM3, ..., RM8
	local digitos = substr("`ano'", 3, 2)
	local file_name ""
	forvalues i = 1/8{
	local file_name "`file_name' PND`digitos'RM`i'.DAT"
	}
}	
else if `ano' == 1985 | `ano' == 1986{
	
	// por exemplo: PNAD1985.DAT
	local file_name PNAD`ano'.DAT
	
}
else if `ano' == 1987 | `ano' == 1989 | `ano' == 1990{
	
	// por exemplo: PND1989N.DAT
	local file_name PND`ano'N.DAT
	
}
else if `ano' == 1992 | `ano' == 1993 | `ano' == 1995{
	
	// por exemplo: DOM93.DAT
	local digitos = substr("`ano'", 3, 2)
	local prefix = cond("`name'" == "dom", "DOM", "PES")
	local file_name `prefix'`digitos'.DAT
	
}
else if `ano' == 1996{
	
	// por exemplo: D96BR.TXT
	local digitos = substr("`ano'", 3, 2)
	local prefix = cond("`name'" == "dom", "D", "P")
	local file_name `prefix'`digitos'BR.txt
	
}
else if `ano' == 1997{
	
	// por exemplo: Domicilios97
	local digitos = substr("`ano'", 3, 2)
	local prefix = cond("`name'" == "dom", "Domicilios", "Pessoas")
	local file_name `prefix'`digitos'
	
}
else if `ano' == 1998 | `ano' == 1999{
	
	// por exemplo: Domicilio98.TXT Pessoa98.TXT
	local digitos = substr("`ano'", 3, 2)
	local prefix = cond("`name'" == "dom", "domicilio", "pessoa")
	local file_name `prefix'`digitos'.txt	
}
else if `ano' >= 2001{
		
	local prefix = cond("`name'" == "dom", "DOM", "PES")
	local file_name `prefix'`ano'.txt
}
else{
	di as error "`ano': Ano inválido" _newline "`ano': Invalid year"
}
return local base`ano'`name' `file_name'

end

program load_pnad
syntax, file(string) original(string) dict_name(string)

	tempfile dic

	findfile dict.dta

	read_compdct, compdct("`r(fn)'") dict_name("`dict_name'") out("`dic'")
			
	cap infile using `dic', using("`original'/`file'") clear
	if _rc == 601{
	di as error "`original'/`file'" _newline "Erro na leitura do arquivo" _newline "Failed to read data"
	exit 601
	}

end

program treat_pnad
syntax, ano(int) name(string) base(string) [pes dom both ncomp comp81 comp92]

if `ano' <= 1990 {                                     // Se tem ano até 1990

	/* Parte específica ao período de 1981 a 1990:
	 Até 1990 domicílios e pessoas são registrados no mesmo arquivo.
	 Nesse mesmo período, não há variável de ano da pesquisa         */

	gen int ano = `ano'                                 // gera variável de ano
	lab var ano "ano da pesquisa"

	* variavel de identificacao do domicilio
	if `ano'==1983 | `ano'==1990 egen id_dom = concat(ano v0102 v0103)
	else egen id_dom = concat(ano v0101)
	lab var id_dom "identificação do domicílio"

	if "`name'"=="pes" {
		keep if v0100 == 3                  // mantém somente pessoas
			sort id_dom v0305 v0306, stable
			by id_dom: gen ordem = _n
			lab var ordem "número de ordem do morador"
		}
		else keep if v0100 == 1                                // mantém somente domicílios

			/* Fim da parte específica a 1981-90 */

			if "`ncomp'" ~= "" {
				tempfile pnad`ano'`name'
				if "`both'"=="" save pnad`ano'`name', replace				// salva base final sem compatibilizar e sem merge
				else { 
					if "`name'"=="pes" save `pnad`ano'`name'', replace	// salva base temporária de pessoas p/ merge posterior
					else {
						merge 1:m id_dom using `pnad`ano'pes', nogen	keep(match)	
						save pnad`ano', replace								// salva base final com merge
					}
				}
			}
			else {
				if "`comp81'"~="" {

					/* contrói renda domiciliar compatível com anos 90 e 2000 */
					if "`name'"=="dom" {
						preserve
						
						tempfile dic

						findfile dict.dta

						read_compdct, compdct("`r(fn)'") dict_name("pnad`ano'pes`lang'") out("`dic'")
						
						qui cap infile using `dic', using("`base'") clear
						keep if v0100 == 3                  // mantém somente pessoas
						g ano = `ano'
						if `ano'==1983 | `ano'==1990 egen id_dom = concat(ano v0102 v0103)
						else egen id_dom = concat(ano v0101)	

						tempvar aux1 aux2
						g `aux2' = v0602 if v0305<6
						if `ano'<=1984 bys id_dom: egen `aux1' = total(`aux2'==9999999)						// identifica se alguma renda é ignorada, pois
						else bys id_dom: egen `aux1' = total(`aux2'>=999999998 & `aux2'~=.)					// nesse caso, a renda domiciliar será missing
						bys id_dom: egen renda_domB = total(`aux2')
						replace renda_domB = . if `aux1'>0
						bys id_dom: keep if _n==1
						keep id_dom renda_domB
						tempfile rdom
						save `rdom', replace

						restore
						merge 1:1 id_dom using `rdom', nogen
					}
					cap drop v0101

					compat_`name'_1981a1990_para_81		// compatibiliza

					tempfile pnad`ano'`name'
					if "`both'"=="" save pnad`ano'`name'_comp81, replace				// salva base final após compatibilizar mas sem merge
					else {
						if "`name'"=="pes" save `pnad`ano'`name'', replace	// salva base temporária de pessoas p/ merge posterior
						else {
							merge 1:m id_dom using `pnad`ano'pes', nogen keep(match)	
							save pnad`ano'_comp81, replace								// salva base final com merge
						}
					}
				}
			}
		}
		
else if `ano' <= 2001 {                                  // ... se tem ano até 2001
	if `ano'==2001 egen id_dom = concat(v0101 v0102 v0103)
	else egen id_dom = concat(v0101 uf v0102 v0103)
	lab var id_dom "identificação do domicílio"
				
	if "`ncomp'" ~= "" {
		tempfile pnad`ano'`name'
		if "`both'"=="" save pnad`ano'`name', replace				// salva base final sem compatibilizar e sem merge
		else {
			if "`name'"=="pes" save `pnad`ano'`name'', replace	// salva base temporária de pessoas p/ merge posterior
			else {
				merge 1:m id_dom using `pnad`ano'pes', nogen	keep(match)	
				save pnad`ano', replace								// salva base final com merge
				}
			}
		}
		else { 
			if "`comp81'"~="" compat_`name'_1992a2001_para_81
			else compat_`name'_1992a2001_para_92
					
			tempfile pnad`ano'`name'
			if "`both'"=="" {
				if "`comp81'"~="" save pnad`ano'`name'_comp81, replace				// salva base final após compatibilizar mas sem merge
				else save pnad`ano'`name'_comp92, replace
			}
			else {
				if "`name'"=="pes" save `pnad`ano'`name'', replace	// salva base temporária de pessoas p/ merge posterior
				else {
					merge 1:m id_dom using `pnad`ano'pes', nogen keep(match)	
					if "`comp81'"~="" save pnad`ano'_comp81, replace								// salva base final com merge
					else save pnad`ano'_comp92, replace
				}
			}
	}
	
}

else if `ano' >= 2002 {                                            // Se só restam anos >= 2002
	display as input "Extraindo `ano'..."
			
	egen id_dom = concat(v0101 v0102 v0103)
	lab var id_dom "identificação do domicílio"
				
	if "`ncomp'" ~= "" 	{ 
		tempfile pnad`ano'`name'
		if "`both'"=="" save pnad`ano'`name', replace				// salva base final sem compatibilizar e sem merge
		else {
			if "`name'"=="pes" save `pnad`ano'`name'', replace	// salva base temporária de pessoas p/ merge posterior
			else {
				merge 1:m id_dom using `pnad`ano'pes', nogen keep(match)	
				save pnad`ano', replace								// salva base final com merge
			}
		}
	}
	else {
		if "`comp81'"~="" compat_`name'_2002a2009_para_81
		else compat_`name'_2002a2009_para_92
					
		tempfile pnad`ano'`name'
		if "`both'"=="" {
			if "`comp81'"~="" save pnad`ano'`name'_comp81, replace				// salva base final após compatibilizar mas sem merge
			else save pnad`ano'`name'_comp92, replace
		}
		else {
			if "`name'"=="pes" save `pnad`ano'`name'', replace	// salva base temporária de pessoas p/ merge posterior
			else {
				merge 1:m id_dom using `pnad`ano'pes', nogen keep(match)	
				if "`comp81'"~="" save pnad`ano'_comp81, replace								// salva base final com merge
				else save pnad`ano'_comp92, replace
			}
		}
	}
}
		
end				

************************************************************
**************compat_dom_1981a1990_para_81.ado**************
************************************************************

program define compat_dom_1981a1990_para_81

label var ano "ano da pesquisa"
lab var id_dom "identificador do domicílio"

/* CRIANDO VARIÁVEL TEMPORÁRIA PARA VERIFICAR PRESENÇA 
   DE ANOS NOS QUAIS EM VEZ DA VAR v0101 HAVIA AS
   VARIÁVEIS v0102 E v0103                          */
tempvar anos_v0102
gen byte `anos_v0102' = (ano==1983)|(ano==1990)

/* A. ACERTA CÓDIGO DOS ESTADOS */

/* A.1 NA VARIÁVEL UF E CRIA VARIÁVEL DE REGIÃO */
destring uf, replace
recode uf (11/14=33) (20/29=35) (30/31 37=41) (32=42) (33/35=43) ///
(41/42=31) (43=32) (51=21) (52=22) (53=23) (54=24) (55=25) ///
(56=26) (57=27) (58=28) (59/60=29) (61=53) (71=11) (72=12) ///
(73=13) (74=14) (75=15) (76=16) (81=50) (82=51) (83=52) 
gen regiao = int(uf/10)
label var regiao "região"
tostring uf, replace

/* C. RECODE E RENAME DAS VARIÁVEIS */

/* C.1 DUMMY: ZONA URBANA */
recode v0003 (5=0)
rename v0003 urbana
label var urbana "zona urbana"
* urbana = 1 urbana
*        = 0 rural

/* C.2 AREA CENSITARIA  */
rename v0005 area_censit

/* C.3 REPLACE: PESOS */
generate int peso =.
lab var peso "peso amostral"

quietly summ ano
* Verifica se há o ano de 1990,
* quando o peso era dado por v1091
loc max = r(max)
loc min = r(min)

if `max' == 1990 {
   replace peso = v1091 
   drop v1091 v1080						/* v1080 peso censo 1980 */
}

* Verifica se há anos da déc. de 80,
* quando o peso era dado por v9981
else {
   replace peso = v9981 
   drop v9981
}

/* C.4 RENAME: TOTAL DE PESSOAS E TOTAL DE PESSOAS +10 ANOS */
rename v0107 tot_pess
rename v0108 tot_pess_10_mais

/* C.5 RECODE: ESPÉCIE DE DOMICÍLIO */
recode v0201 (2=1) (4=3) (6=5) (9=.)
rename v0201 especie_dom
* especie_dom = 1 particular permanente
*             = 3 particular improvisado
*             = 5 coletivo

/* C.6 RECODE: TIPO DO DOMICÍLIO */
* A OPÇÃO "RÚSTICO" FOI SOMADA À "CASA", POIS PARECE SER A MELHOR SOLUÇÃO 
* AS PROPORÇÕES DE "APTO" E "COMODO" NÃO AUMENTAM EM 1992;
* AO CONTRÁRIO, ATÉ DIMINUEM.
recode v0202 (1 5=2) (3=4) (7=6) (9=.)
rename v0202 tipo_dom
* tipo_dom = 2 casa
*          = 4 apto.
*          = 6 cômodo

/* C.7 RECODE: PAREDES */
recode v0203 (0=1) (4=3) (6=4) (8=5) (9=.)
rename v0203 parede
* parede = 1 alvenaria
*        = 2 madeira aparelhada
*        = 3 taipa não revestida
*        = 4 madeira aproveitada
*        = 5 outra

/* C.8 RECODE: COBERTURA */
recode v0205 (0=2) (2=1) (6=3) (7=5) (8=6) (9=.)
rename v0205 cobertura
* cobertura = 1 telha
*           = 2 laje concreto
*           = 3 mad. apar.
*           = 4 zinco
*           = 5 mad. aprov.
*           = 6 outro

/* C.9 DUMMY: ABAST ÁGUA */
recode v0206 (4=1) (2 3 5 6=0) (9=.)
rename v0206 agua_rede
label var agua_rede "água provém de rede"
* agua_rede = 1 sim
*           = 0 não

/* C.10 RECODE: ESGOTO */
recode v0207 (8 9 =.)
replace v0207 = . if v0208>1
rename v0207 esgoto  
* esgoto = 0 rede geral
*        = 2 fossa séptica
*        = 4 fossa rudimentar
*        = 6 outro

/* C.11 SANITÁRIO */

* C.11.1 DUMMY: EXISTE SANITÁRIO
gen sanit = 1 if v0208 == 1 | v0208 == 3
replace sanit = 0 if v0208 == 5
replace sanit = . if v0208 == 9 
label var sanit "possui sanitário"
* sanit = 1 sim
*       = 0 não

* C.11.2 DUMMY: SANITÁRIO EXCLUSIVO
recode v0208 (3=0) (5 9=.)
rename v0208 sanit_excl
label var sanit_excl "sanit excl do domicílio"
* sanit_excl = 1 sim
*            = 0 não

/* C.12 DUMMY: LIXO */
recode v0209 (0=1) (2 4 6 8=0) (9=.)
rename v0209 lixo
label var lixo "lixo é coletado"
* lixo = 1 sim
*      = 0 não

/* C.13 DUMMY: ILUMINAÇÃO ELÉTRICA */
recode v0210 (3=0) (9=.)
rename v0210 ilum_eletr
label var ilum_eletr "possui iluminação elétrica"
* ilum_eletr = 1 sim
*            = 0 não

/* C.14 RECODE: NÚMERO DE CÔMODOS E DORMITÓRIOS */
recode v0211 (99=.)
recode v0231 (99=.)
rename v0211 comodos
rename v0231 dormit

/* C.15 DUMMY: CONDIÇÃO DE OCUPAÇÃO */
recode v0212 (0 2=1) (4 6 8=0) (9=.)
rename v0212 posse_dom
label var posse_dom "posse do domicílio"
* posse_dom = 1 sim
*           = 0 não

/* C.16 RECODE: ALUGUEL/PRESTAÇÃO */
replace v0213 = . if v0213>=888888 & (ano<=1984 | ano==1987 | ano==1988)
replace v0213 = . if v0213>=88000000 & (ano==1985 | ano==1986 | ano>=1989)

generate aluguel = v0213 if posse_dom == 0
lab var aluguel "aluguel pago"
generate prestacao = v0213 if posse_dom == 1
lab var prestacao "prestacao"
drop v0213

/* C.17 DUMMY: FILTRO */
recode v0214 (3=0) (9=.)
rename v0214 filtro
* filtro = 1 sim
*        = 0 não

/* C.18 DUMMY: FOGÃO */
recode v0215 (2=1) (4=0) (9=.)
rename v0215 fogao
* fogao = 1 sim
*       = 0 não

/* C.19 DUMMY: GELADEIRA */
recode v0216 (3=0) (9=.)
rename v0216 geladeira
* geladeira = 1 sim
*           = 0 não

tempvar rtv
g `rtv' = ano==1982 | ano==1988 | ano==1989 | ano==1990
qui sum `rtv'
loc max = r(max)

if `max' == 1 {
/* C.20 DUMMY: RÁDIO */
	recode v0217 (2=1) (4=0) (9=.)
	rename v0217 radio
	* radio = 1 sim
	*       = 0 não

/* C.21 DUMMY: TELEVISÃO */
	recode v0218 (3=0) (9=.)
	rename v0218 tv
	* tv = 1 sim
	*    = 0 não
}
if `max' == 0 {
	g radio = .
	g tv = .
	lab var radio "radio (nao existe p/alguns anos da década 1980)"
	lab var tv "TV (nao existe p/alguns anos da década 1980)"
}


/* C.22 RENAME: RENDA MENSAL DOMICILIAR */
recode v0410 (9999999=.) if ano <= 1984
recode v0410 (999999999=.) if ano >= 1985 
recode v0410 (999999998=.) if ano >= 1985 
rename v0410 renda_dom

/* C.23 OUTROS */
drop v0100 v0204 v0409

/* D. KEEPING */ 
order ano regiao uf id_dom urbana area_censit tot_pess tot_pess_10_mais especie_dom ///
	tipo_dom parede cobertura agua_rede esgoto sanit_excl lixo ilum_eletr comodos dormit ///
		sanit posse_dom filtro fogao geladeira radio tv renda_dom* peso aluguel prestacao

keep ano-prestacao id

compress


/* E. DEFLACIONANDO E CONVERTENDO UNIDADES MONETÁRIAS PARA REAIS */

/* CONVERTENDO OS VALORES NOMINAIS PARA REAIS (UNIDADE MONETÁRIA) */
/* 	E DEFLACIONANDO (OUT/2012)                                            */
gen double deflator = 0.807544/100000 if ano == 1990
format deflator %26.25f
replace deflator    = 0.269888/1000000 if ano == 1989
replace deflator    = 0.196307/10000000    	 	if ano == 1988
replace deflator    = 0.241162/100000000	   	if ano == 1987
replace deflator    = 0.602708/1000000000   	if ano == 1986
replace deflator    = 0.304402/1000000000	  	if ano == 1985
replace deflator    = 0.962506/10000000000   	if ano == 1984
replace deflator    = 0.330205/10000000000		if ano == 1983
replace deflator    = 0.133929/10000000000 		if ano == 1982
replace deflator    = 0.636330/100000000000		if ano == 1981

label var deflator "deflator - base: out/2012"
  
gen double conversor = 2750000       if ano >= 1989
replace conversor    = 2750000000    if ano >= 1986 & ano <= 1988
replace conversor    = 2750000000000 if ano <= 1985

label var conversor "conversor de moedas"

foreach valor in renda_dom renda_domB aluguel prestacao {
	g `valor'_def = (`valor'/conversor)/deflator
	lab var `valor'_def "`valor' deflacionada"
}

lab var renda_domB "renda domiciliar - compativel com 1992"

end

************************************************************
**************compat_dom_1992a2001_para_81.ado**************
************************************************************

program define compat_dom_1992a2001_para_81

/* A. ACERTA CÓDIGO DOS ESTADOS */
* AGREGA TOCANTINS COM GOIÁS

/* A.1 NA VARIÁVEL UF E CRIA VARIÁVEL DE REGIÃO */
destring uf, replace
recode uf (17=52)
gen regiao = int(uf/10)
label var regiao "região"
tostring uf, replace


/* B. NÚMERO DE CONTROLE E SÉRIE */
drop v0102 v0103

/* C. RECODE E RENAME DAS VARIÁVEIS */

/* C.0 RECODE: ANO */
recode v0101 (92=1992) (93=1993) (95=1995) (96=1996) (97=1997) (98=1998) (99=1999)
rename v0101 ano
label var ano "ano da pesquisa"
/* C.1 DUMMY: ZONA URBANA */
recode v4105 (1 2 3=1) (4 5 6 7 8=0)
rename v4105 urbana
label var urbana "área urbana"

/* C.2 AREA CENSITARIA  */
rename v4107 area_censit

/* C.3 RECODE: PESOS */
* ENTRE 92 E 2001, "-1" PARECE SER == MISSING 
recode v4611 (-1=.)
rename v4611 peso

/* C.4 RECODE: TOTAL DE PESSOAS, TOTAL DE PESSOAS 10 ANOS OU MAIS E 5 ANOS OU MAIS */
* ENTRE 92 E 2001, "-1" PARECE SER == MISSING
recode v0105 (-1=.)
recode v0106 (-1=.)
* NO ANO DE 2001 NÃO HÁ A VARIÁVEL TOTAL DE PESSOAS DE 10 ANOS OU MAIS,
* MAS TOTAL DE PESSOAS DE 5 ANOS OU MAIS
replace v0106 = . if ano==2001

rename v0105 tot_pess
rename v0106 tot_pess_10_mais

/* C.5 RENAME: ESPÉCIE DE DOMICÍLIO */
rename v0201 especie_dom

/* C.6 RENAME: TIPO DE DOMICÍLIO */
rename v0202 tipo_dom

/* C.7 RECODE: PAREDE */
recode v0203 (6=5) (9=.)
rename v0203 parede

/* C.8 RECODE: COBERTURA */
recode v0204 (7=6) (9=.)
rename v0204 cobertura

/* C.9 DUMMY: ABAST ÁGUA */
recode v0212 (2=1) (4 6=0) (9=.)
rename v0212 agua_rede 
replace agua_rede = 1 if v0213==1
replace agua_rede = 0 if v0213==3
label var agua_rede "água provém de rede"

/* C.10 RECODE: ESGOTO */
recode v0217 (1=0) (3=2) (5 7=6) (9=.)
rename v0217 esgoto
* esgoto = 0 rede geral
*        = 2 fossa séptica 
*        = 4 fossa rudimentar
*        = 6 outra

/* C.11 SANITÁRIO */

* C.11.1 DUMMY: EXISTE SANITÁRIO
recode v0215 (3=0) (9=.)
rename v0215 sanit
label var sanit "possui sanitario"

/* C.11.2 DUMMY: SANITÁRIO EXCLUSIVO */
recode v0216 (2=1) (4=0) (9=.)
rename v0216 sanit_excl
label var sanit_excl "sanit excl do domicílio"

/* C.12 DUMMY: LIXO */
recode v0218 (2=1) (3/6=0) (9=.)
rename v0218 lixo
label var lixo "lixo é coletado"

/* C.13 DUMMY: ILUMINAÇÃO ELÉTRICA */
recode v0219 (3 5=0) (9=.)
rename v0219 ilum_eletr
label var ilum_eletr "possui ilum elétrica"

/* C.14 RECODE: NÚMERO DE CÔMODOS E DORMITÓRIOS */
recode v0205 (-1 99=.) 
rename v0205 comodos
recode v0206 (-1 99=.)
rename v0206 dormit

/* C.15 DUMMY: CONDIÇÃO DE OCUPAÇÃO */
recode v0207 (2 = 1) (3/6 = 0) (9 = .), gen(posse_dom)
label var posse_dom "posse do domicílio"
drop v0207

/* C.16 VALOR DO ALUGUEL/PRESTAÇÃO */
recode v0208 v0209 (-1=.) 
recode v0208 v0209 (99999999/max=.)
rename v0208 aluguel
rename v0209 prestacao 

/* C.17 DUMMY: FILTRO */
recode v0224 (2=1) (4=0) (9=.)
rename v0224 filtro

/* C.18 DUMMY: FOGÃO */
recode v0221 (3=0) (9=.)
recode v0222 (2=1) (4=0) (9=.)
gen fogao = 1 if v0221 == 1 | v0222 == 1
replace fogao = 0 if v0221 == 0 & v0222 == 0
replace fogao = . if v0221 == . & v0222 == .
label var fogao "possui fogao"
drop v0221 v0222

/* C.19 DUMMY: GELADEIRA */
recode v0228 (2 4=1) (6=0) (9=.)
rename v0228 geladeira

/* C.20 DUMMY: RÁDIO */
recode v0225 (3=0) (9=.)
rename v0225 radio

/* C.21 DUMMY: TELEVISÃO */
recode v0226 (2=1) (4=0) (9=.)
recode v0227 (3=0) (9=.)
gen tv = 1 if v0226 == 1 | v0227 == 1
replace tv = 0 if v0226 == 0 & v0227 == 0
replace tv = . if v0226 == . & v0227 == .
label var tv "possui televisão"
drop v0226 v0227

/* C.22 VALOR DA RENDA DOMICILIAR */
replace v4614 = . if v4614>=999999999
rename v4614 renda_domB 

/* C.23 OUTROS */
cap drop v0220 
cap drop v2020

/* D. KEEPING */
order ano regiao uf id_dom urbana area_censit tot_pess tot_pess_10_mais especie_dom ///
	tipo_dom parede cobertura agua_rede esgoto sanit_excl lixo ilum_eletr comodos dormit ///
		sanit posse_dom filtro fogao geladeira radio tv renda_domB peso aluguel prestacao

keep ano-prestacao


compress


/* D. DEFLACIONANDO E CONVERTENDO UNIDADES MONETÁRIAS PARA REAIS */

/* CONVERTENDO OS VALORES NOMINAIS PARA REAIS (UNIDADE MONETÁRIA) */
/* 	E DEFLACIONANDO: 1 = out/2012                                 */

gen double deflator = 0.488438 if ano == 2001
format deflator %26.25f
replace deflator    = 0.425376 if ano == 1999
replace deflator    = 0.399657 if ano == 1998
replace deflator    = 0.387748 if ano == 1997
replace deflator    = 0.371635 if ano == 1996
replace deflator    = 0.330617 if ano == 1995
replace deflator    = 0.103168/10 if ano == 1993
replace deflator    = 0.498848/1000 if ano == 1992

label var deflator "deflator - base:out/2012"  

gen double conversor = 1             if ano >= 1995
replace conversor    = 2750          if ano == 1993
replace conversor    = 2750000       if ano == 1992

label var conversor "conversor de moedas"

foreach valor in renda_domB aluguel prestacao {
	g `valor'_def = (`valor'/conversor)/deflator
	lab var `valor'_def "`valor' deflacionada"
}

end

************************************************************
**************compat_dom_1992a2001_para_92.ado**************
************************************************************

program define compat_dom_1992a2001_para_92


/* A. RECODE: ANO */
recode v0101 (92=1992) (93=1993) (95=1995) (96=1996) (97=1997) (98=1998) (99=1999)

/* B. NÚMERO DE CONTROLE E SÉRIE */
destring uf, replace
drop v0102 v0103

/* C. NÚMERO DE MORADORES */
* obs: para 2001, v0106 indica numero de moradores com 5 anos ou mais
* -1 deve ser missing
replace v0106=. if v0101==2001

recode v0105 v0106 (-1 =.)

/* D. TELEFONE */
* A partir de 2001, pergunta-se sobre telefone celular e fixo
* em contrapartida com anos anteriores, que só perguntava por 
* telefone.
qui sum v0101
local max = r(max)
local min = r(min)

g telefone = v0220
if `max'==2001 {
	replace telefone = 2 if v2020==2 & telefone>2
	replace telefone = 4 if v2020==4 & telefone>4
	replace telefone = 9 if v2020==9 & telefone>9
	drop v2020
}
drop v0220 
recode telefone (2 =1) (4=0) (9=.)
lab var telefone "tem telefone (de 2001 em diante, fixo ou celular)"
* 1 = sim; 0 = nao

/* RECODE */

/* NUMERO DE CÔMODOS/DORMITÓRIOS */
recode v0205 v0206 (99 -1 =.)

/* VALOR DO ALUGUEL/PRESTAÇÃO */
recode v0208 v0209 (-1 =.)
replace v0208 = . if v0208>10^11
replace v0209 = . if v0209>10^11

/* RENDA MENSAL DOMICILIAR */
recode v4614 (-1 =.)
replace v4614 = . if v4614>10^11

/* PESOS */
* ENTRE 92 E 2001, "-1" PARECE SER == MISSING 
recode v4611 (-1=.)

/* RECODES: IGNORADO PARA MISSING */
recode v0202 v0203 v0204 v0207 v2081 v2091 v0210 v0211 v0212 v0213 v0214 v0215 ///
	v0216 v0217 v0218 v0219 v0221 v0222 v0223 v0224 v0225 v0226 ///
	v0227 v0228 v0229 v0230 (9=.)

/* DEFLACIONANDO E CONVERTENDO UNIDADES MONETÁRIAS PARA REAIS */

/* CONVERTENDO OS VALORES NOMINAIS PARA REAIS (UNIDADE MONETÁRIA) */
/* 	E DEFLACIONANDO: 1 = out/2012                                 */

gen double deflator = 0.488438 if v0101 == 2001
format deflator %26.25f
replace deflator    = 0.425376 if v0101 == 1999
replace deflator    = 0.399657 if v0101 == 1998
replace deflator    = 0.387748 if v0101 == 1997
replace deflator    = 0.371635 if v0101 == 1996
replace deflator    = 0.330617 if v0101 == 1995
replace deflator    = 0.103168/10 if v0101 == 1993
replace deflator    = 0.498848/1000 if v0101 == 1992

label var deflator "deflator - base:out/2012"  

gen double conversor = 1             if v0101 >= 1995
replace conversor    = 2750          if v0101 == 1993
replace conversor    = 2750000       if v0101 == 1992

label var conversor "conversor de moedas"

foreach valor in v0208 v0209 v4614 {
	g `valor'def = (`valor'/conversor)/deflator
	lab var `valor'def "`valor' deflacionada"
}


/* E. KEEPING */

order v0101 uf id_dom v0104 v0105 v0106 v0201 v0202 v0203 v0204 v0205 ///
	v0206 v0207 v0208 v2081 v0209 v2091 v0210 v0211 v0212 v0213 v0214 v0215 ///
	v0216 v0217 v0218 v0219 telefone v0221 v0222 v0223 v0224 v0225 v0226 v0227 ///
	v0228 v0229 v0230 v4105 v4106 v4107 v4600 v4601 v4602 v4604 v4605 v4606 ///
	v4607 v4608 v4609 v4610 v4611 v4614 *def deflator conversor

keep v0101-conversor

compress

end

************************************************************
**************compat_dom_2002a2009_para_81.ado**************
************************************************************

program define compat_dom_2002a2009_para_81

/* A. ACERTA CÓDIGO DOS ESTADOS */
* AGREGA TOCANTINS COM GOIÁS

/* A.1 NA VARIÁVEL UF E CRIA VARIÁVEL DE REGIÃO */
destring uf, replace
recode uf (17=52)
gen regiao = int(uf/10)
label var regiao "região"
tostring uf, replace

/* B. NÚMERO DE CONTROLE E SÉRIE */
drop v0102 v0103

/* C. RECODE E RENAME DAS VARIÁVEIS */

/* C.0 RECODE: ANO */
rename v0101 ano
label var ano "ano da pesquisa"

/* C.1 DUMMY: ZONA URBANA */
recode v4105 (1 2 3=1) (4 5 6 7 8=0)
rename v4105 urbana
label var urbana "área urbana"

/* C.2 AREA CENSITARIA  */
rename v4107 area_censit

/* C.3 RECODE: PESOS */
* ENTRE 92 E 2001, "-1" PARECE SER == MISSING 
recode v4611 (-1=.)
rename v4611 peso

/* C.4 RECODE: TOTAL DE PESSOAS, TOTAL DE PESSOAS 10 ANOS OU MAIS E 5 ANOS OU MAIS */
* ENTRE 92 E 2001, "-1" PARECE SER == MISSING
recode v0105 (-1=.)
recode v0106 (-1=.)
rename v0105 tot_pess
rename v0106 tot_pess_10_mais

/* C.5 RENAME: ESPÉCIE DE DOMICÍLIO */
rename v0201 especie_dom

/* C.6 RENAME: TIPO DE DOMICÍLIO */
rename v0202 tipo_dom

/* C.7 RECODE: PAREDE */
recode v0203 (6=5) (9=.)
rename v0203 parede

/* C.8 RECODE: COBERTURA */
recode v0204 (7=6) (9=.)
rename v0204 cobertura

/* C.9 DUMMY: ABAST ÁGUA */
recode v0212 (2=1) (4 6=0) (9=.)
rename v0212 agua_rede 
replace agua_rede = 1 if v0213==1
replace agua_rede = 0 if v0213==3
label var agua_rede "água provém de rede"
* agua_rede - 1 rede
*			- 0 outra

/* C.10 RECODE: ESGOTO */
recode v0217 (1=0) (3=2) (5 7=6) (9=.)
rename v0217 esgoto
* esgoto = 0 rede geral
*        = 2 fossa séptica 
*        = 4 fossa rudimentar
*        = 6 outra

/* C.11 SANITÁRIO */

* C.11.1 DUMMY: EXISTE SANITÁRIO
recode v0215 (3=0) (9=.)
rename v0215 sanit
label var sanit "possui sanitario"
* sanitary 	- 1 possui
*			- 0 nao possui

/* C.11.2 DUMMY: SANITÁRIO EXCLUSIVO */
recode v0216 (2=1) (4=0) (9=.)
rename v0216 sanit_excl
label var sanit_excl "sanit excl do domicílio"

/* C.12 DUMMY: LIXO */
recode v0218 (2=1) (3/6=0) (9=.)
rename v0218 lixo
label var lixo "lixo é coletado"

/* C.13 DUMMY: ILUMINAÇÃO ELÉTRICA */
recode v0219 (3 5=0) (9=.)
rename v0219 ilum_eletr
label var ilum_eletr "possui ilum elétrica"

/* C.14 RECODE: NÚMERO DE CÔMODOS E DORMITÓRIOS */
recode v0205 (-1 99=.) 
rename v0205 comodos
recode v0206 (-1 99=.)
rename v0206 dormit

/* C.15 DUMMY: CONDIÇÃO DE OCUPAÇÃO */
recode v0207 (2 = 1) (3/6 = 0) (9 = .), gen(posse_dom)
label var posse_dom "posse do domicílio"
* posse_dom	- 1	proprio
*			- 0	alugado/cedido/outro
drop v0207

/* C.16 VALOR DO ALUGUEL/PRESTAÇÃO */
recode v0208 (-1=.) 
recode v0208 (999999999999=.)
recode v0208 (999999999998=.)
recode v0208 (888888888888=.)
recode v0209 (-1=.) 
recode v0209 (999999999999=.)
recode v0209 (999999999998=.)
recode v0209 (888888888888=.)
rename v0208 aluguel
rename v0209 prestacao 

/* C.17 DUMMY: FILTRO */
recode v0224 (2=1) (4=0) (9=.)
rename v0224 filtro

/* C.18 DUMMY: FOGÃO */
recode v0221 (3=0) (9=.)
recode v0222 (2=1) (4=0) (9=.)
gen fogao = 1 if v0221 == 1 | v0222 == 1
replace fogao = 0 if v0221 == 0 & v0222 == 0
replace fogao = . if v0221 == . & v0222 == .
label var fogao "possui fogao"
drop v0221 v0222

/* C.19 DUMMY: GELADEIRA */
recode v0228 (2 4=1) (6=0) (9=.)
rename v0228 geladeira

/* C.20 DUMMY: RÁDIO */
recode v0225 (3=0) (9=.)
rename v0225 radio

/* C.21 DUMMY: TELEVISÃO */
recode v0226 (2=1) (4=0) (9=.)
recode v0227 (3=0) (9=.)
gen tv = 1 if v0226 == 1 | v0227 == 1
replace tv = 0 if v0226 == 0 & v0227 == 0
replace tv = . if v0226 == . & v0227 == .
label var tv "possui televisão"
drop v0226 v0227

/* C.22 VALOR DA RENDA DOMICILIAR */
replace v4614 = . if v4614>=999999999
rename v4614 renda_domB 

/* C.23 OUTROS */
drop v0220

sum ano
if r(mean)==2003 rename v4615 UPA 
					

/* D. KEEPING */
order ano regiao uf id_dom urbana area_censit tot_pess tot_pess_10_mais especie_dom ///
	tipo_dom parede cobertura agua_rede esgoto sanit_excl lixo ilum_eletr comodos dormit ///
		sanit posse_dom filtro fogao geladeira radio tv renda_domB peso aluguel prestacao

keep ano-prestacao
compress


/* D. DEFLACIONANDO E CONVERTENDO UNIDADES MONETÁRIAS PARA REAIS */

/* CONVERTENDO OS VALORES NOMINAIS PARA REAIS (UNIDADE MONETÁRIA) */
/* 	E DEFLACIONANDO : 1 = out/2012                                */
gen double deflator = 1  if ano == 2012
format deflator %26.25f
replace deflator    = 0.945350  if ano == 2011
replace deflator    = 0.841309  if ano == 2009
replace deflator    = 0.806540  if ano == 2008
replace deflator    = 0.752722  if ano == 2007
replace deflator    = 0.717917  if ano == 2006
replace deflator    = 0.698447  if ano == 2005
replace deflator    = 0.663870  if ano == 2004
replace deflator    = 0.627251  if ano == 2003
replace deflator    = 0.536898  if ano == 2002
replace deflator    = 1.056364  if ano == 2013
replace deflator    = 1.124668  if ano == 2014
replace deflator    = .  if ano == 2015


label var deflator "deflator - base:out/2012"

gen double conversor = 1

label var conversor "conversor de moedas"

foreach var in renda_domB aluguel prestacao {
	g `var'_def = (`var'/conversor)/deflator
	lab var `var'_def "`var' deflacionada"
}

end

************************************************************
**************compat_dom_2002a2009_para_92.ado**************
************************************************************

program define compat_dom_2002a2009_para_92

/* A. Ano */
* nada a fazer nesta variável nesta década

/* B. NÚMERO DE CONTROLE E SÉRIE */
drop v0102 v0103
destring uf, replace

/* C. NÚMERO DE MORADORES */
* nada a fazer nesta variável nesta década


/* D. TELEFONE */
* A partir de 2001, pergunta-se sobre telefone celular e fixo,
* diferentemente de anos anteriores, que só perguntava por 
* telefone.
g telefone = v0220
replace telefone = v2020 if telefone==.
recode telefone (2 =1) (4=0) (9=.)
* 1 = sim; 0 = nao
lab var telefone "has telephone"
drop v0220 v2020

/* RECODES */

/* NÚMERO DE CÔMODOS/DORMITÓRIOS */
recode v0205 v0206 (99 -1 =.)

/* VALOR DO ALUGUEL/PRESTAÇÃO */
replace v0208 = . if v0208>10^11
replace v0209 = . if v0209>10^11

/* RENDA MENSAL DOMICILIAR */
replace v4614 = . if v4614>10^11

/* PESOS */
* nada a fazer aqui

/* RECODES: IGNORADO PARA MISSING */
recode v0202 v0203 v0204 v0207 v0210 v0211 v0212 v0213 v0214 v0215 ///
	v0216 v0217 v0218 v0219 v0221 v0222 v0223 v0224 v0225 v0226 ///
	v0227 v0228 v0229 v0230 (9=.)

cap recode v2081 v2091 (9=.) 	// essas variáveis nao existem de 2007 em diante

/* DEFLACIONANDO E CONVERTENDO UNIDADES MONETÁRIAS PARA REAIS */

/* CONVERTENDO OS VALORES NOMINAIS PARA REAIS (UNIDADE MONETÁRIA) */
/* 	E DEFLACIONANDO : 1 = out/2012                                */
gen double deflator = 1  if v0101 == 2012
format deflator %26.25f

replace deflator = 	0.536842105	if v0101==	2002
replace deflator = 	0.627244582	if v0101==	2003
replace deflator = 	0.66377709	if v0101==	2004
replace deflator = 	0.698452012	if v0101==	2005
replace deflator = 	0.717894737	if v0101==	2006
replace deflator = 	0.752693498	if v0101==	2007
replace deflator = 	0.806439628	if v0101==	2008
replace deflator = 	0.84123839	if v0101==	2009
replace deflator = 	0.945263158	if v0101==	2011
replace deflator = 	1.056346749	if v0101==	2013
replace deflator = 	1.124582043	if v0101==	2014
replace deflator = 	1.238390093	if v0101==	2015



label var deflator "income deflator - reference: oct/2012"  

gen double conversor = 1

label var conversor "currency converter"

foreach valor in v0208 v0209 v4614 {
	g `valor'def = (`valor'/conversor)/deflator
	lab var `valor'def "`valor' deflated"
}


/* KEEPING */

order v0101 uf id_dom v0104 v0105 v0106 
	
foreach var in v2006 v2010 v2210 v2016 v2027 v0231 v0232 v2032 v4617 v4618 ///
	v4619 v4620 v4621 v4622 v4624 v9992 UPA {
	cap drop `var'
}

compress

end

************************************************************
**************compat_pess_1981a1990_para_81.ado*************
************************************************************

program define compat_pes_1981a1990_para_81

/* CRIANDO VARIÁVEL TEMPORÁRIA PARA VERIFICAR PRESENÇA 
   DE ANOS NOS QUAIS EM VEZ DA VAR v0101 HAVIA AS
   VARIÁVEIS v0102 E v0103                          */

tempvar anos_v0102
gen byte `anos_v0102' = (ano==1983)|(ano==1990)

qui sum ano
if r(mean)==1981 drop v62* v63* v64* v65* v66* v0820 v76* v86* v96* v67* v68*
if r(mean)==1982 drop v6301 v6303-v6309 v64* v65* v66* v67* v68* v69* v71*
if r(mean)==1983 drop v2201 -v1638
if r(mean)==1984 drop v2301- v6125
if r(mean)==1985 drop v2301- v3108
if r(mean)==1986 drop v2202- v2920 
if r(mean)==1988 drop v2301- v3425 
if r(mean)==1989 drop v2401- v3804 					
if r(mean)==1990 drop v0810- v3804 					

cap drop v0102 v0103

/* A. ACERTA CÓDIGO DOS ESTADOS */

destring uf, replace
recode uf (11/14=33) (20/29=35) (30/31 37=41) (32=42) (33/35=43) ///
(41/42=31) (43=32) (51=21) (52=22) (53=23) (54=24) (55=25) ///
(56=26) (57=27) (58=28) (59/60=29) (61=53) (71=11) (72=12) ///
(73=13) (74=14) (75=15) (76=16) (81=50) (82=51) (83=52) 
gen regiao = int(uf/10)
label var regiao "região"
tostring uf, replace

/* B. NÚMERO DE CONTROLE, SÉRIE E ORDEM */
* variavel "ordem" criada no ado principal

/* C. RECODE E RENAME DAS VARIÁVEIS */

/* C.1 DUMMY: ZONA URBANA */
recode v0003 (5=0)
rename v0003 urbana
label var urbana "zona urbana"
* urbana = 1 urbana
*        = 0 rural

/* C.2 DUMMY: REGIÃO METROPOLITANA */
recode v0005 (2/3=0), g(metropol)
label var metropol "região metropolitana"
* reg_metro = 1 região metropolitana
*           = 0 não

rename v0005 area_censit

/* C.3 REPLACE: PESOS */
generate int peso =.
lab var peso "peso amostral"

quietly summ ano
loc min = r(min)
loc max = r(max)
* Verifica se há o ano de 1990,
* quando o peso era dado por v3091
if `max' == 1990 {
   replace peso = v3091
   drop v3091
}

* Verifica se há anos da déc. de 80,
* quando o peso era dado por v9991
else {
   replace peso = v9991
   drop v9991
}

cap drop v9981 // peso do chefe dom

/* C.4 DUMMY: SEXO */
recode v0303 (3=0)
rename v0303 sexo
label var sexo "0-mulher 1-homem"
* sexo = 1 homem
*      = 0 mulher

/* C.5 DATA DE NASCIMENTO */
* O ano de nascimento reporta a idade quando a idade é presumida.
* Substituindo por missing.
recode v0310 (0/98=.) if v0309 == 20 | v0309 == 30

* Em alguns casos, o ano de nascimento e a idade estão trocados.
gen x1 = v0310 if v0310 < 800
gen x2 = v0805 if v0805 > 800
replace v0310 = x2 if x1 ~= .
replace v0805 = x1 if x2 ~= .
drop x1 x2
recode v0310 (999=.)

* Acrescentando o 1 no ano de nascimento
* Pessoas com idade presumida não tem ano de nascimento
gen x1 = 1
egen ano_nasc = concat(x1 v0310) if v0310 ~= .
drop x1 v0310
destring ano_nasc, replace
label var ano_nasc "ano de nascimento"

recode v0308 (0 99=.) 
rename v0308 dia_nasc
* 0(zero) seria idade presumida, 99 sem declaração

recode v0309 (20 30 99 =.)
rename v0309 mes_nasc
* 20 e 30 seriam idade presumida, 99 sem declaração

/* C.6 RENAME: IDADE */
rename v0805 idade

/* C.7 RENAME: CONDIÇÃO NO DOMICÍLIO */
rename v0305 cond_dom
label var cond_dom "condição no domicílio"
* cond_dom = 1 chefe
*          = 2 cônjuge
*          = 3 filho
*          = 4 outro parente
*          = 5 agregado
*          = 6 pensionista
*          = 7 empregado doméstico
*          = 8 parente do empregado doméstico

/* C.8 RENAME: CONDIÇÃO NA FAMÍLIA */
rename v0306 cond_fam
label var cond_fam "condição na família"
* cond_fam = 1 chefe
*          = 2 cônjuge
*          = 3 filho
*          = 4 outro parente
*          = 5 agregado
*          = 6 pensionista
*          = 7 empregado doméstico
*          = 8 parente do empregado doméstico

/* C.9 RENAME: NÚMERO DA FAMÍLIA */
rename v0307 num_fam
rename v9329 num_pes_fam


/* C.10 RECODE: COR OU RAÇA */
* obs: em 1984, esta variável não existe para todas as pessoas

g cor = .
tempvar ano_cor
g `ano_cor' = ano
qui sum `ano_cor'
loc min = r(min)
if `min'==1982 {
	replace cor = 2 if v6302==1
	replace cor = 4 if v6302==3
	replace cor = 6 if v6302==7
	replace cor = 8 if v6302==5
	replace `ano_cor' = . if ano==`min'
	drop v6302
}
if `min'==1986 {
	replace cor = 2 if v2201==2
	replace cor = 4 if v2201==4
	replace cor = 6 if v2201==8
	replace cor = 8 if v2201==6
	replace `ano_cor' = . if ano==`min'
	drop v2201
}
if `min'>1986 & `min'~=. {
	replace cor = 2 if v0304==2
	replace cor = 4 if v0304==4
	replace cor = 6 if v0304==8
	replace cor = 8 if v0304==6
}
label var cor "2-branca 4-preta 6-amarela 8-parda"

cap drop v0304
cap drop v2301

* cor = 2 branca
*     = 4 preta
*     = 6 amarela
*     = 8 parda
* A opção "0 indígena" somente apareceu a partir de 92.


/* C.11 VARIÁVEIS DE EDUCAÇÃO */

/* C.11.1 RECODE: ANOS DE ESTUDO */
/* EDUCAÇÃO */
/* VARIÁVEIS UTILIZADAS */
/* v0314=QUAL E O CURSO QUE FREQUENTA? */
/* v0312=QUAL E A SERIE QUE FREQUENTA? */
/* v0317=QUAL FOI O CURSO MAIS ELEVADO QUE FREQUENTOU ANTERIORMENTE? */
/* v0315=ESTE CURSO QUE FREQUENTOU ANTERIORMENTE ERA SERIADO? */

/* pessoas que ainda freqüentam escola */
gen educa =0 if   v0314==1 & v0312==1
lab var educa "anos de escolaridade - compatível c/ anos 1980"

replace educa =1 if   v0314==1 & v0312==2
replace educa =2 if   v0314==1 & v0312==3
replace educa =3 if   v0314==1 & v0312==4

replace educa =4 if   v0314==2 & v0312==1
replace educa =5 if   v0314==2 & v0312==2
replace educa =6 if   v0314==2 & v0312==3
replace educa =7 if   v0314==2 & v0312==4

replace educa =8 if   v0314==3 &  v0312==1
replace educa =9 if   v0314==3 &  v0312==2
replace educa =10 if   v0314==3 &  v0312==3

replace educa =0 if   v0314==4 & v0312==1
replace educa =1 if   v0314==4 & v0312==2
replace educa =2 if   v0314==4 & v0312==3
replace educa =3 if   v0314==4 & v0312==4
replace educa =4 if   v0314==4 & v0312==5
replace educa =5 if   v0314==4 & v0312==6
replace educa =6 if   v0314==4 & v0312==7
replace educa =7 if   v0314==4 & v0312==8 

replace educa =8 if   v0314==5 &  v0312==1
replace educa =9 if   v0314==5 &  v0312==2
replace educa =10 if   v0314==5 &  v0312==3
replace educa =11 if   v0314==5 &  v0312==4

replace educa =11 if   v0314==6 & v0312==1
replace educa =12 if   v0314==6 & v0312==2
replace educa =13 if   v0314==6 & v0312==3
replace educa =14 if   v0314==6 & v0312==4
replace educa =15 if   v0314==6 & v0312==5
replace educa =16 if   v0314==6 & v0312==6

replace educa =0 if   v0314==7  

replace educa =0 if   v0314==8

replace educa =0 if   v0314==9 &  v0312==1
replace educa =1 if   v0314==9 &  v0312==2
replace educa =2 if   v0314==9 &  v0312==3
replace educa =3 if   v0314==9 &  v0312==4
replace educa =4 if   v0314==9 &  v0312==5
replace educa =5 if   v0314==9 &  v0312==6
replace educa =6 if   v0314==9 &  v0312==7
replace educa =7 if   v0314==9 &  v0312==8

replace educa =8 if   v0314==10 &  v0312==1
replace educa =9 if   v0314==10 &  v0312==2
replace educa =10 if   v0314==10 &  v0312==3

replace educa =0 if   v0314==11 &  v0312==1
replace educa =1 if   v0314==11 &  v0312==2
replace educa =2 if   v0314==11 &  v0312==3
replace educa =3 if   v0314==11 &  v0312==4
replace educa =4 if   v0314==11 &  v0312==5
replace educa =5 if   v0314==11 &  v0312==6
replace educa =6 if   v0314==11 &  v0312==7
replace educa =7 if   v0314==11 &  v0312==8

replace educa =8 if   v0314==12 &  v0312==1
replace educa =9 if   v0314==12 &  v0312==2
replace educa =10 if   v0314==12 &  v0312==3

replace educa =11 if   v0314==14 

replace educa =15 if   v0314==15

/* pessoas que não freqüentam */
replace educa =1 if   v0317==1 & v0315==1
replace educa =2 if   v0317==1 & v0315==2
replace educa =3 if   v0317==1 & v0315==3
replace educa =4 if   v0317==1 & v0315==4
replace educa =4 if   v0317==1 & v0315==5

replace educa =5 if   v0317==2 & v0315==1 
replace educa =6 if   v0317==2 & v0315==2 
replace educa =7 if   v0317==2 & v0315==3 
replace educa =8 if   v0317==2 & v0315==4 
replace educa =8 if   v0317==2 & v0315==5 

replace educa =9 if   v0317==3 & v0315==1 
replace educa =10 if   v0317==3 & v0315==2 
replace educa =11 if   v0317==3 & v0315==3 
replace educa =11 if   v0317==3 & v0315==4 

replace educa =1 if   v0317==4 & v0315==1 
replace educa =2 if   v0317==4 & v0315==2 
replace educa =3 if   v0317==4 & v0315==3 
replace educa =4 if   v0317==4 & v0315==4 
replace educa =5 if   v0317==4 & v0315==5 
replace educa =6 if   v0317==4 & v0315==6 
replace educa =7 if   v0317==4 & v0315==7 
replace educa =8 if   v0317==4 & v0315==8 

replace educa =9 if   v0317==5 & v0315==1 
replace educa =10 if   v0317==5 & v0315==2 
replace educa =11 if   v0317==5 & v0315==3 
replace educa =11 if   v0317==5 & v0315==4 

replace educa =12 if   v0317==6 & v0315==1
replace educa =13 if   v0317==6 & v0315==2
replace educa =14 if   v0317==6 & v0315==3
replace educa =15 if   v0317==6 & v0315==4
replace educa =16 if   v0317==6 & v0315==5
replace educa =17 if   v0317==6 & v0315==6

replace educa =17 if   v0317==7 
replace educa =0 if   v0312==0 & v0314==0 & v0315==0 & v0317==0

lab var educa "anos de estudo - compatível c/ anos 1980"

drop v0318

/* C.11.2 RENAME: FREQUENTA ESCOLA */
gen freq_escola = 1 if (v0312>=1 & v0312<=8) | (v0314>=1 & v0314<=15)
recode freq_escola (.=-1) if v0312==. & v0314==.
recode freq_escola (.=0)
recode freq_escola (-1=.)
label var freq_escola "0-não freq 1-frequenta"
* freq_escola = 1 se frequenta alguma série ou algum grau
*             = 0 caso contrário

/* C.11.3 DUMMY: LER E ESCREVER */
recode v0311 (3=0) (9=.)
rename v0311 ler_escrever
* ler_escrever = 1 sim
*              = 0 não

/* C.11.4 RECODE: SÉRIE QUE FREQÜENTA NA ESCOLA */
recode v0312 (0 9=.)
recode v0312 (1=5) (2=6) (3=7) (4=8) if v0314 == 2
rename v0312 serie_freq
* A partir de 92, a pergunta inclui se frequenta creche.

/* C.11.5 RECODE: GRAU QUE FREQÜENTA NA ESCOLA */
recode v0314 (0 13 99=.) 
recode v0314 (2 4=1) (3 5=2) (6=5) (8=6) (9 11=3) (10 12=4) (14=8) (15=9) 
rename v0314 grau_freq
* grau_freq = 1 regular primeiro grau
*           = 2 regular segundo grau
*           = 3 supl primeiro grau
*           = 4 supl segundo grau
*           = 5 superior
*           = 6 alfab de adultos
*           = 7 pré-escolar ou creche
*           = 8 pré-vestibular
*           = 9 mestrado/doutorado

/* C.11.6 RECODE: SÉRIE - NÃO FREQUENTA ESCOLA */
recode v0315 (0 9=.)
rename v0315 serie_nao_freq
* Observação: no primário - v0317==1 - podem existir até 6 séries, e não apenas 4.

/* C.11.7 RECODE: GRAU NÃO FREQÜENTA NA ESCOLA */
recode v0317 (0 99=.)
rename v0317 grau_nao_freq
* grau_nao_freq = 1 elementar (primário)
*               = 2 médio primeiro ciclo (ginasial)
*               = 3 médio segundo ciclo (científico, clássico etc.)
*               = 4 primeiro grau
*               = 5 segundo grau
*               = 6 superior
*               = 7 mestrado/doutorado
*               = 8 alfab de adultos
*               = 9 pré-escolar ou creche
* O código 9 só existe a partir de 1992.
* O código 8 só existe em 1981 e depois a partir de 1992.
* O dicionário de 1981 não explicita que 8 é alfab. de adultos;
* entretanto só há pessoas com mais de 16 anos nessa categoria e,
* além disso, só têm 1 ano de estudo.

drop v0319

/* C.12 CARACTERÍSTICAS DO TRABALHO PRINCIPAL NA SEMANA */
/* C.12.0 DUMMY: TRABALHOU NA SEMANA */
gen trabalhou_semana = 1 if v0501 == 1
replace trabalhou_semana = 0 if  v0501 >= 2 & v0501 <9  
label var trabalhou_semana "trabalhou na semana?"
* trabalhou_semana = 1 sim
*                  = 0 não

/* C.12.1 DUMMY: tinha TRABALHO NA SEMANA */
gen tinha_trab_sem = v0501 == 2 if trabalhou_semana==0
label var tinha_trab_sem "tinha trabalho na semana?"
* tinha_trab_sem = 1 sim
*               = 0 não

drop v0501


/* C.12.2 RENAME: OCUPAÇÃO NA SEMANA */
rename v0503 ocup_sem
label var ocup_sem "ocupação na semana"

recode v5030 (9=.)
rename v5030 grupos_ocup_sem 
label var grupos_ocup_sem "occupation groups - week"
* grupos_ocup_sem = 1 técnica, científica, artística e assemelhada
*             = 2 administrativa
*             = 3 agrop. e prod. extrat. vegetal e animal
*             = 4 ind. de transf.
*             = 5 comércio e ativ. auxiliares
*             = 6 transp. e comunicação
*             = 7 prestação de serviços
*             = 8 outras ou não declaradas

/* C.12.3 RENAME: ATIVIDADE/RAMOS DO NEGÓCIO */
* v0504 é mais desagregado - códigos variam ao longo do tempo
* v5040 é mais agregado e comum entre os anos das PNAD's

rename v0504 ramo_negocio_sem
label var ramo_negocio_sem "ativ/ramo do negócio na semana"

rename v5040 ramo_negocio_agreg
label var ramo_negocio_agreg "ativ/ramo do negócio na semana - agregado"
* ramo_negocio_agreg = 1 agrícola
*                    = 2 ind. transf.
*                    = 3 ind. constr.
*                    = 4 out. ativ. industr.
*                    = 5 comércio mercadorias
*                    = 6 prestação de serviços
*                    = 7 serv. aux. ativ. econom.
*                    = 8 transporte e comunicação
*                    = 9 social
*                    = 10 administr. pública
*                    = 11 outras atividades ou não declarada


/* C.12.4 RECODE: POSIÇÃO NA OCUPAÇÃO NA SEMANA */
* v0505 é mais detalhado, mas de difícil compatibilização com as PNAD's dos anos 90
* foi eliminada
drop v0505
* v5050 é mais agregado, mas tem correspondente nas PNAD's dos anos 90
recode v5050 (5=.) 
rename v5050 pos_ocup_sem
label var pos_ocup_sem "posição na ocupação na semana"
* pos_ocup_sem = 1 empregado 
*              = 2 conta própria
*              = 3 empregador
*              = 4 não remunerado


/* C.12.5 RECODE: TEM CARTEIRA ASSINADA */
recode v0506 (2=1) (4=0) (9=.)
rename v0506 tem_carteira_assinada
label var tem_carteira_assinada "0-não 1-sim"
* tem_carteira_assinada = 0 não
*                       = 1 sim

/* NOS ANOS 80, NAS QUESTÕES SOBRE HORAS TRABALHADAS, RESPONDIA APENAS QUEM */
/* DECLARAVA tinha_trab_sem == 1                                             */

/* C.12.6 HORAS TRABALHADAS */

/* RENAME: HORAS NORMALMENTE TRABALHADAS SEMANA */
recode v0508 (99=.) (0=.)
rename v0508 horas_trab_sem 
label var horas_trab_sem "horas normal. trab. sem - ocup. princ"

/* RENAME: HORAS NORMALMENTE TRABALHADAS - OUTRO TRABALHO */
recode v0510 (99=.) (0=.)
rename v0510 horas_trab_sem_outro
label var horas_trab_sem_outro "work hours second job - week"

/* RENAME: HORAS NORMALMENTE TRABALHADAS TODOS TRABALHOS */
recode v5100 (999=.)
rename v5100 horas_trab_todos_trab
label var horas_trab_todos_trab "horas normal. trab sem - todos trabalhos"
cap drop v5101


/* C.13 - RENDIMENTOS */

/* C.13.1 RECODE: RENDA MENSAL EM DINHEIRO */
recode v0537 (9999999=.) if ano >= 1981 & ano <= 1984
recode v0537 (999999999=.) if ano >= 1985 & ano <= 1990
rename v0537 renda_mensal_din

/* C.13.2 RECODE: RENDA MENSAL EM PRODUTOS/MERCADORIAS */
recode v0538 (9999999=.) if ano >= 1981 & ano <= 1984
recode v0538 (999999999=.) if ano >= 1985 & ano <= 1990
rename v0538 renda_mensal_prod

/* C.13.3 RECODE: RENDA MENSAL EM DINHEIRO OUTRA */
recode v0549 (9999999=.) if ano >= 1981 & ano <= 1984
recode v0549 (999999999=.) if ano >= 1985 & ano <= 1990
rename v0549 renda_mensal_din_outra

/* C.13.4 RECODE: RENDA MENSAL EM PRODUTOS/MERCADORIAS OUTRA */
recode v0550 (9999999=.) if ano >= 1981 & ano <= 1984
recode v0550 (999999999=.) if ano >= 1985 & ano <= 1990
rename v0550 renda_mensal_prod_outra

/* C.13.5 RECODE: VALOR APOSENTADORIA */
recode v0578 (9999999=.) if ano >= 1981 & ano <= 1984
recode v0578 (999999999=.) if ano >= 1985 & ano <= 1990
rename v0578 renda_aposentadoria

/* C.13.6 RECODE: VALOR PENSÃO */
recode v0579 (9999999=.) if ano >= 1981 & ano <= 1984
recode v0579 (999999999=.) if ano >= 1985 & ano <= 1990
rename v0579 renda_pensao

/* C.13.7 RECODE: VALOR ABONO PERMANENTE */
recode v0580 (9999999=.) if ano >= 1981 & ano <= 1984
recode v0580 (999999999=.) if ano >= 1985 & ano <= 1990
rename v0580 renda_abono

/* C.13.8 RECODE: VALOR ALUGUEL RECEBIDO */
recode v0581 (9999999=.) if ano >= 1981 & ano <= 1984
recode v0581 (999999999=.) if ano >= 1985 & ano <= 1990
rename v0581 renda_aluguel

/* C.13.9 RECODE: VALOR OUTRAS */
recode v0582 (9999999=.) if ano >= 1981 & ano <= 1984
recode v0582 (999999999=.) if ano >= 1985 & ano <= 1990
rename v0582 renda_outras

/* C.13.10 RECODE: REND MENSAL OCUP PRINCIPAL */
recode v0600 (9999999=.) if ano >= 1981 & ano <= 1984
recode v0600 (999999999=.) if ano >= 1985 & ano <= 1990
rename v0600 renda_mensal_ocup_prin

/* C.13.11 RECODE: REND MENSAL TODOS TRABALHOS */
recode v0601 (9999999=.) if ano >= 1981 & ano <= 1984
recode v0601 (999999999=.) if ano >= 1985 & ano <= 1990
rename v0601 renda_mensal_todos_trab

/* C.13.12 RECODE: REND MENSAL TODAS FONTES */
recode v0602 (9999999=.) if ano >= 1981 & ano <= 1984
recode v0602 (999999999=.) if ano >= 1985 & ano <= 1990
rename v0602 renda_mensal_todas_fontes

foreach name in v5070 v5071 v5072 v5090 v5091 v5092 v5093 {
	cap drop `name'
}

replace v5010 =. if v5010>=9999999
rename v5010 renda_mensal_fam

/* C.14.1 RECODE: CONTRIBUI INST. PREVID. */
recode v0511 (3=0) (9=.)
rename v0511 contr_inst_prev

/* C.14.2 RENAME: QUAL INST. PREVID. */
recode v0512 (9=.)
rename v0512 qual_inst_prev
* qual_inst_prev = 2 federal
*                = 4 estadual
*                = 6 municipal

/* C.15 RECODE: TINHA OUTRO TRABALHO? */
* Apenas para quem tinha trabalho na semana de referência
recode v0502 (3=0) (9=.)
rename v0502 tinha_outro_trab

/* C.16 PESSOAS QUE NÃO TINHAM TRABALHO NA SEMANA DE REFERÊNCIA               */
/*      MAS TIVERAM OCUPAÇÃO NO PERÍODO DE 12 MESES ANTERIORES                */
* As questões sobre o trabalho anterior são pesquisadas, de 1981 a 90, para os
* indivíduos que não tinham trabalho na semana de referência
* A partir da PNAD de 92, foram pesquisados também os indivíduos empregados na semana
* de referência, mas cujo trabalho na sem de ref não era o principal do ano.
* Além disso desde 1992 só foram pesquisados detalhes do trabalho anterior nos 358 dias
* anteriores à semana de referência.
* Assim, nos anos 80, foram mantidas as informações apenas para quem teve trabalho
* anterior nos últimos 12 meses.

/* RECODE: TEMPO SEM TRABALHO */
* Esta informação não pode mais ser aferida com precisão a partir dos anos 90.
* Logo, as variáveis abaixo serão usadas como auxiliares (v. seção C.18.3) e então eliminadas.
recode v0519 (99=.)
rename v0519 anos_nao_trab
recode v0569 (99=.)
rename v0569 meses_nao_trab

/* RECODE: TEMPO NA OCUPAÇÃO ANTERIOR, NO ANO */
* A partir de 1992, esta informação não pode ser obtida para todos os indivíduos.
drop v0523 v0573

/* INFORMAÇÕES SOBRE O EMPREGO ANTERIOR */
* COMO AQUI É SIMPLESMENTE O ÚLTIMO TRABALHO
* (DE QUEM NÃO TRABALHOU NA SEMANA DE REFEÊNCIA),
* ENQUANTO DE 92 EM DIANTE É O PRINCIPAL TRABALHO
* DO QUAL O INDIVÍDUO SAIU NO ANO, AS INFORMAÇÕES
* SOBRE O TRABALHO ANTERIOR DOS ANOS 80 E 90 NÃO
* SÃO PERFEITAMENTE COMPATÍVEIS.

/* DUMMY: NÃO TRABALHA E DEIXOU ÚLTIMO EMPREGO NO ÚLTIMO ANO - 12 MESES OU MENOS */
/* VARIÁVEL TEMPORÁRIA                                                                    */
gen tag = 1 if tinha_trab_sem == 0 & anos_nao_trab == 0 & meses_nao_trab ~= .
replace tag = 1 if tinha_trab_sem == 0 & anos_nao_trab == 1 & meses_nao_trab == 0

/* C.16.1. GEN: OCUPAÇÃO ANTERIOR, NO ANO */
gen ocup_ant_ano = v0520 if tag == 1
label var ocup_ant_ano "ocupação anterior - no ano"

/* C.16.2. GEN: RAMO ANTERIOR, NO ANO */
gen ramo_negocio_ant_ano = v0521 if tag == 1
label var ramo_negocio_ant_ano "ativ/ramo do negócio anterior - no ano"

/* C.16.3. RECODE: TINHA CARTEIRA ASSINADA NA OCUPAÇÃO ANTERIOR, NO ANO */
recode v0525 (2=1) (4=0) (9=.) 
replace v0525 = . if tag ~= 1
rename v0525 tinha_cart_assin_ant_ano
label var tinha_cart_assin_ant_ano "últ emprego - no ano - cart assin"

drop tag anos_nao_trab meses_nao_trab

/* C.18.3.6 RECODE: RECEBEU FGTS OCUPAÇÃO ANTERIOR, NO ANO */
* ESSA PERGUNTA NÃO CONSTA DAS PNAD'S DOS ANOS 90
drop v0526

/* C.17 RECODE: TOMOU PROV. PARA CONSEGUIR TRABALHO */
/* NA SEMANA DE REFERÊNCIA: APENAS QUEM NÃO TINHA TRABALHO NA SEMANA */
replace v0513=. if tinha_trab_sem == 1
recode v0513 (3=0) (9=.) 
rename v0513 tomou_prov_semana
* tomou_prov_semana = 1 sim
*                   = 0 não

/* C.18 RECODE: TOMOU PROV. CONSEGUIR PARA TRABALHO 2 MESES */
replace v0514=. if tinha_trab_sem == 1
recode v0514 (2=1) (4=0) (9=.)
rename v0514 tomou_prov_2meses
* tomou_prov_2meses = 1 sim
*                   = 0 não

/* C.19 RECODE: QUE PROV. TOMOU PARA CONSEGUIR TRABALHO */
recode v0515 (9=.)
rename v0515 que_prov_tomou
* que_prov_tomou = 1 consultou empregador
*                         = 2 fez concurso
*                         = 3 consultou agência/sindicato
*                         = 4 colocou anúncio
*                         = 5 consultou parente
*                         = 6 outra
*                         = 7 nada fez

* As variáveis sobre ocupação anterior
drop v0520 v0521 

drop v0516 v0566 v0517 v0518 v0522 v0524 v9330

/* D. DEFLACIONANDO E CONVERTENDO UNIDADES MONETÁRIAS PARA REAIS */

/* CONVERTENDO OS VALORES NOMINAIS PARA REAIS (UNIDADE MONETÁRIA) */
/* 	E DEFLACIONANDO (OUT/2012)                                            */
gen double deflator = 0.807544/100000 if ano == 1990
format deflator %26.25f
replace deflator    = 0.269888/1000000 if ano == 1989
replace deflator    = 0.196307/10000000    	 	if ano == 1988
replace deflator    = 0.241162/100000000	   	if ano == 1987
replace deflator    = 0.602708/1000000000   	if ano == 1986
replace deflator    = 0.304402/1000000000	  	if ano == 1985
replace deflator    = 0.962506/10000000000   	if ano == 1984
replace deflator    = 0.330205/10000000000		if ano == 1983
replace deflator    = 0.133929/10000000000 		if ano == 1982
replace deflator    = 0.636330/100000000000		if ano == 1981

label var deflator "deflator - base: out/2012"
  
gen double conversor = 2750000       if ano >= 1989
replace conversor    = 2750000000    if ano >= 1986 & ano <= 1988
replace conversor    = 2750000000000 if ano <= 1985

label var conversor "conversor de moedas"

foreach i in din prod din_outra prod_outra ocup_prin todos_trab todas_fontes fam {
	g renda_`i'_def = (renda_mensal_`i'/conversor)/deflator 
	lab var renda_`i'_def "renda_mensal_`i' deflacionada"
}

foreach i in aposentadoria pensao abono aluguel outras {
	g renda_`i'_def = (renda_`i'/conversor)/deflator
	lab var renda_`i'_def "renda_`i' deflacionada"
}

order ano uf id_dom num_fam regiao urbana metropol area_censit peso ///
	sexo cond_dom cond_fam dia_nasc mes_nasc ano_nasc idade 

drop v0100
compress

end

************************************************************
**************compat_pess_1992a2001_para_81.ado*************
************************************************************
program define compat_pes_1992a2001_para_81

/* C.0 RECODE: ANO */
recode v0101 (92=1992) (93=1993) (95=1995) (96=1996) (97=1997) (98=1998) (99=1999)
rename v0101 ano
label var ano "ano da pesquisa"

qui sum ano
if r(mean)==1993 | r(mean)==1995 drop v08* 
if r(mean)==1996 drop v1201-v1219 
if r(mean)==1998 drop v13* v14* v78* v79* 
if r(mean)==2001 drop v81* v15* v16* v22*

foreach var in v4725 v4726 v4732 v4738 v4741 v4742 v4743 v4838 v4788 v4785 v4776 v4739 v4740 v9993 {
	cap drop `var'
}

/* A. ACERTA CÓDIGO DOS ESTADOS */
* AGREGA TOCANTINS COM GOIÁS E CRIA VARIÁVEL DE REGIÃO */
destring uf, replace
recode uf (17=52)
gen regiao = int(uf/10)
label var regiao "região"
tostring uf, replace

/* B. NÚMERO DE CONTROLE, SÉRIE E ORDEM */
rename v0301 ordem
drop v0102 v0103

/* C. RECODE E RENAME DAS VARIÁVEIS */

/* C.1 DUMMY: ZONA URBANA */
recode v4728 (1 2 3=1) (4 5 6 7 8=0)
rename v4728 urbana
label var urbana "área urbana"
* urbana = 1 urbana
*        = 0 rural

/* C.2 DUMMY: REGIÃO METROPOLITANA */
recode v4727 (2/3=0), g(metropol)
label var metropol "região metropolitana"
* metropol = 1 região metropolitana
*          = 0 não

rename v4727 area_censit

/* C.3 RENAME: PESOS */
rename v4729 peso

/* C.4 RECODE: SEXO */
recode v0302 (2=1) (4=0)
rename v0302 sexo
* sexo = 1 homem
*      = 0 mulher

/* C.5 DATA DE NASCIMENTO */
recode v3031 (0 99=.)
rename v3031 dia_nasc

recode v3032 (20 99=.)
rename v3032 mes_nasc

* O ano de nascimento reporta a idade quando a idade é presumida.
* Substituído por missing.
recode v3033 (0/98=.)
recode v3033 (999=.) if ano~=1999
* Se ano~=2001 Acrescentando o 1 no ano de nascimento
* Pessoas com idade presumida não tem ano de nascimento
sum ano
loc max = r(max)
loc min = r(min)
if `max'==2001 {
	replace v3033 =. if v3033==9999
	rename v3033 ano_nasc
}
else {
	gen x1 = 1
	egen ano_nasc = concat(x1 v3033) if v3033 ~= .
	destring ano_nasc, replace
	drop x1 v3033
}
label var ano_nasc "ano de nascimento"

/* C.6 RECODE: IDADE */
recode v8005 (999=.)
rename v8005 idade

/* C.7 RECODE: CONDIÇÃO NO DOMICÍLIO */
rename v0401 cond_dom
label var cond_dom "1-chef 2-cônj 3-filh 4-outr_parent 5-agreg 6-pens 7-empr_domes 8-parent_empr_dom"
* cond_dom = 1 chefe
*          = 2 cônjuge
*          = 3 filho
*          = 4 outro parente
*          = 5 agregado
*          = 6 pensionista
*          = 7 empregado doméstico
*          = 8 parente do empregado doméstico

/* C.8 RENAME: CONDIÇÃO NA FAMÍLIA */
rename v0402 cond_fam
label var cond_fam "1-chef 2-cônj 3-filh 4-outr_parent 5-agreg 6-pens 7-empr_domes 8-parent_empr_dom"
* cond_fam = 1 chefe
*          = 2 cônjuge
*          = 3 filho
*          = 4 outro parente
*          = 5 agregado
*          = 6 pensionista
*          = 7 empregado doméstico
*          = 8 parente do empregado doméstico

/* C.9 RENAME: NÚMERO DA FAMÍLIA */
rename v0403 num_fam

/* C.10 RECODE: COR OU RAÇA */
recode v0404 (9=.)
rename v0404 cor
label var cor "2-branca 4-preta 6-amarela 8-parda 0-indígena"
* cor = 2 branca
*     = 4 preta
*     = 6 amarela
*     = 8 parda
*     = 0 indígena
* A opção "0 indígena" somente apareceu a partir de 92.

drop v0405 v0406 v0407 


/* C.11 VARIÁVEIS DE EDUCAÇÃO */

/* C.11.1 RECODE: ANOS DE ESTUDO */
/* VARIÁVEIS UTILIZADAS */
/* v0602=FREQUENTA ESCOLA OU CRECHE? */
/* v0603=QUAL E O CURSO QUE FREQUENTA? */
/* v0604=ESTE CURSO QUE FREQUENTA E SERIADO? */
/* v0605=QUAL E A SERIE QUE FREQUENTA? */
/* v0606=ANTERIORMENTE FREQUENTOU ESCOLA OU CRECHE? */
/* v0607=QUAL FOI O CURSO MAIS ELEVADO QUE FREQUENTOU ANTERIORMENTE? */
/* v0608=ESTE CURSO QUE FREQUENTOU ANTERIORMENTE ERA SERIADO? */
/* v0609=CONCLUIU,COM APROVACAO,PELO MENOS A PRIMEIRA SERIE DESTE CURSO QUE FREQUENTOU ANTERIORMENTE? */
/* v0610=QUAL FOI A ULTIMA SERIE QUE CONCLUIU,COM APROVACAO,NESTE CURSO QUE FREQUENTOU ANTERIORMENTE? */
/* v0611=CONCLUIU ESTE CURSO QUE FREQUENTOU ANTERIORMENTE? */

* Código do grau ligeiramente diferente em 2001, devido à separação entre pré-escolar e creche:
* 1992 a 99:                        2001:
* v0603                             v0603
* 7 = pré-escolar ou creche         7 = creche
* 8 = pré-vestibular                8 = pré-escolar
* 9 = mestrado/doutorado            9 = pré-vestibular
*                                   10 = mestrado/doutorado
* v0607                             v0607
* 9 = pré-escolar ou creche		9 = creche
*                                   10 = pré-escolar
* Homogeneizando:
recode v0603 (8=7) (9=8) (10=9) if ano == 2001
recode v0607 (10=9) if ano == 2001

/* pessoas que ainda freqüentam escola */
gen educa =0 if v0602==2 & v0603==1 & v0605==1
lab var educa "anos de estudo - compatível c/ anos 1980"
replace educa =1 if v0602==2 & v0603==1 & v0605==2
replace educa =2 if v0602==2 & v0603==1 & v0605==3
replace educa =3 if v0602==2 & v0603==1 & v0605==4
replace educa =4 if v0602==2 & v0603==1 & v0605==5
replace educa =5 if v0602==2 & v0603==1 & v0605==6
replace educa =6 if v0602==2 & v0603==1 & v0605==7
replace educa =7 if v0602==2 & v0603==1 & v0605==8

replace educa =8 if v0602==2 & v0603==2 & v0605==1
replace educa =9 if v0602==2 & v0603==2 & v0605==2
replace educa =10 if v0602==2 & v0603==2 & v0605==3
replace educa =11 if v0602==2 & v0603==2 & v0605==4

replace educa =0 if v0602==2 & v0603==3 & v0604==2 & v0605==1
replace educa =1 if v0602==2 & v0603==3 & v0604==2 & v0605==2
replace educa =2 if v0602==2 & v0603==3 & v0604==2 & v0605==3
replace educa =3 if v0602==2 & v0603==3 & v0604==2 & v0605==4
replace educa =4 if v0602==2 & v0603==3 & v0604==2 & v0605==5
replace educa =5 if v0602==2 & v0603==3 & v0604==2 & v0605==6
replace educa =6 if v0602==2 & v0603==3 & v0604==2 & v0605==7
replace educa =7 if v0602==2 & v0603==3 & v0604==2 & v0605==8

replace educa =0 if v0602==2 & v0603==3 & v0604==4 

replace educa =8 if v0602==2 & v0603==4 & v0604==2 & v0605==1
replace educa =9 if v0602==2 & v0603==4 & v0604==2 & v0605==2
replace educa =10 if v0602==2 & v0603==4 & v0604==2 & v0605==3
replace educa =11 if v0602==2 & v0603==4 & v0604==2 & v0605==4

replace educa =8 if v0602==2 & v0603==4 & v0604==4 

replace educa =11 if v0602==2 & v0603==5 & v0605==1
replace educa =12 if v0602==2 & v0603==5 & v0605==2
replace educa =13 if v0602==2 & v0603==5 & v0605==3
replace educa =14 if v0602==2 & v0603==5 & v0605==4
replace educa =15 if v0602==2 & v0603==5 & v0605==5
replace educa =16 if v0602==2 & v0603==5 & v0605==6

replace educa =0 if v0602==2 & v0603==6
replace educa =0 if v0602==2 & v0603==7
replace educa =11 if v0602==2 & v0603==8
replace educa =15 if v0602==2 & v0603==9

/* pessoas que não freqüentam */

replace educa =1 if v0602==4 & v0606==2 & v0607==1 & v0609==1 & v0610==1
replace educa =2 if v0602==4 & v0606==2 & v0607==1 & v0609==1 & v0610==2
replace educa =3 if v0602==4 & v0606==2 & v0607==1 & v0609==1 & v0610==3
replace educa =4 if v0602==4 & v0606==2 & v0607==1 & v0609==1 & v0610==4
replace educa =4 if v0602==4 & v0606==2 & v0607==1 & v0609==1 & v0610==5
replace educa =4 if v0602==4 & v0606==2 & v0607==1 & v0609==1 & v0610==6

replace educa =0 if v0602==4 & v0606==2 & v0607==1 & v0609==3

replace educa =5 if v0602==4 & v0606==2 & v0607==2 & v0608==2 & v0609==1 & v0610==1
replace educa =6 if v0602==4 & v0606==2 & v0607==2 & v0608==2 & v0609==1 & v0610==2
replace educa =7 if v0602==4 & v0606==2 & v0607==2 & v0608==2 & v0609==1 & v0610==3
replace educa =8 if v0602==4 & v0606==2 & v0607==2 & v0608==2 & v0609==1 & v0610==4
replace educa =8 if v0602==4 & v0606==2 & v0607==2 & v0608==2 & v0609==1 & v0610==5

replace educa =4 if v0602==4 & v0606==2 & v0607==2 & v0608==2 & v0609==3

replace educa =8 if v0602==4 & v0606==2 & v0607==2 & v0608==4 & v0611==1
replace educa =4 if v0602==4 & v0606==2 & v0607==2 & v0608==4 & v0611==3

replace educa =9 if v0602==4 & v0606==2 & v0607==3 & v0608==2 & v0609==1 & v0610==1
replace educa =10 if v0602==4 & v0606==2 & v0607==3 & v0608==2 & v0609==1 & v0610==2
replace educa =11 if v0602==4 & v0606==2 & v0607==3 & v0608==2 & v0609==1 & v0610==3
replace educa =11 if v0602==4 & v0606==2 & v0607==3 & v0608==2 & v0609==1 & v0610==4

replace educa =8 if v0602==4 & v0606==2 & v0607==3 & v0608==2 & v0609==3

replace educa =11 if v0602==4 & v0606==2 & v0607==3 & v0608==4 & v0611==1
replace educa =8 if v0602==4 & v0606==2 & v0607==3 & v0608==4 & v0611==3

replace educa =1 if v0602==4 & v0606==2 & v0607==4 & v0608==2 & v0609==1 & v0610==1
replace educa =2 if v0602==4 & v0606==2 & v0607==4 & v0608==2 & v0609==1 & v0610==2
replace educa =3 if v0602==4 & v0606==2 & v0607==4 & v0608==2 & v0609==1 & v0610==3
replace educa =4 if v0602==4 & v0606==2 & v0607==4 & v0608==2 & v0609==1 & v0610==4
replace educa =5 if v0602==4 & v0606==2 & v0607==4 & v0608==2 & v0609==1 & v0610==5
replace educa =6 if v0602==4 & v0606==2 & v0607==4 & v0608==2 & v0609==1 & v0610==6
replace educa =7 if v0602==4 & v0606==2 & v0607==4 & v0608==2 & v0609==1 & v0610==7
replace educa =8 if v0602==4 & v0606==2 & v0607==4 & v0608==2 & v0609==1 & v0610==8

replace educa =0 if v0602==4 & v0606==2 & v0607==4 & v0608==2 & v0609==3

replace educa =8 if v0602==4 & v0606==2 & v0607==4 & v0608==4 & v0611==1
replace educa =0 if v0602==4 & v0606==2 & v0607==4 & v0608==4 & v0611==3

replace educa =9 if v0602==4 & v0606==2 & v0607==5 & v0608==2 & v0609==1 & v0610==1
replace educa =10 if v0602==4 & v0606==2 & v0607==5 & v0608==2 & v0609==1 & v0610==2
replace educa =11 if v0602==4 & v0606==2 & v0607==5 & v0608==2 & v0609==1 & v0610==3
replace educa =11 if v0602==4 & v0606==2 & v0607==5 & v0608==2 & v0609==1 & v0610==4

replace educa =8 if v0602==4 & v0606==2 & v0607==5 & v0608==2 & v0609==3

replace educa =11 if v0602==4 & v0606==2 & v0607==5 & v0608==4 & v0611==1
replace educa =8 if v0602==4 & v0606==2 & v0607==5 & v0608==4 & v0611==3

replace educa =12 if v0602==4 & v0606==2 & v0607==6 & v0609==1 & v0610==1
replace educa =13 if v0602==4 & v0606==2 & v0607==6 & v0609==1 & v0610==2
replace educa =14 if v0602==4 & v0606==2 & v0607==6 & v0609==1 & v0610==3

replace educa =15 if v0602==4 & v0606==2 & v0607==6 & v0609==1 & v0610==4
replace educa =16 if v0602==4 & v0606==2 & v0607==6 & v0609==1 & v0610==5
replace educa =17 if v0602==4 & v0606==2 & v0607==6 & v0609==1 & v0610==6

replace educa =11 if v0602==4 & v0606==2 & v0607==6 & v0609==3

replace educa =17 if v0602==4 & v0606==2 & v0607==7 & v0611==1
replace educa =15 if v0602==4 & v0606==2 & v0607==7 & v0611==3

replace educa =0 if v0602==4 & v0606==2 & v0607==8
replace educa =0 if v0602==4 & v0606==2 & v0607==9

replace educa =0 if v0602==4 & v0606==4


/* C.11.2 RECODE: FREQUENTA ESCOLA */
recode v0602 (2=1) (4=0) (9=.)
rename v0602 freq_escola
label var freq_escola "0-não freq 1-frequenta"
* freq_escola = 1 se frequenta escola
*             = 0 caso contrário
* Desde 92, a pergunta inclui se frequenta creche.

/* C.11.3 DUMMY: LER E ESCREVER */
recode v0601 (3=0) (9=.)
rename v0601 ler_escrever
* ler_escrever = 1 sim
*              = 0 não

/* C.11.4 RECODE: SÉRIE QUE FREQÜENTA NA ESCOLA */
recode v0605 (9=.)
rename v0605 serie_freq
label var serie_freq "série - frequenta escola"

/* C.11.5 RECODE: GRAU QUE FREQÜENTA NA ESCOLA */
recode v0603 (0=.)
rename v0603 grau_freq
label var grau_freq "grau - frequenta escola"
* grau_freq = 1 regular primeiro grau
*           = 2 regular segundo grau
*           = 3 supl primeiro grau
*           = 4 supl segundo grau
*           = 5 superior
*           = 6 alfab de adultos
*           = 7 pré-escolar ou creche
*           = 8 pré-vestibular
*           = 9 mestrado/doutorado

/* C.11.6 RECODE: SÉRIE - NÃO FREQUENTA ESCOLA */
recode v0610 (9=.)
rename v0610 serie_nao_freq
label var serie_nao_freq "série - não frequenta escola"
* Observação: no primário - v0607==1 - podem existir até 6 séries, e não apenas 4.
*             no médio, primeiro ciclo - v0607==2 - até 5 séries, não apenas 4.
*             no médio, segundo ciclo - v0607==3 - 4 séries, não apenas 3.
*             no segundo grau - v0607==5 - 4 séries, não apenas 3.

/* C.11.7 RECODE: GRAU NÃO FREQÜENTA NA ESCOLA */
recode v0607 (0=.) 
rename v0607 grau_nao_freq
label var grau_nao_freq "grau - não frequenta"
* grau_nao_freq = 1 elementar (primário)
*               = 2 médio primeiro ciclo (ginasial)
*               = 3 médio segundo ciclo (científico, clássico etc.)
*               = 4 primeiro grau
*               = 5 segundo grau
*               = 6 superior
*               = 7 mestrado/doutorado
*               = 8 alfab de adultos
*               = 9 pré-escolar ou creche
* Os códigos 8 e 9 só existem a partir de 1992.

drop v0604 v0606 v0608 v0609 v0611


/* C.12 CARACTERÍSTICAS DO TRABALHO PRINCIPAL NA SEMANA */

/* C.12.0 DUMMY: TRABALHOU NA SEMANA */
/* A partir de 1992, pergunta-se sobre trabalho na produção para o próprio 
consumo e trabalho na construção para o próprio uso. Por isso, a variável a 
seguir não é perfeitamente compatível com a dos anos 1980 */
recode v9001 (0=.) (3=0), copy g(trabalhou_semana)
label var trabalhou_semana "trabalhou na semana?"
* trabalhou_semana = 1 sim
*               	= 0 não

/* C.12.1 DUMMY: tinha TRABALHO NA SEMANA */
* tinha trabalho na semana, mas estava afastado temporariamente (estava de férias etc.)
g tinha_trab_sem = 0 if trabalhou_semana==0
replace tinha_trab_sem = 1 if v9004 == 2 & ano<=1999
replace tinha_trab_sem = 1 if v9002 == 2 & ano==2001
label var tinha_trab_sem "tinha trabalho na semana?"
* tinha_trab_sem = 1 sim
*                = 0 não
drop v9001 v9004

/* C.12.2 RENAME: OCUPAÇÃO NA SEMANA */
rename v9906 ocup_sem
label var ocup_sem "ocupação na semana"

generate grupos_ocup_sem =.
if `min' <= 1999 {
	recode v4710 (0=.)
	replace grupos_ocup_sem = v4710 if ano <= 1999
	drop v4710
}

if `max' == 2001 {
	recode v4760 (0=.)
	replace grupos_ocup_sem = v4760 if ano == 2001
	drop v4760
}

* grupos_ocup_sem = 1 técnica, científica, artística e assemelhada
*             = 2 administrativa
*             = 3 agrop. e prod. extrat. vegetal e animal
*             = 4 ind. de transf.
*             = 5 comércio e ativ. auxiliares
*             = 6 transp. e comunicação
*             = 7 prestação de serviços
*             = 8 outras ou não declaradas
/* C.12.3 RENAME: ATIVIDADE/RAMOS DO NEGÓCIO */
* v9907 é mais desagregado - códigos variam ao longo do tempo
* v4709 (e v4759) é mais agregado e comum entre os anos das PNAD's

rename v9907 ramo_negocio_sem
label var ramo_negocio_sem "ativ/ramo do negócio na semana"

generate ramo_negocio_agreg =.
quietly summarize ano
loc min = r(min)
loc max = r(max)

if `min' <= 1999 {
	recode v4709 (0=.)
	replace ramo_negocio_agreg = v4709 if ano <= 1999
	drop v4709
}

if `max' == 2001 {
	recode v4759 (0=.)
	replace ramo_negocio_agreg = v4759 if ano == 2001
	drop v4759
}

label var ramo_negocio_agreg "ativ/ramo do negócio na semana - agregado"
* ramo_negocio_agreg = 1 agrícola
*                    = 2 ind. transf.
*                    = 3 ind. constr.
*                    = 4 out. ativ. industr.
*                    = 5 comércio mercadorias
*                    = 6 prestação de serviços
*                    = 7 serv. aux. ativ. econom.
*                    = 8 transporte e comunicação
*                    = 9 social
*                    = 10 administr. pública
*                    = 11 outras atividades ou não declarada


/* C.12.4 RECODE: POSIÇÃO NA OCUPAÇÃO NA SEMANA */
* v9008 e v9029 são mais detalhados, mas de difícil compatibilização com as PNAD's dos anos 80
* foram dropadas	
drop v9008 v9029
* v4706 é mais agregado, e é mais fácil compatibilizar com as PNAD's dos anos 80

generate pos_ocup_sem =.
if `min' <= 1999 {
	recode v4706 (0 14=.) (2/8=1) (9=2) (10=3) (11 12=.) (13=4)
	replace pos_ocup_sem = v4706 if ano <= 1999
	drop v4706
}

if `max' == 2001 {
	recode v4756 (0 14=.) (2/8=1) (9=2) (10=3) (11 12=.) (13=4)
	replace pos_ocup_sem = v4756 if ano == 2001
	drop v4756
}

label var pos_ocup_sem "posição na ocupação na semana"
* Trabalhadores na prod/constr para consumo/uso próprio foram excluídos
* da categoria "empregados" pois não eram considerados assim nas PNAD's dos aos 80.
* Se elas não forem eliminadas, haveria uma redução no número de observações
* missing.
* pos_ocup_sem = 1 empregado 
*              = 2 conta própria
*              = 3 empregador
*              = 4 não remunerado

/* C.12.5 RECODE: TEM CARTEIRA ASSINADA */
recode v9042 (2=1) (4=0) (9=.)
rename v9042 tem_carteira_assinada
label var tem_carteira_assinada "0-não 1-sim"
* tem_carteira_assinada = 0 não
*                       = 1 sim

/* C.12.6 HORAS TRABALHADAS */

/* HORAS NORMALMENTE TRABALHADAS SEMANA */
recode v9058 (-1 99 0=.)
replace v9058 = . if tinha_trab_sem == 0 & trabalhou_sem==0
rename v9058 horas_trab_sem
label var horas_trab_sem " horas normal. trab. sem - ocup. princ" 

/* HORAS NORMALMENTE TRABALHADAS - OUTRO TRABALHO */
recode v9101 (-1 99 0=.)
replace v9101 = . if tinha_trab_sem == 0 & trabalhou_sem==0
rename v9101 horas_trab_sem_outro
label var horas_trab_sem_outro "horas normal. sem. outro"

/* C.14.10 RENAME: HORAS NORMALMENTE TRABALHADAS TODOS TRABALHOS */
recode v9105 (-1 99=.)
egen horas_trab_todos_trab = rowtotal(horas_trab_sem horas_trab_sem_outro v9105), miss
replace horas_trab_todos_trab = . if tinha_trab_sem == 0 & trabalhou_sem==0
label var horas_trab_todos_trab "horas todos trab"

drop v9105

/* C.13 RENDIMENTOS */

/* C.13.1 RECODE: RENDA MENSAL EM DINHEIRO - TRABALHO PRINCIPAL */
recode v9532 (-1 999999999999=.)
rename v9532 renda_mensal_din 
label var renda_mensal_din "renda mensal dinheiro"

/* C.13.2 RECODE: RENDA MENSAL EM PRODUTOS/MERCADORIAS - TRABALHO PRINCIPAL */
recode v9535 (-1 999999999999=.)
rename v9535 renda_mensal_prod 
label var renda_mensal_prod "renda mensal prod/merc"

/* C.13.3 RECODE: RENDA MENSAL EM DINHEIRO - OUTROS TRABALHOS (SECUNDARIO E DEMAIS TRABALHOS) */
* SOMANDO: 
	* VALOR REND MENSAL EM DIN NO TRAB SECUNDÁRIO
	* VALOR REND MENSAL EM DIN EXCETO PRINC E SECUND
recode v9982 (-1 999999999999=.)
recode v1022 (-1 999999999999=.)
tempvar miss
egen `miss' = rowmiss(v9982 v1022)
egen double renda_mensal_din_outra = rowtotal(v9982 v1022)
replace  renda_mensal_din_outra  = . if `miss'==2
format renda_mensal_din_outra %12.0f
label var renda_mensal_din_outra "renda mensal em dinheiro em outros trabalhos"

/* C.13.4 RECODE: RENDA MENSAL EM PRODUTOS/MERCADORIAS OUTRA */
* SOMANDO:
	* VALOR REND MENSAL EM PROD NO TRAB SECUND
	* VALOR REND MENSAL EM PROD EXCETO PRINC E SECUND
recode v9985 (-1 999999999999=.)
recode v1025 (-1 999999999999=.)
tempvar miss
egen `miss' = rowmiss(v9985 v1025)
egen double renda_mensal_prod_outra = rowtotal(v9985 v1025)
replace  renda_mensal_prod_outra  = . if `miss'==2
format renda_mensal_prod_outra %12.0f
label var renda_mensal_prod_outra "renda mensal em produtos em outros trabalhos"

/* C.13.5 RECODE: VALOR APOSENTADORIA */
* SOMANDO:
	* VALOR APOSENT DE INST PREV OU DO GOVERNO NO MES
	* REND DE OUTRO TIPO DE APOSENT NO MÊS
recode v1252 (-1 999999999999=.)
recode v1258 (-1 999999999999=.)
gen renda_aposentadoria = v1252+v1258 if v1252 ~= . & v1258 ~= .
replace renda_aposentadoria = v1252 if v1252 ~= . & v1258 == .
replace renda_aposentadoria = v1258 if v1252 == . & v1258 ~= .
label var renda_aposentadoria "rendimento de aposentadoria"

/* C.13.6 RECODE: VALOR PENSÃO */
* SOMANDO:
	* VALOR PENSÃO DE INST PREV OU DO GOVERNO NO MES
	* REND DE OUTRO TIPO DE PENSÃO NO MÊS
recode v1255 (-1 999999999999=.)
recode v1261 (-1 999999999999=.)
gen renda_pensao = v1255+v1261 if v1255 ~= . & v1261 ~= .
replace renda_pensao = v1255 if v1255 ~= . & v1261 == .
replace renda_pensao = v1261 if v1255 == . & v1261 ~= .
label var renda_pensao "rendimento de pensão"

/* C.13.7 RECODE: VALOR ABONO PERMANENTE */
recode v1264 (-1 999999999999=.) 
rename v1264 renda_abono
label var renda_abono "rendimento de abono permanente"

/* C.13.8 RECODE: VALOR ALUGUEL RECEBIDO */
recode v1267 (-1 999999999999=.) 
rename v1267 renda_aluguel
label var renda_aluguel "rendimento de aluguel"

/* C.13.9 RECODE: VALOR OUTRAS */
* SOMANDO:
	* REND DE DOAÇÃO RECEBIDA DE NÃO MORADOR
	* REND DE JUROS E DIVIDENDOS E OUTROS REND
recode v1270 (-1 999999999999=.)
recode v1273 (-1 999999999999=.)
gen renda_outras = v1270+v1273 if v1270 ~= . & v1273 ~= .
replace renda_outras = v1270 if v1270 ~= . & v1273 == .
replace renda_outras = v1273 if v1270 == . & v1273 ~= .
label var renda_outras "rendimento de outras fontes"

/* C.13.10 RECODE: REND MENSAL OCUP PRINCIPAL */
generate double renda_mensal_ocup_prin =.
if `min' <= 1999 {
	recode v4718 (-1 999999999999=.)
	replace renda_mensal_ocup_prin = v4718 if ano <= 1999
	drop v4718
}

if `max' == 2001 {
	recode v4768 (-1 999999999999=.)
	replace renda_mensal_ocup_prin = v4768 if ano ==2001
	drop v4768
}

recode renda_mensal_ocup_prin (0=.) if renda_mensal_din == . & renda_mensal_prod == .
lab var renda_mensal_ocup_prin "renda mensal no trabalho principal"

/* C.13.11 RECODE: REND MENSAL TODOS TRABALHOS */
generate double renda_mensal_todos_trab =.
if `min' <= 1999 {
	recode v4719 (-1 999999999999=.)
	replace renda_mensal_todos_trab = v4719 if ano <= 1999
	drop v4719
}

if `max' == 2001 {
	recode v4769 (-1 999999999999=.)
	replace renda_mensal_todos_trab = v4769 if ano ==2001
	drop v4769
}

recode renda_mensal_todos_trab (0=.) if renda_mensal_din == . & renda_mensal_prod == . ///
& renda_mensal_din_outra == . & renda_mensal_prod_outra == . ///
& v1022 ==. & v1025 == .
lab var renda_mensal_todos_trab "renda mensal em todos os trabalhos"

/* C.13.12 RECODE: REND MENSAL TODAS FONTES */
generate double renda_mensal_todas_fontes =.
if `min' <= 1999 {
	recode v4720 (-1 999999999999=.)
	replace renda_mensal_todas_fontes = v4720 if ano <= 1999
	drop v4720
}

if `max' == 2001 {
	recode v4770 (-1 999999999999=.)
	replace renda_mensal_todas_fontes = v4770 if ano ==2001
	drop v4770
}

recode renda_mensal_todas_fontes (0=.) if renda_mensal_din == . ///
	& renda_mensal_prod == . & renda_aposentadoria == . ///
	& renda_pensao == . & renda_outras == . & renda_abono == . ///
	& renda_aluguel == . 
lab var renda_mensal_todas_fontes "renda mensal de todas as fontes" 
	
drop v1022 v1025 v1252 v1255 v1258 v1261 v1270 v1273

/* C.14.1 RECODE: CONTRIBUI INST. PREVID. */
* Apenas para quem tinha trabalho na semana
recode v9059 (3=0) (0 9=.)
replace v9059 = . if tinha_trab_sem == 0 & trabalhou_sem==0
rename v9059 contr_inst_prev
label var contr_inst_prev "contribui p/ instituto de previdência"

/* C.14.2 RENAME: QUAL INST. PREVID. */
recode v9060 (0 9=.)
replace v9060 = . if tinha_trab_sem == 0 & trabalhou_sem==0
rename v9060 qual_inst_prev
* qual_inst_prev = 2 federal
*                = 4 estadual
*                = 6 municipal

/* C.15 RECODE: TINHA OUTRO TRABALHO? */
* Apenas para quem tinha trabalho na semana de referência
recode v9005 (1=0) (3 5=1)
replace v9005 = . if tinha_trab_sem == 0 & trabalhou==0
rename v9005 tinha_outro_trab
label var tinha_outro_trab "tinha outro trabalho/sem?"

/* C.16 PESSOAS QUE NÃO TINHAM TRABALHO NA SEMANA DE REFERÊNCIA */
/*	  MAS TIVERAM OCUPAÇÃO NO PERÍODO DE 12 MESES             */
* A partir da PNAD de 1992, a questão sobre ocupação anterior passa a
* cobrir tanto as pessoas que não tinham trabalho na semana de referência
* quanto aquelas cujo trab na semana de ref não era o principal no período
* de 365 dias.

/* RECODE: TEMPO SEM TRABALHO */
* Esta informação não pode mais ser aferida com precisão a partir dos anos 90.

/* RECODE: TEMPO NA OCUPAÇÃO ANTERIOR */
* A partir de 1992, esta informação não pode ser obtida para todos os indivíduos.

/* INFORMAÇÕES SOBRE O EMPREGO ANTERIOR */
* COMO NOS ANOS 80 É SIMPLESMENTE O ÚLTIMO TRABALHO
* (DE QUEM NÃO TRABALHOU NA SEMANA DE REFEÊNCIA) 
* AS INFORMAÇÕES SOBRE O TRABALHO ANTERIOR
* DOS ANOS 80 E 90 NÃO SÃO PERFEITAMENTE COMPATÍVEIS.

/* DUMMY: NÃO TRABALHOU NA SEMANA E DEIXOU ÚLTIMO EMPREGO NO ÚLTIMO ANO - 12 MESES OU MENOS */
/*		VARIÁVEL TEMPORÁRIA                                                           */
recode v9067 (3=0) (0 9=.)
rename v9067 teve_algum_trab_ano
label var teve_algum_trab_ano "teve algum trab no ano"
                                                           
gen tag = 1 if tinha_trab_sem == 0 & teve_algum_trab_ano == 1 

/* C.16.1 GEN: OCUPAÇÃO ANTERIOR, NO ANO */
gen ocup_ant_ano = v9971 if tag == 1
label var ocup_ant_ano "ocupação anterior - no ano"
drop v9971

/* C.16.2 GEN: RAMO ANTERIOR, NO ANO */
gen ramo_negocio_ant_ano = v9972 if tag == 1
label var ramo_negocio_ant_ano "ativ/ramo do negócio anterior - no ano"
drop v9972

/* C.16.3 RECODE: TINHA CARTEIRA ASSINADA NA OCUPAÇÃO ANTERIOR, NO ANO */
gen tinha_cart_assin_ant_ano = v9083 if tag == 1
recode tinha_cart_assin_ant_ano (3=0) (9=.) 
label var tinha_cart_assin_ant_ano "últ emprego - no ano - cart assin"
drop tag v9083

/* C.18.3.6 RECODE: RECEBEU FGTS OCUPAÇÃO ANTERIOR, NO ANO */
* ESSA PERGUNTA NÃO CONSTA DAS PNAD'S DOS ANOS 90

/* C.17 RECODE: TOMOU PROV. PARA CONSEGUIR TRABALHO */
/* NA SEMANA DE REFERÊNCIA: APENAS QUEM NÃO TINHA TRABALHO NA SEMANA */
replace v9115 = . if tinha_trab_sem == 1
recode v9115 (3=0) (9=.)
rename v9115 tomou_prov_semana
* tomou_prov_na_sem = 1 sim
*                   = 0 não

/* C.18 RECODE: TOMOU PROV. PARA CONSEGUIR TRABALHO 2 MESES */
/* APENAS QUEM NÃO TINHA TRABALHO NA SEMANA */
replace v9116 = . if tinha_trab_sem == 1
replace v9117 = . if tinha_trab_sem == 1
recode v9116 (2=1) (4=0) (9=.)
recode v9117 (3=0) (9=.)
gen tomou_prov_2meses = 1 if v9116 == 1 | v9117 == 1
replace tomou_prov_2meses = 0 if v9116 == 0 & v9117 == 0
label var tomou_prov_2meses "tomou providência p/ conseguir trab nos últimos 2 meses"
* tomou_prov_2meses = 1 sim
*                   = 0 não
drop v9116 v9117

/* C.19 RECODE: QUE PROV. TOMOU PARA CONSEGUIR TRABALHO */
* Nas PNAD's dos anos 80, a pergunta é feita apenas para quem respondeu "sim"
* à pergunta anterior (tomou prov. cons. trab - 2 meses)
* Nas PNAD's dos anos 90, a pergunta é sobre a última prov. que tomou, e se aplica a todos os indivíduos.
* Isto é ajustado a seguir.
gen que_prov_tomou = v9119 if trabalhou_semana==0 & tinha_trab_sem==0
recode que_prov_tomou (0=7) (3=2) (7 8=6) (4=3) (5=4) (6=5) (9=.)
label var que_prov_tomou "que providência tomou para conseguir trabalho"
* que_prov_tomou = 1 consultou empregador
*                                 = 2 fez concurso
*                                 = 3 consultou agência/sindicato
*                                 = 4 colocou anúncio
*                                 = 5 consultou parente
*                                 = 6 outra
*                                 = 7 nada fez

drop v9002 v9003 v9119 teve_algum_trab_ano

/* Para 2001, variáveis de trabalho referem-se também a trabalho infantil 5-9 anos */
foreach var of varlist tinha_outro_trab ocup_sem ramo_negocio_sem tem_carteira_assinada ///
	renda_mensal_din renda_mensal_prod horas_trab_sem contr_inst_prev qual_inst_prev ///
	horas_trab_sem_outro tomou_prov_semana renda_abono renda_aluguel trabalhou_semana ///
	tinha_trab_sem grupos_ocup_sem ramo_negocio_agreg pos_ocup_sem horas_trab_todos_trab ///
	renda_mensal_din_outra renda_mensal_prod_outra renda_aposentadoria renda_pensao ///
	renda_outras renda_mensal_ocup_prin renda_mensal_todos_trab renda_mensal_todas_fontes ///
	ocup_ant_ano ramo_negocio_ant_ano tinha_cart_assin_ant_ano tomou_prov_2meses que_prov_tomou {
	
	replace `var' = . if idade<10
}

/* D. DEFLACIONANDO E CONVERTENDO UNIDADES MONETÁRIAS PARA REAIS */

/* CONVERTENDO OS VALORES NOMINAIS PARA REAIS (UNIDADE MONETÁRIA) */
/* 	E DEFLACIONANDO: 1 = out/2012                                 */

gen double deflator = 0.488438 if ano == 2001
format deflator %26.25f
replace deflator    = 0.425376 if ano == 1999
replace deflator    = 0.399657 if ano == 1998
replace deflator    = 0.387748 if ano == 1997
replace deflator    = 0.371635 if ano == 1996
replace deflator    = 0.330617 if ano == 1995
replace deflator    = 0.103168/10 if ano == 1993
replace deflator    = 0.498848/1000 if ano == 1992

label var deflator "deflator - base:out/2012"  

gen double conversor = 1             if ano >= 1995
replace conversor    = 2750          if ano == 1993
replace conversor    = 2750000       if ano == 1992

label var conversor "conversor de moedas"

foreach i in din_outra prod_outra ocup_prin todos_trab todas_fontes din prod {
	g renda_`i'_def = (renda_mensal_`i'/conversor)/deflator 
	lab var renda_`i'_def "renda_mensal_`i' deflacionada"
}

foreach i in aposentadoria pensao abono aluguel outras {
	g renda_`i'_def = (renda_`i'/conversor)/deflator
	lab var renda_`i'_def "renda_`i' deflacionada"
}

order ano uf id_dom ordem 

cap drop v1091 v1092 
cap drop v7101 v7102 

drop v*

compress

end

************************************************************
**************compat_pess_1992a2001_para_92.ado*************
************************************************************
program define compat_pes_1992a2001_para_92

/* A.1 RECODE: ANO */
recode v0101 (92=1992) (93=1993) (95=1995) (96=1996) (97=1997) (98=1998) (99=1999)

* VERIFICANDO SE ANOS 1996, 1997 E 2001 FORAM SELECIONADOS
tempvar t
g `t' = v0101==1996 | v0101==1997 | v0101==2001
qui sum `t'
loc max = r(max)

/* A.2 N�MERO DE CONTROLE E S�RIE */
drop v0102 v0103
destring uf, replace


/* B. DATA DE NASCIMENTO */
recode v3031 (0 = .)
recode v3031 v3032 (99 =.)
recode v3032 (20 = .)
recode v3033 (min/98 9999 = .)
replace v3033 = v3033 + 1000 if v3033>99 & v3033<9999 & v0101<=1999


/* B.2 CARACTERISTICAS DE MIGRACAO */
recode v5030 v5080 v5090 (99 =.)
recode v0501 v0502 v0504 v0505 ///
	v5062 v0507 v0510 v0511 v5122 (9 = .)
recode v5062 v5122 (8 = .)
recode v5064 v5124 (0 = .)
cap drop v0503 v0508 v0509

/* C. VARI�VEIS DE EDUCA��O */
recode v0601 v0602 v0611 (0 9 = .)

/* C.1 RECODE: ANOS DE ESTUDO */
/* VARI�VEIS UTILIZADAS */
/* v0602=FREQUENTA ESCOLA OU CRECHE? */
/* v0603=QUAL E O CURSO QUE FREQUENTA? */
/* v0604=ESTE CURSO QUE FREQUENTA E SERIADO? */
/* v0605=QUAL E A SERIE QUE FREQUENTA? */
/* v0606=ANTERIORMENTE FREQUENTOU ESCOLA OU CRECHE? */
/* v0607=QUAL FOI O CURSO MAIS ELEVADO QUE FREQUENTOU ANTERIORMENTE? */
/* v0608=ESTE CURSO QUE FREQUENTOU ANTERIORMENTE ERA SERIADO? */
/* v0609=CONCLUIU,COM APROVACAO,PELO MENOS A PRIMEIRA SERIE DESTE CURSO QUE FREQUENTOU ANTERIORMENTE? */
/* v0610=QUAL FOI A ULTIMA SERIE QUE CONCLUIU,COM APROVACAO,NESTE CURSO QUE FREQUENTOU ANTERIORMENTE? */
/* v0611=CONCLUIU ESTE CURSO QUE FREQUENTOU ANTERIORMENTE? */

* C�digo do grau ligeiramente diferente em 2001, devido � separa��o entre pr�-escolar e creche:
* 1992 a 99:                        2001:
* v0603                             v0603
* 7 = pr�-escolar ou creche         7 = creche
* 8 = pr�-vestibular                8 = pr�-escolar
* 9 = mestrado/doutorado            9 = pr�-vestibular
*                                   10 = mestrado/doutorado
* v0607                             v0607
* 9 = pr�-escolar ou creche		9 = creche
*                                   10 = pr�-escolar
* Homogeneizando:
recode v0603 (8=7) (9=8) (10=9) if v0101 == 2001
recode v0607 (10=9) if v0101 == 2001

/* pessoas que ainda freq�entam escola */
gen anoest =0 if v0602==2 & v0603==1 & v0605==1
replace anoest =1 if v0602==2 & v0603==1 & v0605==2
replace anoest =2 if v0602==2 & v0603==1 & v0605==3
replace anoest =3 if v0602==2 & v0603==1 & v0605==4
replace anoest =4 if v0602==2 & v0603==1 & v0605==5
replace anoest =5 if v0602==2 & v0603==1 & v0605==6
replace anoest =6 if v0602==2 & v0603==1 & v0605==7
replace anoest =7 if v0602==2 & v0603==1 & v0605==8

replace anoest =8 if v0602==2 & v0603==2 & v0605==1
replace anoest =9 if v0602==2 & v0603==2 & v0605==2
replace anoest =10 if v0602==2 & v0603==2 & v0605==3
replace anoest =11 if v0602==2 & v0603==2 & v0605==4

replace anoest =0 if v0602==2 & v0603==3 & v0604==2 & v0605==1
replace anoest =1 if v0602==2 & v0603==3 & v0604==2 & v0605==2
replace anoest =2 if v0602==2 & v0603==3 & v0604==2 & v0605==3
replace anoest =3 if v0602==2 & v0603==3 & v0604==2 & v0605==4
replace anoest =4 if v0602==2 & v0603==3 & v0604==2 & v0605==5
replace anoest =5 if v0602==2 & v0603==3 & v0604==2 & v0605==6
replace anoest =6 if v0602==2 & v0603==3 & v0604==2 & v0605==7
replace anoest =7 if v0602==2 & v0603==3 & v0604==2 & v0605==8

replace anoest =0 if v0602==2 & v0603==3 & v0604==4 

replace anoest =8 if v0602==2 & v0603==4 & v0604==2 & v0605==1
replace anoest =9 if v0602==2 & v0603==4 & v0604==2 & v0605==2
replace anoest =10 if v0602==2 & v0603==4 & v0604==2 & v0605==3
replace anoest =11 if v0602==2 & v0603==4 & v0604==2 & v0605==4

replace anoest =8 if v0602==2 & v0603==4 & v0604==4 

replace anoest =11 if v0602==2 & v0603==5 & v0605==1
replace anoest =12 if v0602==2 & v0603==5 & v0605==2
replace anoest =13 if v0602==2 & v0603==5 & v0605==3
replace anoest =14 if v0602==2 & v0603==5 & v0605==4
replace anoest =15 if v0602==2 & v0603==5 & v0605==5
replace anoest =16 if v0602==2 & v0603==5 & v0605==6

replace anoest =0 if v0602==2 & v0603==6
replace anoest =0 if v0602==2 & v0603==7
replace anoest =11 if v0602==2 & v0603==8
replace anoest =15 if v0602==2 & v0603==9

/* pessoas que n�o freq�entam */

replace anoest =1 if v0602==4 & v0606==2 & v0607==1 & v0609==1 & v0610==1
replace anoest =2 if v0602==4 & v0606==2 & v0607==1 & v0609==1 & v0610==2
replace anoest =3 if v0602==4 & v0606==2 & v0607==1 & v0609==1 & v0610==3
replace anoest =4 if v0602==4 & v0606==2 & v0607==1 & v0609==1 & v0610==4
replace anoest =4 if v0602==4 & v0606==2 & v0607==1 & v0609==1 & v0610==5
replace anoest =4 if v0602==4 & v0606==2 & v0607==1 & v0609==1 & v0610==6

replace anoest =0 if v0602==4 & v0606==2 & v0607==1 & v0609==3

replace anoest =5 if v0602==4 & v0606==2 & v0607==2 & v0608==2 & v0609==1 & v0610==1
replace anoest =6 if v0602==4 & v0606==2 & v0607==2 & v0608==2 & v0609==1 & v0610==2
replace anoest =7 if v0602==4 & v0606==2 & v0607==2 & v0608==2 & v0609==1 & v0610==3
replace anoest =8 if v0602==4 & v0606==2 & v0607==2 & v0608==2 & v0609==1 & v0610==4
replace anoest =8 if v0602==4 & v0606==2 & v0607==2 & v0608==2 & v0609==1 & v0610==5

replace anoest =4 if v0602==4 & v0606==2 & v0607==2 & v0608==2 & v0609==3

replace anoest =8 if v0602==4 & v0606==2 & v0607==2 & v0608==4 & v0611==1
replace anoest =4 if v0602==4 & v0606==2 & v0607==2 & v0608==4 & v0611==3

replace anoest =9 if v0602==4 & v0606==2 & v0607==3 & v0608==2 & v0609==1 & v0610==1
replace anoest =10 if v0602==4 & v0606==2 & v0607==3 & v0608==2 & v0609==1 & v0610==2
replace anoest =11 if v0602==4 & v0606==2 & v0607==3 & v0608==2 & v0609==1 & v0610==3
replace anoest =11 if v0602==4 & v0606==2 & v0607==3 & v0608==2 & v0609==1 & v0610==4

replace anoest =8 if v0602==4 & v0606==2 & v0607==3 & v0608==2 & v0609==3

replace anoest =11 if v0602==4 & v0606==2 & v0607==3 & v0608==4 & v0611==1
replace anoest =8 if v0602==4 & v0606==2 & v0607==3 & v0608==4 & v0611==3

replace anoest =1 if v0602==4 & v0606==2 & v0607==4 & v0608==2 & v0609==1 & v0610==1
replace anoest =2 if v0602==4 & v0606==2 & v0607==4 & v0608==2 & v0609==1 & v0610==2
replace anoest =3 if v0602==4 & v0606==2 & v0607==4 & v0608==2 & v0609==1 & v0610==3
replace anoest =4 if v0602==4 & v0606==2 & v0607==4 & v0608==2 & v0609==1 & v0610==4
replace anoest =5 if v0602==4 & v0606==2 & v0607==4 & v0608==2 & v0609==1 & v0610==5
replace anoest =6 if v0602==4 & v0606==2 & v0607==4 & v0608==2 & v0609==1 & v0610==6
replace anoest =7 if v0602==4 & v0606==2 & v0607==4 & v0608==2 & v0609==1 & v0610==7
replace anoest =8 if v0602==4 & v0606==2 & v0607==4 & v0608==2 & v0609==1 & v0610==8

replace anoest =0 if v0602==4 & v0606==2 & v0607==4 & v0608==2 & v0609==3

replace anoest =8 if v0602==4 & v0606==2 & v0607==4 & v0608==4 & v0611==1
replace anoest =0 if v0602==4 & v0606==2 & v0607==4 & v0608==4 & v0611==3

replace anoest =9 if v0602==4 & v0606==2 & v0607==5 & v0608==2 & v0609==1 & v0610==1
replace anoest =10 if v0602==4 & v0606==2 & v0607==5 & v0608==2 & v0609==1 & v0610==2
replace anoest =11 if v0602==4 & v0606==2 & v0607==5 & v0608==2 & v0609==1 & v0610==3
replace anoest =11 if v0602==4 & v0606==2 & v0607==5 & v0608==2 & v0609==1 & v0610==4

replace anoest =8 if v0602==4 & v0606==2 & v0607==5 & v0608==2 & v0609==3

replace anoest =11 if v0602==4 & v0606==2 & v0607==5 & v0608==4 & v0611==1
replace anoest =8 if v0602==4 & v0606==2 & v0607==5 & v0608==4 & v0611==3

replace anoest =12 if v0602==4 & v0606==2 & v0607==6 & v0609==1 & v0610==1
replace anoest =13 if v0602==4 & v0606==2 & v0607==6 & v0609==1 & v0610==2
replace anoest =14 if v0602==4 & v0606==2 & v0607==6 & v0609==1 & v0610==3

replace anoest =15 if v0602==4 & v0606==2 & v0607==6 & v0609==1 & v0610==4
replace anoest =16 if v0602==4 & v0606==2 & v0607==6 & v0609==1 & v0610==5
replace anoest =17 if v0602==4 & v0606==2 & v0607==6 & v0609==1 & v0610==6

replace anoest =11 if v0602==4 & v0606==2 & v0607==6 & v0609==3

replace anoest =17 if v0602==4 & v0606==2 & v0607==7 & v0611==1
replace anoest =15 if v0602==4 & v0606==2 & v0607==7 & v0611==3

replace anoest =0 if v0602==4 & v0606==2 & v0607==8
replace anoest =0 if v0602==4 & v0606==2 & v0607==9

replace anoest =0 if v0602==4 & v0606==4

label var anoest "years of schooling"

/* C.2 RECODE: S�RIE QUE FREQ�ENTA NA ESCOLA */
recode v0605 (9=.)
rename v0605 serie_freq
label var serie_freq "grade (if attends school)"

/* C.3 RECODE: CURSO QUE FREQ�ENTA NA ESCOLA */
recode v0603 (0=.)
rename v0603 curso_freq
label var curso_freq "course (if attends school)"
* curso_freq = 1 regular primeiro grau
*           = 2 regular segundo grau
*           = 3 supl primeiro grau
*           = 4 supl segundo grau
*           = 5 superior
*           = 6 alfab de adultos
*           = 7 pr�-escolar ou creche
*           = 8 pr�-vestibular
*           = 9 mestrado/doutorado

/* C.4 RECODE: S�RIE - N�O FREQUENTA ESCOLA */
recode v0610 (9=.)
rename v0610 serie_nao_freq

/* C.5 RECODE: curso N�O FREQ�ENTA NA ESCOLA */
recode v0607 (0=.) 
rename v0607 curso_nao_freq
label var curso_nao_freq "course (if does not attends school)"
* curso_nao_freq = 1 elementar (prim�rio)
*               = 2 m�dio primeiro ciclo (ginasial)
*               = 3 m�dio segundo ciclo (cient�fico, cl�ssico etc.)
*               = 4 primeiro grau
*               = 5 segundo grau
*               = 6 superior
*               = 7 mestrado/doutorado
*               = 8 alfab de adultos
*               = 9 pr�-escolar ou creche

/* C.6 CONCLUSAO CURSO FREQUENTDO ANTERIORMENTE */
* v0611

drop v0604 v0606 v0608 v0609 v4701 v4702
cap drop v6002

/* D. VALORES = -1 E 999.999.999.999 E OUTROS MISSINGS E INDETERMINADOS */

/* D. TRABALHO INFANTIL */
	
if `max'==0 {
	recode v0713 v7122 v7125 (-1 = .)
	replace v7122 = . if v7122>10^10
	replace v7125 = . if v7125>10^10
}
	
/* D.1 - APENAS PARA 2001 */
/* Esta se��o n�o � totalmente compativel com as se��es espec�ficas de 
	trabalho infantil nos outros anos da PNAD. Isso porque, em 2001, primeiro
	se fazem as perguntas referentes � semanda de refer�ncia, enquanto nos
	demais, as primeiras perguntas se referem � condi��o de trabalho no ano.
	Isso afeta o encadeamento das quest�es. */
	
sum v0101
loc min = r(min)
qui reg v0101 if v8005>=5 & v8005<=9

if `min' == 2001 {

	* trabalho no ano
	g v0701 = 1 if (v9067==1 | v9001==1 | v9002==2) & e(sample)
	replace v0701 = 3 if (v9067==3 | v9002==4) & e(sample)
	lab var v0701 "worked in the last 365 days"

	* producao para consumo
	g v0702 = 2 if (v9068==2 | v9003==1) & e(sample) 
	replace v0702 = 4 if v9068==4 & e(sample) 
	lab var v0702 "worked - own consumption - last year"
	
	* construcao para uso
	g v0703 = 1 if (v9069==1 | v9004==2) & e(sample)
	replace v0703 = 3 if v9069==3 & e(sample)
	lab var v0703 "worked with construction last year"
	
	* trabalhou na semama
	g v0704 = v9001 if (v0701==1 | v0702==2 | v0703==1) & e(sample) 
	lab var v0704 "worked on reference week"

	* esteve afastado  
	g v0705 = v9002 if v0704==3 & e(sample)
	lab var v0705 "employed taking time-off ref week"
	
	* cod ocupacao/atividade - 358 dias
	g v7060 = v9971 if v9001~=1 & v9002~=2 & e(sample)
	g v7070 = v9972 if v9001~=1 & v9002~=2 & e(sample)
	lab var v7060 "occupation codes on the job - 358 days"
	lab var v7070 "main activity codes - 358 days"
	
	* posicao na ocupacao - 358 dias
	g v0708 = v9077 if                          v9001~=1 & v9002~=2 & e(sample)
	replace v0708 = 8 if v0708==7 &             v9001~=1 & v9002~=2 & e(sample)
	replace v0708 = 1 if v9073<=4 &             v9001~=1 & v9002~=2 & e(sample)
	replace v0708 = 3 if v9073>=5 & v9073<=7 &  v9001~=1 & v9002~=2 & e(sample)
	replace v0708 = 4 if v9073>=8 & v9073<=10 & v9001~=1 & v9002~=2 & e(sample)
	replace v0708 = 5 if v9073==11 &            v9001~=1 & v9002~=2 & e(sample)
	replace v0708 = 6 if v9073==12 &            v9001~=1 & v9002~=2 & e(sample)
	replace v0708 = 7 if v9073==13 &            v9001~=1 & v9002~=2 & e(sample)
	lab var v0708 "position in the ocupation - 358 days"
	
	* cod ocupacao/atividade - semana
	g v7090 = v9906 if (v9001==1 | v9002==2) & e(sample)
	g v7100 = v9907 if (v9001==1 | v9002==2) & e(sample)
	lab var v7090 "occupation codes on the job - ref week"
	lab var v7100 "main activity codes - ref week"
	
	* posicao na ocupacao - semana
	g v0711 = v9029 if 							(v9001==1 | v9002==2) & e(sample)
	replace v0711 = 8 if v9029==7 &             (v9001==1 | v9002==2) & e(sample)
	replace v0711 = 1 if v9008<=4 &             (v9001==1 | v9002==2) & e(sample)
	replace v0711 = 3 if v9008>=5 & v9008<=7 &  (v9001==1 | v9002==2) & e(sample)
	replace v0711 = 4 if v9008>=8 & v9008<=10 & (v9001==1 | v9002==2) & e(sample)
	replace v0711 = 5 if v9008==11 &            (v9001==1 | v9002==2) & e(sample)
	replace v0711 = 6 if v9008==12 &            (v9001==1 | v9002==2) & e(sample)
	replace v0711 = 7 if v9008==13 &            (v9001==1 | v9002==2) & e(sample)
	lab var v0711 "position in occupation ref week"
	
	* renda em dinheiro?
	g v7122 = v9532 if v0711~=.
	lab var v7122 "value monthly income cash ref week"
	
	* renda em mercadoria?
	g v7125 = v9535 if v0711~=.
	lab var v7125 "value income in merchandise"
	
	* horas trabalhadas
	g v0713 = v9058 if v0711~=.
	lab var v0713 "hours worked per week"
	recode v0711 (9 = .)
	replace v0701 = . if v0701==0
	replace v0713 = . if v0713==99
}
cap replace v0701 = . if v0701==0

cap drop v0706 v0707 v0709 v0710

/* E. CARACTERISTICAS DE TRABALHO */

/* E.0 ESPECIFICIDADES DA PNAD 2001 */
* Neste ano, a se��o sobre trabalho e rendimento foi realizada para 5 anos 
* ou mais, em contraste com as demais, onde a idade m�nima foi de 10 anos

* Variaveis derivadas: apenas restringir a 10 anos ou mais

if `min'==2001 {
	g v4704 = v4754 if v8005>9
	g v4705 = v4755 if v8005>9
	g v4706 = v4756 if v8005>9
	g v4707 = v4757 if v8005>9
	g v4709 = v4759 if v8005>9
	g v4710 = v4760 if v8005>9
	g v4711 = v4761 if v8005>9
	g v4713 = v4763 if v8005>9
	g v4714 = v4764 if v8005>9
	g v4715 = v4765 if v8005>9
	g v4716 = v4766 if v8005>9
	g v4717 = v4767 if v8005>9
	g v4718 = v4768 if v8005>9
	g v4719 = v4769 if v8005>9
	g v4720 = v4770 if v8005>9
	replace v4704 = . if v4704 == 3
	replace v4707 = . if v4707 == 6
	replace v4711 = . if v4711 == 3
	replace v4713 = . if v4713 == 3
	replace v4713 = . if v4713 == 0
	replace v4723 = . if v4723 == 0
	


	lab var v4704 "activity condition ref week, 10 or +"
	lab var v4705 "occupation condition ref week, 10 or +"
	lab var v4706 "position in occupation main job ref week, 10 or +"
	lab var v4707 "hours worked per week all jobs, 10 or +"
	lab var v4709 "worked in which sector of the firm - ref week"
	lab var v4710 "type of occupation in the job held - ref week"
	lab var v4711 "contributed social security, 10 or +"
	lab var v4713 "activity condition job 365 days, 10 or +"
	lab var v4714 "occupation condition 365 days, 10 or +"
	lab var v4715 "position in occupation 365 days, 10 or +"
	lab var v4716 "worked in which sector of the firm - 365 days"
	lab var v4717 "type of occupation in the job held - 365 days"
	lab var v4718 "monthly income main job, 10 or +"
	lab var v4719 "monthly income all jobs, 10 or +"
	lab var v4720 "monthly income all sources, 10 or +"

	drop v4754 v4755 v4756 v4757 v4759 v4760 v4761 v4763 v4764 v4765 v4766 v4767 v4768 v4769 v4770
}

* drops
cap drop v9006 v9007 v9071 v9072 v9090 v9091 v9110 v9111	// nomes da ocupacao e atividade

* Recodes
recode v9008 v9058 v9611 v9612 v9064 v9073 v9861 v9862 v9892 v9101 v9105 v1091 v1092 (99 =.)
recode v9008 v9073 (88 = .)
recode v9009-v9014 v9016-v9019 v9021-v9052 v9054-v9057 v9059 v9060 v9062 v9063 v9065-v9070 ///
	v9074-v9085 v9087 v9088 v9891 v9092-v9097 v9099 v9100 v9103 v9104 v9106 v9107 v9108 ///
	v9112-v9124 (9 = .)
recode v9001 (0 = .)
foreach var in v9154 v9159 v9164 v9204 v9209 ///
		v9214 v9038 v9039 v9532 v9535 v9058 v9611 v9612 ///
		v9064 v9861 v9862 v9892 v9982 v9985 v9101 v1022 v1025 v9105 v1091 v1092 v1252 ///
		v1255 v1258 v1261 v1264 v1267 v1270 v1273 v1141 v1142 v1151 v1152 v1161 ///
		v1162 v1111 v1112  v4718 v4719 v4720 {
	replace `var' = . if `var'==-1 | `var'>10^11
}

drop v9152 v9157 v9162 v9202 v9207 v9212 // area da propriedade em medida diferentente de m2
recode v9154 v9159 v9164 v9204 (9999999=.)

cap drop v9921	// horas de afazeres domesticos (so 2001)

/* MUDAN�A NA ORDEM DAS QUEST�ES INICIAIS DA SE��O */
* A partir de 2001, foram invertidas das questoes v9002, v9003 e v9004.
* Antes, perguntava-se primeiro se o individuo havia trabalhado na producao
* para o proprio consumo ou na construcao para o proprio uso. Agora, pergunta-se
* primeiro se o individuo estaava afastado de algum trabalho na semana de ref.
* Isso pode alterar quem responde as questoes dependendo dos saltos.

/* E.1 - Trabalhou na produ��o para pr�prio consumo */
/* E.2 - Trabalhou na constru��o para pr�prio uso */
/* E.3 - Esteve afastado do trabalho */

g trab_consumo = .
g trab_uso = .
g trab_afast = .

if `min' < 2001 {
	replace trab_consumo = v9002
	replace trab_uso = v9003
	replace trab_afast = v9004
}
if `min' == 2001 {
	replace trab_consumo = 2 if v9003 == 1
	replace trab_consumo = 4 if v9003 == 3
	replace trab_uso = v9004 - 1
	replace trab_afast = v9002
}

recode trab_consumo trab_afast (2 = 1) (4 = 0)
recode trab_uso (3 = 0)
lab var trab_consumo "worked in agriculture to feed hh residents"
	* 1 = sim; 0 = nao
lab var trab_uso "worked in contruction within hh"
	* 1 = sim; 0 = nao
lab var trab_afast "was taking time-off"
	* 1 = sim; 0 = nao

drop v9002-v9004	

/* E.4.1 e E.4.2 CONDI��O DE OCUPA��O (na semana e no ano) */ 
* At� 2007, essas vari�veis derivadas inclu�am crian�as menores de 10 anos
* na categoria "ocupados", com exce��o de 1996 e 1997, quando n�o houve
* se��o de trabalho com crian�as menores de 10 anos

g cond_ocup_s = v4705 if v8005>=10
lab var cond_ocup_s "occupation condition - ref week"

g cond_ocup_a = v4714 if v8005>=10
lab var cond_ocup_a "occupation condition - year"

recode cond_ocup_s cond_ocup_a (2 = 0)
* 1 = ocupadas; 0 = desocupadas

drop v4705 v4714

/* E.5 POSICAO NA OCUPACAO */
* A partir de 2007, as 'posicoes' foram encerradas: o 'empregado sem declaracao 
* de carteira' de trabalho, e o 'trabalhador domestico sem declaracao de carteira',
* provavelmente incorporados aos empregados e trabalhadores domesticos sem carteira,
* respectivamente; as demais posicoes permaneceram inalteradas

recode v4706 (5 = 4) (8 = 7) (14=.)
recode v4715 (5 = 4) (8 = 7) (14=.)

/* E.6 ATIVIDADE PRINCIPAL DO EMPREENDIMENTO do trab principal */
* A partir de 2001, essas vari�veis incluem criancas menores de 10 anos

g ativ_semana = v4708 if v8005>=10
lab var ativ_semana "activity/line of business - ref week"
g ativ_ano = v4712 if v8005>=10
lab var ativ_ano "activity/line of business - year"

drop v4708 v4712

/* E.7 CODIGOS DE OCUPACAO E ATIVIDADE */
* codigos de ocupacao e atividade: a partir de 2002, sao usados CBO e CNAE
* as vari�veis s�o mantidas, mas n�o h� comparabilidade das vari�veis agredadas entre as d�cadas


/* F. FECUNDIDADE */
* a partir de 2001, esse quesito passou a ser aplicado tamb�m a mulheres entre 10 e 15 anos.

foreach var in v1101 v1141 v1142 v1151 v1152 v1153 v1154 v1161 v1162 ///
		v1163 v1164 v1107 v1181 v1182 v1109 v1110 v1111 v1112 v1113 v1114 {

		rename `var' `var'c
		replace `var'c = . if v8005<15
}

recode v1182c (999 9999 = .)
recode v1141c v1142c v1151c v1152c v1161c v1162c v1181c v1182c ///
	v1111c v1112c (99 =.)
recode v1107c v1109c v1110c (9 = .)
recode v1101c (0 = .)


/* F.1 - Recode ano de nascimento do ultimo filho */
replace v1182c = v1182c + 1000 if v1182c>99 & v1182c<1000
replace v1182c = v1182c + 1900 if v1182c<=99


/* DEFLACIONANDO E CONVERTENDO UNIDADES MONET�RIAS PARA REAIS */

/* CONVERTENDO OS VALORES NOMINAIS PARA REAIS (UNIDADE MONET�RIA) */
/* 	E DEFLACIONANDO: 1 = out/2012                                 */

gen double deflator = 0.488438 if v0101 == 2001
format deflator %26.25f
replace deflator    = 0.425376 if v0101 == 1999
replace deflator    = 0.399657 if v0101 == 1998
replace deflator    = 0.387748 if v0101 == 1997
replace deflator    = 0.371635 if v0101 == 1996
replace deflator    = 0.330617 if v0101 == 1995
replace deflator    = 0.103168/10 if v0101 == 1993
replace deflator    = 0.498848/1000 if v0101 == 1992

label var deflator "income deflator - reference: oct/2012"  

gen double conversor = 1             if v0101 >= 1995
replace conversor    = 2750          if v0101 == 1993
replace conversor    = 2750000       if v0101 == 1992

label var conversor "currency converter"

foreach var in v9532 v9535 v9982 v9985 v1022 v1025 v1252 v1255 v1258 v1261 v1264 ///
		v1267 v1270 v1273 v7122 v7125 v4718 v4719 v4720 v4721 v4722 v4726 {
	cap replace `var' = . if `var'==-1 | `var'>10^10
	cap g `var'def = (`var'/conversor)/deflator
	cap lab var `var'def "`var' deflated"
}


/* OUTROS RECODES */

recode v8005 (999 =.)
recode v4703 (17 = .)
recode /* cor */ v0404 /* m�e */ v0405 v0406 (9 = .)

if `min'==2001 {
	rename v4788 v4738
	replace v4738=. if v8005<=9
}
cap recode v4738 (7=.)

/* OUTROS DROPS */

if `min'==1996  drop v4739-v4743
if `min'==2001 drop v5005 v5505 v0513 v9151 v9153 v9155 v9156 v9158 v9160 v9161 v9163 ///
	v9165 v9201 v9203 v9205 v9206 v9208 v9210 v9211 v9213 v9215 v9531 v9533 v9534 ///
	v9536 v9537 v9981 v9983 v9984 v9986 v9987 v1021 v1023 v1024 v1026 v1027 v1028 ///
	v1251 v1253 v1254 v1256 v1257 v1259 v1260 v1262 v1263 v1265 v1266 v1268 v1269 ///
	v1271 v1272 v1274 v1275 v4785 v4776 v4739 v4740

/* K. SUPLEMENTOS */
cap drop /* supletivo */ v0801 -v0811 /* nupcialidade */ v1001- v1004 // 1995
cap drop /* mobilidade social */ v1201-v1219 // 1996
cap drop /* saude */ v1301-v7932 /* mobilidade fisica */ v1401-v1409 // 1998
cap drop /* migra��o dos filhos */ v8121-v8163 /* educacao*/ v1501-v1512  /* saude e seguranca */ v1601-v1630 // 2001

end

*************************************************************
*			 compat_pess_2002a2009_para_81.ado 				*
*************************************************************

program define compat_pes_2002a2009_para_81

/* C.0 RECODE: ANO */
rename v0101 ano
label var ano "ano da pesquisa"
qui sum ano
if r(mean)==2003 drop v13* v14* v17* v18* v33* v7101 v7102 
if r(mean)==2004 drop v19* 
if r(mean)==2005 drop v22* 
if r(mean)==2006 drop v19* v23* v88* 
if r(mean)==2007 drop v25* v26* v66* v67* 
if r(mean)==2008 drop v27* v72* v13* v14* v33* v34* v36* v37* v22* v28* ///
	v82* v73* v77* SELEC PESPET v1701 v1702
if r(mean)==2009 drop v29* 

foreach var in v0408 v0409 v0410 v4011 v0412 v4732 v4735 v4838 v6502 v4740 v4741 v4742 v4743 ///
				v4744 v4745 v4746 v4747 v4748 v4749 v4750 v9993 {
	cap drop `var'
}

/* A. ACERTA CÓDIGO DOS ESTADOS */
* AGREGA TOCANTINS COM GOIÁS

/* A.1 NA VARIÁVEL UF E CRIA VARIÁVEL DE REGIÃO */
destring uf, replace
recode uf (17=52)
gen regiao = int(uf/10)
label var regiao "região"
tostring uf, replace

/* B. NÚMERO DE CONTROLE, SÉRIE E ORDEM */
rename v0301 ordem
drop v0102 v0103 

/* C. RECODE E RENAME DAS VARIÁVEIS */

/* C.1 DUMMY: ZONA URBANA */
recode v4728 (1 2 3=1) (4 5 6 7 8=0)
rename v4728 urbana
label var urbana "área urbana"
* urbana = 1 urbana
*        = 0 rural

/* C.2 DUMMY: REGIÃO METROPOLITANA */
recode v4727 (2/3=0), g(metropol)
label var metropol "região metropolitana"
* metropol = 1 região metropolitana
*          = 0 não

rename v4727 area_censit

/* C.3 RENAME: PESOS */
rename v4729 peso

/* C.4 RECODE: SEXO */
recode v0302 (2=1) (4=0)
rename v0302 sexo
* sexo = 1 homem
*      = 0 mulher

/* C.5 DATA DE NASCIMENTO */
recode v3031 (0 99=.)
rename v3031 dia_nasc

recode v3032 (20 99=.)
rename v3032 mes_nasc

* O ano de nascimento reporta a idade quando a idade é presumida.
* Substituído por missing.
replace v3033 = . if v3033 <= 150 | v3033==9999
rename v3033 ano_nasc

/* C.6 RECODE: IDADE */
recode v8005 (999=.)
rename v8005 idade

/* C.7 RECODE: CONDIÇÃO NO DOMICÍLIO */
rename v0401 cond_dom
label var cond_dom "1-chef 2-cônj 3-filh 4-outr_parent 5-agreg 6-pens 7-empr_domes 8-parent_empr_dom"
* cond_dom = 1 chefe
*          = 2 cônjuge
*          = 3 filho
*          = 4 outro parente
*          = 5 agregado
*          = 6 pensionista
*          = 7 empregado doméstico
*          = 8 parente do empregado doméstico

/* C.8 RENAME: CONDIÇÃO NA FAMÍLIA */
rename v0402 cond_fam
label var cond_fam "1-chef 2-cônj 3-filh 4-outr_parent 5-agreg 6-pens 7-empr_domes 8-parent_empr_dom"
* cond_fam = 1 chefe
*          = 2 cônjuge
*          = 3 filho
*          = 4 outro parente
*          = 5 agregado
*          = 6 pensionista
*          = 7 empregado doméstico
*          = 8 parente do empregado doméstico

/* C.9 RENAME: NÚMERO DA FAMÍLIA */
rename v0403 num_fam

/* C.10 RECODE: COR OU RAÇA */
recode v0404 (9=.)
rename v0404 cor
label var cor "2-branca 4-preta 6-amarela 8-parda 0-indígena"
* cor = 2 branca
*     = 4 preta
*     = 6 amarela
*     = 8 parda
*     = 0 indígena
* A opção "0 indígena" somente apareceu a partir de 92.


/* C.11 VARIÁVEIS DE EDUCAÇÃO */
/* C.11.1 RECODE: ANOS DE ESTUDO */
/* EDUCAÇÃO */
/* VARIÁVEIS UTILIZADAS PARA 2002 A 2006*/
/* v0602=FREQUENTA ESCOLA OU CRECHE? */
/* v0603=QUAL E O CURSO QUE FREQUENTA? */
/* v0604=ESTE CURSO QUE FREQUENTA E SERIADO? */
/* v0605=QUAL E A SERIE QUE FREQUENTA? */
/* v0606=ANTERIORMENTE FREQUENTOU ESCOLA OU CRECHE? */
/* v0607=QUAL FOI O CURSO MAIS ELEVADO QUE FREQUENTOU ANTERIORMENTE? */
/* v0608=ESTE CURSO QUE FREQUENTOU ANTERIORMENTE ERA SERIADO? */
/* v0609=CONCLUIU,COM APROVACAO,PELO MENOS A PRIMEIRA SERIE DESTE CURSO QUE FREQUENTOU ANTERIORMENTE? */
/* v0610=QUAL FOI A ULTIMA SERIE QUE CONCLUIU,COM APROVACAO,NESTE CURSO QUE FREQUENTOU ANTERIORMENTE? */
/* v0611=CONCLUIU ESTE CURSO QUE FREQUENTOU ANTERIORMENTE? */
/* PARA 2007, 2008 E 2009, EM VEZ DE v0603 E v0607 */
/* v6003=QUAL E O CURSO QUE FREQUENTA? */
/* v6030=QUAL A DURACAO DO ENSINO FUNDAMENTAL QUE FREQUENTA? */
/* v6007=QUAL FOI O CURSO MAIS ELEVADO QUE FREQUENTOU ANTERIORMENTE? */
/* v6070=QUAL A DURACAO DO ENSINO FUNDAMENTAL QUE FREQUENTOU ANTERIORMENTE? */

generate byte educa = .
lab var educa "anos de estudo - compatível c/ anos 1980"
quietly summarize ano
loc min = r(min)
loc max = r(max)

if `min' <= 2006 {
/* 2002 a 2006 */
/* pessoas que ainda freqüentam escola */
	replace educa =0 if v0602==2 & v0603==1 & v0605==1 & ano <= 2006
	replace educa =1 if v0602==2 & v0603==1 & v0605==2 & ano <= 2006
	replace educa =2 if v0602==2 & v0603==1 & v0605==3 & ano <= 2006
	replace educa =3 if v0602==2 & v0603==1 & v0605==4 & ano <= 2006
	replace educa =4 if v0602==2 & v0603==1 & v0605==5 & ano <= 2006
	replace educa =5 if v0602==2 & v0603==1 & v0605==6 & ano <= 2006
	replace educa =6 if v0602==2 & v0603==1 & v0605==7 & ano <= 2006
	replace educa =7 if v0602==2 & v0603==1 & v0605==8 & ano <= 2006

	replace educa =8 if v0602==2 & v0603==2 & v0605==1 & ano <= 2006
	replace educa =9 if v0602==2 & v0603==2 & v0605==2 & ano <= 2006
	replace educa =10 if v0602==2 & v0603==2 & v0605==3 & ano <= 2006
	replace educa =11 if v0602==2 & v0603==2 & v0605==4 & ano <= 2006

	replace educa =0 if v0602==2 & v0603==3 & v0604==2 & v0605==1 & ano <= 2006
	replace educa =1 if v0602==2 & v0603==3 & v0604==2 & v0605==2 & ano <= 2006
	replace educa =2 if v0602==2 & v0603==3 & v0604==2 & v0605==3 & ano <= 2006
	replace educa =3 if v0602==2 & v0603==3 & v0604==2 & v0605==4 & ano <= 2006
	replace educa =4 if v0602==2 & v0603==3 & v0604==2 & v0605==5 & ano <= 2006
	replace educa =5 if v0602==2 & v0603==3 & v0604==2 & v0605==6 & ano <= 2006
	replace educa =6 if v0602==2 & v0603==3 & v0604==2 & v0605==7 & ano <= 2006
	replace educa =7 if v0602==2 & v0603==3 & v0604==2 & v0605==8 & ano <= 2006

	replace educa =0 if v0602==2 & v0603==3 & v0604==4  & ano <= 2006

	replace educa =8 if v0602==2 & v0603==4 & v0604==2 & v0605==1 & ano <= 2006
	replace educa =9 if v0602==2 & v0603==4 & v0604==2 & v0605==2 & ano <= 2006
	replace educa =10 if v0602==2 & v0603==4 & v0604==2 & v0605==3 & ano <= 2006
	replace educa =11 if v0602==2 & v0603==4 & v0604==2 & v0605==4 & ano <= 2006

	replace educa =8 if v0602==2 & v0603==4 & v0604==4  & ano <= 2006

	replace educa =11 if v0602==2 & v0603==5 & v0605==1 & ano <= 2006
	replace educa =12 if v0602==2 & v0603==5 & v0605==2 & ano <= 2006
	replace educa =13 if v0602==2 & v0603==5 & v0605==3 & ano <= 2006
	replace educa =14 if v0602==2 & v0603==5 & v0605==4 & ano <= 2006
	replace educa =15 if v0602==2 & v0603==5 & v0605==5 & ano <= 2006
	replace educa =16 if v0602==2 & v0603==5 & v0605==6 & ano <= 2006

	replace educa =0 if v0602==2 & v0603==6 & ano <= 2006
	replace educa =0 if v0602==2 & v0603==7 & ano <= 2006
	replace educa =0 if v0602==2 & v0603==8 & ano <= 2006
	replace educa =11 if v0602==2 & v0603==9 & ano <= 2006
	replace educa =15 if v0602==2 & v0603==10 & ano <= 2006

/* pessoas que não freqüentam */

	replace educa =1 if v0602==4 & v0606==2 & v0607==1 & v0609==1 & v0610==1 & ano <= 2006
	replace educa =2 if v0602==4 & v0606==2 & v0607==1 & v0609==1 & v0610==2 & ano <= 2006
	replace educa =3 if v0602==4 & v0606==2 & v0607==1 & v0609==1 & v0610==3 & ano <= 2006
	replace educa =4 if v0602==4 & v0606==2 & v0607==1 & v0609==1 & v0610==4 & ano <= 2006
	replace educa =4 if v0602==4 & v0606==2 & v0607==1 & v0609==1 & v0610==5 & ano <= 2006
	replace educa =4 if v0602==4 & v0606==2 & v0607==1 & v0609==1 & v0610==6 & ano <= 2006

	replace educa =0 if v0602==4 & v0606==2 & v0607==1 & v0609==3 & ano <= 2006

	replace educa =5 if v0602==4 & v0606==2 & v0607==2 & v0608==2 & v0609==1 & v0610==1 & ano <= 2006
	replace educa =6 if v0602==4 & v0606==2 & v0607==2 & v0608==2 & v0609==1 & v0610==2 & ano <= 2006
	replace educa =7 if v0602==4 & v0606==2 & v0607==2 & v0608==2 & v0609==1 & v0610==3 & ano <= 2006
	replace educa =8 if v0602==4 & v0606==2 & v0607==2 & v0608==2 & v0609==1 & v0610==4 & ano <= 2006
	replace educa =8 if v0602==4 & v0606==2 & v0607==2 & v0608==2 & v0609==1 & v0610==5 & ano <= 2006

	replace educa =4 if v0602==4 & v0606==2 & v0607==2 & v0608==2 & v0609==3 & ano <= 2006

	replace educa =8 if v0602==4 & v0606==2 & v0607==2 & v0608==4 & v0611==1 & ano <= 2006
	replace educa =4 if v0602==4 & v0606==2 & v0607==2 & v0608==4 & v0611==3 & ano <= 2006

	replace educa =9 if v0602==4 & v0606==2 & v0607==3 & v0608==2 & v0609==1 & v0610==1 & ano <= 2006
	replace educa =10 if v0602==4 & v0606==2 & v0607==3 & v0608==2 & v0609==1 & v0610==2 & ano <= 2006
	replace educa =11 if v0602==4 & v0606==2 & v0607==3 & v0608==2 & v0609==1 & v0610==3 & ano <= 2006
	replace educa =11 if v0602==4 & v0606==2 & v0607==3 & v0608==2 & v0609==1 & v0610==4 & ano <= 2006

	replace educa =8 if v0602==4 & v0606==2 & v0607==3 & v0608==2 & v0609==3 & ano <= 2006

	replace educa =11 if v0602==4 & v0606==2 & v0607==3 & v0608==4 & v0611==1 & ano <= 2006
	replace educa =8 if v0602==4 & v0606==2 & v0607==3 & v0608==4 & v0611==3 & ano <= 2006

	replace educa =1 if v0602==4 & v0606==2 & v0607==4 & v0608==2 & v0609==1 & v0610==1 & ano <= 2006
	replace educa =2 if v0602==4 & v0606==2 & v0607==4 & v0608==2 & v0609==1 & v0610==2 & ano <= 2006
	replace educa =3 if v0602==4 & v0606==2 & v0607==4 & v0608==2 & v0609==1 & v0610==3 & ano <= 2006
	replace educa =4 if v0602==4 & v0606==2 & v0607==4 & v0608==2 & v0609==1 & v0610==4 & ano <= 2006
	replace educa =5 if v0602==4 & v0606==2 & v0607==4 & v0608==2 & v0609==1 & v0610==5 & ano <= 2006
	replace educa =6 if v0602==4 & v0606==2 & v0607==4 & v0608==2 & v0609==1 & v0610==6 & ano <= 2006
	replace educa =7 if v0602==4 & v0606==2 & v0607==4 & v0608==2 & v0609==1 & v0610==7 & ano <= 2006
	replace educa =8 if v0602==4 & v0606==2 & v0607==4 & v0608==2 & v0609==1 & v0610==8 & ano <= 2006

	replace educa =0 if v0602==4 & v0606==2 & v0607==4 & v0608==2 & v0609==3 & ano <= 2006

	replace educa =8 if v0602==4 & v0606==2 & v0607==4 & v0608==4 & v0611==1 & ano <= 2006
	replace educa =0 if v0602==4 & v0606==2 & v0607==4 & v0608==4 & v0611==3 & ano <= 2006

	replace educa =9 if v0602==4 & v0606==2 & v0607==5 & v0608==2 & v0609==1 & v0610==1 & ano <= 2006
	replace educa =10 if v0602==4 & v0606==2 & v0607==5 & v0608==2 & v0609==1 & v0610==2 & ano <= 2006
	replace educa =11 if v0602==4 & v0606==2 & v0607==5 & v0608==2 & v0609==1 & v0610==3 & ano <= 2006
	replace educa =11 if v0602==4 & v0606==2 & v0607==5 & v0608==2 & v0609==1 & v0610==4 & ano <= 2006

	replace educa =8 if v0602==4 & v0606==2 & v0607==5 & v0608==2 & v0609==3 & ano <= 2006

	replace educa =11 if v0602==4 & v0606==2 & v0607==5 & v0608==4 & v0611==1 & ano <= 2006
	replace educa =8 if v0602==4 & v0606==2 & v0607==5 & v0608==4 & v0611==3 & ano <= 2006

	replace educa =12 if v0602==4 & v0606==2 & v0607==6 & v0609==1 & v0610==1 & ano <= 2006
	replace educa =13 if v0602==4 & v0606==2 & v0607==6 & v0609==1 & v0610==2 & ano <= 2006
	replace educa =14 if v0602==4 & v0606==2 & v0607==6 & v0609==1 & v0610==3 & ano <= 2006

	replace educa =15 if v0602==4 & v0606==2 & v0607==6 & v0609==1 & v0610==4 & ano <= 2006
	replace educa =16 if v0602==4 & v0606==2 & v0607==6 & v0609==1 & v0610==5 & ano <= 2006
	replace educa =17 if v0602==4 & v0606==2 & v0607==6 & v0609==1 & v0610==6 & ano <= 2006

	replace educa =11 if v0602==4 & v0606==2 & v0607==6 & v0609==3 & ano <= 2006

	replace educa =17 if v0602==4 & v0606==2 & v0607==7 & v0611==1 & ano <= 2006
	replace educa =15 if v0602==4 & v0606==2 & v0607==7 & v0611==3 & ano <= 2006

	replace educa =0 if v0602==4 & v0606==2 & v0607==8 & ano <= 2006
	replace educa =0 if v0602==4 & v0606==2 & v0607==9 & ano <= 2006
	replace educa =0 if v0602==4 & v0606==2 & v0607==10 & ano <= 2006

	replace educa =0 if v0602==4 & v0606==4 & ano <= 2006
}
if `max' >= 2007 {
/* 2007 a 2009 */
/* pessoas que ainda freqüentam escola */
	replace educa =0 if v0602==2 & v6003==1 & v6030==1 & v0605==1 & ano >= 2007
	replace educa =1 if v0602==2 & v6003==1 & v6030==1 & v0605==2 & ano >= 2007
	replace educa =2 if v0602==2 & v6003==1 & v6030==1 & v0605==3 & ano >= 2007
	replace educa =3 if v0602==2 & v6003==1 & v6030==1 & v0605==4 & ano >= 2007
	replace educa =4 if v0602==2 & v6003==1 & v6030==1 & v0605==5 & ano >= 2007
	replace educa =5 if v0602==2 & v6003==1 & v6030==1 & v0605==6 & ano >= 2007
	replace educa =6 if v0602==2 & v6003==1 & v6030==1 & v0605==7 & ano >= 2007
	replace educa =7 if v0602==2 & v6003==1 & v6030==1 & v0605==8 & ano >= 2007

	replace educa =0 if v0602==2 & v6003==1 & v6030==3 & v0605==1 & ano >= 2007
	replace educa =0 if v0602==2 & v6003==1 & v6030==3 & v0605==2 & ano >= 2007
	replace educa =1 if v0602==2 & v6003==1 & v6030==3 & v0605==3 & ano >= 2007
	replace educa =2 if v0602==2 & v6003==1 & v6030==3 & v0605==4 & ano >= 2007
	replace educa =3 if v0602==2 & v6003==1 & v6030==3 & v0605==5 & ano >= 2007
	replace educa =4 if v0602==2 & v6003==1 & v6030==3 & v0605==6 & ano >= 2007
	replace educa =5 if v0602==2 & v6003==1 & v6030==3 & v0605==7 & ano >= 2007
	replace educa =6 if v0602==2 & v6003==1 & v6030==3 & v0605==8 & ano >= 2007
	replace educa =7 if v0602==2 & v6003==1 & v6030==3 & v0605==0 & ano >= 2007

	replace educa =8 if v0602==2 & v6003==2 & v0605==1 & ano >= 2007
	replace educa =9 if v0602==2 & v6003==2 & v0605==2 & ano >= 2007
	replace educa =10 if v0602==2 & v6003==2 & v0605==3 & ano >= 2007
	replace educa =11 if v0602==2 & v6003==2 & v0605==4 & ano >= 2007

	replace educa =0 if v0602==2 & v6003==3 & v0604==2 & v0605==1 & ano >= 2007
	replace educa =1 if v0602==2 & v6003==3 & v0604==2 & v0605==2 & ano >= 2007
	replace educa =2 if v0602==2 & v6003==3 & v0604==2 & v0605==3 & ano >= 2007
	replace educa =3 if v0602==2 & v6003==3 & v0604==2 & v0605==4 & ano >= 2007
	replace educa =4 if v0602==2 & v6003==3 & v0604==2 & v0605==5 & ano >= 2007
	replace educa =5 if v0602==2 & v6003==3 & v0604==2 & v0605==6 & ano >= 2007
	replace educa =6 if v0602==2 & v6003==3 & v0604==2 & v0605==7 & ano >= 2007
	replace educa =7 if v0602==2 & v6003==3 & v0604==2 & v0605==8 & ano >= 2007

	replace educa =0 if v0602==2 & v6003==3 & v0604==4  & ano >= 2007

	replace educa =8 if v0602==2 & v6003==4 & v0604==2 & v0605==1 & ano >= 2007
	replace educa =9 if v0602==2 & v6003==4 & v0604==2 & v0605==2 & ano >= 2007
	replace educa =10 if v0602==2 & v6003==4 & v0604==2 & v0605==3 & ano >= 2007
	replace educa =11 if v0602==2 & v6003==4 & v0604==2 & v0605==4 & ano >= 2007

	replace educa =8 if v0602==2 & v6003==4 & v0604==4  & ano >= 2007

	replace educa =11 if v0602==2 & v6003==5 & v0605==1 & ano >= 2007
	replace educa =12 if v0602==2 & v6003==5 & v0605==2 & ano >= 2007
	replace educa =13 if v0602==2 & v6003==5 & v0605==3 & ano >= 2007
	replace educa =14 if v0602==2 & v6003==5 & v0605==4 & ano >= 2007
	replace educa =15 if v0602==2 & v6003==5 & v0605==5 & ano >= 2007
	replace educa =16 if v0602==2 & v6003==5 & v0605==6 & ano >= 2007

	replace educa =0 if v0602==2 & v6003==6 & ano >= 2007
	replace educa =0 if v0602==2 & v6003==7 & ano >= 2007
	replace educa =0 if v0602==2 & v6003==8 & ano >= 2007
	replace educa =0 if v0602==2 & v6003==9 & ano >= 2007
	replace educa =11 if v0602==2 & v6003==10 & ano >= 2007
	replace educa =15 if v0602==2 & v6003==11 & ano >= 2007

/* pessoas que não freqüentam */

	replace educa =1 if v0602==4 & v0606==2 & v6007==1 & v0609==1 & v0610==1 & ano >= 2007
	replace educa =2 if v0602==4 & v0606==2 & v6007==1 & v0609==1 & v0610==2 & ano >= 2007
	replace educa =3 if v0602==4 & v0606==2 & v6007==1 & v0609==1 & v0610==3 & ano >= 2007
	replace educa =4 if v0602==4 & v0606==2 & v6007==1 & v0609==1 & v0610==4 & ano >= 2007
	replace educa =4 if v0602==4 & v0606==2 & v6007==1 & v0609==1 & v0610==5 & ano >= 2007
	replace educa =4 if v0602==4 & v0606==2 & v6007==1 & v0609==1 & v0610==6 & ano >= 2007

	replace educa =0 if v0602==4 & v0606==2 & v6007==1 & v0609==3 & ano >= 2007

	replace educa =5 if v0602==4 & v0606==2 & v6007==2 & v0608==2 & v0609==1 & v0610==1 & ano >= 2007
	replace educa =6 if v0602==4 & v0606==2 & v6007==2 & v0608==2 & v0609==1 & v0610==2 & ano >= 2007
	replace educa =7 if v0602==4 & v0606==2 & v6007==2 & v0608==2 & v0609==1 & v0610==3 & ano >= 2007
	replace educa =8 if v0602==4 & v0606==2 & v6007==2 & v0608==2 & v0609==1 & v0610==4 & ano >= 2007
	replace educa =8 if v0602==4 & v0606==2 & v6007==2 & v0608==2 & v0609==1 & v0610==5 & ano >= 2007

	replace educa =4 if v0602==4 & v0606==2 & v6007==2 & v0608==2 & v0609==3 & ano >= 2007

	replace educa =8 if v0602==4 & v0606==2 & v6007==2 & v0608==4 & v0611==1 & ano >= 2007
	replace educa =4 if v0602==4 & v0606==2 & v6007==2 & v0608==4 & v0611==3 & ano >= 2007

	replace educa =9 if v0602==4 & v0606==2 & v6007==3 & v0608==2 & v0609==1 & v0610==1 & ano >= 2007
	replace educa =10 if v0602==4 & v0606==2 & v6007==3 & v0608==2 & v0609==1 & v0610==2 & ano >= 2007
	replace educa =11 if v0602==4 & v0606==2 & v6007==3 & v0608==2 & v0609==1 & v0610==3 & ano >= 2007
	replace educa =11 if v0602==4 & v0606==2 & v6007==3 & v0608==2 & v0609==1 & v0610==4 & ano >= 2007

	replace educa =8 if v0602==4 & v0606==2 & v6007==3 & v0608==2 & v0609==3 & ano >= 2007

	replace educa =11 if v0602==4 & v0606==2 & v6007==3 & v0608==4 & v0611==1 & ano >= 2007
	replace educa =8 if v0602==4 & v0606==2 & v6007==3 & v0608==4 & v0611==3 & ano >= 2007

	replace educa =1 if v0602==4 & v0606==2 & v6007==4 & v6070==1 & v0609==1 & v0610==1 & ano >= 2007
	replace educa =2 if v0602==4 & v0606==2 & v6007==4 & v6070==1 & v0609==1 & v0610==2 & ano >= 2007
	replace educa =3 if v0602==4 & v0606==2 & v6007==4 & v6070==1 & v0609==1 & v0610==3 & ano >= 2007
	replace educa =4 if v0602==4 & v0606==2 & v6007==4 & v6070==1 & v0609==1 & v0610==4 & ano >= 2007
	replace educa =5 if v0602==4 & v0606==2 & v6007==4 & v6070==1 & v0609==1 & v0610==5 & ano >= 2007
	replace educa =6 if v0602==4 & v0606==2 & v6007==4 & v6070==1 & v0609==1 & v0610==6 & ano >= 2007
	replace educa =7 if v0602==4 & v0606==2 & v6007==4 & v6070==1 & v0609==1 & v0610==7 & ano >= 2007
	replace educa =8 if v0602==4 & v0606==2 & v6007==4 & v6070==1 & v0609==1 & v0610==8 & ano >= 2007

	replace educa =0 if v0602==4 & v0606==2 & v6007==4 & v6070==1 & v0609==3 & ano >= 2007

	replace educa =0 if v0602==4 & v0606==2 & v6007==4 & v6070==3 & v0609==1 & v0610==1 & ano >= 2007
	replace educa =1 if v0602==4 & v0606==2 & v6007==4 & v6070==3 & v0609==1 & v0610==2 & ano >= 2007
	replace educa =2 if v0602==4 & v0606==2 & v6007==4 & v6070==3 & v0609==1 & v0610==3 & ano >= 2007
	replace educa =3 if v0602==4 & v0606==2 & v6007==4 & v6070==3 & v0609==1 & v0610==4 & ano >= 2007
	replace educa =4 if v0602==4 & v0606==2 & v6007==4 & v6070==3 & v0609==1 & v0610==5 & ano >= 2007
	replace educa =5 if v0602==4 & v0606==2 & v6007==4 & v6070==3 & v0609==1 & v0610==6 & ano >= 2007
	replace educa =6 if v0602==4 & v0606==2 & v6007==4 & v6070==3 & v0609==1 & v0610==7 & ano >= 2007
	replace educa =7 if v0602==4 & v0606==2 & v6007==4 & v6070==3 & v0609==1 & v0610==8 & ano >= 2007
	replace educa =8 if v0602==4 & v0606==2 & v6007==4 & v6070==3 & v0609==1 & v0610==0 & ano >= 2007

	replace educa =0 if v0602==4 & v0606==2 & v6007==4 & v6070==3 & v0609==3 & ano >= 2007

	replace educa =9 if v0602==4 & v0606==2 & v6007==5 & v0609==1 & v0610==1 & ano >= 2007
	replace educa =10 if v0602==4 & v0606==2 & v6007==5 & v0609==1 & v0610==2 & ano >= 2007
	replace educa =11 if v0602==4 & v0606==2 & v6007==5 & v0609==1 & v0610==3 & ano >= 2007
	replace educa =11 if v0602==4 & v0606==2 & v6007==5 & v0609==1 & v0610==4 & ano >= 2007

	replace educa =8 if v0602==4 & v0606==2 & v6007==5 & v0609==3 & ano >= 2007

	replace educa =1 if v0602==4 & v0606==2 & v6007==6 & v0608==2 & v0609==1 & v0610==1 & ano >= 2007
	replace educa =2 if v0602==4 & v0606==2 & v6007==6 & v0608==2 & v0609==1 & v0610==2 & ano >= 2007
	replace educa =3 if v0602==4 & v0606==2 & v6007==6 & v0608==2 & v0609==1 & v0610==3 & ano >= 2007
	replace educa =4 if v0602==4 & v0606==2 & v6007==6 & v0608==2 & v0609==1 & v0610==4 & ano >= 2007
	replace educa =5 if v0602==4 & v0606==2 & v6007==6 & v0608==2 & v0609==1 & v0610==5 & ano >= 2007
	replace educa =6 if v0602==4 & v0606==2 & v6007==6 & v0608==2 & v0609==1 & v0610==6 & ano >= 2007
	replace educa =7 if v0602==4 & v0606==2 & v6007==6 & v0608==2 & v0609==1 & v0610==7 & ano >= 2007
	replace educa =8 if v0602==4 & v0606==2 & v6007==6 & v0608==2 & v0609==1 & v0610==8 & ano >= 2007

	replace educa =0 if v0602==4 & v0606==2 & v6007==6 & v0608==2 & v0609==3 & ano >= 2007

	replace educa =8 if v0602==4 & v0606==2 & v6007==6 & v0608==4 & v0611==1 & ano >= 2007
	replace educa =0 if v0602==4 & v0606==2 & v6007==6 & v0608==4 & v0611==3 & ano >= 2007

	replace educa =9 if v0602==4 & v0606==2 & v6007==7 & v0608==2 & v0609==1 & v0610==1 & ano >= 2007
	replace educa =10 if v0602==4 & v0606==2 & v6007==7 & v0608==2 & v0609==1 & v0610==2 & ano >= 2007
	replace educa =11 if v0602==4 & v0606==2 & v6007==7 & v0608==2 & v0609==1 & v0610==3 & ano >= 2007
	replace educa =11 if v0602==4 & v0606==2 & v6007==7 & v0608==2 & v0609==1 & v0610==4 & ano >= 2007

	replace educa =8 if v0602==4 & v0606==2 & v6007==7 & v0608==2 & v0609==3 & ano >= 2007

	replace educa =11 if v0602==4 & v0606==2 & v6007==7 & v0608==4 & v0611==1 & ano >= 2007
	replace educa =8 if v0602==4 & v0606==2 & v6007==7 & v0608==4 & v0611==3 & ano >= 2007

	replace educa =12 if v0602==4 & v0606==2 & v6007==8 & v0609==1 & v0610==1 & ano >= 2007
	replace educa =13 if v0602==4 & v0606==2 & v6007==8 & v0609==1 & v0610==2 & ano >= 2007
	replace educa =14 if v0602==4 & v0606==2 & v6007==8 & v0609==1 & v0610==3 & ano >= 2007
	replace educa =15 if v0602==4 & v0606==2 & v6007==8 & v0609==1 & v0610==4 & ano >= 2007
	replace educa =16 if v0602==4 & v0606==2 & v6007==8 & v0609==1 & v0610==5 & ano >= 2007
	replace educa =17 if v0602==4 & v0606==2 & v6007==8 & v0609==1 & v0610==6 & ano >= 2007

	replace educa =11 if v0602==4 & v0606==2 & v6007==8 & v0609==3 & ano >= 2007

	replace educa =17 if v0602==4 & v0606==2 & v6007==9 & v0611==1 & ano >= 2007
	replace educa =15 if v0602==4 & v0606==2 & v6007==9 & v0611==3 & ano >= 2007

	replace educa =0 if v0602==4 & v0606==2 & v6007==10 & ano >= 2007
	replace educa =0 if v0602==4 & v0606==2 & v6007==11 & ano >= 2007
	replace educa =0 if v0602==4 & v0606==2 & v6007==12 & ano >= 2007
	replace educa =0 if v0602==4 & v0606==2 & v6007==13 & ano >= 2007

	replace educa =0 if v0602==4 & v0606==4 & ano >= 2007
}

/* C.11.2 RECODE: FREQUENTA ESCOLA */
recode v0602 (2=1) (4=0) (9=.)
rename v0602 freq_escola
label var freq_escola "0-não freq 1-frequenta"
* freq_escola = 1 se frequenta escola
*             = 0 caso contrário
* Desde 92, a pergunta inclui se frequenta creche.

/* C.11.3 DUMMY: LER E ESCREVER */
recode v0601 (3=0) (9=.)
rename v0601 ler_escrever
* ler_escrever = 1 sim
*              = 0 não

if `max' >= 2007 {
* A PARTIR DE 2007, HÁ A POSSIBILIDADE DE O ENSINO FUNDAMENTAL SER EM 9 ANOS
* NESSE CASO, O "PRIMEIRO ANO" EQUIVALE À "CLASSE DE ALFABETIZAÇÃO".
	recode v6003 (1=8) if v6030 == 3 & v0605 == 1
	recode v6007 (4=12) if v6070 == 3 & v0610 == 1
	recode v0605 (1=.) (2=1) (3=2) (4=3) (5=4) (6=5) (7=6) (8=7) (0=8) if v6030 == 3
	recode v0610 (1=.) (2=1) (3=2) (4=3) (5=4) (6=5) (7=6) (8=7) (0=8) if v6070 == 3
}

/* C.11.4 RECODE: SÉRIE QUE FREQÜENTA NA ESCOLA */
recode v0605 (9=.)
rename v0605 serie_freq
label var serie_freq "série - frequenta escola"

/* C.11.5 RECODE: GRAU QUE FREQÜENTA NA ESCOLA */
generate byte grau_freq = .

if `max' <= 2006 {
	recode v0603 (0=.) 
	recode v0603 (8=7) (9=8) (10=9)
	replace grau_freq = v0603 if ano <= 2006
}

if `max' >= 2007 {
* EM 2007, SURGIU A CATEGORIA "CLASSE DE ALFABETIZAÇÃO"
* ANTERIORMENTE ELA SE INCLUÍA EM "PRÉ-ESCOLAR OU CRECHE"
	recode v6003 (8 9=7) (10=8) (11=9)
	replace grau_freq = v6003 if ano >= 2007
}

label var grau_freq "grau - frequenta escola"
* grau_freq = 1 regular primeiro grau
*           = 2 regular segundo grau
*           = 3 supl primeiro grau
*           = 4 supl segundo grau
*           = 5 superior
*           = 6 alfab de adultos
*           = 7 pré-escolar ou creche
*           = 8 pré-vestibular
*           = 9 mestrado/doutorado

/* C.11.6 RECODE: SÉRIE - NÃO FREQUENTA ESCOLA */
recode v0610 (9=.)
rename v0610 serie_nao_freq
label var serie_nao_freq "série - não frequenta escola"
* Observação: no primário - v0607==1 - podem existir até 6 séries, e não apenas 4.
*             no médio, primeiro ciclo - v0607==2 - até 5 séries, não apenas 4.
*             no médio, segundo ciclo - v0607==3 - 4 séries, não apenas 3.
*             no segundo grau - v0607==5 - 4 séries, não apenas 3.

/* C.11.7 RECODE: GRAU NÃO FREQÜENTA NA ESCOLA */
generate byte grau_nao_freq = .

if `max' <= 2006 {
	recode v0607 (0=.) 
	recode v0607 (8=7) (9=8) (10=9)
	replace grau_nao_freq = v0607 if ano <= 2006
	drop v0603 v0607
}

if `max' >= 2007 {
	recode v6007 (6=4) (7=5) (8=6) (9=7) (10=8) (11/13=9)
	replace grau_nao_freq = v6007 if ano >= 2007
	drop v6003 v6030 v6007 v6070
}

label var grau_nao_freq "grau - não frequenta"
* grau_nao_freq = 1 elementar (primário)
*               = 2 médio primeiro ciclo (ginasial)
*               = 3 médio segundo ciclo (científico, clássico etc.)
*               = 4 primeiro grau
*               = 5 segundo grau
*               = 6 superior
*               = 7 mestrado/doutorado
*               = 8 alfab de adultos
*               = 9 pré-escolar ou creche
* Os códigos 8 e 9 só existem a partir de 1992.

drop v0604 v0606 v0608 v0609 v0611

/* C.12 CARACTERÍSTICAS DO TRABALHO PRINCIPAL NA SEMANA */
/* C.12.0 DUMMY: TRABALHOU NA SEMANA */
/* A partir de 1992, pergunta-se sobre trabalho na produção para o próprio 
consumo e trabalho na construção para o próprio uso. Por isso, a variável a 
seguir não é perfeitamente compatível com a dos anos 1980 */
recode v9001 (0=.) (3=0), copy g(trabalhou_semana)
label var trabalhou_semana "trabalhou na semana?"
* trabalhou_semana = 1 sim
*                  = 0 não

/* C.12.1 DUMMY: tinha TRABALHO NA SEMANA */
* tinha trabalho na semana, mas estava afastado temporariamente (estava de férias etc.)
g tinha_trab_sem = 0 if trabalhou_semana==0
replace tinha_trab_sem = 1 if v9002 == 2
label var tinha_trab_sem "tinha trabalho na semana?"
* tinha_trab_sem = 1 sim
*               = 0 não
drop v9001 v9002

/* C.12.2 RENAME: OCUPAÇÃO NA SEMANA */
rename v9906 ocup_sem_nova
label var ocup_sem_nova  "ocupação na semana - códigos CBO-Domiciliar"


rename v4810 grupos_ocup_nova 
label var grupos_ocup_nova " ativ/ramo do negócio na semana - códigos CNAE-Domiciliar"
* A partir de 2002, a classificação mudou totalmente. 
* grupos_ocup_nova = 1 dirigentes em geral
*			 = 2 profissionais das ciências e das artes
*			 = 3 técnicos de nível médio
*			 = 4 trabalhadores de serv. administr.
*			 = 5 trabalhadores dos serv.
*			 = 6 vendedores e prestadores de serv. do comércio
*			 = 7 trabalhadores agrícolas
*			 = 8 trabalhadores da prod. de bens e serv. e de reparação e manutenção
*			 = 9 membros das forças armadas e auxiliares
*			 = 10 ocupações mal-definidas ou não declaradas

/* C.12.3 RENAME: ATIVIDADE/RAMOS DO NEGÓCIO */
* v9907 é mais desagregado - códigos variam ao longo do tempo
* v4809 é mais agregado e comum entre os anos das PNAD's

rename v9907 ramo_negocio_sem_nova
label var ramo_negocio_sem "ativ/ramo do negócio na semana - cód. CNAE-Dom"

rename v4809 ramo_negocio_agreg_nova
label var ramo_negocio_agreg_nova "grupos de ativ/ramo do negócio na semana"
* A partir de 2002, a classificação mudou totalmente. 
* ramo_negocio_agreg_nova = 1 agrícola
*                         = 2 outras ativ
*                         = 3 ind. transf.
*                         = 4 constr.
*                         = 5 comércio e reparação
*                         = 6 alojamento e alimentação
*                         = 7 transp., armazenagem e comunicação
*                         = 8 administr. pública
*                         = 9 educação, saúde e serviços sociais
*                         = 10 serv. domésticos
*                         = 11 outros serv. coletivos, sociais e pessoais
*                         = 12 outras ativ.
*                         = 13 ativ. mal definidas ou não-declaradas


/* C.12.4 RECODE: POSIÇÃO NA OCUPAÇÃO NA SEMANA */
* v9008 e v9029 são mais detalhados, mas de difícil compatibilização com as PNAD's dos anos 80
	* foram dropadas	
drop v9008 v9029
* v4706 é mais agregado, e é mais fácil compatibilizar com as PNAD's dos anos 80

recode v4706 (0 14=.) (2/8=1) (9=2) (10=3) (11 12=.) (13=4)
rename v4706 pos_ocup_sem
label var pos_ocup_sem "posição na ocupação na semana"
* Trabalhadores na prod/constr para consumo/uso próprio foram excluídos
* da categoria "empregados", pois não eram considerados assim nas PNAD's dos aos 80.
* pos_ocup_sem = 1 empregado 
*              = 2 conta própria
*              = 3 empregador
*              = 4 não remunerado


/* C.12.5 RECODE: TEM CARTEIRA ASSINADA */
recode v9042 (2=1) (4=0) (9=.)
rename v9042 tem_carteira_assinada
label var tem_carteira_assinada "0-não 1-sim"
* tem_carteira_assinada = 0 não
*                       = 1 sim

/* C.12.6 HORAS TRABALHADAS */

/* HORAS NORMALMENTE TRABALHADAS SEMANA */
recode v9058 (-1 99 0 =.)
replace v9058 = . if tinha_trab_sem == 0 & trabalhou==0
rename v9058 horas_trab_sem
label var horas_trab_sem  "horas normal. trab. sem - ocup. princ"

/* HORAS NORMALMENTE TRABALHADAS - OUTRO TRABALHO */
recode v9101 (-1 99 0 =.)
replace v9101 = . if tinha_trab_sem == 0 & trabalhou==0
rename v9101 horas_trab_sem_outro
label var horas_trab_sem_outro "work hours second job - week"

/* HORAS NORMALMENTE TRABALHADAS TODOS TRABALHOS */
recode v9105 (-1 99=.)
egen horas_trab_todos_trab = rowtotal(horas_trab_sem horas_trab_sem_outro v9105), miss
replace horas_trab_todos_trab = . if tinha_trab_sem == 0 & trabalhou==0
label var horas_trab_todos_trab "horas todos trab"

drop v9105

/* C.13 RENDIMENTOS */

/* C.13.1 RECODE: RENDA MENSAL EM DINHEIRO - TRABALHO PRINCIPAL */
recode v9532 (-1 999999999999=.)
rename v9532 renda_mensal_din 
label var renda_mensal_din "renda mensal dinheiro"

/* C.13.2 RECODE: RENDA MENSAL EM PRODUTOS/MERCADORIAS - TRABALHO PRINCIPAL */
recode v9535 (-1 999999999999=.)
rename v9535 renda_mensal_prod 
label var renda_mensal_prod "renda mensal prod/merc"

/* C.13.3 RECODE: RENDA MENSAL EM DINHEIRO - OUTROS TRABALHOS (SECUNDARIO E DEMAIS TRABALHOS) */
* SOMANDO: 
	* VALOR REND MENSAL EM DIN NO TRAB SECUNDÁRIO
	* VALOR REND MENSAL EM DIN EXCETO PRINC E SECUND
recode v9982 (-1 999999999999=.)
recode v1022 (-1 999999999999=.)
tempvar miss
egen `miss' = rowmiss(v9982 v1022)
egen double renda_mensal_din_outra = rowtotal(v9982 v1022)
replace  renda_mensal_din_outra  = . if `miss'==2
format renda_mensal_din_outra %12.0f
label var renda_mensal_din_outra "renda mensal em dinheiro em outros trabalhos"

/* C.13.4 RECODE: RENDA MENSAL EM PRODUTOS/MERCADORIAS OUTRA */
* SOMANDO:
	* VALOR REND MENSAL EM PROD NO TRAB SECUND
	* VALOR REND MENSAL EM PROD EXCETO PRINC E SECUND
recode v9985 (-1 999999999999=.)
recode v1025 (-1 999999999999=.)
tempvar miss
egen `miss' = rowmiss(v9985 v1025)
egen double renda_mensal_prod_outra = rowtotal(v9985 v1025)
replace  renda_mensal_prod_outra  = . if `miss'==2
format renda_mensal_prod_outra %12.0f
label var renda_mensal_prod_outra "renda mensal em produtos em outrs trabalhos"

/* C.13.5 RECODE: VALOR APOSENTADORIA */
* SOMANDO:
	* VALOR APOSENT DE INST PREV OU DO GOVERNO NO MES
	* REND DE OUTRO TIPO DE APOSENT NO MÊS
recode v1252 (-1 999999999999=.)
recode v1258 (-1 999999999999=.)
gen renda_aposentadoria = v1252+v1258 if v1252 ~= . & v1258 ~= .
replace renda_aposentadoria = v1252 if v1252 ~= . & v1258 == .
replace renda_aposentadoria = v1258 if v1252 == . & v1258 ~= .
label var renda_aposentadoria "rendimento de aposentadoria"

/* C.13.6 RECODE: VALOR PENSÃO */
* SOMANDO:
	* VALOR PENSÃO DE INST PREV OU DO GOVERNO NO MES
	* REND DE OUTRO TIPO DE PENSÃO NO MÊS
recode v1255 (-1 999999999999=.)
recode v1261 (-1 999999999999=.)
gen renda_pensao = v1255+v1261 if v1255 ~= . & v1261 ~= .
replace renda_pensao = v1255 if v1255 ~= . & v1261 == .
replace renda_pensao = v1261 if v1255 == . & v1261 ~= .
label var renda_pensao "rendimento de pensão"

/* C.13.7 RECODE: VALOR ABONO PERMANENTE */
recode v1264 (-1 999999999999=.) 
rename v1264 renda_abono
label var renda_abono "rendimento de abono"

/* C.13.8 RECODE: VALOR ALUGUEL RECEBIDO */
recode v1267 (-1 999999999999=.) 
rename v1267 renda_aluguel
label var renda_aluguel "rendimento de aluguel"

/* C.13.9 RECODE: VALOR OUTRAS */
* SOMANDO:
	* REND DE DOAÇÃO RECEBIDA DE NÃO MORADOR
	* REND DE JUROS E DIVIDENDOS E OUTROS REND
recode v1270 (-1 999999999999=.)
recode v1273 (-1 999999999999=.)
gen renda_outras = v1270+v1273 if v1270 ~= . & v1273 ~= .
replace renda_outras = v1270 if v1270 ~= . & v1273 == .
replace renda_outras = v1273 if v1270 == . & v1273 ~= .
label var renda_outras "valor de outros rendimentos"

/* C.13.10 RECODE: REND MENSAL OCUP PRINCIPAL */
recode v4718 (-1 999999999999=.) 
rename v4718 renda_mensal_ocup_prin
recode renda_mensal_ocup_prin (0=.) if renda_mensal_din == . & renda_mensal_din == .

/* C.13.11 RECODE: REND MENSAL TODOS TRABALHOS */
recode v4719 (-1 999999999999=.) 
rename v4719 renda_mensal_todos_trab
recode renda_mensal_todos_trab (0=.) if renda_mensal_din == . & renda_mensal_din == . ///
& renda_mensal_din_outra == . & renda_mensal_prod_outra == . ///
& v1022 ==. & v1025 == .

/* C.13.12 RECODE: REND MENSAL TODAS FONTES */
recode v4720 (-1 999999999999=.) 
rename v4720 renda_mensal_todas_fontes
recode renda_mensal_todas_fontes (0=.) if renda_mensal_din == . ///
& renda_mensal_prod == . & renda_aposentadoria == . ///
& renda_pensao == . & renda_outras == . & renda_abono == . ///
& renda_aluguel == . 

drop v1022 v1025 v1252 v1255 v1258 v1261 v1270 v1273

/* C.14.1 RECODE: CONTRIBUI INST. PREVID. */
* Apenas para quem tinha trabalho na semana
recode v9059 (3=0) (0 9=.)
replace v9059 = . if tinha_trab_sem == 0 & trabalhou_sem==0
rename v9059 contr_inst_prev
label var contr_inst_prev "contribui p/ instituto de previdência"

/* C.14.2 RENAME: QUAL INST. PREVID. */
recode v9060 (0 9=.)
replace v9060 = . if tinha_trab_sem == 0 & trabalhou_sem==0
rename v9060 qual_inst_prev
* qual_inst_prev = 2 federal
*                = 4 estadual
*                = 6 municipal

/* C.15 RECODE: TINHA OUTRO TRABALHO? */
* Apenas para quem tinha trabalho na semana de referência
recode v9005 (1=0) (3 5=1)
replace v9005 = . if tinha_trab_sem == 0 & trabalhou==0
rename v9005 tinha_outro_trab
label var tinha_outro_trab "tinha outro trabalho/sem?"

/* C.16 PESSOAS QUE NÃO TINHAM TRABALHO NA SEMANA DE REFERÊNCIA */
/*	  MAS TIVERAM OCUPAÇÃO NO PERÍODO DE 12 MESES             */
* A partir da PNAD de 1992, a questão sobre ocupação anterior passa a
* cobrir tanto as pessoas que não tinham trabalho na semana de referência
* quanto aquelas cujo trab na semana de ref não era o principal no período
* de 365 dias.

/* RECODE: TEMPO SEM TRABALHO */
* Esta informação não pode mais ser aferida com precisão a partir dos anos 90.

/* RECODE: TEMPO NA OCUPAÇÃO ANTERIOR */
* A partir da década de 90, esta informação não pode ser obtida para todos os indivíduos.

/* INFORMAÇÕES SOBRE O EMPREGO ANTERIOR */
* COMO NOS ANOS 80 É SIMPLESMENTE O ÚLTIMO TRABALHO
* (DE QUEM NÃO TRABALHOU NA SEMANA DE REFEÊNCIA) 
* AS INFORMAÇÕES SOBRE O TRABALHO ANTERIOR
* DOS ANOS 80 E 90 NÃO SÃO PERFEITAMENTE COMPATÍVEIS.

/* DUMMY: NÃO TRABALHOU NA SEMANA E DEIXOU ÚLTIMO EMPREGO NO ÚLTIMO ANO - 12 MESES OU MENOS */
/*		VARIÁVEL TEMPORÁRIA                                                                      */
recode v9067 (3=0) (0 9=.)
rename v9067 teve_algum_trab_ano
label var teve_algum_trab_ano "teve algum trab no ano"
                                                           
gen tag = 1 if tinha_trab_sem == 0 & teve_algum_trab_ano == 1 

/* C.16.1 GEN: OCUPAÇÃO ANTERIOR, NO ANO */
gen ocup_ant_ano = v9971 if tag == 1
label var ocup_ant_ano "ocupação anterior - no ano"
drop v9971

/* C.16.2 GEN: RAMO ANTERIOR, NO ANO */
gen ramo_negocio_ant_ano = v9972 if tag == 1
label var ramo_negocio_ant_ano "ativ/ramo do negócio anterior - no ano"
drop v9972

/* C.16.3 RECODE: TINHA CARTEIRA ASSINADA NA OCUPAÇÃO ANTERIOR, NO ANO */
gen tinha_cart_assin_ant_ano = v9083 if tag == 1
recode tinha_cart_assin_ant_ano (3=0) (9=.) 
label var tinha_cart_assin_ant_ano "últ emprego - no ano - cart assin"
drop tag v9083

/* C.18.3.6 RECODE: RECEBEU FGTS OCUPAÇÃO ANTERIOR, NO ANO */
* ESSA PERGUNTA NÃO CONSTA DAS PNAD'S DOS ANOS 90

/* C.17 RECODE: TOMOU PROV. PARA CONSEGUIR TRABALHO */
/*	NA SEMANA DE REFERÊNCIA: APENAS QUEM NÃO TINHA TRABALHO NA SEMANA */
replace v9115 = . if tinha_trab_sem == 1
recode v9115 (3=0) (9=.)
rename v9115 tomou_prov_semana
* tomou_prov_semana = 1 sim
*                   = 0 não

/* C.18 RECODE: TOMOU PROV. PARA CONSEGUIR TRABALHO 2 MESES */
/* APENAS QUEM NÃO TINHA TRABALHO NA SEMANA */
replace v9116 = . if tinha_trab_sem == 1
replace v9117 = . if tinha_trab_sem == 1
recode v9116 (2=1) (4=0) (9=.)
recode v9117 (3=0) (9=.)
gen tomou_prov_2meses = 1 if v9116 == 1 | v9117 == 1
replace tomou_prov_2meses = 0 if v9116 == 0 & v9117 == 0
label var tomou_prov_2meses "tomou providência p/ conseguir trab nos últimos 2 meses"
* tomou_prov = 1 sim
*            = 0 não
drop v9116 v9117

/* C.19 RECODE: QUE PROV. TOMOU PARA CONSEGUIR TRABALHO */
* Nas PNAD's dos anos 80, a pergunta é feita apenas para quem respondeu "sim"
* à pergunta anterior (tomou prov. cons. trab - 2 meses)
* Nas PNAD's dos anos 90, a pergunta é sobre a última prov. que tomou, e se aplica a todos os indivíduos.
* Isto é ajustado a seguir.
gen que_prov_tomou = v9119 if trabalhou_semana==0 & tinha_trab_sem==0
recode que_prov_tomou (0=7) (3=2) (7 8=6) (4=3) (5=4) (6=5) (9=.)
label var que_prov_tomou "que providencia tomou para conseguir trabalho"
* que_prov_tomou = 1 consultou empregador
*                                 = 2 fez concurso
*                                 = 3 consultou agência/sindicato
*                                 = 4 colocou anúncio
*                                 = 5 consultou parente
*                                 = 6 outra
*                                 = 7 nada fez
drop v9003 v9004 v9119 teve_algum_trab_ano

/* D. DEFLACIONANDO E CONVERTENDO UNIDADES MONETÁRIAS PARA REAIS */

/* CONVERTENDO OS VALORES NOMINAIS PARA REAIS (UNIDADE MONETÁRIA) */
/* 	E DEFLACIONANDO : 1 = out/2012                                */
gen double deflator = 1  if ano == 2012
format deflator %26.25f
replace deflator    = 0.945350  if ano == 2011
replace deflator    = 0.841309  if ano == 2009
replace deflator    = 0.806540  if ano == 2008
replace deflator    = 0.752722  if ano == 2007
replace deflator    = 0.717917  if ano == 2006
replace deflator    = 0.698447  if ano == 2005
replace deflator    = 0.663870  if ano == 2004
replace deflator    = 0.627251  if ano == 2003
replace deflator    = 0.536898  if ano == 2002
replace deflator    = 1.056364  if ano == 2013
replace deflator    = 1.124668  if ano == 2014
replace deflator    =.  if ano == 2015


label var deflator "deflator - base:out/2012"

gen double conversor = 1

label var conversor "conversor de moedas"

foreach i in din_outra prod_outra ocup_prin todos_trab todas_fontes din prod {
	g renda_`i'_def = (renda_mensal_`i'/conversor)/deflator 
	lab var renda_`i'_def "renda_mensal_`i' deflacionada"
}

foreach i in aposentadoria pensao abono aluguel outras {
	g renda_`i'_def = (renda_`i'/conversor)/deflator
	lab var renda_`i'_def "renda_`i' deflacionada"
}

drop v*
compress

end

************************************************************
**************compat_pess_2002a2009_para_92.ado*************
************************************************************
program define compat_pes_2002a2009_para_92

/* A.1 RECODE: ANO */
* nada a fazer

/* A.2 NÚMERO DE CONTROLE E SÉRIE */

drop v0102 v0103
destring uf, replace

/* B. DATA DE NASCIMENTO */
recode v3031 v3032 (99 =.)
recode v3032 (20 = .)
recode v3033 (min/98 9999 = .)
recode v3031 (0 = .)
cap drop v0408

/* B.2 CARACTERISTICAS DE MIGRACAO */
* OBS: v5062 v0507 v5122: a partir de 2007, nao possui codigo para "ignorado"
recode v5030 v5080 v5090 (99 =.)
recode v0501 v0502 v0504 v0505 v5062 v0507 v0510 v0511 v5122 (9 = .)
recode v5062 v5122 (8 = .)
recode v5064 v5124 (0 = .)

foreach var in v5126 {
	cap drop `var'
}

/* C. VARIÁVEIS DE EDUCAÇÃO */
recode v0601 v0602 v0611 (0 9 = .)

/* C.1 RECODE: ANOS DE ESTUDO */

/* VARIÁVEIS UTILIZADAS PARA 2002 A 2006*/
/* v0602=FREQUENTA ESCOLA OU CRECHE? */
/* v0603=QUAL E O CURSO QUE FREQUENTA? */
/* v0604=ESTE CURSO QUE FREQUENTA E SERIADO? */
/* v0605=QUAL E A SERIE QUE FREQUENTA? */
/* v0606=ANTERIORMENTE FREQUENTOU ESCOLA OU CRECHE? */
/* v0607=QUAL FOI O CURSO MAIS ELEVADO QUE FREQUENTOU ANTERIORMENTE? */
/* v0608=ESTE CURSO QUE FREQUENTOU ANTERIORMENTE ERA SERIADO? */
/* v0609=CONCLUIU,COM APROVACAO,PELO MENOS A PRIMEIRA SERIE DESTE CURSO QUE FREQUENTOU ANTERIORMENTE? */
/* v0610=QUAL FOI A ULTIMA SERIE QUE CONCLUIU,COM APROVACAO,NESTE CURSO QUE FREQUENTOU ANTERIORMENTE? */
/* v0611=CONCLUIU ESTE CURSO QUE FREQUENTOU ANTERIORMENTE? */
/* PARA 2007, 2008 E 2009, EM VEZ DE v0603 E v0607 */
/* v6003=QUAL E O CURSO QUE FREQUENTA? */
/* v6030=QUAL A DURACAO DO ENSINO FUNDAMENTAL QUE FREQUENTA? */
/* v6007=QUAL FOI O CURSO MAIS ELEVADO QUE FREQUENTOU ANTERIORMENTE? */
/* v6070=QUAL A DURACAO DO ENSINO FUNDAMENTAL QUE FREQUENTOU ANTERIORMENTE? */

generate byte anoest = .
quietly summarize v0101
loc min = r(min)
loc max = r(max)

if `min' <= 2006 {
/* 2002 a 2006 */
/* pessoas que ainda freqüentam escola */
	replace anoest =0 if v0602==2 & v0603==1 & v0605==1 & v0101 <= 2006
	replace anoest =1 if v0602==2 & v0603==1 & v0605==2 & v0101 <= 2006
	replace anoest =2 if v0602==2 & v0603==1 & v0605==3 & v0101 <= 2006
	replace anoest =3 if v0602==2 & v0603==1 & v0605==4 & v0101 <= 2006
	replace anoest =4 if v0602==2 & v0603==1 & v0605==5 & v0101 <= 2006
	replace anoest =5 if v0602==2 & v0603==1 & v0605==6 & v0101 <= 2006
	replace anoest =6 if v0602==2 & v0603==1 & v0605==7 & v0101 <= 2006
	replace anoest =7 if v0602==2 & v0603==1 & v0605==8 & v0101 <= 2006

	replace anoest =8 if v0602==2 & v0603==2 & v0605==1 & v0101 <= 2006
	replace anoest =9 if v0602==2 & v0603==2 & v0605==2 & v0101 <= 2006
	replace anoest =10 if v0602==2 & v0603==2 & v0605==3 & v0101 <= 2006
	replace anoest =11 if v0602==2 & v0603==2 & v0605==4 & v0101 <= 2006

	replace anoest =0 if v0602==2 & v0603==3 & v0604==2 & v0605==1 & v0101 <= 2006
	replace anoest =1 if v0602==2 & v0603==3 & v0604==2 & v0605==2 & v0101 <= 2006
	replace anoest =2 if v0602==2 & v0603==3 & v0604==2 & v0605==3 & v0101 <= 2006
	replace anoest =3 if v0602==2 & v0603==3 & v0604==2 & v0605==4 & v0101 <= 2006
	replace anoest =4 if v0602==2 & v0603==3 & v0604==2 & v0605==5 & v0101 <= 2006
	replace anoest =5 if v0602==2 & v0603==3 & v0604==2 & v0605==6 & v0101 <= 2006
	replace anoest =6 if v0602==2 & v0603==3 & v0604==2 & v0605==7 & v0101 <= 2006
	replace anoest =7 if v0602==2 & v0603==3 & v0604==2 & v0605==8 & v0101 <= 2006

	replace anoest =0 if v0602==2 & v0603==3 & v0604==4  & v0101 <= 2006

	replace anoest =8 if v0602==2 & v0603==4 & v0604==2 & v0605==1 & v0101 <= 2006
	replace anoest =9 if v0602==2 & v0603==4 & v0604==2 & v0605==2 & v0101 <= 2006
	replace anoest =10 if v0602==2 & v0603==4 & v0604==2 & v0605==3 & v0101 <= 2006
	replace anoest =11 if v0602==2 & v0603==4 & v0604==2 & v0605==4 & v0101 <= 2006

	replace anoest =8 if v0602==2 & v0603==4 & v0604==4  & v0101 <= 2006

	replace anoest =11 if v0602==2 & v0603==5 & v0605==1 & v0101 <= 2006
	replace anoest =12 if v0602==2 & v0603==5 & v0605==2 & v0101 <= 2006
	replace anoest =13 if v0602==2 & v0603==5 & v0605==3 & v0101 <= 2006
	replace anoest =14 if v0602==2 & v0603==5 & v0605==4 & v0101 <= 2006
	replace anoest =15 if v0602==2 & v0603==5 & v0605==5 & v0101 <= 2006
	replace anoest =16 if v0602==2 & v0603==5 & v0605==6 & v0101 <= 2006

	replace anoest =0 if v0602==2 & v0603==6 & v0101 <= 2006
	replace anoest =0 if v0602==2 & v0603==7 & v0101 <= 2006
	replace anoest =0 if v0602==2 & v0603==8 & v0101 <= 2006
	replace anoest =11 if v0602==2 & v0603==9 & v0101 <= 2006
	replace anoest =15 if v0602==2 & v0603==10 & v0101 <= 2006

/* pessoas que não freqüentam */

	replace anoest =1 if v0602==4 & v0606==2 & v0607==1 & v0609==1 & v0610==1 & v0101 <= 2006
	replace anoest =2 if v0602==4 & v0606==2 & v0607==1 & v0609==1 & v0610==2 & v0101 <= 2006
	replace anoest =3 if v0602==4 & v0606==2 & v0607==1 & v0609==1 & v0610==3 & v0101 <= 2006
	replace anoest =4 if v0602==4 & v0606==2 & v0607==1 & v0609==1 & v0610==4 & v0101 <= 2006
	replace anoest =4 if v0602==4 & v0606==2 & v0607==1 & v0609==1 & v0610==5 & v0101 <= 2006
	replace anoest =4 if v0602==4 & v0606==2 & v0607==1 & v0609==1 & v0610==6 & v0101 <= 2006

	replace anoest =0 if v0602==4 & v0606==2 & v0607==1 & v0609==3 & v0101 <= 2006

	replace anoest =5 if v0602==4 & v0606==2 & v0607==2 & v0608==2 & v0609==1 & v0610==1 & v0101 <= 2006
	replace anoest =6 if v0602==4 & v0606==2 & v0607==2 & v0608==2 & v0609==1 & v0610==2 & v0101 <= 2006
	replace anoest =7 if v0602==4 & v0606==2 & v0607==2 & v0608==2 & v0609==1 & v0610==3 & v0101 <= 2006
	replace anoest =8 if v0602==4 & v0606==2 & v0607==2 & v0608==2 & v0609==1 & v0610==4 & v0101 <= 2006
	replace anoest =8 if v0602==4 & v0606==2 & v0607==2 & v0608==2 & v0609==1 & v0610==5 & v0101 <= 2006

	replace anoest =4 if v0602==4 & v0606==2 & v0607==2 & v0608==2 & v0609==3 & v0101 <= 2006

	replace anoest =8 if v0602==4 & v0606==2 & v0607==2 & v0608==4 & v0611==1 & v0101 <= 2006
	replace anoest =4 if v0602==4 & v0606==2 & v0607==2 & v0608==4 & v0611==3 & v0101 <= 2006

	replace anoest =9 if v0602==4 & v0606==2 & v0607==3 & v0608==2 & v0609==1 & v0610==1 & v0101 <= 2006
	replace anoest =10 if v0602==4 & v0606==2 & v0607==3 & v0608==2 & v0609==1 & v0610==2 & v0101 <= 2006
	replace anoest =11 if v0602==4 & v0606==2 & v0607==3 & v0608==2 & v0609==1 & v0610==3 & v0101 <= 2006
	replace anoest =11 if v0602==4 & v0606==2 & v0607==3 & v0608==2 & v0609==1 & v0610==4 & v0101 <= 2006

	replace anoest =8 if v0602==4 & v0606==2 & v0607==3 & v0608==2 & v0609==3 & v0101 <= 2006

	replace anoest =11 if v0602==4 & v0606==2 & v0607==3 & v0608==4 & v0611==1 & v0101 <= 2006
	replace anoest =8 if v0602==4 & v0606==2 & v0607==3 & v0608==4 & v0611==3 & v0101 <= 2006

	replace anoest =1 if v0602==4 & v0606==2 & v0607==4 & v0608==2 & v0609==1 & v0610==1 & v0101 <= 2006
	replace anoest =2 if v0602==4 & v0606==2 & v0607==4 & v0608==2 & v0609==1 & v0610==2 & v0101 <= 2006
	replace anoest =3 if v0602==4 & v0606==2 & v0607==4 & v0608==2 & v0609==1 & v0610==3 & v0101 <= 2006
	replace anoest =4 if v0602==4 & v0606==2 & v0607==4 & v0608==2 & v0609==1 & v0610==4 & v0101 <= 2006
	replace anoest =5 if v0602==4 & v0606==2 & v0607==4 & v0608==2 & v0609==1 & v0610==5 & v0101 <= 2006
	replace anoest =6 if v0602==4 & v0606==2 & v0607==4 & v0608==2 & v0609==1 & v0610==6 & v0101 <= 2006
	replace anoest =7 if v0602==4 & v0606==2 & v0607==4 & v0608==2 & v0609==1 & v0610==7 & v0101 <= 2006
	replace anoest =8 if v0602==4 & v0606==2 & v0607==4 & v0608==2 & v0609==1 & v0610==8 & v0101 <= 2006

	replace anoest =0 if v0602==4 & v0606==2 & v0607==4 & v0608==2 & v0609==3 & v0101 <= 2006

	replace anoest =8 if v0602==4 & v0606==2 & v0607==4 & v0608==4 & v0611==1 & v0101 <= 2006
	replace anoest =0 if v0602==4 & v0606==2 & v0607==4 & v0608==4 & v0611==3 & v0101 <= 2006

	replace anoest =9 if v0602==4 & v0606==2 & v0607==5 & v0608==2 & v0609==1 & v0610==1 & v0101 <= 2006
	replace anoest =10 if v0602==4 & v0606==2 & v0607==5 & v0608==2 & v0609==1 & v0610==2 & v0101 <= 2006
	replace anoest =11 if v0602==4 & v0606==2 & v0607==5 & v0608==2 & v0609==1 & v0610==3 & v0101 <= 2006
	replace anoest =11 if v0602==4 & v0606==2 & v0607==5 & v0608==2 & v0609==1 & v0610==4 & v0101 <= 2006

	replace anoest =8 if v0602==4 & v0606==2 & v0607==5 & v0608==2 & v0609==3 & v0101 <= 2006

	replace anoest =11 if v0602==4 & v0606==2 & v0607==5 & v0608==4 & v0611==1 & v0101 <= 2006
	replace anoest =8 if v0602==4 & v0606==2 & v0607==5 & v0608==4 & v0611==3 & v0101 <= 2006

	replace anoest =12 if v0602==4 & v0606==2 & v0607==6 & v0609==1 & v0610==1 & v0101 <= 2006
	replace anoest =13 if v0602==4 & v0606==2 & v0607==6 & v0609==1 & v0610==2 & v0101 <= 2006
	replace anoest =14 if v0602==4 & v0606==2 & v0607==6 & v0609==1 & v0610==3 & v0101 <= 2006

	replace anoest =15 if v0602==4 & v0606==2 & v0607==6 & v0609==1 & v0610==4 & v0101 <= 2006
	replace anoest =16 if v0602==4 & v0606==2 & v0607==6 & v0609==1 & v0610==5 & v0101 <= 2006
	replace anoest =17 if v0602==4 & v0606==2 & v0607==6 & v0609==1 & v0610==6 & v0101 <= 2006

	replace anoest =11 if v0602==4 & v0606==2 & v0607==6 & v0609==3 & v0101 <= 2006

	replace anoest =17 if v0602==4 & v0606==2 & v0607==7 & v0611==1 & v0101 <= 2006
	replace anoest =15 if v0602==4 & v0606==2 & v0607==7 & v0611==3 & v0101 <= 2006

	replace anoest =0 if v0602==4 & v0606==2 & v0607==8 & v0101 <= 2006
	replace anoest =0 if v0602==4 & v0606==2 & v0607==9 & v0101 <= 2006
	replace anoest =0 if v0602==4 & v0606==2 & v0607==10 & v0101 <= 2006

	replace anoest =0 if v0602==4 & v0606==4 & v0101 <= 2006
}

if `max' >= 2007 {
/* 2007 a 2009 */
/* pessoas que ainda freqüentam escola */
	replace anoest =0 if v0602==2 & v6003==1 & v6030==1 & v0605==1 & v0101 >= 2007
	replace anoest =1 if v0602==2 & v6003==1 & v6030==1 & v0605==2 & v0101 >= 2007
	replace anoest =2 if v0602==2 & v6003==1 & v6030==1 & v0605==3 & v0101 >= 2007
	replace anoest =3 if v0602==2 & v6003==1 & v6030==1 & v0605==4 & v0101 >= 2007
	replace anoest =4 if v0602==2 & v6003==1 & v6030==1 & v0605==5 & v0101 >= 2007
	replace anoest =5 if v0602==2 & v6003==1 & v6030==1 & v0605==6 & v0101 >= 2007
	replace anoest =6 if v0602==2 & v6003==1 & v6030==1 & v0605==7 & v0101 >= 2007
	replace anoest =7 if v0602==2 & v6003==1 & v6030==1 & v0605==8 & v0101 >= 2007

	replace anoest =0 if v0602==2 & v6003==1 & v6030==3 & v0605==1 & v0101 >= 2007
	replace anoest =0 if v0602==2 & v6003==1 & v6030==3 & v0605==2 & v0101 >= 2007
	replace anoest =1 if v0602==2 & v6003==1 & v6030==3 & v0605==3 & v0101 >= 2007
	replace anoest =2 if v0602==2 & v6003==1 & v6030==3 & v0605==4 & v0101 >= 2007
	replace anoest =3 if v0602==2 & v6003==1 & v6030==3 & v0605==5 & v0101 >= 2007
	replace anoest =4 if v0602==2 & v6003==1 & v6030==3 & v0605==6 & v0101 >= 2007
	replace anoest =5 if v0602==2 & v6003==1 & v6030==3 & v0605==7 & v0101 >= 2007
	replace anoest =6 if v0602==2 & v6003==1 & v6030==3 & v0605==8 & v0101 >= 2007
	replace anoest =7 if v0602==2 & v6003==1 & v6030==3 & v0605==0 & v0101 >= 2007

	replace anoest =8 if v0602==2 & v6003==2 & v0605==1 & v0101 >= 2007
	replace anoest =9 if v0602==2 & v6003==2 & v0605==2 & v0101 >= 2007
	replace anoest =10 if v0602==2 & v6003==2 & v0605==3 & v0101 >= 2007
	replace anoest =11 if v0602==2 & v6003==2 & v0605==4 & v0101 >= 2007

	replace anoest =0 if v0602==2 & v6003==3 & v0604==2 & v0605==1 & v0101 >= 2007
	replace anoest =1 if v0602==2 & v6003==3 & v0604==2 & v0605==2 & v0101 >= 2007
	replace anoest =2 if v0602==2 & v6003==3 & v0604==2 & v0605==3 & v0101 >= 2007
	replace anoest =3 if v0602==2 & v6003==3 & v0604==2 & v0605==4 & v0101 >= 2007
	replace anoest =4 if v0602==2 & v6003==3 & v0604==2 & v0605==5 & v0101 >= 2007
	replace anoest =5 if v0602==2 & v6003==3 & v0604==2 & v0605==6 & v0101 >= 2007
	replace anoest =6 if v0602==2 & v6003==3 & v0604==2 & v0605==7 & v0101 >= 2007
	replace anoest =7 if v0602==2 & v6003==3 & v0604==2 & v0605==8 & v0101 >= 2007

	replace anoest =0 if v0602==2 & v6003==3 & v0604==4  & v0101 >= 2007

	replace anoest =8 if v0602==2 & v6003==4 & v0604==2 & v0605==1 & v0101 >= 2007
	replace anoest =9 if v0602==2 & v6003==4 & v0604==2 & v0605==2 & v0101 >= 2007
	replace anoest =10 if v0602==2 & v6003==4 & v0604==2 & v0605==3 & v0101 >= 2007
	replace anoest =11 if v0602==2 & v6003==4 & v0604==2 & v0605==4 & v0101 >= 2007

	replace anoest =8 if v0602==2 & v6003==4 & v0604==4  & v0101 >= 2007

	replace anoest =11 if v0602==2 & v6003==5 & v0605==1 & v0101 >= 2007
	replace anoest =12 if v0602==2 & v6003==5 & v0605==2 & v0101 >= 2007
	replace anoest =13 if v0602==2 & v6003==5 & v0605==3 & v0101 >= 2007
	replace anoest =14 if v0602==2 & v6003==5 & v0605==4 & v0101 >= 2007
	replace anoest =15 if v0602==2 & v6003==5 & v0605==5 & v0101 >= 2007
	replace anoest =16 if v0602==2 & v6003==5 & v0605==6 & v0101 >= 2007

	replace anoest =0 if v0602==2 & v6003==6 & v0101 >= 2007
	replace anoest =0 if v0602==2 & v6003==7 & v0101 >= 2007
	replace anoest =0 if v0602==2 & v6003==8 & v0101 >= 2007
	replace anoest =0 if v0602==2 & v6003==9 & v0101 >= 2007
	replace anoest =11 if v0602==2 & v6003==10 & v0101 >= 2007
	replace anoest =15 if v0602==2 & v6003==11 & v0101 >= 2007

/* pessoas que não freqüentam */

	replace anoest =1 if v0602==4 & v0606==2 & v6007==1 & v0609==1 & v0610==1 & v0101 >= 2007
	replace anoest =2 if v0602==4 & v0606==2 & v6007==1 & v0609==1 & v0610==2 & v0101 >= 2007
	replace anoest =3 if v0602==4 & v0606==2 & v6007==1 & v0609==1 & v0610==3 & v0101 >= 2007
	replace anoest =4 if v0602==4 & v0606==2 & v6007==1 & v0609==1 & v0610==4 & v0101 >= 2007
	replace anoest =4 if v0602==4 & v0606==2 & v6007==1 & v0609==1 & v0610==5 & v0101 >= 2007
	replace anoest =4 if v0602==4 & v0606==2 & v6007==1 & v0609==1 & v0610==6 & v0101 >= 2007

	replace anoest =0 if v0602==4 & v0606==2 & v6007==1 & v0609==3 & v0101 >= 2007

	replace anoest =5 if v0602==4 & v0606==2 & v6007==2 & v0608==2 & v0609==1 & v0610==1 & v0101 >= 2007
	replace anoest =6 if v0602==4 & v0606==2 & v6007==2 & v0608==2 & v0609==1 & v0610==2 & v0101 >= 2007
	replace anoest =7 if v0602==4 & v0606==2 & v6007==2 & v0608==2 & v0609==1 & v0610==3 & v0101 >= 2007
	replace anoest =8 if v0602==4 & v0606==2 & v6007==2 & v0608==2 & v0609==1 & v0610==4 & v0101 >= 2007
	replace anoest =8 if v0602==4 & v0606==2 & v6007==2 & v0608==2 & v0609==1 & v0610==5 & v0101 >= 2007

	replace anoest =4 if v0602==4 & v0606==2 & v6007==2 & v0608==2 & v0609==3 & v0101 >= 2007

	replace anoest =8 if v0602==4 & v0606==2 & v6007==2 & v0608==4 & v0611==1 & v0101 >= 2007
	replace anoest =4 if v0602==4 & v0606==2 & v6007==2 & v0608==4 & v0611==3 & v0101 >= 2007

	replace anoest =9 if v0602==4 & v0606==2 & v6007==3 & v0608==2 & v0609==1 & v0610==1 & v0101 >= 2007
	replace anoest =10 if v0602==4 & v0606==2 & v6007==3 & v0608==2 & v0609==1 & v0610==2 & v0101 >= 2007
	replace anoest =11 if v0602==4 & v0606==2 & v6007==3 & v0608==2 & v0609==1 & v0610==3 & v0101 >= 2007
	replace anoest =11 if v0602==4 & v0606==2 & v6007==3 & v0608==2 & v0609==1 & v0610==4 & v0101 >= 2007

	replace anoest =8 if v0602==4 & v0606==2 & v6007==3 & v0608==2 & v0609==3 & v0101 >= 2007

	replace anoest =11 if v0602==4 & v0606==2 & v6007==3 & v0608==4 & v0611==1 & v0101 >= 2007
	replace anoest =8 if v0602==4 & v0606==2 & v6007==3 & v0608==4 & v0611==3 & v0101 >= 2007

	replace anoest =1 if v0602==4 & v0606==2 & v6007==4 & v6070==1 & v0609==1 & v0610==1 & v0101 >= 2007
	replace anoest =2 if v0602==4 & v0606==2 & v6007==4 & v6070==1 & v0609==1 & v0610==2 & v0101 >= 2007
	replace anoest =3 if v0602==4 & v0606==2 & v6007==4 & v6070==1 & v0609==1 & v0610==3 & v0101 >= 2007
	replace anoest =4 if v0602==4 & v0606==2 & v6007==4 & v6070==1 & v0609==1 & v0610==4 & v0101 >= 2007
	replace anoest =5 if v0602==4 & v0606==2 & v6007==4 & v6070==1 & v0609==1 & v0610==5 & v0101 >= 2007
	replace anoest =6 if v0602==4 & v0606==2 & v6007==4 & v6070==1 & v0609==1 & v0610==6 & v0101 >= 2007
	replace anoest =7 if v0602==4 & v0606==2 & v6007==4 & v6070==1 & v0609==1 & v0610==7 & v0101 >= 2007
	replace anoest =8 if v0602==4 & v0606==2 & v6007==4 & v6070==1 & v0609==1 & v0610==8 & v0101 >= 2007

	replace anoest =0 if v0602==4 & v0606==2 & v6007==4 & v6070==1 & v0609==3 & v0101 >= 2007

	replace anoest =0 if v0602==4 & v0606==2 & v6007==4 & v6070==3 & v0609==1 & v0610==1 & v0101 >= 2007
	replace anoest =1 if v0602==4 & v0606==2 & v6007==4 & v6070==3 & v0609==1 & v0610==2 & v0101 >= 2007
	replace anoest =2 if v0602==4 & v0606==2 & v6007==4 & v6070==3 & v0609==1 & v0610==3 & v0101 >= 2007
	replace anoest =3 if v0602==4 & v0606==2 & v6007==4 & v6070==3 & v0609==1 & v0610==4 & v0101 >= 2007
	replace anoest =4 if v0602==4 & v0606==2 & v6007==4 & v6070==3 & v0609==1 & v0610==5 & v0101 >= 2007
	replace anoest =5 if v0602==4 & v0606==2 & v6007==4 & v6070==3 & v0609==1 & v0610==6 & v0101 >= 2007
	replace anoest =6 if v0602==4 & v0606==2 & v6007==4 & v6070==3 & v0609==1 & v0610==7 & v0101 >= 2007
	replace anoest =7 if v0602==4 & v0606==2 & v6007==4 & v6070==3 & v0609==1 & v0610==8 & v0101 >= 2007
	replace anoest =8 if v0602==4 & v0606==2 & v6007==4 & v6070==3 & v0609==1 & v0610==0 & v0101 >= 2007

	replace anoest =0 if v0602==4 & v0606==2 & v6007==4 & v6070==3 & v0609==3 & v0101 >= 2007

	replace anoest =9 if v0602==4 & v0606==2 & v6007==5 & v0609==1 & v0610==1 & v0101 >= 2007
	replace anoest =10 if v0602==4 & v0606==2 & v6007==5 & v0609==1 & v0610==2 & v0101 >= 2007
	replace anoest =11 if v0602==4 & v0606==2 & v6007==5 & v0609==1 & v0610==3 & v0101 >= 2007
	replace anoest =11 if v0602==4 & v0606==2 & v6007==5 & v0609==1 & v0610==4 & v0101 >= 2007

	replace anoest =8 if v0602==4 & v0606==2 & v6007==5 & v0609==3 & v0101 >= 2007

	replace anoest =1 if v0602==4 & v0606==2 & v6007==6 & v0608==2 & v0609==1 & v0610==1 & v0101 >= 2007
	replace anoest =2 if v0602==4 & v0606==2 & v6007==6 & v0608==2 & v0609==1 & v0610==2 & v0101 >= 2007
	replace anoest =3 if v0602==4 & v0606==2 & v6007==6 & v0608==2 & v0609==1 & v0610==3 & v0101 >= 2007
	replace anoest =4 if v0602==4 & v0606==2 & v6007==6 & v0608==2 & v0609==1 & v0610==4 & v0101 >= 2007
	replace anoest =5 if v0602==4 & v0606==2 & v6007==6 & v0608==2 & v0609==1 & v0610==5 & v0101 >= 2007
	replace anoest =6 if v0602==4 & v0606==2 & v6007==6 & v0608==2 & v0609==1 & v0610==6 & v0101 >= 2007
	replace anoest =7 if v0602==4 & v0606==2 & v6007==6 & v0608==2 & v0609==1 & v0610==7 & v0101 >= 2007
	replace anoest =8 if v0602==4 & v0606==2 & v6007==6 & v0608==2 & v0609==1 & v0610==8 & v0101 >= 2007

	replace anoest =0 if v0602==4 & v0606==2 & v6007==6 & v0608==2 & v0609==3 & v0101 >= 2007

	replace anoest =8 if v0602==4 & v0606==2 & v6007==6 & v0608==4 & v0611==1 & v0101 >= 2007
	replace anoest =0 if v0602==4 & v0606==2 & v6007==6 & v0608==4 & v0611==3 & v0101 >= 2007

	replace anoest =9 if v0602==4 & v0606==2 & v6007==7 & v0608==2 & v0609==1 & v0610==1 & v0101 >= 2007
	replace anoest =10 if v0602==4 & v0606==2 & v6007==7 & v0608==2 & v0609==1 & v0610==2 & v0101 >= 2007
	replace anoest =11 if v0602==4 & v0606==2 & v6007==7 & v0608==2 & v0609==1 & v0610==3 & v0101 >= 2007
	replace anoest =11 if v0602==4 & v0606==2 & v6007==7 & v0608==2 & v0609==1 & v0610==4 & v0101 >= 2007

	replace anoest =8 if v0602==4 & v0606==2 & v6007==7 & v0608==2 & v0609==3 & v0101 >= 2007

	replace anoest =11 if v0602==4 & v0606==2 & v6007==7 & v0608==4 & v0611==1 & v0101 >= 2007
	replace anoest =8 if v0602==4 & v0606==2 & v6007==7 & v0608==4 & v0611==3 & v0101 >= 2007

	replace anoest =12 if v0602==4 & v0606==2 & v6007==8 & v0609==1 & v0610==1 & v0101 >= 2007
	replace anoest =13 if v0602==4 & v0606==2 & v6007==8 & v0609==1 & v0610==2 & v0101 >= 2007
	replace anoest =14 if v0602==4 & v0606==2 & v6007==8 & v0609==1 & v0610==3 & v0101 >= 2007
	replace anoest =15 if v0602==4 & v0606==2 & v6007==8 & v0609==1 & v0610==4 & v0101 >= 2007
	replace anoest =16 if v0602==4 & v0606==2 & v6007==8 & v0609==1 & v0610==5 & v0101 >= 2007
	replace anoest =17 if v0602==4 & v0606==2 & v6007==8 & v0609==1 & v0610==6 & v0101 >= 2007

	replace anoest =11 if v0602==4 & v0606==2 & v6007==8 & v0609==3 & v0101 >= 2007

	replace anoest =17 if v0602==4 & v0606==2 & v6007==9 & v0611==1 & v0101 >= 2007
	replace anoest =15 if v0602==4 & v0606==2 & v6007==9 & v0611==3 & v0101 >= 2007

	replace anoest =0 if v0602==4 & v0606==2 & v6007==10 & v0101 >= 2007
	replace anoest =0 if v0602==4 & v0606==2 & v6007==11 & v0101 >= 2007
	replace anoest =0 if v0602==4 & v0606==2 & v6007==12 & v0101 >= 2007
	replace anoest =0 if v0602==4 & v0606==2 & v6007==13 & v0101 >= 2007

	replace anoest =0 if v0602==4 & v0606==4 & v0101 >= 2007
}
label var anoest "anos de estudo"



/* C.2 RECODE: SÉRIE QUE FREQÜENTA NA ESCOLA */

if `max' >= 2007 {
* A PARTIR DE 2007, HÁ A POSSIBILIDADE DE O ENSINO FUNDAMENTAL SER EM 9 ANOS
* NESSE CASO, O "PRIMEIRO ANO" EQUIVALE À "CLASSE DE ALFABETIZAÇÃO".
	recode v6003 (1=8) if v6030 == 3 & v0605 == 1
	recode v6007 (4=12) if v6070 == 3 & v0610 == 1
	recode v0605 (1=.) (2=1) (3=2) (4=3) (5=4) (6=5) (7=6) (8=7) (0=8) if v6030 == 3
	recode v0610 (1=.) (2=1) (3=2) (4=3) (5=4) (6=5) (7=6) (8=7) (0=8) if v6070 == 3
}
recode v0605 (9=.)
rename v0605 serie_freq
label var serie_freq "série - frequenta escola"

/* C.3 RECODE: CURSO QUE FREQÜENTA NA ESCOLA */
generate byte curso_freq = .

if `max' <= 2006 {
	recode v0603 (0=.) 
	recode v0603 (8=7) (9=8) (10=9)
	replace curso_freq = v0603 if v0101 <= 2006
}

if `max' >= 2007 {
* EM 2007, SURGIU A CATEGORIA "CLASSE DE ALFABETIZAÇÃO"
* ANTERIORMENTE ELA SE INCLUÍA EM "PRÉ-ESCOLAR OU CRECHE"
	recode v6003 (8 9=7) (10=8) (11=9)
	replace curso_freq = v6003 if v0101 >= 2007
}

label var curso_freq "curso - frequenta escola"
* curso_freq = 1 regular primeiro grau
*           = 2 regular segundo grau
*           = 3 supl primeiro grau
*           = 4 supl segundo grau
*           = 5 superior
*           = 6 alfab de adultos
*           = 7 pré-escolar ou creche
*           = 8 pré-vestibular
*           = 9 mestrado/doutorado


/* C.4 RECODE: SÉRIE - NÃO FREQUENTA ESCOLA */
recode v0610 (9=.)
rename v0610 serie_nao_freq
label var serie_nao_freq "série - não frequenta escola"
* Observação: no primário - v0607==1 - podem existir até 6 séries, e não apenas 4.
*             no médio, primeiro ciclo - v0607==2 - até 5 séries, não apenas 4.
*             no médio, segundo ciclo - v0607==3 - 4 séries, não apenas 3.
*             no segundo grau - v0607==5 - 4 séries, não apenas 3.


/* C.5 RECODE: curso NÃO FREQÜENTA NA ESCOLA */
generate byte curso_nao_freq = .

if `max' <= 2006 {
	recode v0607 (0=.) 
	recode v0607 (8=7) (9=8) (10=9)
	replace curso_nao_freq = v0607 if v0101 <= 2006
	drop v0603 v0607
}

if `max' >= 2007 {
	recode v6007 (6=4) (7=5) (8=6) (9=7) (10=8) (11/13=9)
	replace curso_nao_freq = v6007 if v0101 >= 2007
	drop v6003 v6030 v6007 v6070
}

label var curso_nao_freq "curso - não frequenta"
* curso_nao_freq = 1 elementar (primário)
*               = 2 médio primeiro ciclo (ginasial)
*               = 3 médio segundo ciclo (científico, clássico etc.)
*               = 4 primeiro grau
*               = 5 segundo grau
*               = 6 superior
*               = 7 mestrado/doutorado
*               = 8 alfab de adultos
*               = 9 pré-escolar ou creche


foreach var in v0604 v0606 v0608 v0609 v6002 v6020 v06111 v061111 v06112 v0612 ///
	v4701 v4702 v4801 v4802 {
	cap drop `var'
}


/* D. Valores -1 */
* nada a fazer aqui


/* D. TRABALHO INFANTIL - APENAS PARA 2001 */
replace v0701 = . if v0701==0
replace v0713 = . if v0713 ==99
recode v0711 (9 = .)

rename v7060 v7060_novo
rename v7070 v7070_novo
rename v7090 v7090_novo
rename v7100 v7100_novo

foreach var in v7121 v7123 v7124 v7126 v7127 v7128 v0714 v0715 v0716 {
	cap drop `var'
}


/* E. CARACTERISTICAS DE TRABALHO */

* Recodes
recode v9152 v9154 v9202 v9204 (9000000/max = .)
recode v9008 v9058 v9611 v9612 v9064 v9073 v9861 v9862 v9892 v9101 v9105 ///
	v1091 v1092 (99 =.)
recode v9008 v9073 (88 = .)
recode v9009-v9014 v9016-v9019 v9021-v9052 v9054-v9057 v9059 v9060 v9062 v9063 v9065-v9070 ///
	v9074-v9085 v9087 v9088 v9891 v9092-v9097 v9099 v9100 v9103 v9104 v9106 v9107 v9108 ///
	v9112-v9124 (9 = .)
recode v9001 (0 = .)

drop v9152 v9157 v9162 v9202 v9207 v9212 

cap drop v9921	// horas de afazeres domesticos

/* MUDANÇA NA ORDEM DAS QUESTÕES INICIAIS DA SEÇÃO */
* A partir de 2001, foram invertidas das questoes v9002, v9003 e v9004.
* Antes, perguntava-se primeiro se o individuo havia trabalhado na producao
* para o proprio consumo ou na construcao para o proprio uso. Agora, pergunta-se
* primeiro se o individuo estava afastado de algum trabalho na semana de ref.
* Isso pode alterar quem responde as questoes dependendo dos saltos.

/* E.1 - Trabalhou na produção para próprio consumo */
recode v9003 (3 = 0), g(trab_consumo)
lab var trab_consumo "trab. producao p/ proprio consumo"
* 1 = sim; 0 = nao

/* E.2 - Trabalhou na construção para próprio uso */
recode v9004 (2 = 1) (4 = 0), g(trab_uso)
lab var trab_uso "trab. construcao p/ proprio uso"
* 1 = sim; 0 = nao

/* E.3 - Esteve afastado do trabalho */
recode v9002 (2 = 1) (4 = 0), g(trab_afast)
lab var trab_afast "esteve afastado do trabalho na s.r."
* 1 = sim; 0 = nao

drop v9002-v9004


/* E.4.1 e E.4.2 CONDIÇÃO DE OCUPAÇÃO (na semana e no ano) */
* até 2007, essas variáveis derivadas incluíam crianças menores de 10 anos
* na categoria "ocupados", com exceção de 1996 e 1997, quando não houve
* seção de trabalho com crianças menores de 10 anos. Com isso, 
* a partir de 2007, essa variáveis possuem nomes ligeiramente diferentes.

g cond_ocup_s = .
g cond_ocup_a = .

qui sum v0101
loc min = r(min)
loc max = r(max)

if `max' <= 2006 {
	replace cond_ocup_s = v4705 if v8005>=10
	replace cond_ocup_a = v4714 if v8005>=10
	drop v4714 v4705
}

if `min' < 2007 & `max' > =2007 {
	replace cond_ocup_s = v4805 if v0101>=2007
	replace cond_ocup_a = v4814 if v0101>=2007
	replace cond_ocup_s = v4705 if v8005>=10 & v0101<2007
	replace cond_ocup_a = v4714 if v8005>=10 & v0101<2007
	drop v4714 v4705 v4805 v4814
}

if `min' >= 2007 {
	replace cond_ocup_s = v4805 
	replace cond_ocup_a = v4814 
	drop v4805 v4814
}
recode cond_ocup_s cond_ocup_a (2 = 0)
* 1 = ocupadas; 0 = desocupadas
lab var cond_ocup_s "condicao de ocupação na semana"
lab var cond_ocup_a "condicao de ocupação no ano"


/* E.5 POSICAO NA OCUPACAO */
* A partir de 2007, as 'posicoes' foram encerradas: o 'empregado sem declaracao 
* de carteira' de trabalho, e o 'trabalhador domestico sem declaracao de carteira',
* provavelmente incorporados aos empregados e trabalhadores domesticos sem carteira,
* respectivamente; as demais posicoes permaneceram inalteradas

recode v4706 (5 = 4) (8 = 7) (14=.)
recode v4715 (5 = 4) (8 = 7) (14=.)

/* E.6 ATIVIDADE PRINCIPAL DO EMPREENDIMENTO do trab principal */
* A partir de 2001, essas variáveis incluem criancas menores de 10 anos

g ativ_semana = v4808 if v8005>=10
g ativ_ano = v4812 if v8005>=10

lab var ativ_semana "tipo de atividade na semana"
lab var ativ_ano "tipo de atividade no ano"

drop v4808 v4812

/* E.7 CODIGOS DE OCUPACAO E ATIVIDADE */ 
* codigos de ocupacao e atividade: a partir de 2002, sao usados CBO e CNAE

rename v9906 v9906_novo 
rename v9971 v9971_novo
rename v9907 v9907_novo 
rename v9972 v9972_novo 
rename v9910 v9910_novo 
rename v9911 v9911_novo
rename v9990 v9990_novo 
rename v9991 v9991_novo

foreach var in v9151 v9153 v9155 v9156 v9158 v9160 v9161 v9163 v9165 v9201 v9203 ///
	v9205 v9206 v9208 v9210 v9211 v9213 v9215 v9531 v9533 v9534 v90531 v90532 v90533 v9536 v9537 v9981 ///
	v9983 v9984 v9986 v9987 v1021 v1023 v1024 v1026 v1027 v1028 v1251 v1253 v1254 ///
	v1256 v1257 v1259 v1260 v1262 v1263 v1265 v1266 v1268 v1269 v1271 v1272 v1274 ///
	v1275 v9126 {
	cap drop `var'
}


/* F. FECUNDIDADE */
foreach var in v1101 v1141 v1142 v1151 v1152 v1153 v1154 v1161 v1162 ///
		v1163 v1164 v1107 v1181 v1182 v1109 v1110 v1111 v1112 v1113 v1114 {
	replace `var' = . if v8005<15
	rename `var' `var'c
}
recode v1182c (999 9999 = .)
recode v1141c v1142c v1151c v1152c v1161c v1162c v1181c v1182c ///
	v1111c v1112c (99 =.)
recode v1107c v1109c v1110c (9 = .)
recode v1101c (0 = .)

foreach var in v1115 {
	cap drop `var'
}

/* DEFLACIONANDO E CONVERTENDO UNIDADES MONETÁRIAS PARA REAIS */

/* CONVERTENDO OS VALORES NOMINAIS PARA REAIS (UNIDADE MONETÁRIA) */
/* 	E DEFLACIONANDO : 1 = out/2012                                */
gen double deflator = 1  if v0101 == 2012
format deflator %26.25f
replace deflator    = 0.945350  if v0101 == 2011
replace deflator    = 0.841309  if v0101 == 2009
replace deflator    = 0.806540  if v0101 == 2008
replace deflator    = 0.752722  if v0101 == 2007
replace deflator    = 0.717917  if v0101 == 2006
replace deflator    = 0.698447  if v0101 == 2005
replace deflator    = 0.663870  if v0101 == 2004
replace deflator    = 0.627251  if v0101 == 2003
replace deflator    = 0.536898  if v0101 == 2002
replace deflator    = 1.056364  if v0101 == 2013
replace deflator    = 1.124668  if v0101 == 2014
replace deflator    = .  if v0101 == 2015


label var deflator "deflator - base:out/2012"  

gen double conversor = 1

label var conversor "conversor de moedas"

foreach name in v9532 v9535 v9982 v9985 v1022 v1025 v1252 v1255 v1258 v1261 ///
		v1264 v1267 v1270 v1273 v7122 v7125 v4718 v4719 v4720 v4721 v4722 v4726 {
	cap replace `name' = . if `name'>10^10
	cap g `name'def = (`name'/conversor)/deflator
	cap lab var `name'def "`name' deflacionada"
}


/* OUTROS RECODES */

cap recode v4703 (17 = .)
cap recode v4803 (17 = .)
cap rename v4803 v4703

recode /* cor */ v0404 /* mãe */ v0405 v0406 (9 = .)

recode /* idade */ v8005 (999 =.)

/* grupos de anos de estudo */ 
cap rename v4838 v4738
replace v4738 = . if v8005<10

/* Condição de atividade na semana - não se aplica ou não declarado */
replace v4704 = . if v4704 == 3
/* Horas trabalhadas - não se aplica ou não declarado */
replace v4707 = . if v4707 == 6
/* Horas trabalhadas - não se aplica ou não declarado */
replace v4711 = . if v4711 == 3
/* Horas trabalhadas - não se aplica ou não declarado */
replace v4713 = . if v4713 == 3


/* OUTROS DROPS */ 

foreach var in v4111 v4112 v0408 v0409 v0410 v4011 v0411 v0412 v4735 v6502 v4740 ///
	v4741 v4742 v4743 v4744 v4745 v4746 v4747 v9993 v9993b v4748 v4749 v4750 {
	cap drop `var'
}


/* K. SUPLEMENTOS */
cap drop /* programas sociais */ v1801 -v1804 /* saude/ mobilidade fisica */ v1701-v1409 // 2003
cap drop /* educacao */ v1901 -v1910 // 2004
cap drop /* internet */ v2201 -v2223 // 2005
cap drop /* educacao */ v1901-v1912 /* trabalho 5-17 */  v2301-v2312	// 2006
cap drop /* EJA e educ profissional */ v2500-v2656	// 2007
cap drop /* tabagismo */ v2701-v2791 SELEC PESPET v2801-v2814 /* internet */ v2201-v22006 /* saude, mobilidade */ v1701-v1417 // 2008
cap drop /* vitimizacao */ v2901-v2929

end
