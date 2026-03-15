{smcl}
{viewerdialog "Annual PNAD Contínua" "dialog datazoom_pnadcont_anual_en"}
{viewerdialog "Package" "dialog datazoom_social_en"}
{vieweralsosee "PNAD" "help datazoom_pnad_en"}{...}
{vieweralsosee "Censo" "help datazoom_censo_en"}{...}
{vieweralsosee "PNAD Contínua" "help datazoom_pnadcontinua_en"}{...}
{vieweralsosee "PNS" "help datazoom_pns_en"}{...}
{vieweralsosee "PNAD Covid" "help datazoom_pnad_covid_en"}{...}
{vieweralsosee "PME" "help datazoom_pme_en"}{...}
{vieweralsosee "POF" "help datazoom_pof_en"}{...}
{vieweralsosee "ECINF" "help datazoom_ecinf_en"}{...}
{viewerjumpto "Syntax" "datazoom_pnadcont_anual_en##syntax"}{...}
{viewerjumpto "Description" "datazoom_pnadcont_anual_en##description"}{...}
{viewerjumpto "Options" "datazoom_pnadcont_anual_en##options"}{...}
{viewerjumpto "Examples" "datazoom_pnadcont_anual_en##examples"}{...}
{p 8 8 2} {it:Para a versão em português}, {help datazoom_pnadcont_anual}

{title:Title}

{p 4 4 2}
{cmd:datazoom_pnadcont_anual} {hline 2} Access to Continuous PNAD microdata {c -} Annual Dissemination

{marker syntax}{...}
{title:Syntax}

{p 8 8 2} {cmd:datazoom_pnadcont_anual} [, {it:options}]
	
{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Input}
{synopt:{opt years(numlist)}} years followed by visits or trimesters (quarters) {p_end}
{synopt:{opt original(str)}} path to original microdata {p_end}
{synopt:{opt saving(str)}} path where databases will be saved {p_end}
{synopt:{opt english}} requests variable labels in English {p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}

Use command {cmd:db datazoom_pnadcont_anual_en} to access through dialog box.

{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:datazoom_pnadcont_anual} extracts and builds databases from the original PNAD Contínua 
Annual Dissemination microdata, for years 2012 to 2024. 

{p 4 4 2}
This program allows, for each year, the selection of the available household acumulated visits and quarters for data extraction. For example, years(2016_vis1 2017_tri2) refers to the first cumulative household visits in 2016 and to the second quarter (trimester) of 2017. Annual Continuous PNAD data are particularly useful for the analysis of PNAD supplements, in which IBGE includes additional questions on specific topics in particular quarters and household visits in selected years. To verify the periods in which each supplement is available, consult the Supplements Guide. Users may generate a download link using the program’s dialog box, or alternatively search directly on the IBGE website. For further information on cumulative visits data, quarters, and supplements, read the survey’s technical note available on the IBGE website. For each household visit and each quarter, there is an original txt database available on the IBGE website. Users must download the original data files and provide the path to this folder in the option original() in order to use the command correctly.
 
{p 4 4 2}
Since IBGE still conducts Annual PNAD Continuous surveys, this program will be continuously updated.
  
{p 4 4 2}
The program generates one dataset for each selected period (year_visit and/or year_quarter). It may be useful to use the {help append} command to stack the datasets, provided that they are compatible.

{marker options}{...}
{title:Options}
{dlgtab:Input}

{phang} 
{opt years(numlist)} Specifies the list of years, together with the household visits and/or quarters with which the user wishes to work. This program can be used for the period from 2012 to 2024, with specific visits and quarters. Annual dissemination microdata files are not available for all visits or quarters. Therefore, it is necessary to verify which visits and quarters are available in order to call the command correctly.

{phang} {opt original(str)} Indicates the path to the folder where the original data files are located. There are microdata files for each survey year, and there may be one or more files per year, referring to cumulative household visits and quarters. All files must be stored in the same folder in order for the program to work properly. 
The Portal does not provide the original data files, which can be obtained from the IBGE website.

{phang} {opt saving(str)} specifies the folder path where the new databases are to be saved.

{phang} {opt english} requests English variable labels. By default, labels are provided in Portuguese (Brazil).

{marker examples}{...}
{title:Examples}

{p 4 4 2}
Annual databases, with English variable labels

{p 8 6 2}. datazoom_pnadcont_anual, years(2012_vis1 2014_vis1 2017_tri2) original("~/mydir") saving("~/mydir") english 

{p 6 6 2}
Three databases are created, one per visit or quarter.

{title:Author}

{p 4 4 2}
DataZoom     {break}
PUC-Rio - Department of Economics   {break}
Contact through  {browse "https://github.com/datazoompuc/datazoom_social_Stata":Github}      {break}

{space 4}{hline}
