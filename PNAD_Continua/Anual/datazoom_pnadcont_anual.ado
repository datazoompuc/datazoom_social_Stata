******************************************************
*             datazoom_pnadcontinua_anual.ado              *
******************************************************
* version 1.0
program define datazoom_pnadcont_anual

syntax, years(str) original(str) saving(str) [english]

if "`english'" != "" local lang "_en"

/* Pastas para guardar arquivos da sessão */
cd `"`saving'"'

/* Criação de pastas para salvar os arquivos */
capture mkdir pnadcontinua_anual
if _rc == 693 {
   tempname numpasta
   local numpasta = 0
   while _rc == 693 {
      capture mkdir "pnadcontinua_anual_`++numpasta'"
   }
   cd "pnadcontinua_anual_`numpasta'"
}
else {
   cd "pnadcontinua_anual"
}
loc caminhoprin = c(pwd)

findfile dict.dta

local masterdict = "`r(fn)'"

foreach survey in `years' {
	
	// sufixos: 2015_tri_1 -> tri_1 e 2021_vis_5 -> vis_5
	
	local year = substr("`survey'", 1, 4) // ano no início da string
	
	local suffix = substr("`survey'", 6, .) // resto
	
	* Nome do arquivo de dados
	* Sempre PNADC_YYYY_visitaX.txt ou PNADC_YYYY_trimestreX.txt
	
	local file_name "PNADC_`year'_`suffix'.txt"
	
	// Substituindo tri -> trimestre e vis -> visita
	local file_name = regexr("`file_name'", "tri", "trimestre")
	local file_name = regexr("`file_name'", "vis", "visita")
	
	* Encontrando o dicionário correto
	
	// Caso seja agregada em trimestres
	if regexm("`suffix'", "tri") == 1 {
		local dic "pnad_anual_`suffix'`lang'"
	}
	else if `year' <= 2014 & "`suffix'" == "vis1" {
		local dic "pnad_anual_2012a2014_vis1`lang'"
	}
	else {
		local dic "pnad_anual_`year'_`suffix'`lang'"
	}

	* Lendo o dicionário
	
	tempfile dict_file
	
	read_compdct, compdct("`masterdict'") dict_name("`dic'") out("`dict_file'")
	
	* Lendo o arquivo
	
	di as input "Extraindo arquivo da PNAD Contínua Anual `year' `suffix'"

	qui infile using "`dict_file'", using("`original'/`file_name'") clear
	
	if _rc == 0 {
		save pnad_anual_`year'_`suffix'`lang', replace
	}
	else continue, break
	
	save pnad_anual_`year'_`suffix'`lang', replace
	
}
	
di _newline " As bases de dados foram salvas na pasta `c(pwd)'"

	datazoom_message

end
