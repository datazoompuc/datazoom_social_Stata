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


/* Dicionários */

findfile pnad_anual_2012a2014`lang'.dct
loc dic_14_1 = r(fn)

findfile pnad_anual_1entr_2015`lang'.dct
loc dic_15_1 = r(fn)

findfile pnad_anual_1entr_2016`lang'.dct
loc dic_16_1 = r(fn)

findfile pnad_anual_5entr_2016`lang'.dct
loc dic_16_5 = r(fn)

findfile pnad_anual_1entr_2017`lang'.dct
loc dic_17_1 = r(fn)

findfile pnad_anual_educ`lang'.dct
loc dic_17_2 = r(fn)

findfile pnad_anual_tic`lang'.dct
loc dic_17_4 = r(fn)

findfile pnad_anual_5entr_2017`lang'.dct
loc dic_17_5 = r(fn)

findfile pnad_anual_1entr_2018`lang'.dct
loc dic_18_1 = r(fn)

findfile pnad_anual_5entr_2018`lang'.dct
loc dic_18_5 = r(fn)

findfile pnad_anual_1entr_2019`lang'.dct
loc dic_19_1 = r(fn)

findfile pnad_anual_5entr_2019`lang'.dct
loc dic_19_5 = r(fn)

/* Extraindo dos arquivos */
*tokenize `years'

	
foreach year in `years' {
*************************************2012*********************************
	if `year' == 2012 {
	
		di as input "Extraindo arquivo PNADC_anual_`year'..."
		cap infile using "`dic_14_1'", using("`original'/PNADC_2012_visita1.txt") clear
				if _rc == 0 {
					save PNADC_anual_2012_visita1, replace
					}
				else continue, break
					}
*************************************2013*********************************
	if `year' == 2013 {
	
		di as input "Extraindo arquivo PNADC_anual_`year'..."
		cap infile using "`dic_14_1'", using("`original'/PNADC_2013_visita1.txt") clear
				if _rc == 0 {
					save PNADC_anual_2013_visita1, replace
					}
				else continue, break
					}
*************************************2014*********************************
	if `year' == 2014 {
	
		di as input "Extraindo arquivo PNADC_anual_`year'..."
		cap infile using "`dic_14_1'", using("`original'/PNADC_2014_visita1.txt") clear
				if _rc == 0 {
					save PNADC_anual_2014_visita1, replace
					}
				else continue, break
					}
*************************************2015*********************************
	if `year' == 2015 {
	
		di as input "Extraindo arquivo PNADC_anual_`year'..."
		cap infile using "`dic_15_1'", using("`original'/PNADC_2015_visita1.txt") clear
				if _rc == 0 {
					save PNADC_anual_2015_visita1, replace
					}
				else continue, break
					}
*************************************2016*********************************
	if `year' == 20161 {
	
		di as input "Extraindo arquivo PNADC_anual_`year'..."
		cap infile using "`dic_16_1'", using("`original'/PNADC_2016_visita1.txt") clear
				if _rc == 0 {
					save PNADC_anual_2016_visita1, replace
					}
				else continue, break
					}
		if `year' == 20162 {
		
		di as input "Extraindo arquivo PNADC_anual_`year'..."
		*cap infile using "`dic_17_2'", using("`original'/PNADC_022016_educacao.txt") clear // due to change on arquive name
		cap infile using "`dic_17_2'", using("`original'/PNADC_2016_trimestre2.txt") clear
		if _rc == 0 {
					save PNADC_anual_2016_educ, replace
					}
				else continue, break
					}					
		if `year' == 20164 {
		
		di as input "Extraindo arquivo PNADC_anual_`year'..."
		cap infile using "`dic_17_4'", using("`original'/PNADC_042016_tic.txt") clear
		if _rc == 0 {
					save PNADC_anual_2016_tic, replace
					}
				else continue, break
					}
		if `year' == 20165 {
		
		di as input "Extraindo arquivo PNADC_anual_`year'..."
		cap infile using "`dic_16_5'", using("`original'/PNADC_2016_visita5.txt") clear
		if _rc == 0 {
					save PNADC_anual_2016_visita5, replace
					}
				else continue, break
					}
