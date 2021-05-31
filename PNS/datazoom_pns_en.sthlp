{smcl}
{* *! version 2.0 09 11 2020}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "Install command2" "ssc install command2"}{...}
{vieweralsosee "Help command2 (if installed)" "help command2"}{...}
{viewerjumpto "Syntax" "datazoom_pns##syntax"}{...}
{viewerjumpto "Description" "datazoom_pns##description"}{...}
{viewerjumpto "Options" "datazoom_pns##options"}{...}
{viewerjumpto "Remarks" "datazoom_pns##remarks"}{...}
{viewerjumpto "Examples" "datazoom_pns##examples"}{...}
{title:Title}

{phang}
{bf:datazoom_pns} {hline 2} Access to STATA format PNS databases  - Version 2.1

{marker syntax}{...}
{title:Syntax}
{p 8 17 2}
{cmdab:datazoom_pns}
[{cmd:,}
{it:options}]

{phang}	NOTE: type 'db datazoom_pns' to use program through dialog box

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Inputs}
{synopt:{opt original(str)}} file paths for each original datafile {p_end}
{synopt:{opt saving(str)}} folder path for saving new databases {p_end}

{syntab:Year}
{synopt:{opt year(number)}} year {p_end}

{synoptline}
{p2colreset}{...}
{p 4 6 2}

{marker description}{...}
{title:Description}
{pstd}
{cmd:datazoom_pns} extracts and constructs PNS compatible STATA format databases from original IBGE microdata files, which are not provided by the Portal (for information on how to acquire original datafiles, see www.ibge.gov.br).
 


{marker options}{...}
{title:Options}
{dlgtab:Inputs}

{phang} {opt original(str)} indicates the path of the original data files. The user
        must include paths for all the files he/she is interested in.
 

{phang} {opt saving(str)} specifies the folder path where the new databases are to be saved.

{dlgtab:Year}

{phang}
{opt year(number)} year identifying PNS edition of interest


		
			
	
{marker examples}{...}
{title:Example}

{phang} datazoom_pns, original(C:\DataZoom\PNS\Dados) saving(C:\Bases) year(2013)


{title:Author}
{p}

PUC-Rio - Department of Economics

Email {browse "mailto:datazoom@econ.puc-rio.br":datazoom@econ.puc-rio.br}


{title:See Also}

Related packages:

{help datazoom_censo} (if installed)   
{help datazoom_pnad} (if installed)
{help datazoom_pnadcontinua} (if installed)
{help datazoom_pnadcont_anual} (if installed)  
{help datazoom_pnad_covid} (if installed)
{help datazoom_pmeantiga} (if installed)  
{help datazoom_pmenova} (if installed)   
{help datazoom_pof2017}(if installed)   
{help datazoom_pof2008}(if installed)   
{help datazoom_pof2002} (if installed)  
{help datazoom_pof1995} (if installed)   
{help datazoom_ecinf} (if installed) 

{p} Type "net from http://www.econ.puc-rio.br/datazoom/english" to install these
commands.  Para instalar a versão em portugues, digite "net from
http://www.econ.puc-rio.br/datazoom/portugues".
