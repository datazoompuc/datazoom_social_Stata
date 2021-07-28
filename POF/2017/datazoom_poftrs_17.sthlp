{smcl}
{* *! version 1.0 16 Jul 2020}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "Install command2" "ssc install command2"}{...}
{vieweralsosee "Help command2 (if installed)" "help command2"}{...}
{viewerjumpto "Syntax" "c:/ado/plus/p/datazoom_poftrs_17##syntax"}{...}
{viewerjumpto "Description" "c:/ado/plus/p/datazoom_poftrs_17##description"}{...}
{viewerjumpto "Options" "c:/ado/plus/p/datazoom_poftrs_17##options"}{...}
{viewerjumpto "Remarks" "c:/ado/plus/p/datazoom_poftrs_17##remarks"}{...}
{viewerjumpto "Examples" "c:/ado/plus/p/datazoom_poftrs_17##examples"}{...}
{title:Title}

{phang}
{bf:datazoom_poftrs_17} {hline 2}  Acesso às bases da POF 2017-18 em formato STATA - Versão 1.0

{marker syntax}{...}
{title:Syntax}

{p 8 17 2}
{cmdab:datazoom_poftrs_17}
[{cmd:,}
{it:options}]

{phang}	OBS: digite 'db datazoom_pof2017' na janela de comando para utilizar o programa via caixa de diálogo

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{opt trs(string)}} tipos de registros {p_end}
{synopt:{opt original(string)}} caminho da pasta onde se localizam os arquivos de dados originais {p_end}
{synopt:{opt saving(string)}} caminho da pasta onde serão salvas as novas bases de dados {p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}

{marker description}{...}
{title:Descrição}

{phang}
{cmd:datazoom_poftrs_17} extrai bases de dados da POF 2017-18 em formato STATA (.dta) a partir dos microdados originais, 
os quais não são disponibilizados pelo Portal (informações sobre como obter os arquivos originais de dados, consulte o
        site do IBGE www.ibge.gov.br).
		
{phang} Este programa auxilia o usuário a ter acesso aos 7 tipos de registros existentes na POF 2017-18 sem que haja
	manipulação de variáveis, ou seja, apenas torna possível a utilização dos microdados da POF via STATA.


{marker options}{...}
{title:Opções}
{dlgtab:Main}

{phang}
{opt trs(string)}  especifica o(s) tipo(s) de registro(s) que o usuário deseja obter. A versão 2017-18 possui 7 tipos de 
registros, numerados conforme a documentação do IBGE.

{phang}
{opt original(string)}  indica o caminho da pasta onde estão localizados os arquivos de dados
        originais. Todos os 7 arquivos devem estar posicionados na mesma pasta para que o programa funcione
        adequadamente. O Portal não disponibiliza os dados originais.

{phang}
{opt saving(string)}  indica o caminho da pasta onde devem ser salvas as bases de dados
        produzidas pelo programa.

{marker examples}{...}
{title:Exemplo}

{phang} datazoom_poftrs_17, trs(tr1 tr6 tr7) original(c:/mydata) saving(c:/pof)

{phang} A execução do exemplo acima gera três bases de dados, uma para cada tipo de registro especificado 
(1 - Domicílio; 6 - Rendimento do Trabalho; 7 - Outros Rendimentos). As três bases serão salvas na pasta
"c:/pof".

{phang}  OBS: Recomenda-se a execução do programa por meio da caixa de diálogo. Digite "db
        datazoom_pof2017" na janela de comando do STATA para iniciar.


{title:Autor}
{p}

PUC-Rio - Departamento de Economia

Email {browse "mailto:datazoom@econ.puc-rio.br":datazoom@econ.puc-rio.br}


{title:Veja também}
	
Pacotes relacionados:

{help datazoom_pnad_covid} (se instalado)  
{help datazoom_censo} (se instalado)  
{help datazoom_pnad} (se instalado)  
{help datazoom_pnadcontinua} (se instalado)  
{help datazoom_pmeantiga} (se instalado)
{help datazoom_pnadcontinua} (se instalado)  
{help datazoom_pnadcont_anual} (se instalado)  
{help datazoom_pmenova} (se instalado)  
{help datazoom_pof2008} (se instalado)  
{help datazoom_pof2002} (se instalado)  
{help datazoom_pof1995} (se instalado)  
{help datazoom_ecinf} (se instalado) 
{help datazoom_pns} (se instalado) 

{p} Digite "net from http://www.econ.puc-rio.br/datazoom/portugues" para instalar a versão em português desses pacotes. 
For the english version, type "net from http://www.econ.puc-rio.br/datazoom/english".
