{smcl}
{viewerdialog "PNAD" "dialog datazoom_pnad_en"}
{viewerdialog "Package" "dialog datazoom_social_en"}
{vieweralsosee "PNS" "help datazoom_pns_en"}{...}
{vieweralsosee "Censo" "help datazoom_censo_en"}{...}
{vieweralsosee "PNAD Contínua" "help datazoom_pnadcontinua_en"}{...}
{vieweralsosee "Annual PNAD Contínua" "help datazoom_pnadcont_anual_en"}{...}
{vieweralsosee "PNAD Covid" "help datazoom_pnad_covid_en"}{...}
{vieweralsosee "PME" "help datazoom_pme_en"}{...}
{vieweralsosee "POF" "help datazoom_pof_en"}{...}
{vieweralsosee "ECINF" "help datazoom_ecinf_en"}{...}
{viewerjumpto "Syntax" "datazoom_pnad_en##syntax"}{...}
{viewerjumpto "Description" "datazoom_pnad_en##description"}{...}
{viewerjumpto "Options" "datazoom_pnad_en##options"}{...}
{viewerjumpto "Examples" "datazoom_pnad_en##examples"}{...}
{viewerjumpto "Note on the original data" "datazoom_pnad_en##remarks"}{...}
{p 8 8 2} {it:Para a versão em português}, {help datazoom_pnad}

{title:Title}

{p 4 4 2}
{bf:datazoom_pnad} {hline 2} Access to PNAD microdata

{marker syntax}{...}
{title:Syntax}

