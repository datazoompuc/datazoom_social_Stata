{smcl}
{it:version 2.0} 

{phang} {it:Para a versão em Português}, {help datazoom_pns}


{title:datazoom_pns}

{p 4 4 2}
Loads PNS microdata into memory


{title:Syntax}

{p 8 8 2} {bf:datazoom_pns} [, {it:options}]

{col 5}{it:option}{col 24}{it:Description}
{space 4}{hline 44}
{col 5}source		{col 24}Path to stored raw data.
{col 5}year		{col 24}Either 2013 or 2019
{col 5}saving		{col 24}Path to save
{col 5}english		{col 24}Translates variable labels
{space 4}{hline 44}


{title:Description}

{p 4 4 2}
Uses our dictionaries to read PNS data into Stata. Can either load the data from storage or download it directly from the IBGE website.

{p 4 4 2}
Access the function{c 39}s dialog box with the {bf:db datazoom_pns} command.


{title:Options}

{phang}
{opt source} can either be the path to a directory containing PNS_2013.txt or PNS_2019.txt files, or it can be left out entirely, in which case data will be pulled from the  {browse "https://www.ibge.gov.br/estatisticas/sociais/saude/9160-pesquisa-nacional-de-saude.html?=&t=microdados":IBGE website}.


{title:Examples}

    Downloads and reads the 2019 PNS data 

        . datazoom_pns, year(2019)

    In case the data is already in your local storage

        . datazoom_pns, source(~/mydir) year(2019)


{title:Author}

{p 4 4 2}
DataZoom     {break}
PUC-Rio      {break}
Reach out to us via  {browse "https://github.com/datazoompuc/datazoom_social_Stata":Github}      {break}


{title:License}

{p 4 4 2}
Specify the license of the software

{space 4}{hline}

{p 4 4 2}
This help file was dynamically produced by 
{browse "http://www.haghish.com/markdoc/":MarkDoc Literate Programming package} 


