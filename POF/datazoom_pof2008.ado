*VERSION 1.3

program datazoom_pof2017
syntax, [trs(string)] [source(string)] saving(string) [raw] [english]

if "`source'" == ""{
	
	cd "`source'"
	download_pof08
}

if "`english'" != ""{
	local lang "_en"
}

local files "T_DOMICILIO_S.txt T_MORADOR_S.txt T_MORADOR_IMPUT_S.txt T_CONDICOES_DE_VIDA_S.txt T_INVENTARIO_S.txt T_DESPESA_90DIAS_S.txt T_DESPESA_12MESES_S.txt T_OUTRAS_DESPESAS_S.txt T_SERVICO_DOMS_S.txt T_ALUGUEL_ESTIMADO_S.txt T_CADERNETA_DESPESA_S.txt T_DESPESA_INDIVIDUAL_S.txt T_DESPESA_VEICULO_S.txt T_RENDIMENTOS_S.txt T_OUTROS_RECI_S.txt T_CONSUMO_S.txt"

if "`trs'" == ""{
	numlist "1/16"
	local trs `r(numlist)'
	
	* caso o usuário não escolha trs, supõe-se que quer todos
}

tokenize `files'

/* Leitura dos registros */

foreach TR of numlist `trs'{

	qui cd "`source'"
	
	cap findfile pof2008_tr`TR'`lang'.dct
	
	cap infile using `"`r(fn)'"', using(``TR'') clear
	
	qui cd "`saving'"
	
	save pof2008_tr`TR', replace
	di "``TR''"
	
	if "`source'" == ""{
	qui cd "`source'"
	erase ``TR''
	* não deixar rastros caso tenha usado download
	}
}

display as result "As bases de dados foram salvas na pasta `c(pwd)'"


end

program download_pof08

local url "https://ftp.ibge.gov.br/Orcamentos_Familiares/Pesquisa_de_Orcamentos_Familiares_"

local complemento "2008_2009/Microdados/Dados_20201005.zip"

* esses números no final são a última data de atualização, então podem mudar eventualmente

local url `url'`complemento'

copy `url' pof08.zip

unzipfile pof08.zip, replace

erase pof08.zip

end
