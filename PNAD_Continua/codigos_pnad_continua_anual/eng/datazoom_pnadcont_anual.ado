******************************************************
*             datazoom_pnadcontinua_anual.ado              *
******************************************************
* version 1.0
program define datazoom_pnadcont_anual

syntax, years(str) original(str) saving(str) 

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

findfile pnad_anual_en_2012a2014.dct
loc dic_14_1 = r(fn)

findfile pnad_anual_en_1entr_2015.dct
loc dic_15_1 = r(fn)

findfile pnad_anual_en_1entr_2016.dct
loc dic_16_1 = r(fn)

findfile pnad_anual_en_5entr_2016.dct
loc dic_16_5 = r(fn)

findfile pnad_anual_en_1entr_2017.dct
loc dic_17_1 = r(fn)

findfile pnad_anual_en_educ.dct
loc dic_17_2 = r(fn)

findfile pnad_anual_en_tic.dct
loc dic_17_4 = r(fn)

findfile pnad_anual_en_5entr_2017.dct
loc dic_17_5 = r(fn)

findfile pnad_anual_en_1entr_2018.dct
loc dic_18_1 = r(fn)

findfile pnad_anual_en_5entr_2018.dct
loc dic_18_5 = r(fn)

findfile pnad_anual_en_1entr_2019.dct
loc dic_19_1 = r(fn)

findfile pnad_anual_en_5entr_2019.dct
loc dic_19_5 = r(fn)

/* Extraindo dos arquivos */


	
foreach year in `years' {
*************************************2012*********************************
	if `year' == 2012 {
	findfile pnad_anual_en_2012a2014.dct
    loc dic_14_1 = r(fn)
		di as input "Extracting files from PNADC_anual_`year'..."
		cap infile using "`dic_14_1'", using("`original'/PNADC_2012_visita1.txt") clear
				if _rc == 0 {
					save PNADC_anual_2012_visita1, replace
					}
				else continue, break
					}
*************************************2013*********************************
	if `year' == 2013 {
	findfile pnad_anual_en_2012a2014.dct
    loc dic_14_1 = r(fn)
		di as input "Extracting files from PNADC_anual_`year'..."
		cap infile using "`dic_14_1'", using("`original'/PNADC_2013_visita1.txt") clear
				if _rc == 0 {
					save PNADC_anual_2013_visita1, replace
					}
				else continue, break
					}
*************************************2014*********************************
	if `year' == 2014 {
	findfile pnad_anual_en_2012a2014.dct
    loc dic_14_1 = r(fn)
		di as input "Extracting files from  PNADC_anual_`year'..."
		cap infile using "`dic_14_1'", using("`original'/PNADC_2014_visita1.txt") clear
				if _rc == 0 {
					save PNADC_anual_2014_visita1, replace
					}
				else continue, break
					}
*************************************2015*********************************
	if `year' == 2015 {
	findfile pnad_anual_en_1entr_2015.dct
    loc dic_15_1 = r(fn)
	
		di as input "Extracting files from PNADC_anual_`year'..."
		cap infile using "`dic_15_1'", using("`original'/PNADC_2015_visita1.txt") clear
				if _rc == 0 {
					save PNADC_anual_2015_visita1, replace
					}
				else continue, break
					}
*************************************2016*********************************
	if `year' == 20161 {
	findfile pnad_anual_en_1entr_2016.dct
    loc dic_16_1 = r(fn)
		di as input "Extracting files from PNADC_anual_`year'..."
		cap infile using "`dic_16_1'", using("`original'/PNADC_2016_visita1.txt") clear
				if _rc == 0 {
					save PNADC_anual_2016_visita1, replace
					}
				else continue, break
					}
		if `year' == 20162 {
		findfile pnad_anual_en_educ.dct
        loc dic_17_2 = r(fn)
		di as input "Extracting files from PNADC_anual_`year'..."
		cap infile using "`dic_17_2'", using("`original'/PNADC_022016_educacao.txt") clear
		if _rc == 0 {
					save PNADC_anual_2016_educ, replace
					}
				else continue, break
					}
		if `year' == 20164 {
		findfile pnad_anual_en_tic.dct
        loc dic_17_4 = r(fn)
		di as input "Extracting files from PNADC_anual_`year'..."
		cap infile using "`dic_17_4'", using("`original'/PNADC_042016_tic.txt") clear
		if _rc == 0 {
					save PNADC_anual_2016_tic, replace
					}
				else continue, break
					}
		if `year' == 20165 {
		findfile pnad_anual_en_5entr_2016.dct
        loc dic_16_5 = r(fn)
		di as input "Extracting files from PNADC_anual_`year'..."
		cap infile using "`dic_16_5'", using("`original'/PNADC_2016_visita5.txt") clear
		if _rc == 0 {
					save PNADC_anual_2016_visita5, replace
					}
				else continue, break
					}
