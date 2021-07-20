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
lab var n_homem_dom "number of male residents"
lab var n_mulher_dom "number of female residents"

by UF munic id_dom num_fam: egen n_homem_fam = total(v0601==1)
by UF munic id_dom num_fam: egen n_mulher_fam = total(v0601==2)
lab var n_homem_fam "number of men in the family" 
lab var n_mulher_fam "number of women in the family"

/* C. OUTRAS VARIÁVEIS DE DOMICÍLIO */

/* C.1. SITUAÇÃO */

recode v1006 (2=0)
rename v1006 sit_setor_C
lab var sit_setor_C "household setting"

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
lab var cond_dom_B "status inside the household B"
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
lab var racaB "race/ethnicty - indigenous=mulatto"
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
lab var religiao_B "religion - aggregated"
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
lab var sempre_morou "always lived in this municipality"
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
	8000736 8000834 8000768 8000788 8000800 8000894 8000716 = 83 "Africa - others")	///
	(8000818=82 "Egypt") ///
	(8000032=30 "Argentina") ///
	(8000124=32 "Canada") ///
	(8000192=36 "Cuba") ///
	(8000218=37 "Ecuador") ///
	(8000840=38 "USA") ///
	(8000320=39 "Guatemala") ///
	(8000254=40 "French Guiana") ///
	(8000328=41 "Guyana") ///
	(8000340=44 "Belize (British Honduras") ///
	(8000388=45 "Jamaica") ///
	(8000558=47 "Nicaragua") ///
	(8000591=48 "Panama") ///
	(8000600=49 "Paraguay") ///
	(8000604=50 "Peru") ///
	(8000214=51 "Dominican Republic") ///
	(8000222=52 "El Salvador") ///
	(8000740=53 "Suriname") ///
	(8000858=54 "Uruguay") ///
	(8000862=55 "Venezuela") ///
	(8000028 8000044 8000052 8000084 8000068 8000152 8000170 8000188 8000212 ///
		8000308 8000332 8000484 8000662 8000659 8000670 8000780 = 56 "America - others") ///
	(8000276=58 "Germany")	///
	(8000040=59 "Austria") ///
	(8000056=60 "Belgium") ///
	(8000100=61 "Bulgaria") ///
	(8000208=62 "Denmark") ///
	(8000724=63 "Spain") ///
	(8000246=64 "Finland") ///
	(8000250=65 "France") ///
	(8000826=66 "Great-Britain") ///
	(8000300=67 "Grece") ///
	(8000528=68 "Holand") ///
	(8000348=69 "Hungary") ///
	(8000372=70 "Ireland") ///
	(8000380=71 "Italy") ///
	(8000070 8000191 8000705 8000807 8000499 8000688 = 72 "Yugoslavia") ///
	(8000578=73 "Norway") ///
	(8000616=74 "Poland") ///
	(8000620=75 "Portugal") ///
	(8000642=76 "Romania") ///
	(8000752=77 "Sweden") ///
	(8000756=78 "Switzerland") ///
	(8000203 8000703=79 "Czechoslovakia") ///
	(8000112 8000233 8000428 8000440 8000643 8000804 = 80 "USSR") ///
	(8000008 8000020 8000352 8000438 8000442 8000470 8000492 8000498 8000674 ///
		8000336 = 81 "Europe - others") ///
	(8000156=84 "China") ///
	(8000408=86 "Korea") ///
	(8000356=87 "India") ///
	(8000376=88 "Israel") ///
	(8000392=89 "Japan") ///
	(8000422=90 "Lebanon") ///
	(8000586=91 "Pakistan") ///
	(8000760=92 "Syria") ///
	(8000792=93 "Turkey") ///
	(8000004 8000682 8000051 8000031 8000048 8000050 8000096 8000064 8000116 ///
		8000398 8000634 8000196 8000702 8000784 8000608 8000268 8000887 ///
		8000360 8000364 8000368 8000400 8000414 8000458 8000462 8000104 ///
		8000496 8000524 8000512 8000417 8000410 8000418 8000144 8000762 ///
		8000764 8000626 8000795 8000860 8000704 = 94 "Asia - outros") ///
	(8000036=95 "Australia") ///
	(8000583 8000242 8000584 8000090 8000296 8000520 8000554 8000585 ///
		8000598 8000882 8000776 8000798 8000548 = 96 "Oceania - others"), g(pais_nascim)
