program define compat_censo70

/* A. ANO */
* Já faço isso antes de chamar este programa (idem para a UF)
*generate int ano = 1970

/* B. IDENTIFICAÇÃO E NÚMERO DE MORADORES */

/* B.1. IDENTIFICAÇÃO */
gen regiao = int(UF/10)
lab var regiao "macro-region"

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

	lab var n_homem_dom "number of male residents"
	lab var n_mulher_dom "number of female residents"
	lab var n_pes_dom "total number of residents"

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
	lab var dom_pago "household rights"
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
	lab var sanitario "access to sanitary"
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
	label var fogao "stove"
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

	lab var n_homem_fam "number of males in the family"
	lab var n_mulher_fam "number of females in the family"
	lab var n_pes_fam "total number of people in the family"

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
	lab var idade "age in years"
	replace idade = 0      if v026 == 1 | v026 == 2
	gen idade_meses = v027 if v026 == 1 | v026 == 2
	lab var idade_meses "age in months for toddlers"
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
	label var nasceu_mun "born in the municipality"
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
	label var UF_nascim "State of birth"
	* UF_nascim = 11-53 UF de nascimento especificada

	gen nasceu_UF = 0
	replace nasceu_UF = 1 if UF_nascim == UF
	label var nasceu_UF "born in the current State"

	gen pais_nascim = v030 if v030 >= 30 & v030<99
	replace pais_nascim = 58 if pais_nascim==57 // juntando Alemanhas
	replace pais_nascim = 84 if pais_nascim==85 // juntando Chinas
	label var pais_nascim "country of birth - 1970 codes"
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
	
	lab var t_mor_UF_70 "time of residence in current State - 1970 years range"
	lab var t_mor_mun_70 "time of residence in current Municipality - 1970 years range"

	* Em 1970, não foi pesquisado o MUNICIPIO
	gen UF_mor_ant = v033 if v033 < 30
	recode UF_mor_ant (0=.) // residiu no Brasil, UF não especificada
	recode UF_mor_ant (1=11) (2=12) (3=13) (4=14) (5=15) (6=16) (7=21) (8=22) (9=23) ///
					  (10=24) (11=25) (12=26) (13=27) (14=26) (15=28) (16=29) (17=31) (18=32) ///
					  (19=33) (21=35) (22=41) (23=42) (24=43) (25=51) (26=52) (27=53) 
	label var UF_mor_ant "Federative Unit of previous residence (if migrated in less than 10 years)"
	* UF_mor_ant = 11-53 código da UF em que morava

	gen pais_mor_ant = v033 if v033 >= 30 & v033<99
	replace pais_mor_ant = . if v033 < 30 // residia no Brasil anteriormente
	replace pais_mor_ant = 58 if pais_mor_ant ==57	// juntando Alemanhas
	replace pais_mor_ant = 84 if pais_mor_ant ==85	// juntando Chinas
	label var pais_mor_ant "Country of previous residence(if migrated in less than 10 years)"
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
	lab var freq_escola "school attendance"
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
	lab var anos_estudo "years of schooling"
	
	recode v039 (0 98 99 = .)	///
		(10/48 50/67 = .) ///
		(72 73 75/78 80 83 84 = 3) ///
		(85 86 89 90 92 93 96 = 4) ///
		(79 87 88 94 = 5) ///
		(71 = 6) ///
		(70 74 81 82 95 = 7) ///
		(91 = 8)	///
		(97 = 9), g(cursos_c1)
	lab var cursos_c1 "course concluded - classification 1"
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
	lab var cursos_c2 "course concluded - CONCLA"
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
	lab var mun_escola "attend school in the municipality where you live?"
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
	lab var rend_fam "family income"
	
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
	lab var pea "Economically active population"
	* pea	= 1 economicamente ativo
	*         0 inativo
	
	
	gen v044b = v044
	replace v044b = . if v044b == 924
	* 924 significa "Procurando trabalho pela primeira vez"

	g ocup_hab = v044
	lab var ocup_hab "Main occupation"
	
	recode v044b (11/45 = 1) (101/198 = 2) (211/245 = 3) (311/341 = 4) (411/586 = 5) ///
				 (611/635 = 6) (711/761 = 7) (762=5) (763/777 = 7) (811/834 = 8) ///
				 (841/847 = 9) (911/923 925 = 10) (else=.)
	rename v044b grp_ocup_hab
	label var grp_ocup_hab "Main occupation groups"
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
	lab var ativ_hab "Activity sector"

	replace v045b = . if v045b == 933 	// 933 significa "Procurando trabalho pela primeira vez"
	recode v045b (111/222 = 1) (311/334 = 2) (341 342 = 3) (301/306 = 4) (351 352 = 4) ///
				 (411/422 = 5) (424 = 5) (611/620 = 6) (423 921 922 924 926 927 928 = 7) ///
				 (511/518 = 8) (711/721 = 9) (923 925 = 9) (811/827 = 10) (911/916 = 11) ///
				 (931 932 934 = 11) (else = .)
	rename v045b set_ativ_hab
	label var set_ativ_hab "Main occupation's activity sector"
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
	lab var pos_ocup_habB "position in usual occupation B"
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
	lab var hrs_oc_habB "hours worked p/week B - main job - non-agric."
	* hrs_oc_habB  = 1 - menos de 15 horas
	*                2 - de 15 a 39
	*                3 - de 40 a 49
	*                4 - 50 ou mais
	drop v048

	gen hrs_oc_habC = hrs_oc_habB
	recode hrs_oc_habC (4=3) // 1 a 3 mantidos
	lab var hrs_oc_habC "hours worked p/week C - main job - non-agric."
	* hrs_oc_habC  = 1 - menos de 15 horas
	*                2 - de 15 a 39 horas
	*                3 - 40 horas ou mais

	drop v049	// tempo que procura trabalho
	
	recode v042 (2=1) (3=0) (else=.)
	replace v042 = . if grp_ocup_hab==.
	rename v042 mun_trab
	lab var mun_trab "work in the municipality where you live?"
	* mun_trab 	= 1 - sim
	*			= 0 - não

	/* DEFLACIONANDO RENDAS: referência = julho/2010 */
	g double deflator = 0.000015185/10^8
	g double conversor = 2750000000000
	
	lab var deflator "income deflator - reference: 08/2010"
	lab var conversor "currency converter"

	foreach var in rend_total rend_fam {
		g `var'_def = (`var'/conversor)/deflator
		lab var `var'_def "`var' deflated"
	}

	/* D.11. FECUNDIDADE */

	egen filhos_tot = rowtotal(v050 v051), miss
	replace filhos_tot = . if v050==99 | v051==9
	lab var filhos_tot "total number of children had"
	
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
lab var peso_dom "household weight"

drop  v011 v022

end
