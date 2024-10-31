******************************************************
*					datazoom_censo.ado				 *
******************************************************
* version 1.4
program define datazoom_censo

syntax, years(numlist) ufs(str) original(str) saving(str) [comp pes fam dom both all english]

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

load_censo, years(`years') ufs(`ufs') original(`original') `comp' `pes' `fam' `dom' `both' `all' `english'

end

program load_censo
syntax, years(numlist) ufs(str) original(str) [comp pes fam dom both all english]

if "`english'" != "" local lang "_en"

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
rename v0206 terr_proprio
* terr_proprio = 0 - não
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
lab var tipo_esc_san "tipo de escoadouro - desagregado"

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
*			= 1 - tem

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

/* DEFLACIONANDO RENDAS: referência = julho/2010 */
g double deflator = .515004440
g conversor = 1

lab var deflator "deflator de rendimentos - base 08/2010"
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
		  (810/863 = 8) ///
		  (085 097 = 9), g(cursos_c2)
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
* nao_remunerado = 0 - não
*                  1 - sim
drop v0441

recode v0443 (2=0) // (1=1)
rename v0443 trab_proprio_cons
* prod_alim_cons_proprio = 0 - não
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
*				  6 - Conta - própria
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

*	recode v4513 (0 999000 999999=.)
*	rename v4513 rend_tot_prin

replace v4514 = . if rend_ocup_prin==.
rename v4514 rend_prin_sm
drop v4511 v4513

recode v4522 (0 999000 999999=.)
rename v4522 rend_outras_ocup

drop v4523

replace v4524 = . if rend_outras_ocup==.
rename v4524 rend_outras_sm

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

/* DEFLACIONANDO RENDAS: referência = julho/2010 */
g double deflator = 0.515004440
g conversor = 1
lab var deflator "deflator de rendimentos - base 08/2010"
lab var conversor "conversor de moedas"

