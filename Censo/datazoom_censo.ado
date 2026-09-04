******************************************************
*					datazoom_censo.ado				 *
******************************************************
* version 1.4
program define datazoom_censo

syntax, years(numlist) ufs(str) original(str) saving(str) [comp pes fam dom both all english dbf91 dattxt91 csv22 txt22]

* `years' é lista de anos a extrair 
* `ufs' são as unidades da federação
* `original' são as pastas dos arquivos de microdados brutos
* `saving' é a pasta para salvar as novas bases
* `comp' especifica que será feita a compatibilização.
* `pes' indica arquivo de pessoas
* `dom' indica arquivo de domicilios
* `fam' indica arquivo de família, disponível apenas para o ano 2000
* `both' indica arquivo de domicilios e pessoas merged
* `all' indica arquivo de domicilios, pessoas e família merged para o ano 2000
* `english' indica labels das variáveis em inglês
* `dbf91' indica que o formato de dados originais usados é dbf para o ano de 1991
* `dattxt91' indica que o formato de dados originais usados é dat ou txt para o ano de 1991
* `csv22' indica que o formato de dados originais usados é csv para o ano de 2022
* `txt22' indica que o formato de dados originais usados é txt para o ano de 2022
 
 display as result _newline "Tipo(s) de Registro:"
if "`pes'"~="" display as result " Pessoas"
if "`dom'"~="" display as result " Domicílios"
if "`fam'"~="" display as result " Famílias (2000)"
if "`both'"~="" {
	loc pes "pes"
	loc dom "dom"
	display as result " Domicílios e Pessoas"
}
if "`all'"~="" {
	loc pes "pes"
	loc dom "dom"
	loc fam "fam"
	display as result "Pessoas, Famílias e Domicílios (2000)"
}

/* Pastas para guardar arquivos da sessão */
cd `"`saving'"'

load_censo, years(`years') ufs(`ufs') original(`original') `comp' `pes' `fam' `dom' `both' `all' `english' `dbf91' `dattxt91'

end

program load_censo
syntax, years(numlist) ufs(str) original(str) [comp pes fam dom both all english dbf91 dattxt91]

if "`english'" != "" local lang "_en"

/* Listas de nomes das UFs (como são passados na opção `ufs'), respectivos códigos IBGE */
/* e sufixos dos arquivos de microdados correspondentes em cada ano.                    */
local nomesUFs =  "RO AC AM RR PA AP TO FN MA PI CE RN PB PE AL SE BA MG ES RJ GB SP PR SC RS MS MT GO DF"
local codUFs   =  "11 12 13 14 15 16 17 20 21 22 23 24 25 26 27 28 29 31 32 33 34 35 41 42 43 50 51 52 53"
local suf1970  = `"RO AC AM RR PA AP "" FN MA PI CE RN PB PE AL SE BA MG ES RJ GB SP PR SC RS "" MT GO DF"'
*local suf1980  = `"11 12 13 14 15 16 "" "" 20 21 22 23 24 25 26 27 28 29 "31A 31B" 32 "33A 33B" "" "35 35B 35C" 41 42 43 50 51 52 53"'
local suf1980  =  `"RO AC AM RR PA AP "" FN MA PI CE RN PB PE AL SE BA MG ES RJ "" SP PR SC RS MS MT GO DF"'
local suf1991  = `"U11 U12 U13 U14 U15 U16 U17 "" U21 U22 U23 U24 U25 U26 U27 U28 U29 U31 U32 U33 "" "P35 P36" U41 U42 U43 U50 U51 U52 U53"'
local suf1991dbf = `"11 12 13 14 15 16 17 "" 21 22 23 24 25 26 27 28 29 31 32 33 "" 35 41 42 43 50 51 52 53"'
local suf2000  = `"11 12 13 14 15 16 17 "" 21 22 23 24 25 26 27 28 29 31 32 33 "" 35 41 42 43 50 51 52 53"'
local suf2010  = `"11 12 13 14 15 16 17 "" 21 22 23 24 25 26 27 28 29 31 32 33 "" "35_outras 35_RMSP" 41 42 43 50 51 52 53"'
local suf2022  = `"11 12 13 14 15 16 17 "" 21 22 23 24 25 26 27 28 29 31 32 33 "" 35 41 42 43 50 51 52 53"' // esse eh do publico, checar se tem mudancas para os dados privados (ex: 2 arquivos pra sp)
* local suf2022_privado  = `"11 12 13 14 15 16 17 "" 21 22 23 24 25 26 27 28 29 31 32 33 "" 35 41 42 43 50 51 52 53"' // se tiver MUDANCAS do publico pro privado *

foreach ano in `years' {
	if `ano' == 1970 {
		if "`fam'" != "" {
						di as err "Opção Família não disponível para o ano `ano'"
						exit
						}
		foreach UF in `ufs' {
			/* Achando posição da UF nas listas: */
			local pos = 1
			while word(`"`nomesUFs'"', `pos') != "`UF'" {
				local pos = `pos' + 1
			}
			/* Loop para todos os arquivos da UF                              */
			/* Transforma os conjuntos de sufixos "tokens" e pega o pos-ésimo */
			tokenize `suf1970'
			local sufixos = "``pos''"
			/* Mesmo para o código */
			tokenize `codUFs'
			local codUF = "``pos''"
			foreach suf in `sufixos' {
				/* Abrindo arquivo e gerando variável UF, inexistente em 1970  */
				/* Em 1970 abrir "quietly porque tem um monte de "-" (dá erro) */
				display as input "Extraindo `ano' `UF' - `suf' ..."
				
				tempfile dic
				local dic "`dic'.dct"

				findfile dict.dta

				read_compdct, compdct("`r(fn)'") dict_name("censo`ano'`lang'") out("`dic'")
				
				quietly infile using `dic', using("`original'/DAMO70`suf'.txt") clear
				
				* resolvendo problema nos dados originais: caracteres nao numericos e/ou primeiro digito
				* da var v001 diferente do cod70.
				tempvar d1 d2 d3 d4 d5 d6
				g `d1' = substr(v001,1,1)
				g `d2' = substr(v001,2,1)
				g `d3' = substr(v001,3,1)
				g `d4' = substr(v002,1,1)
				g `d5' = substr(v002,2,1)
				g `d6' = substr(v002,3,1)
				forval n=1/6 {
					drop if `d`n''~="0" & `d`n''~="1" & `d`n''~="2" & `d`n''~="3" & `d`n''~="4" & ///
						`d`n''~="5" & `d`n''~="6" & `d`n''~="7" & `d`n''~="8" & `d`n''~="9"
				}
				if "`UF'"=="RJ" drop if `d1'~="5"
				if "`UF'"=="PB" drop if `d1'~="2"

				gen ano = 1970
				lab var ano "ano da pesquisa"
				gen UF = `codUF'
				lab var UF "unidade da federação"
				
				/* Gera identificacao do domicilio, da familia e numero de ordem das pessoas */
				destring v007 v008 v009, replace force
				gen long id_dom = sum(((v006 == 1 | v006 == 2) & v025 == 1) | /// chefe
                      (v007 == 1 & v007[_n-1] == 0) | /// dom particular -> coletivo
                      (v006 == 0 & v006[_n-1] ~= 0 & v007[_n-1] ~= 1) /// idem
						)
				tostring id_dom, replace
				lab var id_dom "identificação do domicílio"
				sort id_dom, stable
				bys id_dom: gen int num_fam = sum(v025==1) if (v006>=1 & v006<=4)
				lab var num_fam "número da família"
				gsort UF id_dom num_fam v025 -v027
				bys UF id_dom: g ordem = _n
				lab var ordem "número de ordem" 				
				
				/* Gera codigo do municipio em 1970 para trazer o codigo atual do municipio */ 
				tempvar x
				g `x' = substr(v002,2,.)
				egen cod70 = concat(v001 `x')
				lab var cod70 "municipalities'codes in 1970"
				drop __*

				findfile cod1970.dta
				merge m:1 cod70 using `"`r(fn)'"', nogen keep(match) keepus(munic)
				
				local base ""
				if "`comp'" != "" {
					if "`both'"~="" {
						global x "pes dom"
						compat_censo70					/* Compatibiliza, se especificado */
						order ano -ordem 
						
						tempfile _comp
						save `_comp', replace
						local base "`base' _comp"
					}
					else {
						if "`pes'"~="" {
							global x "pes"
							preserve
							compat_censo70
							drop v004-v021 peso_dom
							order ano -ordem
							
							tempfile _pes_comp
							save `_pes_comp', replace
							local base "`base' _pes_comp"
							restore
						}
						else {
							global x "dom"
							compat_censo70
							keep ano UF regiao cod70 id_dom n_pes_dom n_homem_dom n_mulher_dom sit_setor_C ///
								especie dom_pago cond_ocup aluguel_70 abast_agua sanitario tipo_esc_san ilum_eletr fogao ///
								comb_fogao radio geladeira televisao automov_part tot_comodos tot_dorm peso_dom ordem munic
							keep if especie == 0 & ordem==1			// manter apenas domicilios permanentes
							drop ordem
							order ano UF regiao cod70 id_dom 
							tempfile _dom_comp
							save `_dom_comp', replace
							local base "`base' _dom_comp"
						}
					}
					/* Áreas Mínimas Comparáveis */
					foreach n of local base {
						use ``n'', clear
						findfile amcs.dta
						merge m:1 munic using `"`r(fn)'"', nogen keep(match)

						save CENSO70_`UF'`n', replace
					}

				}
				else {
					if "`both'"~="" {
						order ano-ordem
						save CENSO70_`UF', replace
					}
					else {
						if "`pes'"~="" {
							preserve
							drop v004-v021
							order ano-ordem
							save CENSO70_`UF'_pes, replace
							restore
						}
						else {
							keep ano-num_fam v001-v021 v054 ordem
							keep if v007==0 & (v008==0 | v008==1) & ordem==1	// manter apenas domicilios permanentes
							drop ordem
							order ano-num_fam
							
							save CENSO70_`UF'_dom, replace
						}
					}
				}
			}
		}
	}
	else if `ano' == 1980 {
	
		if "`fam'" != "" {
						di as err "Opção Família não disponível para o ano `ano'"
						exit
						}
		

		foreach UF in `ufs' {
			/* Achando posição da UF nas listas: */
			local pos = 1
			while word(`"`nomesUFs'"', `pos') != "`UF'" {
				local pos = `pos' + 1
			}
			 /* Loop para todos os arquivos da UF                              */
			 /* Transformo os conjuntos de sufixos "tokens" e pego o pos-ésimo */
			tokenize `suf1980'
			local sufixos = "``pos''"
			/* Mesmo para o código */
			tokenize `codUFs'
			local codUF = "``pos''"
			di "`sufixos'"
			foreach suf in `sufixos' {
				display as input "Extraindo `ano' `UF' - `suf' ..."
				/* Abrindo arquivo           */
				
				tempfile dic
				local dic "`dic'.dct"

				findfile dict.dta

				read_compdct, compdct("`r(fn)'") dict_name("censo`ano'`lang'") out("`dic'")
				
				capture infile using `dic', using("`original'/AMO80.UF`suf'.txt") clear
				if _rc == 601 {
				/* Abrindo arquivo se em formato dbf */					
					
					/* Definindo um arquivo temporário */
					tempfile step_to_merge
					import dbase "`original'\CD80DOM`codUF'.dbf", clear
					rename *, lower
					rename contadom ndom
					save `step_to_merge', replace
					
					/* Abrindo outro arquivo*/
					import dbase "`original'\CD80PES`codUF'.dbf", clear
					rename *, lower
					
					/* Merge de fato */
					merge m:1 uf munic ndom using `step_to_merge', nogen keep(match)
						
					/* Renomeando as variáveis */
					// Arquivo em formato dbf não contém as variáveis distrito(v6), número de ordem(v500), situação da pessoa (v598) e uf do mun que morava anteriormente (v518)
					qui rename uf v2
					qui rename munic v5
					cap qui tostring v5, format(%04.0f) replace
					drop ndom // var ndom não existia em formato anterior (txt)
					qui rename situacao v198
					qui rename especie v201
					qui rename tipo v202
					qui rename paredes v203
					qui rename piso v204
					qui rename cobertur v205
					qui rename agua v206
					qui rename sanescoa v207
					qui rename sanuso v208
					qui rename condocup v209
					qui rename aluguel v602
					qui rename tpresid v211
					qui rename comodos v212
					qui rename comodor v213
					qui rename fogao v214
					qui rename combcozi v215
					qui rename telefone v216
					qui rename ilumina v217
					qui rename radio v218
					qui rename geladeir v219
					qui rename tv v220
					qui rename automove v221
					qui rename pesod v603
					qui rename pesop v604 
					qui rename sexo v501
					qui rename parendom v503
					qui rename parenfam v504
					qui rename familia v505
					qui rename religiao v508
					qui rename cor v509
					qui rename maeviva v510
					qui rename minacion v511
					qui rename miufnasc v512
					qui rename minascmu v513
					qui rename mimumozn v514
					qui rename miantezn v515
					qui rename mitempuf v516
					qui rename mitempmu v517
					qui rename edsabele v519
					qui rename edserie v520
					qui rename edgrau v521
					qui rename edcursns v522
					qui rename edulseri v523
					qui rename edulgrau v524
					qui rename edcurstp v525
					qui rename estconj v526
					qui rename tmuntrab v527
					qui rename trul12m v528
					qui rename tsitdeso v529
					qui rename tocupaca v530
					qui rename tativida v532
					qui rename tposicao v533
					qui rename tprevid v534
					qui rename thortrab v535
					qui rename thortrto v536
					qui rename rprindin v607
					qui rename rprinprm v608
					qui rename routrocu v609
					qui rename tqtsalar v540
					qui rename tsitulsn v541
					qui rename toutraoc v542
					qui rename toutraat v544
					qui rename toutrapo v545
					qui rename raposent v610
					qui rename raluguel v611
					qui rename rdoacoes v612
					qui rename rcapital v613
					qui rename flnavivh v550
					qui rename flnavivm v551
					qui rename flnamorh v552
					qui rename flnamorm v553
					qui rename flvivosh v554
					qui rename flvivosm v555
					qui rename fluvimes v556
					qui rename fluviano v557
					qui rename idademes v605
					qui rename idadeano v606
					qui rename fluvidad v570
					qui rename rprincif v680
					qui rename rtotalf  v681
					qui rename rtotocuf v682
					gen v6 = .
					gen v500 = .
					gen v598 = .								// Não existe na última versão do Censo 80
					replace v598 = 1 if (v198 == 1 |v198 == 3) // Cidade ou vila ou Área urbana isolada
					replace v598 = 0 if (v198 == 5 |v198 == 7) // Aglomerado rural ou zona rural 
					gen v518 = .
					destring, replace
					}					
				}	
				cap gen ano = 1980
				lab var ano "ano da pesquisa"
				qui tostring v5, format(%04.0f) replace
				cap egen munic = concat(v2 v5)
				destring munic, replace
				lab var munic "municipality codes without DV (6 digits)"

				local base ""
				if "`comp'" != "" { 				
					if "`both'"~="" {
						global x "pes dom"
						
							
						compat_censo80					/* Compatibiliza, se especificado */
										
						drop v503
						tempfile _comp
										
						save `_comp', replace
									
						local base "`base' _comp"
					}
					else {
						if "`pes'"~="" {
							global x = "pes"
							preserve
							compat_censo80
							drop v201-v603 v503 v598

							tempfile _pes_comp
							save `_pes_comp', replace
							local base "`base' _pes_comp"
							restore
						}
						else {
							global x = "dom"
							compat_censo80
							drop  v500 v604 v501 v505- v570 num_fam
							keep if especie == 0 & v503==1		// manter apenas domicilios permanentes
							drop v503
							order ano UF regiao munic id_dom
							tempfile _dom_comp
							save `_dom_comp', replace
							local base "`base' _dom_comp"
						}
					}
					
										
					/* Áreas Mínimas Comparáveis */
					foreach n of local base {
						use ``n'', clear
						findfile amcs.dta
						sort munic		
						merge m:1 munic using `"`r(fn)'"', nogen keep(match)
						save CENSO80_`UF'`n', replace
					}
				}
				else {
					if "`both'"~="" {
						save CENSO80_`UF', replace
					
					}
					else {
						if "`pes'"~="" {
							preserve
							drop v198 v201-v602 v212-v221 v603
							save CENSO80_`UF'_pes, replace
							restore
						}
						else {
							keep v2-v6 v198 v201-v602 v212-v221 v503 v598 v603
							keep if v201 == 1 & v503==1					// manter apenas domicilios permanentes
							drop v503
							save CENSO80_`UF'_dom, replace
						}
					}
				}
			}
		}
	
	else if `ano' == 1991 {
	
		if "`fam'" != "" {
						di as err "Opção Família não disponível para o ano `ano'"
						exit
						}
		
		if "`dbf91'" != "" & "`dattxt91'" == "" {
							di as text "Formato selecionado dos microdados originais do Censo 1991: DBF"
							
							foreach UF in `ufs' {
								/* Achando posição da UF nas listas: */
								local pos = 1
								while word(`"`nomesUFs'"', `pos') != "`UF'" {
									local pos = `pos' + 1
								}
								/* Loop para todos os arquivos da UF                              */
								/* Transformo os conjuntos de sufixos "tokens" e pego o pos-ésimo */
								tokenize `suf1991dbf'
								local sufixos = "``pos''"
								/* Mesmo para o código */
								tokenize `codUFs'
								local codUF = "``pos''"
								di "`sufixos'"
								foreach suf in `sufixos'{
									display as input "Extraindo `ano' `UF' - `suf' ..."	
									capture import dbase using "`original'/CD91AMOUP`suf'.DBF", clear 
									if _rc == 601 {
									di as err "Erro para encontrar o arquivo original indicado. Confira se:"
									di as err "O arquivo original se encontra no formato selecionado (nesse caso, DBF);"
									di as err "O arquivo original está com o nome que vem quando é baixado pelo IBGE"
									di as err "O arquivo original é acessado diretamente da pasta designada (não deve haver pastas intermediárias até o arquivo original)"
									exit
										}
									egen munic = concat(UFNUM MUNICNUM)
									destring munic, replace
									lab var munic "municipality codes without DV (6 digits)"
									
									if "`english'" != ""{
															label variable UFNOM      "State Name"
															label variable UFNUM      "State Code"
															label variable MESONOM    "Name of the Mesoregion"
															label variable MESONUM    "Mesoregion Code"
															label variable MICRONOM   "Name of the Microregion"
															label variable MICRONUM   "Microregion Code"
															label variable MUNICNOM   "Municipality Name"
															label variable METROP     "Metropolitan Area Code"
															label variable MUNICNUM   "Municipality Code"
															label variable SITSET     "Sector Status"
															label variable DOMICIL    "Household"
															label variable AGUA       "Water supply"
															label variable ALUGUEFX   "Rent range"
															label variable ALUGUEL    "Monthly rent"
															label variable ASPIRPO    "Vacuum cleaner"
															label variable AUTPART    "Personal car"
															label variable AUTTRAB    "Car for work"
															label variable BANHEIRO   "Number of Bathrooms"
															label variable CD107      "House number in CD107"
															label variable COBERTUR   "Penthouse"
															label variable COMBCOZI   "Fuel used for cooking"
															label variable COMODOR    "Rooms used as bedrooms"
															label variable COMODOS    "Total number of rooms"
															label variable CONDOCUP   "Occupancy Status"
															label variable DEMOCOFX   "Resident density per room"
															label variable DEMOCOMO   "Density per living space"
															label variable DEMODOFX   "Resident density per bedroom range"
															label variable DEMODORM   "Density of residents per bedroom"
															label variable ESPECIE    "Type of household"
															label variable FILTRO     "Water filter"
															label variable FREEZER    "Freezer"
															label variable GELADEIR   "Refrigerator"
															label variable ILUMINA    "Lighting"
															label variable LIXO       "Garbage disposal"
															label variable LOCALIZA   "Location"
															label variable MAQLAVAR   "Washing machine"
															label variable PAREDES    "Walls"
															label variable PESO       "Expansion weight"
															label variable RADIO      "Radio"
															label variable RDOMICIV   "Household income"
															label variable RDONOMIF   "Nominal household income range"
															label variable RDOREALF   "Actual income range"
															label variable SANESCOA   "Sanitary Facilities - Drainage"
															label variable SANUSO     "Sanitation Facilities - Use"
															label variable TELEFONE   "Phone"
															label variable TVCORES    "Color TV"
															label variable TVPRETO    "Black-and-white TV"
															label variable FAMILIA    "Family"
															label variable ESPFAM     "A sort of family"
															label variable NUMFAM     "Family to which it belongs"
															label variable RFACHCAF   "Nominal couple income bracket"
															label variable RFACHCAV   "Couple's income"
															label variable RFAMILIV   "Family income"
															label variable RFANOMIF   "Nominal family income bracket"
															label variable RFAPCAPF   "Nominal per capita income bracket"
															label variable RFAPCAPV   "Per capita household income"
															label variable RFAREALF   "Actual family income bracket"
															label variable PESSOA     "Individual"
															label variable APOPENS    "Retiree and/or pensioner"
															label variable ATIVIDAD   "Activity Code"
															label variable ATIVISET   "Industry Sector"
															label variable CARTASS    "Has a formal employment contract"
															label variable CONPREV    "Social Security Contributor"
															label variable DEFICIE    "Disability"
															label variable EDANOEST   "Years of schooling"
															label variable EDCURSNS   "Non-sequential course"
															label variable EDCURSO    "Course Completed"
															label variable EDGRAU     "Current degree program"
															label variable EDSABELE   "Can read and write"
															label variable EDSERIE    "Grade level"
															label variable EDULGRAU   "Grade Level of the Final Grade"
															label variable EDULSERI   "Highest grade completed"
															label variable EMPESTB    "Number of employees at the establishment"
															label variable FLDOMICH   "Children live at home - man"
															label variable FLDOMICM   "Daughters living at home—woman"
															label variable FLMORTOH   "Deceased sons—male"
															label variable FLMORTOM   "Deceased daughters—woman"
															label variable FLNAMORH   "Stillborn sons - man"
															label variable FLNAMORM   "Stillborn daughters - woman"
															label variable FLNAMORT   "Total stillborn sons"
															label variable FLNAODOH   "Children do not live at this address"
															label variable FLNAODOM   "Daughters do not live at the address"
															label variable FLNAVIVH   "Live-born sons - male"
															label variable FLNAVIVM   "Daughters born alive - female"
															label variable FLNAVIVT   "Total live-born sons"
															label variable FLTIDOSH   "Sons fathered - male"
															label variable FLTIDOSM   "Daughters raised—woman"
															label variable FLTIDOST   "Total children born"
															label variable FLVIVOSH   "Living children - man"
															label variable FLVIVOSM   "Living daughters - woman"
															label variable FLVIVOST   "Total living children"
															label variable HOROUTR    "Hours worked in other occupations"
															label variable HORTRAB    "Hours worked in occupation Q346"
															label variable IDADEANO   "Age in years"
															label variable IDADEMES   "Age in months"
															label variable IDADETIP   "Age category"
															label variable LOCTRAB    "Workplace"
															label variable MIANMOMU   "Years living in the municipality"
															label variable MIANMOUF   "Years living in the state"
															label variable MIANORES   "Year of taking up residence"
															label variable MIANTEMU   "Previous city of residence"
															label variable MIANTEUF   "Previous place of residence"
															label variable MIANTEZN   "Previous residential area"
															label variable MIMO86MU   "Municipality of residence in 1986"
															label variable MIMO86UF   "Place of residence as of 09/01/86"
															label variable MIMO86ZN   "Residential area in 1986"
															label variable MIMUMOZN   "Neighborhood where you lived in this municipality"
															label variable MINACION   "Nationality"
															label variable MINASCMU   "Born in this municipality"
															label variable MIUFPAIS   "State/Country of birth"
															label variable MIULTMUD   "Last change"
															label variable NORDMAE    "Mother's order number"
															label variable OCUPACAO   "Primary occupation"
															label variable OCUPAGRP   "Primary occupation group"
															label variable PARENDOM   "Relationship to the head of household"
															label variable PARENFAM   "Relationship to the head of the household"
															label variable PESSOAN    "Sequence number"
															label variable POSOCUP    "Job title"
															label variable RACACOR    "Race or Ethnicity"
															label variable RAPOSENF   "Income bracket for retirees/pensioners"
															label variable RAPOSENV   "Retiree/Pensioner Income Amount"
															label variable RELIGIAO   "Religion code"
															label variable ROUTOCUF   "Income bracket: other occupations"
															label variable ROUTOCUV   "Gross income from other occupations"
															label variable ROUTRENF   "Other income bracket"
															label variable ROUTRENV   "Amount of other income"
															label variable RPRINCIF   "Income bracket for primary occupation"
															label variable RPRINCIV   "Gross income from primary occupation"
															label variable RTONOMIF   "Nominal total income range"
															label variable RTOREALF   "Personal Real Income Range"
															label variable RTOTALPV   "Total income"
															label variable SCATUAL    "Current marital status"
															label variable SCDURASC   "Duration of current marital status"
															label variable SCID1UNI   "Age at time of first marriage"
															label variable SCIDISCA   "Age at the start of current marital status"
															label variable SCNAOUNI   "Does not live with spouse"
															label variable SCNATUNI   "Nature of the union"
															label variable SCVIVCON   "Do you currently live or have you ever lived with a spouse?"
															label variable SEXO       "Gender"
															label variable SITDESO    "Employment status: Unemployed"
															label variable TRUL12M    "Has worked in the last 12 months"
															label variable UVIVIDAD   "Estimated age of the last live-born child"
															label variable UVIVIDTP   "Age of last live-born child"
															label variable UVIVSEXO   "Sex of last live-born child"
															gen ano = 1991
															lab var ano "Year"
														}
														else{
															label variable UFNOM    "Nome da UF"
															label variable UFNUM    "Codigo da UF"
															label variable MESONOM  "Nome da Mesorregiao"
															label variable MESONUM  "Codigo da Mesorregiao"
															label variable MICRONOM "Nome da Microrregiao"
															label variable MICRONUM "Codigo da Microrregiao"
															label variable MUNICNOM "Nome do municipio"
															label variable METROP   "Codigo da area metropolitana"
															label variable MUNICNUM "Codigo do municipio"
															label variable SITSET   "Situacao do Setor"

															label variable AGUA      "Abastecimento de agua"
															label variable ALUGUEFX  "Faixa de aluguel"
															label variable ALUGUEL   "Aluguel mensal"
															label variable ASPIRPO   "Aspirador de po"
															label variable AUTPART   "Automovel particular"
															label variable AUTTRAB   "Automovel para trabalho"
															label variable BANHEIRO  "Numero de Banheiros"
															label variable CD107     "Numero do domic no CD107"
															label variable COBERTUR  "Cobertura"
															label variable COMBCOZI  "Combustivel usado p/ cozinhar"
															label variable COMODOR   "Comodos servindo de dormitorio"
															label variable COMODOS   "Total de comodos"
															label variable CONDOCUP  "Condicao de Ocupacao"
															label variable DEMOCOFX  "Faixa densid morador/comodo"
															label variable DEMOCOMO  "Densidade morador comodo"
															label variable DEMODOFX  "Faixa densid morad/dormitorio"
															label variable DEMODORM  "Densidade morador dormitorio"
															label variable ESPECIE   "Especie do domicilio"
															label variable FILTRO    "Filtro de agua"
															label variable FREEZER   "Freezer"
															label variable GELADEIR  "Geladeira"
															label variable ILUMINA   "Iluminacao"
															label variable LIXO      "Destino do lixo"
															label variable LOCALIZA  "Localizacao"
															label variable MAQLAVAR  "Maquina lavar roupa"
															label variable PAREDES   "Paredes"
															label variable PESO      "Peso de expansao"
															label variable RADIO     "Radio"
															label variable RDOMICIV  "Renda domiciliar"
															label variable RDONOMIF  "Faixa renda dom nominal"
															label variable RDOREALF  "Faixa renda dom real"
															label variable SANESCOA  "Instalacao Sanit. - Escoadouro"
															label variable SANUSO    "Inst Sanit - Uso"
															label variable TELEFONE  "Telefone"
															label variable TVCORES   "Televisao em cores"
															label variable TVPRETO   "Televisao em preto e branco"

															label variable ESPFAM    "Especie de familia"
															label variable NUMFAM    "Familia a que pertence"
															label variable RFACHCAF  "Faixa renda casal nominal"
															label variable RFACHCAV  "Renda casal"
															label variable RFAMILIV  "Renda familiar"
															label variable RFANOMIF  "Faixa renda familiar nominal"
															label variable RFAPCAPF  "Faixa renda per capita nominal"
															label variable RFAPCAPV  "Renda familiar per capita"
															label variable RFAREALF  "Faixa renda familiar real"

															label variable APOPENS   "Aposentado e/ou pensionista"
															label variable ATIVIDAD  "Codigo da Atividade"
															label variable ATIVISET  "Setor de atividade"
															label variable CARTASS   "Tem carteira trab. assinada"
															label variable CONPREV   "Contribuinte previdencia"
															label variable DEFICIE   "Deficiencia"
															label variable EDANOEST  "Anos de estudo"
															label variable EDCURSNS  "Curso nao seriado"
															label variable EDCURSO   "Curso concluido"
															label variable EDGRAU    "Grau que frequenta"
															label variable EDSABELE  "Sabe ler escrever"
															label variable EDSERIE   "Serie que frequenta"
															label variable EDULGRAU  "Grau da ultima serie"
															label variable EDULSERI  "Ultima serie concluida"
															label variable EMPESTB   "Num. empregados estabelecimento"
															label variable FLDOMICH  "Filhos moram domicilio - homem"
															label variable FLDOMICM  "Filhas moram domicilio -mulher"
															label variable FLMORTOH  "Filhos mortos - homem"
															label variable FLMORTOM  "Filhas mortas - mulher"
															label variable FLNAMORH  "Filhos nascidos mortos - homem"
															label variable FLNAMORM  "Filhas nascidas mortas - mulher"
															label variable FLNAMORT  "Total filhos nascidos mortos"
															label variable FLNAODOH  "Filhos nao moram domicilio"
															label variable FLNAODOM  "Filhas nao moram domicilio"
															label variable FLNAVIVH  "Filhos nascidos vivos - homem"
															label variable FLNAVIVM  "Filhas nascidas vivas - mulher"
															label variable FLNAVIVT  "Total filhos nascidos vivos"
															label variable FLTIDOSH  "Filhos tidos - homem"
															label variable FLTIDOSM  "Filhas tidas - mulher"
															label variable FLTIDOST  "Total filhos tidos"
															label variable FLVIVOSH  "Filhos vivos - homem"
															label variable FLVIVOSM  "Filhas vivas - mulher"
															label variable FLVIVOST  "Total filhos vivos"
															label variable HOROUTR   "Horas trabalhadas em outras ocupacões"
															label variable HORTRAB   "Horas trabalhadas ocupacao Q346"
															label variable IDADEANO  "Idade em anos"
															label variable IDADEMES  "Idade em meses"
															label variable IDADETIP  "Tipo de idade"
															label variable LOCTRAB   "Local de trabalho"
															label variable MIANMOMU  "Anos que mora no municipio"
															label variable MIANMOUF  "Anos que mora na UF"
															label variable MIANORES  "Ano fixou residencia"
															label variable MIANTEMU  "Municipio moradia anterior"
															label variable MIANTEUF  "Lugar de moradia anterior"
															label variable MIANTEZN  "Zona moradia anterior"
															label variable MIMO86MU  "Municipio moradia em 86"
															label variable MIMO86UF  "Lugar de moradia em 01/09/86"
															label variable MIMO86ZN  "Zona de moradia em 86"
															label variable MIMUMOZN  "Zona que morou neste municipio"
															label variable MINACION  "Nacionalidade"
															label variable MINASCMU  "Nasceu neste municipio"
															label variable MIUFPAIS  "UF/Pais de nascimento"
															label variable MIULTMUD  "Ultima mudanca"
															label variable NORDMAE   "Numero de ordem da mae"
															label variable OCUPACAO  "Ocupacao principal"
															label variable OCUPAGRP  "Grupo ocupacao principal"
															label variable PARENDOM  "Parentesco com o do chefe domicilio"
															label variable PARENFAM  "Parentesco com o chefe da familia"
															label variable PESSOAN   "Numero de ordem"
															label variable POSOCUP   "Posicao da ocupacao"
															label variable RACACOR   "Raca ou cor"
															label variable RAPOSENF  "Faixa de rend aposent/pensionista"
															label variable RAPOSENV  "Valor rend aposent/pensionista"
															label variable RELIGIAO  "Codigo da religiao"
															label variable ROUTOCUF  "Faixa renda outras ocupacoes"
															label variable ROUTOCUV  "Rend bruto outras ocupacoes"
															label variable ROUTRENF  "Faixa outros rendimentos"
															label variable ROUTRENV  "Valor outros rendimentos"
															label variable RPRINCIF  "Faixa renda ocupação principal"
															label variable RPRINCIV  "Rendimento bruto ocupacao principal"
															label variable RTONOMIF  "Faixa renda total nominal"
															label variable RTOREALF  "Faixa renda real pessoal"
															label variable RTOTALPV  "Renda total"
															label variable SCATUAL   "Situacao conjugal atual"
															label variable SCDURASC  "Duracao sit. conjugal atual"
															label variable SCID1UNI  "Idade ao contrair 1ªuniao"
															label variable SCIDISCA  "Idade inicio sit.conj.atual"
															label variable SCNAOUNI  "Nao vive com conjuge"
															label variable SCNATUNI  "Natureza da uniao"
															label variable SCVIVCON  "Vive ou viveu com conjuge"
															label variable SEXO      "Sexo"
															label variable SITDESO   "Situacao desocupado"
															label variable TRUL12M   "Trabalhou ultimos 12 meses"
															label variable UVIVIDAD  "Idade calculada do ult.filho nasc.vivo"
															label variable UVIVIDTP  "Tipo idade ult.filho nasc vivo"
															label variable UVIVSEXO  "Sexo ultimo filho nascido vivo"
															gen ano = 1991
															lab var ano "ano da pesquisa"
															}
									
									
										
									destring NUMFAM ESPECIE PARENDOM, replace force /* altera o id_dom, se: */
									gen long id_dom = sum((MUNICNUM != MUNICNUM[_n-1]) | /// se muda o municipio
															(ESPECIE != ESPECIE[_n-1]) | /// se muda a especie do domicilio
															(PARENDOM == 20) | /// se o individuo mora sozinho
															((RDOMICIV != RDOMICIV[_n-1]) | (ALUGUEL != ALUGUEL[_n-1]) | (PESO != PESO[_n-1]) | ///
															(DEMODORM != DEMODORM[_n-1]) | (COMBCOZI != COMBCOZI[_n-1]) | ///
															(AGUA != AGUA[_n-1]) | (ALUGUEFX != ALUGUEFX[_n-1]) | (ASPIRPO != ASPIRPO[_n-1]) | ///
															(AUTPART != AUTPART[_n-1]) | (AUTTRAB != AUTTRAB[_n-1]) | (BANHEIRO != BANHEIRO[_n-1]) | ///
															(CD107 != CD107[_n-1]) | (COBERTUR != COBERTUR[_n-1]) | (COMODOR != COMODOR[_n-1]) | ///
															(COMODOS != COMODOS[_n-1]) | (CONDOCUP != CONDOCUP[_n-1]) | (DEMOCOFX != DEMOCOFX[_n-1]) | ///
															(DEMOCOMO != DEMOCOMO[_n-1]) | (DEMODOFX != DEMODOFX[_n-1]) | (FILTRO != FILTRO[_n-1]) | ///
															(FREEZER != FREEZER[_n-1]) | (GELADEIR != GELADEIR[_n-1]) | (ILUMINA != ILUMINA[_n-1]) | ///
															(LIXO != LIXO[_n-1]) | (LOCALIZA != LOCALIZA[_n-1]) | (MAQLAVAR != MAQLAVAR[_n-1]) | ///
															(PAREDES != PAREDES[_n-1]) | (RADIO != RADIO[_n-1]) | (RDONOMIF != RDONOMIF[_n-1]) | ///
															(RDOREALF != RDOREALF[_n-1]) | (SANESCOA != SANESCOA[_n-1]) | (SANUSO != SANUSO[_n-1]) | ///
															(TELEFONE != TELEFONE[_n-1]) | (TVCORES != TVCORES[_n-1]) | (TVPRETO != TVPRETO[_n-1])))
															
									
											if "`both'"~="" {
											
											/* Compatibiliza, se especificado */
											if "`comp'" != "" {
												/*	/* ============================================================ */
													/* DROPS                                                        */
													/* ============================================================ */
													capture drop UFNOM MESONOM MICRONOM MUNICNOM RFAPCAPV

													/* ============================================================ */
													/* RENAMES - DOMICÍLIO                                          */
													/* ============================================================ */
													destring UFNUM, replace
													capture rename UFNUM v1101
													capture rename MESONUM  v7001
													capture rename MICRONUM v7002
													capture rename METROP   v7003
													capture rename MUNICNUM v1102
													capture rename SITSET   v1061

													capture rename AGUA     v0205
													capture rename ALUGUEFX v2094
													capture rename ALUGUEL  v0209
													capture rename ASPIRPO  v0227
													capture rename AUTPART  v0218
													capture rename AUTTRAB  v0219
													capture rename BANHEIRO v0213
													capture rename CD107    v0109
													capture rename COBERTUR v0204
													capture rename COMBCOZI v0210
													capture rename COMODOR  v0212
													capture rename COMODOS  v0211
													capture rename CONDOCUP v0208
													capture rename DEMOCOFX v2112
													capture rename DEMOCOMO v2111
													capture rename DEMODOFX v2122
													capture rename DEMODORM v2121
													capture rename ESPECIE  v0201
													capture rename FILTRO   v0216
													capture rename FREEZER  v0225
													capture rename GELADEIR v0222
													capture rename ILUMINA  v0221
													capture rename LIXO     v0214
													capture rename LOCALIZA v0202
													capture rename MAQLAVAR v0226
													capture rename PAREDES  v0203
													capture rename PESO     v7300
													capture rename RADIO    v0220
													capture rename RDOMICIV v2012
													capture rename RDONOMIF v2013
													capture rename RDOREALF v2014
													capture rename SANESCOA v0206
													capture rename SANUSO   v0207
													capture rename TELEFONE v0217
													capture rename TVCORES  v0224
													capture rename TVPRETO  v0223

													/* ============================================================ */
													/* RENOMES - FAMÍLIA                                            */
													/* ============================================================ */
													capture rename ESPFAM   v2011
													capture rename NUMFAM   v0304
													capture rename RFACHCAF v3044
													capture rename RFACHCAV v3043
													capture rename RFAMILIV v3045
													capture rename RFANOMIF v3046
													capture rename RFAPCAPF v3049
													capture rename RFAREALF v3047

													/* ============================================================ */
													/* RENOMES - PESSOAS                                            */
													/* ============================================================ */
													capture rename APOPENS  v0359
													capture rename ATIVIDAD v0347
													capture rename ATIVISET v3471
													capture rename CARTASS  v0350
													capture rename CONPREV  v0353
													capture rename DEFICIE  v0311
													capture rename EDANOEST v3241
													capture rename EDCURSNS v0326
													capture rename EDCURSO  v0329
													capture rename EDGRAU   v0325
													capture rename EDSABELE v0323
													capture rename EDSERIE  v0324
													capture rename EDULGRAU v0328
													capture rename EDULSERI v0327
													capture rename EMPESTB  v0351
													capture rename FLDOMICH v0335
													capture rename FLDOMICM v0336
													capture rename FLMORTOH v0339
													capture rename FLMORTOM v0340
													capture rename FLNAMORH v0341
													capture rename FLNAMORM v0342
													capture rename FLNAMORT v3357
													capture rename FLNAODOH v0337
													capture rename FLNAODOM v0338
													capture rename FLNAVIVH v3355
													capture rename FLNAVIVM v3356
													capture rename FLNAVIVT v3354
													capture rename FLTIDOSH v3352
													capture rename FLTIDOSM v3353
													capture rename FLTIDOST v3351
													capture rename FLVIVOSH v3361
													capture rename FLVIVOSM v3362
													capture rename FLVIVOST v3360
													capture rename HOROUTR  v0355
													capture rename HORTRAB  v0354
													capture rename IDADEANO v3072
													capture rename IDADEMES v3073
													capture rename IDADETIP v3071
													capture rename LOCTRAB  v0352
													capture rename MIANMOMU v0318
													capture rename MIANMOUF v0317
													capture rename MIANORES v3152
													capture rename MIANTEMU v3191
													capture rename MIANTEUF v0319
													capture rename MIANTEZN v0320
													capture rename MIMO86MU v3211
													capture rename MIMO86UF v0321
													capture rename MIMO86ZN v0322
													capture rename MIMUMOZN v0312
													capture rename MINACION v3151
													capture rename MINASCMU v0314
													capture rename MIUFPAIS v0316
													capture rename MIULTMUD v0313
													capture rename NORDMAE  v3005
													capture rename OCUPACAO v0346
													capture rename OCUPAGRP v3461
													capture rename PARENDOM v0302
													capture rename PARENFAM v0303
													capture rename PESSOAN  v0098
													capture rename POSOCUP  v0349
													capture rename RACACOR  v0309
													capture rename RAPOSENF v3604
													capture rename RAPOSENV v0360
													capture rename RELIGIAO v0310
													capture rename ROUTOCUF v3574
													capture rename ROUTOCUV v0357
													capture rename ROUTRENF v3614
													capture rename ROUTRENV v0361
													capture rename RPRINCIF v3564
													capture rename RPRINCIV v0356
													capture rename RTONOMIF v3562
													capture rename RTOREALF v3563
													capture rename RTOTALPV v3561
													capture rename SCATUAL  v3342
													capture rename SCDURASC v3341
													capture rename SCID1UNI v3311
													capture rename SCIDISCA v3312
													capture rename SCNAOUNI v0333
													capture rename SCNATUNI v0332
													capture rename SCVIVCON v0330
													capture rename SEXO     v0301
													capture rename SITDESO  v0358
													capture rename TRUL12M  v0345
													capture rename UVIVIDAD v3443
													capture rename UVIVIDTP v3444
													capture rename UVIVSEXO v0343
													
													destring v0316 v0319 v0321 v3151 v3152 v3191 v3211 v0314 v0312 v0310, replace force

													/* ============================================================ */
													/* VARIÁVEIS GERADAS                                            */
													/* ============================================================ */
													capture gen v3041 = .
													capture gen v3042 = .
													capture gen v7004 = .
													capture gen v0111 = .
													capture gen v0112 = .
													capture gen v7301 = v7300
													
											
											/* roda compatibilizacao para dom e pes?*/ */
											
											
											
											/* ou roda compatibilizacao para uma compatibilizacao unica?*/
											
											compat_censo91dbf
											
											/* Áreas Mínimas Comparáveis */
											findfile amcs.dta
											sort munic
											merge m:1 munic using `"`r(fn)'"', nogen keep(match)
											
											save CENSO91_`UF'_comp, replace
											} 
											else{
											save CENSO91_`UF', replace
											}
											
											/* save CENSO91_`UF', replace */
								
											}
											else{
												if "`pes'"~="" {
												
												drop AGUA ALUGUEFX ALUGUEL ASPIRPO AUTPART AUTTRAB BANHEIRO CD107 ///
													 COBERTUR COMBCOZI COMODOR COMODOS CONDOCUP DEMOCOFX DEMOCOMO ///
													 DEMODOFX DEMODORM ESPECIE FILTRO FREEZER GELADEIR ILUMINA ///
													 LIXO LOCALIZA MAQLAVAR PAREDES RADIO RDOMICIV RDONOMIF RDOREALF ///
													 SANESCOA SANUSO TELEFONE TVCORES TVPRETO
												
												/* Compatibiliza, se especificado */			
												if "`comp'" != ""{
													
													/* ============================================================ */
													/* DROPS                                                        */
													/* ============================================================ */
													capture drop UFNOM MESONOM MICRONOM MUNICNOM RFAPCAPV

													/* ============================================================ */
													/* RENAMES - DOMICÍLIO                                          */
													/* ============================================================ */
													destring UFNUM, replace
													capture rename UFNUM v1101
													capture rename MESONUM  v7001
													capture rename MICRONUM v7002
													capture rename METROP   v7003
													capture rename MUNICNUM v1102
													capture rename SITSET   v1061

													capture rename AGUA     v0205
													capture rename ALUGUEFX v2094
													capture rename ALUGUEL  v0209
													capture rename ASPIRPO  v0227
													capture rename AUTPART  v0218
													capture rename AUTTRAB  v0219
													capture rename BANHEIRO v0213
													capture rename CD107    v0109
													capture rename COBERTUR v0204
													capture rename COMBCOZI v0210
													capture rename COMODOR  v0212
													capture rename COMODOS  v0211
													capture rename CONDOCUP v0208
													capture rename DEMOCOFX v2112
													capture rename DEMOCOMO v2111
													capture rename DEMODOFX v2122
													capture rename DEMODORM v2121
													capture rename ESPECIE  v0201
													capture rename FILTRO   v0216
													capture rename FREEZER  v0225
													capture rename GELADEIR v0222
													capture rename ILUMINA  v0221
													capture rename LIXO     v0214
													capture rename LOCALIZA v0202
													capture rename MAQLAVAR v0226
													capture rename PAREDES  v0203
													capture rename PESO     v7300
													capture rename RADIO    v0220
													capture rename RDOMICIV v2012
													capture rename RDONOMIF v2013
													capture rename RDOREALF v2014
													capture rename SANESCOA v0206
													capture rename SANUSO   v0207
													capture rename TELEFONE v0217
													capture rename TVCORES  v0224
													capture rename TVPRETO  v0223

													/* ============================================================ */
													/* RENOMES - FAMÍLIA                                            */
													/* ============================================================ */
													capture rename ESPFAM   v2011
													capture rename NUMFAM   v0304
													capture rename RFACHCAF v3044
													capture rename RFACHCAV v3043
													capture rename RFAMILIV v3045
													capture rename RFANOMIF v3046
													capture rename RFAPCAPF v3049
													capture rename RFAREALF v3047

													/* ============================================================ */
													/* RENOMES - PESSOAS                                            */
													/* ============================================================ */
													capture rename APOPENS  v0359
													capture rename ATIVIDAD v0347
													capture rename ATIVISET v3471
													capture rename CARTASS  v0350
													capture rename CONPREV  v0353
													capture rename DEFICIE  v0311
													capture rename EDANOEST v3241
													capture rename EDCURSNS v0326
													capture rename EDCURSO  v0329
													capture rename EDGRAU   v0325
													capture rename EDSABELE v0323
													capture rename EDSERIE  v0324
													capture rename EDULGRAU v0328
													capture rename EDULSERI v0327
													capture rename EMPESTB  v0351
													capture rename FLDOMICH v0335
													capture rename FLDOMICM v0336
													capture rename FLMORTOH v0339
													capture rename FLMORTOM v0340
													capture rename FLNAMORH v0341
													capture rename FLNAMORM v0342
													capture rename FLNAMORT v3357
													capture rename FLNAODOH v0337
													capture rename FLNAODOM v0338
													capture rename FLNAVIVH v3355
													capture rename FLNAVIVM v3356
													capture rename FLNAVIVT v3354
													capture rename FLTIDOSH v3352
													capture rename FLTIDOSM v3353
													capture rename FLTIDOST v3351
													capture rename FLVIVOSH v3361
													capture rename FLVIVOSM v3362
													capture rename FLVIVOST v3360
													capture rename HOROUTR  v0355
													capture rename HORTRAB  v0354
													capture rename IDADEANO v3072
													capture rename IDADEMES v3073
													capture rename IDADETIP v3071
													capture rename LOCTRAB  v0352
													capture rename MIANMOMU v0318
													capture rename MIANMOUF v0317
													capture rename MIANORES v3152
													capture rename MIANTEMU v3191
													capture rename MIANTEUF v0319
													capture rename MIANTEZN v0320
													capture rename MIMO86MU v3211
													capture rename MIMO86UF v0321
													capture rename MIMO86ZN v0322
													capture rename MIMUMOZN v0312
													capture rename MINACION v3151
													capture rename MINASCMU v0314
													capture rename MIUFPAIS v0316
													capture rename MIULTMUD v0313
													capture rename NORDMAE  v3005
													capture rename OCUPACAO v0346
													capture rename OCUPAGRP v3461
													capture rename PARENDOM v0302
													capture rename PARENFAM v0303
													capture rename PESSOAN  v0098
													capture rename POSOCUP  v0349
													capture rename RACACOR  v0309
													capture rename RAPOSENF v3604
													capture rename RAPOSENV v0360
													capture rename RELIGIAO v0310
													capture rename ROUTOCUF v3574
													capture rename ROUTOCUV v0357
													capture rename ROUTRENF v3614
													capture rename ROUTRENV v0361
													capture rename RPRINCIF v3564
													capture rename RPRINCIV v0356
													capture rename RTONOMIF v3562
													capture rename RTOREALF v3563
													capture rename RTOTALPV v3561
													capture rename SCATUAL  v3342
													capture rename SCDURASC v3341
													capture rename SCID1UNI v3311
													capture rename SCIDISCA v3312
													capture rename SCNAOUNI v0333
													capture rename SCNATUNI v0332
													capture rename SCVIVCON v0330
													capture rename SEXO     v0301
													capture rename SITDESO  v0358
													capture rename TRUL12M  v0345
													capture rename UVIVIDAD v3443
													capture rename UVIVIDTP v3444
													capture rename UVIVSEXO v0343
													
													destring v0316 v0319 v0321 v3151 v3152 v3191 v3211 v0314 v0312 v0310, replace force

													/* ============================================================ */
													/* VARIÁVEIS GERADAS                                            */
													/* ============================================================ */
													capture gen v3041 = .
													capture gen v3042 = .
													capture gen v7004 = .
													capture gen v0111 = .
													capture gen v0112 = .
													capture gen v7301 = v7300
													
													compat_censo91pess

													/* Áreas Mínimas Comparáveis */
													findfile amcs.dta
													sort munic
													merge m:1 munic using `"`r(fn)'"', nogen keep(match)
													
													save CENSO91_`UF'_pes_comp, replace
													} 
													else{
													save CENSO91_`UF'_pes, replace
													}
	
												}
												
												if "`dom'"~="" {
												
												drop APOPENS ATIVIDAD ATIVISET CARTASS CONPREV DEFICIE EDANOEST EDCURSNS ///
													 EDCURSO EDGRAU EDSABELE EDSERIE EDULGRAU EDULSERI EMPESTB FLDOMICH ///
													 FLDOMICM FLMORTOH FLMORTOM FLNAMORH FLNAMORM FLNAMORT FLNAODOH ///
													 FLNAODOM FLNAVIVH FLNAVIVM FLNAVIVT FLTIDOSH FLTIDOSM FLTIDOST ///
													 FLVIVOSH FLVIVOSM FLVIVOST HOROUTR HORTRAB IDADEANO IDADEMES ///
													 IDADETIP LOCTRAB MIANMOMU MIANMOUF MIANORES MIANTEMU MIANTEUF ///
													 MIANTEZN MIMO86MU MIMO86UF MIMO86ZN MIMUMOZN MINACION MINASCMU ///
													 MIUFPAIS MIULTMUD NORDMAE OCUPACAO OCUPAGRP PARENDOM PARENFAM ///
													 PESSOAN POSOCUP RACACOR RAPOSENF RAPOSENV RELIGIAO ROUTOCUF ///
													 ROUTOCUV ROUTRENF ROUTRENV RPRINCIF RPRINCIV RTONOMIF RTOREALF ///
													 RTOTALPV SCATUAL SCDURASC SCID1UNI SCIDISCA SCNAOUNI SCNATUNI ///
													 SCVIVCON SEXO SITDESO TRUL12M UVIVIDAD UVIVIDTP UVIVSEXO ///
													 ESPFAM NUMFAM RFACHCAF RFACHCAV RFAMILIV RFANOMIF RFAPCAPF RFAPCAPV RFAREALF
													 
													/* drop variaveis de pessoas e familias mantendo id_dom e pesos para expansao */ 
											
													/* Compatibiliza, se especificado */
													if "`comp'" != "" {
													
													/* ============================================================ */
													/* DROPS                                                        */
													/* ============================================================ */
													capture drop UFNOM MESONOM MICRONOM MUNICNOM RFAPCAPV

													/* ============================================================ */
													/* RENOMES - DOMICÍLIO                                          */
													/* ============================================================ */
													destring UFNUM, replace
													capture rename UFNUM    v1101
													capture rename MESONUM  v7001
													capture rename MICRONUM v7002
													capture rename METROP   v7003
													capture rename MUNICNUM v1102
													capture rename SITSET   v1061

													capture rename AGUA     v0205
													capture rename ALUGUEFX v2094
													capture rename ALUGUEL  v0209
													capture rename ASPIRPO  v0227
													capture rename AUTPART  v0218
													capture rename AUTTRAB  v0219
													capture rename BANHEIRO v0213
													capture rename CD107    v0109
													capture rename COBERTUR v0204
													capture rename COMBCOZI v0210
													capture rename COMODOR  v0212
													capture rename COMODOS  v0211
													capture rename CONDOCUP v0208
													capture rename DEMOCOFX v2112
													capture rename DEMOCOMO v2111
													capture rename DEMODOFX v2122
													capture rename DEMODORM v2121
													capture rename ESPECIE  v0201
													capture rename FILTRO   v0216
													capture rename FREEZER  v0225
													capture rename GELADEIR v0222
													capture rename ILUMINA  v0221
													capture rename LIXO     v0214
													capture rename LOCALIZA v0202
													capture rename MAQLAVAR v0226
													capture rename PAREDES  v0203
													capture rename PESO     v7300
													capture rename RADIO    v0220
													capture rename RDOMICIV v2012
													capture rename RDONOMIF v2013
													capture rename RDOREALF v2014
													capture rename SANESCOA v0206
													capture rename SANUSO   v0207
													capture rename TELEFONE v0217
													capture rename TVCORES  v0224
													capture rename TVPRETO  v0223

													/* ============================================================ */
													/* RENOMES - FAMÍLIA                                            */
													/* ============================================================ */
													capture rename ESPFAM   v2011
													capture rename NUMFAM   v0304
													capture rename RFACHCAF v3044
													capture rename RFACHCAV v3043
													capture rename RFAMILIV v3045
													capture rename RFANOMIF v3046
													capture rename RFAPCAPF v3049
													capture rename RFAREALF v3047

													/* ============================================================ */
													/* RENOMES - PESSOAS                                            */
													/* ============================================================ */
													capture rename APOPENS  v0359
													capture rename ATIVIDAD v0347
													capture rename ATIVISET v3471
													capture rename CARTASS  v0350
													capture rename CONPREV  v0353
													capture rename DEFICIE  v0311
													capture rename EDANOEST v3241
													capture rename EDCURSNS v0326
													capture rename EDCURSO  v0329
													capture rename EDGRAU   v0325
													capture rename EDSABELE v0323
													capture rename EDSERIE  v0324
													capture rename EDULGRAU v0328
													capture rename EDULSERI v0327
													capture rename EMPESTB  v0351
													capture rename FLDOMICH v0335
													capture rename FLDOMICM v0336
													capture rename FLMORTOH v0339
													capture rename FLMORTOM v0340
													capture rename FLNAMORH v0341
													capture rename FLNAMORM v0342
													capture rename FLNAMORT v3357
													capture rename FLNAODOH v0337
													capture rename FLNAODOM v0338
													capture rename FLNAVIVH v3355
													capture rename FLNAVIVM v3356
													capture rename FLNAVIVT v3354
													capture rename FLTIDOSH v3352
													capture rename FLTIDOSM v3353
													capture rename FLTIDOST v3351
													capture rename FLVIVOSH v3361
													capture rename FLVIVOSM v3362
													capture rename FLVIVOST v3360
													capture rename HOROUTR  v0355
													capture rename HORTRAB  v0354
													capture rename IDADEANO v3072
													capture rename IDADEMES v3073
													capture rename IDADETIP v3071
													capture rename LOCTRAB  v0352
													capture rename MIANMOMU v0318
													capture rename MIANMOUF v0317
													capture rename MIANORES v3152
													capture rename MIANTEMU v3191
													capture rename MIANTEUF v0319
													capture rename MIANTEZN v0320
													capture rename MIMO86MU v3211
													capture rename MIMO86UF v0321
													capture rename MIMO86ZN v0322
													capture rename MIMUMOZN v0312
													capture rename MINACION v3151
													capture rename MINASCMU v0314
													capture rename MIUFPAIS v0316
													capture rename MIULTMUD v0313
													capture rename NORDMAE  v3005
													capture rename OCUPACAO v0346
													capture rename OCUPAGRP v3461
													capture rename PARENDOM v0302
													capture rename PARENFAM v0303
													capture rename PESSOAN  v0098
													capture rename POSOCUP  v0349
													capture rename RACACOR  v0309
													capture rename RAPOSENF v3604
													capture rename RAPOSENV v0360
													capture rename RELIGIAO v0310
													capture rename ROUTOCUF v3574
													capture rename ROUTOCUV v0357
													capture rename ROUTRENF v3614
													capture rename ROUTRENV v0361
													capture rename RPRINCIF v3564
													capture rename RPRINCIV v0356
													capture rename RTONOMIF v3562
													capture rename RTOREALF v3563
													capture rename RTOTALPV v3561
													capture rename SCATUAL  v3342
													capture rename SCDURASC v3341
													capture rename SCID1UNI v3311
													capture rename SCIDISCA v3312
													capture rename SCNAOUNI v0333
													capture rename SCNATUNI v0332
													capture rename SCVIVCON v0330
													capture rename SEXO     v0301
													capture rename SITDESO  v0358
													capture rename TRUL12M  v0345
													capture rename UVIVIDAD v3443
													capture rename UVIVIDTP v3444
													capture rename UVIVSEXO v0343

													/* ============================================================ */
													/* VARIÁVEIS GERADAS                                            */
													/* ============================================================ */
													capture gen v3041 = .
													capture gen v3042 = .
													capture gen v7004 = .
													capture gen v0111 = .
													capture gen v0112 = .
													capture gen v7301 = v7300

													compat_censo91dom

													/* Áreas Mínimas Comparáveis */
													findfile amcs.dta
													sort munic
													merge m:1 munic using `"`r(fn)'"', nogen keep(match)
													
													save CENSO91_`UF'_dom_comp, replace
													}
													else{
													save CENSO91_`UF'_dom, replace
													}
												}
											}
										}
									}
								}
								else if "`dattxt91'" != "" & "`dbf91'" == "" {
		di as text "Formato selecionado dos microdados originais do Censo 1991: DAT / TXT"
		
		foreach UF in `ufs' {
			/* Achando posição da UF nas listas: */
			local pos = 1
			while word(`"`nomesUFs'"', `pos') != "`UF'" {
				local pos = `pos' + 1
			}
			/* Loop para todos os arquivos da UF                              */
			/* Transformo os conjuntos de sufixos "tokens" e pego o pos-ésimo */
			tokenize `suf1991'
			local sufixos = "``pos''"
			/* Mesmo para o código */
			tokenize `codUFs'
			local codUF = "``pos''"
			di "`sufixos'"
			foreach suf in `sufixos' {
				if "`pes'"~="" {
					display as input "Extraindo `ano' `UF' - `suf' ..."
					/* Abrindo arquivo                              */
					* resgata códigos do município e microrregião do arquivo de domicílios
					
					tempfile dic
					local dic "`dic'.dct"

					findfile dict.dta

					read_compdct, compdct("`r(fn)'") dict_name("censo`ano'dom`lang'") out("`dic'")
					
					capture infile using `dic', using("`original'/CD102`suf'.txt") clear
					/* Próximas linha roda se Stata não encontrar o .txt */
					if _rc == 601 {
									capture infile using `dic', using("`original'/CD102`suf'.dat") clear
									if _rc == 601 {
									di as err "Erro para encontrar o arquivo original indicado. Confira se:"
									di as err "O arquivo original se encontra no formato selecionado (nesse caso, DAT ou TXT);"
									di as err "O arquivo original está com o nome que vem quando é baixado pelo IBGE"
									di as err "O arquivo original é acessado diretamente da pasta designada (não deve haver pastas intermediárias até o arquivo original)"
									exit
										}
									}
					

					keep if v0099 == 1 // i.e. guarda só os domicíios
					keep v0102 v1101 v1102 v7002
					bys v0102: keep if _n==1
					tempfile cod91
					sort v0102
					save `cod91', replace

					/* Primeiros base de pessoas */
					
					tempfile dic
					local dic "`dic'.dct"

					findfile dict.dta

					read_compdct, compdct("`r(fn)'") dict_name("censo`ano'pes`lang'") out("`dic'")
					
					capture infile using `dic', using("`original'/CD102`suf'.txt") clear
					/* Próximas linha roda se Stata não encontrar o .txt */
					if _rc == 601 cap infile using `dic', using("`original'/CD102`suf'.dat") clear

					keep if v0099 == 2 // i.e. guarda só os indivíduos

					gen ano = 1991
					lab var ano "ano da pesquisa"
					drop v0099
					
					sort v0102
					merge m:1 v0102 using `cod91', nogen keep(match)
			
					egen munic = concat(v1101 v1102)
					destring munic, replace
					lab var munic "municipality codes without DV (6 digits)"
					
				*----------------------------------------------------
				* Reorganiza variáveis na ordem do dbf
				*----------------------------------------------------

				 capture order ///
					ano munic v7004 v1101 v7001 v7002 v7003 v1102 v1061 ///
					v0205 v2094 v0209 v0227 v0218 v0219 v0213 v0109 v0204 v0210 ///
					v0212 v0211 v0208 v2112 v2111 v2122 v2121 v0201 v0216 v0225 ///
					v0222 v0221 v0214 v0202 v0226 v0203 v7300 v0220 v2012 v2013 ///
					v2014 v0206 v0207 v0217 v0224 v0223 v0111 v0112 ///
					v2011 v0304 v3044 v3043 v3045 v3046 v3049 v3047 v3041 v3042 ///
					v0359 v0347 v3471 v0350 v0353 v0311 v3241 v0326 v0329 v0325 ///
					v0323 v0324 v0328 v0327 v0351 v0335 v0336 v0339 v0340 v0341 ///
					v0342 v3357 v0337 v0338 v3355 v3356 v3354 v3352 v3353 v3351 ///
					v3361 v3362 v3360 v0355 v0354 v3072 v3073 v3071 v0352 v0318 ///
					v0317 v3152 v3191 v0319 v0320 v3211 v0321 v0322 v0312 v3151 ///
					v0314 v0316 v0313 v3005 v0346 v3461 v0302 v0303 v0098 v0349 ///
					v0309 v3604 v0360 v0310 v3574 v0357 v3614 v0361 v3564 v0356 ///
					v3562 v3563 v3561 v3342 v3341 v3311 v3312 v0333 v0332 v0330 ///
					v0301 v0358 v0345 v3443 v3444 v0343 v0102

						
					/* Compatibiliza, se especificado */
					if "`comp'" != "" {
						compat_censo91pess

						/* Áreas Mínimas Comparáveis */
						findfile amcs.dta
						sort munic
						merge m:1 munic using `"`r(fn)'"', nogen keep(match)
					}
					tempfile CENSO91_`UF'_pes_`suf'
					save `CENSO91_`UF'_pes_`suf'', replace
				}
				if "`dom'"~="" {
					/* Agora os domicílios */
					
					tempfile dic
					local dic "`dic'.dct"

					findfile dict.dta

					read_compdct, compdct("`r(fn)'") dict_name("censo`ano'dom`lang'") out("`dic'")
					
					capture infile using `dic', using("`original'/CD102`suf'.txt") clear
					/* Próximas linha roda se Stata não encontrar o .txt */
					if _rc == 601 cap infile using `dic', using("`original'/CD102`suf'.dat") clear

					keep if v0099 == 1 // i.e. guarda só os domicíios
					bys v0102: keep if _n==1
					gen ano = 1991
					lab var ano "ano da pesquisa"
					drop v0098 v0099

					egen munic = concat(v1101 v1102)
					destring munic, replace
					lab var munic "municipality codes without DV (6 digits)"
					
				*----------------------------------------------------
				* Reorganiza variáveis na ordem do dbf
				*----------------------------------------------------
				capture order ///
					ano munic v7004 v1101 v7001 v7002 v7003 v1102 v1061 ///
					v0205 v2094 v0209 v0227 v0218 v0219 v0213 v0109 v0204 v0210 ///
					v0212 v0211 v0208 v2112 v2111 v2122 v2121 v0201 v0216 v0225 ///
					v0222 v0221 v0214 v0202 v0226 v0203 v7300 v0220 v2012 v2013 ///
					v2014 v0206 v0207 v0217 v0224 v0223 v0111 v0112 ///
					v2011 v0304 v3044 v3043 v3045 v3046 v3049 v3047 v3041 v3042 ///
					v0359 v0347 v3471 v0350 v0353 v0311 v3241 v0326 v0329 v0325 ///
					v0323 v0324 v0328 v0327 v0351 v0335 v0336 v0339 v0340 v0341 ///
					v0342 v3357 v0337 v0338 v3355 v3356 v3354 v3352 v3353 v3351 ///
					v3361 v3362 v3360 v0355 v0354 v3072 v3073 v3071 v0352 v0318 ///
					v0317 v3152 v3191 v0319 v0320 v3211 v0321 v0322 v0312 v3151 ///
					v0314 v0316 v0313 v3005 v0346 v3461 v0302 v0303 v0098 v0349 ///
					v0309 v3604 v0360 v0310 v3574 v0357 v3614 v0361 v3564 v0356 ///
					v3562 v3563 v3561 v3342 v3341 v3311 v3312 v0333 v0332 v0330 ///
					v0301 v0358 v0345 v3443 v3444 v0343 v0102


					if "`comp'" != "" {
						compat_censo91dom

						/* Áreas Mínimas Comparáveis */
						findfile amcs.dta
						sort munic
						merge m:1 munic using `"`r(fn)'"', nogen keep(match)
					}
					tempfile CENSO91_`UF'_dom_`suf'
					save `CENSO91_`UF'_dom_`suf'', replace
				}
				if "`comp'"~="" loc var = "id_dom"
				else loc var = "v0102"
				if "`both'"~="" {
					use `CENSO91_`UF'_pes_`suf'', clear
					merge m:1 `var' using `CENSO91_`UF'_dom_`suf'', nogen keep(match)
					
					/* Se não for o primeiro arquivo, junta com o anterior */
					if "`suf'" != word(`"`sufixos'"', 1) {
						if "`comp'"~= "" append using CENSO91_`UF'_comp
						else append using CENSO91_`UF'
					}
					if "`comp'"~= "" save CENSO91_`UF'_comp, replace
					else save CENSO91_`UF', replace
				}
				else {
					if "`pes'"~="" {
						use `CENSO91_`UF'_pes_`suf'', clear
						/* Se não for o primeiro arquivo, junta com o anterior */
						if "`suf'" != word(`"`sufixos'"', 1) {
							if "`comp'"~= "" append using CENSO91_`UF'_pes_comp
							else append using CENSO91_`UF'_pes
						}
						if "`comp'"~="" save CENSO91_`UF'_pes_comp, replace
						else save CENSO91_`UF'_pes, replace
					}
					else {
						use `CENSO91_`UF'_dom_`suf'', clear
						/* Se não for o primeiro arquivo, junta com o anterior */
						if "`suf'" != word(`"`sufixos'"', 1) {
							if "`comp'"~= "" append using CENSO91_`UF'_dom_comp
							else append using CENSO91_`UF'_dom
						}
						if "`comp'"~="" save CENSO91_`UF'_dom_comp, replace
						else save CENSO91_`UF'_dom, replace
						}
					}
				}
			}
		}
	 else if "`dattxt91'" != "" & "`dbf91'" != "" {
														di as err "Apenas uma opção de formato dos arquivos originais deve ser escolhida (dbf91 ou dat/txt91)"
														exit
													}
	 else if "`dattxt91'" == "" & "`dbf91'" == "" {
														di as err "Deve ser escolhida uma opção de formato de acordo com os arquivos originais usados (dbf91 ou dat/txt91)"
														exit
													}
	}	
	else if `ano' == 2000 {

	di as input "Atenção: utilize os microdados do Censo 2000 atualizados em 08/09/2017"

		foreach UF in `ufs' {
			/* Achando posição da UF nas listas: */
			local pos = 1
			while word(`"`nomesUFs'"', `pos') != "`UF'" {
				local pos = `pos' + 1
			}
			/* Loop para todos os arquivos da UF                              */
			/* Transformo os conjuntos de sufixos "tokens" e pego o pos-ésimo */
			tokenize `suf2000'
			local sufixos = "``pos''"
			/* Mesmo para o código */
			tokenize `codUFs'
			local codUF = "``pos''"
			foreach suf in `sufixos' {
				if "`fam'"~="" {
					display as input "Extraindo `ano' `UF' - `suf' ..."
					
					tempfile dic
					local dic "`dic'.dct"

					findfile dict.dta

					read_compdct, compdct("`r(fn)'") dict_name("censo`ano'fam`lang'") out("`dic'")
					
					/* Abrindo arquivo                              */
					quietly infile using `dic', using("`original'/Fami`suf'.txt") clear
					
					gen ano = 2000
					lab var ano "ano da pesquisa"

					g munic = int(v0103/10)
					lab var munic "municipality codes without DV (6 digits)"

					/* Finaliza se compatibilização escolhida */
					if "`comp'" != "" {
						di as err "Compatibilização não disponível para opção Famílias"
						exit
						}
					tempfile CENSO00_`UF'_fam_`suf'
					save `CENSO00_`UF'_fam_`suf'', replace
					}
				if "`pes'"~="" {
					display as input "Extraindo `ano' `UF' - `suf' ..."
					
					tempfile dic
					local dic "`dic'.dct"

					findfile dict.dta

					read_compdct, compdct("`r(fn)'") dict_name("censo`ano'pes`lang'") out("`dic'")
					
					/* Abrindo arquivo                              */
					/* Também há versões .dat e .txt dos arquivos,  */
					/* então uso "capture" de novo.                 */
					quietly cap infile using `dic', using("`original'/pes`suf'.txt") clear
					if _rc == 601 quietly cap infile using `dic', using("`original'/pes`suf'.dat") clear
				
					gen ano = 2000
					lab var ano " ano da pesquisa"					
					g munic = int(v0103/10)
					lab var munic "municipality codes without DV (6 digits)"

					/* Compatibiliza, se especificado */
					if "`comp'" != "" {
						compat_censo00pess

						/* Áreas Mínimas Comparáveis */
						findfile amcs.dta
						sort munic
						merge m:1 munic using `"`r(fn)'"', nogen keep(match)
					}
					tempfile CENSO00_`UF'_pes_`suf'
					save `CENSO00_`UF'_pes_`suf'', replace
				}
				if "`dom'"~="" {
					/* Agora os domicílios */
					
					display as input "Extraindo `ano' `UF' - `suf' ..."
					
					tempfile dic
					local dic "`dic'.dct"

					findfile dict.dta

					read_compdct, compdct("`r(fn)'") dict_name("censo`ano'dom`lang'") out("`dic'")
					
					quietly cap infile using `dic', using("`original'/dom`suf'.txt") clear
					if _rc == 601 quietly cap infile using `dic', using("`original'/dom`suf'.dat") clear
				
					gen ano = 2000
					lab var ano " ano da pesquisa"
					
					g munic = int(v0103/10)
					lab var munic "municipality codes without DV (6 digits)"
					
					drop v0400 		// numero de serie = 0 para domicilios; deletar para nao haver conflito com arquivo de pessoas

					/* Compatibiliza, se especificado */
					if "`comp'" != "" {
						compat_censo00dom

						/* Áreas Mínimas Comparáveis */
						findfile amcs.dta
						sort munic
						merge m:1 munic using `"`r(fn)'"', nogen keep(match)
					}
					tempfile CENSO00_`UF'_dom_`suf'
					save `CENSO00_`UF'_dom_`suf'', replace
				}
				if "`comp'"~="" loc var = "id_dom"
				else loc var = "v0300"
				/* Merge das bases se both escolhido */
				if "`both'"~="" {
					use `CENSO00_`UF'_pes_`suf'', clear
					merge m:1 `var' using `CENSO00_`UF'_dom_`suf'', nogen keep(match)

					/* Se não for o primeiro arquivo, junta com o anterior */
					if "`suf'" != word(`"`sufixos'"', 1) {
						if "`comp'"~= "" append using CENSO00_both_`UF'_comp
						else append using CENSO00_both_`UF'
					}
					
					if "`comp'"~= "" save CENSO00_both_`UF'_comp, replace
					else save CENSO00_both_`UF', replace
				}
				/* Merge das bases se all escolhido */
				else if "`all'"~="" {
					use `CENSO00_`UF'_pes_`suf'', clear
					merge m:1 `var' v0404 using `CENSO00_`UF'_fam_`suf'', nogen keep(match)
					merge m:1 `var' using `CENSO00_`UF'_dom_`suf'', nogen keep(match)


					/* Se não for o primeiro arquivo, junta com o anterior */
					if "`suf'" != word(`"`sufixos'"', 1) {
						append using CENSO00_all_`UF'
					}
					
					save CENSO00_all_`UF', replace
				}
				else {
					if "`fam'"~="" {
						use `CENSO00_`UF'_fam_`suf'', clear
						/* Se não for o primeiro arquivo, junta com o anterior */
						if "`suf'" != word(`"`sufixos'"', 1) {
							append using CENSO00_`UF'_fam
							}
						save CENSO00_`UF'_fam, replace
						}
					if "`pes'"~="" {
						use `CENSO00_`UF'_pes_`suf'', clear
						/* Se não for o primeiro arquivo, junta com o anterior */
						if "`suf'" != word(`"`sufixos'"', 1) {
							if "`comp'"~= "" append using CENSO00_`UF'_pes_comp
							else append using CENSO00_`UF'_pes
						}
						if "`comp'"~="" save CENSO00_`UF'_pes_comp, replace
						else save CENSO00_`UF'_pes, replace
					}
					if "`dom'"~="" {
						use `CENSO00_`UF'_dom_`suf'', clear
						/* Se não for o primeiro arquivo, junta com o anterior */
						if "`suf'" != word(`"`sufixos'"', 1) {
							if "`comp'"~= "" append using CENSO00_`UF'_dom_comp
							else append using CENSO00_`UF'_dom
						}
						if "`comp'"~="" save CENSO00_`UF'_dom_comp, replace
						else save CENSO00_`UF'_dom, replace
					}
				}
			}
		}
	di as input "Atenção: utilize os microdados do Censo 2000 atualizados em 08/09/2017"
	}

	else if `ano' == 2010 {
		
		if "`fam'" != "" {
						di as err "Opção Família não disponível para o ano `ano'"
						exit
						}
		

		foreach UF in `ufs' {
			/* Achando posição da UF nas listas: */
			local pos = 1
			while word(`"`nomesUFs'"', `pos') != "`UF'" {
				local pos = `pos' + 1
			}
			/* Loop para todos os arquivos da UF                              */
			/* Transformo os conjuntos de sufixos "tokens" e pego o pos-ésimo */
			tokenize `suf2010'
			local sufixos = "``pos''"
			/* Mesmo para o código */
			tokenize `codUFs'
			local codUF = "``pos''"
			foreach suf in `sufixos' {
				if "`pes'"~="" {
					display as input "Extraindo `ano' `UF' - `suf' ..."
					/* Infile arquivo novo para os 14 municípios */
					
					tempfile dic
					local dic "`dic'.dct"

					findfile dict.dta

					read_compdct, compdct("`r(fn)'") dict_name("censo`ano'pes`lang'") out("`dic'")
					
					quietly cap infile using `dic', using("`original'/Amostra_Pessoas_14munic.txt") clear
					if _rc == 601 {
					di as err "Arquivo Amostra_Pessoas_14munic.txt não encontrado"
					di "Ver http://www.ibge.gov.br/home/estatistica/populacao/censo2010/resultados_gerais_amostra_areas_ponderacao/default_redefinidos.shtm"
					exit
						}
					qui destring, replace
					qui cap keep if v0001==`suf'
					if _rc == 198 {
					qui keep if v0001==35
					}
					tempfile CENSO10_`UF'_pes14
					save `CENSO10_`UF'_pes14', replace
										
					/* Abrindo arquivo principal */
					
					tempfile dic
					local dic "`dic'.dct"

					findfile dict.dta

					read_compdct, compdct("`r(fn)'") dict_name("censo`ano'pes`lang'") out("`dic'")
					
					quietly cap infile using `dic', using("`original'/Amostra_Pessoas_`suf'.txt") clear
										
					/* Dropando observações dos 14 municípios com erro nas áreas de ponderação - microdados separados */
					qui destring, replace
					qui drop if v0001==33 & v0002==4557 | v0001==43 & v0002==5108 |v0001==21 & v0002==5302 |v0001==24 & v0002==8102 | v0001==29 & v0002==10800 |v0001==43 & v0002==13409 | v0001==43 & v0002==14407 | v0001==43 & v0002==14902 | v0001==41 & v0002==15200 | v0001==43 & v0002==15602 | v0001==43 & v0002==16907 | v0001==41 & v0002==19905 | v0001==43 & v0002==23002 | v0001==29 & v0002==27408  
					
					/* Substituindo essas observações pelas observações do novo arquivo*/
					append using `CENSO10_`UF'_pes14'					
				
					
					gen ano = 2010
					lab var ano " ano da pesquisa"	
					* Deixando a variável v0002 com 5 dígitos
					tostring v0002, format(%05.0f) replace
					replace v0002="....." if v0002=="."
					*Criando a variável munic
					egen munic = concat(v0001 v0002)
					destring munic, replace
					replace munic = int(munic/10)
					lab var munic "municipality codes without DV (6 digits)"


					/* Compatibiliza, se especificado */
	            			if "`comp'" != "" {
						compat_censo10pess

						/* Áreas Mínimas Comparáveis */
						findfile amcs.dta
						sort munic
						merge m:1 munic using `"`r(fn)'"', nogen keep(match)
					}
					tempfile CENSO10_`UF'_pes_`suf'
					save `CENSO10_`UF'_pes_`suf'', replace
				}
				if "`dom'"~="" | "`both'"~="" {
					/* Agora os domicílios */
					display as input "Extraindo `ano' `UF' - `suf' ..."
					
					/* Infile arquivo novo para os 14 municípios */
					
					tempfile dic
					local dic "`dic'.dct"

					findfile dict.dta

					read_compdct, compdct("`r(fn)'") dict_name("censo`ano'dom`lang'") out("`dic'")
					
					quietly cap infile using `dic', using("`original'/Amostra_Domicilios_14munic.txt") clear
					if _rc == 601 {
					di as err "Arquivo Amostra_Domicilios_14munic.txt não encontrado"
					di "Ver http://www.ibge.gov.br/home/estatistica/populacao/censo2010/resultados_gerais_amostra_areas_ponderacao/default_redefinidos.shtm"
					exit
					}
					qui destring, replace
					qui cap keep if v0001==`suf'
					if _rc == 198 {
					qui keep if v0001==35
					}
					tempfile CENSO10_`UF'_dom14
					save `CENSO10_`UF'_dom14', replace
										
					/* Abrindo arquivo principal */
					
					tempfile dic
					local dic "`dic'.dct"

					findfile dict.dta

					read_compdct, compdct("`r(fn)'") dict_name("censo`ano'dom`lang'") out("`dic'")
					
					quietly cap infile using `dic', using("`original'/Amostra_Domicilios_`suf'.txt") clear
									
					/* Dropando observações dos 14 municípios com erro nas áreas de ponderação - microdados separados */
					qui destring, replace
					qui drop if v0001==33 & v0002==4557 | v0001==43 & v0002==5108 |v0001==21 & v0002==5302 |v0001==24 & v0002==8102 | v0001==29 & v0002==10800 |v0001==43 & v0002==13409 | v0001==43 & v0002==14407 | v0001==43 & v0002==14902 | v0001==41 & v0002==15200 | v0001==43 & v0002==15602 | v0001==43 & v0002==16907 | v0001==41 & v0002==19905 | v0001==43 & v0002==23002 | v0001==29 & v0002==27408  
					
					/* Substituindo essas observações pelas observações do novo arquivo*/
					append using `CENSO10_`UF'_dom14'
					
					
					gen ano = 2010
					lab var ano " ano da pesquisa"
					* Deixando a variável v0002 com 5 dígitos
					tostring v0002, format(%05.0f) replace
					replace v0002="....." if v0002=="."
					*Criando a variável munic
					egen munic = concat(v0001 v0002)
					destring munic, replace
					replace munic = int(munic/10)
					lab var munic "municipality codes without DV (6 digits)"

					/* Compatibiliza, se especificado */
	            			if "`comp'" != "" {
						compat_censo10dom

						/* Áreas Mínimas Comparáveis */
						findfile amcs.dta
						sort munic
						merge m:1 munic using `"`r(fn)'"', nogen keep(match)
	            	}
					tempfile CENSO10_`UF'_dom_`suf'
					save `CENSO10_`UF'_dom_`suf'', replace
				}
				if "`comp'"~="" loc var = "id_dom"
				else loc var = "v0300"
				if "`both'"~="" {
					use `CENSO10_`UF'_pes_`suf'', clear
					merge m:1 `var' using `CENSO10_`UF'_dom_`suf'', nogen keep(match)
					/* Se não for o primeiro arquivo, junta com o anterior */
					if "`suf'" != word(`"`sufixos'"', 1) {
						if "`comp'"~= "" append using CENSO10_`UF'_comp
						else append using CENSO10_`UF'
					}
					if "`comp'"~= "" save CENSO10_`UF'_comp, replace
					else save CENSO10_`UF', replace
				}
				else {
					if "`pes'"~="" {
						use `CENSO10_`UF'_pes_`suf'', clear
						/* Se não for o primeiro arquivo, junta com o anterior */
						if "`suf'" != word(`"`sufixos'"', 1) {
							if "`comp'"~= "" append using CENSO10_`UF'_pes_comp
							else append using CENSO10_`UF'_pes
						}
						if "`comp'"~="" save CENSO10_`UF'_pes_comp, replace
						else save CENSO10_`UF'_pes, replace
					}
					else {
						use `CENSO10_`UF'_dom_`suf'', clear
						/* Se não for o primeiro arquivo, junta com o anterior */
						if "`suf'" != word(`"`sufixos'"', 1) {
							if "`comp'"~= "" append using CENSO10_`UF'_dom_comp
							else append using CENSO10_`UF'_dom
						}
						if "`comp'"~="" save CENSO10_`UF'_dom_comp, replace
						else save CENSO10_`UF'_dom, replace
					}
				}
			}
		}
	}

**************
* CENSO 2022 *
**************
else if `ano' == 2022 {
// PRECISA VERIFICAR SE TEM ALGUMA OUTRA PADRONIZACAO NECESSARIA PARA O ANO DE 2022 QUE NAO TINHA SIDO FEITA EM ANOS ANTERIORES
// NOTAR OUTROS COMENTARIOS EM CADA ETAPA DA LEITURA E AGRUPAMENTO DOS ARQUIVOS DE DOMICILIOS E PESSOAS

/* tambem tem a opcao de familia para 2022, entao esse bloco n é valido
		if "`fam'" != "" {
						di as err "Opção Família não disponível para o ano `ano'"
						exit
						}
						*/
		if "`txt22'"!="" {
		    display as input "Ainda não foi implementada a leitura em TXT para o Censo de 2022. Use os arquivos em CSV"
		}
		
		if "`csv22'"!="" {
		    display as input "Certifique de estar usando os dados originais em CSV para a leitura correta do Censo de 2022"
		}
			
		foreach UF in `ufs' {
			* Achando posição da UF nas listas:
			local pos = 1
			while word(`"`nomesUFs'"', `pos') != "`UF'" {
				local pos = `pos' + 1
			}

			* Loop para todos os arquivos da UF                              
			* Transformo os conjuntos de sufixos "tokens" e pego o pos-ésimo
			tokenize `suf2022'
			local sufixos = "``pos''"
			* Mesmo para o código
			tokenize `codUFs'
			local codUF = "``pos''"
			foreach suf in `sufixos' {
				if "`pes'"~="" {
					display as input "Extraindo `ano' `UF' - `suf' ..."
					
			/* logica de leitura para txt (usando dicionario)		
			* 		Abrindo arquivo principal
					
			*		tempfile dic

			*		findfile dict.dta

			*		read_compdct, compdct("`r(fn)'") dict_name("censo`ano'pes`lang'") out("`dic'") */
					
					
			* logica de leitura com csv
					import delimited "`original'/Pessoas_`suf'_publico.csv", delimiter(";") case(preserve) clear
										
					gen ano = 2022
					lab var ano "ano da pesquisa"
					
					save CENSO22_`UF'_pes, replace

					/* criacao de codigo de municipio, que nao tem nos dados de acesso publico
					
					* Deixando a variável v0002 com 5 dígitos
					tostring v0002, format(%05.0f) replace // VERIFICAR SE VIRA COM 6 DIGITOS A VARIAVEL DE MUNIC E VERIFICAR O NUMERO DA VARIAVEL DE MUNIC
					replace v0002="....." if v0002=="."
					*Criando a variável munic
					egen munic = concat(v0001 v0002)
					destring munic, replace
					replace munic = int(munic/10)
					lab var munic "municipality codes without DV (6 digits)" */

					/* compatibilizacao, que vai ser implementada em breve
					
					* Compatibiliza, se especificado
	            	if "`comp'" != "" {
						compat_censo22pess

						* Áreas Mínimas Comparáveis
						findfile amcs.dta // VERIFICAR NOVO DOCUMENTO DE AREAS MINIMAS COMPARAVEIS COM COMPATIBILIZACAO PARA ANO DE 2022
						sort munic
						merge m:1 munic using `"`r(fn)'"', nogen keep(match)
					}
					tempfile CENSO22_`UF'_pes_`suf'
					save `CENSO22_`UF'_pes_`suf'', replace
					
					*/
				}
				if "`dom'"!="" /*| "`both'"~="" //quando tiver implementado o recurso de mergear pes e dom*/ { 
					/* Agora os domicílios */
					display as input "Extraindo `ano' `UF' - `suf' ..."
															
					
					/* logica para txt (com dicionario)
					* Abrindo arquivo principal
					
					tempfile dic

					findfile dict.dta

					read_compdct, compdct("`r(fn)'") dict_name("censo`ano'dom`lang'") out("`dic'")
					
					quietly cap infile using `dic', using("`original'/Domicilios_`suf'_publico.txt") clear */
					
					* Leitura para csv
					import delimited "`original'/Domicilios_`suf'_publico.csv", delimiter(";") case(preserve) clear
					
					gen ano = 2022
					lab var ano "ano da pesquisa"
					
					/* criacao de codigo de municipio, que nao tem nos dados de acesso publico

					* Deixando a variável v0002 com 5 dígitos
					tostring v0002, format(%05.0f) replace // VERIFICAR SE VIRA COM 6 DIGITOS A VARIAVEL DE MUNIC E VERIFICAR O NUMERO DA VARIAVEL DE MUNIC
					replace v0002="....." if v0002=="."
					*Criando a variável munic
					egen munic = concat(v0001 v0002)
					destring munic, replace
					replace munic = int(munic/10)
					lab var munic "municipality codes without DV (6 digits)" */
					
					
					/* compatibilizacao, que vai ser implementada em breve

					* Compatibiliza, se especificado 
	            	if "`comp'" != "" {
						compat_censo22dom

						* Áreas Mínimas Comparáveis 
						findfile amcs.dta // VERIFICAR NOVO DOCUMENTO DE AREAS MINIMAS COMPARAVEIS COM COMPATIBILIZACAO PARA ANO DE 2022
						sort munic
						merge m:1 munic using `"`r(fn)'"', nogen keep(match)
	            	}
					tempfile CENSO22_`UF'_dom_`suf' 
					save `CENSO22_`UF'_dom_`suf'', replace */
					
					save CENSO22_`UF'_dom, replace
					
				}/* logica de merge e compatibilizacao, que ainda vai ser implementada
				if "`comp'"~="" loc var = "id_dom"
				else loc var = "v0300" // VARIAVEL DE CONTROLE - VERIFICAL O NUMERO NO NOVO CENSO
				if "`both'"~="" {
					use `CENSO22_`UF'_pes_`suf'', clear
					merge m:1 `var' using `CENSO22_`UF'_dom_`suf'', nogen keep(match)
					/* Se não for o primeiro arquivo, junta com o anterior */
					if "`suf'" != word(`"`sufixos'"', 1) {
						if "`comp'"~= "" append using CENSO22_`UF'_comp
						else append using CENSO22_`UF'
					}
					if "`comp'"~= "" save CENSO22_`UF'_comp, replace
					else save CENSO22_`UF', replace
				}
				else {
					if "`pes'"~="" {
						use `CENSO22_`UF'_pes_`suf'', clear
						/* Se não for o primeiro arquivo, junta com o anterior */
						if "`suf'" != word(`"`sufixos'"', 1) {
							if "`comp'"~= "" append using CENSO22_`UF'_pes_comp
							else append using CENSO22_`UF'_pes
						}
						if "`comp'"~="" save CENSO22_`UF'_pes_comp, replace
						else save CENSO22_`UF'_pes, replace
					}
					else {
						use `CENSO22_`UF'_dom_`suf'', clear
						/* Se não for o primeiro arquivo, junta com o anterior */
						if "`suf'" != word(`"`sufixos'"', 1) {
							if "`comp'"~= "" append using CENSO22_`UF'_dom_comp
							else append using CENSO22_`UF'_dom
						}
						if "`comp'"~="" save CENSO22_`UF'_dom_comp, replace
						else save CENSO22_`UF'_dom, replace 
						*/
						
					if "`fam'"!="" {
					display as input "Extraindo `ano' `UF' - `suf' ..."	
					
					import delimited "`original'/Familia_`suf'_publico.csv", delimiter(";") case(preserve) clear
										
					gen ano = 2022
					lab var ano "ano da pesquisa"
					
					save CENSO22_`UF'_fam, replace
					
					}
					
					/* criando leitura para o dataset de mortalidade
					if "`mort'"~="" {
					display as input "Extraindo `ano' `UF' - `suf' ..."	
					
					import delimited "`original'/Mortalidade_`suf'_publico.csv", delimiter(";") case(preserve) clear
										
					gen ano = 2022
					lab var ano "ano da pesquisa"
					
					save CENSO22_`UF'_mort, replace }*/
					
					
				}
			}
		}
	}

**************
* CENSO 2022 *
**************


display as result "As bases de dados foram salvas na pasta `c(pwd)'"

di _newline "Esta versão do pacote datazoom_censo é compatível com os microdados do Censo 2010 divulgados em 11/03/2016, do Censo 2000 divulgados em 08/09/2017, e do Censo de 2022 divulgados em 31/08/2026."

end

program define compat_censo00dom

/* A. ANO */
* Essa variável é definida antes de chamar este programa.

/* B. IDENTIFICAÇÃO E NÚMERO DE PESSOAS */

/* B.1. IDENTIFICAÇÃO */
rename v0102 UF
rename v1001 regiao

drop v0103

rename v0300 id_dom

drop v1002 v1003 v0104 v0105 v1004 AREAP

/* B.2. VARIÁVEIS DE NÚMERO DE PESSOAS */

rename v0110 n_homem_dom
rename v0111 n_mulher_dom
rename v7100 n_pes_dom
drop v7401-v7409

/* C. OUTRAS VARIÁVEIS DE DOMICÍLIO */

/* C.1. SITUAÇÃO */
rename v1005 sit_setor
lab var sit_setor "situação do domicílio - desagregado"
* sit_setor = 1 - Área urbanizada de vila ou cidade
*             2 - Área não urbanizada de vila ou cidade
*             3 - Área urbanizada isolada
*             4 - Rural - extensão urbana
*             5 - Rural - povoado
*             6 - Rural - núcleo
*             7 - Rural - outros aglomerados
*             8 - Rural - exclusive os aglomerados rurais

gen sit_setor_B = sit_setor
recode sit_setor_B (1 2 = 1) (3=2) (4/7 = 3) (8=4)
lab var sit_setor_B "situação do domicílio - agregado"
* sit_setor_B = 1 - Vila ou cidade
*               2 - Urbana isolada
*               3 - Aglomerado rural
*               4 - Rural exclusive os aglomerados

gen sit_setor_C = sit_setor_B
recode sit_setor_C (1 2 = 1) (3 4 = 0)
lab var  sit_setor_C "situação do domicílio - urbano/rural"
* sit_setor_C = 1 - Urbana
*               0 - Rural
drop v1006


/* C.2. ESPÉCIE */
recode v0201 (1 = 0) (2 = 1) (3 = 2)
rename v0201 especie
* especie = 0 - particular permanente
*           1 - particular improvisado
*           2 - coletivo

/* C.3.	MATERIAL DAS PAREDES */

/* C.4.	MATERIAL DA COBERTURA */

/* C.5. TIPO */
gen subnormal = 0 if (especie == 0) & ((v0202 == 1) | (v0202 == 2))
replace subnormal = 1 if (especie == 0) & ((v0202 == 1 | v0202 == 2) & v1007 == 1)
lab var subnormal "dummy para setor subnormal"
* Somente para domicílios particulares permanentes tipo casa ou apt (não cômodo)
* subnormal = 0 - não
*             1 - sim

drop v1007

rename v0202 tipo_dom
* tipo_dom = 1 - casa
*            2 - apartamento
*            3 - cômodo
lab var tipo_dom "tipo de domicílio"

gen tipo_dom_B = tipo_dom
recode tipo_dom_B (3=2)
* tipo_dom_B = 1 - casa
*              2 - apartamento (ou cômodo)
lab var tipo_dom_B "tipo de domicílio B"


/* C.6. CONDIÇÃO DE OCUPAÇÃO E ALUGUEL */
gen dom_pago = 1 if v0205==1
replace dom_pago = 0 if v0205==2
lab var dom_pago "dummy para domicílio próprio já pago"
* dom_pago = 0 - Domicílio próprio em aquisição
*            1 - Domicílio próprio já pago

g cond_ocup = v0205
recode cond_ocup (2=1) (3=2) (4=3) (5=4) (6=5) (0=.) // (1=1)
* cond_ocup = 1 - próprio
*             2 - alugado
*             3 - cedido por empregador
*             4 - cedido de outra forma
*             5 - outra condição
lab var cond_ocup "condição de ocupação do domicílio"

gen cond_ocup_B = cond_ocup
recode cond_ocup_B (4=3) (5=4) // 1 a 3 mantidos
* cond_ocup_B = 1 - próprio
*               2 - alugado
*               3 - cedido
*               4 - outra condição
lab var cond_ocup_B "condição de ocupação do domicílio B"

rename v0205 cond_ocup_C


recode v0206 (2 3 = 0) // (1=1)
rename v0206 terreno_prop
* terreno_prop = 0 - não
*                1 - sim


/* C.7. ABASTECIMENTO DE ÁGUA */
gen abast_agua = 1 if (v0207 == 1) & (v0208 == 1)
replace abast_agua = 2 if (v0207 == 1) & ((v0208 == 2) | (v0208 == 3))
replace abast_agua = 3 if (v0207 == 2) & (v0208 == 1)
replace abast_agua = 4 if (v0207 == 2) & ((v0208 == 2) | (v0208 == 3))
replace abast_agua = 5 if v0207 == 3
* abast_agua = 1 - rede geral com canalização interna
*              2 - rede geral sem canalização interna
*              3 - poço ou nascente com canalização interna
*              4 - poço ou nascente sem canalização interna
*              5 - outra forma
lab var abast_agua "forma de abastecimento de água"

drop v0207

rename v0208 agua_canal
*agua_canal = 1 - Canalizada em pelo menos um cômodo
*              2 - Canalizada só na propriedade ou terreno
*              3 - Não canalizada


/* C.8. INSTALAÇÕES SANITÁRIAS */
* v0209 é número de banheiros; se há algum, considero que há instalações sanitárias
* originalmente v0210 se refere à existência de instalação que não seja um banheiro
replace v0210 = 1 if (v0209 >= 1 & v0209 != .)
recode v0210 (2=0) // (1=1)
rename v0210 sanitario
* sanitario = 0 - não tem acesso
*                1 - tem acesso


replace v0209 = 5 if (v0209 >= 5) & (v0209 != .)
rename v0209 banheiros
lab var banheiros "número de banheiros"
* banheiros = 0 - não tem
*             1 a 4 - número de banheiros
*             5 - cinco ou mais banheiros

g tipo_esc_san_B = v0211
*tipo_esc_san_B = 1 - Rede geral de esgoto ou pluvial
*                 2 - Fossa séptica
*                 3 - Fossa rudimentar
*                 4 - Vala
*                 5 - Rio, lago ou mar
*                 6 - Outro 
lab var tipo_esc_san_B "tipo de escoadouro - desagregado"

recode v0211 (5 6 = 4) // 1 a 4 mantidos
rename v0211 tipo_esc_san
* tipo_esc_san = 1 - Rede geral
*                2 - Fossa séptica
*                3 - Fossa rudimentar
*                4 - Outro escoadouro


/* C.9. DESTINO DO LIXO */
rename v0212 dest_lixo
* dest_lixo = 1 - Coletado por serviço de limpeza
*             2 - Colocado em caçamba de serviço de limpeza
*             3 - Queimado(na propriedade)
*             4 - Enterrado(na propriedade)
*             5 - Jogado em terreno baldio ou logradouro
*             6 - Jogado em rio, lago ou mar
*             7 - Tem outro destino

gen dest_lixo_B = dest_lixo
recode dest_lixo_B (7=6)
* dest_lixo_B = 1 - Coletado no domicílio por serviço de limpeza
*             	2 - Colocado em caçamba de serviço de limpeza
*             	3 - Queimado na propriedade
*             	4 - Enterrado na propriedade
*             	5 - Jogado em terreno baldio, encosta ou área pública
*             	6 - Outro destino

/* C.10. ILUMINAÇÃO ELÉTRICA */
recode v0213 (2=0) // (1=1)
rename v0213 ilum_eletr
* ilum_eletr = 0 - não tem
*              1 - tem


/* C.11. BENS DE CONSUMO DURÁVEIS */
* Em 2000, não foi pesquisada a posse e o tipo de fogão.

recode v0214 (2=0) // (1=1)
rename v0214 radio
* radio = 0 - não tem
*         1 - tem

recode v0215 (2=0) // (1=1)
rename v0215 gelad_ou_fre
* gelad_ou_fre = 0 - não tem
*                1 - tem

recode v0217 (2=0) // (1=1)
rename v0217 lavaroupa
* lavaroupa = 0 - não tem	
* 		1 - tem

recode v0219 (2=0) // (1=1)
rename v0219 telefone
* telefone = 0 - não tem
*            1 - tem

recode v0220 (2=0) // (1=1)
rename v0220 microcomp
* microcomp = 0 - não tem
*             1 - tem

recode v0221 (2/9 = 1) // 0 e 1 mantidos
rename v0221 televisao
* televisao = 0 - não tem
*             1 - tem

recode v0222 (2/9 = 1) // 0 e 1 mantidos
rename v0222 automovel
* automovel = 0 - não tem
*             1 - tem

* videocassete, microondas, ar condicionado
drop v0216 v0218 v0223


/* C.12. NÚMERO DE CÔMODOS */
rename v0203 tot_comodos
rename v0204 tot_dorm

drop v7203 v7204 


/* C.13. RENDA DOMICILIAR */
recode v7616 (999999 = .)
rename v7616 renda_dom
drop v7617	// em salarios minimos

/* DEFLACIONANDO RENDAS: referência = julho/2022 */
g double deflator = 0.2426823264085210000
g conversor = 1

lab var deflator "deflator de rendimentos - base julho/2022"
lab var conversor "conversor de moedas"

g renda_dom_def = (renda_dom/conversor)/deflator
lab var renda_dom_def "renda_dom deflacionada"

/* C.14. PESO AMOSTRAL */
rename P001 peso_dom

/* Variáveis de domicílio não utilizadas */
* identificacao, iluminacao publica, pavimentacao
drop v1111 v1112 v1113

end

program define compat_censo00pess

/* A. ANO */
* Essa variável é definida antes de chamar este programa.

/* B. IDENTIFICAÇÃO E NÚMERO DE PESSOAS */

/* B.1. IDENTIFICAÇÃO */
rename v0102 UF
rename v0103 id_muni
rename v0300 id_dom
rename v0404 num_fam
* num_fam = 0 - membro individual em dom coletivo
*           1 a 9 - número da família no domicílio
rename v0400 ordem

/* B.2. VARIÁVEIS DE NÚMERO DE PESSOAS */
* Via "count":
sort id_muni id_dom num_fam, stable
by id_muni id_dom num_fam: egen n_homem_fam = total(v0401==1)
by id_muni id_dom num_fam: egen n_mulher_fam = total(v0401==2)
egen n_pes_fam = rowtotal(n_homem_fam n_mulher_fam)

lab var n_homem_fam "número de homens na família" 
lab var n_mulher_fam "número de mulheres na família"
lab var n_pes_fam "número de pessoas na família"

/* C. OUTRAS VARIÁVEIS DE DOMICÍLIO */

/* C.1. SITUAÇÃO E LOCALIZAÇÃO */
rename v1001 regiao
drop v1004 AREAP
recode v1005 (1/3 = 1) (4/8 = 0)
rename v1005 sit_setor_C
* sit_setor_C = 1 – Urbana
*               0 – Rural

drop v1006

drop v1002 v1003 v0104 v0105 v1007


/* D. VARIÁVEIS DE PESSOA */

/* D.0. CONDIÇÃO DE INFORMANTE E PRESENÇA */
drop MARCA // não registrado em 1991

/* D.1. SEXO */
recode v0401 (2=0) // (1=1)
rename v0401 sexo
* sexo = 0 - feminino
*        1 - masculino

/* D.2. CONDIÇÃO NA FAMÍLIA E NO DOMICÍLIO */
rename v0402 cond_dom
* cond_dom =  1 - Pessoa responsável
*                 2 - Cônjuge, companheiro(a)
*                 3 - Filho(a), enteado(a)
*                 4 - Pai, mãe, sogro(a)
*                 5 - Neto(a), bisneto(a)
*                 6 - Irmão, irmã
*                 7 - Outro parente
*                 8 - Agregado(a)
*                 9 - Pensionista
*                10 - Empregado(a) doméstico(a)
*                11 - Parente do(a) empregado(a) doméstico(a)
*                12 - Individual em domicílio coletivo

rename v0403 cond_fam
* cond_fam =  1 - Pessoa responsável
*                 2 - Cônjuge, companheiro(a)
*                 3 - Filho(a), enteado(a)
*                 4 - Pai, mãe, sogro(a)
*                 5 - Neto(a), bisneto(a)
*                 6 - Irmão, irmã
*                 7 - Outro parente
*                 8 - Agregado(a)
*                 9 - Pensionista
*                10 - Empregado(a) doméstico(a)
*                11 - Parente do(a) empregado(a) doméstico(a)
*                12 - Individual em domicílio coletivo

gen cond_dom_B = cond_dom
recode cond_dom_B (5/7 = 5) (8=6) (9=7) (10=8) (11=9) (12=10) // 1 a 4 mantidos
gen cond_fam_B = cond_fam
recode cond_fam_B (5/7 = 5) (8=6) (9=7) (10=8) (11=9) (12=10) // 1 a 4 mantidos
* cond_***_B =  1 - Pessoa responsável
*               2 - Cônjuge, companheiro(a)
*               3 - Filho(a), enteado(a)
*               4 - Pai, mãe, sogro(a)
*               5 - Outro parente
*               6 - Agregado
*               7 - Hóspede, pensionista
*               8 - Empregado(a) doméstico(a)
*               9 - Parente do(a) empregado(a) doméstico(a)
*              10 - Individual em domicílio coletivo

lab var cond_dom_B "relação com o responsável do domicílio B"
lab var cond_fam_B "relação com o responsável da família B"


/* D.3. IDADE */
rename v4752 idade
replace v4754 = . if idade>0
rename v4754 idade_meses

recode v4070 (1=0) (2=1)
rename v4070 idade_presumida
*lab def idade_presumida 1 sim 0 nao
* idade_presumida = 0 - não
*                   1 - sim

/* D.4. COR OU RAÇA */
recode v0408 (9=.)
rename v0408 raca
* raca = 1 - branca
*               2 - preta
*               3 - amarela
*               4 - parda
*               5 - indígena

gen racaB = raca
recode racaB (5=4) // 1 a 4 mantidos
* racaB = 1 - branca
*                2 - preta
*                3 - amarela
*                4 - parda
lab var racaB "cor ou raça (indígena=pardo)"


/* D.5. RELIGIÃO */
replace v4090 = int(v4090/10) // dois primeiros dígitos = religião com os códs de 1991
recode v4090 (11/19 =1) (21/28 = 2) (31/48 = 3) (61=4) (62 63 64= 5) (74 75 76 78 79 = 6) ///
             (71=7) (30 49 51 52 53 59 81 82 83 84 12 13 19 = 8) (85 86 89 99 = .)
rename v4090 religiao
* religiao = 0 - sem religião
*            1 - católica
*            2 - evangélica tradicional
*            3 - evangélica pentecostal
*            4 - espírita kardecista
*            5 - espírita afro-brasileira
*            6 - religiões orientais
*            7 - judaica/israelita
*            8 - outras religiões

gen religiao_A = religiao
recode religiao_A (3 = 2) (4 = 3) (5 = 4) (6 = 5) (7 = 6) (8 = 7)
lab var religiao_A "religião A - mais agregada"
* religiao_A = 0 - sem religião
*            1 - católica
*            2 - evangélica
*            3 - espírita kardecista
*            4 - espírita afro-brasileira
*            5 - religiões orientais
*            6 - judaica/israelita
*            7 - outras religiões

gen religiao_B = religiao
recode religiao_B (3=2) (4 5 = 3) (6/8 = 4)
lab var religiao_B "religião - mais agregada"
* religiao_B = 0 - sem religião
*              1 - católica
*              2 - evangélica
*              3 - espírita
*              4 - outra

/* D.6. DEFICIÊNCIAS FÍSICA E MENTAL  */
* nao dá pra compatibilizar com 1991
drop v0414

recode v0411 (9= .)
rename v0411 dif_enxergar
	*dif_enxergar = 1- Sim, não consegue de modo algum
	*				2- Sim, grande dificuldade
	*				3- Sim, alguma dificuldade
	*				4- Não, nenhuma dificuldade
	
	
recode v0412 (9= .)
rename v0412 dif_ouvir
	*dif_ouvir = 1- Sim, não consegue de modo algum
	*			 2- Sim, grande dificuldade
	*			 3- Sim, alguma dificuldade
	*			 4- Não, nenhuma dificuldade

recode v0413 (9= .)
rename v0413 dif_caminhar
	*dif_caminhar = 1- Sim, não consegue de modo algum
	*			 2- Sim, grande dificuldade
	*			 3- Sim, alguma dificuldade
	*			 4- Não, nenhuma dificuldade

recode v0410 (2=0) (9= .) // 1=1
rename v0410 def_mental
	*def_mental = 1 - Sim
	*			  0 - Não


/* D.7. NATURALIDADE E MIGRAÇÃO */

*** Condição de migrante
recode v0415 (2=0) // (1=1)
rename v0415 sempre_morou
* sempre_morou = 0 - não
*                1 - sim

*** Nacionalidade e naturalidade
recode v0417 (2=0) // (1=1)
replace v0417 = 1 if sempre_morou == 1 // originalmente é missing
rename v0417 nasceu_mun
label var nasceu_mun "Nasceu neste município"
* nasceu_mun = 0 - não
*              1 - sim

recode v0418 (2=0) // (1=1)
replace v0418 = 1 if nasceu_mun == 1 // originalmente é missing
rename v0418 nasceu_UF
* nasceu_UF = 0 - não
*             1 - sim

replace v0419 = 1 if nasceu_UF == 1 // originalmente é missing
recode v0419 (1=0) (2=1) (3=2)
rename v0419 nacionalidade
* nacionalidade = 0 - brasileiro nato
*                 1 - brasileiro naturalizado
*                 2 - estrangeiro

rename v0420 ano_fix_res

gen UF_nascim = v4210 
recode UF_nascim (29/99=.) (1=11) (2=12) (3=13) (4=14) (5=15) (6=16) (7=17) (8=21) (9=22) (10=23) ///
				 (11=24) (12=25) (13=26) (14=27) (15=28) (16=29) (17=31) (18=32) (19=33) ///
				 (20=35) (21=41) (22=42) (23=43) (24=50) (25=51) (26=52) (27=53) 
label var UF_nascim "UF de nascimento"
* UF_nascim = 11-53 UF de nascimento especificada

recode v4210 (1/29 99 = .) (82 84 85 = 83 )	(83 = 82 ) (86 87=84 ) ///
	(88=86 ) (89=87 ) (90=88 ) (91=89 ) (92=90 ) (93=91 ) ///
	(94=92 ) (95=93 ) (96=94 ) (97=95 ) (98=96 ), copy g(pais_nascim)
* pais_nascim = 30-98 país estrangeiro especificado
* 82 = Egito	
* 83 = Africa - outros  
* 84 = China 
* 86 = Coréia 
* 87 = Índia 
* 88 = Israel 
* 89 = Japão 
* 90 = Líbano 
* 91 = Paquistão 
* 92 = Síria 
* 93 = Turquia 
* 94 = Ásia - outros 
* 95 = Australia
* 96 = Oceania
label var pais_nascim "País de nascimento - códigos 1970"
drop v4210

*** Última migração
rename v0416 anos_mor_mun
rename v0422 anos_mor_UF

* tempo de moradia em 1970 só vale para quem não nasceu no município.
g t_mor_UF_70 = anos_mor_UF
g t_mor_mun_70 = anos_mor_mun
recode t_mor_UF_70 t_mor_mun_70 (7/10=6) (11/max=7)
lab var t_mor_UF_70 "tempo de moradia na UF - grupos de 1970"
lab var t_mor_mun_70 "tempo de moradia no municipio - grupos de 1970"

* De 1980 em diante, podemos montar a variavel de tempo de moradia incluindo
* pessoas que nasceram mas nem sempre moraram no municipio em que residem

recode anos_mor_UF (7/9 =6) (10/max =7), g(t_mor_UF_80)
recode anos_mor_mun (7/9 =6) (10/max =7), g(t_mor_mun_80)
lab var t_mor_UF_80 "tempo de moradia na UF - grupos de 1980"
lab var t_mor_mun_80 "tempo de moradia no municipio - grupos de 1980"

*** Onde morava anteriormente - para quem migrou nos últimos 10 anos:
* Em 2000 não foi pesquisado o MUNICIPIO e a situação de residência anterior.
gen UF_mor_ant = v4230 if v4230~=0
recode UF_mor_ant (29/99 = .) (1=11) (2=12) (3=13) (4=14) (5=15) (6=16) (7=17) (8=21) (9=22) (10=23) ///
				 (11=24) (12=25) (13=26) (14=27) (15=28) (16=29) (17=31) (18=32) (19=33) ///
				 (20=35) (21=41) (22=42) (23=43) (24=50) (25=51) (26=52) (27=53) 
label var UF_mor_ant "UF onde morava anteriormente (se migrou nos últ 10 anos)"
* UF_mor_ant = 11-53 código da UF em que morava
			  
recode v4230 (0=.) (1/29 = .) ///	// aqui 0 era, originalmente, "ignorado"; passa a "missing"
	(82 84 85 = 83 ) (83 = 82 )	(86 87=84 ) (88=86 ) (89=87 ) ///
	(90=88 ) (91=89 ) (92=90 ) (93=91 ) (94=92 ) (95=93 ) (96=94 ) ///   
	(97=95 ) (98=96 )
rename v4230 pais_mor_ant
label var pais_mor_ant "País onde morava anteriormente (se migrou nos últ 10 anos)"
* pais_mor_ant = 30-98 país estrangeiro especificado


*** Onde morava há 5 anos:
recode v0424 (1 3 = 1) (2 4 = 0) (5 6 =.)
rename v0424 sit_dom5anos
* sit_dom5anos = 1 - zona urbana
*                0 - zona rural

replace v4250 = . if v4250>5400000
rename v4250 mun_mor5anos

gen UF_mor5anos = v4260 if (v4260 >= 1 & v4260 <= 29)
recode UF_mor5anos (1=11) (2=12) (3=13) (4=14) (5=15) (6=16) (7=17) (8=21) (9=22) (10=23) ///
				   (11=24) (12=25) (13=26) (14=27) (15=28) (16=29) (17=31) (18=32) (19=33) ///
				   (20=35) (21=41) (22=42) (23=43) (24=50) (25=51) (26=52) (27=53) (0 29=.) 
label var UF_mor5anos "UF onde morava há 5 anos"
* UF_mor5anos = 11-53 código da UF em que morava

recode v4260 (1/29 99= .) (82 84 85 = 83 )	(83 = 82 )	(82=82 ) ///
	(79=79 ) (80=80 ) (81=81 ) (86 87=84 ) (88=86 ) (89=87 ) ///
	(90=88 ) (91=89 ) (92=90 ) (93=91 ) (94=92 ) (95=93 ) (96=94 ) ///   
	(97=95 ) (98=96 )
rename v4260 pais_mor5anos
label var pais_mor5anos "País onde morava há 5 anos"
* pais_mor5anos = 30-98 país estrangeiro especificado


/* D.8. EDUCAÇÃO */
recode v0428 (2=0) // (1=1)
replace v0428 = . if idade<5
rename v0428 alfabetizado
* alfabetizado = 0 - não
*                1 - sim (sabe ler e escrever)
recode v0429 (1 2 =1 "sim") (3 4 =0 "nao"), g(freq_escola)	// exclui pre-escola, creche e pre-vestibular
replace freq_escola = 0 if v0430<=3 | v0430==11
lab var freq_escola "frequenta escola"
* freq_escola = 0 - não
*                1 - sim

g freq_escolaB = freq_escola
replace freq_escolaB = 1 if v0430 == 2 | v0430==3 // inclui pre-escola
lab var freq_escolaB "frequenta escola - inclui pre-escola"
* freq_escolaB = 0 - não
*                1 - sim

* rede de ensino 
recode v0429 (2 = 1) (1 = 0) (else=.) 
replace v0429 = . if v0430==11	// para compatibilizar com 2010, exclui pre-vestibular
rename v0429 rede_freq
lab var rede_freq "rede de ensino da escola"
* rede_freq = 0 - particular
*             1 - pública

* grupos de anos de estudo
* para quem frequenta escola
recode v4300 (min/3 20 30 = 0) (4/7 = 1) (8/10 = 2) (11/14 = 3) (15/max = 4), g(anos_estudoC)
replace anos_estudoC = 3 if anos_estudoC==4 & v0430==12 
replace anos_estudoC = . if v0430==.

* para quem nao frequenta escola
replace anos_estudoC = 0 if v0432==1 	// alfabetizacao de adultos
replace anos_estudoC = 0 if v0432==2 & v0434==2 	// antigo primario sem conclusao
replace anos_estudoC = 0 if v0432==5 & v0434==2 & (v0433<=3 | v0433==9 | v0433==10)	// fundamental/1o.grau sem conclusao - 1a-3a serie
	
replace anos_estudoC = 1 if v0432==2 & v0434==1 	// antigo primario com conclusao
replace anos_estudoC = 1 if v0432==3 & v0434==2 	// antigo ginasio sem conclusao
replace anos_estudoC = 1 if v0432==5 & v0434==2 & v0433>=4 & v0433<9		// fundamental/1o.grau sem conclusao - 1a-3a serie

replace anos_estudoC = 2 if v0432==3 & v0434==1 	// antigo ginasio com conclusao
replace anos_estudoC = 2 if v0432==4 & v0434==2 	// classico/cientifico sem conclusao
replace anos_estudoC = 2 if v0432==5 & v0434==1 	// fundamental/1o.grau com conclusao
replace anos_estudoC = 2 if v0432==6 & v0434==2 	// medio/2o.grau sem conclusao

replace anos_estudoC = 3 if v0432==4 & v0434==1 	// classico/cientifico com conclusao
replace anos_estudoC = 3 if v0432==6 & v0434==1 	// medio/2o.grau com conclusao
replace anos_estudoC = 3 if v0432==7 & v0434==2 	// superior de graduacao sem conclusao

replace anos_estudoC = 4 if v0432==7 & v0434==1 	// superior de graduacao com conclusao
replace anos_estudoC = 4 if v0432==8 	// mestrado ou doutorado
lab var anos_estudoC "grupos de anos de escolaridade"

* anos_estudoC = 0 – sem instrução ou menos de 3 anos de estudo (primário incompleto)
*                1 – de 4 a 7 (fundamental/ ginásio/ 1º. Grau/ médio primeiro ciclo incompleto)
*				 2 – de 8 a 10 (médio/ 2º. Grau/ médio segundo ciclo incompleto)
*			 	 3 – de 11 a 14 (médio/ 2º. Grau/ médio segundo ciclo completo ou superior incompleto)
*			 	 4 – 15 ou mais (superior completo, mestrado, doutorado)

drop v0430 v0431

* Estuda no município em que reside?
recode v4276 (100008 = 1) (200006 = .) (else = 0), g(mun_escola)
replace mun_escola = . if freq_escolaB==0
lab var mun_escola "frequenta escola no município de residência"

recode v4355 (2 = .)	///
		 (56/64 67 77 78 81/83 89 = 3) ///
		 (12 21/29 = 4) ///
		 (31/49 = 5) ///
		 (11 13 19 = 6) ///
		 (51/55 65 66 75 76 = 7) ///
		 (91 = 8) ///
		 (68 79 01 09 = 9), g(cursos_c1)
lab var cursos_c1 "curso superior concluído"
* cursos_c1	=	3	ciências humanas
*				4	ciências biológicas
*				5	ciências exatas
*				6	ciências agrárias
*				7	ciências sociais
*				8	militar
*				9	outros cursos

recode  v4354 (2 = .)	///
		  (140/146 = 1) ///
		  (210/226 = 2) ///
		  (310/380 = 3) ///
		  (420/482 = 4) ///
		  (520/582 = 5) ///
		  (620/641 = 6) ///
		  (720/762 = 7) ///
		  (863 = 8) ///
		  (810/862 085 097 = 9), g(cursos_c2)
lab var cursos_c2 "curso superior concluído - CONCLA"
* cursos_c2 =	1	Educação
*				2	Artes, Humanidades e Letras
*				3	Ciências Sociais, Administração e Direito
*				4	Ciências, Matemática e Computação
*				5	Engenharia, Produção e Construção
*				6	Agricultura e Veterinária
*				7	Saúde e Bem-Estar Social    
*				8	militar
*				9	Outros

rename v4355 curso_concl // COMP SO PARA CURSO SUPERIOR

drop v0432 v0433 v0434 v0433 

* Anos de estudo - cálculo do IBGE
recode v4300 (17 = 16) (20=.) (30=0) // 16 máximo (1970); 20 é não determinado; 30, alfabetização de adultos
rename v4300 anos_estudoB
* anos_estudoB  = 0      - Sem instrução ou menos de 1 ano
*                1 a 15 - Número de anos
*                16     - 16 anos ou mais

 
/* D.9. SITUAÇÃO CONJUGAL */

gen teve_conjuge = 1 if (v0436 == 1 | v0436 == 2)
replace teve_conjuge = 0 if v0436 == 3
label var teve_conjuge "vive ou já viveu com cônjuge"
* teve_conjuge = 0 - não
*                1 - sim

recode v0436 (2 3 = 0) // (1=1)
rename v0436 vive_conjuge
label var vive_conjuge "vive com cônjuge"
* vive_conjuge = 0 - não
*                1 - sim

gen estado_conj = v0437 if vive_conjuge == 1
replace estado_conj = 5 if teve_conjuge == 0
replace estado_conj = v0438 + 5 if (teve_conjuge == 1 & vive_conjuge == 0 & v0438 >= 2 & v0438 <= 4)
replace estado_conj = 6 if (teve_conjuge == 1 & vive_conjuge == 0 & estado_conj == .)
label var estado_conj "estado conjugal"
* estado_conj = 1 casamento civil e religioso
*               2 só casamento civil
*               3 só casamento religioso
*               4 união consensual
*               5 solteiro
*               6 separado(a)
*               7 desquitado(a)/separado(a) judicialmente
*               8 divorciado(a)
*               9 viúvo(a)

gen estado_conj_B = estado_conj
recode estado_conj_B (7 8 9 = 6)
label var estado_conj_B "estado conjugal B - mais agregado"
* estado_conj_B = 1 casamento civil e religioso
*                 2 só casamento civil
*                 3 só casamento religioso
*                 4 união consensual
*                 5 solteiro
*                 6 outros: separado(a) OU desquitado(a)/separado(a) judicialmente OU divorciado(a) OU viúvo(a)

drop v0437 v0438

/* D.10. RENDA E ATIVIDADE ECONÔMICA */

recode v0439 (2=0) // (1=1)
rename v0439 trab_rem_sem
* trab_rem_sem = 0 - não
*                1 - sim

recode v0440 (2=0) // (1=1)
rename v0440 afast_trab_sem
* afast_trab_sem = 0 - não
*                  1 - sim


recode v0442 (2=0) // (1=1)
rename v0442 nao_remun
replace nao_remun = 1 if v0441==1 & nao_remun==.
* nao_remun = 0 - não
*                  1 - sim
drop v0441

recode v0443 (2=0) // (1=1)
rename v0443 trab_proprio_cons
* trab_proprio_cons = 0 - não
*                          1 - sim

recode v0444 (1=0) (2=1)
rename v0444 mais_de_um_trab
lab var mais_de_um_trab "tinha mais de um trabalho"
* mais_de_um_trab = 0 - não
*                   1 - sim

*** Ocupação exercida e atividade/ramo de negócio do estabelecimento
* códigos Censo 2000:
rename v4452 ocup2000
rename v4462 ativ2000

* códigos Censo 1991:
rename v4451 ocup1991
rename v4461 ativ1991

* posição na ocupacao, compatível com 2010
recode v0447 (1 = 4) (2 = 5) (3 = 1) (4 = 3) (5 = 7) (7 = 8) 
rename v0447 pos_ocup_sem
replace pos_ocup_sem = 2 if v0448==1
* pos_ocup_sem  = 1 - Empregado com carteira
*				  2 - Militar e Funcionário Públicos
*				  3 - Empregado sem carteira
*				  4 - Trabalhador doméstico com carteira
*				  5 - Trabalhador doméstico sem carteira
*				  6 - Conta-própria
*				  7 - Empregador
*				  8 - Não remunerado
*                 9 - Trabalhador na produção para o próprio consumo

 
drop v0448

recode v0449 (2 3 = 1) (4 5 = 2)
rename v0449 qtos_empregados
* qtos_empregados = 1 - Um a cinco empregados
*                   2 - Seis ou mais

recode v0450 (2=0) // (1=1)
rename v0450 previd_B
* previd_B = 0 - não
*            1 - sim

* Variáveis de horas, em número de horas.
rename v0453 horas_trabprin
rename v0454 horas_outros_sem
drop v4534

* Trabalha no município em que reside?
recode v4276 (100008 = 1) (200006 = .) (else = 0)
replace v4276 = . if mais_de_um_trab==.
rename v4276 mun_trab


recode v4512 (0 999000 999999=.)
rename v4512 rend_ocup_prin

*	recode v4513 (0 999000 999999=.) // POR QUE NÃO APAGAR?
*	rename v4513 rend_tot_prin // POR QUE NÃO APAGAR?

replace v4514 = . if rend_ocup_prin==.
rename v4514 rend_prin_sm
drop v4511 v4513

recode v4522 (0 999000 999999=.)
rename v4522 rend_outras_ocup

drop v4523

replace v4524 = . if rend_outras_ocup==.
rename v4524 rend_outras_sm

egen rend_todos_trab = rowtotal(rend_ocup_prin rend_outras_ocup)
replace rend_todos_trab = . if rend_ocup_prin == . & rend_outras_ocup == .

drop v4521

drop v4525 v4526

*** Classificando não trabalhadores
recode v0455 (2=0) // (1=1)
rename v0455 tomou_prov

drop v0456

*** Rendimentos não-trabalho:
recode v4573 (999000 999999=.)
recode v4583 (999000 999999=.)
recode v4593 (999000 999999=.)
recode v4603 (999000 999999=.)
recode v4613 (999000 999999=.)

egen rend_outras_fontes = rowtotal(v4573 v4583 v4593 v4603 v4613) if idade>=10
lab var rend_outras_fontes "rendimento de outras fontes"

drop v4573 v4583 v4593 v4603 v4613

rename v4614 rend_total
rename v4615 rend_total_sm

* renda familiar
g aux = rend_total if cond_fam_B<=6
bys id_dom num_fam: egen rend_fam = total(aux)
drop aux
lab var rend_fam "renda familiar"

drop  ESTR ESTRP

/* DEFLACIONANDO RENDAS: referência = julho/2022 */
g double deflator = 0.2426823264085210000
g conversor = 1
lab var deflator "deflator de rendimentos - base julho/2022"
lab var conversor "conversor de moedas"

foreach var in rend_ocup_prin rend_outras_ocup rend_todos_trab rend_outras_fontes rend_total rend_fam {
		g `var'_def = (`var'/conversor)/deflator
		lab var `var'_def "`var' deflacionada"
}

/* D.11. FECUNDIDADE */	
* Em 1970 e 1980, a fecundidade foi investigada para mulheres de 15 anos ou mais;
* A partir de 1991, a idade foi reduzida para 10 anos ou mais

rename v4620 filhos_nasc_vivos
rename v0463 filhos_vivos
rename v4670 filhos_nasc_mortos
rename v4690 filhos_tot
egen filhos_hom = rowtotal(v4621 v4671)
lab var filhos_hom "total de filhos tidos homens"

egen filhos_mul = rowtotal(v4622 v4672)
lab var filhos_mul "total de filhos tidos mulheres"

rename v4621 f_nasc_v_hom
rename v4622 f_nasc_v_mul
rename v4631 f_vivos_hom
rename v4632 f_vivos_mul
rename v4671 f_nasc_m_hom
rename v4672 f_nasc_m_mul

label var f_nasc_v_hom "filhos nascidos vivos (homens)"
label var f_nasc_v_mul "filhos nascidos vivos (mulheres)"
label var f_nasc_m_hom "filhos nascidos mortos (homens)"
label var f_nasc_m_mul "filhos nascidos mortos (mulheres)"

recode v0464 (2=0) // (1=1)
rename v0464 sexo_ult_nasc_v
* sexo_ult_nas_v = 0 - feminino
*                  1 - masculino
replace v4654=. if v4654==99
rename v4654 idade_ult_nasc_v
label var idade_ult_nasc_v "idade calculada do ultimo filho nascido vivo"

/* PESO E OUTRAS */
rename P001 peso_pess
drop v4219 v4239 v4269 v4279 v4354 id_muni

order ano UF regiao munic id_dom ordem

end

**************
* CENSO 2022 *
**************
program define compat_censo22dom

/* A. ANO */
* Essa variável é definida antes de chamar este programa.

/* B. IDENTIFICAÇÃO  */

/* B.1. IDENTIFICAÇÃO */
rename D0020 UF
rename D0100 id_dom
rename D0010 regiao

/* B.2. VARIÁVEIS DE NÚMERO DE PESSOAS */
rename D0370 n_homem_dom
rename D0380 n_mulher_dom
rename D0150 n_pes_dom

/* C. OUTRAS VARIÁVEIS DE DOMICÍLIO */

/* C.1. SITUAÇÃO */

rename D0120 sit_setor
destring sit_setor, replace // Retira zeros à esquerda
lab var sit_setor "situação do domicílio"
* sit_setor = 	1	Área urbanizada de vila ou cidade
*				2	Área não urbanizada de vila ou cidade
*				3	Área urbanizada isolada
*				4	- N/A
*				5	Rural - povoado
*				6	Rural núcleo
*				7	Rural - outros aglomerados
*				8	Rural exclusive os aglomerados rurais

g sit_setor_B = sit_setor
recode sit_setor_B (1 2 = 1) (3=2) (5/7 = 3) (8=4)
lab var sit_setor_B "situação do domicílio - agregado"
* sit_setor_B = 1 - Vila ou cidade
*               2 - Urbana isolada
*               3 - Aglomerado rural
*               4 - Rural exclusive os aglomerados

rename D0140 sit_setor_C
recode sit_setor_C (2=0)
lab var sit_setor_C "situação do domicílio - urbano/rural"
* sit_setor_C = 1 - urbano
*               0 - rural

/* C.2. ESPÉCIE */

rename D0130 especie
destring especie, replace // Retira zeros à esquerda
recode especie (1 = 0) (5 = 1) (6 = 2)
* especie = 0 - particular permanente 
*           1 - particular improvisado
*           2 - coletivo

/* C.3. MATERIAL DAS PAREDES */
recode D0210 (2 = 1) (4 = 2) (5 = 4) (6 = 5) (7 = .) // (1 = 1) (3 = 3)
rename D0210 paredes_B
* paredes_B	= 1   Alvenaria
*        	= 2   Madeira aparelhada
*        	= 3   Taipa não revestida
*       	= 4   Material aproveitado
*   	    = 5   Outro

/* C.4.	MATERIAL DA COBERTURA */

/* C.5. TIPO */
* Em 2022, permanece a categoria "maloca" ou "habitação indígena sem paredes". Foi mantida em "casa" por
* exclusão, pois não se trata de apartamento nem de cômodo.
* Também foi considerado por exclusão como casa a habitação permanente ocupada que se tratava de estrutura residencial 
* permanente degradada ou inacabada.
* Domicílios improvisados ou coletivos foram considerados missing nessa categoria.

recode D0200 (11 12 15 16 = 1) (13 = 2) (14 = 3) (50/max = .)
rename D0200 tipo_dom
* tipo_dom = 1 - casa ou oca/maloca
*            2 - apartamento
*            3 - cômodo
lab var tipo_dom "tipo do domicílio"

g tipo_dom_B = tipo_dom
recode tipo_dom_B (3 = 2)
* tipo_dom_B = 1 - casa ou oca/maloca
*              2 - apartamento ou cômodo
lab var tipo_dom_B "tipo do domicílio B"


/* C.6. CONDIÇÃO DE OCUPAÇÃO E ALUGUEL */

g cond_ocup = D0190
recode cond_ocup (2=1) (3=2) (4=3) (5 6=4) (7=5) 
* cond_ocup  = 1 - Próprio
*              2 - Alugado
*              3 - Cedido por empregador
*              4 - Cedido de outra forma
*              5 - Outra Condição
lab var cond_ocup "condição de ocupação do domicílio"

g cond_ocup_B = cond_ocup 
recode cond_ocup_B (4=3) (5=4)
* cond_ocup_B = 1 - próprio
*               2 - alugado
*               3 - cedido
*               4 - outra condição
lab var cond_ocup_B "condição de ocupação do domicílio B"

rename D0190 cond_ocup_C
recode cond_ocup_C (6=5) (7=6) 
* cond_ocup_C = 1 - Próprio, já pago
*               2 - Próprio, ainda pagando
*               3 - Alugado
*               4 - Cedido por empregador
*               5 - Cedido de outra forma
*               6 - Outra Condição
lab var cond_ocup_C "condição de ocupação do domicílio C"

g dom_pago = 1 if cond_ocup_C == 1
replace dom_pago = 0 if cond_ocup_C == 2
lab var dom_pago "dummy para domicílio próprio já pago"
* dom_pago = 0 - Domicílio próprio em aquisição
*            1 - Domicílio próprio já pago
 
/* C.7. INSTALAÇÕES SANITÁRIAS */
rename D0280 banheiros_B
* banheiros_B = 0 - não tem
*               1 - 1 banheiro
*               2 - 2 banheiros
*               3 - 3 banheiros
*               4 - 4 banheiros
*               5 - 5 banheiros
*               6 - 6 banheiros
*               7 - 7 banheiros
*               8 - 8 banheiros
*               9 - 9 ou mais banheiros

g banheiros = banheiros_B
replace banheiros = 5 if banheiros >= 5
lab var banheiros "número de banheiros"
* banheiros = 0 - não tem
*			 1 - 1 banheiro
*			 2 - 2 banheiros
*            3 - 3 banheiros
*            4 - 4 banheiros
*            5 - 5 ou mais banheiros
drop banheiros_B

gen sanitario = D0270
recode sanitario (7 = 0)
replace sanitario = 1 if sanitario >= 1 & sanitario <= 6
* sanitario = 0 - Não
*             1 - Sim

recode D0270 (2 3 4 = 1) (5 6 7 = 0)
rename D0270 sanitario_ex
label var sanitario_ex "acesso exclusivo a instalação sanitária"
* inst_san_exc = 0 - não tem acesso a inst san exclusiva
*                1 - tem acesso a inst sanitária exclusiva

rename D0250 tipo_esc_san_B
recode tipo_esc_san_B (3=2) (4=3) (5=4) (6=5) (7=6) (9=.)
* tipo_esc_san_B = 1 - Rede geral de esgoto ou pluvial
*                  2 - Fossa séptica
*                  3 - Fossa rudimentar
*                  4 - Vala
*                  5 - Rio, lago ou mar
*                  6 - Outro 
lab var tipo_esc_san_B "tipo de escoadouro - desagregado"

g tipo_esc_san = tipo_esc_san_B
recode tipo_esc_san (4 5 6 = 4)
lab var tipo_esc_san "tipo de escoadouro"
* tipo_esc_san = 1 - Rede geral de esgoto ou pluvial
*                2 - Fossa séptica
*                3 - Fossa rudimentar
*                4 - Outro

/* C.8. ABASTECIMENTO DE ÁGUA */

rename D0260 abast_agua_B
recode abast_agua_B (1=1) (2 3 4 = 2) (5/8 = 3)
* abast_agua_B = 1 - rede geral
*                2 - poço ou nascente na propriedade
*                3 - outra

gen abast_agua = 1 if (abast_agua_B == 1) & (D0300 == 1)
replace abast_agua = 2 if (abast_agua_B == 1) & ((D0300 == 2) | (D0300 == 3))
replace abast_agua = 3 if (abast_agua_B == 2) & (D0300 == 1)
replace abast_agua = 4 if (abast_agua_B == 2) & ((D0300 == 2) | (D0300 == 3))
replace abast_agua = 5 if abast_agua_B == 3
* abast_agua = 1 - rede geral com canalização interna
*              2 - rede geral sem canalização interna
*              3 - poço ou nascente com canalização interna
*              4 - poço ou nascente sem canalização interna
*              5 - outra forma
lab var abast_agua "forma de abastecimento de água"
drop abast_agua_B

rename D0300 agua_canal
* agua_canal = 1 - Canalizada em pelo menos um cômodo
*              2 - Canalizada só na propriedade ou terreno
*              3 - Não canalizada


/* C.9. DESTINO DO LIXO */
rename D0310 dest_lixo_B
* dest_lixo_B = 1 - Coletado no domicílio por serviço de limpeza
*             	2 - Colocado em caçamba de serviço de limpeza
*             	3 - Queimado na propriedade
*             	4 - Enterrado na propriedade
*             	5 - Jogado em terreno baldio, encosta ou área pública
*             	6 - Outro destino

/* C.10. ILUMINAÇÃO ELÉTRICA */

/* C.11. BENS DE CONSUMO DURÁVEIS */
rename D0320 lavaroupa
recode lavaroupa (2 = 0)
* lavaroupa = 0 - Nao
*             1 - Sim

/* C.12. NÚMERO DE CÔMODOS */

rename D0220 tot_comodos
rename D0230 tot_dorm

/* C.13. RENDA DOMICILIAR */

rename D0350 renda_dom

/* DEFLACIONANDO RENDAS: referência = julho de 2022 */
/* Manual do entrevistador Censo 2022: Trabalho e Rendimento:
Na investigação deste tema, serão considerados os seguintes períodos de referência:
SEMANA DE REFERÊNCIA – 25 a 31 de julho de 2022.
MÊS DE REFERÊNCIA – julho de 2022. */
g double deflator = 1
g conversor = 1

lab var deflator "deflator de rendimentos - referência: julho de 2022"
lab var conversor "conversor de moedas"

g renda_dom_def = (renda_dom/conversor)/deflator
lab var renda_dom_def "renda_dom deflacionada"

/* C.14. PESO AMOSTRAL */
/* Será necessário adaptar o peso de acordo com a versão dos microdados.
Acesso público: D0110.
Acesso controlado: D0111.
Acesso restrito: D0112.
ATENÇÃO: a opção `versao_censo22' ainda não é repassada por datazoom_censo
nem por load_censo. Enquanto isso não for feito nenhum ramo é escolhido e
o peso amostral não é renomeado. */
if "`versao_censo22'" == "publico"         rename D0110 peso_dom
else if "`versao_censo22'" == "controlado" rename D0111 peso_dom
else if "`versao_censo22'" == "restrito"   rename D0112 peso_dom
else di as err "Versão dos microdados de 2022 não especificada: peso amostral não renomeado para peso_dom"

/* Variáveis de domicílio não utilizadas */

drop D0030 D0040 D0050 D0060 D0070 D0080 D0090 D0160 D0170 D0171 D0180 D0181 D0240 D0290 D0330 D0340 D0360 D0390 D0400 D0410 MD*

end
 
program define compat_censo22pess

/* A. ANO */
* Essa variável é definida antes de chamar este programa.

/* B. IDENTIFICAÇÃO  */

rename P0020 UF
rename P0100 id_dom
rename P0010 regiao

/* Será necessário adaptar o peso de acordo com a versão dos microdados.
Acesso público: P0110.
Acesso controlado: P0111.
Acesso restrito: P0112.
ATENÇÃO: a opção `versao_censo22' ainda não é repassada por datazoom_censo
nem por load_censo. Enquanto isso não for feito nenhum ramo é escolhido e
o peso amostral não é renomeado. */
if "`versao_censo22'" == "publico"         rename P0110 peso_pess
else if "`versao_censo22'" == "controlado" rename P0111 peso_pess
else if "`versao_censo22'" == "restrito"   rename P0112 peso_pess
else di as err "Versão dos microdados de 2022 não especificada: peso amostral não renomeado para peso_pess"

sort UF munic id_dom
by UF munic id_dom: egen n_homem_dom = total(P0160==1)
by UF munic id_dom: egen n_mulher_dom = total(P0160==2)
lab var n_homem_dom "numero de homens no domicilio"
lab var n_mulher_dom "numero de mulheres no domicilio"

/* C. OUTRAS VARIÁVEIS DE DOMICÍLIO */

/* C.1. SITUAÇÃO */

recode P0140 (2=0)
rename P0140 sit_setor_C
lab var sit_setor_C "situação do domicílio - urbano/rural"
* sit_setor_C = 1 - urbano
*               0 - rural

/* D. OUTRAS VARIÁVEIS DE PESSOAS */

rename P0101 ordem

/* D.1. SEXO */
/* Há também a variável P0150, elaborada com restrições para atender aos critérios de controle estatístico 
de confidencialidade. Necessário verificar o que irá funcionar ou se será necessário criar uma condicional
aqui também. */
rename P0160 sexo
recode sexo (2=0)
* sexo = 0 - Feminino
*    	 1 - Masculino

/* D.2. CONDIÇÃO NA FAMÍLIA E NO DOMICÍLIO  */

rename P0170 cond_dom
destring cond_dom, replace
recode cond_dom (1 = 1) (2 3 = 2) (4 5 6 = 3) (8 9 = 4) (10 11 = 5) ///
	(12 = 6) (7 13 14 = 7) (15 16 = 8) (17 = 9) (18 = 10)(19 = 11) (20 = 12)
lab var cond_dom "condição no domicílio"
* condicao_dom = 1	pessoa responsável
*				 2	cônjuge, companheiro
*				 3	filho, enteado
*				 4	pai, mãe, sogro
*				 5	neto, bisneto
*				 6	irmão, irmã
*				 7	outro parente
*				 8	Agregado
*				 9	pensionista
*				 10	Empregado doméstico
*				 11	Parente do empregado doméstico
*				 12	Individual em domicílio coletivo

g cond_dom_B = cond_dom
recode cond_dom_B (6 7 = 5) (8 = 6) (9 = 7) (10 = 8) (11 = 9) (12 = 10)
lab var cond_dom_B "condição no domicílio B"
* cond_dom_B = 1 - pessoa responsável
*			   2 - cônjuge, companheiro
*			   3 - filho, enteado
*			   4 - pai, mãe, sogro
*			   5 - outro parente
*			   6 - agregado
*			   7 - hóspede, pensionista
*			   8 - Empregado doméstico
*			   9 - Parente do empregado doméstico
*			   10 - Individual em domicílio coletivo

/* D.3. IDADE */

rename P0181 idade
rename P0190 idade_meses
rename P0200 idade_presumida
recode idade_presumida (1 = 0) (2 = 1)
* idade_presumida = 0 -	Não
*					1 - Sim

/* D.4. COR OU RACA */

recode P0210 (9=.) // v0401
rename P0210 raca // v0401
* raca = 1 - Branca
*		 2 - Preta
*		 3 - Amarela
*		 4 - Parda
*		 5 - Indígena
lab var raca "cor ou raça"

g racaB = raca
recode racaB (5 = 4)
lab var racaB "cor ou raça (indigenous=mulatto)"
* raca =  1 - Branca
*		  2 - Preta
*		  3 - Amarela
*		  4 - Parda

/* D.5 RELIGIÃO */
recode P0411 (27 28 29 = 0) (1 = 1) (4 5 6 7 = 2) (12 = 3) (13 14 15 = 4) (17 18 19 20 21 = 5) ///
             (16 = 6) (2 3 8 9 10 11 22 23 24 25 26 30 31 = 7) (32 33 = .)
rename P0411 religiao_A
lab var religiao_A "religião A - mais agregada"
* religiao_A = 0 - sem religião
*            1 - católica
*            2 - evangélica
*            3 - espírita kardecista
*            4 - espírita afro-brasileira
*            5 - religiões orientais
*            6 - judaica/israelita
*            7 - outras religiões

gen religiao_B = religiao_A
recode religiao_B (3 4 = 3) (5/7 = 4)
lab var religiao_B "religião B - mais agregada"
* religiao_B = 0 - sem religião
*              1 - católica
*              2 - evangélica
*              3 - espírita
*              4 - outra

/* D.6. DEFICIÊNCIAS FÍSICA E MENTAL */

* legenda: dif_x = dificuldade em fazer o movimento "x"

recode P0420 (9 = .)
rename P0420 dif_enxergar
* dif_enxergar = 1 - Sim, não consegue de modo algum
*				 2 - Sim, grande dificuldade
*				 3 - Sim, alguma dificuldade
*				 4 - Não, nenhuma dificuldade
	
recode P0430 (9 = .)
rename P0430 dif_ouvir
* dif_ouvir = 1 - Sim, não consegue de modo algum
*			  2 - Sim, grande dificuldade
*			  3 - Sim, alguma dificuldade
*			  4 - Não, nenhuma dificuldade
	
recode P0440 (9 = .)
rename P0440 dif_caminhar
* dif_caminhar = 1 - Sim, não consegue de modo algum
*			 	 2 - Sim, grande dificuldade
*			 	 3 - Sim, alguma dificuldade
*				 4 - Não, nenhuma dificuldade

recode P0460 (1/3 = 1) (4 = 0) (9 = .)
rename P0460 def_mental
* def_mental = 1 - Sim
*			   0 - Não

/* D.7. NATURALIDADE E MIGRAÇÃO  */

g sempre_morou = 1 if P0480 == 1 & P0530 == 2
replace sempre_morou = 0 if (P0480 == 2 | P0480 == 3) | P0530 == 1
lab var sempre_morou "sempre morou neste município"
* sempre_morou = 1 - sim
*				 0 - nao

g nasceu_mun = P0480
recode nasceu_mun (1 = 1) (2 3 = 0) (9 = .)
lab var nasceu_mun "nasceu neste município"
* nasceu_mun = 1 - Sim
*			   0 - Não

g nasceu_UF = 1 if P0480 == 2 & P0490 == UF
replace nasceu_UF = 0 if (P0480 == 2 & P0490 != UF) | P0480 == 3
replace nasceu_UF = 1 if nasceu_mun == 1
lab var nasceu_UF "nasceu nesta UF"
* nasceu_UF = 1 - Sim
*			  0 - Não

drop P0480 

rename P0520 nacionalidade
recode nacionalidade (1 = 0) (2 = 1) (3 = 2)
* nacionalidade = 0 - Brasileiro nato
*				  1 - Naturalizado brasileiro
*				  2 - Estrangeiro
	
rename P0540 ano_fix_res
* ano em que fixou residência no Brasil

replace P0490 = . if P0490 > 53
rename P0490 UF_nascim

recode P0510 (8000998000/max =.) ///
(8000818000=82 "Egito") ///
(8000032000=30 "Argentina") ///
(8000124000=32 "Canadá") ///
(8000192000=36 "Cuba") ///
(8000218000=37 "Equador") ///
(8000840000=38 "EUA") ///
(8000320000=39 "Guatemala") ///
(8000254000=40 "Guiana Francesa") ///
(8000328000=41 "Guiana Inglesa") ///
(8000340000=44 "Honduras Britânicas") ///
(8000388000=45 "Jamaica") ///
(8000558000=47 "Nicarágua") ///
(8000591000=48 "Panamá") ///
(8000600000=49 "Paraguai") ///
(8000604000=50 "Peru") ///
(8000214000=51 "República Dominicana") ///
(8000222000=52 "Salvador") ///
(8000740000=53 "Suriname") ///
(8000858000=54 "Uruguai") ///
(8000862000=55 "Venezuela") ///
(8000276000=58 "Alemanha") ///
(8000040000=59 "Áustria") ///
(8000056000=60 "Bélgica") ///
(8000100000=61 "Bulgária") ///
(8000208000=62 "Dinamarca") ///
(8000724000=63 "Espanha") ///
(8000246000=64 "Finlândia") ///
(8000250000=65 "França") ///
(8000826000 8000826001 8000826002 8000826003 8000826004 =66 "Grã-Bretanha") ///
(8000300000=67 "Grécia") ///
(8000528000=68 "Holanda") ///
(8000348000=69 "Hungria") ///
(8000372000=70 "Irlanda (Eire)") ///
(8000380000=71 "Itália") ///
(8000578000=73 "Noruega") ///
(8000616000=74 "Polônia") ///
(8000620000=75 "Portugal") ///
(8000642000=76 "Romênia") ///
(8000752000=77 "Suécia") ///
(8000756000=78 "Suíça") ///
(8000156000=84 "China - Continente") ///
(8000408000=86 "Coréia") ///
(8000356000=87 "Índia") ///
(8000376000=88 "Israel") ///
(8000392000=89 "Japão") ///
(8000422000=90 "Líbano") ///
(8000586000=91 "Paquistão") ///
(8000760000=92 "Síria") ///
(8000792000=93 "Turquia") ///
(8000036000=95 "Austrália") ///
(8000203000 8000703000=79 "Tchecoeslovaquia") ///
(8000070000 8000191000 8000705000 8000807000 8000499000 8000688000 = 72 "Iugoslávia") ///
(8000112000 8000233000 8000428000 8000440000 8000643000 8000643001 8000804000 = 80 "URSS") ///
(8000008000 8000020000 8000352000 8000438000 8000442000 8000470000 8000492000 8000498000 8000674000 ///
8000336000 = 81 "Europa - outros") ///
(8000028000 8000044000 8000052000 8000084000 8000068000 8000152000 8000170000 8000188000 8000212000 ///
8000308000 8000332000 8000484000 8000662000 8000659000 8000670000 8000780000 = 56 "América - outros") ///
(8000583000 8000242000 8000584000 8000090000 8000296000 8000520000 8000554000 8000585000 ///
8000598000 8000882000 8000776000 8000798000 8000548000 = 96 "Oceania - outros") ///
(8000004000 8000682000 8000051000 8000031000 8000048000 8000050000 8000096000 8000064000 8000116000 ///
8000398000 8000634000 8000196000 8000702000 8000784000 8000608000 8000268000 8000887000 ///
8000360000 8000364000 8000368000 8000400000 8000414000 8000458000 8000462000 8000104000 ///
8000496000 8000524000 8000512000 8000417000 8000410000 8000418000 8000144000 8000762000 ///
8000764000 8000626000 8000795000 8000860000 8000704000 = 94 "Ásia - outros") ///
(8000710000 8000024000 8000012000 8000204000 8000072000 8000854000 8000108000 8000132000 8000120000 ///
8000148000 8000174000 8000178000 8000384000 8000262000 8000232000 8000231000 8000266000 8000270000 ///
8000288000 8000324000 8000624000 8000226000 8000426000 8000430000 8000434000 8000450000 8000454000 ///
8000466000 8000504000 8000480000 8000478000 8000508000 8000516000 8000562000 8000566000 8000404000 ///
8000140000 8000180000 8000646000 8000678000 8000686000 8000694000 8000690000 8000706000 8000748000 ///
8000736000 8000834000 8000768000 8000788000 8000800000 8000894000 8000716000 = 83 "Africa - outros"), g(pais_nascim)
label var pais_nascim "País de nascimento - códigos 1970"
* Obs: Em 2022, foram considerados os seguintes países como Grã-Bretanha: ESCOCIA, INGLATERRA, IRLANDA DO 
* NORTE, PAIS DE GALES, e REINO UNIDO. Isso vale para todas os itens desta seção, quando aplicável.
* Nos anos anteriores, se classificou a Coreia do Norte como "Coreia" e a Coreia do Sul como "Asia - Outros".
* Mantive esse padrão, mas pode ser que queiram rever no futuro.
* Nos anos anteriores, Chipre estava como Ásia. Mantive assim, mas pode ser revisto, já que hoje ele faz parte
* da UE.

drop P0510

replace P0570 = . if P0570 > 53
rename P0570 UF_mor_ant

replace P0580 = . if P0580 >= 8888888
rename P0580 mun_mor_ant

recode P0590 (8000998000/max =.) ///
(8000818000=82 "Egito") ///
(8000032000=30 "Argentina") ///
(8000124000=32 "Canadá") ///
(8000192000=36 "Cuba") ///
(8000218000=37 "Equador") ///
(8000840000=38 "EUA") ///
(8000320000=39 "Guatemala") ///
(8000254000=40 "Guiana Francesa") ///
(8000328000=41 "Guiana Inglesa") ///
(8000340000=44 "Honduras Britânicas") ///
(8000388000=45 "Jamaica") ///
(8000558000=47 "Nicarágua") ///
(8000591000=48 "Panamá") ///
(8000600000=49 "Paraguai") ///
(8000604000=50 "Peru") ///
(8000214000=51 "República Dominicana") ///
(8000222000=52 "Salvador") ///
(8000740000=53 "Suriname") ///
(8000858000=54 "Uruguai") ///
(8000862000=55 "Venezuela") ///
(8000276000=58 "Alemanha") ///
(8000040000=59 "Áustria") ///
(8000056000=60 "Bélgica") ///
(8000100000=61 "Bulgária") ///
(8000208000=62 "Dinamarca") ///
(8000724000=63 "Espanha") ///
(8000246000=64 "Finlândia") ///
(8000250000=65 "França") ///
(8000826000 8000826001 8000826002 8000826003 8000826004 =66 "Grã-Bretanha") ///
(8000300000=67 "Grécia") ///
(8000528000=68 "Holanda") ///
(8000348000=69 "Hungria") ///
(8000372000=70 "Irlanda (Eire)") ///
(8000380000=71 "Itália") ///
(8000578000=73 "Noruega") ///
(8000616000=74 "Polônia") ///
(8000620000=75 "Portugal") ///
(8000642000=76 "Romênia") ///
(8000752000=77 "Suécia") ///
(8000756000=78 "Suíça") ///
(8000156000=84 "China - Continente") ///
(8000408000=86 "Coréia") ///
(8000356000=87 "Índia") ///
(8000376000=88 "Israel") ///
(8000392000=89 "Japão") ///
(8000422000=90 "Líbano") ///
(8000586000=91 "Paquistão") ///
(8000760000=92 "Síria") ///
(8000792000=93 "Turquia") ///
(8000036000=95 "Austrália") ///
(8000203000 8000703000=79 "Tchecoeslovaquia") ///
(8000070000 8000191000 8000705000 8000807000 8000499000 8000688000 = 72 "Iugoslávia") ///
(8000112000 8000233000 8000428000 8000440000 8000643000 8000643001 8000804000 = 80 "URSS") ///
(8000008000 8000020000 8000352000 8000438000 8000442000 8000470000 8000492000 8000498000 8000674000 ///
8000336000 = 81 "Europa - outros") ///
(8000028000 8000044000 8000052000 8000084000 8000068000 8000152000 8000170000 8000188000 8000212000 ///
8000308000 8000332000 8000484000 8000662000 8000659000 8000670000 8000780000 = 56 "América - outros") ///
(8000583000 8000242000 8000584000 8000090000 8000296000 8000520000 8000554000 8000585000 ///
8000598000 8000882000 8000776000 8000798000 8000548000 = 96 "Oceania - outros") ///
(8000004000 8000682000 8000051000 8000031000 8000048000 8000050000 8000096000 8000064000 8000116000 ///
8000398000 8000634000 8000196000 8000702000 8000784000 8000608000 8000268000 8000887000 ///
8000360000 8000364000 8000368000 8000400000 8000414000 8000458000 8000462000 8000104000 ///
8000496000 8000524000 8000512000 8000417000 8000410000 8000418000 8000144000 8000762000 ///
8000764000 8000626000 8000795000 8000860000 8000704000 = 94 "Ásia - outros") ///
(8000710000 8000024000 8000012000 8000204000 8000072000 8000854000 8000108000 8000132000 8000120000 ///
8000148000 8000174000 8000178000 8000384000 8000262000 8000232000 8000231000 8000266000 8000270000 ///
8000288000 8000324000 8000624000 8000226000 8000426000 8000430000 8000434000 8000450000 8000454000 ///
8000466000 8000504000 8000480000 8000478000 8000508000 8000516000 8000562000 8000566000 8000404000 ///
8000140000 8000180000 8000646000 8000678000 8000686000 8000694000 8000690000 8000706000 8000748000 ///
8000736000 8000834000 8000768000 8000788000 8000800000 8000894000 8000716000 = 83 "Africa - outros"), g(pais_mor_ant)
label var pais_mor_ant "País onde morava anteriormente (se migrou nos últ 10 anos)"

drop P0590

rename P0550 anos_mor_mun

* tempo de moradia em 1970 só vale para quem não nasceu no município.
g t_mor_mun_70 = anos_mor_mun
recode t_mor_mun_70 (7/10=6) (11/max=7)
lab var t_mor_mun_70 "tempo de moradia no municipio - grupos de 1970"

* De 1980 em diante, podemos montar a variavel de tempo de moradia incluindo
* pessoas que nasceram mas nem sempre moraram no municipio em que residem
recode anos_mor_mun (7/9 = 6) (10/max = 7), g(t_mor_mun_80)
lab var t_mor_mun_80 "tempo de moradia no municipio - grupos de 1980"

replace P0610 = . if P0610 > 53
rename P0610 UF_mor5anos // v11071 

replace P0620 = . if P0620 >= 8888888
rename P0620 mun_mor5anos // v11072

recode P0630 (8000998000/max =.) ///
(8000818000=82 "Egito") ///
(8000032000=30 "Argentina") ///
(8000124000=32 "Canadá") ///
(8000192000=36 "Cuba") ///
(8000218000=37 "Equador") ///
(8000840000=38 "EUA") ///
(8000320000=39 "Guatemala") ///
(8000254000=40 "Guiana Francesa") ///
(8000328000=41 "Guiana Inglesa") ///
(8000340000=44 "Honduras Britânicas") ///
(8000388000=45 "Jamaica") ///
(8000558000=47 "Nicarágua") ///
(8000591000=48 "Panamá") ///
(8000600000=49 "Paraguai") ///
(8000604000=50 "Peru") ///
(8000214000=51 "República Dominicana") ///
(8000222000=52 "Salvador") ///
(8000740000=53 "Suriname") ///
(8000858000=54 "Uruguai") ///
(8000862000=55 "Venezuela") ///
(8000276000=58 "Alemanha") ///
(8000040000=59 "Áustria") ///
(8000056000=60 "Bélgica") ///
(8000100000=61 "Bulgária") ///
(8000208000=62 "Dinamarca") ///
(8000724000=63 "Espanha") ///
(8000246000=64 "Finlândia") ///
(8000250000=65 "França") ///
(8000826000 8000826001 8000826002 8000826003 8000826004 =66 "Grã-Bretanha") ///
(8000300000=67 "Grécia") ///
(8000528000=68 "Holanda") ///
(8000348000=69 "Hungria") ///
(8000372000=70 "Irlanda (Eire)") ///
(8000380000=71 "Itália") ///
(8000578000=73 "Noruega") ///
(8000616000=74 "Polônia") ///
(8000620000=75 "Portugal") ///
(8000642000=76 "Romênia") ///
(8000752000=77 "Suécia") ///
(8000756000=78 "Suíça") ///
(8000156000=84 "China - Continente") ///
(8000408000=86 "Coréia") ///
(8000356000=87 "Índia") ///
(8000376000=88 "Israel") ///
(8000392000=89 "Japão") ///
(8000422000=90 "Líbano") ///
(8000586000=91 "Paquistão") ///
(8000760000=92 "Síria") ///
(8000792000=93 "Turquia") ///
(8000036000=95 "Austrália") ///
(8000203000 8000703000=79 "Tchecoeslovaquia") ///
(8000070000 8000191000 8000705000 8000807000 8000499000 8000688000 = 72 "Iugoslávia") ///
(8000112000 8000233000 8000428000 8000440000 8000643000 8000643001 8000804000 = 80 "URSS") ///
(8000008000 8000020000 8000352000 8000438000 8000442000 8000470000 8000492000 8000498000 8000674000 ///
8000336000 = 81 "Europa - outros") ///
(8000028000 8000044000 8000052000 8000084000 8000068000 8000152000 8000170000 8000188000 8000212000 ///
8000308000 8000332000 8000484000 8000662000 8000659000 8000670000 8000780000 = 56 "América - outros") ///
(8000583000 8000242000 8000584000 8000090000 8000296000 8000520000 8000554000 8000585000 ///
8000598000 8000882000 8000776000 8000798000 8000548000 = 96 "Oceania - outros") ///
(8000004000 8000682000 8000051000 8000031000 8000048000 8000050000 8000096000 8000064000 8000116000 ///
8000398000 8000634000 8000196000 8000702000 8000784000 8000608000 8000268000 8000887000 ///
8000360000 8000364000 8000368000 8000400000 8000414000 8000458000 8000462000 8000104000 ///
8000496000 8000524000 8000512000 8000417000 8000410000 8000418000 8000144000 8000762000 ///
8000764000 8000626000 8000795000 8000860000 8000704000 = 94 "Ásia - outros") ///
(8000710000 8000024000 8000012000 8000204000 8000072000 8000854000 8000108000 8000132000 8000120000 ///
8000148000 8000174000 8000178000 8000384000 8000262000 8000232000 8000231000 8000266000 8000270000 ///
8000288000 8000324000 8000624000 8000226000 8000426000 8000430000 8000434000 8000450000 8000454000 ///
8000466000 8000504000 8000480000 8000478000 8000508000 8000516000 8000562000 8000566000 8000404000 ///
8000140000 8000180000 8000646000 8000678000 8000686000 8000694000 8000690000 8000706000 8000748000 ///
8000736000 8000834000 8000768000 8000788000 8000800000 8000894000 8000716000 = 83 "Africa - outros"), g(pais_mor5anos)
label var pais_mor5anos "País onde morava há 5 anos"

drop P0630

/* D.8. EDUCACÃO */

rename P0640 alfabetizado
recode alfabetizado (2 = 0)
* alfabetizado = 1 - Sim
*				 0 - Não
	
** frequencia a escola: 2010 DESCONSIDERA PRE-VESTIBULAR, por isso, diversas variaveis de frequencia

destring P0660, replace

recode P0650 (1 = 1 "sim") (2 3 = 0 "nao"), g(freq_escola)
replace freq_escola = 0 if P0660 <= 2	//	desconsidera creche e pre-escola para compatibilizar com todos
lab var freq_escola "frequenta escola"
* freq_escola = 1 - Sim
*			    0 - Não

g freq_escolaB = freq_escola
replace freq_escolaB = 1 if P0660 == 2 //	inclui pre-escola
lab var freq_escolaB "frequenta escola - inclui pre-escola"
* freq_escolaB = 1 - Sim
*				 0 - Não

* Como há diversas definições para a frequencia a escola, a variavel abaixo deve
* ser utilizada conjuntamente com a serie que frequenta
* em 2022, nao tem opção de Classe de Alfabetização nem Pré-vestibular

destring P0670, replace
destring P0680, replace
recode P0660 (3 = 4) (4 = 5) (5 = 7) (6 = 8) (7 = 10) (8 = 12) (9 10 11 = 13) (99 = .)
replace P0660 = 6 if P0660 == 5 & P0670 == 10
replace P0660 = 9 if P0660 == 8 & (P0670 == 10 | P0680 == 10)
rename P0660 curso_freq
* curso_freq = 1  - Creche
*              2  - Pré-escolar
*              3  - Classe de alfabetização
*              4  - Alfabetização de adultos
*              5  - Ensino fundamental ou 1º grau - regular seriado
*              6  - Ensino fundamental ou 1º grau - regular não-seriado
*              7  - Supletivo - Ensino fundamental ou 1º grau
*              8  - Ensino médio ou 2º grau - regular seriado
*              9  - Ensino médio ou 2º grau - regular não-seriado
*              10 - Supletivo - Ensino médio ou 2º grau
*			   11 - Pré-vestibular
*              12 - Superior - graduação
*              13 - Superior - mestrado ou doutorado


rename P0670 serie_freq
recode serie_freq (1 2 = 1) (3 = 2) (4 = 3) (5 = 4) (6 = 5) (7 = 6) (8 = 7) (9 = 8) (10 = 9) (99 = .)
replace serie_freq = P0680 if serie_freq == . & P0680 < 9
replace serie_freq = 8 if serie_freq == . & P0680 == 9
replace serie_freq = 9 if serie_freq == . & P0680 == 10
* serie_freq = 1 - Primeira série/ano
*			   2 - Segunda série
*			   3 - Terceira série
*			   4 - Quarta série
*			   5 - Quinta série
*			   6 - Sexta série
*			   7 - Sétima série
* 			   8 - Oitava série
*			   9 - Não seriado
	
* grupos de anos de estudo
g anos_estudoC = .
* para quem frequenta escola
replace anos_estudoC = 0 if curso_freq<=4	// Creche, pre-escolar, classe de alfabetização e alfabetização de adultos
replace anos_estudoC = 0 if curso_freq==6	// fundamental ou 1o grau nao seriado
replace anos_estudoC = 0 if curso_freq==7	// supletivo fundamental ou 1o grau
replace anos_estudoC = 0 if curso_freq==5 & serie_freq<=4	// fundamental ou 1o grau seriado - até 4o ano (inclusive)

replace anos_estudoC = 1 if curso_freq==5 & serie_freq>=5 & serie_freq<=8	// fundamental ou 1o grau seriado - 5o a 8o ano

replace anos_estudoC = 2 if curso_freq==8 	// medio ou 2o grau seriado - 1o ano
replace anos_estudoC = 2 if curso_freq==9	// medio ou 2o grau nao seriado
replace anos_estudoC = 2 if curso_freq==10	// supletivo medio ou 2o grau

replace anos_estudoC = 3 if curso_freq==12		// superior de graduacao

replace anos_estudoC = 4 if curso_freq==13		// mestrado ou doutorado

* para ficar compativel com 2000, nao podemos recuperar a informacao abaixo
*replace anos_estudoC = 4 if P0690 == 1	// ja concluiu curso superior de graduacao

* para quem nao frequenta escola

* não tem pré-vestibular
destring P0700, replace
destring P0720, replace
destring P0730, replace
recode P0700 (5 6 7 = 5) (8 = 7) (9 10 = 8) (11 = 10) (12 = 12) (13/15 = 13) (99 = .)
replace P0700 = 6 if P0700 == 5 & (P0720 == 11 | P0730 == 11)
replace P0700 = 9 if P0700 == 8 & (P0720 == 11 | P0730 == 11)
rename P0700 curso_frequentou
* curso_frequentou = 1  - Creche
*              		 2  - Pré-escolar
*              		 3  - Classe de alfabetização
*              		 4  - Alfabetização de adultos
*              		 5  - Ensino fundamental ou 1º grau - regular seriado
*              		 6  - Ensino fundamental ou 1º grau - regular não-seriado
*              		 7  - Supletivo - Ensino fundamental ou 1º grau
*              		 8  - Ensino médio ou 2º grau - regular seriado
*             		 9  - Ensino médio ou 2º grau - regular não-seriado
*             		 10 - Supletivo - Ensino médio ou 2º grau
*			  		 11 - Pré-vestibular
*             		 12 - Superior - graduação
*             		 13 - Superior - mestrado ou doutorado


rename P0720 serie_frequentou
recode serie_frequentou (1 99 = .)
replace serie_frequentou = serie_frequentou - 2
recode serie_frequentou (0 = 1)
replace P0730 = P0730 - 1
recode P0730 (0 98 = .) (9 = 8) (10 = 9)
replace serie_frequentou = P0730 if serie_frequentou == .
* serie_frequentou = 1 - Primeira série/ano
*			  		 2 - Segunda série
*			  		 3 - Terceira série
*			  		 4 - Quarta série
*			  		 5 - Quinta série
*			  		 6 - Sexta série
*			  		 7 - Sétima série
* 			  		 8 - Oitava série
*			  		 9 - Não seriado

replace anos_estudoC = 0 if curso_frequentou<=4	// Creche, pre-escolar, classe de alfabetização e alfabetização de adultos
replace anos_estudoC = 0 if curso_frequentou==5 & serie_frequentou<4 // 1a-3a serie/1o-4o ano do 1o. grau ou fundamental 
replace anos_estudoC = 0 if curso_frequentou==6 & P0740 == 2 // antigo primario sem conclusao
replace anos_estudoC = 0 if curso_frequentou==7 & P0740 == 2 // supletivo 1o.grau/fundamental sem conclusao

replace anos_estudoC = 1 if curso_frequentou==5 & serie_frequentou>=4 & serie_frequentou<=7 // ensino fundamental ate a 7a serie

replace anos_estudoC = 2 if curso_frequentou==5 & serie_frequentou==8 & P0740 == 1 // ensino fundamental com conclusao
replace anos_estudoC = 2 if (curso_frequentou==6 | curso_frequentou==7) & P0740 == 1 // fundamental nao seriado ou supletivo com conclusao
replace anos_estudoC = 2 if (curso_frequentou>=8 & curso_frequentou<=10) & P0740 == 2	// ensino medio sem conclusao

replace anos_estudoC = 3 if (curso_frequentou>=8 & curso_frequentou<=10) & P0740 == 1	// antigo cientifico/classico/medio 2o.ciclo com conclusao

replace anos_estudoC = 3 if curso_frequentou==12 & P0740 == 2		// superior de graduacao sem conclusao

replace anos_estudoC = 4 if curso_frequentou==12 & P0740==1		// superior de graduacao com conclusao
replace anos_estudoC = 4 if curso_frequentou==13		// especializacao/mestrado/doutorado 

* anos_estudoC = 0 – sem instrução ou menos de 4 anos de estudo (primário incompleto)
*                1 – de 4 a 7 (fundamental/ ginásio/ 1º. Grau/ médio primeiro ciclo incompleto)
*				 2 – de 8 a 10 (médio/ 2º. Grau/ médio segundo ciclo incompleto)
*			 	 3 – de 11 a 14 (médio/ 2º. Grau/ médio segundo ciclo completo ou superior incompleto)
*			 	 4 – 15 ou mais (superior completo, mestrado, doutorado)
lab var anos_estudoC "grupos de anos de escolaridade"

* O IBGE fornece a variável P0770 com essa classificação de anos_estudoC compatível com Censo 2010
* É uma possibilidade usá-la diretamente, se quiser.

drop curso_freq serie_freq

* Anos de estudo - cálculo IBGE
rename P0790 anos_estudo
	replace anos_estudo = 16 if anos_estudo > 16 // compatível com demais anos

* Estuda no município em que reside?
recode P0800 (2 3 = 0) (9 = .)
replace P0800 = . if freq_escolaB==0
rename P0800 mun_escola
lab var mun_escola "estuda no município em que reside?"
* mun_escola = 1 - sim
*			   0 - não

recode P0750 (140/226 320/322 347 380 = 3) ///
		 (260 270 421 641/727 = 4) ///
		 (440/481 520/525 581 582 = 5) ///
		 (620/624 = 6) ///
		 (310/314 342/346 762 = 7) ///
		 (863 = 8) ///
		 (240 420 422 483 541/554 810/862 870 900 910 = 9), g(cursos_c1)
lab var cursos_c1 "curso superior concluído"
* cursos_c1	=	3	ciências humanas
*				4	ciências biológicas
*				5	ciências exatas
*				6	ciências agrárias
*				7	ciências sociais
*				8	militar
*				9	outros cursos
		 
recode P0750 (140/146 = 1) ///
		 (210/270 = 2) ///
		 (310/380 = 3) ///
		 (420/483 = 4) ///
		 (520/582 623 = 5) ///
		 (620/622 624 641 = 6) ///
		 (720/762 = 7) ///
		 (810/870 = 8) ///
		 (900 910 = 9), g(cursos_c2)
lab var cursos_c2 "curso superior concluído - CONCLA"
* cursos_c2 =	1	Educação
*				2	Artes, Humanidades e Letras
*				3	Ciências Sociais, Administração e Direito
*				4	Ciências, Matemática e Computação
*				5	Engenharia, Produção e Construção
*				6	Agricultura e Veterinária
*				7	Saúde e Bem-Estar Social    
*				8	serviços
*				9	Outros

rename P0750 curso_concl	// COMP SO PARA CURSO SUPERIOR 

/* D.9. SITUAÇÃO CONJUGAL */

* teve conjuge
recode P0280 (1 2 = 1) (3 = 0), g(teve_conjuge)
label var teve_conjuge "vive ou já viveu com cônjuge"
* teve_conjuge = 0 - não
*                1 - sim

* vive com o cônjuge?
recode P0280 (2 3 = 0)
rename P0280 vive_conjuge
lab var vive_conjuge "se a pessoa vive com o cônjuge"
* vive_conjuge = 0 - Não
*				 1 - Sim

gen estado_conj_B = P0290 if vive_conjuge == 1
replace estado_conj_B = 5 if teve_conjuge == 0
replace estado_conj_B = 6 if (teve_conjuge == 1 & vive_conjuge == 0 & estado_conj_B == .)
label var estado_conj_B "estado conjugal B - mais agregado"
* estado_conj_B = 1 casamento civil e religioso
*               2 só casamento civil
*               3 só casamento religioso
*               4 união consensual
*               5 solteiro
*               6 outros: separado(a) OU desquitado(a)/separado(a) judicialmente OU divorciado(a) OU viúvo(a)

/* D.10.1 TRABALHO */

gen trab_rem_sem = 1 if P0840 == 1 | P0850 == 1 | P0860 == 1
replace trab_rem_sem = 0 if trab_rem_sem == . & P0860 == 2
* trab_rem_sem = 1 - Sim
*				 0 - Não

/* Atenção! Em 2022, a pergunta se ajudou sem pagamento algum morador do domicílio ou parente veio antes da de estar afastado de trabalho remunerado.
Vamos disponibilizar sob mesmo nome, pois a pergunta é igual, mas cuidado ao comparar os anos, pois o fluxo pode afetar a quantidade de pessoas que
aparece em cada categoria. */
rename P0880 afast_trab_sem
recode afast_trab_sem (2 = 0) (9 = .)
* afast_trab_sem = 1 - Sim
*				   0 - Não

* OBS: não perfeitamente compatível com 2000 por conta de mudanças nas questões.
* Em 2000, sao duas questoes, uma referente a aprendiz/estagiário e outra sobre
* ajuda sem remuneração a morador em atividade de extração e cultivo; em 2010 e 2022,
* é uma pergunta genérica sobre ajuda sem remuneração a morador do domicílio
rename P0870 nao_remun
recode nao_remun (2 = 0) (9 = .)
* nao_remun = 1 - Sim
*			  0 - Não
	
rename P0890 trab_proprio_cons
recode trab_proprio_cons (2 = 0) (9 = .)
* trab_proprio_cons = 1 - Sim
*					  0 - Não

recode P0900 (1 = 0) (2 3 = 1) (9 = .)
rename P0900 mais_de_um_trab
lab var mais_de_um_trab "tinha mais de um trabalho"
* mais_de_um_trab = 0 - Não
*			   	    1 - Sim

rename P0970 ocup2010
recode ocup2010 (K000 = 0000)
rename P0980 ativ2010
recode ativ2010 (32991 32998 = 32999) (84997 84998 = 84999) (00999 = 00000)

* PEA nesse ano é apenas para 14 anos ou mais
rename P0930 pea

* Posição na Ocupação
* Não considerei funcionários públicos não estatutários que não tivessem carteira de
* trabalho assinada em nenhum grupo. Pode ser revisto, se necessário.
gen pos_ocup_sem = 1 if P0990 == 3 & P1000 == 1
replace pos_ocup_sem = 2 if P0990 == 2 | P0990 == 4 | (P0990 == 5 & P1000 == 1) | (P0990 == 6 & P1000 == 1)
replace pos_ocup_sem = 3 if P0990 == 3 & P1000 == 2
replace pos_ocup_sem = 4 if P0990 == 1 & P1000 == 1
replace pos_ocup_sem = 5 if P0990 == 1 & P1000 == 2
replace pos_ocup_sem = 6 if P0990 == 8
replace pos_ocup_sem = 7 if P0990 == 7
replace pos_ocup_sem = 8 if P0990 == 9
replace pos_ocup_sem = 9 if pos_ocup_sem == . & trab_proprio_cons == 1
* pos_ocup_sem  = 1 - Empregado com carteira
*				  2 - Militar e Funcionário Públicos
*				  3 - Empregado sem carteira
*				  4 - Trabalhador doméstico com carteira
*				  5 - Trabalhador doméstico sem carteira
*				  6 - Conta - própria
*				  7 - Empregador
*				  8 - Não remunerado
*                 9 - Trabalhador na produção para o próprio consumo

drop P0990 P1000

* para pessoas de 14 anos ou mais
rename P0940 previd_B
* previd = 1 - Sim
*          0 - Não

* providência para conseguir trabalho
recode P1050 (2 = 0) (9 = .)
rename P1050 tomou_prov
lab var tomou_prov "tomou providências para conseguir trabalho"
* tom_prov = 1 - sim
*            0 - não

* trabalha no município 
recode P1120 (1 2 = 1) (3/5 = 0) (9 = .)
rename P1120 mun_trab
lab var mun_trab "trabalha no município em que reside"
* mun_trab 	= 1 - sim
*			  0 - não

/* D.10.2 RENDIMENTOS */

/* Há uma distinção em 2022, em que é perguntado rendimento do trabalho principal somente para quem tinha 1 trabalho e para quem tinha mais trabalhos, 
é perguntado o rendimento total desses trabalhos.
Vamos disponibilizar o rendimento do trabalho principal, mas note que ela irá representar a mesma coisa entre os anos apenas para quem tem apenas 1 trabalho.
Vamos também disponibilizar uma nova variável, rendimento de todos os trabalhos, somando trabalho principal com outras ocupações sob nome rend_todos_trab,
aplicando também para 2000 e 2010. */

replace P1080 = . if P1080 == 0

* rendimento bruto trabalho principal (se apenas 1 trabalho)
gen rend_ocup_prin = P1080 if mais_de_um_trab == 0

* rendimento bruto todos trabalhos
rename P1080 rend_todos_trab

* em anos anteriores já disponibilizava a total pronta, ver se em 2022 também
rename P1110 rend_total
lab var rend_total "rendimento de todas as fontes"

rename P1100 rend_outras_fontes
lab var rend_outras_fontes "rendimento de outras fontes"

/* D.11. FECUNDIDADE */

rename P0320 f_nasc_v_hom
rename P0330 f_nasc_v_mul
rename P0340 filhos_nasc_vivos

rename P0350 f_vivos_hom
rename P0360 f_vivos_mul
rename P0370 filhos_vivos

rename P0381 idade_ult_nasc_v

label var f_nasc_v_hom "filhos nascidos vivos (homens)"
label var f_nasc_v_mul "filhos nascidos vivos (mulheres)"
label var idade_ult_nasc_v "idade calculada do ultimo filho nascido vivo"
	
/* DEFLACIONANDO RENDAS: referência = julho/2022 */
/* Manual do entrevistador Censo 2022: Trabalho e Rendimento:
Na investigação deste tema, serão considerados os seguintes períodos de referência:
SEMANA DE REFERÊNCIA – 25 a 31 de julho de 2022.
MÊS DE REFERÊNCIA – julho de 2022. */
g double deflator = 1
g conversor = 1
lab var deflator "deflator de rendimentos - julho/2022"
lab var conversor "conversor de moedas"

foreach var in rend_ocup_prin rend_todos_trab rend_total rend_outras_fontes {
		g `var'_def = (`var'/conversor)/deflator
		lab var `var'_def "`var' deflacionada"
}

/* D.12. OUTRAS INFORMAÇÕES */
 
drop P0030 P0040 P0050 P0060 P0070 P0080 P0090 P0120 P0130 P0180 P0220 P0230 P0240 P0250 P0260 P0270 P0290 P0300 P0310 P0380 P0390 P0400 P0410 P0450 P0470 P0500 P0530 P0560 P0600 P0650 P0680 P0690 P0710 P0730 P0740 P0760 P0770 P0780 P0810 P0820 P0830 P0840 P0850 P0860 P0910 P0920 P0950 P0960 P1010 P1020 P1030 P1040 P1060 P1070 P1090 P1130 P1140 P1150 P1160 P1170 P1180 P1190 P1200 P1210 P1220 MP*

order ano UF regiao munic id_dom ordem

end

**************
* CENSO 2022 *
**************

program define compat_censo10dom

/* A. ANO */
* Essa variável é definida antes de chamar este programa.

/* B. IDENTIFICAÇÃO  */

/* B.1. IDENTIFICAÇÃO */
rename v0001 UF
rename v0300 id_dom
rename v1001 regiao
drop v0002 v0011 v1002 v1003 v1004

/* B.2. VARIÁVEIS DE NÚMERO DE PESSOAS */
rename v0401 n_pes_dom

/* C. OUTRAS VARIÁVEIS DE DOMICÍLIO */

/* C.1. SITUAÇÃO */

recode v1006 (2=0)
rename v1006 sit_setor_C
lab var sit_setor_C "situação do domicílio - urbano/rural"
*sit_setor_C = 1 - urbano
*              0 - rural

/* C.2. ESPÉCIE */

rename v4001 especie
recode especie (1 2 = 0) (5 = 1) (6 = 2)
*especie = 0 - particular permanente 
*          1 - particular improvisado
*          2 - coletivo

/* C.3. MATERIAL DAS PAREDES */
recode v0202 (2 4 = 1) (3 = 2) (5 = 3) (6 = 4) (7 = 5) (8 = 6) (9 = .)
rename v0202 paredes
* paredes 	= 1   Alvenaria
*        	= 2   Madeira aparelhada
*        	= 3   Taipa não revestida
*       	= 4   Material aproveitado
*   	    	= 5   Palha
*	        = 6   Outro

gen paredes_B = paredes
recode paredes_B (6=5)
* paredes_B	= 1   Alvenaria
*        	= 2   Madeira aparelhada
*        	= 3   Taipa não revestida
*       	= 4   Material aproveitado
*   	    = 5   Outro

/* C.4.	MATERIAL DA COBERTURA */

/* C.5. TIPO */
* Em 2010, aparece a categoria "oca ou maloca". Esta foi incluída em "casa" por
* exclusão, pois não se trata de apartamento nem de cômodo.

recode v4002 (11 12 15 = 1) (13 = 2) (14 = 3) (50/max = .)
rename v4002 tipo_dom
* tipo_dom = 1 - casa ou oca/maloca
*            2 - apartamento
*            3 - cômodo
lab var tipo_dom "tipo do domicílio"


g tipo_dom_B = tipo_dom
recode tipo_dom_B (3 = 2)
* tipo_dom_B = 1 - casa ou oca/maloca
*              2 - apartamento
lab var tipo_dom_B "tipo do domicílio B"


/* C.6. CONDIÇÃO DE OCUPAÇÃO E ALUGUEL */

g cond_ocup = v0201 - 1
replace cond_ocup = 1 if cond_ocup==0
* cond_ocup  = 1 - Próprio
*              2 - Alugado
*              3 - Cedido por empregador
*              4 - Cedido de outra forma
*              5 - Outra Condição
lab var cond_ocup "condição de ocupação do domicílio"

g cond_ocup_B = cond_ocup 
recode cond_ocup_B (4 =3) (5 = 4)
* cond_ocup_B = 1 - próprio
*               2 - alugado
*               3 - cedido
*               4 - outra condição
lab var cond_ocup_B "condição de ocupação do domicílio B"

rename v0201 cond_ocup_C
* cond_ocup_C= 1 - Próprio, já pago
*              2 - Próprio, ainda pagando
*              3 - Alugado
*              4 - Cedido por empregador
*              5 - Cedido de outra forma
*              6 - Outra Condição

/* ALUGUEL */
rename v2011 aluguel

* aluguel em salarios mínimos
drop v2012

 
/* C.7. INSTALAÇÕES SANITÁRIAS */
rename v0205 banheiros_B
* banheiros_B= 0 - não tem
*              1 - 1 banheiro
*              2 - 2 banheiros
*              3 - 3 banheiros
*              4 - 4 banheiros
*              5 - 5 banheiros
*              6 - 6 banheiros
*              7 - 7 banheiros
*              8 - 8 banheiros
*              9 - 9 ou mais banheiros

g banheiros = banheiros_B
replace banheiros = 5 if banheiros >= 5
lab var banheiros "número de banheiros"
*banheiros = 0 - não tem
*			 1 - 1 banheiro
*			 2 - 2 banheiros
*            3 - 3 banheiros
*            4 - 4 banheiros
*            5 - 5 ou mais banheiros
drop banheiros_B

rename v0206 sanitario
recode sanitario (2 = 0)
replace sanitario = 1 if banheiros>0 & banheiros~=.
* sanitario = 0 - Não
*             1 - Sim


rename v0207 tipo_esc_san_B
*tipo_esc_san_B = 1 - Rede geral de esgoto ou pluvial
*                 2 - Fossa séptica
*                 3 - Fossa rudimentar
*                 4 - Vala
*                 5 - Rio, lago ou mar
*                 6 - Outro 
lab var tipo_esc_san_B "tipo de escoadouro - desagregado"

g tipo_esc_san = tipo_esc_san_B
recode tipo_esc_san (4 5 6 = 4)
lab var tipo_esc_san "tipo de escoadouro"
*tipo_esc_san = 1 - Rede geral de esgoto ou pluvial
*               2 - Fossa séptica
*               3 - Fossa rudimentar
*               4 - Outro

/* C.8. ABASTECIMENTO DE ÁGUA */

rename v0208 abast_agua_B
recode abast_agua_B (1=1) (2 9 = 2) (3/8 10 = 3)
*abast_agua_B = 1 - rede geral
*               2 - poço ou nascente na propriedade
*               3 - outra

gen abast_agua = 1 if (abast_agua_B == 1) & (v0209 == 1)
replace abast_agua = 2 if (abast_agua_B == 1) & ((v0209 == 2) | (v0209 == 3))
replace abast_agua = 3 if (abast_agua_B == 2) & (v0209 == 1)
replace abast_agua = 4 if (abast_agua_B == 2) & ((v0209 == 2) | (v0209 == 3))
replace abast_agua = 5 if abast_agua_B == 3
* abast_agua = 1 - rede geral com canalização interna
*              2 - rede geral sem canalização interna
*              3 - poço ou nascente com canalização interna
*              4 - poço ou nascente sem canalização interna
*              5 - outra forma
lab var abast_agua "forma de abastecimento de água"
drop abast_agua_B

rename v0209 agua_canal
*agua_canal = 1 - Canalizada em pelo menos um cômodo
*             2 - Canalizada só na propriedade ou terreno
*             3 - Não canalizada


/* C.9. DESTINO DO LIXO */
rename v0210 dest_lixo
* dest_lixo = 1 - Coletado por serviço de limpeza
*             2 - Colocado em caçamba de serviço de limpeza
*             3 - Queimado(na propriedade)
*             4 - Enterrado(na propriedade)
*             5 - Jogado em terreno baldio ou logradouro
*             6 - Jogado em rio, lago ou mar
*             7 - Tem outro destino

gen dest_lixo_B = dest_lixo
recode dest_lixo_B (7=6)
* dest_lixo_B = 1 - Coletado no domicílio por serviço de limpeza
*             	2 - Colocado em caçamba de serviço de limpeza
*             	3 - Queimado na propriedade
*             	4 - Enterrado na propriedade
*             	5 - Jogado em terreno baldio, encosta ou área pública
*             	6 - Outro destino

/* C.10. ILUMINAÇÃO ELÉTRICA */
rename v0211 ilum_eletr
recode ilum_eletr (1 2 =1) (3 = 0)
*ilum_eletr = 0 - Não
*             1 - Sim


rename v0212 medidor_el
recode medidor_el (1 2 = 1) (3 = 0)
*medidor_el = 1 - Tem
*		0 - Não tem



/* C.11. BENS DE CONSUMO DURÁVEIS */
rename v0213 radio
recode radio (2 = 0)
* radio = 0 - Não
*         1 - Sim

rename v0214 televisao
recode televisao(2 = 0) (1=1)
*televisao = 0 - não tem
*          = 1 - tem

rename v0215 lavaroupa
recode lavaroupa (2 = 0)
*lavaroupa_B = 0 - Nao
*              1 - Sim

rename v0216 geladeira
recode geladeira (2 = 0)
*geladeira_B = 0 - Não
*              1 - Sim

drop v0217 

recode v0218 (2=0)
rename v0218 telefone
*telefone = 0 - Não
*           1 - Sim

rename v0219 microcomp
recode microcomp (2 = 0)
*microcomp   = 1 - sim
*              0 - não

drop v0220 v0221 

rename v0222 automovel_part
recode automovel_part (2=0) (1=1)
*automov_part = 0-não tem
*               1-tem

/* C.12. NÚMERO DE CÔMODOS */

rename v0203 tot_comodos
rename v0204 tot_dorm

drop v6203 v6204 


/* C.13. RENDA DOMICILIAR */

rename v6529 renda_dom

drop v6530 v6531 v6532

/* DEFLACIONANDO RENDAS: julho/2022 */
g double deflator = 0.4802429326872950000
g conversor = 1

lab var deflator "deflator de rendimentos - referência: julho/2022"
lab var conversor "conversor de moedas"

g renda_dom_def = (renda_dom/conversor)/deflator
lab var renda_dom_def "renda_dom deflacionada"

g aluguel_def = (aluguel/conversor)/deflator
lab var aluguel_def "aluguel deflacionada"

/* C.14. PESO AMOSTRAL */
rename v0010 peso_dom


/* Variáveis de domicílio não utilizadas */

drop v0301 v0402 v0701 v6600 v6210


end
 
program define compat_censo10pess

/* A. ANO */
* Essa variável é definida antes de chamar este programa.

/* B. IDENTIFICAÇÃO  */

rename v0001 UF
drop v0002
rename v0300 id_dom
rename v5020 num_fam
rename v5060 n_pes_fam
rename v1001 regiao
drop v0011 v1002 v1003 v1004
rename v0010 peso_pess

sort UF munic id_dom num_fam
by UF munic id_dom: egen n_homem_dom = total(v0601==1)
by UF munic id_dom: egen n_mulher_dom = total(v0601==2)
lab var n_homem_dom "numero de homens no domicilio"
lab var n_mulher_dom "numero deo mulheres no domicilio"

by UF munic id_dom num_fam: egen n_homem_fam = total(v0601==1)
by UF munic id_dom num_fam: egen n_mulher_fam = total(v0601==2)
lab var n_homem_fam "numero de homens na familia" 
lab var n_mulher_fam "numero de mulheres na familia"

/* C. OUTRAS VARIÁVEIS DE DOMICÍLIO */

/* C.1. SITUAÇÃO */

recode v1006 (2=0)
rename v1006 sit_setor_C
lab var sit_setor_C "situação do domicílio - urbano/rural"

/* D. OUTRAS VARIÁVEIS DE PESSOAS */

rename v0504 ordem

/* D.1. SEXO */
rename v0601 sexo
recode sexo (2 =0)
*sexo = 0 - Feminino
*    	1 - Masculino

/* D.2. CONDIÇÃO NA FAMÍLIA E NO DOMICÍLIO  */
rename v0502 cond_dom
recode 	cond_dom (1 = 1) (2 3 = 2) (4 5 6 = 3) (8 9 = 4) (10 11 = 5) ///
	(12 = 6) (14 13 7 = 7) (15 16 = 8) (17 = 9) (18 = 10)(19 = 11) (20 = 12)
*cond_dom = 1	pessoa responsável
*				2	cônjuge, companheiro
*				3	filho, enteado
*				4	pai, mãe, sogro
*				5	neto, bisneto
*				6	irmão, irmã
*				7	outro parente
*				8	Agregado
*				9	pensionista
*				10	Empregado doméstico
*				11	Parente do empregado doméstico
*				12	Individual em domicílio coletivo

g cond_dom_B = cond_dom
recode cond_dom_B (8 = 6) (10 = 8) (11 = 9) (12 = 10) (5 6 7 = 5) (9 = 7)
lab var cond_dom_B "condição no domicílio B"
*cond_dom_B = 1	- pessoa responsável
*				  2	- cônjuge, companheiro
*				  3	- filho, enteado
*				  4	- pai, mãe, sogro
*				  5	- outro parente
*				  6	- agregado
*				  7	- hóspede, pensionista
*				  8	- Empregado doméstico
*				  9	- Parente do empregado doméstico
*				  10 - Individual em domicílio coletivo

/* D.3. IDADE */
rename v6036 idade
rename v6037 idade_meses
rename v6040 idade_presumida
recode idade_presumida (2 = 1) (1 = 0)
*idade_presumida =   0-	Não
*			1- Sim

drop v6033	
	
/* D.4. COR OU RACA */
recode v0606 (9=.)
rename v0606 raca
*	raca = 1 -Branca
*			2 - Preta
*			3 - Amarela
*			4 - Parda
*			5 - Indígena
	
g racaB = raca
recode racaB (5 = 4)
lab var racaB "cor ou raça (indigenous=mulatto)" // POR QUE ESTA EM INGLES?
*	raca =  1 -Branca
*			2 - Preta
*			3 - Amarela
*			4 - Parda

	
drop v0613	

/* D.5 RELIGIÃO */
replace v6121 = int(v6121/10) // dois primeiros dígitos = religião com os códs de 1991
recode v6121 (11/19 =1) (21/28 = 2) (31/48 = 3) (61=4) (62 63 64= 5) (74 75 76 78 79 = 6) ///
             (71=7) (30 49 51 52 53 59 81 82 83 84 12 13 19 = 8) (85 86 89 99 = .)
rename v6121 religiao
* religiao = 0 - sem religião
*            1 - católica
*            2 - evangélica tradicional
*            3 - evangélica pentecostal
*            4 - espírita kardecista
*            5 - espírita afro-brasileira
*            6 - religiões orientais
*            7 - judaica/israelita
*            8 - outras religiões

gen religiao_A = religiao
recode religiao_A (3 = 2) (4 = 3) (5 = 4) (6 = 5) (7 = 6) (8 = 7)
lab var religiao_A "religião A - mais agregada"
* religiao_A = 0 - sem religião
*            1 - católica
*            2 - evangélica
*            3 - espírita kardecista
*            4 - espírita afro-brasileira
*            5 - religiões orientais
*            6 - judaica/israelita
*            7 - outras religiões

gen religiao_B = religiao
recode religiao_B (3=2) (4 5 = 3) (6/8 = 4)
lab var religiao_B "religião B - mais agregada"
* religiao_B = 0 - sem religião
*              1 - católica
*              2 - evangélica
*              3 - espírita
*              4 - outra

	
/* D.6. DEFICIÊNCIAS FÍSICA E MENTAL */

*legenda: dif_x = dificuldade em fazer o movimento "x"

recode v0614 (9= .)
rename v0614 dif_enxergar
	*dif_enxergar = 1- Sim, não consegue de modo algum
	*				2- Sim, grande dificuldade
	*				3- Sim, alguma dificuldade
	*				4- Não, nenhuma dificuldade
	
recode v0615 (9= .)
rename v0615 dif_ouvir
	*dif_ouvir = 1- Sim, não consegue de modo algum
	*			 2- Sim, grande dificuldade
	*			 3- Sim, alguma dificuldade
	*			 4- Não, nenhuma dificuldade
	
recode v0616 (9= .)
rename v0616 dif_caminhar
	*dif_caminhar = 1- Sim, não consegue de modo algum
	*			 2- Sim, grande dificuldade
	*			 3- Sim, alguma dificuldade
	*			 4- Não, nenhuma dificuldade

recode v0617 (2=0) (9= .) // 1=1
rename v0617 def_mental
	*def_mental = 1 - Sim
	*			  0 - Não

/* D.7. NATURALIDADE E MIGRAÇÃO  */

recode v0618 (2 3 = 0), copy g(sempre_morou)
lab var sempre_morou "sempre morou neste município"
* sempre_morou = 1 - sim
*		= 0 - nao

rename v0618 nasceu_mun
label var nasceu_mun "Nasceu neste município"
recode nasceu_mun (1 2 = 1) (3 = 0)
	*nasceu_mun = 1- Sim
	*		0- Não
rename v0619 nasceu_UF
recode nasceu_UF (1 2 = 1) (3 = 0)
replace nasceu_UF = 1 if nasceu_mun==1
	*nasceu_UF = 1- Sim
	*		0- Não

rename v0620 nacionalidade 
recode nacionalidade (1 = 0) (2 = 1) (3 = 2)
replace nacionalidade = 0 if nasceu_UF==1
* nacionalidade = 0- Brasileiro nato
	*		1- Naturalizado brasileiro
	*		2- Estrangeiro
	
rename v0621 ano_fix_res
	*ano em que fixou residência no Brasil

drop v0622

replace v6222 = floor(v6222/10^5)
replace v6222 = . if v6222>53
rename v6222 UF_nascim

recode v6224 (8000998/max =.) (8000710 8000024 8000012 8000204 8000072 8000854 8000108 8000132 8000120 ///
	8000148 8000174 8000178 8000384 8000262 8000232 8000231 8000266 8000270 ///
	8000288 8000324 8000624 8000226 8000426 8000430 8000434 8000450 8000454 ///
	8000466 8000504 8000480 8000478 8000508 8000516 8000562 8000566 8000404 ///
	8000140 8000180 8000646 8000678 8000686 8000694 8000690 8000706 8000748 ///
	8000736 8000834 8000768 8000788 8000800 8000894 8000716 = 83 "Africa - outros")	///
	(8000818=82 "Egito") ///
	(8000032=30 "Argentina") ///
	(8000124=32 "Canadá") ///
	(8000192=36 "Cuba") ///
	(8000218=37 "Equador") ///
	(8000840=38 "EUA") ///
	(8000320=39 "Guatemala") ///
	(8000254=40 "Guiana Francesa") ///
	(8000328=41 "Guiana Inglesa") ///
	(8000340=44 "Honduras Britânicas") ///
	(8000388=45 "Jamaica") ///
	(8000558=47 "Nicarágua") ///
	(8000591=48 "Panamá") ///
	(8000600=49 "Paraguai") ///
	(8000604=50 "Peru") ///
	(8000214=51 "República Dominicana") ///
	(8000222=52 "Salvador") ///
	(8000740=53 "Suriname") ///
	(8000858=54 "Uruguai") ///
	(8000862=55 "Venezuela") ///
	(8000028 8000044 8000052 8000084 8000068 8000152 8000170 8000188 8000212 ///
		8000308 8000332 8000484 8000662 8000659 8000670 8000780 = 56 "América - outros") ///
	(8000276=58 "Alemanha")	///
	(8000040=59 "Áustria") ///
	(8000056=60 "Bélgica") ///
	(8000100=61 "Bulgária") ///
	(8000208=62 "Dinamarca") ///
	(8000724=63 "Espanha") ///
	(8000246=64 "Finlândia") ///
	(8000250=65 "França") ///
	(8000826=66 "Grã-Bretanha") ///
	(8000300=67 "Grécia") ///
	(8000528=68 "Holanda") ///
	(8000348=69 "Hungria") ///
	(8000372=70 "Irlanda (Eire)") ///
	(8000380=71 "Itália") ///
	(8000070 8000191 8000705 8000807 8000499 8000688 = 72 "Iugoslávia") ///
	(8000578=73 "Noruega") ///
	(8000616=74 "Polônia") ///
	(8000620=75 "Portugal") ///
	(8000642=76 "Romênia") ///
	(8000752=77 "Suécia") ///
	(8000756=78 "Suíça") ///
	(8000203 8000703=79 "Tchecoeslovaquia") ///
	(8000112 8000233 8000428 8000440 8000643 8000804 = 80 "URSS") ///
	(8000008 8000020 8000352 8000438 8000442 8000470 8000492 8000498 8000674 ///
		8000336 = 81 "Europa - outros") ///
	(8000156=84 "China - Continente") ///
	(8000408=86 "Coréia") ///
	(8000356=87 "Índia") ///
	(8000376=88 "Israel") ///
	(8000392=89 "Japão") ///
	(8000422=90 "Líbano") ///
	(8000586=91 "Paquistão") ///
	(8000760=92 "Síria") ///
	(8000792=93 "Turquia") ///
	(8000004 8000682 8000051 8000031 8000048 8000050 8000096 8000064 8000116 ///
		8000398 8000634 8000196 8000702 8000784 8000608 8000268 8000887 ///
		8000360 8000364 8000368 8000400 8000414 8000458 8000462 8000104 ///
		8000496 8000524 8000512 8000417 8000410 8000418 8000144 8000762 ///
		8000764 8000626 8000795 8000860 8000704 = 94 "Ásia - outros") ///
	(8000036=95 "Austrália") ///
	(8000583 8000242 8000584 8000090 8000296 8000520 8000554 8000585 ///
		8000598 8000882 8000776 8000798 8000548 = 96 "Oceania - outros"), g(pais_nascim)
label var pais_nascim "País de nascimento - códigos 1970"
* Obs: Em 2010, a Irlanda do Norte possui o mesmo código que os países da Grã-Bretanha. Não dá
* pra saber se nos anos anteriores o equívoco foi cometido. Isso vale para todas os itens 
* desta seção, quando aplicável.

drop v6224

replace v6252 = floor(v6252/10^5)
replace v6252 = . if v6252>53
rename v6252 UF_mor_ant

replace v6254 = . if v6254>5400000 
rename v6254 mun_mor_ant

recode v6256 (8000998/max =.) (8000710 8000024 8000012 8000204 8000072 8000854 8000108 8000132 8000120 ///
	8000148 8000174 8000178 8000384 8000262 8000232 8000231 8000266 8000270 ///
	8000288 8000324 8000624 8000226 8000426 8000430 8000434 8000450 8000454 ///
	8000466 8000504 8000480 8000478 8000508 8000516 8000562 8000566 8000404 ///
	8000140 8000180 8000646 8000678 8000686 8000694 8000690 8000706 8000748 ///
	8000736 8000834 8000768 8000788 8000800 8000894 8000716 = 83 "Africa - outros")	///
	(8000818=82 "Egito") ///
	(8000032=30 "Argentina") ///
	(8000124=32 "Canadá") ///
	(8000192=36 "Cuba") ///
	(8000218=37 "Equador") ///
	(8000840=38 "EUA") ///
	(8000320=39 "Guatemala") ///
	(8000254=40 "Guiana Francesa") ///
	(8000328=41 "Guiana Inglesa") ///
	(8000340=44 "Honduras Britânicas") ///
	(8000388=45 "Jamaica") ///
	(8000558=47 "Nicarágua") ///
	(8000591=48 "Panamá") ///
	(8000600=49 "Paraguai") ///
	(8000604=50 "Peru") ///
	(8000214=51 "República Dominicana") ///
	(8000222=52 "Salvador") ///
	(8000740=53 "Suriname") ///
	(8000858=54 "Uruguai") ///
	(8000862=55 "Venezuela") ///
	(8000028 8000044 8000052 8000084 8000068 8000152 8000170 8000188 8000212 ///
		8000308 8000332 8000484 8000662 8000659 8000670 8000780 = 56 "América - outros") ///
	(8000276=58 "Alemanha")	///
	(8000040=59 "Áustria") ///
	(8000056=60 "Bélgica") ///
	(8000100=61 "Bulgária") ///
	(8000208=62 "Dinamarca") ///
	(8000724=63 "Espanha") ///
	(8000246=64 "Finlândia") ///
	(8000250=65 "França") ///
	(8000826=66 "Grã-Bretanha") ///
	(8000300=67 "Grécia") ///
	(8000528=68 "Holanda") ///
	(8000348=69 "Hungria") ///
	(8000372=70 "Irlanda (Eire)") ///
	(8000380=71 "Itália") ///
	(8000070 8000191 8000705 8000807 8000499 8000688 = 72 "Iugoslávia") ///
	(8000578=73 "Noruega") ///
	(8000616=74 "Polônia") ///
	(8000620=75 "Portugal") ///
	(8000642=76 "Romênia") ///
	(8000752=77 "Suécia") ///
	(8000756=78 "Suíça") ///
	(8000203 8000703=79 "Tchecoeslovaquia") ///
	(8000112 8000233 8000428 8000440 8000643 8000804 = 80 "URSS") ///
	(8000008 8000020 8000352 8000438 8000442 8000470 8000492 8000498 8000674 ///
		8000336 = 81 "Europa - outros") ///
	(8000156=84 "China - Continente") ///
	(8000408=86 "Coréia") ///
	(8000356=87 "Índia") ///
	(8000376=88 "Israel") ///
	(8000392=89 "Japão") ///
	(8000422=90 "Líbano") ///
	(8000586=91 "Paquistão") ///
	(8000760=92 "Síria") ///
	(8000792=93 "Turquia") ///
	(8000004 8000682 8000051 8000031 8000048 8000050 8000096 8000064 8000116 ///
		8000398 8000634 8000196 8000702 8000784 8000608 8000268 8000887 ///
		8000360 8000364 8000368 8000400 8000414 8000458 8000462 8000104 ///
		8000496 8000524 8000512 8000417 8000410 8000418 8000144 8000762 ///
		8000764 8000626 8000795 8000860 8000704 = 94 "Ásia - outros") ///
	(8000036=95 "Austrália") ///
	(8000583 8000242 8000584 8000090 8000296 8000520 8000554 8000585 ///
		8000598 8000882 8000776 8000798 8000548 = 96 "Oceania - outros"), g(pais_mor_ant)
label var pais_mor_ant "País onde morava anteriormente (se migrou nos últ 10 anos)"
drop v6256

rename v0624 anos_mor_mun
* Em 2010, ha discernimento entre quem nasceu e sempre morou na UF e quem nasceu mas
* nem sempre morou, sendo que apenas os últimos respondem ha qto tempo moram na UF sem 
* interrupção. Então, para compatibilizar, para quem nasceu e sempre morou, o tempo de 
* moradia é a idade
replace v0623 = idade if v0623==. & anos_mor_mun~=.
rename v0623 anos_mor_UF

* tempo de moradia em 1970 só vale para quem não nasceu no município. // MAS DO JEITO QUE ESTÁ CONSTRUÍDO, INCLUI QUEM NASCEU, POIS A VARIÁVEL ACIMA INCLUI IDADE
g t_mor_UF_70 = anos_mor_UF
g t_mor_mun_70 = anos_mor_mun
recode t_mor_UF_70 t_mor_mun_70 (7/10=6) (11/max=7)
lab var t_mor_UF_70 "tempo de moradia na UF - grupos de 1970"
lab var t_mor_mun_70 "tempo de moradia no municipio - grupos de 1970"

* De 1980 em diante, podemos montar a variavel de tempo de moradia incluindo
* pessoas que nasceram mas nem sempre moraram no municipio em que residem
recode anos_mor_UF (7/9 =6) (10/max =7), g(t_mor_UF_80)
recode anos_mor_mun (7/9 =6) (10/max =7), g(t_mor_mun_80)
lab var t_mor_UF_80 "tempo de moradia na UF - grupos de 1980"
lab var t_mor_mun_80 "tempo de moradia no municipio - grupos de 1980"

replace v6262 = floor(v6262/10^5)
replace v6262 = . if v6262>53
rename v6262 UF_mor5anos

replace v6264 = . if v6264>5400000 
rename v6264 mun_mor5anos

recode v6266 (8000998/max =.) (8000710 8000024 8000012 8000204 8000072 8000854 8000108 8000132 8000120 ///
	8000148 8000174 8000178 8000384 8000262 8000232 8000231 8000266 8000270 ///
	8000288 8000324 8000624 8000226 8000426 8000430 8000434 8000450 8000454 ///
	8000466 8000504 8000480 8000478 8000508 8000516 8000562 8000566 8000404 ///
	8000140 8000180 8000646 8000678 8000686 8000694 8000690 8000706 8000748 ///
	8000736 8000834 8000768 8000788 8000800 8000894 8000716 = 83 "Africa - outros")	///
	(8000818=82 "Egito") ///
	(8000032=30 "Argentina") ///
	(8000124=32 "Canadá") ///
	(8000192=36 "Cuba") ///
	(8000218=37 "Equador") ///
	(8000840=38 "EUA") ///
	(8000320=39 "Guatemala") ///
	(8000254=40 "Guiana Francesa") ///
	(8000328=41 "Guiana Inglesa") ///
	(8000340=44 "Honduras Britânicas") ///
	(8000388=45 "Jamaica") ///
	(8000558=47 "Nicarágua") ///
	(8000591=48 "Panamá") ///
	(8000600=49 "Paraguai") ///
	(8000604=50 "Peru") ///
	(8000214=51 "República Dominicana") ///
	(8000222=52 "Salvador") ///
	(8000740=53 "Suriname") ///
	(8000858=54 "Uruguai") ///
	(8000862=55 "Venezuela") ///
	(8000028 8000044 8000052 8000084 8000068 8000152 8000170 8000188 8000212 ///
		8000308 8000332 8000484 8000662 8000659 8000670 8000780 = 56 "América - outros") ///
	(8000276=58 "Alemanha")	///
	(8000040=59 "Áustria") ///
	(8000056=60 "Bélgica") ///
	(8000100=61 "Bulgária") ///
	(8000208=62 "Dinamarca") ///
	(8000724=63 "Espanha") ///
	(8000246=64 "Finlândia") ///
	(8000250=65 "França") ///
	(8000826=66 "Grã-Bretanha") ///
	(8000300=67 "Grécia") ///
	(8000528=68 "Holanda") ///
	(8000348=69 "Hungria") ///
	(8000372=70 "Irlanda (Eire)") ///
	(8000380=71 "Itália") ///
	(8000070 8000191 8000705 8000807 8000499 8000688 = 72 "Iugoslávia") ///
	(8000578=73 "Noruega") ///
	(8000616=74 "Polônia") ///
	(8000620=75 "Portugal") ///
	(8000642=76 "Romênia") ///
	(8000752=77 "Suécia") ///
	(8000756=78 "Suíça") ///
	(8000203 8000703=79 "Tchecoeslovaquia") ///
	(8000112 8000233 8000428 8000440 8000643 8000804 = 80 "URSS") ///
	(8000008 8000020 8000352 8000438 8000442 8000470 8000492 8000498 8000674 ///
		8000336 = 81 "Europa - outros") ///
	(8000156=84 "China - Continente") ///
	(8000408=86 "Coréia") ///
	(8000356=87 "Índia") ///
	(8000376=88 "Israel") ///
	(8000392=89 "Japão") ///
	(8000422=90 "Líbano") ///
	(8000586=91 "Paquistão") ///
	(8000760=92 "Síria") ///
	(8000792=93 "Turquia") ///
	(8000004 8000682 8000051 8000031 8000048 8000050 8000096 8000064 8000116 ///
		8000398 8000634 8000196 8000702 8000784 8000608 8000268 8000887 ///
		8000360 8000364 8000368 8000400 8000414 8000458 8000462 8000104 ///
		8000496 8000524 8000512 8000417 8000410 8000418 8000144 8000762 ///
		8000764 8000626 8000795 8000860 8000704 = 94 "Ásia - outros") ///
	(8000036=95 "Austrália") ///
	(8000583 8000242 8000584 8000090 8000296 8000520 8000554 8000585 ///
		8000598 8000882 8000776 8000798 8000548 = 96 "Oceania - outros"), g(pais_mor5anos)
label var pais_mor5anos "País onde morava há 5 anos"

drop v6266 v0625 v0626 

/* D.8. EDUCACÃO */

rename v0627 alfabetizado
recode alfabetizado (2 = 0)
	*alfabetizado = 1 - Sim
	*		 0 - Não
	
** frequencia a escola: 2010 DESCONSIDERA PRE-VESTIBULAR, por isso, diversas variaveis de frequencia

recode v0628 (1 2=1 "sim") (3 4 =0 "nao"), g(freq_escola)
replace freq_escola = 0 if v0629<=3		// 	desconsidera creche e pre-escola para compatibilizar com todos
lab var freq_escola "frequenta escola"
*freq_escola = 1 - Sim
*		0 - Não

g freq_escolaB = freq_escola
replace freq_escolaB = 1 if v0629==2 | v0629==3	// 	inclui pre-escola
lab var freq_escolaB "frequenta escola - inclui pre-escola"
*freq_escolaB = 1 - Sim
*		0 - Não

* rede de ensino
recode v0628 (1 = 1) (2 = 0) (else=.) 
rename v0628 rede_freq
lab var rede_freq "rede de ensino da escola"
* rede_freq = 0 - particular
*             1 - pública

* Como há diversas definições para a frequencia a escola, a variavel abaixo deve
* ser utilizada conjuntamente com a frequencia
recode v0629 (6 = 7) (7 = 8) (10 11 12 = 13) (9 = 12) (8 = 10)		
replace v0629 = 6 if v0629==5 & v0630==10
replace v0629 = 9 if v0629==8 & v0631==5
rename v0629 curso_freq
* curso_freq = 1  - Creche
*             2  - Pré-escolar
*             3  - Classe de alfabetização
*             4  - Alfabetização de adultos
*             5  - Ensino fundamental ou 1º grau - regular seriado
*             6  - Ensino fundamental ou 1º grau - regular não-seriado
*             7  - Supletivo - Ensino fundamental ou 1º grau
*             8  - Ensino médio ou 2º grau - regular seriado
*             9  - Ensino médio ou 2º grau - regular não-seriado
*             10 - Supletivo - Ensino médio ou 2º grau
*			  11 - Pré-vestibular
*             12 - Superior - graduação
*             13 - Superior - mestrado ou doutorado

rename v0630 serie_freq
recode serie_freq (1 2 = 1) (3 = 2) (4 = 3) (5 = 4) (6 = 5) (7 = 6) (8 = 7) (9 = 8) (10 = 9)
replace serie_freq = v0631 if serie_freq==. & v0631~=5
replace serie_freq = 9 if serie_freq==. & v0631 ==5

*serie_freq = 1 - Primeira série/ano
*			  2 - Segunda série
*			  3 - Terceira série
*			  4 - Quarta série
*			  5 - Quinta série
*			  6 - Sexta série
*			  7 - Sétima série
* 			  8-  Oitava série
*			  9 - Não seriado
	
* grupos de anos de estudo
g anos_estudoC = .
* para quem frequenta escola
replace anos_estudoC = 0 if curso_freq<=4	// Creche, pre-escolar, classe de alfabetização e alfabetização de adultos
replace anos_estudoC = 0 if curso_freq==6	// fundamental ou 1o grau nao seriado
replace anos_estudoC = 0 if curso_freq==7	// supletivo fundamental ou 1o grau
replace anos_estudoC = 0 if curso_freq==5 & serie_freq<=4	// fundamental ou 1o grau seriado - até 4o ano (inclusive)

replace anos_estudoC = 1 if curso_freq==5 & serie_freq>=5 & serie_freq<=8	// fundamental ou 1o grau seriado - 5o a 8o ano

replace anos_estudoC = 2 if curso_freq==8 	// medio ou 2o grau seriado - 1o ano
replace anos_estudoC = 2 if curso_freq==9	// medio ou 2o grau nao seriado
replace anos_estudoC = 2 if curso_freq==10	// supletivo medio ou 2o grau

replace anos_estudoC = 3 if curso_freq==12		// superior de graduacao

replace anos_estudoC = 4 if curso_freq==13		// mestrado ou doutorado

* para ficar compativel com 2000, nao podemos recuperar a informacao abaixo
*replace anos_estudoC = 4 if v0632==1	// ja concluiu curso superior de graduacao

* para quem nao frequenta escola
replace anos_estudoC = 0 if v0633<=2	// Creche, pre-escolar, classe de alfabetização e alfabetização de adultos
replace anos_estudoC = 0 if v0633==5	// 1a-3a serie/1o-4o ano do 1o. grau ou fundamental 
replace anos_estudoC = 0 if v0633==3 & v0634==2		// antigo primario sem conclusao
replace anos_estudoC = 0 if v0633==8 & v0634==2		// supletivo 1o.grau/fundamental sem conclusao

replace anos_estudoC = 1 if v0633==3 & v0634==1		// antigo primario com conclusao
replace anos_estudoC = 1 if v0633==4 & v0634==2		// antigo ginasio sem conclusao
replace anos_estudoC = 1 if v0633==6	// 5a serie/6o ano do 1o.grau ou fundamental
replace anos_estudoC = 1 if v0633==7 & v0634==2		// 6a-8a serie/7o-9o ano 1o.grau ou fundamental sem conclusao

replace anos_estudoC = 2 if v0633==4 & v0634==1		// antigo ginasio com conclusao
replace anos_estudoC = 2 if v0633==7 & v0634==1		// 6a-8a serie/7o-9o ano 1o.grau ou fundamental com conclusao
replace anos_estudoC = 2 if v0633==8 & v0634==1		// supletivo 1o.grau/fundamental com conclusao

replace anos_estudoC = 2 if v0633==9 & v0634==2		// antigo cientifico/classico/medio 2o.ciclo sem conclusao
replace anos_estudoC = 2 if v0633==10 & v0634==2		// regular/supletivo ensino medio sem conclusao

replace anos_estudoC = 3 if v0633==9 & v0634==1		// antigo cientifico/classico/medio 2o.ciclo com conclusao
replace anos_estudoC = 3 if v0633==10 & v0634==1		// regular/supletivo ensino medio com conclusao

replace anos_estudoC = 3 if v0633==11 & v0634==2		// superior de graduacao sem conclusao

replace anos_estudoC = 4 if v0633==11 & v0634==1		// superior de graduacao com conclusao
replace anos_estudoC = 4 if v0633==12 & v0633<=14		// especializacao/mestrado/doutorado 

* anos_estudoC = 0 – sem instrução ou menos de 4 anos de estudo (primário incompleto)
*                1 – de 4 a 7 (fundamental/ ginásio/ 1º. Grau/ médio primeiro ciclo incompleto)
*				 2 – de 8 a 10 (médio/ 2º. Grau/ médio segundo ciclo incompleto)
*			 	 3 – de 11 a 14 (médio/ 2º. Grau/ médio segundo ciclo completo ou superior incompleto)
*			 	 4 – 15 ou mais (superior completo, mestrado, doutorado)
lab var anos_estudoC "grupos de anos de escolaridade"

drop v0631 v0632 curso_freq serie_freq

* Estuda no município em que reside?
recode v0636 (2 3 = 0)
replace v0636 = . if freq_escolaB==0	
rename v0636 mun_escola
lab var mun_escola "estuda no município em que reside?"
* mun_escola 	= 1 - sim
*		= 0 - não

recode v6352 (140/226 321 322 347 380 = 3) ///
		 (421 641/727 813 = 4) ///
		 (440/481 520/525 581 582 = 5) ///
		 (620/624 = 6) ///
		 (310/314 340 342/346 762 = 7) ///
		 (863 = 8) ///
		 (341 420 422 482 483 540/544 761 810/812 814/862 085 = 9), g(cursos_c1)
lab var cursos_c1 "curso superior concluído"
* cursos_c1	=	3	ciências humanas
*			4	ciências biológicas
*			5	ciências exatas
*			6	ciências agrárias
*			7	ciências sociais
*			8	militar
*			9	outros cursos
		 
recode v6352 (140/146 = 1) ///
		 (210/226 = 2) ///
		 (310/346 347 380 = 3) ///
		 (420/483 = 4) ///
		 (520/582 623 = 5) ///
		 (620/622 624 641 = 6) ///
		 (720/762 = 7) ///
		 (863 = 8) ///
		 (810/862 085 = 9), g(cursos_c2)
lab var cursos_c2 "curso superior concluído - CONCLA"
* cursos_c2 =	1	Educação
*				2	Artes, Humanidades e Letras
*				3	Ciências Sociais, Administração e Direito
*				4	Ciências, Matemática e Computação
*				5	Engenharia, Produção e Construção
*				6	Agricultura e Veterinária
*				7	Saúde e Bem-Estar Social    
*				8	militar
*				9	Outros

rename v6352 curso_concl	// COMP SO PARA CURSO SUPERIOR

drop v0633 v0634 v0635 v6400 v6354 v6356 v6362 v6364 v6366

/* D.9. SITUAÇÃO CONJUGAL */

* teve conjuge
recode v0637 (1 2 = 1) (3=0), g(teve_conjuge)
label var teve_conjuge "vive ou já viveu com cônjuge"
* teve_conjuge = 0 - não
*                1 - sim

* vive com o cônjuge?
recode v0637 ( 2 3 = 0)
rename v0637 vive_conjuge
lab var vive_conjuge "se a pessoa vive com o cônjuge"
* vive_conjuge = 0 - Não
*		 1 - Sim

drop v0638

gen estado_conj = v0639 if vive_conjuge == 1
replace estado_conj = 5 if teve_conjuge == 0
replace estado_conj = v0640 + 5 if (teve_conjuge == 1 & vive_conjuge == 0 & v0640 >= 2 & v0640 <= 4)
replace estado_conj = 6 if (teve_conjuge == 1 & vive_conjuge == 0 & estado_conj == .)
label var estado_conj "estado conjugal"
* estado_conj = 1 casamento civil e religioso
*               2 só casamento civil
*               3 só casamento religioso
*               4 união consensual
*               5 solteiro
*               6 separado(a)
*               7 desquitado(a)/separado(a) judicialmente
*               8 divorciado(a)
*               9 viúvo(a)

gen estado_conj_B = estado_conj
recode estado_conj_B (7 8 9 = 6)
label var estado_conj_B "estado conjugal B - mais agregado"
* estado_conj_B = 1 casamento civil e religioso
*                 2 só casamento civil
*                 3 só casamento religioso
*                 4 união consensual
*                 5 solteiro
*                 6 outros: separado(a) OU desquitado(a)/separado(a) judicialmente OU divorciado(a) OU viúvo(a)
drop v0639 v0640


/* D.10. RENDA E ATIVIDADE ECONÔMICA */

rename v0641 trab_rem_sem
recode trab_rem_sem (2 = 0)
* trab_rem_sem = 1 - Sim
*		 0 - Não

rename v0642 afast_trab_sem
recode afast_trab_sem (2 = 0)
* afast_trab_sem = 1 - Sim
*			0 - Não

* OBS: não perfeitamente compatível com 2000 por conta de mudanças nas questões.
* Em 2000, sao duas questoes, uma referente a aprendiz/estagiário e outra sobre
* ajuda sem remuneração a morador em atividade de extração e cultivo; em 2010, é
* uma pergunta genérica sobre ajuda sem remuneração a morador do domicílio
rename v0643 nao_remun
recode nao_remun (2 = 0)	
* nao_remun = 1 - Sim
*		0 - Não
	
rename v0644 trab_proprio_cons
recode trab_proprio_cons (2 = 0)
* trab_proprio_cons = 1 - Sim
*			0 - Não

recode v0645 (1 = 0) (2 = 1)
rename v0645 mais_de_um_trab
lab var mais_de_um_trab "tinha mais de um trabalho"
* mais_de_um_trab = 0 - Não
*			1 - Sim

rename v6461 ocup2010
rename v6471 ativ2010	

rename v6462 ocup2000
rename v6472 ativ2000

* OBS: a variável abaixo é uma mistura das existentes em 2000 e 2010.
* Posição na Ocupação
recode v6930 (4 = 6) (5 = 7) (6 = 8) (7 = 9)
rename v6930 pos_ocup_sem 
replace pos_ocup_sem = 4 if v6940==1
replace pos_ocup_sem = 5 if v6940==2

* pos_ocup_sem  = 1 - Empregado com carteira
*		  2 - Militar e Funcionário Públicos
*		  3 - Empregado sem carteira
*		  4 - Trabalhador doméstico com carteira
*		  5 - Trabalhador doméstico sem carteira
*		  6 - Conta - própria
*		  7 - Empregador
*		  8 - Não remunerado
*                 9 - Trabalhador na produção para o próprio consumo


drop v0648 

rename v0649 qtos_empregados
* qtos_empregados = 1 - Um a cinco empregados
*                   2 - Seis ou mais

rename v0650 previd_B
recode previd_B (1 2 = 1) (3 = 0) 
* previd = 1-Sim
*          0-Não

drop v0651 

replace	v6511=. if v6511==0
rename v6511 rend_ocup_prin
*rendimento bruto trabalho principal

drop v6513

replace v6514 = . if rend_ocup_prin==.
rename v6514 rend_prin_sm
*rendimento salarios minimos trabalho principal

replace v6521=. if v6521==0
rename v6521 rend_outras_ocup
*rendimento bruto nos demais trabalhos

rename v6524 rend_outras_sm
*rendimento em salarios mínimos nos demais trabalhos

egen rend_todos_trab = rowtotal(rend_ocup_prin rend_outras_ocup)
replace rend_todos_trab = . if rend_ocup_prin == . & rend_outras_ocup == .
* rendimento bruto em todos os trabalhos

drop v6525 v6526

rename v6527 rend_total

rename v6528 rend_total_sm

* renda familiar
replace v5070 = v5070*n_pes_fam
rename v5070 rend_fam
lab var rend_fam "renda familiar"

drop v6530 v6532 v0652 v6529 v6531

* horas trabalhadas no trabalho principal
rename v0653 horas_trabprin

* providencia para conseguir trabalho
recode v0654 (2 = 0)
rename v0654 tomou_prov
*tomou_prov = 1 - sim
*             0 - não

drop v0655

drop v0656 v0657 v0658 v0659

rename v6591 rend_outras_fontes
lab var rend_outras_fontes "rendimento de outras fontes"

* trabalha no município 
recode v0660 (1 2 = 1) (3/5 = 0) (else = .)
rename v0660 mun_trab
lab var mun_trab "trabalha no município em que reside"
* mun_trab 	= 1 - sim
*		= 0 - não

drop v6602 v6604 v6606 v0661 v0662 v5110 v5120 v6900 v6910 v6920 v6940

/* D.11. FECUNDIDADE */

drop v0663 
rename v6631 f_nasc_v_hom
rename v6632 f_nasc_v_mul
rename v6633 filhos_nasc_vivos
drop v0664
rename v6641 f_vivos_hom
rename v6642 f_vivos_mul
rename v6643 filhos_vivos
rename v0665 sexo_ult_nasc_v

label var f_nasc_v_hom "filhos nascidos vivos (homens)"
label var f_nasc_v_mul "filhos nascidos vivos (mulheres)"

recode sexo_ult_nasc_v (2 = 0 )
* sexo_ult_nasc_v = 1 - masculino
*                   0 - feminino

rename v6660 idade_ult_nasc_v
drop v0669 
rename v6691 f_nasc_m_hom
rename v6692 f_nasc_m_mul
rename v6693 filhos_nasc_mortos
rename v6800 filhos_tot

label var idade_ult_nasc_v "idade calculada do ultimo filho nascido vivo"
label var f_nasc_m_hom "filhos nascidos mortos (homens)"
label var f_nasc_m_mul "filhos nascidos mortos (mulheres)"

drop v6664 v0667 v0668 v6681 v6682 
	
/* DEFLACIONANDO RENDAS: julho/2022 */
g double deflator = 0.4802429326872950000
g conversor = 1

lab var deflator "deflator de rendimentos - referência: julho/2022"
lab var conversor "conversor de moedas"

foreach var in rend_ocup_prin rend_outras_ocup rend_todos_trab rend_outras_fontes rend_total rend_fam {
		g `var'_def = (`var'/conversor)/deflator
		lab var `var'_def "`var' deflacionada"
}


/* D.12. OUTRAS INFORMAÇÕES */
 
drop v0670 v0671 v0604 v0605 v5080 v5030- v5130

order ano UF regiao munic id_dom ordem

end

program define compat_censo70

/* A. ANO */
* Já faço isso antes de chamar este programa (idem para a UF)
*generate int ano = 1970

/* B. IDENTIFICAÇÃO E NÚMERO DE MORADORES */

/* B.1. IDENTIFICAÇÃO */
gen regiao = int(UF/10)
lab var regiao "região geográfica"

drop v001 v002

drop v003 v005 v006

sort id_dom num_fam, stable

/* IDENTIFICA PARA QUAIS TIPOS DE REGISTRO DEVE SE FAZER A COMPATIBILIZACAO */

loc d = 0
loc p = 0
foreach n of global x {
	if "`n'" == "dom" loc d = 1
	if "`n'" == "pes" loc p = 1
}

if `d'==1 {

	/* B.2. VARIÁVEIS DE NÚMERO DE PESSOAS */

	* gerando totais de homens e mulheres nas famílias e nos domicílios
	* v023 == 0 representa sexo masculino; == 1 feminino
	by id_dom: egen n_homem_dom = total(v023==0)
	by id_dom: egen n_mulher_dom = total(v023==1)
	egen n_pes_dom = rowtotal(n_homem_dom n_mulher_dom)

	lab var n_homem_dom "número de homens no domicílio"
	lab var n_mulher_dom "número de mulheres no domicílio"
	lab var n_pes_dom "número de pessoas no domicílio"

	/* C. VARIÁVEIS DE DOMICÍLIO */

	/* C.1. SITUAÇÃO */
	recode v004 (0 1 = 1) (2=0)
	rename v004 sit_setor_C
	* sit_setor_C = 1 urbano
	*               0 rural
	* situação "área suburbana" (v004==1) passou a ser considerada, posteriormente,
	* situação "urbana - área não urbanizada"


	/* C.2. ESPÉCIE */
	replace v008 = 0 if (v007 == 0 & (v008 == 0 | v008 == 1))
	replace v008 = 1 if (v007 == 0 & (v008 == 2 | v008 == .))
	replace v008 = 2 if v007 == 1
	rename v008 especie
	* especie = 0 - particular permanente
	*           1 - particular improvisado
	*           2 - coletivo
	drop v007

	/* C.3.	MATERIAL DAS PAREDES */

	/* C.4.	MATERIAL DA COBERTURA */

	/* C.5. TIPO DE DOMICÍLIO */
	* Não há variável de "tipo" de domicílio (se casa, apartamento ou cômodo) em 1970.


	/* C.6. CONDIÇÃO DE OCUPAÇÃO E ALUGUEL */
	gen dom_pago = 1 if v009==1
	replace dom_pago = 0 if v009==2
	lab var dom_pago "dummy para domicílio próprio já pago"
	* dom_pago = 0 - Domicílio próprio em aquisição
	*            1 - Domicílio próprio já pago

	recode v009 (2=1) (3=2) (4=3) (5=4) (0=.) // (1=1)
	rename v009 cond_ocup_B
	* cond_ocup_B = 1 - próprio
	*               2 - alugado
	*               3 - cedido
	*               4 - outra condição

	recode v010 (9 0 = .)
	rename v010 aluguel_70
	* aluguel_70 = 1 - até 15 NCr$
	*              2 - de 16 a 30 NCr$
	*              3 - de 31 a 60 NCr$
	*              4 - de 61 a 120 NCr$
	*              5 - de 121 a 240 NCr$
	*              6 - de 241 a 480 NCr$
	*              7 - de 481 a 960 NCr$
	*              8 - de 961 e mais NCr$


	/* C.7. ABASTECIMENTO DE ÁGUA */
	recode v012 (6 . = .)
	rename v012 abast_agua
	* abast_agua = 1 - rede geral com canalização interna
	*              2 - rede geral sem canalização interna
	*              3 - poço ou nascente com canalização interna
	*              4 - poço ou nascente sem canalização interna
	*              5 - outra forma


	/* C.8. INSTALAÇÃO SANITÁRIA */
	gen sanitario = 0 if v013 == 5
	replace sanitario = 1 if (v013 >= 1) & (v013 <= 4) // reportou tipo de escoadouro
	lab var sanitario "dummy para acesso a sanitário"
	* sanitario = 0 - não tem acesso
	*             1 - tem acesso a sanitario

	recode v013 (5 0 = .) // 1 a 4 mantidos
	rename v013 tipo_esc_san
	* tipo_esc_san = 1 - Rede geral
	*                2 - Fossa séptica
	*                3 - Fossa rudimentar
	*                4 - Outro escoadouro


	/* C.9. DESTINO DO LIXO */
	*Não pesquisado em 1970.


	/* C.10. ILUMINAÇÃO ELÉTRICA */
	recode v014 (0 . = .) (2=0) // (1=1)
	rename v014 ilum_eletr
	* ilum_eletr = 0 - não tem
	*              1 - tem


	/* C.11. BENS DE CONSUMO DURÁVEIS */
	gen fogao = 0 if v015 == 6
	replace fogao = 1 if (v015 >= 1) & (v015 <= 5)
	label var fogao "fogão"
	* fogao = 0 - não tem
	*         1 - tem

	recode v015 (1=2) (0=.) (2=1) (5=4) (6=0) // (3=3) (4=4)
	rename v015 comb_fogao
	* comb_fogao = 1 - gás
	*              2 - lenha
	*              3 - carvão
	*              4 - outro
	*              0 - não tem fogão

	recode v016 (0 . = .) (2=0) // (1=1)
	rename v016 radio
	* radio = 0 - não tem
	*         1 - tem

	recode v017 (0 . = .) (2=0) // (1=1)
	rename v017 geladeira
	* geladeira = 0 - não tem
	*             1 - tem

	recode v018 (0 . = .) (2=0) // (1=1)
	rename v018 televisao
	* televisao = 0 - não tem
	*             1 - tem

	recode v019 (0 . = .) (2=0) // (1=1)
	rename v019 automov_part // NAO FAZ MAIS SENTIDO COMPATIBILIZAR SOMENTE COMO AUTOMOVEL TEM/NAO TEM DO QUE COMO PARTICULAR, JA QUE NO DICIONARIO ORIGINAL NAO FALA ISSO?
	* automov_part = 0 - não tem
	*                1 - tem

	/* C.12. NÚMERO DE CÔMODOS */
	rename v020 tot_comodos
	rename v021 tot_dorm

	/* C.13. RENDA DOMICILIAR */
	* Não pode ser obtida em 1970. Mas há cálculo de renda familiar, como na seção D.10.

	/* C.14. PESO AMOSTRAL */
	* Ver parte D.12.

}

/* D. OUTRAS VARIÁVEIS DE PESSOAS */

if `p'==1 {

	/* número de pessoas na família */
	by id_dom num_fam: egen n_homem_fam = total(v023==0)
	by id_dom num_fam: egen n_mulher_fam = total(v023==1)
	egen n_pes_fam = rowtotal(n_homem_fam n_mulher_fam)

	lab var n_homem_fam "número de homens na família"
	lab var n_mulher_fam "número de mulheres na família"
	lab var n_pes_fam "número de pessoas na família"

	/* D.1. SEXO */
	recode v023 (1=0) (0=1)
	rename v023 sexo
	* sexo = 0 - feminino
	*        1 - masculino

	/* D.2. CONDIÇÃO NA FAMÍLIA E NO DOMICÍLIO */
	* Em 1970 não é investigada a condição no domicílio.

	recode v025 (9=10) (0=.) // 1 a 8 mantidos
	rename v025 cond_fam_B
	* cond_fam_B =  1 - Pessoa responsável
	*               2 - Cônjuge, companheiro(a)
	*               3 - Filho(a), enteado(a)
	*               4 - Pai, mãe, sogro(a)
	*               5 - Outro parente
	*               6 - Agregado
	*               7 - Hóspede, pensionista
	*               8 - Empregado(a) doméstico(a)
	*               9 - Parente do(a) empregado(a) doméstico(a)
	*              10 - Individual em domicílio coletivo

	/* D.3. IDADE */
	gen idade = v027       if v026 == 3 | v026 == 4
	lab var idade "idade em anos"
	replace idade = 0      if v026 == 1 | v026 == 2
	gen idade_meses = v027 if v026 == 1 | v026 == 2
	lab var idade_meses "idade em meses p/ < 1 ano"
	drop v027

	recode v026 (0=.) (1 3 = 0) (2 4 = 1)
	rename v026 idade_presumida
	* idade_presumida = 0 - não
	*                   1 - sim

	/* D.4. COR OU RAÇA */
	* Este quesito não foi investigado em 1970.

	/* D.5. RELIGIÃO */
	recode v028 (5=0) (0=.) // 1 a 4 mantidas
	rename v028 religiao_B
	* religiao_B = 0 - sem religião
	*              1 - católica
	*              2 - evangélica
	*              3 - espírita
	*              4 - outra

	/* D.6. DEFICIÊNCIAS FÍSICA E MENTAL */
	* Este quesito não foi investigado em 1970.

	/* D.7. NATURALIDADE E MIGRAÇÃO */

	*** Condição de migrante
	* Este quesito não foi investigado em 1970.
	* As questões sobre migração foram aplicadas a quem não nasceu no município onde mora.

	*** Nacionalidade e naturalidade
	gen nasceu_mun = 0
	replace nasceu_mun = 1 if v031 == . // NO DICIONARIO, v031 e v032 (tempo de residencia na UF e no municipio), 0 é considerado nao aplicavel. nao seria mais adequado usar o 0 & a v032?
	label var nasceu_mun "Nasceu neste município"
	* nasceu_mun = 0 - não
	*              1 - sim
	drop v024

	rename v029 nacionalidade
	* nacionalidade = 0 - brasileiro nato
	*                 1 - brasileiro naturalizado
	*                 2 - estrangeiro

	gen UF_nascim = v030 if v030 < 30
	recode UF_nascim (0=.) // Brasileiro, UF não especificada.
	* A situação acima não apareceu no estado do Rio de Janeiro!
	recode UF_nascim (1=11) (2=12) (3=13) (4=14) (5=15) (6=16) (7=21) (8=22) (9=23) ///
					 (10=24) (11=25) (12=26) (13=27) (14=26) (15=28) (16=29) (17=31) (18=32) ///
					 (19=33) (21=35) (22=41) (23=42) (24=43) (25=51) (26=52) (27=53)
	label var UF_nascim "UF de nascimento"
	* UF_nascim = 11-53 UF de nascimento especificada

	gen nasceu_UF = 0
	replace nasceu_UF = 1 if UF_nascim == UF
	label var nasceu_UF "Nasceu nesta UF"

	gen pais_nascim = v030 if v030 >= 30 & v030<99
	replace pais_nascim = 58 if pais_nascim==57
	label var pais_nascim "País de nascimento"
	* pais_nascim = 30-98 país estrangeiro especificado
	* As duas Alemanhas estão com mesmo código
	drop v030

	*** Última migração
	* Participação na frente de seca é avaliada simultaneamente com tempo de moradia na UF
	* atual. Ignoramos esta informação que só é registrada em 1970 e parece afetar poucos
	* indivíduos.
	
	* tempo de moradia existe somente para quem nao nasceu no municipio; nao ha como separar
	* quem nasceu e sempre morou de quem nasceu mas ja morou em outro lugar, como ocorre
	* em outros censos; para quem nao nasceu no municipio mas nasceu no estado em que reside
	* atualmente, o tempo de moradia na UF é a propria idade.
	recode v031 (9 0 = .)
	replace v031 = v031 - 1
	rename v031 t_mor_UF_70
	* t_mor_UF_70 = 0 - menos de 1 ano
	*               1 - 1 ano
	*               2 - 2 anos
	*               3 - 3 anos
	*               4 - 4 anos
	*               5 - 5 anos
	*               6 - de 6 a 10 anos
	*               7 - de 11 anos e mais

	recode v032 (0 9 = .)
	replace v032 = v032 - 1
	rename v032 t_mor_mun_70
	* t_mor_mun_70 = 0 - menos de 1 ano
	*                1 - 1 ano
	*                2 - 2 anos
	*                3 - 3 anos
	*                4 - 4 anos
	*                5 - 5 anos
	*                6 - de 6 a 10 anos
	*                7 - de 11 anos e mais
	
	lab var t_mor_UF_70 "tempo de moradia na UF - grupos de 1970"
	lab var t_mor_mun_70 "tempo de moradia no município - grupos de 1970"

	* Em 1970, não foi pesquisado o MUNICIPIO
	gen UF_mor_ant = v033 if v033 < 30
	recode UF_mor_ant (0=.) // residiu no Brasil, UF não especificada
	recode UF_mor_ant (1=11) (2=12) (3=13) (4=14) (5=15) (6=16) (7=21) (8=22) (9=23) ///
					  (10=24) (11=25) (12=26) (13=27) (14=26) (15=28) (16=29) (17=31) (18=32) ///
					  (19=33) (21=35) (22=41) (23=42) (24=43) (25=51) (26=52) (27=53) 
	label var UF_mor_ant "UF onde morava anteriormente (se migrou nos últ 10 anos)"
	* UF_mor_ant = 11-53 código da UF em que morava

	gen pais_mor_ant = v033 if v033 >= 30 & v033<99
	replace pais_mor_ant = . if v033 < 30 // residia no Brasil anteriormente
	replace pais_mor_ant = 58 if pais_mor_ant ==57	// juntando Alemanhas
	replace pais_mor_ant = 84 if pais_mor_ant ==85	// juntando Chinas
	label var pais_mor_ant "País onde morava anteriormente (se migrou nos últ 10 anos)"
	* pais_mor_ant = 30-98 país estrangeiro especificado
	drop v033

	recode v034 (2 8 9 = 0) (1=1) (else=.)
	rename v034	sit_mun_ant
	* sit_mun_ant = 1 zona urbana
	*               0 zona rural

	*** Onde morava há 5 anos:
	* Este quesito não foi investigado em 1970.

	/* D.8. EDUCAÇÃO */

	recode v035 (0=.) (2=0) // (1=1)
	rename v035 alfabetizado
	* alfabetizado = 0 - não
	*                1 - sim

	recode v036 (0=.) (2=0) // (1=1)
	rename v036 freq_escola
	lab var freq_escola "frequenta escola"
	* freq_escola = 0 - não
	*               1 - sim

	gen anos_estudo = 0             if (idade >= 5) & (v038 == 5)
	replace anos_estudo = 0         if (v037 == 9) // alfabetização de adultos
	replace anos_estudo = v037 - 1  if (v038 == 1) & (v037 >= 1) & (v037 <= 5) // elementar
	replace anos_estudo = 3         if (v038 == 1) & (v037 == 6) & v039==99	// não concluiu nenhum curso
	replace anos_estudo = 4         if (v038 == 1) & (v037 == 6) & anos_estudo==.
	replace anos_estudo = 4         if (v037 == 7) & (v038 == 1) // admissão
	replace anos_estudo = 4         if (v037 == 8) & (v038 == 2) // artigo 99, médio 1o ciclo
	replace anos_estudo = v037 + 3  if (v038 == 2) & (v037 >= 1) & (v037 <= 5) // méd 1o ciclo
	replace anos_estudo = 7         if (v038 == 2) & (v037 == 6) & v039<30	// concluiu apenas elementar
	replace anos_estudo = 8         if (v038 == 2) & (v037 == 6) & anos_estudo==. 
	replace anos_estudo = 8         if (v037 == 8) & (v038 == 3) // artigo 99, médio 2o ciclo
	replace anos_estudo = v037 + 7  if (v038 == 3) & (v037 >= 1) & (v037 <= 4) // méd 2o ciclo
	replace anos_estudo = 10        if (v038 == 3) & (v037 >= 5) & (v037 <= 6) & v039<50	// nao concluiu 2o.grau
	replace anos_estudo = 11        if (v038 == 3) & (v037 >= 5) & (v037 <= 6) & anos_estudo==.
	replace anos_estudo = 11        if (v037 == 7 & v038 == 3) // vestibular
	replace anos_estudo = v037 + 10 if (v038 == 4) & (v037 >= 1) & (v037 <= 6) // superior

	drop v037 v038
	lab var anos_estudo "anos de escolaridade"
	
	recode v039 (0 98 99 = .)	///
		(10/48 50/67 = .) ///
		(72 73 75/78 80 83 84 = 3) ///
		(85 86 89 90 92 93 96 = 4) ///
		(79 87 88 94 = 5) ///
		(71 = 6) ///
		(70 74 81 82 95 = 7) ///
		(91 = 8)	///
		(97 = 9), g(cursos_c1)
	lab var cursos_c1 "curso superior concluído"
	* cursos_c1	=	3	ciências humanas
	*				4	ciências biológicas
	*				5	ciências exatas
	*				6	ciências agrárias
	*				7	ciências sociais
	*				8	militar
	*				9	outros cursos

	recode v039 (0 98 99 = .)	///
		(10/67 = .)	///
		(80 = 1)	///
		(73 75/78 84 = 2)	///
		(70 74 81/83 93 95 = 3)	///
		(79 88 94 = 4)	///
		(72 87 = 5)	///
		(71 96 = 6)	///
		(85 86 89 90 92 = 7)	///
		(91 = 8)	///
		(97 = 9), g(cursos_c2)
	lab var cursos_c2 "curso superior concluído - CONCLA"
	* cursos_c2 =	1	Educação
	*				2	Artes, Humanidades e Letras
	*				3	Ciências Sociais, Administração e Direito
	*				4	Ciências, Matemática e Computação
	*				5	Engenharia, Produção e Construção
	*				6	Agricultura e Veterinária
	*				7	Saúde e Bem-Estar Social    
	*				8	Militar
	*				9	Outros

	rename v039 curso_concl
	
	recode v042 (2=1) (3=0) (else=.), g(mun_escola)
	replace mun_escola = . if freq_escola~=1
	lab var mun_escola "frequenta escola no município de residência"
	* mun_escola 	= 1 - sim
	*				= 0 - não


	/* D.9. SITUAÇÃO CONJUGAL */
	recode v040 (0=.)
	rename v040 estado_conj
	* estado_conj = 1 casamento civil e religioso
	*               2 só casamento civil
	*               3 só casamento religioso
	*               4 união consensual
	*               5 solteiro
	*               6 separado(a)
	*               7 desquitado(a)/separado(a) judicialmente
	*               8 divorciado(a)
	*               9 viúvo(a)
	
	gen estado_conj_B = estado_conj
	recode estado_conj_B (7 8 9 = 6)
	label var estado_conj_B "estado conjugal B - mais agregado"
	* estado_conj_B = 1 casamento civil e religioso
	*                 2 só casamento civil
	*                 3 só casamento religioso
	*                 4 união consensual
	*                 5 solteiro
	*                 6 outros: separado(a) OU desquitado(a)/separado(a) judicialmente OU divorciado(a) OU viúvo(a)

	/* D.10. RENDA E ATIVIDADE ECONÔMICA */

	recode v041 (9999 = .)
	rename v041 rend_total
	by id_dom num_fam: egen rend_fam = total(rend_total*(cond_fam_B <= 6))
	lab var rend_fam "renda familiar"
	
	recode v043 (0=8) (1=6) (2=3) (3=4) (4=7) (5=5) (6=9) (7=1) (nonmissing = .)
	replace v043 = 2 if v044 == 924 & v045 == 933 // duas condições dizem o mesmo:
												  // procura trabalho pela 1a vez
	rename v043 cond_ativB
	* cond_ativB = 1 trabalhou nos últimos 12 meses ou procurando trabalho - já trabalhou
	*             2 procurando trabalho - nunca trabalhou
	*             3 aposentado ou pensionista
	*             4 vive de renda
	*             5 detento
	*             6 estudante
	*             7 doente ou inválido
	*             8 afazeres domésticos
	*             9 sem ocupação

	recode cond_ativB (2=1) (3/8 =0), copy g(pea)
	lab var pea "população economicamente ativa"
	* pea	= 1 economicamente ativo
	*         0 inativo
	
	
	gen v044b = v044
	replace v044b = . if v044b == 924
	* 924 significa "Procurando trabalho pela primeira vez"

	g ocup_hab = v044
	lab var ocup_hab "ocupação habitual"
	
	recode v044b (11/45 = 1) (101/198 = 2) (211/245 = 3) (311/341 = 4) (411/586 = 5) ///
				 (611/635 = 6) (711/761 = 7) (762=5) (763/777 = 7) (811/834 = 8) ///
				 (841/847 = 9) (911/923 925 = 10) (else=.)
	rename v044b grp_ocup_hab
	label var grp_ocup_hab "Grupo da ocupação habitual"
	* grp_ocup_hab =  1 administrativas
	*                 2 técnicas, científicas, artísticas e assemelhadas
	*                 3 agropecuária e da produção extrativa vegetal e animal
	*                 4 produção extrativa mineral
	*                 5 indústrias de transformação e construção civil
	*                 6 comércio e atividades auxiliares
	*                 7 transportes e comunicações
	*                 8 prestação de serviços
	*                 9 defesa nacional e segurança pública
	*                10 outras ocupações, ocupações mal definidas ou não declaradas
	drop v044

	gen v045b = v045
	rename v045 ativ_hab
	lab var ativ_hab "atividade habitual"

	replace v045b = . if v045b == 933 	// 933 significa "Procurando trabalho pela primeira vez"
	recode v045b (111/222 = 1) (311/334 = 2) (341 342 = 3) (301/306 = 4) (351 352 = 4) ///
				 (411/422 = 5) (424 = 5) (611/620 = 6) (423 921 922 924 926 927 928 = 7) ///
				 (511/518 = 8) (711/721 = 9) (923 925 = 9) (811/827 = 10) (911/916 = 11) ///
				 (931 932 934 = 11) (else = .)
	rename v045b set_ativ_hab
	label var set_ativ_hab "Setor de atividade na ocupação habitual"
	* set_ativ_hab =  1 atividades agropecuárias, de extração vegetal e pesca
	*                 2 indústria de transformação
	*                 3 indústria da construção civil
	*                 4 outras atividades industriais (extração mineral e serviços
	*                   industriais de utilidade pública)
	*                 5 comércio de mercadorias
	*                 6 transporte e comunicação
	*                 7 serviços auxiliares da atividade econômica (técnico-profissionais
	*                   e auxiliares das atividades econômicas)
	*                 8 prestação de serviços (alojamento e alimentação, reparação e
	*                   conservação, pessoais, domiciliares e diversões)
	*                 9 social(comunitárias, médicas, odontológicas e ensino)
	*                10 administração pública, defesa nacional e segurança pública
	*                11 outras atividades (instituições de crédito, seguros e
	*                   capitalização, comércio e administração de imóveis e valores
	*                   mobiliários, organizações internacionais e representações
	*                   estrangeiras, atividades não compreendidas nos demais ramos e
	*                   atividades mal definidas ou não declaradas)

	* posicao na ocupacao
	recode v046 (0=.) (1 2 =4) (3 = 5) (4 =1) (5 =6) (6 =0), g(pos_ocup_habB)
	replace pos_ocup_habB = . if ocup_hab ==924 | ocup_hab==925 		// exclui 'procurando trabalho pela 1a. vez' e 'sem declaracao de ocupacao'
	replace pos_ocup_habB = 2 if ocup_hab ==813 & pos_ocup_habB==4					// empregados domésticos
	replace pos_ocup_habB = 3 if ocup_hab ==813 & pos_ocup_habB==5					// empregados domésticos
	drop v046 
	lab var pos_ocup_habB "posição na ocupação B"
	* pos_ocup_habB = 0 sem remuneração
	*                 1 parceiro ou meeiro 
	*                 2 trabalhador doméstico - empregado
	*                 3 trabalhador doméstico - autônomo ou conta-própria
	*                 4 empregado
	*                 5 autônomo ou conta-própria
	*                 6 empregador

	recode v047 (3 =2) (2 =3) (5 =4) (0 6=.)
	rename v047 trab_semana
	* trab_semana = 1 - só ocupação habitual
	*                 2 - habitual e outra
	*                 3 - só outra
	*                 4 - outros

	gen hrs_oc_habB = v048 - 4 if (v048 >= 5 & v048 <= 8)
	lab var hrs_oc_habB "horas trabalhadas p/semana B - ocup hab - exclusive agropec"
	* hrs_oc_habB  = 1 - menos de 15 horas
	*                2 - de 15 a 39
	*                3 - de 40 a 49
	*                4 - 50 ou mais
	drop v048

	gen hrs_oc_habC = hrs_oc_habB
	recode hrs_oc_habC (4=3) // 1 a 3 mantidos
	lab var hrs_oc_habC "horas trabalhadas p/semana C - ocup hab - exclusive agropec"
	* hrs_oc_habC  = 1 - menos de 15 horas
	*                2 - de 15 a 39 horas
	*                3 - 40 horas ou mais

	drop v049	// tempo que procura trabalho
	
	recode v042 (2=1) (3=0) (else=.)
	replace v042 = . if grp_ocup_hab==.
	rename v042 mun_trab
	lab var mun_trab "trabalha no município em que reside"
	* mun_trab 	= 1 - sim
	*			= 0 - não

	/* DEFLACIONANDO RENDAS: julho/2022 */
	g double deflator = 0.0000000000000711935
	g conversor = 2750000000000
	
	lab var deflator "deflator de rendimentos - referência: julho/2022"
	lab var conversor "conversor de moedas"

	foreach var in rend_total rend_fam {
		g `var'_def = (`var'/conversor)/deflator
		lab var `var'_def "`var' deflacionada"
	}

	/* D.11. FECUNDIDADE */

	egen filhos_tot = rowtotal(v050 v051), miss
	replace filhos_tot = . if v050==99 | v051==9
	lab var filhos_tot "total de filhos tidos"
	
	recode v050 (99=.)
	rename v050	filhos_nasc_vivos

	recode v051 (9=.)
	rename v051 filhos_nasc_mortos

	drop v052

	recode v053 (99=.)
	rename v053 filhos_vivos
}

/* D.12. PESO */
rename v054	peso_pess
by id_dom: gen peso_dom = peso_pess[1]
lab var peso_dom "peso do domicílio"

drop  v011 v022

end

program define compat_censo80

/* A. ANO */
* Essa variável é definida antes de chamar este programa.

/* B. IDENTIFICAÇÃO */

/* B.1. IDENTIFICAÇÃO */
rename v2 UF
gen regiao = int(UF/10)
lab var regiao "região geográfica"

egen id_muni = concat(UF v5)
lab var id_muni "município"
drop v5
rename v6 distrito

g id_dom = sum(v503<=1)
tostring id_dom, replace
lab var id_dom "identificação do domicílio"
bys id_muni distrito id_dom: gen num_fam = sum(v504<=1)
lab var num_fam "número da família"

sort id_muni distrito id_dom num_fam, stable

/* IDENTIFICA PARA QUAIS TIPOS DE REGISTRO DEVE SE FAZER A COMPATIBILIZACAO */
loc d = 0
loc p = 0
foreach n of global x {
	if "`n'" == "dom" loc d = 1
	if "`n'" == "pes" loc p = 1
}

if `d'==1 {
	/* B.2. VARIÁVEIS DE NÚMERO DE PESSOAS */
	* gerando totais de homens e mulheres nos domicílios
	* v501 == 1 representa sexo masculino; == 3 feminino
	by id_muni distrito id_dom: egen n_homem_dom = total(v501==1)
	by id_muni distrito id_dom: egen n_mulher_dom = total(v501==3)
	egen n_pes_dom = rowtotal(n_homem_dom  n_mulher_dom)

	lab var n_homem_dom "número de homens no domicílio"
	lab var n_mulher_dom "número de mulheres no domicílio"
	lab var n_pes_dom "número de pessoas no domicílio"


	/* C. VARIÁVEIS DE DOMICÍLIO*/

	/* C.1. SITUAÇÃO */
	recode v198 (3=2) (5=3) (7=4) // (1=1)
	rename v198 sit_setor_B
	lab var sit_setor_B "situação do domicílio - agregado"
	* sit_setor_B = 1 - Vila ou cidade
	*               2 - Urbana isolada
	*               3 - Aglomerado rural
	*               4 - Rural exclusive os aglomerados

	recode v598 (0 =1) (1 = 2)
	rename v598 sit_setor_C
	lab var  sit_setor_C "situação do domicílio C - urbano/rural"
	* sit_setor_C = 1 - Urbana
	*               0 - Rural

	/* C.2. ESPÉCIE */
	recode v201 (1 = 0) (3 = 1) (5 7 = 2)
	rename v201 especie
	* especie = 0 - particular permanente
	*           1 - particular improvisado
	*           2 - coletivo

	/* C.3.	MATERIAL DAS PAREDES */
	recode v203 (2 =1) (4 =2) (6 =3) (7 =4) (8 =5) (0 = 6) (9 =.)
	rename v203 paredes
	* paredes 	= 1   Alvenaria
	*        	= 2   Madeira aparelhada
	*        	= 3   Taipa não revestida
	*       	= 4   Material aproveitado
	*   	    	= 5   Palha
	*	        = 6   Outro

	gen paredes_B = paredes
	recode paredes_B (6=5)
	* paredes_B	= 1   Alvenaria
	*        	= 2   Madeira aparelhada
	*        	= 3   Taipa não revestida
	*       	= 4   Material aproveitado
	*   	    = 5   Outro

	/* C.4.	MATERIAL DA COBERTURA */
	recode v205 (0 =8) (9 =.)
	rename v205 cobertura
	*cobertura = 1 laje de concreto
	*		   = 2 telha de barro
	*		   = 3 telha de amianto
	*		   = 4 zinco
	*		   = 5 madeira aparelhada
	*		   = 6 palha
	*		   = 7 material aproveitado
	*		   = 8 outro material

	/* C.5. TIPO */
	recode v202 (3=2) // (1=1)
	rename v202 tipo_dom_B
	* tipo_dom_B = 1 - casa
	*              2 - apartamento (ou cômodo)

	/* C.6. CONDIÇÃO DE OCUPAÇÃO E ALUGUEL */
	gen dom_pago = 1 if v209==1
	replace dom_pago = 0 if v209==3
	lab var dom_pago "dummy para domicílio próprio já pago"
	* dom_pago = 0 - Domicílio próprio em aquisição
	*            1 - Domicílio próprio já pago

	recode v209 (3=1) (5=2) (6=3) (7=4) (0=5) (9=.) // (1=1)
	rename v209 cond_ocup
	* cond_ocup = 1 - próprio
	*             2 - alugado
	*             3 - cedido por empregador
	*             4 - cedido de outra forma
	*             5 - outra condição

	recode cond_ocup (4 = 3) (5 = 4), copy g(cond_ocup_B)
	lab var cond_ocup_B "condição de ocupação B"
	* cond_ocup = 1 - próprio
	*             2 - alugado
	*             3 - cedido 
	*             4 - outra condição

	recode v602 (0 999999 = .)
	rename v602 aluguel

	/* C.7 ABASTECIMENTO DE ÁGUA */
	recode v206 (6=2) (7=4) (0=5) (9=.) // (1=1) (3=3) (5=5) 
	rename v206 abast_agua
	* abast_agua = 1 - rede geral com canalização interna
	*              2 - rede geral sem canalização interna
	*              3 - poço ou nascente com canalização interna
	*              4 - poço ou nascente sem canalização interna
	*              5 - outra forma

	/* C.8. INSTALAÇÕES SANITÁRIAS */
	gen sanitario = 0 if v207 == 8
	replace sanitario = 1 if (v207 >= 0) & (v207 <= 6) // reportou tipo de escoadouro
	replace sanitario = 1 if (v208 == 1) | (v208 == 3) // reportou uso excl ou coletivo
	lab var sanitario "dummy para acesso a sanitário"
	* sanitario = 0 - não tem acesso
	*                1 - tem acesso

	recode v207 (2 = 1) (4 = 2) (6 = 3) (0 = 4) (8 9 = .)
	rename v207 tipo_esc_san
	* tipo_esc_san = 1 - Rede geral
	*                2 - Fossa séptica
	*                3 - Fossa rudimentar
	*                4 - Outro escoadouro

	recode v208 (3 8 = 0) (9 = .) // (1=1)
	rename v208 sanitario_ex
	label var sanitario_ex "acesso exclusivo a instalação sanitária"
	* sanitario_ex = 0 - não tem acesso a instalação san exclusiva
	*                1 - tem acesso a instalação sanitária exclusiva


	/* C.9. DESTINO DO LIXO */
	*Não pesquisado em 1980.


	/* C.10. ILUMINAÇÃO ELÉTRICA */
	gen medidor_el = 1 if v217 == 2
	replace medidor_el = 0 if v217 == 4
	label var medidor_el "presença de medidor de consumo de eletricidade"
	* medidor_el = 0 - não tem
	*                1 - tem

	recode v217 (2 4 = 1) (8 = 0) (9 = .)
	rename v217 ilum_eletr
	* ilum_eletr = 0 - não tem
	*              1 - tem


	/* C.11. BENS DE CONSUMO DURÁVEIS */
	gen fogao_ou_fog = 1 if (v214 == 1) | (v214 == 3) | (v214 == 5)
	replace fogao_ou_fog = 0 if v214 == 8
	label var fogao_ou_fog "fogão ou fogareiro"
	* fogao_ou_fog = 0 - não tem
	*                1 - tem

	recode v214 (3=1) (5 8 = 0) (9=.) // (1=1)
	rename v214 fogao
	label var fogao "fogao"
	* fogao = 0 - não tem
	*         1 - tem

	recode v215 (2=1) (3=2) (4=3) (5/7 = 4) (8=0) (9=.) // (1=1)
	rename v215 comb_fogao
	* comb_fogao = 1 - gás
	*                2 - lenha
	*                3 - carvão
	*                4 - outro
	*                0 - não tem fogão nem fogareiro

	recode v216 (8=0) (9=.) // (1=1) 
	rename v216 telefone
	* telefone = 0 - não tem
	*            1 - tem

	recode v218 (8=0) (9=.) // (1=1)
	rename v218 radio
	* radio = 0 - não tem
	*         1 - tem

	recode v219 (8=0) (9=.) // (1=1)
	rename v219 geladeira
	* geladeira = 0 - não tem
	*             1 - tem


	gen tv_pb = 1 if v220 == 3 | v220 == 5
	replace tv_pb = 0 if v220 == 1 | v220 == 8
	label var tv_pb "televisao em preto e branco"
	recode v220 (3=1) (5 8 = 0) (9=.) // (1=1)
	rename v220 tv_cores
	label var tv_cores "televisao em cores"
	gen televisao = 0 if tv_pb == 0 & tv_cores == 0
	replace televisao = 1 if (tv_pb == 1) | (tv_cores == 1)
	lab var televisao "televisão"
	* televisao, tv_pb, tv_cores = 0 - não tem
	*                              1 - tem

	gen automov_part = 1 if v221 == 1
	replace automov_part = 0 if (v221 == 3) | (v221 == 8)
	lab var automov_part "automóvel particular"

	recode v221 (3=1) (8=0) (9=.) // (1=1)
	rename v221 automovel
	* automovel, automov_part = 0 - não tem
	*                           1 - tem

	/* C.12. NÚMERO DE CÔMODOS */
	recode v212 v213 (99=.)
	rename v212 tot_comodos
	rename v213 tot_dorm

	/* C.13. RENDA DOMICILIAR */
	* Ver parte D.10.

	/* C.14. PESO AMOSTRAL */
	rename v603 peso_dom

	/* Variáveis de domicílio não utilizadas */
	drop v204 v211 

	
	/* DEFLACIONANDO RENDAS: julho/2022 */
	
	g double deflator = 0.0000000000015139096
	g double conversor = 2750000000000
	lab var deflator "deflator de rendimentos - referência: julho/2022"
	lab var conversor "conversor de moedas"

	g aluguel_def = (aluguel/conversor)/deflator
	lab var aluguel_def "aluguel deflacionada"
}


if `p'==1 {

	/* número de pessoas na família */
	by id_muni distrito id_dom num_fam: egen n_homem_fam = total(v501==1)
	by id_muni distrito id_dom num_fam: egen n_mulher_fam = total(v501==3)
	egen n_pes_fam = rowtotal(n_homem_fam n_mulher_fam)

	lab var n_homem_fam "número de homens na família"
	lab var n_mulher_fam "número de mulheres na família"
	lab var n_pes_fam "número de pessoas na família"

	/* D. OUTRAS VARIÁVEIS PESSOA*/

	rename v500 ordem

	/* D.1. SEXO */

	recode v501 (3=0) // (1=1)
	rename v501 sexo
	* sexo = 0 - feminino
	*      = 1 - masculino

	/* D.2. CONDIÇÃO NA FAMÍLIA E NO DOMICÍLIO */
	recode v503 (0=10), g(cond_dom_B)
	lab var cond_dom_B "Relação com o chefe do domicílio"
	* cond_dom_B =  1 - Pessoa responsável
	*               2 - Cônjuge, companheiro(a)
	*               3 - Filho(a), enteado(a)
	*               4 - Pai, mãe, sogro(a)
	*               5 - Genro, nora, outro parente
	*               6 - Agregado
	*               7 - Hóspede, pensionista
	*               8 - Empregado(a) doméstico(a)
	*               9 - Parente do(a) empregado(a) doméstico(a)
	*              10 - Individual em domicílio coletivo

	recode v504 (0=10), g(cond_fam_B)
	lab var cond_fam_B "Relação com o chefe da família"
	* cond_fam_B =  1 - Pessoa responsável
	*               2 - Cônjuge, companheiro(a)
	*               3 - Filho(a), enteado(a)
	*               4 - Pai, mãe, sogro(a)
	*               5 - Genro, nora, outro parente
	*               6 - Agregado
	*               7 - Hóspede, pensionista
	*               8 - Empregado(a) doméstico(a)
	*               9 - Parente do(a) empregado(a) doméstico(a)
	*              10 - Individual em domicílio coletivo


	/* D.3. IDADE */
	replace v605=. if v606~=0
	rename v605 idade_meses
	recode v606 (999=.)
	rename v606 idade

	/* D.4. COR OU RAÇA */
	recode v509 (2 = 1) (4 = 2) (6 = 3) (8 = 4) (9 = .)
	rename v509 racaB
	* racaB = 1 - branca
	*                2 - preta
	*                3 - amarela
	*                4 - parda


	/* D.5. RELIGIÃO */
	replace v508=. if v508==9
	rename v508 religiao
	* religiao = 0 - sem religião
	*            1 - católica
	*            2 - evangélica tradicional
	*            3 - evangélica pentecostal
	*            4 - espírita kardecista
	*            5 - espírita afro-brasileira
	*            6 - religiões orientais
	*            7 - judaica/israelita
	*            8 - outras religiões

	gen religiao_A = religiao
	recode religiao_A (3 = 2) (4 = 3) (5 = 4) (6 = 5) (7 = 6) (8 = 7)
	lab var religiao_A "religião A - mais agregada"
	* religiao_A = 0 - sem religião
	*            1 - católica
	*            2 - evangélica
	*            3 - espírita kardecista
	*            4 - espírita afro-brasileira
	*            5 - religiões orientais
	*            6 - judaica/israelita
	*            7 - outras religiões

	gen religiao_B = religiao
	recode religiao_B (3=2) (4 5 = 3) (6/8 = 4)
	lab var religiao_B "religião B - mais agregada"
	* religiao_B = 0 - sem religião
	*              1 - católica
	*              2 - evangélica
	*              3 - espírita
	*              4 - outra

	/* D.6. DEFICIÊNCIAS FÍSICA E MENTAL */
	* Este quesito não foi investigado em 1980.


	/* D.7. NATURALIDADE E MIGRAÇÃO */
	*** Condição de migrante
	gen sempre_morou = 0
	replace sempre_morou = 1 if v515 == 8
	label var sempre_morou "Sempre morou neste município"
	* sempre_morou = 0 - não
	*                1 - sim

	recode v514 (2 = 0) (4 = 1) (6 = 2) (9 = .)
	rename v514 onde_morou
	* onde_morou   = 0 só na zona urbana
	*                1 só na zona rural
	*                2 nas zonas urbana e rural

	*** Nacionalidade e naturalidade
	recode v511 (2 = 0) (4 = 1) (6 = 2)
	rename v511 nacionalidade
	* nacionalidade = 0 - brasileiro nato
	*                 1 - brasileiro naturalizado
	*                 2 - estrangeiro

	recode v512 (1=11) (2=12) (3=13) (4=14) (5=15) (6=16) (7=21) (8=22) (9=23) ///
	 (10=24) (11=25) (12=26) (13=27) (14=26) (15=28) (16=29) (17=31) (18=32) ///
	 (19=33) (20=35) (21=41) (22=42) (23=43) (24=50) (25=51) (26=52) (27=53) (29=999) ///
	 (else=.), g(nasceu_UF) 
	replace nasceu_UF = 1 if nasceu_UF== UF
	replace nasceu_UF = 0 if nasceu_UF>1 & nasceu_UF~=999
	replace nasceu_UF=. if nasceu_UF==999
	label var nasceu_UF "Nasceu nesta UF"
	* nasceu_UF = 0 não
	*             1 sim

	gen UF_nascim = v512 if nasceu_UF==0
	replace UF_nascim = . if v512 >= 29
	recode UF_nascim (1=11) (2=12) (3=13) (4=14) (5=15) (6=16) (7=21) (8=22) (9=23) ///
	 (10=24) (11=25) (12=26) (13=27) (14=26) (15=28) (16=29) (17=31) (18=32) ///
	 (19=33) (20=35) (21=41) (22=42) (23=43) (24=50) (25=51) (26=52) (27=53)
	lab var UF_nascim "UF de nascimento"
	* UF_nascim = 11-53 UF de nascimento especificada

	gen pais_nascim = v512
	replace pais_nascim = . if v512 < 30 | v512==99
	recode pais_nascim (57 = 58) (82 84 85 = 83) (83=82 )	(86 87 =84 ) ///
		(88=86 ) (89=87 ) (90=88 ) (91=89 ) (92=90 ) (93=91 ) ///
		(94=92 ) (95=93 ) (96=94 ) (97=95) (98=96)
	* pais_nascim = 30-98 país estrangeiro especificado
	* 58 = Alemanha
	* 83 = Africa - outros  
	* 82 = Egito	
	* 84 = China 
	* 86 = Coréia 
	* 87 = Índia 
	* 88 = Israel 
	* 89 = Japão 
	* 90 = Líbano 
	* 91 = Paquistão 
	* 92 = Síria 
	* 93 = Turquia 
	* 94 = Ásia - outros 
	* 95 = Australia
	* 96 = Oceania
	lab var pais_nascim "país de nascimento - codigos 1970"
	drop v512
	
	recode v513 (8 = 0)		// 1=1
	rename v513 nasceu_mun
	label var nasceu_mun "Nasceu neste município"
	* nasceu_mun = 0 - não
	*              1 - sim

	*** Última migração

	* De 1980 em diante, podemos montar a variavel de tempo de moradia incluindo
	* pessoas que nasceram mas nem sempre moraram no municipio em que residem
	
	recode v517 (8 9=.)
	rename v517 t_mor_mun_80
	* t_mor_mun_80 =  0 - menos de 1 ano
	*                 1 - 1 ano
	*                 2 - 2 anos
	*                 3 - 3 anos
	*                 4 - 4 anos
	*                 5 - 5 anos
	*                 6 - 6 a 9 anos
	*                 7 - 10 anos e mais

	recode v516 (9=.)
	replace v516 = idade if (v516 == 8) & (idade <= 5)
	replace v516 = 6     if (v516 == 8) & (idade <= 9) // irrelevante: & (idade > 5) // NAO SERIA NECESSARIO COMPLEMENTAR COM >5 E <=9?
	replace v516 = 7     if (v516 == 8) & (idade != .) // irrelevante: & (idade > 9) // NAO SERIA NECESSARIO COMPLEMENTAR COM >9 E !=.?
	replace v516 = . if v516==8 // AQUI SERIA TER NASCIDO NA UF MAS NAO TER INFO DE IDADE? NAO SERIA MELHOR COLOCAR (v516 == 8) & (idade == .)?
	rename v516 t_mor_UF_80
	
	* t_mor_UF_80 =  0 - menos de 1 ano
	*                1 - 1 ano
	*                2 - 2 anos
	*                3 - 3 anos
	*                4 - 4 anos
	*                5 - 5 anos
	*                6 - 6 a 9 anos
	*                7 - 10 anos e mais

	* Em 1980, não há o PAÍS onde morava anteriormente - para quem migrou nos últimos 10 anos:
	gen UF_mor_ant = int(v518/100000)
	recode UF_mor_ant (0 54 80 99=.)
	label var UF_mor_ant "UF onde morava anteriormente (se migrou nos últ 10 anos)"
	* UF_mor_ant = 11-53 código da UF em que morava

	recode v518 (0 5400000/max =.)
	rename v518 mun_mor_ant
	label var mun_mor_ant "Município onde morava ant (se migrou nos últ 10 anos)"

	recode v515 (3 = 0) (8 9 = .) //  (1 = 1)
	rename v515 sit_mun_ant
	* sit_mun_ant = 1 zona urbana
	*               0 zona rural

	*** Onde morava há 5 anos:
	* Este quesito não foi investigado em 1980.

	/* D.8. EDUCAÇÃO */

	recode v519 (2=1) (4 6 = 0) (9 = .)
	rename v519 alfabetizado
	* alfabetizado = 0 - não
	*                1 - sim

	gen freq_escola = 0     if idade >= 5
	replace freq_escola = 1 if (idade >= 5) & (v521 ~= 0) & (v521 ~= 9) // frequenta curso seriado
	* frequenta curso não seriado, exceto pre-escola, supletivo por rádio ou TV e pre-vestibular:
	replace freq_escola = 1 if (idade >= 5) & ((v522>=2 & v522<=4) | v522==8)
	lab var freq_escola "frequenta escola"

	gen freq_escolaB = freq_escola
	replace freq_escolaB = 1 if v522 == 1 // inclui pré-escola
	lab var freq_escolaB "frequenta escola - inclui pre-escola"


	* Estuda no município em que reside?
	recode v527 (0 = 1) (1100007/max = 0), g(mun_escola)
	replace mun_escola = . if freq_escolaB == 0
	lab var mun_escola "frequenta escola no município de residência"
	* mun_escola 	= 1 - sim
	*				= 0 - não

	gen anos_estudoB = 0 if (idade >= 5) & (v521 == 0) & (v522 == 0) & (v523 == 0) & (v524 == 0)
	lab var anos_estudoB "anos de estudo B (associado à série atualmente cursada)"

	* Frequentando cursos não seriados:
	replace anos_estudoB = 0 if (v522 == 1) | (v522 == 2) // pré-escolar, alfabetização de adultos
	* Na situaçao abaixo, supletivo de 1o grau, IBGE tem optado por considerar nível "indefinido"
	*replace anos_estudoB = 0 if (v522 == 3) | (v522 == 5) // suplet 1o grau
	replace anos_estudoB = 8 if (v522 == 4) | (v522 == 6) // suplet 2o grau
	replace anos_estudoB = 11 if (v522 == 7)              // vestibular
	replace anos_estudoB = 15 if (v522 == 8)              // mestrado ou doutorado

	* Frequentando cursos seriados:
	replace anos_estudoB = v520 - 1  if (v520 >= 1) & (v520 <= 4) & (v521 == 1)                                      // primário
	replace anos_estudoB = 3         if (v520 >= 5) & (v520 <= 8) & (v521 == 1)                                      // não terminou primário, não pode receber 4 anos
	replace anos_estudoB = v520 + 3  if (v520 >= 1) & (v520 <= 4) & (v521 == 2)                                      // ginásio
	replace anos_estudoB = 7         if (v520 >= 5) & (v520 <= 8) & (v521 == 2)                                      // não terminou ginásio, não pode receber 8 anos
	replace anos_estudoB = v520 - 1  if (v520 >= 1) & (v520 <= 8) & ((v521 == 3) | (v521 == 6))                      // 1o grau reg ou supletivo
	replace anos_estudoB = v520 + 7  if (v520 >= 1) & (v520 <= 3) & (v521 == 5)                                      // colegial
	replace anos_estudoB = 10        if (v520 >= 4) & (v520 <= 8) & (v521 == 5)                                      // não terminou colegial, não pode receber 11 anos
	replace anos_estudoB = v520 + 7  if (freq_escola == 1) & (v520 >= 1) & (v520 <= 3) & ((v521 == 4) | (v521 == 7)) // 2o grau reg ou supletivo
	replace anos_estudoB = 10        if (freq_escola == 1) & (v520 >= 4) & (v520 <= 8) & ((v521 == 4) | (v521 == 7)) // não terminou médio, não pode receber 11 anos
	replace anos_estudoB = v520 + 10 if (freq_escola == 1) & (v520 >= 1) & (v520 <= 5) & (v521 == 8)                 // superior
	replace anos_estudoB = 15        if (freq_escola == 1) & (v520 >= 6) & (v520 <= 8) & (v521 == 8)                 // atribuo no máx 15 anos p/ superior incompleto

	* Não frequentando - informação de curso concluído:
	replace anos_estudoB = 0         if (v524 == 1)                                                                  // alfabetização de adultos
	replace anos_estudoB = v523      if (v523 >= 1) & (v523 <= 4) & (v524 == 2)                                      // primário
	replace anos_estudoB = 4         if (v523 >= 5) & (v523 <= 8) & (v524 == 2)                                      // primário concluído vale 4 anos
	replace anos_estudoB = v523 + 4  if (v523 >= 1) & (v523 <= 4) & (v524 == 3)                                      // ginásio
	replace anos_estudoB = 8         if (v523 >= 5) & (v523 <= 8) & (v524 == 3)                                      // ginásio concluído vale 8 anos
	replace anos_estudoB = v523      if (v523 >= 1) & (v523 <= 8) & (v524 == 4)                                      // 1o grau
	replace anos_estudoB = v523 + 8  if (v523 >= 1) & (v523 <= 3) & (v524 == 5)                                      // 2o grau
	replace anos_estudoB = 11        if (v523 >= 4) & (v523 <= 8) & (v524 == 5)                                      // 2o grau concluído vale 11 anos
	replace anos_estudoB = v523 + 8  if (v523 >= 1) & (v523 <= 3) & (v524 == 6)                                      // colegial
	replace anos_estudoB = 11        if (v523 >= 4) & (v523 <= 8) & (v524 == 6)                                      // colegial concluído vale 11 anos
	replace anos_estudoB = v523 + 11 if (v523 >= 1) & (v523 <= 5) & (v524 == 7)                                      // superior
	replace anos_estudoB = 16        if (v523 >= 6) & (v523 <= 8) & (v524 == 7)                                      // superior concluído vale até 16 anos
	replace anos_estudoB = 16        if (v524 == 8)                                                                  // mestrado ou doutorado
	
	* Grupos de anos de estudo
	* para quem frequenta escola
	recode anos_estudoB (min/3 = 0) (4/7 = 1) (8/10 = 2) (11/14 = 3) (15/max = 4), g(anos_estudoC)
	replace anos_estudoC = 0 if (v522 == 3) | (v522 == 5) // suplet 1o grau
	replace anos_estudoC = . if freq_escola==0
	replace anos_estudoC = 3 if freq_escola==1 & v521==8 & anos_estudoC==4 	// superior sem conclusao

	* para quem nao frequenta escola
	replace anos_estudoC = 0 if freq_escola==0 & (v524==1 | v524==0)	// alfabetizacao de adultos/ nenhuma
	replace anos_estudoC = 0 if freq_escola==0 & v524==2 	// primario
	replace anos_estudoC = 0 if freq_escola==0 & v524==4 & (v523>=1 & v523<=3) 	// 1a-3a serie 1o.grau
	
	replace anos_estudoC = 1 if freq_escola==0 & v524==3		// ginasio/medio 1o.ciclo
	replace anos_estudoC = 1 if freq_escola==0 & v524==2 & (v525>=1 & v525<=8) 	// primario com conclusao
	replace anos_estudoC = 1 if freq_escola==0 & v524==4 & (v523>=4 & v523<=8) 	// 4a-8a serie 1o.grau

	replace anos_estudoC = 2 if freq_escola==0 & v524==3 & (v525>=11 & v525<=23) 	// ginasio/medio 1o.ciclo com conclusao
	replace anos_estudoC = 2 if freq_escola==0 & v524==4 & (v523>=4 & v523<=8) & (v525>=11 & v525<=23) 	// 4a-8a serie 1o.grau com conclusao
	replace anos_estudoC = 2 if freq_escola==0 & v524==5		// 2o.grau
	replace anos_estudoC = 2 if freq_escola==0 & v524==6		// colegial/medio 2o.ciclo

	replace anos_estudoC = 3 if freq_escola==0 & v524==5 & (v525>=24 & v525<=42) 	// 2o.grau com conclusao
	replace anos_estudoC = 3 if freq_escola==0 & v524==6 & (v525>=24 & v525<=42) 	// colegial/medio 2o.ciclo com conclusao
	replace anos_estudoC = 3 if freq_escola==0 & v524==7		// superior
	
	replace anos_estudoC = 4 if freq_escola==0 & v524==7 & (v525>=43 & v525<=85) 	// superior com conclusao
	replace anos_estudoC = 4 if freq_escola==0 & v524==8		// mestrado/doutorado

	* corrigindo usando conclusao de curso
	replace anos_estudoC = 0 if freq_escola==0 & v525==0
	replace anos_estudoC = 1 if freq_escola==0 & v525>=1 & v525<=8
	replace anos_estudoC = 2 if freq_escola==0 & v525>=10 & v525<=23
	replace anos_estudoC = 3 if freq_escola==0 & v525>=24 & v525<=42
	replace anos_estudoC = 4 if freq_escola==0 & v525>=43 & v525<=85
	lab var anos_estudoC "grupo de anos de escolaridade"
		
	* anos_estudoC = 0 – sem instrução ou menos de 3 anos de estudo (primário incompleto)
	*                1 – de 4 a 7 (fundamental/ ginásio/ 1º. Grau/ médio primeiro ciclo incompleto)
	*				 2 – de 8 a 10 (médio/ 2º. Grau/ médio segundo ciclo incompleto)
	*			 	 3 – de 11 a 14 (médio/ 2º. Grau/ médio segundo ciclo completo ou superior incompleto)
	*			 	 4 – 15 ou mais (superior completo, mestrado, doutorado)

	recode v525 (1/8 12/15 17/19 21 22 26 28 31 36/38 40 42 = .) ///
			(10 11 16 20 23/25 27 29 30 32/35 39 41 = .) ///
			(73/77 80/83 85 93 94 96 = 3) ///
			(43/49 65 86 87 = 4) ///
			(50/63 88 89 = 5) ///
			(64 66 90 = 6) ///
			(67/72 78 79 91 92 95 = 7) ///
			(84 = 8) ///
			(00 99 = .), g(cursos_c1)

	lab var cursos_c1 "curso superior concluído"
	* cursos_c1	=	3	ciências humanas
	*				4	ciências biológicas
	*				5	ciências exatas
	*				6	ciências agrárias
	*				7	ciências sociais
	*				8	militar
	*				9	outros cursos

	recode v525 (1/42 = .) ///
			(77 94 = 1) ///
			(74/76 80/85 96 = 2) ///
			(67/73 78/79 91/93 95 = 3) ///
			(43 51 52 56/63 87 89 = 4) ///
			(50 53/55 88 = 5) ///
			(64/66 90 = 6) ///
			(44/49 86 = 7) ///
			(84 = 8) ///
			(99 00 =.), g(cursos_c2) 
	lab var cursos_c2 "curso superior concluído - CONCLA"
	* cursos_c2 =	1	Educação
	*				2	Artes, Humanidades e Letras
	*				3	Ciências Sociais, Administração e Direito
	*				4	Ciências, Matemática e Computação
	*				5	Engenharia, Produção e Construção
	*				6	Agricultura e Veterinária
	*				7	Saúde e Bem-Estar Social    
	*				8	militar
	*				9	Outros

	rename v525 curso_concl
	
	drop v520 v521 v522 v523 v524


	/* D.9. SITUAÇÃO CONJUGAL */
	recode v526 (0=9) (9=.) // 1 a 8 mantidos
	rename v526 estado_conj
	* estado_conj = 1 casamento civil e religioso
	*               2 só casamento civil
	*               3 só casamento religioso
	*               4 união consensual
	*               5 solteiro
	*               6 separado(a)
	*               7 desquitado(a)/separado(a) judicialmente
	*               8 divorciado(a)
	*               9 viúvo(a)
	
	gen estado_conj_B = estado_conj
	recode estado_conj_B (7 8 9 = 6)
	label var estado_conj_B "estado conjugal B - mais agregado"
	* estado_conj_B = 1 casamento civil e religioso
	*                 2 só casamento civil
	*                 3 só casamento religioso
	*                 4 união consensual
	*                 5 solteiro
	*                 6 outros: separado(a) OU desquitado(a)/separado(a) judicialmente OU divorciado(a) OU viúvo(a)


	/* D.10. RENDA E ATIVIDADE ECONÔMICA  */

	recode v528 (1 = 1) (3 5 = 0) // 5 é "frente de seca", eles continuam o questionário como quem não trabalha
	rename v528 trab_ult_12m
	* trab_ult_12m = 1 sim
	*                0 não

	rename v529 cond_ativ
	* cond_ativ = 0 trabalhou nos últimos 12 meses
	*             1 procurando trabalho - já trabalhou
	*             2 procurando trabalho - nunca trabalhou
	*             3 aposentado ou pensionista
	*             4 vive de renda
	*             5 detento
	*             6 estudante
	*             7 doente ou inválido
	*             8 afazeres domésticos
	*             9 sem ocupação

	gen cond_ativB = cond_ativ
	recode cond_ativB (0 = 1)
	* cond_ativB = 1 trabalhou nos últimos 12 meses ou procurando trabalho - já trabalhou
	*             2 procurando trabalho - nunca trabalhou
	*             3 aposentado ou pensionista
	*             4 vive de renda
	*             5 detento
	*             6 estudante
	*             7 doente ou inválido
	*             8 afazeres domésticos
	*             9 sem ocupação

	recode cond_ativ (0/2=1) (3/9 =0), copy g(pea)
	lab var pea "população economicamente ativa"
	* pea	= 1 economicamente ativo
	*         0 inativo


	gen v530b = v530
	recode v530b (1/65 = 1) (101/293 = 2) (301/336 = 3) (341/391 = 4) (401/589 = 5) ///
				 (601/646 = 6) (701/776 = 7) (801/845 = 8) (851/859 = 9) (911/924 = 10) ///
				 (925=5) (926 927 = 10)
	rename v530 ocup_hab
	rename v530b grp_ocup_hab	
	label var grp_ocup_hab "Grupo da ocupação habitual"
	* grp_ocup_hab =  1 administrativas
	*                 2 técnicas, científicas, artísticas e assemelhadas
	*                 3 agropecuária e da produção extrativa vegetal e animal
	*                 4 produção extrativa mineral
	*                 5 indústrias de transformação e construção civil
	*                 6 comércio e atividades auxiliares
	*                 7 transportes e comunicações
	*                 8 prestação de serviços
	*                 9 defesa nacional e segurança pública
	*                10 outras ocupações, ocupações mal definidas ou não declaradas

	gen v532b = v532
	recode v532b (11/42 = 1) (100/300 = 2) (340 = 3) (50/59 = 4) (351/354 = 4) ///
				 (410/424 = 5) (471/482 = 6) (571/589 = 7) (511/552 = 8) (610/632 = 9) ///
				 (711/727 = 10) (451/464 = 11) (801/903 = 11) (else=.)
	rename v532 ativ_hab
	rename v532b set_ativ_hab
	label var set_ativ_hab "Setor de atividade na ocupação habitual"
	* set_ativ_hab =  1 atividades agropecuárias, de extração vegetal e pesca
	*                 2 indústria de transformação
	*                 3 indústria da construção civil
	*                 4 outras atividades industriais (extração mineral e serviços
	*                   industriais de utilidade pública)
	*                 5 comércio de mercadorias
	*                 6 transporte e comunicação
	*                 7 serviços auxiliares da atividade econômica (técnico-profissionais
	*                   e auxiliares das atividades econômicas)
	*                 8 prestação de serviços (alojamento e alimentação, reparação e
	*                   conservação, pessoais, domiciliares e diversões)
	*                 9 social(comunitárias, médicas, odontológicas e ensino)
	*                10 administração pública, defesa nacional e segurança pública
	*                11 outras atividades (instituições de crédito, seguros e
	*                   capitalização, comércio e administração de imóveis e valores
	*                   mobiliários, organizações internacionais e representações
	*                   estrangeiras, atividades não compreendidas nos demais ramos e
	*                   atividades mal definidas ou não declaradas)

	recode v533 (2=1) (3=2) (4 7 = 8) (5=3) (8=7) (9=.) // 0, 1 e 6 mantidos
	replace v533 = 4 if v533 == 6 & ocup_hab == 805 // trabalhador doméstico - empregado
	replace v533 = 5 if v533 == 7 & ocup_hab == 805 // trabalhador doméstico - conta-própria
	rename v533 pos_ocup_hab
	* pos_ocup_hab = 0 sem remuneração
	*                1 trabalhador agrícola volante
	*                2 parceiro ou meeiro - empregado
	*                3 parceiro ou meeiro - autônomo ou conta-própria
	*                4 trabalhador doméstico - empregado
	*                5 trabalhador doméstico - autônomo ou conta-própria
	*                6 empregado
	*                7 autônomo ou conta-própria
	*                8 empregador

	recode pos_ocup_hab (1 6=4) (2 3 =1) (4 =2) (5 =3) (7 =5) (8 =6), copy g(pos_ocup_habB)
	lab var pos_ocup_habB "Posição na ocupação habitual - agregada"
	* pos_ocup_habB = 0 sem remuneração
	*                 1 parceiro ou meeiro 
	*                 2 trabalhador doméstico - empregado
	*                 3 trabalhador doméstico - autônomo ou conta-própria
	*                 4 empregado
	*                 5 autônomo ou conta-própria
	*                 6 empregador

	recode v534 (2 4 6 = 1) (8=0) (9=.)
	rename v534 previd_A
	* previd_A = 0 não
	*          1 sim

	recode v535 (9=.)
	rename v535 hrs_oc_hab
	lab var hrs_oc_hab "horas trabalhadas p/semana - ocup hab"
	* hrs_oc_hab = 1 - menos de 15 horas
	*              2 - de 15 a 29 horas
	*              3 - de 30 a 39 horas
	*              4 - de 40 a 48 horas
	*              5 - 49 horas ou mais

	gen hrs_oc_habC = hrs_oc_hab
	recode hrs_oc_habC (3 = 2) (4 5=3) // (1=1) (2=2)
	replace hrs_oc_habC = . if set_ativ_hab==1
	lab var hrs_oc_habC "horas trabalhadas p/semana C - ocup hab - exclusive agropec"

	* hrs_oc_habC = 1 - menos de 15 horas
	*               2 - de 15 a 39 horas
	*               3 - 40 horas ou mais


	recode v536 (4=1) (5=2) (6=3) (7=4) (0=5) (else=.)
	rename v536 hrs_todas_oc
	* hrs_todas_oc = 1 - menos de 15 horas
	*                2 - de 15 a 29 horas
	*                3 - de 30 a 39 horas
	*                4 - de 40 a 48 horas
	*                5 - 49 horas ou mais
	
	* trabalha no município
	recode v527 (0 = 1) (1100007/max = 0)
	replace v527 = . if hrs_oc_hab==.
	rename v527 mun_trab
	lab var mun_trab "trabalha no município em que reside"
	* mun_trab 	= 1 - sim
	*			= 0 - não


	*** Ocupação na semana -- comparável com 1970:
	recode v541 (6 4 =4) (5=.)
	rename v541 trab_semana
	* trab_semana = 1 só ocupação habitual
	*               2 habitual e outra
	*               3 só outra
	*               4 outros
 
	drop v542
	drop v544
	drop v545 trab_ult_12m
		

	/* D.11. FECUNDIDADE */

	egen filhos_nasc_vivos = rowtotal(v550 v551), miss
	lab var filhos_nasc_vivos "total de filhos nascidos vivos"

	recode v550 (98 99 = .)
	rename v550 f_nasc_v_hom
	recode v551 (98 99 = .)
	rename v551 f_nasc_v_mul
	
	label var f_nasc_v_hom "filhos nascidos vivos (homens)"
	label var f_nasc_v_mul "filhos nascidos vivos (mulheres)"

	replace filhos_nasc_vivos =. if f_nasc_v_hom==. | f_nasc_v_mul==.
	
	egen filhos_nasc_mortos = rowtotal(v552 v553), miss
	lab var filhos_nasc_mortos "total de filhos nascidos mortos"

	recode v552 (98 99 = .)
	rename v552 f_nasc_m_hom
	recode v553 (98 99 = .)
	rename v553 f_nasc_m_mul
	
	label var f_nasc_m_hom "filhos nascidos mortos (homens)"
	label var f_nasc_m_mul "filhos nascidos mortos (mulheres)"

	replace filhos_nasc_mortos =. if f_nasc_m_hom==. | f_nasc_m_mul==.
	
	egen filhos_hom = rowtotal(f_nasc_v_hom f_nasc_m_hom), miss
	replace filhos_hom = . if f_nasc_v_hom==. | f_nasc_m_hom==.
	lab var filhos_hom "total de filhos tidos"

	egen filhos_mul = rowtotal(f_nasc_v_mul f_nasc_m_mul), miss
	replace filhos_mul = . if f_nasc_v_mul ==. | f_nasc_m_mul==.
	lab var filhos_mul "total de filhas tidas"

	egen filhos_tot = rowtotal(filhos_nasc_vivos filhos_nasc_mortos), miss
	replace filhos_tot = . if filhos_nasc_vivos ==. | filhos_nasc_mortos==.
	lab var filhos_tot "total de filhos tidos"

	egen filhos_vivos = rowtotal(v554 v555), miss
	lab var filhos_vivos "total de filhos vivos"

	recode v554 (98 99 = .)
	rename v554 f_vivos_hom
	recode v555 (98 99 = .)
	rename v555 f_vivos_mul

	replace filhos_vivos = . if f_vivos_hom==. | f_vivos_mul==.
	
	recode v570 (999 = .)
	rename v570 idade_ult_nasc_v

	label var idade_ult_nasc_v "idade calculada do ultimo filho nascido vivo"

	rename v604 peso_pess

	drop  v505 v510 v556 v557


	/* D.10. CONTINUACAO. RENDA E ATIVIDADE ECONÔMICA */ 
	foreach nn in 07 08 09 10 11 12 13 {
	   replace v6`nn' = . if v6`nn' == 9999999
	}

	rename v607 rend_ocup_hab
	rename v609 rend_outras_ocup

	rename v610 rend_aposent
	rename v611 rend_aluguel
	rename v612 rend_doa_pen
	egen rend_total = rowtotal(rend_ocup_hab rend_outras_ocup rend_aposent rend_aluguel rend_doa_pen v613) // NAO INCLUI RENDIMENTO EM MERCADORIAS E PRODUTOS MESMO? A V608...
	lab var rend_total "renda total"
	by id_muni distrito id_dom num_fam: ///
		egen rend_fam = total(rend_total*(v504>= 1 & v504<= 6))
	lab var rend_fam "renda familiar"
	by id_muni distrito id_dom: ///
		egen renda_dom = total(rend_total*(v503>= 1 & v503<= 6))
	lab var renda_dom "renda domiciliar"
	drop v608 v613  v680 v540 v682 v681
	
	/* DEFLACIONANDO RENDAS: julho/2022 */
	cap g double deflator = 0.0000000000015139096
	cap g conversor = 2750000000000
	
	lab var deflator "deflator de rendimentos - referência: julho/2022"
	lab var conversor "conversor de moedas"

	foreach var in rend_ocup_hab rend_outras_ocup rend_total rend_fam renda_dom {
		g `var'_def = (`var'/conversor)/deflator
		lab var `var'_def "`var' deflacionada"
	}
	drop rend_aposent rend_aluguel rend_doa_pen
}

drop id_muni distrito v504 

order ano UF regiao munic id_dom

end

program define compat_censo91dom

/* A. ANO */
* Essa variável é definida antes de chamar este programa.

/* B. IDENTIFICAÇÃO E NÚMERO DE PESSOAS */

/* B.1. IDENTIFICAÇÃO */
rename v1101 UF
drop v1102

capture rename v0102 id_dom

rename v7004 regiao
* regiao = 1 região norte
*          2 região nordeste
*          3 região sudeste
*          4 região sul
*          5 região centro-oeste


drop v7001 v7002 v0109 v7003

	
/* B.2. VARIÁVEIS DE NÚMERO DE PESSOAS */
rename v0111 n_homem_dom
rename v0112 n_mulher_dom
egen n_pes_dom = rowtotal(n_homem_dom n_mulher_dom)
lab var n_pes_dom "número de moradores no domicílio"

/* C. VARIÁVEIS DE DOMICÍLIO*/

/* C.1. SITUAÇÃO */
rename v1061 sit_setor
lab var sit_setor "situação do domicílio - desagregado"
* sit_setor = 1 - Área urbanizada de vila ou cidade
*             2 - Área não urbanizada de vila ou cidade
*             3 - Área urbanizada isolada
*             4 - Rural - extensão urbana
*             5 - Rural - povoado
*             6 - Rural - núcleo
*             7 - Rural - outros aglomerados
*             8 - Rural - exclusive os aglomerados rurais

gen sit_setor_B = sit_setor
recode sit_setor_B (1 2 = 1) (3=2) (4/7 = 3) (8=4)
lab var sit_setor_B "situação do domicílio - agregado"
* sit_setor_B = 1 - Vila ou cidade
*               2 - Urbana isolada
*               3 - Aglomerado rural
*               4 - Rural exclusive os aglomerados

gen sit_setor_C = sit_setor_B
recode sit_setor_C (1 2 = 1) (3 4 = 0)
lab var  sit_setor_C "situação do domicílio - urbano/rural"
* sit_setor_C = 1 - Urbana
*               0 - Rural

/* C.2. ESPÉCIE */
recode v0201 (1=0) (2=1) (3=2)
rename v0201 especie
* especie = 0 - particular permanente
*           1 - particular improvisado
*           2 - coletivo

/* C.3. MATERIAL DAS PAREDES */
rename v0203 paredes
* paredes 	= 1   Alvenaria
*        	= 2   Madeira aparelhada
*        	= 3   Taipa não revestida
*       	= 4   Material aproveitado
*   	    = 5   Palha
*	        = 6   Outro

gen paredes_B = paredes
recode paredes_B (6=5)
* paredes_B	= 1   Alvenaria
*        	= 2   Madeira aparelhada
*        	= 3   Taipa não revestida
*       	= 4   Material aproveitado
*   	    = 5   Outro

/* C.4. MATERIAL DA COBERTURA */
rename v0204 cobertura
*cobertura = 1 laje de concreto
*		   = 2 telha de barro
*		   = 3 telha de amianto
*		   = 4 zinco
*		   = 5 madeira aparelhada
*		   = 6 palha
*		   = 7 material aproveitado
*		   = 8 outro material


/* C.5. TIPO */

* Somente para domicílios particulares permanentes tipo casa ou apt (não cômodo)
gen subnormal = 1 if (v0202 == 3 | v0202 == 6)
replace subnormal = 0 if (v0202 == 1 | v0202 ==2 | v0202 == 4 | v0202 == 5)
lab var subnormal "dummy para setor subnormal"
* subnormal = 0 - não
*             1 - sim

recode v0202 (1/3 = 1) (4/6 = 2) (7=3)
rename v0202 tipo_dom
* tipo_dom = 1 - casa
*            2 - apartamento
*            3 - cômodo

gen tipo_dom_B = tipo_dom
recode tipo_dom_B (3=2)
lab var tipo_dom_B "tipo de domicílio B"
* tipo_dom_B = 1 - casa
*              2 - apartamento (ou cômodo)

/* C.6. CONDIÇÃO DE OCUPAÇÃO E ALUGUEL */
gen terreno_prop = 1 if v0208==1
replace terreno_prop = 0 if v0208==2
lab var terreno_prop "dummy para terreno próprio"
* terreno_prop = 0 - não
*                1 - sim

recode v0208 (2=1) (3=2) (4=3) (5=4) (6=5) // (1=1)
rename v0208 cond_ocup
* cond_ocup = 1 - próprio
*             2 - alugado
*             3 - cedido por empregador
*             4 - cedido de outra forma
*             5 - outra condição

gen cond_ocup_B = cond_ocup
recode cond_ocup_B (4=3) (5=4) // 1 a 3 mantidos
lab var  cond_ocup_B "condição de ocupação B"
* cond_ocup_B = 1 - próprio
*               2 - alugado
*               3 - cedido
*               4 - outra condição

recode v0209 (0 999999=.)
rename v0209 aluguel

* Aluguel em salários mínimos
drop v2094 


/* C.7. ABASTECIMENTO DE ÁGUA */
recode v0205 (1=1) (2=3) (3=5) (4=2) (5=4) (6=5)
rename v0205 abast_agua
* abast_agua = 1 - rede geral com canalização interna
*              2 - rede geral sem canalização interna
*              3 - poço ou nascente com canalização interna
*              4 - poço ou nascente sem canalização interna
*              5 - outra forma


/* C.8. INSTALAÇÕES SANITÁRIAS */
gen sanitario = 0 if v0206 == 0
replace sanitario = 1 if (v0206 >= 1) & (v0206 <= 7)
lab var sanitario "dummy para acesso a sanitário"
* sanitario = 0 - não tem acesso
*                1 - tem acesso

recode v0206 (3=2) (4=3) (5 6 = 4) (7 0 = .) // 1 e 2 mantidos
rename v0206 tipo_esc_san
* tipo_esc_san = 1 - Rede geral
*                2 - Fossa séptica
*                3 - Fossa rudimentar
*                4 - Outro escoadouro

recode v0207 (2=0) // 0 e 1 mantidos
rename v0207 sanitario_ex
label var sanitario_ex "acesso exclusivo a instalação sanitária"
* inst_san_exc = 0 - não tem acesso a inst san exclusiva
*                1 - tem acesso a inst sanitária exclusiva

rename v0213 banheiros
* banheiros = 0 - não tem
*             1 a 4 - número de banheiros
*             5 - cinco ou mais banheiros


/* C.9. DESTINO DO LIXO */
rename v0214 dest_lixo
* dest_lixo = 1 - Coletado por serviço de limpeza
*             2 - Colocado em caçamba de serviço de limpeza
*             3 - Queimado(na propriedade)
*             4 - Enterrado(na propriedade)
*             5 - Jogado em terreno baldio ou logradouro
*             6 - Jogado em rio, lago ou mar
*             7 - Tem outro destino

gen dest_lixo_B = dest_lixo
recode dest_lixo_B (7=6)
* dest_lixo_B = 1 - Coletado no domicílio por serviço de limpeza
*             	2 - Colocado em caçamba de serviço de limpeza
*             	3 - Queimado na propriedade
*             	4 - Enterrado na propriedade
*             	5 - Jogado em terreno baldio, encosta ou área pública
*             	6 - Outro destino

/* C.10. ILUMINAÇÃO ELÉTRICA */
gen medidor_el = 0 if v0221 == 2
replace medidor_el = 1 if v0221 == 1
label var medidor_el "presença de medidor de consumo de eletricidade"
* medidor_el = 0 - não tem
*                1 - tem

recode v0221 (2=1) (3 4 = 0) // (1=1)
rename v0221 ilum_eletr
* ilum_eletr = 0 - não tem
*              1 - tem


/* C.11. BENS DE CONSUMO DURÁVEIS */
generate fogao_ou_fog = 0 if v0210 == 0
replace fogao_ou_fog = 1 if (v0210 >= 1) & (v0210 <= 6)
label var fogao_ou_fog "fogão ou fogareiro"
* fogao_ou_fog = 0 - não tem
*                1 - tem

recode v0210 (2 4 = 1) (3=2) (5=3) (6=4) // 0 e 1 mantidos
rename v0210 comb_fogao
* comb_fogao = 1 - gás
*                2 - lenha
*                3 - carvão
*                4 - outro
*                0 - não tem fogão nem fogareiro

rename v0220 radio
* radio = 0 - não tem
*         1 - tem

recode v0222 (2=1) // 0 e 1 mantidos
rename v0222 geladeira
* geladeira = 0 - não tem
*             1 - tem

gen gelad_ou_fre = 0 if (geladeira == 0) & (v0225 == 0)
replace gelad_ou_fre = 1 if (geladeira == 1) | (v0225 == 1)
lab var gelad_ou_fre "geladeira ou freezer"
* gelad_ou_fre = 0 - não tem
*                1 - tem
drop v0225

recode v0217 (2 = 1)
rename v0217 telefone
* telefone = 0 - não tem
*            1 - tem

rename v0223 tv_pb
recode v0224 (2 3 = 1) // 0 e 1 mantidos
rename v0224 tv_cores

gen televisao = 0 if tv_pb == 0 & tv_cores == 0
replace televisao = 1 if (tv_pb == 1) | (tv_cores == 1)
lab var televisao "televisão"
* televisao, tv_pb, tv_cores = 0 - não tem
*                              1 - tem

recode v0218 (2 3 = 1) // 0 e 1 mantidos
rename v0218 automov_part
gen automovel = 0 if automov_part == 0
replace automovel = 1 if (automov_part == 1) | (v0219 == 1) | (v0219 == 2)
lab var automovel "automóvel"
* automovel, automov_part = 0 - não tem
*                           1 - tem

* Quesito automóvel para trabalho pesquisado só em 1991
drop v0219

rename v0226 lavaroupa
* lavaroupa 0 - não tem
*			1 - tem

drop v0216 v0227


/* C.12. NÚMERO DE CÔMODOS */
rename v0211 tot_comodos
rename v0212 tot_dorm

drop v2111 v2112 v2121 v2122


/* C.13. RENDA DOMICILIAR */
replace v2012 = . if v2012>10^8
rename v2012 renda_dom

drop v2013 v2014

/* DEFLACIONANDO RENDAS: julho/2022 */
g double deflator = 0.0000160532976703994
g double conversor = 2750000

lab var deflator "deflator de rendimentos - referência: julho/2022"
lab var conversor "conversor de moedas"

g renda_dom_def = (renda_dom/conversor)/deflator
lab var renda_dom_def "renda_dom deflacionada"

g aluguel_def = (aluguel/conversor)/deflator
lab var aluguel_def "aluguel deflacionada"


/* C.14. PESO AMOSTRAL */
rename v7300 peso_dom

order  ano UF munic id_dom  

end

program define compat_censo91pess

/* A. ANO */
* Essa variável é definida antes de chamar este programa.


/* B. IDENTIFICAÇÃO E NÚMERO DE PESSOAS */

/* B.1. IDENTIFICAÇÃO */
rename v1101 UF

capture rename v0102 id_dom

drop v7002 v1102 

rename v0098 ordem

* renda do casal
drop v3043 v3044 v3046- v3049 

* numero de ordem da mae
drop v3005

rename v7004 regiao
* reg_geo = 1 região norte
*         = 2 região nordeste
*         = 3 região sudeste
*         = 4 região sul
*         = 5 região centro-oeste

/* B.2. VARIÁVEIS DE NÚMERO DE PESSOAS */
rename v3041 n_homem_fam
rename v3042 n_mulher_fam
egen n_pes_fam = rowtotal(n_homem_fam n_mulher_fam)
lab var n_pes_fam "número de pessoas na família"
* Pessoas no domicílio: não disponível no registro de pessoas.


/* D. OUTRAS VARIÁVEIS PESSOA */

/* D.1. SEXO */
recode v0301 (2=0) // (1=1)
rename v0301 sexo
* sexo = 0 - feminino
*        1 - masculino

/* D.2. CONDIÇÃO NA FAMÍLIA E NO DOMICÍLIO */
recode v0302 (3 4 = 3) (5 6 = 4) (8=5) (10=6) (7 9 11 12 = 7) (13=8) /// (1=1) (2=2)
             (14=9) (15=10) (16=11) (20=12)
rename v0302 cond_dom
* cond_dom =  1 - Pessoa responsável
*                 2 - Cônjuge, companheiro(a)
*                 3 - Filho(a), enteado(a)
*                 4 - Pai, mãe, sogro(a)
*                 5 - Neto(a), bisneto(a)
*                 6 - Irmão, irmã
*                 7 - Outro parente
*                 8 - Agregado(a)
*                 9 - Pensionista
*                10 - Empregado(a) doméstico(a)
*                11 - Parente do(a) empregado(a) doméstico(a)
*                12 - Individual em domicílio coletivo

recode v0303 (3 4 = 3) (5 6 = 4) (8=5) (10=6) (7 9 11 12 = 7) (13=8) /// (1=1) (2=2)
             (14=9) (15=10) (16=11) (20=12)
rename v0303 cond_fam
* cond_fam =  1 - Pessoa responsável
*                 2 - Cônjuge, companheiro(a)
*                 3 - Filho(a), enteado(a)
*                 4 - Pai, mãe, sogro(a)
*                 5 - Neto(a), bisneto(a)
*                 6 - Irmão, irmã
*                 7 - Outro parente
*                 8 - Agregado(a)
*                 9 - Pensionista
*                10 - Empregado(a) doméstico(a)
*                11 - Parente do(a) empregado(a) doméstico(a)
*                12 - Individual em domicílio coletivo

gen cond_dom_B = cond_dom
recode cond_dom_B (5/7 = 5) (8=6) (9=7) (10=8) (11=9) (12=10) // 1 a 4 mantidos
lab var cond_dom_B "relação com o responsável do domicílio B"

gen cond_fam_B = cond_fam
lab var cond_fam_B "relação com o responsável da família B"
recode cond_fam_B (5/7 = 5) (8=6) (9=7) (10=8) (11=9) (12=10) // 1 a 4 mantidos
* cond_***_B =  1 - Pessoa responsável
*               2 - Cônjuge, companheiro(a)
*               3 - Filho(a), enteado(a)
*               4 - Pai, mãe, sogro(a)
*               5 - Outro parente
*               6 - Agregado
*               7 - Hóspede, pensionista
*               8 - Empregado(a) doméstico(a)
*               9 - Parente do(a) empregado(a) doméstico(a)
*              10 - Individual em domicílio coletivo

recode v0304 (2=0) (3=1) (4=2) (5=3) (6=4) (7=5) // 1 mantido
rename v0304 num_fam

* tipo de familia
drop v2011 // só em 1991

/* D.3. IDADE */
recode v3071 (2=0) // (1=1)
rename v3071 idade_presumida
* idade_presumida = 0 - não
*                   1 - sim

rename v3072 idade
rename v3073 idade_meses

/* D.4. COR OU RAÇA */
recode v0309 (9=.)
rename v0309 raca
* raca = 1 - branca
*        2 - preta
*        3 - amarela
*        4 - parda
*        5 - indígena

gen racaB = raca
recode racaB (5=4) // 1 a 4 mantidos
lab var racaB "cor ou raça (indígena=pardo)"
* racaB = 1 - branca
*         2 - preta
*         3 - amarela
*         4 - parda

/* D.5. RELIGIÃO */
recode v0310 (11=1) (21/30 = 2) (31/41 45 = 3) (61=4) (62 63 = 5) (75 76 77 79 = 6) ///
             (71=7) (49 51 52 53 59 81 82 83 84 12 13 19 = 8) (85 86 89 99 = .) // 19 nao tem no dicionario: confirmar tabulacao.
rename v0310 religiao
* religiao = 0 - sem religião
*            1 - católica
*            2 - evangélica tradicional
*            3 - evangélica pentecostal
*            4 - espírita kardecista
*            5 - espírita afro-brasileira
*            6 - religiões orientais
*            7 - judaica/israelita
*            8 - outras religiões

gen religiao_A = religiao
recode religiao_A (3 = 2) (4 = 3) (5 = 4) (6 = 5) (7 = 6) (8 = 7)
lab var religiao_A "religião A - mais agregada"
* religiao_A = 0 - sem religião
*            1 - católica
*            2 - evangélica
*            3 - espírita kardecista
*            4 - espírita afro-brasileira
*            5 - religiões orientais
*            6 - judaica/israelita
*            7 - outras religiões

gen religiao_B = religiao
recode religiao_B (3=2) (4 5 = 3) (6/8 = 4)
lab var religiao_B "religião B - mais agregada"
* religiao_B = 0 - sem religião
*              1 - católica
*              2 - evangélica
*              3 - espírita
*              4 - outra

/* D.6. DEFICIÊNCIAS FÍSICA E MENTAL */
* foi retirado da compatibilizacao porque o item é analisada em uma única
* pergunta, diferentemente dos anos subsequentes
drop v0311

/* D.7. NATURALIDADE E MIGRAÇÃO */

*** Condição de migrante
gen sempre_morou = 0 if (v0314 == 2 | v0314 == 3)
replace sempre_morou = 1 if v0314 == 1
label var sempre_morou "Sempre morou neste município"
* sempre_morou = 0 - não
*                1 - sim

recode v0312 (1=0) (2=1) (3=2)
rename v0312 onde_morou
* onde_morou = 0 só na zona urbana
*                1 só na zona rural
*                2 nas zonas urbana e rural

* O quesito abaixo só é pesquisado em 1991.
drop v0313

*** Nacionalidade e naturalidade
recode v0314 (3=0) (2=1) // (1=1)
rename v0314 nasceu_mun
label var nasceu_mun "Nasceu neste município"
* nasceu_mun = 0 não
*              1 sim


recode v3151 (1=0) (2=1) (3=2)
replace v3151 = 0 if nasceu_mun==1
rename v3151 nacionalidade
* nacionalidade = 0 - brasileiro nato
*                 1 - brasileiro naturalizado
*                 2 - estrangeiro

replace v3152 = . if nacionalidade == 0 // originalmente ambíguo: bras nato ou
										// estrangeiro que fixou res até 1900
replace v3152 = 1900 + v3152 if (v3152 >= 0 & v3152 <= 91)
rename v3152 ano_fix_res

gen UF_nascim = v0316
replace UF_nascim = . if (v0316 >= 30 & v0316 != .)
recode UF_nascim (1=11) (2=12) (3=13) (4=14) (5=15) (6=16) (7=17) (8=21) (9=22) (10=23) ///
				 (11=24) (12=25) (13=26) (14=27) (15=28) (16=29) (17=31) (18=32) (19=33) ///
				 (20=35) (21=41) (22=42) (23=43) (24=50) (25=51) (26=52) (27=53) (29=.)
*	replace UF_nascim = UF if nasceu_mun==1
label var UF_nascim "UF de nascimento"
* UF_nascim = 11-53 UF de nascimento especificada

gen nasceu_UF = 0
replace nasceu_UF = 1 if UF_nascim == UF | nasceu_mun==1
label var nasceu_UF "Nasceu nesta UF"
* nasceu_UF = 0 não
*             1 sim

recode v0316 (1/29 99 = .)	///
	(82 84 85 = 83 )	///
	(83 = 82 )	///
	(86 87=84 ) ///
	(88=86 ) ///
	(89=87 ) ///
	(90=88 ) ///
	(91=89 ) ///
	(92=90 ) ///
	(93=91 ) ///
	(94=92 ) ///
	(95=93 ) ///
	(96=94 ) ///   
	(97=95 ) ///
	(98=96 ), copy g(pais_nascim)
* pais_nascim = 30-98 país estrangeiro especificado
* 83 = Africa - outros  
* 82 = Egito	
* 84 = China 
* 86 = Coréia 
* 87 = Índia 
* 88 = Israel 
* 89 = Japão 
* 90 = Líbano 
* 91 = Paquistão 
* 92 = Síria 
* 93 = Turquia 
* 94 = Ásia - outros 
* 95 = Australia
* 96 = Oceania
label var pais_nascim "País de nascimento - códigos 1970"
* pais_nascim = 30-98 país estrangeiro especificado
drop v0316

*** Última migração

rename v0317 anos_mor_UF
rename v0318 anos_mor_mun

* em 1970, somente quem não nasceu no município responde às questões de tempo de moradia
g t_mor_UF_70 = anos_mor_UF
g t_mor_mun_70 = anos_mor_mun
recode t_mor_UF_70 t_mor_mun_70 (7/10=6) (11/max=7)

lab var t_mor_UF_70 "tempo de moradia na UF - grupos de 1970"
lab var t_mor_mun_70 "tempo de moradia no municipio - grupos de 1970"

* De 1980 em diante, podemos montar a variavel de tempo de moradia incluindo
* pessoas que nasceram mas nem sempre moraram no municipio em que residem
recode anos_mor_UF (7/9 =6) (10/max =7), g(t_mor_UF_80)
recode anos_mor_mun (7/9 =6) (10/max =7), g(t_mor_mun_80)
lab var t_mor_UF_80 "tempo de moradia na UF - grupos de 1980"
lab var t_mor_mun_80 "tempo de moradia no municipio - grupos de 1980"

*** Onde morava anteriormente - para quem migrou nos últimos 10 anos:
gen pais_mor_ant = v3191 if v0319 == 80
recode pais_mor_ant (0/29 99=.)	///
	(82 84 85 = 83 )	///
	(83 = 82 )	///
	(86 87=84 ) ///
	(88=86 ) ///
	(89=87 ) ///
	(90=88 ) ///
	(91=89 ) ///
	(92=90 ) ///
	(93=91 ) ///
	(94=92 ) ///
	(95=93 ) ///
	(96=94 ) ///   
	(97=95 ) ///
	(98=96 )
label var pais_mor_ant "País onde morava anteriormente (se migrou nos últ 10 anos)"
* pais_mor_ant = 30-98 país estrangeiro especificado

gen long mun_mor_ant = 10000*v0319 + v3191 if v0319 <= 53
label var mun_mor_ant "Município onde morava ant (se migrou nos últ 10 anos)"

recode v0319 (0 54 80 99=.)
rename v0319 UF_mor_ant
label var UF_mor_ant "UF onde morava anteriormente (se migrou nos últ 10 anos)"
* UF_mor_ant = 11-53 código da UF em que morava

drop v3191

recode v0320 (9=.) (2=0) // (1=1) // no dicionario, tem opcao 0 como NSA. checar na tabulacao para transformar em missing tambem
rename v0320 sit_mun_ant
* sit_mun_ant = 1 zona urbana
*               0 zona rural

*** Local de residência há 5 anos:
gen pais_mor5anos = v3211 if v0321 == 80
recode pais_mor5anos (0/29 99=.)	///
	(82 84 85 = 83)	///
	(83 = 82)	///
	(86 87=84) ///
	(88=86) ///
	(89=87) ///
	(90=88) ///
	(91=89) ///
	(92=90) ///
	(93=91) ///
	(94=92) ///
	(95=93) ///
	(96=94) ///   
	(97=95) ///
	(98=96)
label var pais_mor5anos "País onde morava há 5 anos"
* pais_mor5anos = 30-98 código de país/região estrangeiro(a)

gen long mun_mor5anos = 10000*v0321 + v3211 if v0321 <= 53
label var mun_mor5anos "Município onde morava há 5 anos"
drop v3211

recode v0321 (54 70 80 99=.) // 70 é não-migrante
rename v0321 UF_mor5anos
label var UF_mor5anos "UF onde morava há 5 anos"
* UF_mor5anos = 11-53 código de UF em que morava

recode v0322 (2=0) (9=.) // (1=1) // no dicionario, tem opcao 0 como NSA. checar na tabulacao para transformar em missing tambem
replace v0322 =. if pais_mor5anos~=.
rename v0322 sit_dom5anos
label var sit_dom5anos "Situação do domicílio onde morava há 5 anos"
* sit_dom5anos = 1 zona urbana
*                0 zona rural

/* D.8. EDUCAÇÃO */
recode v0323 (2=0) // (1=1) // no dicionario, tem opcao 0 como NSA. checar na tabulacao para transformar em missing tambem
rename v0323 alfabetizado
* alfabetizado = 0 - não
*                1 - sim

gen freq_escola = 0     if idade >= 5
replace freq_escola = 1 if (idade >= 5) & (v0325 ~= 0) // frequenta curso seriado
replace freq_escola = 1 if (idade >= 5) & ((v0326>=2 & v0326<=4) | v0326==6) // frequenta curso não-seriado
lab var freq_escola "frequenta escola"

gen freq_escolaB = freq_escola
replace freq_escolaB = 1 if v0326 == 1 // inclui pré-escola
lab var freq_escolaB "frequenta escola - inclui pré-escola"


* Anos de estudo - cálculo do IBGE
recode v3241 (20 = .) (17=16) (30 = 0) // 20 é "indefinido"; lim em 16 pois é máximo em 1970  // no dicionario, tem opcao 31 como NSA. checar na tabulacao para transformar em missing tambem
rename v3241 anos_estudo
* anos_estudo = 0      - Sem instrução ou menos de 1 ano
*               1 a 15 - Número de anos
*               16     - 16 anos ou mais


* Anos de estudo "B" - nível de escolaridade associado à série atualmente cursada

* Para quem não freqüenta, usamos anos_estudo:
gen anos_estudoB = anos_estudo if freq_escola == 0
lab var anos_estudoB "anos de estudo - associado à série atualmente cursada"

* Frequentando cursos não seriados:
replace anos_estudoB = 0  if (freq_escola == 1) & (v0326 >= 1) & (v0326 <= 2) // pré-escola, alfabetização de adultos
* Na situaçao abaixo, supletivo de 1o grau, IBGE tem optado por considerar nível "indefinido"
*replace anos_estudoB = 0  if (freq_escola == 1) & (v0326 == 3) // suplet 1o grau
replace anos_estudoB = 8  if (freq_escola == 1) & (v0326 == 4) // suplet 2o grau
replace anos_estudoB = 11 if (freq_escola == 1) & (v0326 == 5) // pré-vestibular
replace anos_estudoB = 15 if (freq_escola == 1) & (v0326 == 6) // mestrado ou doutorado

* Frequentando cursos seriados:
replace anos_estudoB = v0324 - 1  if (freq_escola == 1) & (v0324 >= 1) & (v0324 <= 8) & ((v0325 == 1) | (v0325 == 4)) // 1o grau reg ou supletivo
replace anos_estudoB = v0324 + 7  if (freq_escola == 1) & (v0324 >= 1) & (v0324 <= 3) & ((v0325 == 2) | (v0325 == 5)) // 2o grau reg ou supletivo
replace anos_estudoB = 10         if (freq_escola == 1) & (v0324 >= 4) & (v0324 <= 8) & ((v0325 == 2) | (v0325 == 5)) // não terminou médio, não pode receber 11 anos
replace anos_estudoB = v0324 + 10 if (freq_escola == 1) & (v0324 >= 1) & (v0324 <= 5) & (v0325 == 3)                  // superior
replace anos_estudoB = 15         if (freq_escola == 1) & (v0324 >= 6) & (v0324 <= 8) & (v0325 == 3)                  // atribuo no máx 15 anos p/ superior incompleto

* Gupos de Anos de Estudo
* para quem frequenta escola
recode anos_estudoB (min/3 = 0) (4/7 = 1) (8/10 = 2) (11/14 = 3) (15/max = 4), g(anos_estudoC)
replace anos_estudoC = . if freq_escola==0
replace anos_estudoC = 0 if freq_escola==1 & v0326 == 3		// suplet 1o grau
replace anos_estudoC = 3 if freq_escola==1 & v0325==3 & anos_estudoC==4 	// superior sem conclusao

* para quem nao frequenta escola
replace anos_estudoC = 0 if freq_escola==0 & (v0328==1 | v0328==0) 	// alfabetizacao de adultos/nenhum
replace anos_estudoC = 0 if freq_escola==0 & v0328==2 	// primario
replace anos_estudoC = 0 if freq_escola==0 & v0328==4 & v0327>=1 & v0327<=3 	// 1a-3a serie 1o.grau
replace anos_estudoC = 1 if freq_escola==0 & v0328==4 & v0327>=4 & v0327<=8 	// 4a-8a serie 1o.grau

replace anos_estudoC = 1 if freq_escola==0 & v0328==2 & v0329>=1 & v0329<=8	// primario com conclusao
replace anos_estudoC = 1 if freq_escola==0 & v0328==3 	// ginasio/medio 1o.ciclo
replace anos_estudoC = 2 if freq_escola==0 & v0328==3 & v0329>=10 & v0329<=23 // ginasio/medio 1o.ciclo com conclusao

replace anos_estudoC = 2 if freq_escola==0 & v0328==4 & v0327>=4 & v0327<=8 & v0329>=10 & v0329<=23	// 4a-8a serie 1o.grau com conclusao
replace anos_estudoC = 2 if freq_escola==0 & v0328==5 	// 2o.grau
replace anos_estudoC = 2 if freq_escola==0 & v0328==6 	// colegiaa/medio 2o.ciclo

replace anos_estudoC = 3 if freq_escola==0 & v0328==5 & v0329>=24 & v0329<=42		// 2o.grau com conclusao
replace anos_estudoC = 3 if freq_escola==0 & v0328==6 & v0329>=24 & v0329<=42		// colegiaa/medio 2o.ciclo com conclusao
replace anos_estudoC = 3 if freq_escola==0 & v0328==7 	// superior

replace anos_estudoC = 4 if freq_escola==0 & v0328==7 & v0329>=43 & v0329<=97	// superior com conclusao
replace anos_estudoC = 4 if freq_escola==0 & v0328==8 	// mestrado/doutorado

lab var anos_estudoC "grupo de anos de escolaridade"

* anos_estudoC = 0 – sem instrução ou menos de 3 anos de estudo (primário incompleto)
*                1 – de 4 a 7 (fundamental/ ginásio/ 1º. Grau/ médio primeiro ciclo incompleto)
*				 2 – de 8 a 10 (médio/ 2º. Grau/ médio segundo ciclo incompleto)
*			 	 3 – de 11 a 14 (médio/ 2º. Grau/ médio segundo ciclo completo ou superior incompleto)
*			 	 4 – 15 ou mais (superior completo, mestrado, doutorado)

drop v0324- v0328

recode v0329 (1/8 = .) ///
		 (10/42 = .) ///
		 (72/77 80/83 93 94 96 = 3) ///
		 (43/49 65 86 87 = 4) ///
		 (50/63 88 89 = 5) ///
		 (64 66 90 = 6) ///
		 (67/71 78 79 91 92 = 7) ///
		 (84 = 8) ///
		 (85 95 97 = 9)	///
		 (0 = .), g(cursos_c1) 
lab var cursos_c1 "curso superior concluído"
* cursos_c1	=	3	ciências humanas
*				4	ciências biológicas
*				5	ciências exatas
*				6	ciências agrárias
*				7	ciências sociais
*				8	militar
*				9	outros cursos

recode v0329 (1/42 = .) /// 
		 (77 94 = 1) ///
		 (74/76 80/83 96 = 2) ///
		 (67/73 78 79 91/93 = 3) ///
		 (43 51 52 58/62 87 89 = 4) ///
		 (50 53/57 63 88 = 5) ///
		 (64/66 90 = 6) ///
		 (44/49 86 = 7) ///
		 (84 = 8) ///
		 (85 95 97 = 9)	///
		 (0 = .), g(cursos_c2)
lab var cursos_c2 "curso superior concluído - CONCLA"
* cursos_c2 =	1	Educação
*				2	Artes, Humanidades e Letras
*				3	Ciências Sociais, Administração e Direito
*				4	Ciências, Matemática e Computação
*				5	Engenharia, Produção e Construção
*				6	Agricultura e Veterinária
*				7	Saúde e Bem-Estar Social    
*				8	militar
*				9	Outros

rename v0329 curso_concl	// COMP SO PARA CURSO SUPERIOR
* curso_concl = 00 nenhum curso
*             = 01-97 curso concluído

/* D.9. SITUAÇÃO CONJUGAL */

recode v0330 (2 = 0)  // no dicionario, tem opcao 0 como NSA. checar na tabulacao para transformar em missing tambem
rename v0330 teve_conjuge
* teve_conjuge = 0 não
*              = 1 sim

gen vive_conjuge = 1 if (v3342 >= 1 & v3342 <= 3)
replace vive_conjuge = 0 if v3342 == 4 | v3342 == 5
label var vive_conjuge "vive com cônjuge"
* vive_conjuge = 0 - não
*                1 - sim
drop v3342

gen estado_conj = v0332 if (v0332 >= 1 & v0332 <=4)
replace estado_conj = v0333 + 1 if (v0333 >= 5 & v0333 <= 8)
replace estado_conj = 5 if teve_conjuge== 0
label var estado_conj "estado conjugal"
* estado_conj = 1 casamento civil e religioso
*               2 só casamento civil
*               3 só casamento religioso
*               4 união consensual
*               5 solteiro
*               6 separado(a)
*               7 desquitado(a)/separado(a) judicialmente
*               8 divorciado(a)
*               9 viúvo(a)

gen estado_conj_B = estado_conj
recode estado_conj_B (7 8 9 = 6)
label var estado_conj_B "estado conjugal B - mais agregado"
* estado_conj_B = 1 casamento civil e religioso
*                 2 só casamento civil
*                 3 só casamento religioso
*                 4 união consensual
*                 5 solteiro
*                 6 outros: separado(a) OU desquitado(a)/separado(a) judicialmente OU divorciado(a) OU viúvo(a)
drop v0332 v0333

drop v3311 v3312 v3341


/* D.10. RENDA E ATIVIDADE ECONÔMICA */

recode v0345 (2=1) (3=0) // (1=1)
rename v0345 trab_ult_12m
*trab_ult_12m = 0 não
*               1 sim

rename v0346 ocup_hab

rename v3461 grp_ocup_hab
* grp_ocup_hab =  1 administrativas
*                 2 técnicas, científicas, artísticas e assemelhadas
*                 3 agropecuária e da produção extrativa vegetal e animal
*                 4 produção extrativa mineral
*                 5 indústrias de transformação e construção civil
*                 6 comércio e atividades auxiliares
*                 7 transportes e comunicações
*                 8 prestação de serviços
*                 9 defesa nacional e segurança pública
*                10 outras ocupações, ocupações mal definidas ou não declaradas

rename v0347 ativ_hab

rename v3471 set_ativ_hab
* set_ativ_hab =  1 atividades agropecuárias, de extração vegetal e pesca
*                 2 indústria de transformação
*                 3 indústria da construção civil
*                 4 outras atividades industriais (extração mineral e serviços
*                   industriais de utilidade pública)
*                 5 comércio de mercadorias
*                 6 transporte e comunicação
*                 7 serviços auxiliares da atividade econômica (técnico-profissionais
*                   e auxiliares das atividades econômicas)
*                 8 prestação de serviços (alojamento e alimentação, reparação e
*                   conservação, pessoais, domiciliares e diversões)
*                 9 social(comunitárias, médicas, odontológicas e ensino)
*                10 administração pública, defesa nacional e segurança pública
*                11 outras atividades (instituições de crédito, seguros e
*                   capitalização, comércio e administração de imóveis e valores
*                   mobiliários, organizações internacionais e representações
*                   estrangeiras, atividades não compreendidas nos demais ramos e
*                   atividades mal definidas ou não declaradas)

recode v0349 (7 8 = 6) (9=7) (10=8) (11=0) // 1 a 6 mantidos
rename v0349 pos_ocup_hab
* pos_ocup_hab = 0 sem remuneração
*                1 trabalhador agrícola volante
*                2 parceiro ou meeiro - empregado
*                3 parceiro ou meeiro - autônomo ou conta-própria
*                4 trabalhador doméstico - empregado
*                5 trabalhador doméstico - autônomo ou conta-própria
*                6 empregado
*                7 autônomo ou conta-própria
*                8 empregador

recode pos_ocup_hab (1 =4) (2 3 =1) (4 =2) (5 =3) (6 =4) (7 =5) (8 =6), copy gen(pos_ocup_habB) 
lab var pos_ocup_habB "Posição na ocupação habitual - agregada"
* pos_ocup_habB = 0 sem remuneração
*                 1 parceiro ou meeiro 
*                 2 trabalhador doméstico - empregado
*                 3 trabalhador doméstico - autônomo ou conta-própria
*                 4 empregado
*                 5 autônomo ou conta-própria
*                 6 empregador

drop v0350 v0351 v0352

recode v0353 (2 = .) (3 = 0)
rename v0353 previd_A
* previd = 0 não
*          1 sim

gen hrs_oc_hab = 1 if v0354 < 15
replace hrs_oc_hab = 2 if (v0354 >= 15) & (v0354 < 30)
replace hrs_oc_hab = 3 if (v0354 >= 30) & (v0354 < 40)
replace hrs_oc_hab = 4 if (v0354 >= 40) & (v0354 < 49)
replace hrs_oc_hab = 5 if (v0354 >= 49) & v0354~=.
lab var hrs_oc_hab "horas trabalhadas p/semana - ocup hab"
* hrs_oc_hab = 1 - menos de 15 horas
*              2 - de 15 a 29 horas
*              3 - de 30 a 39 horas
*              4 - de 40 a 48 horas
*              5 - 49 horas ou mais

gen hrs_oc_habB = 1 if v0354 < 15
replace hrs_oc_habB = 2 if (v0354 >= 15) & (v0354 < 40)
replace hrs_oc_habB = 3 if (v0354 >= 40) & (v0354 < 50)
replace hrs_oc_habB = 4 if (v0354 >= 50) & v0354~=.
replace hrs_oc_habB = . if set_ativ_hab==1
lab var hrs_oc_habB "horas trabalhadas p/semana B - ocup hab - exclusive agropec"
* hrs_oc_habB = 1 - menos de 15 horas
*               2 - de 15 a 39 horas
*               3 - de 40 a 49 horas
*               4 - 50 horas ou mais

gen hrs_oc_habC = hrs_oc_habB
recode hrs_oc_habC (4=3) // 1 a 3 mantidos
lab var hrs_oc_habC "horas trabalhadas p/semana C - ocup hab - exclusive agropec"
* hrs_oc_habC = 1 - menos de 15 horas
*               2 - de 15 a 39 horas
*               3 - 40 horas ou mais

egen hrs_todas_oc = rowtotal(v0354 v0355)
recode hrs_todas_oc (min/14=1) (15/29=2) (30/39=3) (40/48=4) (49/max=5)
lab var hrs_todas_oc "horas de trabalho p/semana em todas as ocupações"

drop v0354 v0355

recode v0356 (0 9999999=.) // no dicionario, tem opcao 9999998 como NSA. checar na tabulacao para transformar em missing tambem
rename v0356 rend_ocup_hab

recode v0357 (0 9999999=.) // no dicionario, tem opcao 9999998 como NSA. checar na tabulacao para transformar em missing tambem
rename v0357 rend_outras_ocup

recode v0360 (9999999=.) // no dicionario, tem opcao 9999998 como NSA. checar na tabulacao para transformar em missing tambem
recode v0361 (9999999=.) // no dicionario, tem opcao 9999998 como NSA. checar na tabulacao para transformar em missing tambem
egen rend_outras_fontes = rowtotal(v0360 v0361)
lab var rend_outras_fontes "rendimento de outras fontes"

recode v3561 (99999999=.) // rendimento total tem 1 dígito a mais // no dicionario, tem opcao 99999998 como NSA. checar na tabulacao para transformar em missing tambem
rename v3561 rend_total
lab var rend_total "total de rendimentos"

* renda familiar
replace v3045 = . if v3045>99999999 // no dicionario, tem opcao 999999998 como NSA. checar na tabulacao para transformar em missing tambem
rename v3045 rend_fam

drop v0360 v0361 v3562 v3563 v3564 v3574 v3604 v3614

recode v0358 (4=3) (5=4) (6=5) (7=6) (8=7) (9=8) (0=9) // 1 a 3 mantidos
replace v0358 = 0 if v0358 == . & trab_ult_12m == 1
rename v0358 cond_ativ
* cond_ativ = 0 trabalhou nos últimos 12 meses
*             1 procurando trabalho - já trabalhou
*             2 procurando trabalho - nunca trabalhou
*             3 aposentado ou pensionista
*             4 vive de renda
*             5 detento
*             6 estudante
*             7 doente ou inválido
*             8 afazeres domésticos
*             9 sem ocupação
drop v0359

gen cond_ativB = cond_ativ
recode cond_ativB (0 = 1)
* cond_ativB = 1 trabalhou nos últimos 12 meses ou procurando trabalho - já trabalhou
*             2 procurando trabalho - nunca trabalhou
*             3 aposentado ou pensionista
*             4 vive de renda
*             5 detento
*             6 estudante
*             7 doente ou inválido
*             8 afazeres domésticos
*             9 sem ocupação

recode cond_ativ (0 2=1) (3/9 =0), copy g(pea)
lab var pea "população economicamente ativa"
* pea	= 1 economicamente ativo
*         0 inativo

/* DEFLACIONANDO RENDAS: julho/2022 */
g double deflator = 0.0000160532976703994
g double conversor = 2750000

lab var deflator "deflator de rendimentos - referência: julho/2022"
lab var conversor "conversor de moedas"

foreach var in rend_ocup_hab rend_outras_ocup rend_outras_fontes rend_total rend_fam  {
		g `var'_def = (`var'/conversor)/deflator
		lab var `var'_def "`var' deflacionada"
}

drop trab_ult_12m
	
/* D.11. VARIÁVEIS DE FECUNDIDADE */
* Em 1970 e 1980, a fecundidade foi investigada para mulheres de 15 anos ou mais;
* A partir de 1991, a idade foi reduzida para 10 anos ou mais

rename v3351 filhos_tot

rename v3352 filhos_hom
rename v3353 filhos_mul

rename v3354 filhos_nasc_vivos
rename v3355 f_nasc_v_hom
rename v3356 f_nasc_v_mul

label var f_nasc_v_hom "filhos nascidos vivos (homens)"
label var f_nasc_v_mul "filhos nascidos vivos (mulheres)"

rename v3360 filhos_vivos
rename v3361 f_vivos_hom
rename v3362 f_vivos_mul

drop v0335 v0336 v0337 v0338 v0339 v0340

rename v3357 filhos_nasc_mortos
rename v0341 f_nasc_m_hom
rename v0342 f_nasc_m_mul

label var f_nasc_m_hom "filhos nascidos mortos (homens)"
label var f_nasc_m_mul "filhos nascidos mortos (mulheres)"

foreach var in filhos_tot filhos_hom filhos_mul filhos_nasc_vivos f_nasc_v_hom ///
	f_nasc_v_mul filhos_vivos f_vivos_hom f_vivos_mul filhos_nasc_mortos ///
	f_nasc_m_hom f_nasc_m_mul {
		replace `var'=. if `var'==99 // no dicionario, tem opcao 100 como NSA. checar na tabulacao para transformar em missing tambem
}


recode v0343 (7 = .) (9 = .) (2=0) // (1=1) // no dicionario, tem opcao 0 como NSA. checar na tabulacao para transformar em missing tambem
rename v0343 sexo_ult_nasc_v
* sexo_ult_nasc_v = 0 feminino
*                 = 1 masculino

recode v3443 (99 = .)
rename v3443 idade_ult_nasc_v // no dicionario, tem opcao 100 como NSA. checar na tabulacao para transformar em missing tambem
label var idade_ult_nasc_v "idade calculada do ultimo filho nascido vivo"
drop v3444

/* OUTRAS */
rename v7301 peso_pess
order ano UF regiao munic id_dom ordem

datazoom_message

end

program define compat_censo91dbf

/* ============================================================ */
/* DROPS                                                        */
/* ============================================================ */
capture drop UFNOM MESONOM MICRONOM MUNICNOM RFAPCAPV

/* ============================================================ */
/* RENAMES - DOMICÍLIO                                          */
/* ============================================================ */
destring UFNUM, replace
capture rename UFNUM    v1101
capture rename MESONUM  v7001
capture rename MICRONUM v7002
capture rename METROP   v7003
capture rename MUNICNUM v1102
capture rename SITSET   v1061

capture rename AGUA     v0205
capture rename ALUGUEFX v2094
capture rename ALUGUEL  v0209
capture rename ASPIRPO  v0227
capture rename AUTPART  v0218
capture rename AUTTRAB  v0219
capture rename BANHEIRO v0213
capture rename CD107    v0109
capture rename COBERTUR v0204
capture rename COMBCOZI v0210
capture rename COMODOR  v0212
capture rename COMODOS  v0211
capture rename CONDOCUP v0208
capture rename DEMOCOFX v2112
capture rename DEMOCOMO v2111
capture rename DEMODOFX v2122
capture rename DEMODORM v2121
capture rename ESPECIE  v0201
capture rename FILTRO   v0216
capture rename FREEZER  v0225
capture rename GELADEIR v0222
capture rename ILUMINA  v0221
capture rename LIXO     v0214
capture rename LOCALIZA v0202
capture rename MAQLAVAR v0226
capture rename PAREDES  v0203
capture rename PESO     v7300
capture rename RADIO    v0220
capture rename RDOMICIV v2012
capture rename RDONOMIF v2013
capture rename RDOREALF v2014
capture rename SANESCOA v0206
capture rename SANUSO   v0207
capture rename TELEFONE v0217
capture rename TVCORES  v0224
capture rename TVPRETO  v0223

/* ============================================================ */
/* RENOMES - FAMÍLIA                                            */
/* ============================================================ */
capture rename ESPFAM   v2011
capture rename NUMFAM   v0304
capture rename RFACHCAF v3044
capture rename RFACHCAV v3043
capture rename RFAMILIV v3045
capture rename RFANOMIF v3046
capture rename RFAPCAPF v3049
capture rename RFAREALF v3047

/* ============================================================ */
/* RENOMES - PESSOAS                                            */
/* ============================================================ */
capture rename APOPENS  v0359
capture rename ATIVIDAD v0347
capture rename ATIVISET v3471
capture rename CARTASS  v0350
capture rename CONPREV  v0353
capture rename DEFICIE  v0311
capture rename EDANOEST v3241
capture rename EDCURSNS v0326
capture rename EDCURSO  v0329
capture rename EDGRAU   v0325
capture rename EDSABELE v0323
capture rename EDSERIE  v0324
capture rename EDULGRAU v0328
capture rename EDULSERI v0327
capture rename EMPESTB  v0351
capture rename FLDOMICH v0335
capture rename FLDOMICM v0336
capture rename FLMORTOH v0339
capture rename FLMORTOM v0340
capture rename FLNAMORH v0341
capture rename FLNAMORM v0342
capture rename FLNAMORT v3357
capture rename FLNAODOH v0337
capture rename FLNAODOM v0338
capture rename FLNAVIVH v3355
capture rename FLNAVIVM v3356
capture rename FLNAVIVT v3354
capture rename FLTIDOSH v3352
capture rename FLTIDOSM v3353
capture rename FLTIDOST v3351
capture rename FLVIVOSH v3361
capture rename FLVIVOSM v3362
capture rename FLVIVOST v3360
capture rename HOROUTR  v0355
capture rename HORTRAB  v0354
capture rename IDADEANO v3072
capture rename IDADEMES v3073
capture rename IDADETIP v3071
capture rename LOCTRAB  v0352
capture rename MIANMOMU v0318
capture rename MIANMOUF v0317
capture rename MIANORES v3152
capture rename MIANTEMU v3191
capture rename MIANTEUF v0319
capture rename MIANTEZN v0320
capture rename MIMO86MU v3211
capture rename MIMO86UF v0321
capture rename MIMO86ZN v0322
capture rename MIMUMOZN v0312
capture rename MINACION v3151
capture rename MINASCMU v0314
capture rename MIUFPAIS v0316
capture rename MIULTMUD v0313
capture rename NORDMAE  v3005
capture rename OCUPACAO v0346
capture rename OCUPAGRP v3461
capture rename PARENDOM v0302
capture rename PARENFAM v0303
capture rename PESSOAN  v0098
capture rename POSOCUP  v0349
capture rename RACACOR  v0309
capture rename RAPOSENF v3604
capture rename RAPOSENV v0360
capture rename RELIGIAO v0310
capture rename ROUTOCUF v3574
capture rename ROUTOCUV v0357
capture rename ROUTRENF v3614
capture rename ROUTRENV v0361
capture rename RPRINCIF v3564
capture rename RPRINCIV v0356
capture rename RTONOMIF v3562
capture rename RTOREALF v3563
capture rename RTOTALPV v3561
capture rename SCATUAL  v3342
capture rename SCDURASC v3341
capture rename SCID1UNI v3311
capture rename SCIDISCA v3312
capture rename SCNAOUNI v0333
capture rename SCNATUNI v0332
capture rename SCVIVCON v0330
capture rename SEXO     v0301
capture rename SITDESO  v0358
capture rename TRUL12M  v0345
capture rename UVIVIDAD v3443
capture rename UVIVIDTP v3444
capture rename UVIVSEXO v0343

/* ============================================================ */
/* VARIÁVEIS GERADAS                                            */
/* ============================================================ */
capture gen v3041 = .
capture gen v3042 = .
capture gen v7004 = .
capture gen v0111 = .
capture gen v0112 = .
capture gen v7301 = v7300


/* ============================================================ */
/* BLOCO DE DOMICÍLIOS                                          */
/* ============================================================ */

/* A. ANO */
* Essa variável é definida antes de chamar este programa.

/* B. IDENTIFICAÇÃO E NÚMERO DE PESSOAS */

/* B.1. IDENTIFICAÇÃO */
rename v1101 UF
drop v1102

capture rename v0102 id_dom

rename v7004 regiao
* regiao = 1 região norte
*          2 região nordeste
*          3 região sudeste
*          4 região sul
*          5 região centro-oeste


drop v7001 v7002 v0109 v7003

	
/* B.2. VARIÁVEIS DE NÚMERO DE PESSOAS */
rename v0111 n_homem_dom
rename v0112 n_mulher_dom
egen n_pes_dom = rowtotal(n_homem_dom n_mulher_dom)
lab var n_pes_dom "número de moradores no domicílio"

/* C. VARIÁVEIS DE DOMICÍLIO*/

/* C.1. SITUAÇÃO */
rename v1061 sit_setor
lab var sit_setor "situação do domicílio - desagregado"
* sit_setor = 1 - Área urbanizada de vila ou cidade
*             2 - Área não urbanizada de vila ou cidade
*             3 - Área urbanizada isolada
*             4 - Rural - extensão urbana
*             5 - Rural - povoado
*             6 - Rural - núcleo
*             7 - Rural - outros aglomerados
*             8 - Rural - exclusive os aglomerados rurais

gen sit_setor_B = sit_setor
recode sit_setor_B (1 2 = 1) (3=2) (4/7 = 3) (8=4)
lab var sit_setor_B "situação do domicílio - agregado"
* sit_setor_B = 1 - Vila ou cidade
*               2 - Urbana isolada
*               3 - Aglomerado rural
*               4 - Rural exclusive os aglomerados

gen sit_setor_C = sit_setor_B
recode sit_setor_C (1 2 = 1) (3 4 = 0)
lab var  sit_setor_C "situação do domicílio - urbano/rural"
* sit_setor_C = 1 - Urbana
*               0 - Rural

/* C.2. ESPÉCIE */
recode v0201 (1=0) (2=1) (3=2)
rename v0201 especie
* especie = 0 - particular permanente
*           1 - particular improvisado
*           2 - coletivo

/* C.3. MATERIAL DAS PAREDES */
rename v0203 paredes
* paredes 	= 1   Alvenaria
*        	= 2   Madeira aparelhada
*        	= 3   Taipa não revestida
*       	= 4   Material aproveitado
*   	    = 5   Palha
*	        = 6   Outro

gen paredes_B = paredes
recode paredes_B (6=5)
* paredes_B	= 1   Alvenaria
*        	= 2   Madeira aparelhada
*        	= 3   Taipa não revestida
*       	= 4   Material aproveitado
*   	    = 5   Outro

/* C.4. MATERIAL DA COBERTURA */
rename v0204 cobertura
*cobertura = 1 laje de concreto
*		   = 2 telha de barro
*		   = 3 telha de amianto
*		   = 4 zinco
*		   = 5 madeira aparelhada
*		   = 6 palha
*		   = 7 material aproveitado
*		   = 8 outro material


/* C.5. TIPO */

* Somente para domicílios particulares permanentes tipo casa ou apt (não cômodo)
gen subnormal = 1 if (v0202 == 3 | v0202 == 6)
replace subnormal = 0 if (v0202 == 1 | v0202 ==2 | v0202 == 4 | v0202 == 5)
lab var subnormal "dummy para setor subnormal"
* subnormal = 0 - não
*             1 - sim

recode v0202 (1/3 = 1) (4/6 = 2) (7=3)
rename v0202 tipo_dom
* tipo_dom = 1 - casa
*            2 - apartamento
*            3 - cômodo

gen tipo_dom_B = tipo_dom
recode tipo_dom_B (3=2)
lab var tipo_dom_B "tipo de domicílio B"
* tipo_dom_B = 1 - casa
*              2 - apartamento (ou cômodo)

/* C.6. CONDIÇÃO DE OCUPAÇÃO E ALUGUEL */
gen terreno_prop = 1 if v0208==1
replace terreno_prop = 0 if v0208==2
lab var terreno_prop "dummy para terreno próprio"
* terreno_prop = 0 - não
*                1 - sim

recode v0208 (2=1) (3=2) (4=3) (5=4) (6=5) // (1=1)
rename v0208 cond_ocup
* cond_ocup = 1 - próprio
*             2 - alugado
*             3 - cedido por empregador
*             4 - cedido de outra forma
*             5 - outra condição

gen cond_ocup_B = cond_ocup
recode cond_ocup_B (4=3) (5=4) // 1 a 3 mantidos
lab var  cond_ocup_B "condição de ocupação B"
* cond_ocup_B = 1 - próprio
*               2 - alugado
*               3 - cedido
*               4 - outra condição

recode v0209 (0 999999=.)
rename v0209 aluguel

* Aluguel em salários mínimos
drop v2094 


/* C.7. ABASTECIMENTO DE ÁGUA */
recode v0205 (1=1) (2=3) (3=5) (4=2) (5=4) (6=5)
rename v0205 abast_agua
* abast_agua = 1 - rede geral com canalização interna
*              2 - rede geral sem canalização interna
*              3 - poço ou nascente com canalização interna
*              4 - poço ou nascente sem canalização interna
*              5 - outra forma


/* C.8. INSTALAÇÕES SANITÁRIAS */
gen sanitario = 0 if v0206 == 0
replace sanitario = 1 if (v0206 >= 1) & (v0206 <= 7)
lab var sanitario "dummy para acesso a sanitário"
* sanitario = 0 - não tem acesso
*                1 - tem acesso

recode v0206 (3=2) (4=3) (5 6 = 4) (7 0 = .) // 1 e 2 mantidos
rename v0206 tipo_esc_san
* tipo_esc_san = 1 - Rede geral
*                2 - Fossa séptica
*                3 - Fossa rudimentar
*                4 - Outro escoadouro

recode v0207 (2=0) // 0 e 1 mantidos
rename v0207 sanitario_ex
label var sanitario_ex "acesso exclusivo a instalação sanitária"
* inst_san_exc = 0 - não tem acesso a inst san exclusiva
*                1 - tem acesso a inst sanitária exclusiva

rename v0213 banheiros
* banheiros = 0 - não tem
*             1 a 4 - número de banheiros
*             5 - cinco ou mais banheiros


/* C.9. DESTINO DO LIXO */
rename v0214 dest_lixo
* dest_lixo = 1 - Coletado por serviço de limpeza
*             2 - Colocado em caçamba de serviço de limpeza
*             3 - Queimado(na propriedade)
*             4 - Enterrado(na propriedade)
*             5 - Jogado em terreno baldio ou logradouro
*             6 - Jogado em rio, lago ou mar
*             7 - Tem outro destino

gen dest_lixo_B = dest_lixo
recode dest_lixo_B (7=6)
* dest_lixo_B = 1 - Coletado no domicílio por serviço de limpeza
*             	2 - Colocado em caçamba de serviço de limpeza
*             	3 - Queimado na propriedade
*             	4 - Enterrado na propriedade
*             	5 - Jogado em terreno baldio, encosta ou área pública
*             	6 - Outro destino

/* C.10. ILUMINAÇÃO ELÉTRICA */
gen medidor_el = 0 if v0221 == 2
replace medidor_el = 1 if v0221 == 1
label var medidor_el "presença de medidor de consumo de eletricidade"
* medidor_el = 0 - não tem
*                1 - tem

recode v0221 (2=1) (3 4 = 0) // (1=1)
rename v0221 ilum_eletr
* ilum_eletr = 0 - não tem
*              1 - tem


/* C.11. BENS DE CONSUMO DURÁVEIS */
generate fogao_ou_fog = 0 if v0210 == 0
replace fogao_ou_fog = 1 if (v0210 >= 1) & (v0210 <= 6)
label var fogao_ou_fog "fogão ou fogareiro"
* fogao_ou_fog = 0 - não tem
*                1 - tem

recode v0210 (2 4 = 1) (3=2) (5=3) (6=4) // 0 e 1 mantidos
rename v0210 comb_fogao
* comb_fogao = 1 - gás
*                2 - lenha
*                3 - carvão
*                4 - outro
*                0 - não tem fogão nem fogareiro

rename v0220 radio
* radio = 0 - não tem
*         1 - tem

recode v0222 (2=1) // 0 e 1 mantidos
rename v0222 geladeira
* geladeira = 0 - não tem
*             1 - tem

gen gelad_ou_fre = 0 if (geladeira == 0) & (v0225 == 0)
replace gelad_ou_fre = 1 if (geladeira == 1) | (v0225 == 1)
lab var gelad_ou_fre "geladeira ou freezer"
* gelad_ou_fre = 0 - não tem
*                1 - tem
drop v0225

recode v0217 (2 = 1)
rename v0217 telefone
* telefone = 0 - não tem
*            1 - tem

rename v0223 tv_pb
recode v0224 (2 3 = 1) // 0 e 1 mantidos
rename v0224 tv_cores

gen televisao = 0 if tv_pb == 0 & tv_cores == 0
replace televisao = 1 if (tv_pb == 1) | (tv_cores == 1)
lab var televisao "televisão"
* televisao, tv_pb, tv_cores = 0 - não tem
*                              1 - tem

recode v0218 (2 3 = 1) // 0 e 1 mantidos
rename v0218 automov_part
gen automovel = 0 if automov_part == 0
replace automovel = 1 if (automov_part == 1) | (v0219 == 1) | (v0219 == 2)
lab var automovel "automóvel"
* automovel, automov_part = 0 - não tem
*                           1 - tem

* Quesito automóvel para trabalho pesquisado só em 1991
drop v0219

rename v0226 lavaroupa
* lavaroupa 0 - não tem
*			1 - tem

drop v0216 v0227


/* C.12. NÚMERO DE CÔMODOS */
rename v0211 tot_comodos
rename v0212 tot_dorm

drop v2111 v2112 v2121 v2122


/* C.13. RENDA DOMICILIAR */
replace v2012 = . if v2012>10^8
rename v2012 renda_dom

drop v2013 v2014

/* DEFLACIONANDO RENDAS: julho/2022 */
g double deflator = 0.0000160532976703994
g double conversor = 2750000

lab var deflator "deflator de rendimentos - referência: julho/2022"
lab var conversor "conversor de moedas"

g renda_dom_def = (renda_dom/conversor)/deflator
lab var renda_dom_def "renda_dom deflacionada"

g aluguel_def = (aluguel/conversor)/deflator
lab var aluguel_def "aluguel deflacionada"


/* C.14. PESO AMOSTRAL */
rename v7300 peso_dom
  

/* ============================================================ */
/* BLOCO DE PESSOAS                                          */
/* ============================================================ */

rename v0098 ordem

* renda do casal
drop v3043 v3044 v3046- v3049 

* numero de ordem da mae
drop v3005

/* B.2. VARIÁVEIS DE NÚMERO DE PESSOAS */
rename v3041 n_homem_fam
rename v3042 n_mulher_fam
egen n_pes_fam = rowtotal(n_homem_fam n_mulher_fam)
lab var n_pes_fam "número de pessoas na família"
* Pessoas no domicílio: não disponível no registro de pessoas.


/* D. OUTRAS VARIÁVEIS PESSOA */

/* D.1. SEXO */
recode v0301 (2=0) // (1=1)
rename v0301 sexo
* sexo = 0 - feminino
*        1 - masculino

/* D.2. CONDIÇÃO NA FAMÍLIA E NO DOMICÍLIO */
recode v0302 (3 4 = 3) (5 6 = 4) (8=5) (10=6) (7 9 11 12 = 7) (13=8) /// (1=1) (2=2)
             (14=9) (15=10) (16=11) (20=12)
rename v0302 cond_dom
* cond_dom =  1 - Pessoa responsável
*                 2 - Cônjuge, companheiro(a)
*                 3 - Filho(a), enteado(a)
*                 4 - Pai, mãe, sogro(a)
*                 5 - Neto(a), bisneto(a)
*                 6 - Irmão, irmã
*                 7 - Outro parente
*                 8 - Agregado(a)
*                 9 - Pensionista
*                10 - Empregado(a) doméstico(a)
*                11 - Parente do(a) empregado(a) doméstico(a)
*                12 - Individual em domicílio coletivo

recode v0303 (3 4 = 3) (5 6 = 4) (8=5) (10=6) (7 9 11 12 = 7) (13=8) /// (1=1) (2=2)
             (14=9) (15=10) (16=11) (20=12)
rename v0303 cond_fam
* cond_fam =  1 - Pessoa responsável
*                 2 - Cônjuge, companheiro(a)
*                 3 - Filho(a), enteado(a)
*                 4 - Pai, mãe, sogro(a)
*                 5 - Neto(a), bisneto(a)
*                 6 - Irmão, irmã
*                 7 - Outro parente
*                 8 - Agregado(a)
*                 9 - Pensionista
*                10 - Empregado(a) doméstico(a)
*                11 - Parente do(a) empregado(a) doméstico(a)
*                12 - Individual em domicílio coletivo

gen cond_dom_B = cond_dom
recode cond_dom_B (5/7 = 5) (8=6) (9=7) (10=8) (11=9) (12=10) // 1 a 4 mantidos
lab var cond_dom_B "relação com o responsável do domicílio B"

gen cond_fam_B = cond_fam
lab var cond_fam_B "relação com o responsável da família B"
recode cond_fam_B (5/7 = 5) (8=6) (9=7) (10=8) (11=9) (12=10) // 1 a 4 mantidos
* cond_***_B =  1 - Pessoa responsável
*               2 - Cônjuge, companheiro(a)
*               3 - Filho(a), enteado(a)
*               4 - Pai, mãe, sogro(a)
*               5 - Outro parente
*               6 - Agregado
*               7 - Hóspede, pensionista
*               8 - Empregado(a) doméstico(a)
*               9 - Parente do(a) empregado(a) doméstico(a)
*              10 - Individual em domicílio coletivo

recode v0304 (2=0) (3=1) (4=2) (5=3) (6=4) (7=5) // 1 mantido
rename v0304 num_fam

* tipo de familia
drop v2011 // só em 1991

/* D.3. IDADE */
recode v3071 (2=0) // (1=1)
rename v3071 idade_presumida
* idade_presumida = 0 - não
*                   1 - sim

rename v3072 idade
rename v3073 idade_meses

/* D.4. COR OU RAÇA */
recode v0309 (9=.)
rename v0309 raca
* raca = 1 - branca
*        2 - preta
*        3 - amarela
*        4 - parda
*        5 - indígena

gen racaB = raca
recode racaB (5=4) // 1 a 4 mantidos
lab var racaB "cor ou raça (indígena=pardo)"
* racaB = 1 - branca
*         2 - preta
*         3 - amarela
*         4 - parda

/* D.5. RELIGIÃO */
recode v0310 (11=1) (21/30 = 2) (31/41 45 = 3) (61=4) (62 63 = 5) (75 76 77 79 = 6) ///
             (71=7) (49 51 52 53 59 81 82 83 84 12 13 19 = 8) (85 86 89 99 = .) // 19 nao tem no dicionario: confirmar tabulacao.
rename v0310 religiao
* religiao = 0 - sem religião
*            1 - católica
*            2 - evangélica tradicional
*            3 - evangélica pentecostal
*            4 - espírita kardecista
*            5 - espírita afro-brasileira
*            6 - religiões orientais
*            7 - judaica/israelita
*            8 - outras religiões

gen religiao_A = religiao
recode religiao_A (3 = 2) (4 = 3) (5 = 4) (6 = 5) (7 = 6) (8 = 7)
lab var religiao_A "religião A - mais agregada"
* religiao_A = 0 - sem religião
*            1 - católica
*            2 - evangélica
*            3 - espírita kardecista
*            4 - espírita afro-brasileira
*            5 - religiões orientais
*            6 - judaica/israelita
*            7 - outras religiões

gen religiao_B = religiao
recode religiao_B (3=2) (4 5 = 3) (6/8 = 4)
lab var religiao_B "religião B - mais agregada"
* religiao_B = 0 - sem religião
*              1 - católica
*              2 - evangélica
*              3 - espírita
*              4 - outra

/* D.6. DEFICIÊNCIAS FÍSICA E MENTAL */
* foi retirado da compatibilizacao porque o item é analisada em uma única
* pergunta, diferentemente dos anos subsequentes
drop v0311

/* D.7. NATURALIDADE E MIGRAÇÃO */

*** Condição de migrante
gen sempre_morou = 0 if (v0314 == 2 | v0314 == 3)
replace sempre_morou = 1 if v0314 == 1
label var sempre_morou "Sempre morou neste município"
* sempre_morou = 0 - não
*                1 - sim

recode v0312 (1=0) (2=1) (3=2)
rename v0312 onde_morou
* onde_morou = 0 só na zona urbana
*                1 só na zona rural
*                2 nas zonas urbana e rural

* O quesito abaixo só é pesquisado em 1991.
drop v0313

*** Nacionalidade e naturalidade
recode v0314 (3=0) (2=1) // (1=1)
rename v0314 nasceu_mun
label var nasceu_mun "Nasceu neste município"
* nasceu_mun = 0 não
*              1 sim


recode v3151 (1=0) (2=1) (3=2)
replace v3151 = 0 if nasceu_mun==1
rename v3151 nacionalidade
* nacionalidade = 0 - brasileiro nato
*                 1 - brasileiro naturalizado
*                 2 - estrangeiro

replace v3152 = . if nacionalidade == 0 // originalmente ambíguo: bras nato ou
										// estrangeiro que fixou res até 1900
replace v3152 = 1900 + v3152 if (v3152 >= 0 & v3152 <= 91)
rename v3152 ano_fix_res

gen UF_nascim = v0316
replace UF_nascim = . if (v0316 >= 30 & v0316 != .)
recode UF_nascim (1=11) (2=12) (3=13) (4=14) (5=15) (6=16) (7=17) (8=21) (9=22) (10=23) ///
				 (11=24) (12=25) (13=26) (14=27) (15=28) (16=29) (17=31) (18=32) (19=33) ///
				 (20=35) (21=41) (22=42) (23=43) (24=50) (25=51) (26=52) (27=53) (29=.)
*	replace UF_nascim = UF if nasceu_mun==1
label var UF_nascim "UF de nascimento"
* UF_nascim = 11-53 UF de nascimento especificada

gen nasceu_UF = 0
replace nasceu_UF = 1 if UF_nascim == UF | nasceu_mun==1
label var nasceu_UF "Nasceu nesta UF"
* nasceu_UF = 0 não
*             1 sim

recode v0316 (1/29 99 = .)	///
	(82 84 85 = 83 )	///
	(83 = 82 )	///
	(86 87=84 ) ///
	(88=86 ) ///
	(89=87 ) ///
	(90=88 ) ///
	(91=89 ) ///
	(92=90 ) ///
	(93=91 ) ///
	(94=92 ) ///
	(95=93 ) ///
	(96=94 ) ///   
	(97=95 ) ///
	(98=96 ), copy g(pais_nascim)
* pais_nascim = 30-98 país estrangeiro especificado
* 83 = Africa - outros  
* 82 = Egito	
* 84 = China 
* 86 = Coréia 
* 87 = Índia 
* 88 = Israel 
* 89 = Japão 
* 90 = Líbano 
* 91 = Paquistão 
* 92 = Síria 
* 93 = Turquia 
* 94 = Ásia - outros 
* 95 = Australia
* 96 = Oceania
label var pais_nascim "País de nascimento - códigos 1970"
* pais_nascim = 30-98 país estrangeiro especificado
drop v0316

*** Última migração

rename v0317 anos_mor_UF
rename v0318 anos_mor_mun

* em 1970, somente quem não nasceu no município responde às questões de tempo de moradia
g t_mor_UF_70 = anos_mor_UF
g t_mor_mun_70 = anos_mor_mun
recode t_mor_UF_70 t_mor_mun_70 (7/10=6) (11/max=7)

lab var t_mor_UF_70 "tempo de moradia na UF - grupos de 1970"
lab var t_mor_mun_70 "tempo de moradia no municipio - grupos de 1970"

* De 1980 em diante, podemos montar a variavel de tempo de moradia incluindo
* pessoas que nasceram mas nem sempre moraram no municipio em que residem
recode anos_mor_UF (7/9 =6) (10/max =7), g(t_mor_UF_80)
recode anos_mor_mun (7/9 =6) (10/max =7), g(t_mor_mun_80)
lab var t_mor_UF_80 "tempo de moradia na UF - grupos de 1980"
lab var t_mor_mun_80 "tempo de moradia no municipio - grupos de 1980"

*** Onde morava anteriormente - para quem migrou nos últimos 10 anos:
gen pais_mor_ant = v3191 if v0319 == 80
recode pais_mor_ant (0/29 99=.)	///
	(82 84 85 = 83 )	///
	(83 = 82 )	///
	(86 87=84 ) ///
	(88=86 ) ///
	(89=87 ) ///
	(90=88 ) ///
	(91=89 ) ///
	(92=90 ) ///
	(93=91 ) ///
	(94=92 ) ///
	(95=93 ) ///
	(96=94 ) ///   
	(97=95 ) ///
	(98=96 )
label var pais_mor_ant "País onde morava anteriormente (se migrou nos últ 10 anos)"
* pais_mor_ant = 30-98 país estrangeiro especificado

gen long mun_mor_ant = 10000*v0319 + v3191 if v0319 <= 53
label var mun_mor_ant "Município onde morava ant (se migrou nos últ 10 anos)"

recode v0319 (0 54 80 99=.)
rename v0319 UF_mor_ant
label var UF_mor_ant "UF onde morava anteriormente (se migrou nos últ 10 anos)"
* UF_mor_ant = 11-53 código da UF em que morava

drop v3191

recode v0320 (9=.) (2=0) // (1=1) // no dicionario, tem opcao 0 como NSA. checar na tabulacao para transformar em missing tambem
rename v0320 sit_mun_ant
* sit_mun_ant = 1 zona urbana
*               0 zona rural

*** Local de residência há 5 anos:
gen pais_mor5anos = v3211 if v0321 == 80
recode pais_mor5anos (0/29 99=.)	///
	(82 84 85 = 83)	///
	(83 = 82)	///
	(86 87=84) ///
	(88=86) ///
	(89=87) ///
	(90=88) ///
	(91=89) ///
	(92=90) ///
	(93=91) ///
	(94=92) ///
	(95=93) ///
	(96=94) ///   
	(97=95) ///
	(98=96)
label var pais_mor5anos "País onde morava há 5 anos"
* pais_mor5anos = 30-98 código de país/região estrangeiro(a)

gen long mun_mor5anos = 10000*v0321 + v3211 if v0321 <= 53
label var mun_mor5anos "Município onde morava há 5 anos"
drop v3211

recode v0321 (54 70 80 99=.) // 70 é não-migrante
rename v0321 UF_mor5anos
label var UF_mor5anos "UF onde morava há 5 anos"
* UF_mor5anos = 11-53 código de UF em que morava

recode v0322 (2=0) (9=.) // (1=1) // no dicionario, tem opcao 0 como NSA. checar na tabulacao para transformar em missing tambem
replace v0322 =. if pais_mor5anos~=.
rename v0322 sit_dom5anos
label var sit_dom5anos "Situação do domicílio onde morava há 5 anos"
* sit_dom5anos = 1 zona urbana
*                0 zona rural

/* D.8. EDUCAÇÃO */
recode v0323 (2=0) // (1=1) // no dicionario, tem opcao 0 como NSA. checar na tabulacao para transformar em missing tambem
rename v0323 alfabetizado
* alfabetizado = 0 - não
*                1 - sim

gen freq_escola = 0     if idade >= 5
replace freq_escola = 1 if (idade >= 5) & (v0325 ~= 0) // frequenta curso seriado
replace freq_escola = 1 if (idade >= 5) & ((v0326>=2 & v0326<=4) | v0326==6) // frequenta curso não-seriado
lab var freq_escola "frequenta escola"

gen freq_escolaB = freq_escola
replace freq_escolaB = 1 if v0326 == 1 // inclui pré-escola
lab var freq_escolaB "frequenta escola - inclui pré-escola"


* Anos de estudo - cálculo do IBGE
recode v3241 (20 = .) (17=16) (30 = 0) // 20 é "indefinido"; lim em 16 pois é máximo em 1970  // no dicionario, tem opcao 31 como NSA. checar na tabulacao para transformar em missing tambem
rename v3241 anos_estudo
* anos_estudo = 0      - Sem instrução ou menos de 1 ano
*               1 a 15 - Número de anos
*               16     - 16 anos ou mais


* Anos de estudo "B" - nível de escolaridade associado à série atualmente cursada

* Para quem não freqüenta, usamos anos_estudo:
gen anos_estudoB = anos_estudo if freq_escola == 0
lab var anos_estudoB "anos de estudo - associado à série atualmente cursada"

* Frequentando cursos não seriados:
replace anos_estudoB = 0  if (freq_escola == 1) & (v0326 >= 1) & (v0326 <= 2) // pré-escola, alfabetização de adultos
* Na situaçao abaixo, supletivo de 1o grau, IBGE tem optado por considerar nível "indefinido"
*replace anos_estudoB = 0  if (freq_escola == 1) & (v0326 == 3) // suplet 1o grau
replace anos_estudoB = 8  if (freq_escola == 1) & (v0326 == 4) // suplet 2o grau
replace anos_estudoB = 11 if (freq_escola == 1) & (v0326 == 5) // pré-vestibular
replace anos_estudoB = 15 if (freq_escola == 1) & (v0326 == 6) // mestrado ou doutorado

* Frequentando cursos seriados:
replace anos_estudoB = v0324 - 1  if (freq_escola == 1) & (v0324 >= 1) & (v0324 <= 8) & ((v0325 == 1) | (v0325 == 4)) // 1o grau reg ou supletivo
replace anos_estudoB = v0324 + 7  if (freq_escola == 1) & (v0324 >= 1) & (v0324 <= 3) & ((v0325 == 2) | (v0325 == 5)) // 2o grau reg ou supletivo
replace anos_estudoB = 10         if (freq_escola == 1) & (v0324 >= 4) & (v0324 <= 8) & ((v0325 == 2) | (v0325 == 5)) // não terminou médio, não pode receber 11 anos
replace anos_estudoB = v0324 + 10 if (freq_escola == 1) & (v0324 >= 1) & (v0324 <= 5) & (v0325 == 3)                  // superior
replace anos_estudoB = 15         if (freq_escola == 1) & (v0324 >= 6) & (v0324 <= 8) & (v0325 == 3)                  // atribuo no máx 15 anos p/ superior incompleto

* Gupos de Anos de Estudo
* para quem frequenta escola
recode anos_estudoB (min/3 = 0) (4/7 = 1) (8/10 = 2) (11/14 = 3) (15/max = 4), g(anos_estudoC)
replace anos_estudoC = . if freq_escola==0
replace anos_estudoC = 0 if freq_escola==1 & v0326 == 3		// suplet 1o grau
replace anos_estudoC = 3 if freq_escola==1 & v0325==3 & anos_estudoC==4 	// superior sem conclusao

* para quem nao frequenta escola
replace anos_estudoC = 0 if freq_escola==0 & (v0328==1 | v0328==0) 	// alfabetizacao de adultos/nenhum
replace anos_estudoC = 0 if freq_escola==0 & v0328==2 	// primario
replace anos_estudoC = 0 if freq_escola==0 & v0328==4 & v0327>=1 & v0327<=3 	// 1a-3a serie 1o.grau
replace anos_estudoC = 1 if freq_escola==0 & v0328==4 & v0327>=4 & v0327<=8 	// 4a-8a serie 1o.grau

replace anos_estudoC = 1 if freq_escola==0 & v0328==2 & v0329>=1 & v0329<=8	// primario com conclusao
replace anos_estudoC = 1 if freq_escola==0 & v0328==3 	// ginasio/medio 1o.ciclo
replace anos_estudoC = 2 if freq_escola==0 & v0328==3 & v0329>=10 & v0329<=23 // ginasio/medio 1o.ciclo com conclusao

replace anos_estudoC = 2 if freq_escola==0 & v0328==4 & v0327>=4 & v0327<=8 & v0329>=10 & v0329<=23	// 4a-8a serie 1o.grau com conclusao
replace anos_estudoC = 2 if freq_escola==0 & v0328==5 	// 2o.grau
replace anos_estudoC = 2 if freq_escola==0 & v0328==6 	// colegiaa/medio 2o.ciclo

replace anos_estudoC = 3 if freq_escola==0 & v0328==5 & v0329>=24 & v0329<=42		// 2o.grau com conclusao
replace anos_estudoC = 3 if freq_escola==0 & v0328==6 & v0329>=24 & v0329<=42		// colegiaa/medio 2o.ciclo com conclusao
replace anos_estudoC = 3 if freq_escola==0 & v0328==7 	// superior

replace anos_estudoC = 4 if freq_escola==0 & v0328==7 & v0329>=43 & v0329<=97	// superior com conclusao
replace anos_estudoC = 4 if freq_escola==0 & v0328==8 	// mestrado/doutorado

lab var anos_estudoC "grupo de anos de escolaridade"

* anos_estudoC = 0 – sem instrução ou menos de 3 anos de estudo (primário incompleto)
*                1 – de 4 a 7 (fundamental/ ginásio/ 1º. Grau/ médio primeiro ciclo incompleto)
*				 2 – de 8 a 10 (médio/ 2º. Grau/ médio segundo ciclo incompleto)
*			 	 3 – de 11 a 14 (médio/ 2º. Grau/ médio segundo ciclo completo ou superior incompleto)
*			 	 4 – 15 ou mais (superior completo, mestrado, doutorado)

drop v0324- v0328

recode v0329 (1/8 = .) ///
		 (10/42 = .) ///
		 (72/77 80/83 93 94 96 = 3) ///
		 (43/49 65 86 87 = 4) ///
		 (50/63 88 89 = 5) ///
		 (64 66 90 = 6) ///
		 (67/71 78 79 91 92 = 7) ///
		 (84 = 8) ///
		 (85 95 97 = 9)	///
		 (0 = .), g(cursos_c1) 
lab var cursos_c1 "curso superior concluído"
* cursos_c1	=	3	ciências humanas
*				4	ciências biológicas
*				5	ciências exatas
*				6	ciências agrárias
*				7	ciências sociais
*				8	militar
*				9	outros cursos

recode v0329 (1/42 = .) /// 
		 (77 94 = 1) ///
		 (74/76 80/83 96 = 2) ///
		 (67/73 78 79 91/93 = 3) ///
		 (43 51 52 58/62 87 89 = 4) ///
		 (50 53/57 63 88 = 5) ///
		 (64/66 90 = 6) ///
		 (44/49 86 = 7) ///
		 (84 = 8) ///
		 (85 95 97 = 9)	///
		 (0 = .), g(cursos_c2)
lab var cursos_c2 "curso superior concluído - CONCLA"
* cursos_c2 =	1	Educação
*				2	Artes, Humanidades e Letras
*				3	Ciências Sociais, Administração e Direito
*				4	Ciências, Matemática e Computação
*				5	Engenharia, Produção e Construção
*				6	Agricultura e Veterinária
*				7	Saúde e Bem-Estar Social    
*				8	militar
*				9	Outros

rename v0329 curso_concl	// COMP SO PARA CURSO SUPERIOR
* curso_concl = 00 nenhum curso
*             = 01-97 curso concluído

/* D.9. SITUAÇÃO CONJUGAL */

recode v0330 (2 = 0)  // no dicionario, tem opcao 0 como NSA. checar na tabulacao para transformar em missing tambem
rename v0330 teve_conjuge
* teve_conjuge = 0 não
*              = 1 sim

gen vive_conjuge = 1 if (v3342 >= 1 & v3342 <= 3)
replace vive_conjuge = 0 if v3342 == 4 | v3342 == 5
label var vive_conjuge "vive com cônjuge"
* vive_conjuge = 0 - não
*                1 - sim
drop v3342

gen estado_conj = v0332 if (v0332 >= 1 & v0332 <=4)
replace estado_conj = v0333 + 1 if (v0333 >= 5 & v0333 <= 8)
replace estado_conj = 5 if teve_conjuge== 0
label var estado_conj "estado conjugal"
* estado_conj = 1 casamento civil e religioso
*               2 só casamento civil
*               3 só casamento religioso
*               4 união consensual
*               5 solteiro
*               6 separado(a)
*               7 desquitado(a)/separado(a) judicialmente
*               8 divorciado(a)
*               9 viúvo(a)

gen estado_conj_B = estado_conj
recode estado_conj_B (7 8 9 = 6)
label var estado_conj_B "estado conjugal B - mais agregado"
* estado_conj_B = 1 casamento civil e religioso
*                 2 só casamento civil
*                 3 só casamento religioso
*                 4 união consensual
*                 5 solteiro
*                 6 outros: separado(a) OU desquitado(a)/separado(a) judicialmente OU divorciado(a) OU viúvo(a)
drop v0332 v0333

drop v3311 v3312 v3341


/* D.10. RENDA E ATIVIDADE ECONÔMICA */

recode v0345 (2=1) (3=0) // (1=1)
rename v0345 trab_ult_12m
*trab_ult_12m = 0 não
*               1 sim

rename v0346 ocup_hab

rename v3461 grp_ocup_hab
* grp_ocup_hab =  1 administrativas
*                 2 técnicas, científicas, artísticas e assemelhadas
*                 3 agropecuária e da produção extrativa vegetal e animal
*                 4 produção extrativa mineral
*                 5 indústrias de transformação e construção civil
*                 6 comércio e atividades auxiliares
*                 7 transportes e comunicações
*                 8 prestação de serviços
*                 9 defesa nacional e segurança pública
*                10 outras ocupações, ocupações mal definidas ou não declaradas

rename v0347 ativ_hab

rename v3471 set_ativ_hab
* set_ativ_hab =  1 atividades agropecuárias, de extração vegetal e pesca
*                 2 indústria de transformação
*                 3 indústria da construção civil
*                 4 outras atividades industriais (extração mineral e serviços
*                   industriais de utilidade pública)
*                 5 comércio de mercadorias
*                 6 transporte e comunicação
*                 7 serviços auxiliares da atividade econômica (técnico-profissionais
*                   e auxiliares das atividades econômicas)
*                 8 prestação de serviços (alojamento e alimentação, reparação e
*                   conservação, pessoais, domiciliares e diversões)
*                 9 social(comunitárias, médicas, odontológicas e ensino)
*                10 administração pública, defesa nacional e segurança pública
*                11 outras atividades (instituições de crédito, seguros e
*                   capitalização, comércio e administração de imóveis e valores
*                   mobiliários, organizações internacionais e representações
*                   estrangeiras, atividades não compreendidas nos demais ramos e
*                   atividades mal definidas ou não declaradas)

recode v0349 (7 8 = 6) (9=7) (10=8) (11=0) // 1 a 6 mantidos
rename v0349 pos_ocup_hab
* pos_ocup_hab = 0 sem remuneração
*                1 trabalhador agrícola volante
*                2 parceiro ou meeiro - empregado
*                3 parceiro ou meeiro - autônomo ou conta-própria
*                4 trabalhador doméstico - empregado
*                5 trabalhador doméstico - autônomo ou conta-própria
*                6 empregado
*                7 autônomo ou conta-própria
*                8 empregador

recode pos_ocup_hab (1 =4) (2 3 =1) (4 =2) (5 =3) (6 =4) (7 =5) (8 =6), copy gen(pos_ocup_habB) 
lab var pos_ocup_habB "Posição na ocupação habitual - agregada"
* pos_ocup_habB = 0 sem remuneração
*                 1 parceiro ou meeiro 
*                 2 trabalhador doméstico - empregado
*                 3 trabalhador doméstico - autônomo ou conta-própria
*                 4 empregado
*                 5 autônomo ou conta-própria
*                 6 empregador

drop v0350 v0351 v0352

recode v0353 (2 = .) (3 = 0)
rename v0353 previd_A
* previd = 0 não
*          1 sim

gen hrs_oc_hab = 1 if v0354 < 15
replace hrs_oc_hab = 2 if (v0354 >= 15) & (v0354 < 30)
replace hrs_oc_hab = 3 if (v0354 >= 30) & (v0354 < 40)
replace hrs_oc_hab = 4 if (v0354 >= 40) & (v0354 < 49)
replace hrs_oc_hab = 5 if (v0354 >= 49) & v0354~=.
lab var hrs_oc_hab "horas trabalhadas p/semana - ocup hab"
* hrs_oc_hab = 1 - menos de 15 horas
*              2 - de 15 a 29 horas
*              3 - de 30 a 39 horas
*              4 - de 40 a 48 horas
*              5 - 49 horas ou mais

gen hrs_oc_habB = 1 if v0354 < 15
replace hrs_oc_habB = 2 if (v0354 >= 15) & (v0354 < 40)
replace hrs_oc_habB = 3 if (v0354 >= 40) & (v0354 < 50)
replace hrs_oc_habB = 4 if (v0354 >= 50) & v0354~=.
replace hrs_oc_habB = . if set_ativ_hab==1
lab var hrs_oc_habB "horas trabalhadas p/semana B - ocup hab - exclusive agropec"
* hrs_oc_habB = 1 - menos de 15 horas
*               2 - de 15 a 39 horas
*               3 - de 40 a 49 horas
*               4 - 50 horas ou mais

gen hrs_oc_habC = hrs_oc_habB
recode hrs_oc_habC (4=3) // 1 a 3 mantidos
lab var hrs_oc_habC "horas trabalhadas p/semana C - ocup hab - exclusive agropec"
* hrs_oc_habC = 1 - menos de 15 horas
*               2 - de 15 a 39 horas
*               3 - 40 horas ou mais

egen hrs_todas_oc = rowtotal(v0354 v0355)
recode hrs_todas_oc (min/14=1) (15/29=2) (30/39=3) (40/48=4) (49/max=5)
lab var hrs_todas_oc "horas de trabalho p/semana em todas as ocupações"

drop v0354 v0355

recode v0356 (0 9999999=.) // no dicionario, tem opcao 9999998 como NSA. checar na tabulacao para transformar em missing tambem
rename v0356 rend_ocup_hab

recode v0357 (0 9999999=.) // no dicionario, tem opcao 9999998 como NSA. checar na tabulacao para transformar em missing tambem
rename v0357 rend_outras_ocup

recode v0360 (9999999=.) // no dicionario, tem opcao 9999998 como NSA. checar na tabulacao para transformar em missing tambem
recode v0361 (9999999=.) // no dicionario, tem opcao 9999998 como NSA. checar na tabulacao para transformar em missing tambem
egen rend_outras_fontes = rowtotal(v0360 v0361)
lab var rend_outras_fontes "rendimento de outras fontes"

recode v3561 (99999999=.) // rendimento total tem 1 dígito a mais // no dicionario, tem opcao 99999998 como NSA. checar na tabulacao para transformar em missing tambem
rename v3561 rend_total
lab var rend_total "total de rendimentos"

* renda familiar
replace v3045 = . if v3045>99999999 // no dicionario, tem opcao 999999998 como NSA. checar na tabulacao para transformar em missing tambem
rename v3045 rend_fam

drop v0360 v0361 v3562 v3563 v3564 v3574 v3604 v3614

recode v0358 (4=3) (5=4) (6=5) (7=6) (8=7) (9=8) (0=9) // 1 a 3 mantidos
replace v0358 = 0 if trab_ult_12m == 1
rename v0358 cond_ativ
* cond_ativ = 0 trabalhou nos últimos 12 meses
*             1 procurando trabalho - já trabalhou
*             2 procurando trabalho - nunca trabalhou
*             3 aposentado ou pensionista
*             4 vive de renda
*             5 detento
*             6 estudante
*             7 doente ou inválido
*             8 afazeres domésticos
*             9 sem ocupação
drop v0359

recode cond_ativ (0 2=1) (3/9 =0), copy g(pea)
lab var pea "população economicamente ativa"
* pea	= 1 economicamente ativo
*         0 inativo


foreach var in rend_ocup_hab rend_outras_ocup rend_outras_fontes rend_total rend_fam  {
		g `var'_def = (`var'/conversor)/deflator
		lab var `var'_def "`var' deflacionada"
}

drop trab_ult_12m
	
/* D.11. VARIÁVEIS DE FECUNDIDADE */
* Em 1970 e 1980, a fecundidade foi investigada para mulheres de 15 anos ou mais;
* A partir de 1991, a idade foi reduzida para 10 anos ou mais

rename v3351 filhos_tot

rename v3352 filhos_hom
rename v3353 filhos_mul

rename v3354 filhos_nasc_vivos
rename v3355 f_nasc_v_hom
rename v3356 f_nasc_v_mul

label var f_nasc_v_hom "filhos nascidos vivos (homens)"
label var f_nasc_v_mul "filhos nascidos vivos (mulheres)"

rename v3360 filhos_vivos
rename v3361 f_vivos_hom
rename v3362 f_vivos_mul

drop v0335 v0336 v0337 v0338 v0339 v0340

rename v3357 filhos_nasc_mortos
rename v0341 f_nasc_m_hom
rename v0342 f_nasc_m_mul

label var f_nasc_m_hom "filhos nascidos mortos (homens)"
label var f_nasc_m_mul "filhos nascidos mortos (mulheres)"

foreach var in filhos_tot filhos_hom filhos_mul filhos_nasc_vivos f_nasc_v_hom ///
	f_nasc_v_mul filhos_vivos f_vivos_hom f_vivos_mul filhos_nasc_mortos ///
	f_nasc_m_hom f_nasc_m_mul {
		replace `var'=. if `var'==99 // no dicionario, tem opcao 100 como NSA. checar na tabulacao para transformar em missing tambem
}


recode v0343 (7 = .) (9 = .) (2=0) // (1=1) // no dicionario, tem opcao 0 como NSA. checar na tabulacao para transformar em missing tambem
rename v0343 sexo_ult_nasc_v
* sexo_ult_nasc_v = 0 feminino
*                 = 1 masculino

recode v3443 (99 = .)
rename v3443 idade_ult_nasc_v // no dicionario, tem opcao 100 como NSA. checar na tabulacao para transformar em missing tambem
label var idade_ult_nasc_v "idade calculada do ultimo filho nascido vivo"
drop v3444

/* OUTRAS */
rename v7301 peso_pess
order ano UF regiao munic id_dom ordem

datazoom_message

end
