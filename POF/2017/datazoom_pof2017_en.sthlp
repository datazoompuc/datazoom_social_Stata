{smcl}
{* *! version 1.0 15 Oct 2019}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "Install command2" "ssc install command2"}{...}
{vieweralsosee "Help command2 (if installed)" "help command2"}{...}
{viewerjumpto "Description" "datazoom_pof2017##description"}{...}
{title:Title}

{phang}
{bf:datazoom_poftrs_17} {hline 2}  Access to STATA format POF 2017-18 databases - Version 1.0


{marker description}{...}
{title:Description}

{phang}
{cmd:datazoom_pof2017} is composed of three programs.

{phang}
1) datazoom_pofstd_17 (currently not available): run this program to get a POF 2017-18 standard database. It contains
	expenditure/acquisition variables for aggregate items according to IBGE classification.
	For more information, check {help datazoom_pofstd_17}

{phang}
2) datazoom_pofsel_17 (currently not available) : through this program the user can construct his own database by choosing 
	and adding disaggregated items into a basket. For more information, check {help datazoom_pofsel_17}
	
{phang}
3) datazoom_poftrs_17: run this program to extract STATA format POF 2017-18 databases from
	original files whithout any manipulation. 2017-18 version contains 7 types of register.
	For more information, check {help datazoom_poftrs_17}
	
{phang}
The first two programs allow the user to choose the level at which the data are to be aggregated: household, 
	consumption unit (family) or individual. Some types of register are not compatible with all
	levels. 

{phang}
Type "db datazoom_pof2017" on the command window to start.

{title: About the POF 2017-18}

{phang} The Consumer Expenditure Survey (POF) is a household survey whose objective is to provide information about
the compostition of household budgets, through the research of consumer habits, allocation of
expenditures and distribution of income. It has been carried out by IBGE on a five-year basis since 1996 (its first version was
published in 1988) and cover all brazilian territory. Among other purpuses, POF supports the 
elaboration of products baskets used to calculate inflation
indexes such as IPCA.

{phang} What makes POF peculiar and allegedly complicated is how numerous and varied its types of register are.

{phang} Besides information on households (such as the existance of sewage, walls and vehicles) and on individuals 
(age, instruction and income) - both present in the Census and in the PNADs -,
the POF contains different types of register for each type of expenditure/consumption/acquisition. 
Each type depends on the periodicity (weekly, quarterly) and to whom
it is attributed - whether to the household (such as electricity consumption) or to the individual 
(meals away from the household). Both periodicity and attribution are pre-defined
by IBGE before the survey takes place. Food acquisition, for an example, is measured through a booklet
 to be daily filled by each household throughout seven days.
Expenditures with hairdrassing services, on the other hand, are registered individually throughout a period of 90 days.

{phang} In order to identify an item it is necessary to combine one variable with the first three digits of another. However,
this second variable is different specifically in the collective expenditures's documentation via booklets.
 That is, the variable used in any other types of register exists in the
collective expenditure's base, but should not be used. 

{phang} Therefore, the task of calculating the total expenditure of a household or individual is far from trivial. 
The above-cited programs (specially datazoom_pofstd_17 and datazoom_pofsel_17) aim to aid the user's access to this survey.

{title: Author}
{p}


PUC-Rio - Department of Economics

Email {browse "mailto:datazoom@econ.puc-rio.br":datazoom@econ.puc-rio.br}


{title:See Also}

Related packages:

{help datazoom_censo} (if installed) 
{help datazoom_pmenova} (if installed)  
{help datazoom_pmeantiga} (if installed)  
{help datazoom_pnad} (if installed)  
{help datazoom_pof2008} (if installed) 
{help datazoom_pof2002} (if installed)
{help datazoom_pof1995} (if installed)
{help datazoom_ecinf} (if installed)  


{p} Type "net from http://www.econ.puc-rio.br/datazoom/english" to install these commands.
Para instalar a versão em portugues, digite "net from http://www.econ.puc-rio.br/datazoom/portugues".
