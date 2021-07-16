{smcl}
{it:version 2.2} 

{vieweralsosee "PNAD" "help datazoom_pnas"}{...}
{vieweralsosee "Censo" "help datazoom_censo"}{...}

{viewerjumpto "Syntax" "datazoom_pns##synt"}{...}
{viewerjumpto "Description" "datazoom_pns##desc"}{...}
{viewerjumpto "Options" "datazoom_pns##opt"}{...}
{viewerjumpto "Examples" "datazoom_pns##ex"}{...}

{p 8 8 2} {it:For the English version}, {help datazoom_pns_en}

{p 4 4 2}
{bf:datazoom_pns} - Acesso aos microdados da PNS

{marker synt}

{title:Syntax}

{p 8 8 2} {bf:datazoom_pns} [, {it:options}]

{col 5}{it:options}          	{col 28}{it:Description}
{space 4}{hline 48}
{col 5}source		    	{col 28}Local dos dados brutos
{col 5}year			{col 28}2013 ou 2019
{col 5}saving		    	{col 28}Local para salvar
{col 5}english		    	{col 28}Labels em inglês          
{space 4}{hline 48}
{p 4 4 2}
Digite o comando {bf:db datazoom_pns} para utilizar a função via caixa de diálogo.      {break}

{marker desc}{...}

{title:Description}

{p 4 4 2}
Carrega os dados da PNS para o Stata com os nossos dicionários. Os dados podem ser lidos do armazenamento local ou baixados automaticamente.          {break}

{marker opt}{...}

{title:Options}
{dlgtab:Options}

{phang}
{opt source} Pode ser o caminho para uma pasta contendo os arquivos originais PNS_2013.txt ou PNS_2019.txt. Caso a opção seja omitida, os dados serão baixados do {browse "https://www.ibge.gov.br/estatisticas/sociais/saude/":site} do IBGE.              {break}

{marker ex}{...} 

{title:Examples}

    Para baixar e ler os dados da PNS 2019

        . datazoom_pns, year(2019)

    Caso o arquivo de dados brutos já esteja em seu computador

        . datazoom_pns, source(~/mydir) year(2019)


{title:Author}

{p 4 4 2}
DataZoom     {break}
PUC-Rio      {break}
Contato pelo  {browse "https://github.com/datazoompuc/datazoom_social_Stata":Github}      {break}

{space 4}{hline}

{p 4 4 2}
This help file was dynamically produced by 
{browse "http://www.haghish.com/markdoc/":MarkDoc Literate Programming package} 


