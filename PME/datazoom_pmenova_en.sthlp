{smcl}
{* *! version 1.3 Feb 2016}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "Install command2" "ssc install command2"}{...}
{vieweralsosee "Help command2 (if installed)" "help command2"}{...}
{viewerjumpto "Syntax" "datazoom_pmenova##syntax"}{...}
{viewerjumpto "Description" "datazoom_pmenova##description"}{...}
{viewerjumpto "Options" "datazoom_pmenova##options"}{...}
{viewerjumpto "Remarks" "datazoom_pmenova##remarks"}{...}
{viewerjumpto "Examples" "datazoom_pmenova##examples"}{...}
{title:Title}

{phang}
{bf:datazoom_pmenova} {hline 2} Access to STATA format PME-Nova databases - Version 1.3

{marker syntax}{...}
{title:Syntax}
{p 8 17 2}
{cmdab:datazoom_pmenova}
[{cmd:,}
{it:options}]

	Note: type 'db datazoom_pmenova' to use program through dialog box

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Inputs}
{synopt:{opt years(numlist)}} waves {p_end}
{synopt:{opt original(string)}} folder path where original datafiles are located {p_end}
{synopt:{opt saving(string)}} folder where new databases are to be saved {p_end}

{syntab:Individual Identification}
{synopt:{opt nid}} No identification {p_end}
{synopt:{opt idbas}} Basic {p_end}
{synopt:{opt idrs}} Advanced (Ribas-Soares) {p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}

{marker description}{...}
{title:Description}

{phang}
{cmd:datazoom_pmenova} extracts PME-New methodology databases from original 
	IBGE microdata files, which are not available online (for information on how to acquire these data, see www.ibge.gov.br).
	The program suits the period from 2002 to 2016.
	
{phang} Although this is a monthly survey, this program does not allow specific months to be chosen, only years. 
As PME is still published by IBGE, this program is
under constant update. There is usually a two-month lag between the last update and the current month, due to
 the divulgation of the index used to deflate the variables
related to income. The user must be connected to the internet because of the deflating process of monetary 
variables. The period of reference is January 2016.

{phang} Although this is a household panel, individuals may not carry the same order number throughout different surveys. 
In case the user wishes to work with an individuals panel,
it is necessary to construct a variable to identify each individual throughout different surveys.
 For this reason we use algorithms suggested by Ribas and Soares (2000).
The authors elaborated a basic system identification and an advanced one. They differ by the number of 
variables used to identify individuals in different surveys.
The idea is to verify inconsistencies in the set of variables. Either way the program may take a resonable 
amount of time to perform the identification process, depending on the computational
capacity. For this reason, we discourage the selection of more than four or five years simultaneously. 
However, if it is not of the user's interest to perform this
identification, it is possible to opt out of this process, which is valuable in terms of execution time.

{phang} If {opt nid} is selected, the program will generate a database for each selected year. Other options
 will yield one database for each PME panel. That is,
the program will generate a database for each set of households with partook the survey cycle in a given 
month (each of these sets is ascribed an upper-case letter.
If it is the case, use the command {help append} to tile bases.


{marker options}{...}
{title:Options}
{dlgtab:Inputs}

{phang} 
{opt years(numlist)} indicates which waves the user wants to work with. This program suits the period from 2002 to 2016. 
March 2002 is the first month available. It is not possible to choose specific months. 

{phang}
{opt original(string)}  indicates the path of the folder where the original data files are located. There is a microdata
 file for each survey month. All must be located in the same folder so that
the program functions properly.
		The Portal does not provide these data. Please check IBGE website for information on how to get
        microdata files.

{phang}
{opt saving(string)}  indicates the path of the folder where the user wants to save the new datafiles.

{dlgtab:Individual Identification}

{phang}
{opt nid}  requests not to create any individual identification variable. The identification number of each 
individual is not necessarily the same through PME waves. In this option, the program does not address 
this issue. The user may prefer this option if obtaining individual panel data is not the main purpose 
(cannot be combined with {opt idbas} or {opt idrs}).

{phang}
{opt idbas}  requests an individual identification variable to be created to address the identification 
issue. The basic algorithm checks a set of variables looking for inconsistencies. See Ribas and Soares 
(2008) (cannot be combined with {opt idbas} or {opt idrs}). 

{phang}
{opt idrs}  requests a bigger set of variables to be checked by the algorithm. This option is time consuming. 
See Ribas and Soares (2008) (cannot be combined with {opt idbas} or {opt idrs}).


{marker examples}{...}
{title:Examples}

{phang}  NOTE: in order to facilitate the command use, type "db datazoom_pmenova" on the command window.

{phang} Exemplo 1: no identification.

{phang} datazoom_pmenova, years(2003 2008 2009) original (C:/pme) saving (D:/mydatabases) nid

{phang} The program generates one database for each selected year. Eeach database will 
	contain the observations for the months for which there are original data files in specified folder.

{phang}

{phang} Exemplo 2: advanced identification.

{phang} datazoom_pmenova, years(2005 2006) original (C:/pme) saving (D:/mydatabases) idbas

{phang} The program generates one database for each PME Panel within that period. In each database 
there will be a variable identifying the same individuals through waves. There
will be individuals with less than eight surveys, either because their correspondent panel started 
before the year of 2005 or because their survey cycle would only
end in 2007.


{title:Author}
{p}

PUC-Rio - Department of Economics

Email {browse "mailto:datazoom@econ.puc-rio.br":datazoom@econ.puc-rio.br}

{title:See Also}

Related commands:

{help datazoom_censo} (if installed) 
{help datazoom_pnad} (if installed)  
{help datazoom_pmeantiga} (if installed)  
{help datazoom_pof2008} (if installed)
{help datazoom_pof2002} (if installed)
{help datazoom_pof1995} (if installed)
{help datazoom_ecinf} (if installed)  

{p} Type "net from http://www.econ.puc-rio.br/datazoom/english" to install these commands.
Para instalar a versão em portugues, digite "net from http://www.econ.puc-rio.br/datazoom/portugues".

{title: Reference} 

{pstd} Ribas, R. P. and Soares, S. S. D. (2008). Sobre o painel da Pesquisa Mensal de Emprego (PME) 
do IBGE. Brasília: IPEA (Texto para Discussão – 1348).
