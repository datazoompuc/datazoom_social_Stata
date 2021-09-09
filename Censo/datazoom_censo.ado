******************************************************
*					datazoom_censo.ado				 *
******************************************************
* version 1.4
program define datazoom_censo

syntax, years(numlist) ufs(str) original(str) saving(str) [comp pes fam dom both all english]

if "`english'" != "" local lang "_en"

* `years' é lista de anos a extrair 
* `ufs' são as unidades da federação
* `original' são as pastas dos arquivos de microdados brutos
* `saving' é a pasta para salvar as novas bases
* `comp' especifica que será feita a compatibilização.
* `pes' indica arquivo de pessoas
* `dom' indica arquivo de domicilios
* `fam' indica arquivo de família disponível apenas para o ano 2000
* `both' indica arquivo de domicilios e pessoas merged
* `all' indica arquivo de domicilios, pessoas e família merged para o ano 2000
 
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

/* Listas de nomes das UFs (como são passados na opção `ufs'), respectivos códigos IBGE */
/* e sufixos dos arquivos de microdados correspondentes em cada ano.                    */
local nomesUFs =  "RO AC AM RR PA AP TO FN MA PI CE RN PB PE AL SE BA MG ES RJ GB SP PR SC RS MS MT GO DF"
local codUFs   =  "11 12 13 14 15 16 17 20 21 22 23 24 25 26 27 28 29 31 32 33 34 35 41 42 43 50 51 52 53"
local suf1970  = `"RO AC AM RR PA AP "" FN MA PI CE RN PB PE AL SE BA MG ES RJ GB SP PR SC RS "" MT GO DF"'
*local suf1980  = `"11 12 13 14 15 16 "" "" 20 21 22 23 24 25 26 27 28 29 "31A 31B" 32 "33A 33B" "" "35 35B 35C" 41 42 43 50 51 52 53"'
local suf1980  =  `"RO AC AM RR PA AP "" FN MA PI CE RN PB PE AL SE BA MG ES RJ "" SP PR SC RS MS MT GO DF"'
local suf1991  = `"U11 U12 U13 U14 U15 U16 U17 "" U21 U22 U23 U24 U25 U26 U27 U28 U29 U31 U32 U33 "" "P35 P36" U41 U42 U43 U50 U51 U52 U53"'
local suf2000  = `"11 12 13 14 15 16 17 "" 21 22 23 24 25 26 27 28 29 31 32 33 "" 35 41 42 43 50 51 52 53"'
local suf2010  = `"11 12 13 14 15 16 17 "" 21 22 23 24 25 26 27 28 29 31 32 33 "" "35_outras 35_RMSP" 41 42 43 50 51 52 53"'

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

				findfile dict.dta

				read_compdct, compdct("`r(fn)'") dict_name("censo`ano'`lang'") out("`dic'")
				
				capture infile using `dic', using("`original'/AMO80.UF`suf'.txt") clear
				if _rc == 601 {
				/* Abrindo arquivo se em formato dbf           */
					qui use "`original'/CD80DOM`codUF'.dta", clear
					qui rename contadom ndom
					qui merge 1:m uf munic ndom using "`original'/CD80PES`codUF'.dta", nogen keep(match) 
					
			
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
					qui rename TRUL12M v528
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

					findfile dict.dta

					read_compdct, compdct("`r(fn)'") dict_name("censo`ano'dom`lang'") out("`dic'")
					
					capture infile using `dic', using("`original'/CD102`suf'.txt") clear
					/* Próximas linha roda se Stata não encontrar o .txt */
					if _rc == 601 cap infile using `dic', using("`original'/CD102`suf'.dat") clear

					keep if v0099 == 1 // i.e. guarda só os domicíios
					keep v0102 v1101 v1102 v7002
					bys v0102: keep if _n==1
					tempfile cod91
					sort v0102
					save `cod91', replace

					/* Primeiros base de pessoas                    */
					
					tempfile dic

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
}

display as result "As bases de dados foram salvas na pasta `c(pwd)'"

di _newline "Esta versão do pacote datazoom_censo é compatível com os microdados do Censo 2010 divulgados em 11/03/2016 e Censo 2000 divulgados em 08/09/2017."

end
