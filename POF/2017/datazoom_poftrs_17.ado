* VERSION 1.0
program datazoom_poftrs_17
syntax , trs(string) original(string) saving(string) [english]

if "`english'" != "" local lang "_en"

cd "`saving'"

tokenize `trs'
di "`*'"
while "`*'"~="" {
	cap findfile pof2017_`1'`lang'.dct

	if "`1'"=="tr1" {
		qui cap infile using `"`r(fn)'"', using("`original'/MORADOR.txt") clear
	}
	if "`1'"=="tr2" {
		qui cap infile using `"`r(fn)'"', using("`original'/DESPESA_COLETIVA.txt") clear
	}
	if "`1'"=="tr3" {
		qui cap infile using `"`r(fn)'"', using("`original'/CADERNETA_COLETIVA.txt") clear
	}
	if "`1'"=="tr4" {
		qui cap infile using `"`r(fn)'"', using("`original'/DESPESA_INDIVIDUAL.txt") clear
	}
	if "`1'"=="tr5" {
		qui cap infile using `"`r(fn)'"', using("`original'/ALUGUEL_ESTIMADO.txt") clear
	}
	if "`1'"=="tr6" {
		qui cap infile using `"`r(fn)'"', using("`original'/RENDIMENTO_TRABALHO.txt") clear
	}
	if "`1'"=="tr7" {
		qui cap infile using `"`r(fn)'"', using("`original'/OUTROS_RENDIMENTOS.txt") clear
	}
	if "`1'"=="tr8" {
		qui cap infile using `"`r(fn)'"', using("`original'/DOMICILIO.txt") clear
	}	
	if "`1'"=="tr9" {
		qui cap infile using `"`r(fn)'"', using("`original'/INVENTARIO.txt") clear
	}	
	if "`1'"=="tr10" {
		qui cap infile using `"`r(fn)'"', using("`original'/CARACTERISTICAS_DIETA.txt") clear
	}	
	if "`1'"=="tr11" {
		qui cap infile using `"`r(fn)'"', using("`original'/CONSUMO_ALIMENTAR.txt") clear
	}	
	if "`1'"=="tr12" {
		qui cap infile using `"`r(fn)'"', using("`original'/CONDICOES_VIDA.txt") clear
	}	
	if "`1'"=="tr13" {
		qui cap infile using `"`r(fn)'"', using("`original'/RESTRICAO_PRODUTOS_SERVICOS_SAUDE.txt") clear
	}	
	if "`1'"=="tr14" {
		qui cap infile using `"`r(fn)'"', using("`original'/SERVICO_NAO_MONETARIO_POF2.txt") clear
	}	
	if "`1'"=="tr15" {
		qui cap infile using `"`r(fn)'"', using("`original'/SERVICO_NAO_MONETARIO_POF4.txt") clear
	}	

	save pof2017_`1', replace
	macro shift
}

display as result "As bases de dados foram salvas na pasta `c(pwd)'"
di _newline "Esta versão do pacote datazoom_poftrs_17 é compatível com os microdados do POF 2017/2018 divulgados em 25/11/2020"

end
