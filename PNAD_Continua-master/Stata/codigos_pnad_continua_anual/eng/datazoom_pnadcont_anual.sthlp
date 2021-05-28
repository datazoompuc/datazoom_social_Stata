
{smcl}
{* *! version 1.0  23rd June 2020}{...}
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
{bf:datazoom_pnadcont_anual} {hline 2} Access to STATA format Annual Continuous PNAD databases - Version 1.0

{marker syntax}{...}
{title:Syntax}
{p 8 17 2}
{cmdab:datazoom_pnadcont_anual}
[{cmd:,}
{it:options}]

{p}	NOTE: type 'db datazoom_pnadcont_anual' to use program through dialog box
	
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

{marker description}{...}
{title:Description}

{phang}
{cmd:datazoom_pnadcont_anual} extracts and constructs Anuual Continuous PNAD compatible STATA format databases from 
original IBGE microdata files, which are not provided by the Portal. For
information on how to acquire original datafiles, see www.ibge.gov.br. The
program covers all years from 2012 to 2019.
 
{phang} Although Annual Continuous PNAD is an annual survey, from 2016 this program allows selection for the first interview of the household (2016_entr1 and 2017_entr1 ) and 
for the 5th interview of the household (2016_entr5 and 2017_entr5). This is due to the change in IBGE's survey with the transfer of the questions  "Other forms of work"
 to the 5th home interview in the years 2016 and 2019. For each interview, there is an original txt database available on the IBGE website. 
 For more information about the survey's change, read the technical note of the survey on the IBGE website.

{phang} Since IBGE still conducts Annual PNAD Continuous surveys, this program will be continuously updated.
  
{phang} The program generates a database for each selected year. If necessary, use the 
command append in order to aggregate all years.



{marker options}{...}
{title:Options}
{dlgtab:Inputs}

{phang} 
{opt years(numlist)} specifies the list of years the user wants to work with. This program
covers all years from 2012 to 2019.


{phang} {opt original(str)} indicates the path of the original data files. 
There is one data file for each annual survey, except for 2016 and 2017, when there are two annual surveys per year 
(one referring to the first interview and another referring to the fifth interview). All of these files must be placed in the same 
folder for the program's proper functioning. The original datafiles are not provided but can be found in IBGE's website. 

{phang} {opt saving(str)} specifies the folder path where the new databases are to be saved.

{marker examples}{...}
{title:Examples}

{phang} NOTE: in order to facilitate the command use, type "db datazoom_pnadcont_anual" on the command
    window.


{phang} Example #1: Annual databases 

{phang} datazoom_pnadcont_anual, years(2012 2013 2014) original(C:/pnadc) saving(D:/mydatabases) 

{phang} Three databases will be generated, one for each selected year. 

{title:Author}
{p}

PUC-Rio - Department of Economics

Email {browse "mailto:datazoom@econ.puc-rio.br":datazoom@econ.puc-rio.br}

{title:See also}

Related packages:

{help datazoom_pnad_covid} (if installed) 
{help datazoom_pnadcontinua} (if installed) 
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
