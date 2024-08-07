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

tempfile dic_14_1
tempfile dic_15_1
tempfile dic_16_1
tempfile dic_16_5
tempfile dic_17_1
tempfile dic_17_2
tempfile dic_17_5
tempfile dic_18_1
tempfile dic_18_5
tempfile dic_19_1
tempfile dic_19_3
tempfile dic_19_5
tempfile dic_20_2
tempfile dic_20_5
tempfile dic_21_2
tempfile dic_21_5
tempfile dic_21_4
tempfile dic_22_1
tempfile dic_22_5
tempfile dic_23_1
tempfile dic_23_v1

findfile dict.dta

local masterdict = "`r(fn)'"

read_compdct, compdct("`masterdict'") dict_name("pnad_anual_2012a2014`lang'") out("`dic_14_1'")
read_compdct, compdct("`masterdict'") dict_name("pnad_anual_1entr_2015`lang'") out("`dic_15_1'")
read_compdct, compdct("`masterdict'") dict_name("pnad_anual_1entr_2016`lang'") out("`dic_16_1'")
read_compdct, compdct("`masterdict'") dict_name("pnad_anual_5entr_2016`lang'") out("`dic_16_5'")
read_compdct, compdct("`masterdict'") dict_name("pnad_anual_1entr_2017`lang'") out("`dic_17_1'")
read_compdct, compdct("`masterdict'") dict_name("pnad_anual_2tri_2016a2022`lang'") out("`dic_17_2'")
read_compdct, compdct("`masterdict'") dict_name("pnad_anual_5entr_2017`lang'") out("`dic_17_5'")
read_compdct, compdct("`masterdict'") dict_name("pnad_anual_1entr_2018`lang'") out("`dic_18_1'")
read_compdct, compdct("`masterdict'") dict_name("pnad_anual_5entr_2018`lang'") out("`dic_18_5'")
read_compdct, compdct("`masterdict'") dict_name("pnad_anual_1entr_2019`lang'") out("`dic_19_1'")
read_compdct, compdct("`masterdict'") dict_name("pnad_anual_3tri_2019e2022`lang'") out("`dic_19_3'")
read_compdct, compdct("`masterdict'") dict_name("pnad_anual_5entr_2019`lang'") out("`dic_19_5'")
read_compdct, compdct("`masterdict'") dict_name("pnad_anual_2entr_2020e2021`lang'") out("`dic_20_2'")
read_compdct, compdct("`masterdict'") dict_name("pnad_anual_5entr_2020`lang'") out("`dic_20_5'")
read_compdct, compdct("`masterdict'") dict_name("pnad_anual_5entr_2021`lang'") out("`dic_21_5'")
read_compdct, compdct("`masterdict'") dict_name("pnad_anual_4tri_2016a2022`lang'") out("`dic_21_4'")
read_compdct, compdct("`masterdict'") dict_name("pnad_anual_1entr_2022`lang'") out("`dic_22_1'")
read_compdct, compdct("`masterdict'") dict_name("pnad_anual_5entr_2022`lang'") out("`dic_22_5'")
read_compdct, compdct("`masterdict'") dict_name("pnad_anual_1tri_2023`lang'") out("`dic_23_1'")
read_compdct, compdct("`masterdict'") dict_name("pnad_anual_1entr_2023`lang'") out("`dic_23_v1'")

/* Extraindo dos arquivos */
*tokenize `years'

	
foreach year in `years' {
*************************************2012*********************************
	if `year' == 2012 {
	
		di as input "Extraindo arquivo PNADC_anual_`year'..."
		infile using "`dic_14_1'", using("`original'/PNADC_2012_visita1.txt") clear
				if _rc == 0 {
					save PNADC_anual_2012_visita1, replace
					}
				else continue, break
					}
