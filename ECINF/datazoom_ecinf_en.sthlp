{smcl}
{* *! version 1.0 28 Jun 2013}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "Install command2" "ssc install command2"}{...}
{vieweralsosee "Help command2 (if installed)" "help command2"}{...}
{viewerjumpto "Syntax" "datazoom_ecinf##syntax"}{...}
{viewerjumpto "Description" "datazoom_ecinf##description"}{...}
{viewerjumpto "Options" "datazoom_ecinf##options"}{...}
{viewerjumpto "Remarks" "datazoom_ecinf##remarks"}{...}
{viewerjumpto "Examples" "datazoom_ecinf##examples"}{...}
{title:Title}
{phang}

{bf:datazoom_ecinf} {hline 2} Access to STATA format ECINF databases - Version 1.0

{marker syntax}{...}
{title:Syntax}
{p 8 17 2}
{cmdab:datazoom_ecinf}
[{cmd:,}
{it:options}]

{phang} Note: type 'db datazoom_ecinf' in the command window to use the program through the dialog blog.

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{opt year(numlist)}} wave {p_end}
{synopt:{opt original(string)}} folder path where original datafiles are located {p_end}
{synopt:{opt saving(string)}} folder where new databases are to be saved {p_end}
{synopt:{opt tipo(str)}} types of register {p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}

{marker description}{...}
{title:Description}

{pstd}
{cmd:datazoom_ecinf} extracts ECINF databases from original IBGE microdata files, which are not available online 
(for information on how to acquire original files,
see www.ibge.gov.br).
	This program suits 1997 and 2003 waves.

{marker options}{...}
{title:Options}
{dlgtab:Main}
{phang}
{opt year(numlist)}  specifies the year to be extracted. It is not possible to select two waves simultaneously.

{phang}
{opt original(string)}  indicates the path of the folder where the original data files are located. 
 All files should be located in the same folder so that the program
functions properly.
		The Portal does not provide these data. Please check IBGE website for information on how to get
        microdata files.

{phang}
{opt saving(string)}  indicates the path of the folder where the user wants to save the new datafiles.

{phang}
{opt tipo(str)}  specifies the type(s) of register the user wants to work with. These types are named
	according to the ECINF Dictionary provided by IBGE: {opt domicilios} for household, {opt moradores} for household members, 
	{opt trabrend} for labor and income; {opt uecon} for economic unit, {opt pesocup} for characteristics
	of the employed; {opt indprop} for the proprietor's individual characteristics; and {opt sebrae} for the Sebrae supplement (suits only 2003).


{marker examples}{...}
{title:Examples}

{phang} datazoom_ecinf, year(1997) tipo(pesocup indprop uecon) original(D:\Finep\ECINF\dados) saving(D:\teste)

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
{help datazoom_pof1995} (if installed)

{p} Type "net from http://www.econ.puc-rio.br/datazoom/english" to install these commands.
Para instalar a versão em portugues, digite "net from http://www.econ.puc-rio.br/datazoom/portugues".
