* VERSION 2.2

program datazoom_pns
syntax, [source(str)] [saving(str)] year(integer) [english]

cd "`source'"

if "`source'" == ""{
	download_pns, year(`year')
}

load_pns, year(`year') `english'

if "`saving'" != ""{
save "`saving'/pns_`year'", replace 

display as result "A base de dados foi salva na pasta `saving'!"
}

if "`source'" == ""{
	erase pns_`year'.txt
}

end

program load_pns
syntax, year(integer) [english]

if "`english'" != "" local lang "_en"

qui findfile pns`year'`lang'.dct
cap infile using "`r(fn)'", using(PNS_`year'.txt) clear

end

program download_pns
syntax, year(integer)

local url "https://ftp.ibge.gov.br/PNS/`year'/Microdados/Dados/PNS_"

if `year' == 2013{
	local complemento "2013.zip"
}
else if `year' == 2019{
	local complemento "2019_20210507.zip"
}

* esses números no final são a última data de atualização, então podem mudar eventualmente

local url `url'`complemento'
di _newline "Downloading from `url'. This may take a few minutes" 
unzipfile `url', replace

end