{smcl}
{* *! version 1.0 20 May 2013}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "Install command2" "ssc install command2"}{...}
{vieweralsosee "Help command2 (if installed)" "help command2"}{...}
{viewerjumpto "Syntax" "datazoom_pofsel_95##syntax"}{...}
{viewerjumpto "Description" "datazoom_pofsel_95##description"}{...}
{viewerjumpto "Options" "datazoom_pofsel_95##options"}{...}
{viewerjumpto "Remarks" "datazoom_pofsel_95##remarks"}{...}
{viewerjumpto "Examples" "datazoom_pofsel_95##examples"}{...}
{title:Title}

{phang}
{bf:datazoom_pofsel_95} {hline 2} Acess to STATA format POF 1995-96 Customized Databases

{marker syntax}{...}
{title:Syntax}
{p 8 17 2}
{cmdab:datazoom_pofsel_95}
[{cmd:,}
{it:options}]

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
{cmd:datazoom_pofsel_95} extracts and constructs personalized STATA format databases (.dta) from original microdata files,
which are not available online (for information on how to acquire original datafiles, see www.ibge.gov.br). This program
is part of POF 1995-96 package, which also contains {help datazoom_poftrs_95} and {help datazoom_pofsel_95} (these programs
 are independent from each other). 
	
{phang} The databases are extracted according to a list of items defined by the user in {opt lista}. 
As each of these items carries a specific, predefined name,
it is highly recommended that the program is used through the dialog box, which allows the user to see 
all available items by category (Food, Other Expenditures and Income).

{phang} The expenditure on each selected item will be aggregated at the level the users prefers: 
household, consumption unit (family) or individual.The same will happen to the income-related variables. The income variables (gross monetary income, 
gross non-monetary income and total income) corresponds to the household monthly gross income or to the consumption unity monthly gross income. 
All values are annualized and deflated to September 1996. It is worth noting that each expenditure corresponds
to a determined identification level. So it is not possible to obtain the expenditure of a  given individual of itens that are associated
with the consumption unit or household. In this case, the user should run the program for each identification level 
and then use the command {help merge} to aggregate the databases.

{phang} The final database, under any identification level, contains all variables pertaining household 
characteristics. If Consumption Unit is chosen, variables
pertaining life conditions are added. Finally, if Individual is chosen, variables pertaining individual characteristics are added.

{phang} For estimates' creation, it is necessary to use the expansion factor 2 as weighting factor. For more informations, check
{help weight}.

{marker options}{...}
{title:Options}
{dlgtab:Main}
{phang}
{opt id(string)}  specifies the identification type for which the expenditures are to be computed: household ({opt dom}), 
	consumption unit ({opt uc}) or individual ({opt pess}). As defined by IBGE, a constumption unit 
	is a set of household residents (even if there is only one resident
	in a given household) whose food derives from the same source.

{phang}
{opt lista(string asis)}  indicates the items on which expenditures will be included in the final database. May also contain income-related variables.

{phang}
{opt original(string)}  indicates the path of the folder where the original data files are located. All twelve files must be located in the same
folder so that the program functions properly.  
		The Portal does not provide the original data.

{phang}
{opt saving(string)}  indicates the path of the folder where the user wants to save the new datafiles.


{marker examples}{...}
{title:Examples}

{p}  NOTE: (Strongly recommended) In order to facilitate the command use, type "db datazoom_pof1995" on the command window. 

{p} Example 1: the final base contains annualized expenditure on fruits, flour and sugar at the Consumption Unit level

{phang} datazoom_pofsel_95, id(uc) original(c:/mydata) saving(c:/pof) lista(grutas farinha_de_trigo açúcar_refinado)


{p} Example 2: the command below is not valid, since the expenditures registered in notebooks 
referred to each consumption unit and the command asks for
individual level ("pess").

{phang} datazoom_pofsel_95, id(pess) original (c:/mydata) saving (c:/proof) lista(frutas farinha_de_trigo açúcar_refinado)

{p} Example 3: the final database contains annualized expenditures on beans, carrot and children's wear, besides transfer payments (pensions,
scholarships, transitory transfer payments). All values are aggregated at the household level. Therefore, 
all income, which is individual, is aggregated within each household.

{phang} datazoom_pofsel_95, id(dom) original(c:/mydata) saving(c:/pof) lista(Feijao Cenoura Roupa_de_crianca Transferencia)

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
{help datazoom_pof2002} (if installed)  
{help datazoom_ecinf} (if installed)  

{p} Type "net from http://www.econ.puc-rio.br/datazoom/english" to install these commands.
Para instalar a versão em portugues, digite "net from http://www.econ.puc-rio.br/datazoom/portugues".
