{smcl}
{viewerdialog "Annual PNAD Contínua" "dialog datazoom_pnadcont_anual_en"}
{viewerdialog "Package" "dialog datazoom_social_en"}
{vieweralsosee "PNAD" "help datazoom_pnad_en"}{...}
{vieweralsosee "Censo" "help datazoom_censo_en"}{...}
{vieweralsosee "PNAD Contínua" "help datazoom_pnadcontinua_en"}{...}
{vieweralsosee "PNS" "help datazoom_pns_en"}{...}
{vieweralsosee "PNAD Covid" "help datazoom_pnad_covid_en"}{...}
{vieweralsosee "PME" "help datazoom_pme_en"}{...}
{vieweralsosee "POF" "help datazoom_pof_en"}{...}
{vieweralsosee "ECINF" "help datazoom_ecinf_en"}{...}
{viewerjumpto "Syntax" "datazoom_pnadcont_anual_en##syntax"}{...}
{viewerjumpto "Description" "datazoom_pnadcont_anual_en##description"}{...}
{viewerjumpto "Options" "datazoom_pnadcont_anual_en##options"}{...}
{viewerjumpto "Examples" "datazoom_pnadcont_anual_en##examples"}{...}
{p 8 8 2} {it:Para a versão em português}, {help datazoom_pnadcont_anual}

{title:Title}

{p 4 4 2}
{cmd:datazoom_pnadcont_anual} {hline 2} Access to Continuous PNAD microdata {c -} Annual Dissemination

{marker syntax}{...}
{title:Syntax}

{p 8 8 2} {cmd:datazoom_pnadcont_anual} [, {it:options}]
	
{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Input}
{synopt:{opt years(numlist)}}  {p_end}
{synopt:{opt original(str)}} path to original microdata {p_end}
{synopt:{opt saving(str)}} path where databases will be saved {p_end}
{synopt:{opt english}} variable labels in English {p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}

Use command {cmd:db datazoom_pnadcont_anual_en} to access through dialog box.

{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:datazoom_pnadcont_anual} extracts and builds databases from the original PNAD Contínua 
Annual Dissemination microdata, for years 2012 to 2019. 

{p 4 4 2}
Although Annual Continuous PNAD is an annual survey, from 2016 this program allows selection for the first interview of the household (2016_entr1 and 2017_entr1 ) and 
for the 5th interview of the household (2016_entr5 and 2017_entr5). This is due to the change in IBGE's survey with the transfer of the questions  "Other forms of work"
 to the 5th home interview in the years 2016 and 2019. For each interview, there is an original txt database available on the IBGE website. 
 For more information about the survey's change, read the technical note of the survey on the IBGE website.
 
{p 4 4 2}
Since IBGE still conducts Annual PNAD Continuous surveys, this program will be continuously updated.
  
{p 4 4 2}
The program generates a database for each selected year. If necessary, use
command {help append} in order to aggregate all years.

{marker options}{...}
{title:Options}
{dlgtab:Input}

{phang} 
{opt years(numlist)} specifies the list of years the user wants to work with. This program
covers all years from 2012 to 2019.

{phang} {opt original(str)} indicates the path of the original data files. 
There is one data file for each annual survey, except for 2016 and 2017, when there are two annual surveys per year 
(one referring to the first interview and another referring to the fifth interview). All of these files must be placed in the same 
folder for the program's proper functioning.

{phang} {opt saving(str)} specifies the folder path where the new databases are to be saved.

{marker examples}{...}
{title:Examples}

{p 4 4 2}
Annual databases, with English variable labels

{p 8 6 2}. datazoom_pnadcont_anual, years(2012 2014 2015) original("~/mydir") saving("~/mydir") english 

{p 6 6 2}
Three databases are created, one per year.

{title:Author}

{p 4 4 2}
DataZoom     {break}
PUC-Rio - Department of Economics   {break}
Contact through  {browse "https://github.com/datazoompuc/datazoom_social_Stata":Github}      {break}

{space 4}{hline}