label var pais_nascim "Country of birth - 1970 codes"
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
	8000736 8000834 8000768 8000788 8000800 8000894 8000716 = 83 "Africa - others")	///
	(8000818=82 "Egypt") ///
	(8000032=30 "Argentina") ///
	(8000124=32 "Canada") ///
	(8000192=36 "Cuba") ///
	(8000218=37 "Ecuador") ///
	(8000840=38 "USA") ///
	(8000320=39 "Guatemala") ///
	(8000254=40 "French Guiana") ///
	(8000328=41 "Guyana") ///
	(8000340=44 "Belize (British Honduras") ///
	(8000388=45 "Jamaica") ///
	(8000558=47 "Nicaragua") ///
	(8000591=48 "Panama") ///
	(8000600=49 "Paraguay") ///
	(8000604=50 "Peru") ///
	(8000214=51 "Dominican Republic") ///
	(8000222=52 "El Salvador") ///
	(8000740=53 "Suriname") ///
	(8000858=54 "Uruguay") ///
	(8000862=55 "Venezuela") ///
	(8000028 8000044 8000052 8000084 8000068 8000152 8000170 8000188 8000212 ///
		8000308 8000332 8000484 8000662 8000659 8000670 8000780 = 56 "America - others") ///
	(8000276=58 "Germany")	///
	(8000040=59 "Austria") ///
	(8000056=60 "Belgium") ///
	(8000100=61 "Bulgaria") ///
	(8000208=62 "Denmark") ///
	(8000724=63 "Spain") ///
	(8000246=64 "Finland") ///
	(8000250=65 "France") ///
	(8000826=66 "Great-Britain") ///
	(8000300=67 "Grece") ///
	(8000528=68 "Holand") ///
	(8000348=69 "Hungary") ///
	(8000372=70 "Ireland") ///
	(8000380=71 "Italy") ///
	(8000070 8000191 8000705 8000807 8000499 8000688 = 72 "Yugoslavia") ///
	(8000578=73 "Norway") ///
	(8000616=74 "Poland") ///
	(8000620=75 "Portugal") ///
	(8000642=76 "Romania") ///
	(8000752=77 "Sweden") ///
	(8000756=78 "Switzerland") ///
	(8000203 8000703=79 "Czechoslovakia") ///
	(8000112 8000233 8000428 8000440 8000643 8000804 = 80 "USSR") ///
	(8000008 8000020 8000352 8000438 8000442 8000470 8000492 8000498 8000674 ///
		8000336 = 81 "Europe - others") ///
	(8000156=84 "China - Continental") ///
	(8000408=86 "Korea") ///
	(8000356=87 "India") ///
	(8000376=88 "Israel") ///
	(8000392=89 "Japan") ///
	(8000422=90 "Lebanon") ///
	(8000586=91 "Pakistan") ///
	(8000760=92 "Syria") ///
	(8000792=93 "Turkey") ///
	(8000004 8000682 8000051 8000031 8000048 8000050 8000096 8000064 8000116 ///
		8000398 8000634 8000196 8000702 8000784 8000608 8000268 8000887 ///
		8000360 8000364 8000368 8000400 8000414 8000458 8000462 8000104 ///
		8000496 8000524 8000512 8000417 8000410 8000418 8000144 8000762 ///
		8000764 8000626 8000795 8000860 8000704 = 94 "Asia - outros") ///
	(8000036=95 "Australia") ///
	(8000583 8000242 8000584 8000090 8000296 8000520 8000554 8000585 ///
		8000598 8000882 8000776 8000798 8000548 = 96 "Oceania - others"), g(pais_mor_ant)
label var pais_mor_ant "Previous Country of residence (if migrated in the last 10 years)"
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
lab var t_mor_UF_70 "time of residence in current State - 1970 years range"
lab var t_mor_mun_70 "time of residence in current Municipality - 1970 years range"