*************************************2017*********************************
	if `year' == 20171 {
	
		di as input "Extraindo arquivo PNADC_anual_`year'..."
		cap infile using "`dic_17_1'", using("`original'/PNADC_2017_visita1.txt") clear
				if _rc == 0 {
					save PNADC_anual_2017_visita1, replace
					}
				else continue, break
					}					
		if `year' == 20172 {
		
		di as input "Extraindo arquivo PNADC_anual_`year'..."
		*cap infile using "`dic_17_2'", using("`original'/PNADC_022017_educacao.txt") clear // due to change on arquive name
		cap infile using "`dic_17_2'", using("`original'/PNADC_2017_trimestre2.txt") clear
		if _rc == 0 {
					save PNADC_anual_2017_educ, replace
					}
				else continue, break
					}					
		if `year' == 20174 {
		
		di as input "Extraindo arquivo PNADC_anual_`year'..."
		cap infile using "`dic_17_4'", using("`original'/PNADC_042017_tic.txt") clear
		if _rc == 0 {
					save PNADC_anual_2017_tic, replace
					}
				else continue, break
					}
		if `year' == 20175 {
		
		di as input "Extraindo arquivo PNADC_anual_`year'..."
		cap infile using "`dic_17_5'", using("`original'/PNADC_2017_visita5.txt") clear
		if _rc == 0 {
					save PNADC_anual_2017_visita5, replace
					}
				else continue, break
					}
	*************************************2018*********************************
	if `year' == 20181 {
	
		di as input "Extraindo arquivo PNADC_anual_`year'..."
		cap infile using "`dic_18_1'", using("`original'/PNADC_2018_visita1.txt") clear
				if _rc == 0 {
					save PNADC_anual_2018_visita1, replace
					}
				else continue, break
					}
	if `year' == 20182 {
	
		di as input "Extraindo arquivo PNADC_anual_`year'..."
		*cap infile using "`dic_17_2'", using("`original'/PNADC_022018_educacao.txt") clear // due to change on arquive name
		cap infile using "`dic_17_2'", using("`original'/PNADC_2018_trimestre2.txt") clear
		if _rc == 0 {
					save PNADC_anual_2018_educ, replace
					}
				else continue, break
					}
		if `year' == 20185 {
		
		di as input "Extraindo arquivo PNADC_anual_`year'..."
		cap infile using "`dic_18_5'", using("`original'/PNADC_2018_visita5.txt") clear
		if _rc == 0 {
					save PNADC_anual_2018_visita5, replace
					}
				else continue, break
					}
	*************************************2019*********************************
	if `year' == 20191 {
	
		di as input "Extraindo arquivo PNADC_anual_`year'..."
		cap infile using "`dic_19_1'", using("`original'/PNADC_2019_visita1.txt") clear
				if _rc == 0 {
					save PNADC_anual_2019_visita1, replace
					}
				else continue, break
					}
	if `year' == 20192 {
	
		di as input "Extraindo arquivo PNADC_anual_`year'..."
		*cap infile using "`dic_17_2'", using("`original'/PNADC_022019_educacao.txt") clear // due to change on arquive name
		cap infile using "`dic_17_2'", using("`original'/PNADC_2019_trimestre2.txt") clear
		if _rc == 0 {
					save PNADC_anual_2019_educ, replace
					}
				else continue, break
					}
		if `year' == 20195 {
		
		di as input "Extraindo arquivo PNADC_anual_`year'..."
		cap infile using "`dic_19_5'", using("`original'/PNADC_2019_visita5.txt") clear
		if _rc == 0 {
					save PNADC_anual_2019_visita5, replace
					}
				else continue, break
					}					
	}


	
di _newline "Esta versão do pacote datazoom_pnadcont_anual é compatível com a última versão dos microdados divulgado pelo IBGE em 16/07/2020"
di _newline " As bases de dados foram salvas na pasta `c(pwd)'"
end