*************************************2017*********************************
	if `year' == 20171 {
	    findfile pnad_anual_en_1entr_2017.dct
        loc dic_17_1 = r(fn)
		di as input "Extracting files from PNADC_anual_`year'..."
		cap infile using "`dic_17_1'", using("`original'/PNADC_2017_visita1.txt") clear
				if _rc == 0 {
					save PNADC_anual_2017_visita1, replace
					}
				else continue, break
					}
					
		if `year' == 20172 {
		findfile pnad_anual_en_educ.dct
        loc dic_17_2 = r(fn)
		di as input "Extracting files from PNADC_anual_`year'..."
		cap infile using "`dic_17_2'", using("`original'/PNADC_022017_educacao.txt") clear
		if _rc == 0 {
					save PNADC_anual_2017_educ, replace
					}
				else continue, break
					}
					
		if `year' == 20174 {
		findfile pnad_anual_en_tic.dct
        loc dic_17_4 = r(fn)
		di as input "Extracting files from PNADC_anual_`year'..."
		cap infile using "`dic_17_4'", using("`original'/PNADC_042017_tic.txt") clear
		if _rc == 0 {
					save PNADC_anual_2017_tic, replace
					}
				else continue, break
					}
					
		if `year' == 20175 {
		findfile pnad_anual_en_5entr_2017.dct
        loc dic_17_5 = r(fn)
		di as input "Extracting files from PNADC_anual_`year'..."
		cap infile using "`dic_17_5'", using("`original'/PNADC_2017_visita5.txt") clear
		if _rc == 0 {
					save PNADC_anual_2017_visita5, replace
					}
				else continue, break
					}
	
	*************************************2018*********************************
	if `year' == 20181 {
	    findfile pnad_anual_en_1entr_2018.dct
        loc dic_18_1 = r(fn)
		di as input "Extracting files from PNADC_anual_`year'..."
		cap infile using "`dic_18_1'", using("`original'/PNADC_2018_visita1.txt") clear
				if _rc == 0 {
					save PNADC_anual_2018_visita1, replace
					}
				else continue, break
					}
	if `year' == 20182 {
	    findfile pnad_anual_en_educ.dct
        loc dic_17_2 = r(fn)
		di as input "Extracting files from PNADC_anual_`year'..."
		cap infile using "`dic_17_2'", using("`original'/PNADC_022018_educacao.txt") clear
		if _rc == 0 {
					save PNADC_anual_2018_educ, replace
					}
				else continue, break
					}
		if `year' == 20185 {
		findfile pnad_anual_en_5entr_2018.dct
        loc dic_18_5 = r(fn)
		di as input "Extracting files from PNADC_anual_`year'..."
		cap infile using "`dic_18_5'", using("`original'/PNADC_2018_visita5.txt") clear
		if _rc == 0 {
					save PNADC_anual_2018_visita5, replace
					}
				else continue, break
					}
	*************************************2019*********************************
	if `year' == 20191 {
	findfile pnad_anual_en_1entr_2019.dct
    loc dic_19_1 = r(fn)
		di as input "Extracting files from PNADC_anual_`year'..."
		cap infile using "`dic_19_1'", using("`original'/PNADC_2019_visita1.txt") clear
				if _rc == 0 {
					save PNADC_anual_2019_visita1, replace
					}
				else continue, break
					}
	if `year' == 20192 {
	findfile pnad_anual_en_educ.dct
    loc dic_17_2 = r(fn)
		di as input "Extracting files from PNADC_anual_`year'..."
		cap infile using "`dic_17_2'", using("`original'/PNADC_022019_educacao.txt") clear
		if _rc == 0 {
					save PNADC_anual_2019_educ, replace
					}
				else continue, break
					}
		if `year' == 20195 {
		findfile pnad_anual_en_5entr_2019.dct
        loc dic_19_5 = r(fn)
		di as input "Extracting files from PNADC_anual_`year'..."
		cap infile using "`dic_19_5'", using("`original'/PNADC_2019_visita5.txt") clear
		if _rc == 0 {
					save PNADC_anual_2019_visita5, replace
					}
				else continue, break
					}
	}


	
di _newline "This version of the datazoom_pnadcont_anual package is compatible with the latest version of  the continuous annual PNAD data published on 10/16/2019."
di _newline " Databases were saved in `c(pwd)'"
end
