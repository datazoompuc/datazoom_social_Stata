{smcl}
{* *! version 1.0 22 May 2013}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "Install command2" "ssc install command2"}{...}
{vieweralsosee "Help command2 (if installed)" "help command2"}{...}
{viewerjumpto "Syntax" "datazoom_pmeantiga##syntax"}{...}
{viewerjumpto "Description" "datazoom_pmeantiga##description"}{...}
{viewerjumpto "Options" "datazoom_pmeantiga##options"}{...}
{viewerjumpto "Remarks" "datazoom_pmeantiga##remarks"}{...}
{viewerjumpto "Examples" "datazoom_pmeantiga##examples"}{...}
{title:Title}

{phang}
{bf:datazoom_pmeantiga} {hline 2} Access to STATA format PME-Antiga databases - Version 1.2

{marker syntax}{...}
{title:Syntax}
{p 8 17 2}
{cmdab:datazoom_pmeantiga}
[{cmd:,}
{it:options}]

	Note: type 'db datazoom_pmeantiga' to use program through dialog box

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
{cmd:datazoom_pmeantiga} extracts PME-Old methodology (1991-2001) databases from original 
	IBGE microdata files, which are not available in the Portal (for information on how to acquire them, 
	see www.ibge.gov.br). The program suits the period
	from 1991 until 2001. 
	
{phang} Although PME is a monthly survey, this program does not allow specific months to be chosen, only years. 
Monetary variables are deflated to December 2001.

{phang} Although this is a household panel, individuals may not carry the same order number throughout the surveys. 
It is necessary, then, that the user who wishes
to work with an individuals panel constructs a variable to identify each individual throughout different surveys. 
For this reason we use algorithms suggested by Ribas and Soares (2008).
The authors elaborated a basic system identification and an advanced one. They differ by the number of variables 
used to identify individuals in different surveys.
The idea is to verify inconsistencies in the set of variables. Either way the program may take a resonable amount 
of time to perform the identification process, depending on the computational
capacity. For this reason, we discourage the selection of more than four or five years simultaneously. However, 
if working with an individuals panel is not of the user's interest, it is possible
to opt out of the identification process, which is valuable in terms of execution time.

{phang} If {opt nid} is selected, the program will generate a database for each selected year. When other options 
are chosen, the program will generate a database for each PME panel.
That is, a database will be generated for each set of households which partake the survey cycle in a given month 
(each of these sets is ascribed an upper-case letter). If it is the case, use the command
{help append} in order to tile bases.


{marker options}{...}
{title:Options}

{dlgtab:Inputs}

{pstd} 
{opt years(numlist)} indicates which waves the user wants to work with. This program suits the period from 
1991 to 2001. It is
not possible to choose specific months.

{phang}
{opt original(string)}  indicates the path of the folder where the original data files are located. There is a microdata file for each survey month. All must be located in the same folder so that
the program functions properly. 
		The Portal does not provide these data. Please check IBGE website for information on how to get
        microdata files.

{phang}
{opt saving(string)}  indicates the path of the folder where the user wants to save the new datafiles.

{dlgtab:Individual Identification}

{phang}
{opt nid}  requests not to create any individual identification variable. The user may prefer this option if obtaining
 individual panel data is not of his interest, as it demands less time.
(cannot be combined with {opt idbas} or {opt idrs}).

{phang}
{opt idbas}  requests an individual identification variable be created to address the identification 
issue. The basic algorithm checks a set of variables looking for inconsistencies. See Ribas and Soares 
(2008) (cannot be combined with {opt idbas} or {opt idrs}). 

{phang}
{opt idrs}  requests a bigger set of variables be checked by the algorithm. This option is time consuming. 
See Ribas and Soares (2008) (cannot be combined with {opt idbas} or {opt idrs}).


{marker examples}{...}
{title:Examples}

{phang}  NOTE: in order to facilitate the command use, type "db datazoom_pmeantiga" on the command window.

{phang} Example 1: no identification

{phang} datazoom_pmenova years(1991 1992 2000), original(C:/pmeant) saving(D:/mydatabases) nid

{phang} 

{phang} Example 2: advanced identification

{phang} datazoom_pmenova years(1999 2000), original(C:/pmeant) saving(D:/mydatabases) idbas

{phang} A new dabatase will be generated for each PME panel in 1999 and 2000. In each database there will be a variable to identify individuals only.
There will be individuals with less than eight surveys, either because their correspondent panels started before 1999 or because their survey cycle would only end
in 2000.


{title:Author}
{p}

PUC-Rio - Department of Economics

Email {browse "mailto:datazoom@econ.puc-rio.br":datazoom@econ.puc-rio.br}

{title:See Also}

Related commands:

{help datazoom_censo} (if installed) 
{help datazoom_pnad} (if installed)  
{help datazoom_pmenova} (if installed)  
{help datazoom_pof2008} (if installed)
{help datazoom_pof2002} (if installed)
{help datazoom_pof1995} (if installed)
{help datazoom_ecinf} (if installed)  

{p} Type "net from http://www.econ.puc-rio.br/datazoom/english" to install these commands.
Para instalar a versão em portugues, digite "net from http://www.econ.puc-rio.br/datazoom/portugues".

{title: Reference} 

{pstd} Ribas, R. P. and Soares, S. S. D. (2008). Sobre o painel da Pesquisa Mensal de Emprego (PME) 
do IBGE. Brasília: IPEA (Texto para Discussão – 1348).
