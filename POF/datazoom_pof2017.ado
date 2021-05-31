*VERSION 1.1

program datazoom_pof2017
syntax, [trs(string)] [source(string)] saving(string) [english]

if "`source'" == ""{
	
	cd "`source'"
	download_pof17
}

if "`english'" != ""{
	local lang "_en"
}

local files "MORADOR.txt DESPESA_COLETIVA.txt CADERNETA_COLETIVA.txt DESPESA_INDIVIDUAL.txt ALUGUEL_ESTIMADO.txt RENDIMENTO_TRABALHO.txt OUTROS_RENDIMENTOS.txt DOMICILIO.txt INVENTARIO.txt CARACTERISTICAS_DIETA.txt CONSUMO_ALIMENTAR.txt CONDICOES_VIDA.txt RESTRICAO_PRODUTOS_SERVICOS_SAUDE.txt SERVICO_NAO_MONETARIO_POF2.txt SERVICO_NAO_MONETARIO_POF4.txt"
local nums ""

if "`trs'" == ""{
	numlist "1/15"
	local trs `r(numlist)'
	
	* caso o usuário não escolha trs, supõe-se que quer todos
} 

tokenize `files'

/* Leitura dos registros */

foreach TR of numlist `trs'{

	qui cd "`source'"
	
	cap findfile pof2017_tr`TR'`lang'.dct
	
	cap infile using `"`r(fn)'"', using(``TR'') clear
	
	qui cd "`saving'"
	
	save pof2017_tr`TR', replace
	di "``TR''"
	
	if "`source'" == ""{
	qui cd "`source'"
	erase ``TR''
	* não deixar rastros caso tenha usado download
	}
}

if "`source'" == ""{
	erase pof.zip
}

display as result "As bases de dados foram salvas na pasta `c(pwd)'"


end

program download_pof17

local url "https://ftp.ibge.gov.br/Orcamentos_Familiares/Pesquisa_de_Orcamentos_Familiares_"

local complemento "2017_2018/Microdados/Dados_20210304.zip"

* esses números no final são a última data de atualização, então podem mudar eventualmente

local url `url'`complemento'

copy `url' pof.zip

unzipfile pof.zip, replace

end
