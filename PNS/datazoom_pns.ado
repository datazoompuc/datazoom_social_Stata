******************************************************
*                   datazoom_pns.ado                  *
******************************************************
* version 2.1

program define datazoom_pns
syntax, original(str) saving(str) year(integer) [language(string)]

local lang ""
if "`language'" == "eng"{
	local lang "_en"
}

/* Infile */
display as input "Gerando a base..."
display as input "Extraindo `original'/PNS_`year'.txt"
qui findfile pns`year'`lang'.dct
qui infile using "`r(fn)'", using("`original'/PNS_`year'.txt") clear
save "`saving'/pns`year'", replace 

display as result "A base de dados foi salva na pasta `saving'!"
di _newline "Esta versão do pacote datazoom_pns é compatível com os microdados da PNS 2013 divulgados em 30/09/2020 e da PNS 2019 divulgados em 03/03/2021"

end
