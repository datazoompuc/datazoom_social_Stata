{smcl}
{it:version 2.2} 

{vieweralsosee "PNAD" "help datazoom_pnas"}{...}
{vieweralsosee "Censo" "help datazoom_censo"}{...}

{viewerjumpto "Syntax" "datazoom_pns##synt"}{...}
{viewerjumpto "Description" "datazoom_pns##desc"}{...}
{viewerjumpto "Options" "datazoom_pns##opt"}{...}
{viewerjumpto "Examples" "datazoom_pns##ex"}{...}

{p 8 8 2} {it:Para a versão em Português}, {help datazoom_pns}

{p 4 4 2}
{bf:datazoom_pns} - Loads PNS microdata
{marker synt}

{title:Syntax}

{p 8 8 2} {bf:datazoom_pns} [, {it:options}]

{col 5}{it:options}          	{col 28}{it:Description}
{space 4}{hline 48}
{col 5}source		    	{col 28}Path to raw data
{col 5}year			{col 28}Either 2013 or 2019
{col 5}saving		    	{col 28}Path to save
{col 5}english		    	{col 28}Translates variable labels         
{space 4}{hline 48}
{p 4 4 2}
Access the dialog box with the {bf:db datazoom_pns} command.      {break}

{marker desc}{...}

{title:Description}

{p 4 4 2}
Uses our dictionaries to read PNS data into Stata. Can either load the data from storage or download it automatically.          {break}

{marker opt}{...}

{title:Options}
{dlgtab:Options}

{phang}
{opt source} Can either be the path to a directory containing PNS_2013.txt or PNS_2019.txt files, or it can be left out entirely, in which case data will be pulled from the {browse "https://www.ibge.gov.br/estatisticas/sociais/saude/":IBGE website}.              {break}

{marker ex}{...} 

{title:Examples}

    Downloads and reads the 2019 PNS data 

        . datazoom_pns, year(2019)

    In case the data is already in your local storage

        . datazoom_pns, source(~/mydir) year(2019)


{title:Author}

{p 4 4 2}
DataZoom     {break}
PUC-Rio      {break}
Contact through  {browse "https://github.com/datazoompuc/datazoom_social_Stata":Github}      {break}

{space 4}{hline}

{p 4 4 2}
This help file was dynamically produced by 
{browse "http://www.haghish.com/markdoc/":MarkDoc Literate Programming package} 


