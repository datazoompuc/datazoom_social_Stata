{smcl}
{* *! version 1.0 17 05 2021}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "Install command2" "ssc install command2"}{...}
{vieweralsosee "Help command2 (if installed)" "help command2"}{...}
{viewerjumpto "Syntax" "datazoom_social##syntax"}{...}
{viewerjumpto "Description" "datazoom_social##description"}{...}
{viewerjumpto "Options" "datazoom_social##options"}{...}
{viewerjumpto "Remarks" "datazoom_social##remarks"}{...}
{viewerjumpto "Examples" "datazoom_social##examples"}{...}
{p 8 8 2} {it:For the English version}, {help datazoom_social_en}

{title:Title}

{phang}
{bf:datazoom_social} {hline 2} Acesso aos microdados das pesquisas domiciliares do IBGE em formato STATA - Versão 1.0

{marker syntax}{...}
{title:Syntax}
{p 8 17 2}
{cmdab:datazoom_social}
[{cmd:,}
{it:options}]

{phang}	OBS: digite 'db datazoom_social' na janela de comando para utilizar o programa via caixa de diálogo

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Inputs}
{synopt:{opt research(str)}} pesquisa domiciliar que deseja fazer leitura dos dados {p_end}
{synopt:{opt folder1(str)}} caminho da pasta onde se localizam os arquivos de dados originais {p_end}
{synopt:{opt folder2(str)}} caminho da pasta onde serão salvas as novas bases de dados {p_end}

{syntab:Período}
{synopt:{opt date(number)}} data da pesquisa (mês ou ano) {p_end}

{syntab:Outras opções}
{synopt:{opt ops}} acesse "https://github.com/datazoompuc/datazoom_social_Stata/blob/main/README.md" para ver opções específicas de cada pesquisa {p_end}

{synoptline}
{p2colreset}{...}
{p 4 6 2}

{marker description}{...}
{title:Descrição}
{pstd}
{cmd:datazoom_social} extrai bases de dados de pesquisas domiciliares do IBGE em formato STATA a partir dos microdados originais, 
	os quais não são disponibilizados pelo Data Zoom. Para informações sobre como obter os arquivos originais de dados, 
	consulte o nosso github "https://github.com/datazoompuc/datazoom_social_Stata/blob/main/README.md#censo" ou o site do IBGE "www.ibge.gov.br" (sugestão: busque pela área de downloads). 


{marker options}{...}
{title:Opções}
{dlgtab:Inputs}

{phang} {opt research(str)} indica qual pesquisa deseja compatibilizar os dados. 

{phang} {opt folder1(str)} indica o caminho dos arquivos de dados originais. 

{phang} {opt folder2(str)} indica o caminho da pasta onde devem ser salvas as bases de dados produzidas pelo programa.

{dlgtab:Período}

{phang}
{opt date(number)}  especifica a edição/período de interesse da pesquisa.
			
	
{marker examples}{...}
{title:Exemplo}

{pstd}  OBS: Recomenda-se a execução do programa por meio da caixa de diálogo. Digite "db datazoom_social" na janela 
de comando do STATA para iniciar.

{phang} Exemplo 1: PNS

{phang} datazoom_social, research(pns) folder1(C:\DataZoom\PNS\Dados) folder2(C:\Bases) date(2019)

{pstd} Uma base de dados para o ano de 2019 é gerada

{pstd} 

{phang} Exemplo 2: Censo

{phang} datazoom_social, research(censo) folder1(C:\DataZoom\PNS\Dados) folder2(C:\Bases) date(2010) state(AC) pes

{pstd} Uma base de dados para o ano de 2010 para pessoas do estado do Acre é gerada

{pstd}

{phang} Exemplo 3: PME

{phang} datazoom_social, research(pmenova) folder1(C:\DataZoom\PNS\Dados) folder2(C:\Bases) date(2014 2015) nid

{pstd} Duas bases de dados para os anos de 2014 e 2015 são geradas.

{title:Autor}
{p}

PUC-Rio - Departamento de Economia

Email {browse "mailto:datazoom@econ.puc-rio.br":datazoom@econ.puc-rio.br}


{title:Veja também}

Documentação e exemplos específicos para cada pesquisa:

{help datazoom_censo}   
{help datazoom_pnad}
{help datazoom_pnadcontinua}
{help datazoom_pnadcont_anual}  
{help datazoom_pnad_covid}
{help datazoom_pmeantiga}  
{help datazoom_pmenova}   
{help datazoom_pof2017}   
{help datazoom_pof2008}   
{help datazoom_pof2002}  
{help datazoom_pof1995}   
{help datazoom_ecinf} 
