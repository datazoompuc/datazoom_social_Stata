{smcl}
{* *! version 1.0 24th June 2020}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "Install command2" "ssc install command2"}{...}
{vieweralsosee "Help command2 (if installed)" "help command2"}{...}
{viewerjumpto "Syntax" "datazoom_pnad_covid##syntax"}{...}
{viewerjumpto "Description" "datazoom_pnad_covid##description"}{...}
{viewerjumpto "Options" "datazoom_pnad_covid##options"}{...}
{viewerjumpto "Remarks" "datazoom_pnad_covid##remarks"}{...}
{viewerjumpto "Examples" "datazoom_pnad_covid##examples"}{...}
{title:Title}

{phang}
{bf:datazoom_pnad_covid} {hline 2} Access to STATA format PNAD COVID19 em formato STATA - Version 1.0

{marker syntax}{...}
{title:Syntax}
{p 8 17 2}
{cmdab:datazoom_pnad_covid}
[{cmd:,}
{it:options}]

{p}	NOTE: type 'db datazoom_pnadcontinua' to use program through dialog box
	
{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Inputs}
{synopt:{opt month(numlist)}} months of PNAD COVID19 {p_end}
{synopt:{opt original(str)}} files paths for each original datafile {p_end}
{synopt:{opt saving(str)}} folder path for saving new databases {p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}

{marker description}{...}
{title:Description}

{phang}
{cmd:datazoom_pnad_covid} eextracts and constructs PNAD COVID19 STATA format databases from 
original IBGE microdata files, which are not provided by the Portal (for
information on how to acquire original datafiles, see www.ibge.gov.br). The
program suits waves starting from May 2020. Since IBGE still conducts PNAD COVID19 surveys, this program will be continuously updated.
  
{phang} O programa gera uma base para cada mês. Se for o caso, utilize o 
comando {help append} para empilhar as bases.

{phang} The program gerenates a database for each month. 


{marker options}{...}
{title:Opções}
{dlgtab:Inputs}

{phang} 
{opt month(numlist)} specifies the list of monthsthe user wants to work with. 



{phang} {opt original(str)} indicates the path of the original data files. 
There is one data file for each of the survey’s quarters. All of these files must be placed in the same folder
for the program’s proper functioning. The original datafiles are not provided but can be found in IBGE’s website. 

{phang} {opt saving(str)} specifies the folder path where the new databases are to be saved.

{marker examples}{...}
{title:Exemplos}

{phang} NOTE: in order to facilitate the command use, type "db datazoom_pnad_covid" on the command
    window.

{title:Autor}
{p}

PUC-Rio - Department of Economics

Email {browse "mailto:datazoom@econ.puc-rio.br":datazoom@econ.puc-rio.br}

{title:See also}

Related packages:

{help datazoom_censo} (if installed)   
{help datazoom_pnad} (if installed)
{help datazoom_pnadcontinua} (if installed)  
{help datazoom_pnadcont_anual} (if installed)    
{help datazoom_pmeantiga} (if installed)  
{help datazoom_pmenova} (if installed)   
{help datazoom_pof2017}(if installed)  
{help datazoom_pof2008}(if installed)   
{help datazoom_pof2002} (if installed)  
{help datazoom_pof1995} (if installed)   
{help datazoom_ecinf} (if installed) 
{help datazoom_pns}  (if installed) 

Pacotes relacionados:


{p} Type "net from http://www.econ.puc-rio.br/datazoom/english" to install these commands in the english version. 
Para instalar a versão em português, digite "net from http://www.econ.puc-rio.br/datazoom/portugues".
