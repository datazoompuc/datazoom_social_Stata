{smcl}
{viewerdialog "POF" "dialog datazoom_pof_en"}
{viewerdialog "Package" "dialog datazoom_social_en"}
{vieweralsosee "PNAD" "help datazoom_pnad_en"}{...}
{vieweralsosee "Censo" "help datazoom_censo_en"}{...}
{vieweralsosee "Annual PNAD Contínua" "help datazoom_pnadcont_anual_en"}{...}
{vieweralsosee "PNS" "help datazoom_pns_en"}{...}
{vieweralsosee "PNAD Contínua Trimestral" "help datazoom_pnadcontinua_en"}{...}
{vieweralsosee "PME" "help datazoom_pme_en"}{...}
{vieweralsosee "PNAD Covid" "help datazoom_pnad_covid_en"}{...}
{vieweralsosee "ECINF" "help datazoom_ecinf_en"}{...}
{viewerjumpto "Syntax" "datazoom_pof_en##syntax"}{...}
{viewerjumpto "Description" "datazoom_pof_en##description"}{...}
{viewerjumpto "Options" "datazoom_pof_en##options"}{...}
{viewerjumpto "About POF" "datazoom_pof_en##remarks"}{...}
{viewerjumpto "Examples" "datazoom_pof_en##examples"}{...}
{p 8 8 2} {it:Para a versão em português}, {help datazoom_pof}

{title:Title}

{p 4 4 2}
{cmd:datazoom_pof}{it:(ano)} {hline 2} Access to POF microdata

{marker syntax}{...}
{title:Syntax}

{p 8 8 2} {cmd:datazoom_pofstd_}{it:year} [, {it:options} {it:std_options}]

{p 8 8 2} {cmd:datazoom_pofsel_}{it:year} [, {it:options} {it:sel_options}]

{p 8 8 2} {cmd:datazoom_poftrs_}{it:year} [, {it:options} {it:trs_options}]

{p 4 4 2} Where {it:year} can be 95, 02, 08 or 17

{synoptset 20 tabbed}{...}
{synopthdr: options}
{synoptline}
{syntab:Input}
{synopt:{opt original(str)}} path to original microdata {p_end}
{synopt:{opt saving(str)}} path where databases will be saved {p_end}
{synopt:{opt english}} variable labels in English {p_end}
{p2colreset}{...}

{synoptset 20 tabbed}{...}
{synopthdr: std_options}
{synoptline}
{syntab:Stardardized Databases}
{synopt:{opt id(string)}} identification level {p_end}
{p2colreset}{...}

{synoptset 20 tabbed}{...}
{synopthdr: sel_options}
{synoptline}
{syntab:Selected Expenditures}
{synopt:{opt id(string)}} identification level {p_end}
{synopt:{opt lista(string asis)}} list of items {p_end}
{p2colreset}{...}

{synoptset 20 tabbed}{...}
{synopthdr: trs_options}
{synoptline}
{syntab:Types of Register}
{synopt:{opt trs(string)}} registers {p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}

Use command {cmd:db datazoom_pof_en} to access through dialog box.

{marker description}{...}
{title:Description}

{p 4 4 2}
For each year, there are three commands of the form {cmd:datazoom_pof}{it:(ano)}. It's highly recommended 
to use them via the dialog box.

{p 4 4 2}
{cmd: datazoom_pofstd_}{it:ano} generates a standardized POF database.
This database contains expenditure/aquisition variables for a predetermined consumption basket, 
which aggregates individual items, following the IBGE consumption documentation. This function 
is not avaliable for the 2017/18 POF.

{p 4 4 2}
{cmd: datazoom_pofsel_}{it:ano} creates a custom database, with variable pertaining to 
user-chosen items. Não disponível para 2017. Not avaliable for the 2017/18 POF.
	
