{smcl}
{viewerdialog "PNS" "dialog datazoom_pns_en"}
{viewerdialog "Package" "dialog datazoom_social_en"}
{vieweralsosee "PNAD" "help datazoom_pnad_en"}{...}
{vieweralsosee "Censo" "help datazoom_censo_en"}{...}
{vieweralsosee "PNAD Contínua Trimestral" "help datazoom_pnadcontinua_en"}{...}
{vieweralsosee "Annual PNAD Contínua" "help datazoom_pnadcont_anual_en"}{...}
{vieweralsosee "PNAD Covid" "help datazoom_pnad_covid_en"}{...}
{vieweralsosee "PME" "help datazoom_pme_en"}{...}
{vieweralsosee "POF" "help datazoom_pof_en"}{...}
{vieweralsosee "ECINF" "help datazoom_ecinf_en"}{...}
{viewerjumpto "Syntax" "datazoom_pns_en##syntax"}{...}
{viewerjumpto "Description" "datazoom_pns_en##description"}{...}
{viewerjumpto "Options" "datazoom_pns_en##options"}{...}
{viewerjumpto "Examples" "datazoom_pns_en##examples"}{...}
{p 8 8 2} {it:Para a versão em português}, {help datazoom_pns}

{p 4 4 2}
{cmd:datazoom_pns} - Access to PNS microdata

{marker syntax}
{title:Syntax}

{p 8 8 2} {cmd:datazoom_pns} [, {it:options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{opt original(str)}} path to original microdata {p_end}
{synopt:{opt year(int)}} survey year, either 2013 or 2019 {p_end}
{synopt:{opt saving(str)}} path where databases will be saved {p_end}
{synopt:{opt english}} variable labels in English {p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}

Use command {cmd:db datazoom_pns_en} to access through dialog box.

{marker description}{...}
{title:Description}

{p 4 4 2}
Uses our dictionaries to read PNS data into Stata. Can either load the data from storage or download it automatically.          {break}

{marker options}{...}

{title:Options}
{dlgtab:Options}

{phang}
{opt source} Can either be the path to a directory containing PNS_2013.txt or PNS_2019.txt files, or it can be left out entirely, in which case data will be pulled from the {browse "https://www.ibge.gov.br/estatisticas/sociais/saude/":IBGE website}.              {break}

{marker examples}{...} 

{title:Examples}

{p 4 4 2}
Reads 2019 PNS data, adding English variable labels

{p 8 6 2}. datazoom_pns, source(~/mydir) year(2019) english


{title:Author}

{p 4 4 2}
DataZoom     {break}
PUC-Rio - Department of Economics   {break}
Contact through  {browse "https://github.com/datazoompuc/datazoom_social_Stata":Github}      {break}

{space 4}{hline}

{p 4 4 2}
This help file was dynamically produced by 
{browse "http://www.haghish.com/markdoc/":MarkDoc Literate Programming package} 


