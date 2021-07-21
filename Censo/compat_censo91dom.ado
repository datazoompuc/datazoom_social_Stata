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