{p 4 4 2}
{cmd: datazoom_poftrs_}{it:ano} produces the original databases in Stata format, with no 
variable manipulation, for the chosen types of register.
	
{p 4 4 2}
The first two programs allow the user to choose the level at which the data are to be aggregated: household, 
	consumption unit (family) or individual. Some types of register are not compatible with all
	levels. 
	
{p 4 4 2}
Using the Standardized Databases or Selected Expenditures programs, values are annualized and deflateed: to 
september 1996, for the 1995/96 POF; to january 2003, for the 2002/03; and to january 2009, for the 2008/09 POF.

{p 4 4 2}
All can used reached in dialog box format through {cmd: db datazoom_pof_en}

{title: Standardized Databases}

{p 4 4 2}
{cmd:datazoom_pofstd_}{it:ano} extracts and builds a standardized database from the original POF microdata.
		
{p 4 4 2}
In this standard database, the expenditures on similar items are aggregated to a 
single item. For an example, expenditures on any kind of
rice, bean and others are unified under expenditures on cereals, pulses and oilseeds. 
This aggregation follows IBGE POF documentation ("Tradutores"). All existing aggregations
 in that document are incorporated in the final database.
The user cannot choose which items to include in the database nor specify aggregations 
different from the predetermined ones. All values are annualized and
deflated to January 2009.

{p 4 4 2}
It is worth noting that each expenditure corresponds to a determined identification 
level (household, consumption unit or individual). When choosing the identification level,
 the program computes the expenditure
for the chosen level, adding the individual expenditures within the level when that is the
 case. In particular, when the identification level is
the individual, the expenditures on items associated with consumption unit or household 
levels are disconsidered. In case it is of the user's interest to work with an
individual database, run the program for each identification level and then use the 
command {help merge} to aggregate the databases.

{p 4 4 2}
It is important to remember that there are also identification levels for income variables,
 in the same way that there are levels for expenditure. The income variables (gross monetary income,
 gross non-monetary income and total income) corresponds to the household monthly gross income or 
 to the consumption unity monthly gross income. 
 
{p 4 4 2}
The final database, under any identification level, will contain all variables 
pertaining household characteristics. If Consumption Unit is chosen, variables pertaining
life conditions are added. Finally, if Individual is chosen, variables pertaining individual
 characteristics are added.
	
{p 4 4 2}
To construct estimates, the expansion factor 2 must be used as a sampling {help weight}.

{title: Selected Expenditures}

{p 4 4 2}
{cmd:datazoom_pofsel_}{it:ano} extracts and builds custom Stata databases from the original POF microdata.
		
{p 4 4 2}
Em {opt lista} The desired list of items is defined by the user in {opt lista}. As each item carries
 a specific, predefined name, it is stronly recommended
that the program is used through its dialog box, which allows the user to see all available 
items by category (Food, Other Expenditures and Income).

{p 4 4 2} The expenditures in each chosen item is aggregated to the desired identification level: 
household, consumption unit (family) or individual. The same occurs with income-related variables. All values are annualized and deflated to January 2009. 
The income variables (gross monetary income, gross non-monetary income and total income) corresponds to the household monthly gross
income or to the consumption unity monthly gross income. 
It is worth noting that each expenditure corresponds to a determined identification level.
Therefore, it is not possible to obtain for an individual the expenditures on items associated 
with the consumption unit and household. In this case, run the program
for each identification level and then use the command {help merge} to aggregate the databases.
 
{p 4 4 2} The final database, under any identification level, contains all variables pertaining 
household characteristics. If Consumption Unit is chosen, variables pertaining
life conditions are added. Finally, if Individual is chosen, variables pertaining individual characteristics are added.

{p 4 4 2} To construct estimates, the expansion factor 2 must be used as a sampling {help weight}.

{title: Types of Register}

{p 4 4 2}
{cmd:datazoom_poftrs_}{it:ano} reads POF databases for the chosen registers from the original microdata.
		
