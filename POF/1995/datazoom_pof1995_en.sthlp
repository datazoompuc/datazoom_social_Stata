{smcl}
{* *! version 1.0 18 Jun 2013}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "Install command2" "ssc install command2"}{...}
{vieweralsosee "Help command2 (if installed)" "help command2"}{...}
{viewerjumpto "Description" "datazoom_pof1995##description"}{...}
{title:Title}

{phang}
{bf:datazoom_pof1995} {hline 2}  Access to STATA format POF 1995-96 databases - Version 1.0


{marker description}{...}
{title:Description}

{phang}
{cmd:datazoom_pof1995} is composed of three programs.

{phang}
1) datazoom_pofstd_95: run this program to get a POF 1995-96 standard database. It contains
	expenditure/acquisition variables for aggregate items according to IBGE classification.
	For more information, check {help datazoom_pofstd_95}.

{phang}
2) datazoom_pofsel_95: through this program the user can construct his own database by choosing 
	and adding disaggregated items into a basket. For more information, check {help datazoom_pofsel_95}.
	
{phang}
3) datazoom_poftrs_95: run this program to extract STATA format POF 1995-96 databases from
   original files whithout any manipulation. 1995-96 version contains 12 types of register.
   For more information, check {help datazoom_poftrs_95}.
   
{phang}
The first two programs allow the user to choose the level at which the data are to be aggregated: 
	household, consumption unit (family) or individual. Note that some types of register are not 
	compatible with all levels.

{phang}
Type "db datazoom_pof1995" on the command window to start.

{title: About the POF 1995-96}

{phang} The Consumer Expenditure Survey (POF) is a household survey whose objective is to provide information
about the composition of household budgets, through the research of consumer habits, allocation of expenditures and distribution of 
income. It has been carried out by IBGE on a five-year basis since 1995 (its first version was published in 1988) and it covers all brazilian territory.
Among other purposes, POF supports the elaboration of products baskets that are used to calculate inflation indexes such as IPCA. 

{phang} What makes POF peculiar and allegedly complicated is how numerous and varied its types of register are.

{phang} Besides information on households (such as the existence of sewage, walls and vehicles) and individuals 
(age, instruction and income) - both present in the Census and in the PNADs -, 
the POF also contains different types of registers for each type of expenditure/consumption/acquisition. 
Each type depends on the periodicity (weekly, quarterly) and to whom it is attributed - whether
to the household (such as electricity consumption) or to the individual (meals away from the household). 
Both the periodicity and the attribution are pre-defined by IBGE before the
survey takes place. Food acquisition, for an example, is measured through a booklet to be daily filled by 
each household throughout seven days.
Expenditures with hairdrassing services, on the other hand, are registered individually throughout a period of 90 days.

{phang} In order to identify an item it is necessary to combine one variable with the first three digits of another. However,
this second variable is different specifically in the collective expenditures's documentation via booklets. That is, 
the variable used in any other types of register exists in the
collective expenditure's base, but should not be used. 

{phang} Therefore, the task of calculating the total expenditure of a household or individual is far from trivial. 
The above-cited programs (specially datazoom_pofstd_95 and datazoom_pofsel_95) aim to aid the user's access to this survey.

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
{help datazoom_ecinf} (if installed)  


{p} Type "net from http://www.econ.puc-rio.br/datazoom/english" to install these commands.
Para instalar a versão em portugues, digite "net from http://www.econ.puc-rio.br/datazoom/portugues".
