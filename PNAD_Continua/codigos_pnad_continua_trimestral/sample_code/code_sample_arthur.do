/* -----------------------------------------------------------------------------
Esse do file 
1) seleciona amostra de 1% da PNAD Contínua
2) roda a identificação de individuos avançada em etapas 
----------------------------------------------------------------------------- */

 // caminhos (check your username by typing "di c(username)" in Stata) ----
if "`c(username)'" == "Francisco"   {
    global ROOT "C:/Users/Francisco/Dropbox"
}
else if "`c(username)'" == "f.cavalcanti"   {
    global ROOT "C:/Users/f.cavalcanti/Dropbox"
}
global inpdir     "${ROOT}/DataZoom/BasesIBGE/datazoom_rar/PNAD_CONTINUA/pnadcontinua_trimestral_20190729"  
global outdir     "${ROOT}/sample_arthur"

clear

/*
* 1) seleciona amostra de 1% da PNAD Contínua
forvalues yr = 2012(1)2018 {
	import delimited "$inpdir/PNADC_01`yr'_20190729.txt", encoding(Big5) clear
	sample 1
	export delimited using "$outdir/avancado_etapas/PNADC_01`yr'_20190729.txt", replace	
	
	import delimited "$inpdir/PNADC_02`yr'_20190729.txt", encoding(Big5) clear
	sample 1
	export delimited using "$outdir/avancado_etapas/PNADC_02`yr'_20190729.txt", replace	
	
	import delimited "$inpdir/PNADC_03`yr'_20190729.txt", encoding(Big5) clear
	sample 1
	export delimited using "$outdir/avancado_etapas/PNADC_03`yr'_20190729.txt", replace	
	
	import delimited "$inpdir/PNADC_04`yr'_20190729.txt", encoding(Big5) clear
	sample 1
	export delimited using "$outdir/avancado_etapas/PNADC_04`yr'_20190729.txt", replace	
}

* 2019
import delimited "$inpdir/PNADC_012019_20190729.txt", encoding(Big5) clear
sample 1
export delimited using "$outdir/avancado_etapas/PNADC_012019_20190729.txt", replace	

import delimited "$inpdir/PNADC_022019.txt", encoding(Big5) clear
sample 1
export delimited using "$outdir/avancado_etapas/PNADC_022019.txt", replace	

import delimited "$inpdir/PNADC_032019.txt", encoding(Big5) clear
sample 1
export delimited using "$outdir/avancado_etapas/PNADC_032019.txt", replace	

import delimited "$inpdir/PNADC_042019.txt", encoding(Big5) clear
sample 1
export delimited using "$outdir/avancado_etapas/PNADC_042019.txt", replace	

* 2020
import delimited "$inpdir/PNADC_012020.txt", encoding(Big5) clear
sample 1
export delimited using "$outdir/avancado_etapas/PNADC_012020.txt", replace	

/* identificacao do painel avançado por etapas
	1) é necessário renomear cada arquivo .ado:
		datazoom_pnadcontinua_etapa1
		datazoom_pnadcontinua_etapa2
		datazoom_pnadcontinua_etapa3
		datazoom_pnadcontinua_etapa4
		datazoom_pnadcontinua_etapa5
	para o nome: "datazoom_pnadcontinua"
	2) salvar o arquivo datazoom_pnadcontinua.ado no folder:
		C:\ado\plus\d
	3) rodar a idenficacao avancada (abaixo)
	4) repatir para cada etapa, salvando em folder direntes (./etapa1, ./etapa2, etc)
*/
*/
clear
datazoom_pnadcontinua, years(2012 2013 2014 2015 2016 2017 2018 2019) /*
	*/	original($outdir) 	/*
	*/	saving($outdir/avancado_etapas/etapa2) idrs