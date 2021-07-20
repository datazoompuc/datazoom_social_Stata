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

lab var n_homem_fam "number of men in the family" 
lab var n_mulher_fam "number of women in the family"
lab var n_pes_fam "total number of people in the family"

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

lab var cond_dom_B "status inside the household B"
lab var cond_fam_B "status inside the family B"


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
lab var racaB "race/ethnicty - exclude indigenous"


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
lab var religiao_B "religion - aggregated"
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
label var UF_nascim "State of birth"
* UF_nascim = 11-53 UF de nascimento especificada

recode v4210 (1/29 99 = .) (82 84 85 = 83 )	(83 = 82 ) (86 87=84 ) ///
	(87=85 ) (88=86 ) (89=87 ) (90=88 ) (91=89 ) (92=90 ) (93=91 ) ///
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
label var pais_nascim "Country of birth - 1970 codes"
drop v4210

*** Última migração
rename v0416 anos_mor_mun
rename v0422 anos_mor_UF

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

*** Onde morava anteriormente - para quem migrou nos últimos 10 anos:
* Em 2000 não foi pesquisado o MUNICIPIO e a situação de residência anterior.
gen UF_mor_ant = v4230 if v4230~=0
recode UF_mor_ant (29/99 = .) (1=11) (2=12) (3=13) (4=14) (5=15) (6=16) (7=17) (8=21) (9=22) (10=23) ///
				 (11=24) (12=25) (13=26) (14=27) (15=28) (16=29) (17=31) (18=32) (19=33) ///
				 (20=35) (21=41) (22=42) (23=43) (24=50) (25=51) (26=52) (27=53) 
label var UF_mor_ant "Previous State of residence (if migrated in the last 10 years)"
* UF_mor_ant = 11-53 código da UF em que morava
			  
recode v4230 (0=.) (1/29 = .) ///	// aqui 0 era, originalmente, "ignorado"; passa a "missing"
	(82 84 85 = 83 ) (83 = 82 )	(86 87=84 ) (88=86 ) (89=87 ) ///
	(90=88 ) (91=89 ) (92=90 ) (93=91 ) (94=92 ) (95=93 ) (96=94 ) ///   
	(97=95 ) (98=96 )
rename v4230 pais_mor_ant
label var pais_mor_ant "Previous Country of residence (if migrated in the last 10 years)"
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
label var UF_mor5anos "State of residence 5 years ago"
* UF_mor5anos = 11-53 código da UF em que morava

recode v4260 (1/29 99= .) (82 84 85 = 83 )	(83 = 82 )	(82=82 ) ///
	(79=79 ) (80=80 ) (81=81 ) (86 87=84 ) (88=86 ) (89=87 ) ///
	(90=88 ) (91=89 ) (92=90 ) (93=91 ) (94=92 ) (95=93 ) (96=94 ) ///   
	(97=95 ) (98=96 )
rename v4260 pais_mor5anos
label var pais_mor5anos "Country of residence 5 years ago"
* pais_mor5anos = 30-98 país estrangeiro especificado


/* D.8. EDUCAÇÃO */
recode v0428 (2=0) // (1=1)
replace v0428 = . if idade<5
rename v0428 alfabetizado
* alfabetizado = 0 - não
*                1 - sim (sabe ler e escrever)
recode v0429 (1 2 =1 "yes") (3 4 =0 "no"), g(freq_escola)	// exclui pre-escola, creche e pre-vestibular
replace freq_escola = 0 if v0430<=3 | v0430==11
lab var freq_escola "school attendance"
* freq_escola = 0 - não
*                1 - sim

g freq_escolaB = freq_escola
replace freq_escolaB = 1 if v0430 == 2 | v0430==3 // inclui pre-escola
lab var freq_escolaB "school attendance - including pre-school"
* freq_escolaB = 0 - não
*                1 - sim

* rede de ensino 
recode v0429 (2 = 1) (1 = 0) (else=.) 
replace v0429 = . if v0430==11	// para compatibilizar com 2010, exclui pre-vestibular
rename v0429 rede_freq
lab var rede_freq "private/public school"
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
lab var anos_estudoC "group of years of schooling"

* anos_estudoC = 0 – sem instrução ou menos de 3 anos de estudo (primário incompleto)
*                1 – de 4 a 7 (fundamental/ ginásio/ 1º. Grau/ médio primeiro ciclo incompleto)
*				 2 – de 8 a 10 (médio/ 2º. Grau/ médio segundo ciclo incompleto)
*			 	 3 – de 11 a 14 (médio/ 2º. Grau/ médio segundo ciclo completo ou superior incompleto)
*			 	 4 – 15 ou mais (superior completo, mestrado, doutorado)

drop v0430 v0431

* Estuda no município em que reside?
recode v4276 (100008 = 1) (200006 = .) (else = 0), g(mun_escola)
replace mun_escola = . if freq_escolaB==0
lab var mun_escola "attend school in the same municipality where you live?"

recode v4355 (2 = .)	///
		 (56/64 67 77 78 81/83 89 = 3) ///
		 (12 21/29 = 4) ///
		 (31/49 = 5) ///
		 (11 13 19 = 6) ///
		 (51/55 65 66 75 76 = 7) ///
		 (91 = 8) ///
		 (68 79 01 09 = 9), g(cursos_c1)
lab var cursos_c1 "course concluded - classification 1"
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
lab var cursos_c2 "course concluded - CONCLA"
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
label var teve_conjuge "live or lived with partner"
* teve_conjuge = 0 - não
*                1 - sim

recode v0436 (2 3 = 0) // (1=1)
rename v0436 vive_conjuge
label var vive_conjuge "live with partner"
* vive_conjuge = 0 - não
*                1 - sim

gen estado_conj = v0437 if vive_conjuge == 1
replace estado_conj = 5 if teve_conjuge == 0
replace estado_conj = v0438 + 5 if (teve_conjuge == 1 & vive_conjuge == 0 & v0438 >= 2 & v0438 <= 4)
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
lab var mais_de_um_trab "had two or more jobs"
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
lab var rend_outras_fontes "other sources income"

drop v4573 v4583 v4593 v4603 v4613

rename v4614 rend_total
rename v4615 rend_total_sm

* renda familiar
g aux = rend_total if cond_fam_B<=6
bys id_dom num_fam: egen rend_fam = total(aux)
drop aux
lab var rend_fam "family total income"

drop  ESTR ESTRP

/* DEFLACIONANDO RENDAS: referência = julho/2010 */
g double deflator = 0.515004440
g conversor = 1
lab var deflator "income deflator - reference: 08/2010"
lab var conversor "currency converter"

foreach var in rend_ocup_prin rend_outras_ocup rend_outras_fontes rend_total rend_fam {
		g `var'_def = (`var'/conversor)/deflator
		lab var `var'_def "`var' deflated"
}

/* D.11. FECUNDIDADE */	
* Em 1970 e 1980, a fecundidade foi investigada para mulheres de 15 anos ou mais;
* A partir de 1991, a idade foi reduzida para 10 anos ou mais

rename v4620 filhos_nasc_vivos
rename v0463 filhos_vivos
rename v4670 filhos_nasc_mortos
rename v4690 filhos_tot
egen filhos_hom = rowtotal(v4621 v4671)
lab var filhos_hom "male children"

egen filhos_mul = rowtotal(v4622 v4672)
lab var filhos_mul "female children"

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