foreach var in rend_ocup_prin rend_outras_ocup rend_outras_fontes rend_total rend_fam {
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

recode v0464 (2=0) // (1=1)
rename v0464 sexo_ult_nasc_v
* sexo_ult_nas_v = 0 - feminino
*                  1 - masculino
replace v4654=. if v4654==99
rename v4654 idade_ult_nasc_v

/* PESO E OUTRAS */
rename P001 peso_pess
drop v4219 v4239 v4269 v4279 v4354 id_muni

order ano UF regiao munic id_dom ordem

end


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
*especie_B = 0 - particular permanente 
*            1 - particular improvisado
*            2 - coletivo

/* C.3. MATERIAL DAS PAREDES */
recode v0202 (2 4 = 1) (3 = 2) (5 = 3) (6 = 4) (7 = 5) (8 = 6) (9 = .)
rename v0202 paredes
* paredes 	= 1   Alvenaria
*        	= 2   Madeira aparelhada
*        	= 3   Taipa não revestida
*       	= 4   Material aproveitado
*   	    = 5   Palha
*	        = 6   Outro


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
*              2 - Canalizada só na propriedade ou terreno
*              3 - Não canalizada


/* C.9. DESTINO DO LIXO */
rename v0210 dest_lixo
* dest_lixo = 1 - Coletado por serviço de limpeza
*             2 - Colocado em caçamba de serviço de limpeza
*             3 - Queimado(na propriedade)
*             4 - Enterrado(na propriedade)
*             5 - Jogado em terreno baldio ou logradouro
*             6 - Jogado em rio, lago ou mar
*             7 - Tem outro destino

/* C.10. ILUMINAÇÃO ELÉTRICA */
rename v0211 ilum_eletr
recode ilum_eletr (1 2 =1) (3 = 0)
*ilum_eletr	 = 0 - Não
*              1 - Sim


rename v0212 medidor_el
recode medidor_el (1 2 = 1) (3 = 0)
*medidor_el = 1 - Tem
*			  0 - Não tem



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
*            1 - Sim

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

/* DEFLACIONANDO RENDAS: referência = julho/2010 */
g double deflator = 1
g conversor = 1

lab var deflator "deflator - referência: 08/2010"
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
*condicao_dom = 1	pessoa responsável
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
recode cond_dom_B (8 = 6) (10 = 8) (11 = 9) (12 = 10) (5 6 = 5) (9 = 7)
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
*					 1- Sim

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
lab var racaB "cor ou raça (indigenous=mulatto)"
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
*				= 0 - nao

rename v0618 nasceu_mun
recode nasceu_mun (1 2 = 1) (3 = 0)
	*nasceu_mun = 1- Sim
	*			  0- Não
rename v0619 nasceu_UF
recode nasceu_UF (1 2 = 1) (3 = 0)
replace nasceu_UF = 1 if nasceu_mun==1
	*nasceu_UF = 1- Sim
	*			  0- Não

rename v0620 nacionalidade 
recode nacionalidade (1 = 0) (2 = 1) (3 = 2)
replace nacionalidade = 0 if nasceu_UF==1
* nacionalidade = 0- Brasileiro nato
	*				  1- Naturalizado brasileiro
	*				  2- Estrangeiro
	
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
	*alfabetizadoB = 1 - Sim
	*				 0 - Não
	
** frequencia a escola: 2010 DESCONSIDERA PRE-VESTIBULAR, por isso, diversas variaveis de frequencia

recode v0628 (1 2=1 "sim") (3 4 =0 "nao"), g(freq_escola)
replace freq_escola = 0 if v0629<=3		// 	desconsidera creche e pre-escola para compatibilizar com todos
lab var freq_escola "frequenta escola"
*freq_escola = 1 - Sim
*			   0 - Não

g freq_escolaB = freq_escola
replace freq_escolaB = 1 if v0629==2 | v0629==3	// 	inclui pre-escola
lab var freq_escolaB "frequenta escola - inclui pre-school"
*freq_escolaB = 1 - Sim
*				0 - Não

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
* mun_esc 	= 1 - sim
*			= 0 - não

recode v6352 (140/226 321 322 347 380 = 3) ///
		 (421 641/727 813 = 4) ///
		 (440/481 520/525 581 582 = 5) ///
		 (620/624 = 6) ///
		 (310/314 340 342/346 762 = 7) ///
		 (863 = 8) ///
		 (341 420 422 482 483 540/544 761 810/812 814/862 085 = 9), g(cursos_c1)
lab var cursos_c1 "curso superior concluído"
* cursos_c1	=	3	ciências humanas
*				4	ciências biológicas
*				5	ciências exatas
*				6	ciências agrárias
*				7	ciências sociais
*				8	militar
*				9	outros cursos
		 
recode v6352 (140/146 = 1) ///
		 (210/226 = 2) ///
		 (310/346 347 380 = 3) ///
		 (420/483 = 4) ///
		 (520/582 623 = 5) ///
		 (620/622 624 641 = 6) ///
		 (720/762 = 7) ///
		 (810/863 = 8) ///
		 (085 = 9), g(cursos_c2)
lab var cursos_c2 "curso superior concluído - CONCLA"
* cursos_c2 =	1	Educação
*				2	Artes, Humanidades e Letras
*				3	Ciências Sociais, Administração e Direito
*				4	Ciências, Matemática e Computação
*				5	Engenharia, Produção e Construção
*				6	Agricultura e Veterinária
*				7	Saúde e Bem-Estar Social    
*				8	serviÃ§os
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
*				 1 - Sim

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
drop v0639 v0640


/* D.10. RENDA E ATIVIDADE ECONÔMICA */

rename v0641 trab_rem_sem
recode trab_rem_sem (2 = 0)
* trab_rem_sem = 1 - Sim
*				 0 - Não

rename v0642 afast_trab_sem
recode afast_trab_sem (2 = 0)
* afast_trab_sem = 1 - Sim
*				   0 - Não

* OBS: não perfeitamente compatível com 2000 por conta de mudanças nas questões.
* Em 2000, sao duas questoes, uma referente a aprendiz/estagiário e outra sobre
* ajuda sem remuneração a morador em atividade de extração e cultivo; em 2010, é
* uma pergunta genérica sobre ajuda sem remuneração a morador do domicílio
rename v0643 nao_remun
recode nao_remun (2 = 0)	
* nao_remun = 1 - Sim
*			 0 - Não
	
rename v0644 trab_proprio_cons
recode trab_proprio_cons (2 = 0)
* trab_proprio_cons = 1 - Sim
*					 0 - Não

recode v0645 (1 = 0) (2 = 1)
rename v0645 mais_de_um_trab
lab var mais_de_um_trab "tinha mais de um trabalho"
* mais_de_um_trab = 0 - Não
*			   	   1 - Sim

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
*				  2 - Militar e Funcionário Públicos
*				  3 - Empregado sem carteira
*				  4 - Trabalhador doméstico com carteira
*				  5 - Trabalhador doméstico sem carteira
*				  6 - Conta - própria
*				  7 - Empregador
*				  8 - Não remunerado
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
*tom_prov_trab = 1 - sim
*                0 - não

drop v0655

drop v0656 v0657 v0658 v0659

rename v6591 rend_outras_fontes
lab var rend_outras_fontes "rendimento de outras fontes"

* trabalha no minicípio 
recode v0660 (1 2 = 1) (3/5 = 0) (else = .)
rename v0660 mun_trab
lab var mun_trab "trabalha no município em que reside"
* mun_trab 	= 1 - sim
*			= 0 - não

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

recode sexo_ult_nasc_v (2 = 0 )
* sexo_ult_nasc_v_B = 1 - masculino
*                     0 - feminino

rename v6660 idade_ult_nasc_v
drop v0669 
rename v6691 f_nasc_m_hom
rename v6692 f_nasc_m_mul
rename v6693 filhos_nasc_mortos
rename v6800 filhos_tot


drop v6664 v0667 v0668 v6681 v6682 
	
/* DEFLACIONANDO RENDAS: referência = julho/2010 */
g double deflator = 1
g conversor = 1
lab var deflator "deflator de rendimentos - base 08/2010"
lab var conversor "conversor de moedas"

foreach var in rend_ocup_prin rend_outras_ocup rend_outras_fontes rend_total rend_fam {
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
	replace v008 = 1 if (v007 == 1 & (v008 == 2 | v008 == .))
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
	* aluguel_70 = 1 - até 15 salários mínimos
	*              2 - de 16 a 30 salários mínimos
	*              3 - de 31 a 60 salários mínimos
	*              4 - de 61 a 120 salários mínimos
	*              5 - de 121 a 240 salários mínimos
	*              6 - de 241 a 480 salários mínimos
	*              7 - de 481 a 960 salários mínimos
	*              8 - de 961 e mais salários mínimos


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
	rename v019 automov_part
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
	replace nasceu_mun = 1 if v031 == .
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
	*               2 zona rural

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
	* freq_escolaB = 0 - não
	*                1 - sim

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

	/* D.10. RENDA E ATIVIDADE ECONÔMICA */

	recode v041 (9999 = .)
	rename v041 rend_total
	by id_dom num_fam: egen rend_fam = total(rend_total*(cond_fam_B <= 6))
	lab var rend_fam "renda familiar"
	
	recode v043 (0=8) (1=6) (2=3) (3=4) (4=7) (5=5) (6=0) (7=1) (nonmissing = .)
	replace v043 = 2 if v044 == 924 & v045 == 933 // duas condições dizem o mesmo:
												  // procura trabalho pela 1a vez
	rename v043 cond_ativB
	* cond_ativ = 1 trabalha/procurando trabalho - já trabalhou
	*             2 procurando trabalho - nunca trabalhou
	*             3 aposentado ou pensionista
	*             4 vive de renda
	*             5 detento
	*             6 estudante
	*             7 doente ou inválido
	*             8 afazeres domésticos
	*             0 sem ocupação

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
	* cond_ativ_sem = 1 - só ocupação habitual
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

	/* DEFLACIONANDO RENDAS: referência = julho/2010 */
	g double deflator = 0.000015185/10^8
	g double conversor = 2750000000000
	
	lab var deflator "deflator de rendimentos - base 08/2010"
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
	* gerando totais de homens e mulheres nas famílias e nos domicílios
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
	*   	    = 5   Palha
	*	        = 6   Outro


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
	* inst_san_exc = 0 - não tem acesso a inst san exclusiva
	*                1 - tem acesso a inst sanitária exclusiva


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
	rename v215 comb_cozinha
	* comb_cozinha = 1 - gás
	*                2 - lenha
	*                3 - carvão
	*                4 - outro
	*                0 - não tem fogão nem fogareiro

	gen comb_fogao = comb_cozinha
	replace comb_fogao = 0 if fogao == 0
	lab var comb_fogao "combustível utilizado no fogão"
	* comb_fogao = 1 - gás
	*              2 - lenha
	*              3 - carvão
	*              4 - outro
	*              0 - não tem fogão

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

	
	/* DEFLACIONANDO RENDAS: referência = julho/2010 */
	
	g double deflator = 0.000033234/10^7
	g double conversor = 2750000000000
	lab var deflator "deflator de rendimentos - base 08/2010"
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
	replace v516 = 6     if (v516 == 8) & (idade <= 9) // irrelevante: & (idade > 5)
	replace v516 = 7     if (v516 == 8) & (idade != .) // irrelevante: & (idade > 9)
	replace v516 = . if v516==8
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

	recode v515 (1 = 0) (3 = 1)  (8 9 = .)
	rename v515 sit_mun_ant
	* sit_mun_ant = 0 zona urbana
	*               1 zona rural

	*** Onde morava há 5 anos:
	* Este quesito não foi investigado em 1980.

	/* D.8. EDUCAÇÃO */

	recode v519 (2=1) (4 6 = 0) (9 = .)
	rename v519 alfabetizado
	* alfabetizado = 0 - não
	*                1 - sim

	gen freq_escola = 0     if idade >= 5
	replace freq_escola = 1 if (idade >= 5) & (v521 ~= 0) // frequenta curso seriado
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

	recode cond_ativ (0 2=1) (3/9 =0), copy g(pea)
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
	* previd = 0 não
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
	
	* trabalha no minicípio  - compativel com 2010 apenas
	recode v527 (0 = 1) (1100007/max = 0)
	replace v527 = . if hrs_oc_hab==.
	rename v527 mun_trab
	lab var mun_trab "trabalha no município em que reside"
	* mun_trab 	= 1 - sim
	*			= 0 - não


	*** Ocupação na semana -- comparável com 2000:
	recode v541 (6 4 =4) (5=.)
	rename v541 trab_semana
	* trab_semana = 1 só trabalho habitual
	*               2 trabalho habitual e outros
	*               3 só trabalho diferente do habitual
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

	replace filhos_nasc_vivos =. if f_nasc_v_hom==. | f_nasc_v_mul==.
	
	egen filhos_nasc_mortos = rowtotal(v552 v553), miss
	lab var filhos_nasc_mortos "total de filhos nascidos mortos"

	recode v552 (98 99 = .)
	rename v552 f_nasc_m_hom
	recode v553 (98 99 = .)
	rename v553 f_nasc_m_mul

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
	egen rend_total = rowtotal(rend_ocup_hab rend_outras_ocup rend_aposent rend_aluguel rend_doa_pen v613)
	lab var rend_total "renda total"
	by id_muni distrito id_dom num_fam: ///
		egen rend_fam = total(rend_total*(v504>= 1 & v504<= 6))
	lab var rend_fam "renda familiar"
	by id_muni distrito id_dom: ///
		egen renda_dom = total(rend_total*(v503>= 1 & v503<= 6))
	lab var renda_dom "renda domiciliar"
	drop v608 v613  v680 v540 v682 v681
	
	/* DEFLACIONANDO RENDAS: referência = julho/2010 */
	
	cap g double deflator = 0.000033234/10^7
	cap g double conversor = 2750000000000
	lab var deflator "deflator de rendimentos - base 08/2010"
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

rename v0102 id_dom

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
*               2 - Rural

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
rename v0210 comb_cozinha
* comb_cozinha = 1 - gás
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

/* DEFLACIONANDO RENDAS: referência = julho/2010 */
g double deflator = 0.000038883
g double conversor = 2750000

lab var deflator "deflator de rendimentos - base 08/2010"
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

rename v0102 id_dom

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
             (71=7) (49 51 52 53 59 81 82 83 84 12 13 19 = 8) (85 86 89 99 = .)
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
* sitmorou_mun = 0 só na zona urbana
*                1 só na zona rural
*                2 nas zonas urbana e rural

* O quesito abaixo só é pesquisado em 1991.
drop v0313

*** Nacionalidade e naturalidade
recode v0314 (3=0) (2=1) // (1=1)
rename v0314 nasceu_mun
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
* 95 = Australis
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

recode v0320 (9=.) (2=0) // (1=1)
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

recode v0322 (2=0) (9=.) // (1=1)
replace v0322 =. if pais_mor5anos~=.
rename v0322 sit_dom5anos
label var sit_dom5anos "Situação do domicílio onde morava há 5 anos"
* sit_dom5anos = 1 zona urbana
*                0 zona rural

/* D.8. EDUCAÇÃO */
recode v0323 (2=0) // (1=1)
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
recode v3241 (20 = .) (17=16) (30 = 0) // 20 é "indefinido"; lim em 16 pois é máximo em 1970
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

recode v0330 (2 = 0)
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

recode v0356 (0 9999999=.)
rename v0356 rend_ocup_hab

recode v0357 (0 9999999=.)
rename v0357 rend_outras_ocup

recode v0360 (9999999=.)
recode v0361 (9999999=.)
egen rend_outras_fontes = rowtotal(v0360 v0361)
lab var rend_outras_fontes "rendimento de outras fontes"

recode v3561 (99999999=.) // rendimento total tem 1 dígito a mais
rename v3561 rend_total
lab var rend_total "total de rendimentos"

* renda familiar
replace v3045 = . if v3045>99999999
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

/* DEFLACIONANDO RENDAS: referência = julho/2010 */
g double deflator = 0.000038883
g double conversor = 2750000
lab var deflator "deflator de rendimentos - base 08/2010"
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

rename v3360 filhos_vivos
rename v3361 f_vivos_hom
rename v3362 f_vivos_mul

drop v0335 v0336 v0337 v0338 v0339 v0340

rename v3357 filhos_nasc_mortos
rename v0341 f_nasc_m_hom
rename v0342 f_nasc_m_mul

foreach var in filhos_tot filhos_hom filhos_mul filhos_nasc_vivos f_nasc_v_hom ///
	f_nasc_v_mul filhos_vivos f_vivos_hom f_vivos_mul filhos_nasc_mortos ///
	f_nasc_m_hom f_nasc_m_mul {
		replace `var'=. if `var'==99
}


recode v0343 (7 = .) (9 = .) (2=0) // (1=1)
rename v0343 sexo_ult_nasc_v
* sexo_ult_nasc_v = 0 feminino
*                 = 1 masculino

recode v3443 (99 = .)
rename v3443 idade_ult_nasc_v
drop v3444

/* OUTRAS */
rename v7301 peso_pess
order ano UF regiao munic id_dom ordem

datazoom_message

end
