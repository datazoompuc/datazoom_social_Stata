{smcl}
{viewerdialog "ECINF" "dialog datazoom_ecinf_en"}
{viewerdialog "Package" "dialog datazoom_social_en"}
{vieweralsosee "PNAD" "help datazoom_pnad_en"}{...}
{vieweralsosee "PNS" "help datazoom_pns_en"}{...}
{vieweralsosee "PNAD Contínua" "help datazoom_pnadcontinua_en"}{...}
{vieweralsosee "PNAD Contínua - Yearly" "help datazoom_pnadcont_anual_en"}{...}
{vieweralsosee "PNAD Covid" "help datazoom_pnad_covid_en"}{...}
{vieweralsosee "PME" "help datazoom_pme_en"}{...}
{vieweralsosee "POF" "help datazoom_pof_en"}{...}
{vieweralsosee "Censo" "help datazoom_censo_en"}{...}
{viewerjumpto "Syntax" "datazoom_censo##syntax"}{...}
{viewerjumpto "Description" "datazoom_censo##description"}{...}
{viewerjumpto "Options" "datazoom_censo##options"}{...}
{viewerjumpto "Examples" "datazoom_censo##examples"}{...}
{viewerjumpto "Note on the original data" "datazoom_censo##remarks"}{...}
{p 8 8 2} {it:Para a versão em português}, {help datazoom_ecinf}

{title:Title}

{p 4 4 2}
{cmd:datazoom_ecinf} {hline 2} Access to ECINF microdata

{marker syntax}{...}
{title:Syntax}

{p 8 8 2} {cmd:datazoom_ecinf} [, {it:options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{opt year(numlist)}} wave {p_end}
{synopt:{opt original(str)}} path to original microdata {p_end}
{synopt:{opt saving(str)}} path where databases will be saved {p_end}
{synopt:{opt tipo(str)}} type of register {p_end}
{synopt:{opt english}} variable labels in English {p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}

Use command {cmd:db datazoom_ecinf_en} to access through dialog box.

{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:datazoom_ecinf} extracts ECINF databases in Stata format from the original IBGE microdata. Supports years 1997 and 2003.

{marker options}{...}
{title:Options}
{dlgtab:Options}
{phang}
{opt year(numlist)}  specifies the year to be extracted. It is not possible to select two waves simultaneously.

{phang}
{opt original(string)}  indicates the path of the folder where the original data files are located. 
 All files should be located in the same folder so that the program
functions properly.

{phang}
{opt saving(string)}  indicates the path of the folder where the user wants to save the new datafiles.

{phang}
{opt tipo(str)}  specifies the type(s) of register the user wants to work with. These types are named
	according to the ECINF Dictionary provided by IBGE: {opt domicilios} for household, {opt moradores} for household members, 
	{opt trabrend} for labor and income; {opt uecon} for economic unit, {opt pesocup} for characteristics
	of the employed; {opt indprop} for the proprietor's individual characteristics; and {opt sebrae} for the Sebrae supplement (suits only 2003).

{marker examples}{...}
{title:Examples}

{p 8 6 2}. datazoom_ecinf, year(1997) tipo(pesocup indprop uecon) original("~/mydir") saving("~/mydir")


{title:Author}

{p 4 4 2}
DataZoom     {break}
PUC-Rio - Department of Economics   {break}
Contact through  {browse "https://github.com/datazoompuc/datazoom_social_Stata":Github}      {break}

{space 4}{hline}

