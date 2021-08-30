{smcl}
{* *! version 1.0 20 May 2013}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "Install command2" "ssc install command2"}{...}
{vieweralsosee "Help command2 (if installed)" "help command2"}{...}
{viewerjumpto "Syntax" "datazoom_pofsel_08##syntax"}{...}
{viewerjumpto "Description" "datazoom_pofsel_08##description"}{...}
{viewerjumpto "Options" "datazoom_pofsel_08##options"}{...}
{viewerjumpto "Remarks" "datazoom_pofsel_08##remarks"}{...}
{viewerjumpto "Examples" "datazoom_pofsel_08##examples"}{...}
{title:Title}

{phang}
{bf:datazoom_pofsel_08} {hline 2} Acess to STATA format POF 2008-09 Customized Databases

{marker syntax}{...}
{title:Syntax}
{p 8 17 2}
{cmdab:datazoom_pofsel_08}
[{cmd:,}
{it:options}]

{phang} NOTE: type 'db datazoom_pof2008' in the command window in order to use the program through the dialog box (strongly recommended)

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{opt id(string)}} identification type {p_end}
{synopt:{opt lista(string asis)}} list of items {p_end}
{synopt:{opt original(string)}} folder path where original datafiles are located {p_end}
{synopt:{opt saving(string)}} folder where new databases are to be saved {p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}

{marker description}{...}
{title:Description}

{phang}
{cmd:datazoom_pofsel_08} extracts and constructs personalized STATA format databases (.dta) from 
original microdata files, which are not available online
(for information on how to acquire original data, see www.ibge.gov.br). This program is part of 
POF 2008-09  package, which also contains {help datazoom_poftrs_08} and {help datazoom_pofsel_08} (these programs
 are independent from each other). 

{phang} The desired list of items is defined by the user in {opt lista}. As each item carries
 a specific, predefined name, it is stronly recommended
that the program is used through its dialog box, which allows the user to see all available 
items by category (Food, Other Expenditures and Income).

{phang} The expenditures in each chosen item is aggregated to the desired identification level: 
household, consumption unit (family) or individual. The same occurs with income-related variables. All values are annualized and deflated to January 2009. 
The income variables (gross monetary income, gross non-monetary income and total income) corresponds to the household monthly gross
income or to the consumption unity monthly gross income. 
It is worth noting that each expenditure corresponds to a determined identification level.
Therefore, it is not possible to obtain for an individual the expenditures on items associated 
with the consumption unit and household. In this case, run the program
for each identification level and then use the command {help merge} to aggregate the databases.

{phang} The final database, under any identification level, contains all variables pertaining 
household characteristics. If Consumption Unit is chosen, variables pertaining
life conditions are added. Finally, if Individual is chosen, variables pertaining individual characteristics are added.

{phang} For estimates' creation, it is necessary to use the expansion factor 2 as weighting factor. For more informations, check
{help weight}.

{marker options}{...}
{title:Options}
{dlgtab:Main}
{phang}
{opt id(string)}  specifies the identification type for which the expenditures are to be computed: household {opt dom}, 
	consumption unit ({opt uc}) or individual ({opt pess}). As defined by IBGE, a consumption unit
	is a set of household residents (which may consist of only one person, in case a household has
	only one resident) whose food derives from the same source.

{phang}
{opt lista(string asis)}  indicates which items on which expenditures will be 
included in the final database. May also contain income-related variables.

{phang}
{opt original(string)}  indicates the path of the folder where the original data
 files are located. All sixteen files must be located in the same folder so that
the program functions properly.	The Portal does not provide these data.

{phang}
{opt saving(string)}  indicates the path of the folder where the user wants to save the new datafiles.


{marker examples}{...}
{title:Examples}

{p}  NOTE: (strongly recommended) type 'db datazoom_pof2008' in the command window in order to use the program through the dialog box.

{p} Example 1: the final database contains annualized expenditures on fruits, flour and refined sugar at the Consumption Unit level.

{phang} datazoom_pofsel_08, id(uc) original(c:/mydata) saving(c:/pof) lista(frutas farinha_de_trigo açúcar_refinado)

{p} Exemple 2: the command below would not be valid, since the expenditures registered on
 notebooks relate to the consumption unit level and the
command asks for a database in individual level ('pess')

{phang} datazoom_pofsel_08, id(pess) original (c:/mydata) saving (c:/pof) lista (frutas farinha_de_trigo açúcar_refinado)

{p} Example 3: the final database contains annualized expenditures on beans, carrot and 
children's wear, besides transfer payments (pensions, scholarships, transitory transfer payments). 
All values are aggregated ate household level. Therefore, the income, which is individual, is added within each household.

{phang} datazoom_pofsel_08, id(dom) original (c:/mydata) saving (c:/pof) lista (Feijão Cenoura Roupa_de_crianca Transferencia)


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