{p 8 8 2} {cmd:datazoom_pnad} [, {it:options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Input}
{synopt:{opt years(numlist)}}  {p_end}
{synopt:{opt original(str)}} path to original microdata {p_end}
{synopt:{opt saving(str)}} path where databases will be saved {p_end}
{synopt:{opt english}} variable labels in English {p_end}

{syntab:Types of Register}
{synopt:{opt pes}} individuals {p_end}
{synopt:{opt dom}} households {p_end}
{synopt:{opt both}} individuals and households merged {p_end}

{syntab:Compatibility}
{synopt:{opt ncomp}} none (default) {p_end}
{synopt:{opt comp81}} 1980s compatible {p_end}
{synopt:{opt comp92}} 1990s compatible {p_end}

{synoptline}
{p2colreset}{...}
{p 4 6 2}

Use command {cmd:db datazoom_pnad_en} to access through dialog box.

{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:datazoom_pnad} extracts and builds PNAD databases from the original IBGE microdata. 
Program can be used for years ranging from 1981 to 2015, with the exception of Census years and 1994.

{p 4 4 2}
Variables can be made compatible across the years. That is avaliable for the most frequent PNAD variable, meaning that 
the ones which only appeared in a few years are not considered. Some methodological aspects may also 
prevent some variables from being made compatible. The construction of compatible variables is documented in
"PNAD - Compatibilização" in the DataZoom website. With this method, only the compatible and control variables 
remain in the final database. All monetary variables are deflated to september 2011.
 

{p 4 4 2} 
There are two possible compatibilities, one for the 1980 and one for the 1990s. 
That is due to PNAD having been restructured in 1992, when among other changes, household and 
individual files were made separate, the survey started covering a wider range of question, variable names 
were restructured and new concepts were introduced to the employment section. Therefore 1980s 
compatibility somehow hinders the PNADs from 1992 and beyond, since the new features can't be made 
backwards compatible. Even the variables from the 1980s are somewhat changed by the compatibility process or 
are excluded for appearing infrequently. On the other hand, since there have been few changes 
after 1992, 1990s compatibility is able to retain most variables. Under this second compatibity 
method, PNADs from the 1980s are not considered.

{p 4 4 2} 
The final database, made compatible or not, may contain only variables at the individual level, 
only variables at the household level, or both. In the 1980s, only the themes of education, 
employment, and earning are covered. Because of this limitation, 1980s compatibility strips away 
all variables outside of these realms.

{p 4 4 2} 
The program generates a database for each chosen year. If needed, use the command 
{help append} to pool the years together. If option {opt both} is chosen, the program still 
generates a single file, with both individual and household data.

{marker options}{...}
{title:Options}
{dlgtab:Input}

{phang} {opt years(numlist)} list of years to be extracted. Avaliable years range from 1981 to 
2015, with the exception of 1994 and the years when Censo was held.

{phang} {opt original(str)} folder path to the original data.

{phang} {opt saving(str)} path to the folder when final databases are to be saved.

{dlgtab:Types of Register}

{phang}
{opt pes}  specifies that only individual-level files are to be read. Standard option in case 
a type is not provided.

{phang}
{opt dom}  specifies that only household-level files are to be extracted.

{phang}
{opt both}  to obtain both individual and household-level data in one file, 
by executing a {help merge} between both types of register.


{dlgtab:Wave Compatibility}

{phang}
{opt ncomp}  no compatibility. End product will preserve all original variables.

{phang}
{opt comp81}  variables are made compatible to the 1980s data.

{phang}
{opt comp92}  variables are made compatible across the 1990s. Unavaliable for years of the 1980s.

{marker examples}{...}
{title:Exemplos}

{p 4 4 2}
	Individual-level data, not compatible, with English variable labels:

{p 8 6 2}. datazoom_pnad, years(1984 1997 1999 2003) original("~/mydir") saving("~/mydir") pes ncomp english

{p 6 6 2}		
	Four databases are created, one for each year. 

{p 4 4 2}
	Household files, not compatible.

{p 8 6 2}. datazoom_pnad, years(1990 2005) original("~/mydir") saving("~/mydir") dom ncomp

{p 6 6 2}		
Two databases, one per year.

{p 4 4 2}
Household files, 1980s compatible

{p 8 6 2}. datazoom_pnad, years(1990 2005) original("~/mydir") saving("~/mydir") dom comp81

{p 6 6 2}		
Contains only variables that can be made compatible.

{p 4 4 2}	
Individual-level files, 1990s compatible

{p 8 6 2}. datazoom_pnad, years(1997 2003) original("~/mydir") saving("~/mydir") pes comp92

{p 6 6 2}		
Contains only 1990s compatible variables. Note that a year from the 1980s could not have been included.

{p 4 4 2} 
	Both individual and household files, 1990s compatible:

{p 8 6 2}. datazoom_pnad, years(1992 2005) original("~/mydir") saving("~/mydir") both comp92

{p 6 6 2}		
Generates two databases, each containing both register types for a given year.

{marker remarks}{...}
{title:Note on the original data}

IBGE file names were standardized from 2001 onwards. 
Individual-level files have a "PES" prefix, while household-level files have a "DOM" prefix, 
and both have a suffix with the four-digit year. However, years before 2000 may face 
inconsistencies, leading to them not being recognized by {cmd:datazoom_pnad}.

Below is the list of file names expectedby the program until 1999.

In case user files do not match the list, the program should work once the files are renamed. 

If there are deeper structural differences, the program will not function normally. To check, 
a dictionary of expected variables is avaliable at www.econ.puc-rio.br/datazoom and can 
be compared to the dictionary that came with the user files.

{phang} - List of file names: 

{phang}
- Between 1981 and 1990: pnadYYbr, where YY is the two-digit year (81 to 90)

{phang}
- Between 1992 and 1995: PESYY for individuals, DOMYY for households

{phang}
- 1996: p96br for individuals, d96br for households

{phang}
- 1997: pessoas97 for individuals, domicilios97 for households

{phang}
- 1998 e 1999: pessoaYY for individuals, domicilioYY for households

{title:Author}

{p 4 4 2}
DataZoom     {break}
PUC-Rio - Department of Economics   {break}
Contact through  {browse "https://github.com/datazoompuc/datazoom_social_Stata":Github}      {break}

{space 4}{hline}

