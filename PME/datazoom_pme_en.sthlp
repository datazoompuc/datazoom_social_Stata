{smcl}
{viewerdialog "PME" "dialog datazoom_pme_em"}
{viewerdialog "Pacote" "dialog datazoom_social_en"}
{vieweralsosee "PNAD" "help datazoom_pnad_en"}{...}
{vieweralsosee "Censo" "help datazoom_censo_en"}{...}
{vieweralsosee "PNAD Contínua Trimestral" "help datazoom_pnadcontinua_en"}{...}
{vieweralsosee "PNAD Contínua Anual" "help datazoom_pnadcont_anual_en"}{...}
{vieweralsosee "PNAD Covid" "help datazoom_pnad_covid_en"}{...}
{vieweralsosee "PNS" "help datazoom_pns_en"}{...}
{vieweralsosee "POF" "help datazoom_pof_en"}{...}
{vieweralsosee "ECINF" "help datazoom_ecinf_en"}{...}
{viewerjumpto "Syntax" "datazoom_pme_en##syntax"}{...}
{viewerjumpto "Description" "datazoom_pme_en##description"}{...}
{viewerjumpto "Options" "datazoom_pme_en##options"}{...}
{viewerjumpto "Examples" "datazoom_pme_en##examples"}{...}
{p 8 8 2} {it:Para a versão em português}, {help datazoom_pme}

{title:Title}

{p 4 4 2}
{cmd:datazoom_pmeantiga} and {cmd:datazoom_pmenova} {hline 2} Access to PME microdata

{marker syntax}
{title:Syntax}

{p 8 8 2} {cmd:datazoom_pme}(antiga/nova) [, {it:options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Input}
{synopt:{opt years(numlist)}} {p_end}
{synopt:{opt original(str)}} path to original microdata {p_end}
{synopt:{opt saving(str)}} path where databases will be saved {p_end}
{synopt:{opt english}} variable labels in English {p_end}

{syntab:Individual Identification}
{synopt:{opt nid}} No identification {p_end}
{synopt:{opt idbas}} Basic {p_end}
{synopt:{opt idrs}} Advanced (Ribas-Soares) {p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}

Use command {cmd:db datazoom_pme_en} to access through dialog box.

{marker description}{...}

{title:Description}

{p 4 4 2}
{cmd:datazoom_pmeantiga} and {cmd:datazoom_pmenova} extract and build PME databases from the IBGE microdate {c -} 
for the old and new methodologies, respectively. Both function the same way, only readjusted for the two possible microdata types. 

{p 4 4 2}
{cmd: datazoom_pmeantiga} supports years 1991 to 2001, while {bf:datazoom_pmenova} supports years 2002 to 2016.

{p 4 4 2}
Despite the PME being a monthly survey, we only allow choosing specific years, and not months. Old PME data is 
deflated to december 2001, and to new one to january 2016.

{p 4 4 2}
Although this is a household panel, individuals may not carry the same order number throughout different surveys. 
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

{p 4 4 2}
If {opt nid} is selected, the program will generate a database for each selected year. Other options
 will yield one database for each PME panel. That is,
the program will generate a database for each set of households with partook the survey cycle in a given 
month (each of these sets is ascribed an upper-case letter.
If it is the case, use the command {help append} to tile bases.
  
{marker options}{...}
{title:Options}
{dlgtab:Input}

{phang} 
{opt years(numlist)} indicated which years the user would like to extract. They can range from 1991 to 2001
in {cmd:datazoom_pmeantiga}, and from 2002 to 2016 in {cmd:datazoom_pmenova}.

{phang} {opt original(str)} indicates the path of the folder where the original data files are located. There is a microdata
 file for each survey month. All must be located in the same folder so that
the program functions properly.

{phang} {opt saving(str)} indicates the path of the folder where the user wants to save the new datafiles.

{dlgtab:Identification}

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
{opt idrs}  requests that a bigger set of variables is checked by the algorithm. This option is time consuming. 
See Ribas and Soares (2008) (cannot be combined with {opt idbas} or {opt idrs}).

{marker examples}{...} 
{title:Examples}

{p 4 4 2}
No identification:

{p 8 6 2}. datazoom_pmeantiga, years(1991 1992) original("~/mydir") saving("~/mydir") nid english

{p 6 6 2}
Generates three databases, one per year. Each will contain observations from all months whose original data is avaliable.
Variable labels will be provided in English.
	
{p 4 4 2}	
Advanced identification:

{p 8 6 2}. datazoom_pmenova, years(2005 2006) original("~/mydir") saving("~/mydir") idbas

{p 6 6 2}		
		The program generates one database for each PME Panel within that period. In each database 
there will be a variable identifying the same individuals through waves. There
will be individuals with less than eight surveys, either because their correspondent panel started 
before the year of 2005 or because their survey cycle would only
end in 2007.

{title:Author}

{p 4 4 2}
DataZoom     {break}
PUC-Rio - Department of Economics   {break}
Contact through  {browse "https://github.com/datazoompuc/datazoom_social_Stata":Github}      {break}

{space 4}{hline}

