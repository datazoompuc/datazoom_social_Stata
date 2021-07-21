{smcl}
{* *! version 1.0 18 Jun 2013}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "Install command2" "ssc install command2"}{...}
{vieweralsosee "Help command2 (if installed)" "help command2"}{...}
{viewerjumpto "Syntax" "c:/ado/plus/p/datazoom_poftrs_08##syntax"}{...}
{viewerjumpto "Description" "c:/ado/plus/p/datazoom_poftrs_08##description"}{...}
{viewerjumpto "Options" "c:/ado/plus/p/datazoom_poftrs_08##options"}{...}
{viewerjumpto "Remarks" "c:/ado/plus/p/datazoom_poftrs_08##remarks"}{...}
{viewerjumpto "Examples" "c:/ado/plus/p/datazoom_poftrs_08##examples"}{...}
{title:Title}

{phang}
{bf:datazoom_poftrs_08} {hline 2}  Access to STATA format POF 2008-09 databases - Version 1.2

{marker syntax}{...}
{title:Syntax}
{p 8 17 2}
{cmdab:datazoom_poftrs_08}
[{cmd:,}
{it:options}]

{phang} NOTE: Type 'db datazoom_pof2008' in the command window in order to use the program
 through the dialog box (strongly recommended).

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{opt trs(string)}} types of register {p_end}
{synopt:{opt original(string)}} folder path where original datafiles are located {p_end}
{synopt:{opt saving(string)}} folder where new databases are to be saved {p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}

{marker description}{...}
{title:Description}

{phang}
{cmd:datazoom_poftrs_08} extracts STATA format databases (.dta) of POF 2008-09 from 
original microdata, which are not available online (for information on how
to acquire original data, see www.ibge.gov.br). This program is part of POF 2008-09
  package, which also contains {help datazoom_pofstd_08} and {help datazoom_pofsel_08}
 (these programs are independent from each other). 

{phang} This program facilitates access to the 16 existing types of register of POF 2008-09, 
without any manipulation of the variables. That is,
it makes the use of POF microdata via STATA possible.


{marker options}{...}
{title:Options}
{dlgtab:Main}

{phang}
{opt trs(string)}  specifies the type(s) of register the user wants to obtain. There are 16 
types of register in the 2008-09 version, numbered according IBGE documentation.

{phang}
{opt original(string)}  indicates the path of the folder where the original data files are 
located. All 16 files must be located in the same folder so that the program
functions properly.	The Portal does not provide these data.

{phang}
{opt saving(string)}  indicates the path of the folder where the user wants to save the new datafiles.


{marker examples}{...}
{title:Examples}

{phang} datazoom_poftrs_08, trs(tr1 tr6 tr16) original(c:/mydata) saving(c:/pof)

{phang} The command above generates three databases, one for each type of register 
(1 - Household; 6 - 12-month Expenditures; 12 - Income and Deductions).
All three are saved in the folder "c:/pof".

{phang}  NOTE: In order to facilitate the command use, type "db datazoom_pof2008" on the 
command window (strongly recommended).

{title:Author}
{p}

PUC-Rio - Department of Economics

Email {browse "mailto:datazoom@econ.puc-rio.br":datazoom@econ.puc-rio.br}

{title:See Also}

Related commands:

{help datazoom_censo} (if installed)  
{help datazoom_pnad} (if installed) 
{help datazoom_pmenova} (if installed)  
{help datazoom_pmeantiga} (if installed)  
{help datazoom_pof2002} (if installed)  
{help datazoom_pof1995} (if installed)  
{help datazoom_ecinf} (if installed) 


{p} Type "net from http://www.econ.puc-rio.br/datazoom/english" to install these commands.
Para instalar a versão em portugues, digite "net from http://www.econ.puc-rio.br/datazoom/portugues".
