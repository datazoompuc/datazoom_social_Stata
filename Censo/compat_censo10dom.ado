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
 
