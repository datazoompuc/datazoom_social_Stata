{smcl}
{* *! version 1.4 22 October 2015}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "Install command2" "ssc install command2"}{...}
{vieweralsosee "Help command2 (if installed)" "help command2"}{...}
{viewerjumpto "Syntax" "datazoom_censo##syntax"}{...}
{viewerjumpto "Description" "datazoom_censo##description"}{...}
{viewerjumpto "Options" "datazoom_censo##options"}{...}
{viewerjumpto "Remarks" "datazoom_censo##remarks"}{...}
{viewerjumpto "Examples" "datazoom_censo##examples"}{...}
{title:Title}

{phang}
{bf:datazoom_censo} {hline 2} Access to STATA format Censo databases - Version 1.4

{marker syntax}{...}
{title:Syntax}
{p 8 17 2}
{cmdab:datazoom_censo}
[{cmd:,}
{it:options}]

	NOTE: type 'db datazoom_censo' to use program through dialog box

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Inputs}
{synopt:{opt years(numlist)}} waves {p_end}
{synopt:{opt original(str)}} folder path where original datafiles are located {p_end}
{synopt:{opt saving(str)}} folder path for saving new databases {p_end}
{synopt:{opt ufs(str)}} Federation Units codes {p_end}

{syntab:Waves Compatibility}
{synopt:{opt comp}} compatible databases {p_end}

{syntab:Type of Register}
{synopt:{opt pes}} individual variables only {p_end}
{synopt:{opt dom}} household variables only {p_end}
{synopt:{opt fam}} family variables only (2000) {p_end}
{synopt:{opt both}} individual and household variables merged {p_end}
{synopt:{opt all}} individual, family and household variables merged (2000) {p_end}

{synoptline}
{p2colreset}{...}
{p 4 6 2}

{marker description}{...}
{title:Description}

{phang}
{cmd:datazoom_censo} extracts and constructs CENSO STATA format (.dta) databases from original IBGE 
microdata files. These original files are not provided by the Portal (please check IBGE website for 
information about how to acquire them - www.ibge.gov.br).

{phang} The program can implement an algorithm to make variables compatible through waves. 
This is valid for those variables that exist in at least two waves and are not too much different in terms 
of survey methodology. The procedures applied through that algorithm are documented in "Census - Making variables compatible" 
disposable for download on the Portal website. In addition, to address the administrative boundaries changes 
issue, variables identifying consistet areas over time are included in the database. Under this option, 
noncompatible variables are deleted during the process. Moreover, monetary variables are deflated to August 2010.

{phang}	The program generates one database for each federative unit and wave chosen. If necessary, use the
command {help append} so as to aggregate all states. 

{phang} Se apenas uma das opções dentre {opt pes}, {opt fam} ou {opt dom} for escolhida, o programa gera uma base de dados com as variáveis 
correspondentes à seleção em um único arquivo. O arquivo família existe somente para o Censo 2000. Se a opção {opt both} for escolhida, o programa 
gera uma base de dados inclindo as variáveis de domicílios e pessoas no mesmo arquivo. Se a opção {opt all} for escolhida, disponível apenas para 
o ano 2000, o programa gera uma base de dados inclindo as variáveis de domicílios, famílias e pessoas no mesmo arquivo.

{phang} If only one option {opt pes} {opt fam} {opt dom} is selected, the program will  generate a database with the option variables
 in one file. The file family exists only for the Census 2000. If the option {opt both} is selected, the program will
 generate a database with both household and individual variables in the same file. If the option {opt all} is selected, the program will
 generate a database with household, family and individual variables in the same file.
 
{phang}	Initially, it is strongly recommended to use the program through its dialog box, for it facilitates the insertion
of the necessary information. Type 'db datazoom_censo' on the command window in order to access the dialog box.


{marker remarks}{...}
{title:Note}

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


{marker options}{...}
{title:Options}
{dlgtab:Inputs}

{phang} {opt years(numlist)}  specifies the list of waves the user wants to work with. This program suits
1970, 1980, 1991, 2000 and 2010 waves.

{phang} {opt original(str)} indicates the folder path where the user has copied the original data files. Each
 census has at least one file for each state.  All files must be positioned in the same folder so that the program functions properly.
 The Portal does not provide these data. The 2010 data are available online. Please check IBGE website for information on how to get
other waves' microdata files.

{phang} {opt saving(str)} indicates the folder path where the new databases are to be saved.

{phang} {opt ufs(str)} specifies which states to include in the database. Each state code in the list must be the 
two-letter code often used to identify a Brazilian state. State codes: Rondônia RO, Acre AC, Amazonas AM, Roraima RR, 
Pará PA, Amapá AP, Tocantins TO, Fernando de Noronha FN, Maranhão MA, Piaui PI, Ceará CE, Rio Grande do Norte RN, 
Paraíba PB, Pernambuco PE, Alagoas AL, Sergipe SE, Bahia BA, Minas Gerais MG, Espírito Santo ES, Rio de Janeiro RJ, 
Guanabara GB, São Paulo SP, Paraná PR, Santa Catarina SC, Rio Grande do Sul RS, Mato Grosso do Sul MS, Mato Grosso 
MT, Goiás GO, Distrito Federal DF.

{dlgtab:Waves Compatibility}

{phang}
{opt comp}  requests the databases be compatible through waves. Under this option, the final number of variables is 
reduced to the set of variables that appear in at least two
waves. Even so, due to methodological changes, some variables are not subject to standardization and are therefore excluded.

{dlgtab:Type of Register}

{phang}
{opt pes}  specifies that the user wants to get variables at individual level. If no type of register is chosen, the program
automatically run this option.

{phang}
{opt dom}  specifies that the user wants to get variables at household level.

{phang}
{opt fam}  specifies that the user wants to get variables at family level (2000).

{phang}
{opt both} specifies that the user wants to get variables at household and individual levels. In this option,
 both types of variables are merged in a single database. The program executes the command {help merge} 
 automatically so as to aggregate both types of variables.
 
 {phang}
{opt all} specifies that the user wants to get variables at household, family and individual levels (2000). In this option,
 the three types of variables are merged in a single database. The program executes the command {help merge} 
 automatically so as to aggregate the three types of variables.


{marker examples}{...}
{title:Examples}

{phang} datazoom_censo years(1970 2000) original("C:/censo") saving("C:/censo/bases") ufs(BA RJ SP DF), pes 

{pstd} The above-cited command renders eight databases, one for each state and wave chosen. The variables are not standardized. 

{phang} datazoom_censo years(1970 2000) original("C:/censo") saving("C:/censo/bases") ufs(BA RJ SP DF), comp both

{pstd} The command above renders the same eight databases of the previous exemple. The difference is that each database 
contains the individuals and household variables, all standardized. 

{phang}  NOTE: In order to facilitate the command use, type "db datazoom_censo" on the command window.

{title:Author}
{p}

PUC-Rio - Department of Economics

Email {browse "mailto:datazoom@econ.puc-rio.br":datazoom@econ.puc-rio.br}

{title:See Also}

Related commands:

{help datazoom_pnad} (if installed) 
{help datazoom_pmenova} (if installed)  
{help datazoom_pmeantiga} (if installed)  
{help datazoom_pof2008} (if installed)  
{help datazoom_pof2002} (if installed)  
{help datazoom_pof1995} (if installed)  
{help datazoom_ecinf} (if installed)  

{p} Type "net from http://www.econ.puc-rio.br/datazoom/english" to install these commands.
Para instalar a versão em portugues, digite "net from http://www.econ.puc-rio.br/datazoom/portugues".