{p 4 4 2} 
POF microdata is split into Types of Register, that may be different between years. The desired Types of 
Register may be chosen via the dialog box.
	
{marker options}{...}
{title:Options}
{dlgtab:Input}

{phang}
{opt original(string)}  indicates the folder path to the original microdata. 
All files must be located in the same folder so that the program functions properly.


{phang}
{opt saving(string)}  indicates the folder path where the new databases are to be saved.
		
{dlgtab:Standardized Databases}
{phang}
{opt id(string)}  specifies the identification type for which the expenditures are to be computed: household {opt dom}, 
	consumption unit ({opt uc}) or individual ({opt pess}). As defined by IBGE, a consumption unit
	is a set of household residents (which may consist of only one person, in case a household has
	only one resident) whose food derives from the same source.

{dlgtab:Selected Expenditures}
{phang}
{opt id(string)}   specifies the identification type for which the expenditures are to be computed: household {opt dom}, 
	consumption unit ({opt uc}) or individual ({opt pess}). As defined by IBGE, a consumption unit
	is a set of household residents (which may consist of only one person, in case a household has
	only one resident) whose food derives from the same source.
	
{phang}
{opt lista(string asis)}  indicates which items on which expenditures will be 
included in the final database. May also contain income-related variables.

{dlgtab:Types of Register}

{phang}
{opt trs(string)}  specifies the chosen register codes.

{marker examples}{...}
{title:Examples}

{p 8 6 2}. datazoom_pofstd_95, id(uc pess ) original("~/mydata") saving("~/mydata") english

{p 6 6 2}
Produces two standardized databases for 1995, one at the consumption unit level, and 
another at the individual level. Variable labels are provided in English.

{p 8 6 2}.datazoom_poftrs_17, trs(tr1 tr6 tr7) original("~/mydata") saving("~/mydada")

{p 6 6 2}
Creates three databases for 2017, one for each Type of Register 
(1 - Household; 6 - Labor Earnings; 7 - Other Earnings).

{marker remarks}
{title:About the POF}

{p 4 4 2}
The Consumer Expenditure Survey (POF) is a household survey whose objective is to provide information about
the compostition of household budgets, through the research of consumer habits, allocation of
expenditures and distribution of income. It has been carried out by IBGE on a five-year basis since 1996 (its first version was
published in 1988) and cover all brazilian territory. Among other purpuses, POF supports the 
elaboration of products baskets used to calculate inflation
indexes such as IPCA.

{p 4 4 2}
What makes POF peculiar and allegedly complicated is how numerous and varied its types of register are.

{p 4 4 2}
Besides information on households (such as the existance of sewage, walls and vehicles) and on individuals 
(age, instruction and income) - both present in the Census and in the PNADs -,
the POF contains different types of register for each type of expenditure/consumption/acquisition. 
Each type depends on the periodicity (weekly, quarterly) and to whom
it is attributed - whether to the household (such as electricity consumption) or to the individual 
(meals away from the household). Both periodicity and attribution are pre-defined
by IBGE before the survey takes place. Food acquisition, for an example, is measured through a booklet
 to be daily filled by each household throughout seven days.
Expenditures with hairdrassing services, on the other hand, are registered individually throughout a period of 90 days.

{p 4 4 2}
In order to identify an item it is necessary to combine one variable with the first three digits of another. However,
this second variable is different specifically in the collective expenditures's documentation via booklets.
 That is, the variable used in any other types of register exists in the
collective expenditure's base, but should not be used. 

{p 4 4 2}
Therefore, the task of calculating the total expenditure of a household or individual is far from trivial. 
The above-cited programs aim to aid the user's access to this survey.

{title:Author}

{p 4 4 2}
DataZoom     {break}
PUC-Rio - Department of Economics   {break}
Contact through  {browse "https://github.com/datazoompuc/datazoom_social_Stata":Github}      {break}

{space 4}{hline}