*************************************2013*********************************
	if `year' == 2013 {
	
		di as input "Extraindo arquivo PNADC_anual_`year'..."
		infile using "`dic_14_1'", using("`original'/PNADC_2013_visita1.txt") clear
				if _rc == 0 {
					save PNADC_anual_2013_visita1, replace
					}
				else continue, break
					}
*************************************2014*********************************
	if `year' == 2014 {
	
		di as input "Extraindo arquivo PNADC_anual_`year'..."
		infile using "`dic_14_1'", using("`original'/PNADC_2014_visita1.txt") clear
				if _rc == 0 {
					save PNADC_anual_2014_visita1, replace
					}
				else continue, break
					}
*************************************2015*********************************
	if `year' == 2015 {
	
		di as input "Extraindo arquivo PNADC_anual_`year'..."
		infile using "`dic_15_1'", using("`original'/PNADC_2015_visita1.txt") clear
				if _rc == 0 {
					save PNADC_anual_2015_visita1, replace
					}
				else continue, break
					}
*************************************2016*********************************
	if `year' == 20161 {
	
		di as input "Extraindo arquivo PNADC_anual_`year'..."
		infile using "`dic_16_1'", using("`original'/PNADC_2016_visita1.txt") clear
				if _rc == 0 {
					save PNADC_anual_2016_visita1, replace
					}
				else continue, break
					}
		if `year' == 20162 {
		
		di as input "Extraindo arquivo PNADC_anual_`year'..."
		*cap infile using "`dic_17_2'", using("`original'/PNADC_022016_educacao.txt") clear // due to change on arquive name
		infile using "`dic_17_2'", using("`original'/PNADC_2016_trimestre2.txt") clear
		if _rc == 0 {
					save PNADC_anual_2016_trimestre2, replace
					}
				else continue, break
					}					
		if `year' == 20164 {
		
		di as input "Extraindo arquivo PNADC_anual_`year'..."
		infile using "`dic_21_4'", using("`original'/PNADC_2016_trimestre4.txt") clear
		if _rc == 0 {
					save PNADC_anual_2016_trimestre4, replace
					}
				else continue, break
					}
		if `year' == 20165 {
		
		di as input "Extraindo arquivo PNADC_anual_`year'..."
		infile using "`dic_16_5'", using("`original'/PNADC_2016_visita5.txt") clear
		if _rc == 0 {
					save PNADC_anual_2016_visita5, replace
					}
				else continue, break
					}