* De 1980 em diante, podemos montar a variavel de tempo de moradia incluindo
* pessoas que nasceram mas nem sempre moraram no municipio em que residem
recode anos_mor_UF (7/9 =6) (10/max =7), g(t_mor_UF_80)
recode anos_mor_mun (7/9 =6) (10/max =7), g(t_mor_mun_80)
lab var t_mor_UF_80 "time of residence in current State - 1980 onward compatible"
lab var t_mor_mun_80 "time of residence in current Municipality - 1980 onward compatible"

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
	8000736 8000834 8000768 8000788 8000800 8000894 8000716 = 83 "Africa - others")	///
	(8000818=82 "Egypt") ///
	(8000032=30 "Argentina") ///
	(8000124=32 "Canada") ///
	(8000192=36 "Cuba") ///
	(8000218=37 "Ecuador") ///
	(8000840=38 "USA") ///
	(8000320=39 "Guatemala") ///
	(8000254=40 "French Guiana") ///
	(8000328=41 "Guyana") ///
	(8000340=44 "Belize (British Honduras") ///
	(8000388=45 "Jamaica") ///
	(8000558=47 "Nicaragua") ///
	(8000591=48 "Panama") ///
	(8000600=49 "Paraguay") ///
	(8000604=50 "Peru") ///
	(8000214=51 "Dominican Republic") ///
	(8000222=52 "El Salvador") ///
	(8000740=53 "Suriname") ///
	(8000858=54 "Uruguay") ///
	(8000862=55 "Venezuela") ///
	(8000028 8000044 8000052 8000084 8000068 8000152 8000170 8000188 8000212 ///
		8000308 8000332 8000484 8000662 8000659 8000670 8000780 = 56 "America - others") ///
	(8000276=58 "Germany")	///
	(8000040=59 "Austria") ///
	(8000056=60 "Belgium") ///
	(8000100=61 "Bulgaria") ///
	(8000208=62 "Denmark") ///
	(8000724=63 "Spain") ///
	(8000246=64 "Finland") ///
	(8000250=65 "France") ///
	(8000826=66 "Great-Britain") ///
	(8000300=67 "Grece") ///
	(8000528=68 "Holand") ///
	(8000348=69 "Hungary") ///
	(8000372=70 "Ireland") ///
	(8000380=71 "Italy") ///
	(8000070 8000191 8000705 8000807 8000499 8000688 = 72 "Yugoslavia") ///
	(8000578=73 "Norway") ///
	(8000616=74 "Poland") ///
	(8000620=75 "Portugal") ///
	(8000642=76 "Romania") ///
	(8000752=77 "Sweden") ///
	(8000756=78 "Switzerland") ///
	(8000203 8000703=79 "Czechoslovakia") ///
	(8000112 8000233 8000428 8000440 8000643 8000804 = 80 "USSR") ///
	(8000008 8000020 8000352 8000438 8000442 8000470 8000492 8000498 8000674 ///
		8000336 = 81 "Europe - others") ///
	(8000156=84 "China - Continental") ///
	(8000408=86 "Korea") ///
	(8000356=87 "India") ///
	(8000376=88 "Israel") ///
	(8000392=89 "Japan") ///
	(8000422=90 "Lebanon") ///
	(8000586=91 "Pakistan") ///
	(8000760=92 "Syria") ///
	(8000792=93 "Turkey") ///
	(8000004 8000682 8000051 8000031 8000048 8000050 8000096 8000064 8000116 ///
		8000398 8000634 8000196 8000702 8000784 8000608 8000268 8000887 ///
		8000360 8000364 8000368 8000400 8000414 8000458 8000462 8000104 ///
		8000496 8000524 8000512 8000417 8000410 8000418 8000144 8000762 ///
		8000764 8000626 8000795 8000860 8000704 = 94 "Asia - outros") ///
	(8000036=95 "Australia") ///
	(8000583 8000242 8000584 8000090 8000296 8000520 8000554 8000585 ///
		8000598 8000882 8000776 8000798 8000548 = 96 "Oceania - others"), g(pais_mor5anos)
lab var pais_mor5anos "Country of residence 5 years ago"

drop v6266 v0625 v0626 

/* D.8. EDUCACÃO */

