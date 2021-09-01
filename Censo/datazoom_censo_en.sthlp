{smcl}
{viewerdialog "Censo" "dialog datazoom_censo_en"}
{viewerdialog "Package" "dialog datazoom_social_en"}
{vieweralsosee "PNAD" "help datazoom_pnad_en"}{...}
{vieweralsosee "PNS" "help datazoom_pns_en"}{...}
{vieweralsosee "PNAD Contínua" "help datazoom_pnadcontinua_en"}{...}
{vieweralsosee "Annual PNAD Contínua" "help datazoom_pnadcont_anual_en"}{...}
{vieweralsosee "PNAD Covid" "help datazoom_pnad_covid_en"}{...}
{vieweralsosee "PME" "help datazoom_pme_en"}{...}
{vieweralsosee "POF" "help datazoom_pof_en"}{...}
{vieweralsosee "ECINF" "help datazoom_ecinf_en"}{...}
{viewerjumpto "Syntax" "datazoom_censo##syntax"}{...}
{viewerjumpto "Description" "datazoom_censo##description"}{...}
{viewerjumpto "Options" "datazoom_censo##options"}{...}
{viewerjumpto "Examples" "datazoom_censo##examples"}{...}
{viewerjumpto "Note on the original data" "datazoom_censo##remarks"}{...}
{p 8 8 2} {it:Para a versão em português}, {help datazoom_censo}

{title:Title}

{p 4 4 2}
{cmd:datazoom_censo} {hline 2} Access to Censo microdata

{marker syntax}{...}
{title:Syntax}

