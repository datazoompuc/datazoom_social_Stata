{smcl}
{viewerdialog "PNAD Covid" "dialog datazoom_pnad_covid_en"}
{viewerdialog "Package" "dialog datazoom_social_en"}
{vieweralsosee "PNAD" "help datazoom_pnad_en"}{...}
{vieweralsosee "Censo" "help datazoom_censo_en"}{...}
{vieweralsosee "Annual PNAD Contínua" "help datazoom_pnadcont_anual_en"}{...}
{vieweralsosee "PNS" "help datazoom_pns_en"}{...}
{vieweralsosee "PNAD Contínua" "help datazoom_pnadcontinua_en"}{...}
{vieweralsosee "PME" "help datazoom_pme_en"}{...}
{vieweralsosee "POF" "help datazoom_pof_en"}{...}
{vieweralsosee "ECINF" "help datazoom_ecinf_en"}{...}
{viewerjumpto "Syntax" "datazoom_pnad_covid_en##syntax"}{...}
{viewerjumpto "Description" "datazoom_pnad_covid_en##description"}{...}
{viewerjumpto "Options" "datazoom_pnad_covid_en##options"}{...}
{viewerjumpto "Examples" "datazoom_pnad_covid_en##examples"}{...}
{p 8 8 2} {it:Para a versão em português}, {help datazoom_pnad_covid}

{title:Title}

{p 4 4 2}
{cmd:datazoom_pnad_covid} {hline 2} Access to PNAD Covid microdata

{marker syntax}{...}
{title:Syntax}

{p 8 8 2} {cmd:datazoom_pnad_covid} [, {it:options}]
	
{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Inputs}
{synopt:{opt month(numlist)}} months of PNAD COVID19 {p_end}
{synopt:{opt original(str)}} path to original microdata {p_end}
{synopt:{opt saving(str)}} path where databases will be saved {p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}

Use command {cmd:db datazoom_pnad_covid_en} to access through dialog box.

{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:datazoom_pnad_covid} extrai e constrói bases de dados da PNAD COVID19 em formato Stata a partir
dos microdados originais do IBGE. Os dados abrangem vários meses do ano de 2020.
  
{p 4 4 2}
O programa gera uma base para cada mês. Se for o caso, utilize o 
comando {help append} para empilhar as bases.


{marker options}{...}
{title:Options}
{dlgtab:Inputs}

{phang} 
{opt month(numlist)} specifies the list of months the user wants to work with. 

{phang} {opt original(str)} indicates the path of the original data files. 
There is one data file for each of the survey’s quarters. All of these files must be placed in the same folder
for the program’s proper functioning.

{phang} {opt saving(str)} specifies the folder path where the new databases are to be saved.

{marker examples}{...}
{title:Examples}

{p 4 4 2}
Reading June and July 2020 databases

{p 8 6 2}. datazoom_pnad_covid, month(06 07) original("~/mydir") saving("~/mydir")

{p 6 6 2}
Gera duas bases em formato .dta, uma para cada mês.

{title:Author}

{p 4 4 2}
DataZoom     {break}
PUC-Rio - Department of Economics   {break}
Contact through  {browse "https://github.com/datazoompuc/datazoom_social_Stata":Github}      {break}

{space 4}{hline}