rename v0627 alfabetizado
recode alfabetizado (2 = 0)
	*alfabetizadoB = 1 - Sim
	*				 0 - Não
	
** frequencia a escola: 2010 DESCONSIDERA PRE-VESTIBULAR, por isso, diversas variaveis de frequencia

recode v0628 (1 2=1 "yes") (3 4 =0 "no"), g(freq_escola)
replace freq_escola = 0 if v0629<=3		// 	desconsidera creche e pre-escola para compatibilizar com todos
lab var freq_escola "school attendance"
*freq_escola = 1 - Sim
*			   0 - Não

g freq_escolaB = freq_escola
replace freq_escolaB = 1 if v0629==2 | v0629==3	// 	inclui pre-escola
lab var freq_escolaB "school attendance - including pre-school"
*freq_escolaB = 1 - Sim
*				0 - Não

* rede de ensino
recode v0628 (1 = 1) (2 = 0) (else=.) 
rename v0628 rede_freq
lab var rede_freq "private/public school"
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
lab var anos_estudoC "years of schooling groups"

drop v0631 v0632 curso_freq serie_freq

* Estuda no município em que reside?
recode v0636 (2 3 = 0)
replace v0636 = . if freq_escolaB==0	
rename v0636 mun_escola
lab var mun_escola "attend school in the same municipality where you live?"
* mun_esc 	= 1 - sim
*			= 0 - não

recode v6352 (140/226 321 322 347 380 = 3) ///
		 (421 641/727 813 = 4) ///
		 (440/481 520/525 581 582 = 5) ///
		 (620/624 = 6) ///
		 (310/314 340 342/346 762 = 7) ///
		 (863 = 8) ///
		 (341 420 422 482 483 540/544 761 810/812 814/862 085 = 9), g(cursos_c1)
lab var cursos_c1 "course concluded - classification 1"
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
lab var cursos_c2 "course concluded - CONCLA"
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
label var teve_conjuge "live or lived with partner"
* teve_conjuge = 0 - não
*                1 - sim

* vive com o cônjuge?
recode v0637 ( 2 3 = 0)
rename v0637 vive_conjuge
lab var vive_conjuge "live with partner"
* vive_conjuge = 0 - Não
*				 1 - Sim

drop v0638

gen estado_conj = v0639 if vive_conjuge == 1
replace estado_conj = 5 if teve_conjuge == 0
replace estado_conj = v0640 + 5 if (teve_conjuge == 1 & vive_conjuge == 0 & v0640 >= 2 & v0640 <= 4)
replace estado_conj = 6 if (teve_conjuge == 1 & vive_conjuge == 0 & estado_conj == .)
label var estado_conj "marital status"
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
lab var mais_de_um_trab "had two or more jobs"
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
recode previd_B ( 1 = 1) (2 3 = 0)
* previd_B = 1-Sim
*            0-Não

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
lab var rend_fam "family total income"

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
lab var rend_outras_fontes "other sources income"

* trabalha no minicípio  
recode v0660 (1 2 = 1) (3/5 = 0) (else = .)
rename v0660 mun_trab
lab var mun_trab "work in the same municipality where you live?"
* mun_trab 	= 1 - sim
*			= 0 - não

drop v6602 v6604 v6606 v0661 v0662 v5110 v5120 v6900 v6910 v6920 v6940

/* DEFLACIONANDO RENDAS: referência = julho/2010 */
g double deflator = 1
g conversor = 1
lab var deflator "income deflator - reference: 08/2010"
lab var conversor "currency converter"

foreach var in rend_ocup_prin rend_outras_ocup rend_outras_fontes rend_total rend_fam {
		g `var'_def = (`var'/conversor)/deflator
		lab var `var'_def "`var' deflated"
}

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

egen filhos_hom = rowtotal(f_nasc_m_hom f_nasc_v_hom)
lab var filhos_hom "male children"

egen filhos_mul = rowtotal(f_nasc_m_mul f_nasc_v_mul)
lab var filhos_mul "female children"

drop v6664 v0667 v0668 v6681 v6682 
	

/* D.12. OUTRAS INFORMAÇÕES */
 
drop v0670 v0671 v0604 v0605 v5080 v5030- v5130

order ano UF regiao munic id_dom ordem

end

