/***
_version 2.2_ 

{vieweralsosee "PNAD" "help datazoom_pnas"}{...}
{vieweralsosee "Censo" "help datazoom_censo"}{...}

{viewerjumpto "Syntax" "datazoom_pns##synt"}{...}
{viewerjumpto "Description" "datazoom_pns##desc"}{...}
{viewerjumpto "Options" "datazoom_pns##opt"}{...}
{viewerjumpto "Examples" "datazoom_pns##ex"}{...}

> _For the English version_, {help datazoom_pns_en}

__datazoom_pns__ - Acesso aos microdados da PNS

{marker synt}
Syntax
------

> __datazoom_pns__ [, _options_]

| _options_          	|  _Description_          |
|:----------------------|:------------------------|
| source		    	| Local dos dados brutos  |
| year			| 2013 ou 2019            |
| saving		    	| Local para salvar       |
| english		    	| Labels em inglês        |

Digite o comando __db datazoom_pns__ para utilizar a função via caixa de diálogo.       

{marker desc}{...}
Description
------

Carrega os dados da PNS para o Stata com os nossos dicionários. Os dados podem ser lidos do armazenamento local ou baixados automaticamente.         

{marker opt}{...}
Options
-------
{dlgtab:Options}

{phang}
{opt source} Pode ser o caminho para uma pasta contendo os arquivos originais PNS_2013.txt ou PNS_2019.txt. Caso a opção seja omitida, os dados serão baixados do {browse "https://www.ibge.gov.br/estatisticas/sociais/saude/":site} do IBGE.               

{marker ex}{...} 
Examples
----------

    Para baixar e ler os dados da PNS 2019

        . datazoom_pns, year(2019)

    Caso o arquivo de dados brutos já esteja em seu computador

        . datazoom_pns, source(~/mydir) year(2019)

Author
------

DataZoom   
PUC-Rio    
Contato pelo [Github](https://github.com/datazoompuc/datazoom_social_Stata)    

- - -

This help file was dynamically produced by 
[MarkDoc Literate Programming package](http://www.haghish.com/markdoc/) 
***/

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
