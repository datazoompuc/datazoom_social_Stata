{smcl}
{* *! version 1.0  08th April 2020}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "Install command2" "ssc install command2"}{...}
{vieweralsosee "Help command2 (if installed)" "help command2"}{...}
{viewerjumpto "Syntax" "datazoom_pnadcontinua##syntax"}{...}
{viewerjumpto "Description" "datazoom_pnadcontinua##description"}{...}
{viewerjumpto "Options" "datazoom_pnadcontinua##options"}{...}
{viewerjumpto "Remarks" "datazoom_pnadcontinua##remarks"}{...}
{viewerjumpto "Examples" "datazoom_pnadcontinua##examples"}{...}
{title:Title}

{phang}
{bf:datazoom_pnadcontinua} {hline 2} Access to STATA format Annual Continuous PNAD databases - Version 1.0

{marker syntax}{...}
{title:Syntax}
{p 8 17 2}
{cmdab:datazoom_pnadcontinua}
[{cmd:,}
{it:options}]

{p}	NOTE: type 'db datazoom_pnadcontinua' to use program through dialog box
	
{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Inputs}
{synopt:{opt years(numlist)}} years of Annual Continuous PNAD {p_end}
{synopt:{opt original(str)}} file paths for each original datafile {p_end}
{synopt:{opt saving(str)}} folder path for saving new databases {p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}

{syntab:Individual Identification}
{synopt:{opt nid}} No Identification {p_end}
{synopt:{opt idbas}} Basic Identification {p_end}
{synopt:{opt idrs}} Advanced Identification {p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}

{marker description}{...}
{title:Description}

{phang}
{cmd:datazoom_pnadcontinua} extracts and constructs Anuual Continuous PNAD compatible STATA format databases from 
original IBGE microdata files, which are not provided by the Portal. For
information on how to acquire original datafiles, see www.ibge.gov.br. The
program covers all years from 2012 to 2020.
 
 {phang} Although Continuous PNAD is a quartely survey, this program does not allow specific quarter to be chosen, only years. The package generates a single database for each year, with quarters appended. 
As Continuous PNAD is still published by IBGE, this program is
under constant update.

{phang} The Continuous PNAD is a panel survey, in which each household is interviewed for five consecutive quarters. Despite correctly identifying the same household in all five interviews, the Pnad Continuous does not assign the same identification number to each member of the household at every interview. 
In case the user wishes to work with an individuals panel,
it is necessary to construct a variable to identify each individual throughout different surveys.
 For this reason we use algorithms suggested by Ribas and Soares (2008).
The authors elaborated a basic system identification and an advanced one. They differ by the number of 
variables used to identify individuals in different surveys.
The idea is to verify inconsistencies in the set of variables. Either way the program may take a resonable 
amount of time to perform the identification process, depending on the computational
capacity.

{phang} If {opt nid} is selected, the program will generate a database for each selected year. Other options
 will yield one database for each PME panel. That is,
the program will generate a database for each set of households with partook the survey cycle in a given 
quarter.
If it is the case, use the command {help append} to tile bases.

{marker options}{...}
{title:Options}
{dlgtab:Inputs}

{phang} 
{opt years(numlist)} specifies the list of years the user wants to work with. This program
covers all years from 2012 to 2020. It is not possible to choose specific quarters.

{phang} {opt original(str)} indicates the path of the original data files. 
There is one data file for each quarter. All of these files must be placed in the same 
folder for the program's proper functioning. The original datafiles are not provided but can be found in IBGE's website. 

{phang} {opt saving(str)} specifies the folder path where the new databases are to be saved.

{marker examples}{...}
{title:Examples}

{phang} NOTE: in order to facilitate the command use, type "db datazoom_pnadcontinua" on the command
    window.


{phang} Example #1: Quarterly databases

{phang} datazoom_pnadcontinua, years(2012 2013 2014) original(C:/pnadc) saving(D:/mydatabases) 

{phang} Three databases will be generated, one for each selected year. 

{title:Author}
{p}

PUC-Rio - Department of Economics

Email {browse "mailto:datazoom@econ.puc-rio.br":datazoom@econ.puc-rio.br}

{title:See also}

Related packages:

{help datazoom_censo} (if installed)   
{help datazoom_pnad} (if installed)    
{help datazoom_pmeantiga} (if installed)  
{help datazoom_pmenova} (if installed)   
{help datazoom_pof2017}(if installed)   
{help datazoom_pof2008}(if installed)   
{help datazoom_pof2002} (if installed)  
{help datazoom_pof1995} (if installed)   
{help datazoom_ecinf} (if installed) 
{help datazoom_pns}  (if installed) 


{p} Type "net from http://www.econ.puc-rio.br/datazoom/english" to install these commands in the English version. 
Type "net from http://www.econ.puc-rio.br/datazoom/portugues" to install these commands in the Portuguese version.