{p 8 8 2} {cmd:datazoom_censo} [, {it:options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Input}
{synopt:{opt years(numlist)}} {p_end}
{synopt:{opt original(str)}} path to original microdata {p_end}
{synopt:{opt saving(str)}} path where databases will be saved {p_end}
{synopt:{opt ufs(str)}} Federation Unit codes {p_end}
{synopt:{opt english}} variable labels in English {p_end}

{syntab:Compatibility}
{synopt:{opt comp}} compatible variables across the years {p_end}

{syntab:Types of Register}
{synopt:{opt pes}} individual {p_end}
{synopt:{opt dom}} household {p_end}
{synopt:{opt fam}} family (2000) {p_end}
{synopt:{opt both}} individual and household merged {p_end}
{synopt:{opt all}} individual, family, and household merged (2000) {p_end}

{synoptline}
{p2colreset}{...}
{p 4 6 2}

Use command {cmd:db datazoom_censo_en} to access through dialog box.

{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:datazoom_censo} extracts and builds Censo databases from the original IBGE microdata. 
Program can be used for Censo years 1970 to 2010.

{p 4 4 2}
The program can implement an algorithm to make variables compatible through waves. 
This is valid for those variables that exist in at least two waves and are not too much different in terms 
of survey methodology. The procedures applied through that algorithm are documented in "Census - Making variables compatible" 
disposable for download on the Portal website. In addition, to address the administrative boundaries changes 
issue, variables identifying consistet areas over time are included in the database. Under this option, 
noncompatible variables are deleted during the process. Moreover, monetary variables are deflated to August 2010.

{p 4 4 2}
The program generates one database for each federative unit and wave chosen. If necessary, use the
command {help append} so as to aggregate all states.  

{p 4 4 2}
If only one option {opt pes} {opt fam} {opt dom} is selected, the program will  generate a database with the option variables
 in one file. The file family exists only for the Census 2000. If the option {opt both} is selected, the program will
 generate a database with both household and individual variables in the same file. If the option {opt all} is selected, the program will
 generate a database with household, family and individual variables in the same file.
 
{marker options}{...}
{title:Options}
{dlgtab:Input}

{phang} {opt years(numlist)}  specifies the list of waves the user wants to work with. Alternatives are the
1970, 1980, 1991, 2000 and 2010 waves.

{phang} {opt original(str)} indicates the folder path where the user has copied the original data files. Each
 census has at least one file for each state.  All files must be located in the same folder so that the program functions properly.

{phang} {opt saving(str)} indicates the folder path where the new databases are to be saved.

{phang} {opt ufs(str)} specifies which states to include in the database. Each state code in the list must be the 
two-letter code often used to identify a Brazilian state. State codes: Rondônia RO, Acre AC, Amazonas AM, Roraima RR, 
Pará PA, Amapá AP, Tocantins TO, Fernando de Noronha FN, Maranhão MA, Piaui PI, Ceará CE, Rio Grande do Norte RN, 
Paraíba PB, Pernambuco PE, Alagoas AL, Sergipe SE, Bahia BA, Minas Gerais MG, Espírito Santo ES, Rio de Janeiro RJ, 
Guanabara GB, São Paulo SP, Paraná PR, Santa Catarina SC, Rio Grande do Sul RS, Mato Grosso do Sul MS, Mato Grosso 
MT, Goiás GO, Distrito Federal DF.

{dlgtab:Compatibility}

{phang}
{opt comp}  requests the databases be compatible through waves. Under this option, the final number of variables is 
reduced to the set of variables that appear in at least two
waves. Even so, due to methodological changes, some variables are not subject to standardization and are therefore excluded.

{dlgtab:Types of Register}

{phang}
{opt pes}  specifies that the user wants to get variables at the individual level. This is the default option if no type of register is chosen.

{phang}
{opt dom}  specifies that the user wants to get variables at the household level.

{phang}
{opt fam}  specifies that the user wants to get variables at the family level.

{phang} 
{opt both} specifies that the user wants to get variables at household and individual levels. In this option,
 both types of variables are merged in a single database. The program executes the command {help merge} 
 automatically so as to aggregate both types of variables.
 
{phang} 
{opt all} specifies that the user wants to get variables at household, family and individual levels (2000). In this option,
 the three types of variables are merged in a single database. The program executes the command {help merge} 
 automatically so as to aggregate the three types of variables.
 
{marker examples}{...}
{title:Exemplos}

{p 4 4 2}
Produces eight databases, one for each state and year. Variables are not made compatible.

{p 8 6 2}. datazoom_censo, years(1970 2000) original("~/mydir") saving("~/mydir") ufs(BA RJ SP DF) pes

{p 4 4 2}
Same eight databases, but now at both the individual and household levels, as well as with compatible variables between the years.

{p 8 6 2}. datazoom_censo, years(1970 2000) original("~/mydir") saving("~/mydir") ufs(BA RJ SP DF) comp both
 
{marker remarks}{...}
{title:Note on the original data}


{phang}
The names and quantity of the microdata files provided by IBGE change from one Census wave to another. 
Below there is a list of the names and number of datafiles expected by {cmd:datazoom_censo} for each year and
federative unit (FU).

{phang}
If there are differences between the list and the user file for a given FU, the program will not
work properly for the FU.

{phang}
If there is a disparity only in the name of the file, the program should 
work properly after the user rename his data file by adapting it to the one found in the list. 

{phang}
However, it is possible that the structure of the data used by Data Zoom is different from the structure of 
the data owned by the user even in the case where apparently there are differences in names only. In this case, 
the program will not work correctly. To check for possible structural differences, please check the variables dictionary 
available for download in www.econ.puc-rio.br/datazoom and compare it with the dictionary at hand.

{phang} - Microdata names list. For 1991 onward, suffix number refers, in general,
 to the IBGE Federative Unit codes.

{phang} 1970

{phang} - prefix for all files: Damo70

{phang} - suffixes: RO AC AM RR PA AP FN MA PI CE RN PB PE AL SE BA MG ES RJ GB SP PR SC RS MT GO DF

{phang} 1980

{phang} - prefix for all files: AMO80.UF

{phang} - suffixes: RO AC AM RR PA AP MA PI CE RN PB PE AL SE BA MG ES RJ SP PR SC RS MS MT GO DF

{phang} 1991 

{phang} - prefix for all files: CD102U

{phang} - suffixes: U11 U12 U13 U14 U15 U16 U17 U21 U22 U23 U24 U25 U26 U27 U28 U29 U31 U32 U33 P35 P36 U41 U42 U43 U50 U51 U52 U53

{phang} - note that P35 and P36 refer to SP datafiles

{phang} 2000

{phang} - prefixes: Pes (for individuals), Dom (for households) and Fami (for families)

{phang} - suffixes: 11 12 13 14 15 16 17 21 22 23 24 25 26 27 28 29 31 32 33 35 41 42 43 50 51 52 53

{phang} 2010

{phang} - prefixes: Amostra_Pessoas_ (for individuals) and Amostra_Domicilios_ (for households)

{phang} - suffixes: 11 12 13 14 15 16 17 21 22 23 24 25 26 27 28 29 31 32 33 35_outras 35_RMSP 41 42 43 50 51 52 53 14munic

{phang} - note that 35_outras and 35_RMSP refer to SP 

{phang} - note that 14munic refers to the Census 2000 file redefined by IBGE for 14 municipalities
 
 
{title:Author}

{p 4 4 2}
DataZoom     {break}
PUC-Rio - Department of Economics   {break}
Contact through  {browse "https://github.com/datazoompuc/datazoom_social_Stata":Github}      {break}

{space 4}{hline}