*************************************2017*********************************
	if `year' == 20171 {
	
		di as input "Extraindo arquivo PNADC_anual_`year'..."
		infile using "`dic_17_1'", using("`original'/PNADC_2017_visita1.txt") clear
				if _rc == 0 {
					save PNADC_anual_2017_visita1, replace
					}
				else continue, break
					}					
		if `year' == 20172 {
		
		di as input "Extraindo arquivo PNADC_anual_`year'..."
		*cap infile using "`dic_17_2'", using("`original'/PNADC_022017_educacao.txt") clear // due to change on arquive name
		infile using "`dic_17_2'", using("`original'/PNADC_2017_trimestre2.txt") clear
		if _rc == 0 {
					save PNADC_anual_2017_trimestre2, replace
					}
				else continue, break
					}					
		if `year' == 20174 {
		
		di as input "Extraindo arquivo PNADC_anual_`year'..."
		infile using "`dic_21_4'", using("`original'/PNADC_2017_trimestre4.txt") clear
		if _rc == 0 {
					save PNADC_anual_2017_trimestre4, replace
					}
				else continue, break
					}
		if `year' == 20175 {
		
		di as input "Extraindo arquivo PNADC_anual_`year'..."
		infile using "`dic_17_5'", using("`original'/PNADC_2017_visita5.txt") clear
		if _rc == 0 {
					save PNADC_anual_2017_visita5, replace
					}
				else continue, break
					}
	*************************************2018*********************************
	if `year' == 20181 {
	
		di as input "Extraindo arquivo PNADC_anual_`year'..."
		infile using "`dic_18_1'", using("`original'/PNADC_2018_visita1.txt") clear
				if _rc == 0 {
					save PNADC_anual_2018_visita1, replace
					}
				else continue, break
					}
	if `year' == 20182 {
	
		di as input "Extraindo arquivo PNADC_anual_`year'..."
		*cap infile using "`dic_17_2'", using("`original'/PNADC_022018_educacao.txt") clear // due to change on arquive name
		infile using "`dic_17_2'", using("`original'/PNADC_2018_trimestre2.txt") clear
		if _rc == 0 {
					save PNADC_anual_2018_trimestre2, replace
					}
				else continue, break
					}
		if `year' == 20184 {
		
		di as input "Extraindo arquivo PNADC_anual_`year'..."
		infile using "`dic_21_4'", using("`original'/PNADC_2018_trimestre4.txt") clear
		if _rc == 0 {
					save PNADC_anual_2018_trimestre4, replace
					}
				else continue, break
					}
		if `year' == 20185 {
		
		di as input "Extraindo arquivo PNADC_anual_`year'..."
		infile using "`dic_18_5'", using("`original'/PNADC_2018_visita5.txt") clear
		if _rc == 0 {
					save PNADC_anual_2018_visita5, replace
					}
				else continue, break
					}
	*************************************2019*********************************
	if `year' == 20191 {
	
		di as input "Extraindo arquivo PNADC_anual_`year'..."
		infile using "`dic_19_1'", using("`original'/PNADC_2019_visita1.txt") clear
				if _rc == 0 {
					save PNADC_anual_2019_visita1, replace
					}
				else continue, break
					}
	if `year' == 20192 {
	
		di as input "Extraindo arquivo PNADC_anual_`year'..."
		*cap infile using "`dic_17_2'", using("`original'/PNADC_022019_educacao.txt") clear // due to change on arquive name
		infile using "`dic_17_2'", using("`original'/PNADC_2019_trimestre2.txt") clear
		if _rc == 0 {
					save PNADC_anual_2019_trimestre2, replace
					}
				else continue, break
					}
	if `year' == 20193 {
		
		di as input "Extraindo arquivo PNADC_anual_`year'..."
		infile using "`dic_19_3'", using("`original'/PNADC_2019_trimestre3.txt") clear
		if _rc == 0 {
					save PNADC_anual_2019_trimestre3, replace
					}
				else continue, break
					}
	if `year' == 20194 {
		
		di as input "Extraindo arquivo PNADC_anual_`year'..."
		infile using "`dic_21_4'", using("`original'/PNADC_2019_trimestre4.txt") clear
		if _rc == 0 {
					save PNADC_anual_2019_trimestre4, replace
					}
				else continue, break
					}
		if `year' == 20195 {
		
		di as input "Extraindo arquivo PNADC_anual_`year'..."
		infile using "`dic_19_5'", using("`original'/PNADC_2019_visita5.txt") clear
		if _rc == 0 {
					save PNADC_anual_2019_visita5, replace
					}
				else continue, break
					}					
	
	
	*************************************2020*********************************
	if `year' == 20202 {
		
		di as input "Extraindo arquivo PNADC_anual_`year'..."
		infile using "`dic_20_2'", using("`original'/PNADC_2020_visita2.txt") clear
		if _rc == 0 {
					save PNADC_anual_2020_visita2, replace
					}
				else continue, break
					}	
	if `year' == 20205 {
		
		di as input "Extraindo arquivo PNADC_anual_`year'..."
		infile using "`dic_20_5'", using("`original'/PNADC_2020_visita5.txt") clear
		if _rc == 0 {
					save PNADC_anual_2020_visita5, replace
					}
				else continue, break
					}					
	

	*************************************2021*********************************
		if `year' == 20212 {
		
		di as input "Extraindo arquivo PNADC_anual_`year'..."
		infile using "`dic_20_2'", using("`original'/PNADC_2021_visita2.txt") clear
		if _rc == 0 {
					save PNADC_anual_2021_visita2, replace
					}
				else continue, break
					}					

	if `year' == 20215 {
		
		di as input "Extraindo arquivo PNADC_anual_`year'..."
		infile using "`dic_21_5'", using("`original'/PNADC_2021_visita5.txt") clear
		if _rc == 0 {
					save PNADC_anual_2021_visita5, replace
					}
				else continue, break
					}					
	if `year' == 20214 {
		
		di as input "Extraindo arquivo PNADC_anual_`year'..."
		infile using "`dic_21_4'", using("`original'/PNADC_2021_trimestre4.txt") clear
		if _rc == 0 {
					save PNADC_anual_2021_trimestre4, replace
					}
				else continue, break
					}					

	*************************************2022*********************************
	if `year' == 20222 {
		
		di as input "Extraindo arquivo PNADC_anual_`year'..."
		infile using "`dic_17_2'", using("`original'/PNADC_2022_trimestre2.txt") clear
		if _rc == 0 {
					save PNADC_anual_2022_trimestre2, replace
					}
				else continue, break
					}	

	if `year' == 20223 {
		
		di as input "Extraindo arquivo PNADC_anual_`year'..."
		infile using "`dic_19_3'", using("`original'/PNADC_2022_trimestre3.txt") clear
		if _rc == 0 {
					save PNADC_anual_2022_trimestre3, replace
					}
				else continue, break
					}	

	if `year' == 20225 {
		
		di as input "Extraindo arquivo PNADC_anual_`year'..."
		infile using "`dic_22_5'", using("`original'/PNADC_2022_visita5.txt") clear
		if _rc == 0 {
					save PNADC_anual_2022_visita5, replace
					}
				else continue, break
					}

	if `year' == 20221 {
		
		di as input "Extraindo arquivo PNADC_anual_`year'..."
		infile using "`dic_22_1'", using("`original'/PNADC_2022_visita1.txt") clear
		if _rc == 0 {
					save PNADC_anual_2022_visita1, replace
					}
				else continue, break
					}

	if `year' == 20224 {
		
		di as input "Extraindo arquivo PNADC_anual_`year'..."
		infile using "`dic_21_4'", using("`original'/PNADC_2022_trimestre4.txt") clear
		if _rc == 0 {
					save PNADC_anual_2022_trimestre4, replace
					}
				else continue, break
					}		

	*************************************2023*********************************
	if `year' == 20231 {
		
		di as input "Extraindo arquivo PNADC_anual_`year'..."
		infile using "`dic_23_1'", using("`original'/PNADC_2023_trimestre1.txt") clear
		if _rc == 0 {
					save PNADC_anual_2023_trimestre1, replace
					}
				else continue, break
					}		
	
	if `year' == 20232 {
		
		di as input "Extraindo arquivo PNADC_anual_`year'..."
		infile using "`dic_17_2'", using("`original'/PNADC_2023_trimestre2.txt") clear
		if _rc == 0 {
					save PNADC_anual_2023_trimestre2, replace
					}
				else continue, break
					}

	if `year' == 20234 {
		
		di as input "Extraindo arquivo PNADC_anual_`year'..."
		infile using "`dic_21_4'", using("`original'/PNADC_2023_trimestre4.txt") clear
		if _rc == 0 {
					save PNADC_anual_2023_trimestre4, replace
					}
				else continue, break
					}		

	}
	
	if `year' == 2023v1 {
		
		di as input "Extraindo arquivo PNADC_anual_`year'..."
		infile using "`dic_23_v1'", using("`original'/PNADC_2023_visita1.txt") clear
		if _rc == 0 {
					save PNADC_anual_2023_visita1, replace
					}
				else continue, break
					}
	
	}
	
di _newline "Esta versão do pacote datazoom_pnadcont_anual é compatível com a última versão dos microdados divulgado pelo IBGE em 10/06/2022"
di _newline " As bases de dados foram salvas na pasta `c(pwd)'"

datazoom_message
end
