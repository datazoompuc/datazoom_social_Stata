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
{bf:datazoom_pns} {hline 2} Acesso aos microdados da PNS em formato STATA - Versão 2.1

{marker syntax}{...}
{title:Syntax}
{p 8 17 2}
{cmdab:datazoom_pns}
[{cmd:,}
{it:options}]

{phang}	OBS: digite 'db datazoom_pns' na janela de comando para utilizar o programa via caixa de diálogo

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Inputs}
{synopt:{opt original(str)}} caminho da pasta onde se localizam os arquivos de dados originais {p_end}
{synopt:{opt saving(str)}} caminho da pasta onde serão salvas as novas bases de dados {p_end}

{syntab:Ano}
{synopt:{opt year(number)}} ano {p_end}

{synoptline}
{p2colreset}{...}
{p 4 6 2}

{marker description}{...}
{title:Descrição}
{pstd}
{cmd:datazoom_pns} extrai bases de dados da PNS em formato STATA a partir dos microdados originais, 
	os quais não são disponibilizados pelo Portal (informações sobre como obter os arquivos originais de dados, consulte o
        site do IBGE www.ibge.gov.br). 


{marker options}{...}
{title:Opções}
{dlgtab:Inputs}

{phang} {opt original(str)} indica o caminho dos arquivos de dados originais. 

{phang} {opt saving(str)} indica o caminho da pasta onde devem ser salvas as bases de dados produzidas pelo programa.

{dlgtab:Ano}

{phang}
{opt year(number)}  especifica a edição de interesse da PNS.
			
	
{marker examples}{...}
{title:Exemplo}

{phang} datazoom_pns, original(C:\DataZoom\PNS\Dados) saving(C:\Bases) year(2013)


{title:Autor}
{p}

PUC-Rio - Departamento de Economia

Email {browse "mailto:datazoom@econ.puc-rio.br":datazoom@econ.puc-rio.br}


{title:Veja também}

Pacotes relacionados:

{help datazoom_censo} (se instalado)   
{help datazoom_pnad} (se instalado)
{help datazoom_pnadcontinua} (se instalado)
{help datazoom_pnadcont_anual} (se instalado)  
{help datazoom_pnad_covid} (se instalado)
{help datazoom_pmeantiga} (se instalado)  
{help datazoom_pmenova} (se instalado)   
{help datazoom_pof2017}(se instalado)   
{help datazoom_pof2008}(se instalado)   
{help datazoom_pof2002} (se instalado)  
{help datazoom_pof1995} (se instalado)   
{help datazoom_ecinf} (se instalado) 


{p} Digite "net from http://www.econ.puc-rio.br/datazoom/portugues" para instalar a versão em português desses pacotes. 
For the english version, type "net from http://www.econ.puc-rio.br/datazoom/english".
