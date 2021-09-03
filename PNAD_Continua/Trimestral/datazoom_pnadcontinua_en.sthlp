{smcl}
{viewerdialog "PNAD Contínua" "dialog datazoom_pnadcontinua_en"}
{viewerdialog "Package" "dialog datazoom_social_en"}
{vieweralsosee "PNAD" "help datazoom_pnad_en"}{...}
{vieweralsosee "Censo" "help datazoom_censo_en"}{...}
{vieweralsosee "Annual PNAD Contínua" "help datazoom_pnadcont_anual_en"}{...}
{vieweralsosee "PNS" "help datazoom_pns_en"}{...}
{vieweralsosee "PNAD Covid" "help datazoom_pnad_covid_en"}{...}
{vieweralsosee "PME" "help datazoom_pme_en"}{...}
{vieweralsosee "POF" "help datazoom_pof_en"}{...}
{vieweralsosee "ECINF" "help datazoom_ecinf_en"}{...}
{viewerjumpto "Syntax" "datazoom_pnadcontinua_en##syntax"}{...}
{viewerjumpto "Description" "datazoom_pnadcontinua_en##description"}{...}
{viewerjumpto "Options" "datazoom_pnadcontinua_en##options"}{...}
{viewerjumpto "Examples" "datazoom_pnadcontinua_en##examples"}{...}
{p 8 8 2} {it:Para a versão em português}, {help datazoom_pnadcontinua}

{title:Title}

{p 4 4 2}
{cmd:datazoom_pnadcont_anual} {hline 2} Access to Continuous PNAD microdata {c -}  Quarterly Dissemination

{marker syntax}{...}
{title:Syntax}

{p 8 8 2} {cmd:datazoom_pnadcontinua} [, {it:options}]
	
{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Input}
{synopt:{opt years(numlist)}} {p_end}
{synopt:{opt original(str)}} path to original microdata {p_end}
{synopt:{opt saving(str)}} path where databases will be saved {p_end}
{synopt:{opt english}} variable labels in English {p_end}

{syntab:Individual Identification}
{synopt:{opt nid}} No identification {p_end}
{synopt:{opt idbas}} Basic {p_end}
{synopt:{opt idrs}} Advanced (Ribas-Soares) {p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}

Use command {cmd:db datazoom_pnadcontinua_en} to access through dialog box.

{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:datazoom_pnadcontinua} extracts Continuous PNAD databases from the original IBGE microdata. 
Can be used for years 2012 to 2020. 

{p 4 4 2}
Although Continuous PNAD is a quartely survey, this program does not allow specific quarter to be chosen, only years. The package generates a single database for each year, with quarters appended. 
As Continuous PNAD is still published by IBGE, this program is
under constant update.
  
{p 4 4 2}
The Continuous PNAD is a panel survey, in which each household is interviewed for five consecutive quarters. Despite correctly identifying the same household in all five interviews, the Pnad Continuous does not assign the same identification number to each member of the household at every interview. 
In case the user wishes to work with an individuals panel,
it is necessary to construct a variable to identify each individual throughout different surveys.
 For this reason we use algorithms suggested by Ribas and Soares (2008).
The authors elaborated a basic system identification and an advanced one. They differ by the number of 
variables used to identify individuals in different surveys.
The idea is to verify inconsistencies in the set of variables. Either way the program may take a resonable 
amount of time to perform the identification process, depending on the computational
capacity.

{p 4 4 2}
If {opt nid} is selected, the program will generate a database for each selected year. Other options
 will yield one database for each PME panel. That is,
the program will generate a database for each set of households with partook the survey cycle in a given 
quarter. If so desired, use command {help append} to pool together databases.


{marker options}{...}
{title:Options}
{dlgtab:Input}

{phang} 
{opt years(numlist)} specifies the list of years the user wants to work with. This program
covers all years from 2012 to 2020. It is not possible to choose specific quarters.

{phang} {opt original(str)} indicates the path of the original data files. 
There is one data file for each quarter. All of these files must be placed in the same 
folder for the program's proper functioning.

{phang} {opt saving(str)} specifies the folder path where the new databases are to be saved.

{marker examples}{...}
{title:Examples}

{p 4 4 2}
Quarterly databases, with English variable labels

{p 8 6 2}datazoom_pnadcontinua, years(2012 2013 2014) original("~/mydata") saving("~/mydata") english

{p 6 6 2}
Three databases are created, one for each year.

{title:Author}

{p 4 4 2}
DataZoom     {break}
PUC-Rio - Department of Economics   {break}
Contact through  {browse "https://github.com/datazoompuc/datazoom_social_Stata":Github}      {break}

{space 4}{hline}
