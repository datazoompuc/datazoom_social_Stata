{smcl}
{* *! version 1.0 20 May 2013}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "Install command2" "ssc install command2"}{...}
{vieweralsosee "Help command2 (if installed)" "help command2"}{...}
{viewerjumpto "Syntax" "datazoom_pofstd_02##syntax"}{...}
{viewerjumpto "Description" "datazoom_pofstd_02##description"}{...}
{viewerjumpto "Options" "datazoom_pofstd_02##options"}{...}
{viewerjumpto "Remarks" "datazoom_pofstd_02##remarks"}{...}
{viewerjumpto "Examples" "datazoom_pofstd_02##examples"}{...}
{title:Title}

{phang}
{bf:datazoom_pofstd_02} {hline 2} Access to STATA format POF 2002-03 Standard Databases - Version 1.2

{marker syntax}{...}
{title:Syntax}
{p 8 17 2}
{cmdab:datazoom_pofstd_02}
[{cmd:,}
{it:options}]

{phang} NOTE: type 'db datazoom_pof2008' in the command window in order to use the program through the dialog box (strongly recommended)

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{opt id(string)}} identification type {p_end}
{synopt:{opt original(string)}} folder path where original datafiles are located {p_end}
{synopt:{opt saving(string)}} folder where new databases are to be saved {p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}

{marker description}{...}
{title:Description}

{phang}
{cmd:datazoom_pofstd_02} extracts and constructs a standard database of POF 2002-03 from 
the original microdata, which are not available online
(for information on how to acquire original data, see www.ibge.gov.br). This program 
is part of POF 2002-03  package, which also contains {help datazoom_poftrs_02} 
and {help datazoom_pofsel_02} (these programs
 are independent from each other). 
	
{phang} In this standard database, expenditures in similar items are aggregated in a single item. 
For an example, expenditures in any type of rice, beans and others are unified under expenditures
on cereals, pulses and oilseeds. This aggregation follows IBGE POF documentation ("Tradutores"). 
All existing aggregations in that document are incorporated in the final database.
The user cannot choose which items to include in the database nor specify aggregations different 
from the predetermined ones. All values are annualized and
deflated to January 2003.

{phang} It is worth noting that each expenditure corresponds to a determined identification level 
(household, consumption unit or individual). When choosing the identification level, the program 
computes the expenditure
for the chosen level, adding the individual expenditures within the level when that is the case. 
In particular, when the identification level is
the individual, the expenditures on items associated with consumption unit or household levels are
 disconsidered. In case it is of the user's interest to work with an
individual database, run the program for each identification level and then use the command
 {help merge} to aggregate the databases.

 {phang} It is important to remember that there are also identification levels for income variables,
 in the same way that there are levels for expenditure. The income variables (gross monetary income,
 gross non-monetary income and total income) corresponds to the household monthly gross income or 
 to the consumption unity monthly gross income. 
 
{phang} The final database, under any identification level, will contain all variables pertaining 
household characteristics. If Consumption Unit is chosen, variables pertaining
life conditions are added. Finally, if Individual is chosen, variables pertaining individual 
characteristics are added.

{phang} For estimates' creation, it is necessary to use the expansion factor 2 as weighting factor. For more informations, check
{help weight}.
	
{marker options}{...}
{title:Options}
{dlgtab:Main}
{phang}
{opt id(string)}  specifies the identification type for which the expenditures are to be computed: 
household ({opt dom}), 
	consumption unit ({opt uc}) or individual ({opt pess}). As defined by IBGE, consumption unit is 
	a set of household residents (which may consist of one, in case
	a household has only one resident) whose food derives from the same source.

{phang}
{opt original(string)}  indicates the path of the folder where the original data files are located.
 All fourteen files must be located
in the same folder so that the program functions properly. The Portal does not provide these data.

{phang}
{opt saving(string)}  indicates the path of the folder where the user wants to save the new datafiles.


{marker examples}{...}
{title:Examples}

{phang}  NOTE: In order to facilitate the command use, type "db datazoom_pof2002" on the command window.

{phang} datazoom_pofstd_02, id(uc pess ) original(c:/mydata) saving(c:/pof)

{pstd}
This produces two standard databases, one at the family (uc) level and another at individual (pess) level.



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
{help datazoom_pof2008} (if installed)  
{help datazoom_pof1995} (if installed)  
{help datazoom_ecinf} (if installed) 
 
{p} Type "net from http://www.econ.puc-rio.br/datazoom/english" to install these commands.
Para instalar a versão em portugues, digite "net from http://www.econ.puc-rio.br/datazoom/portugues".
