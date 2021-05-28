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
{bf:datazoom_ecinf} {hline 2} Acesso aos microdados da ECINF em formato STATA - Versão 1.0

{marker syntax}{...}
{title:Syntax}
{p 8 17 2}
{cmdab:datazoom_ecinf}
[{cmd:,}
{it:options}]

{phang}	OBS: digite 'db datazoom_ecinf' na janela de comando para utilizar o programa via caixa de diálogo

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{opt year(numlist)}} ano da pesquisa {p_end}
{synopt:{opt original(string)}} caminho da pasta onde se localizam os arquivos de dados originais {p_end}
{synopt:{opt saving(string)}} caminho da pasta onde serão salvas as novas bases de dados {p_end}
{synopt:{opt tipo(str)}} tipo de registro {p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}

{marker description}{...}
{title:Descrição}
{pstd}
{cmd:datazoom_ecinf} extrai bases de dados da ECINF em formato STATA a partir dos microdados originais, 
	os quais não são disponibilizados pelo Portal (informações sobre como obter os arquivos originais de dados, consulte o
        site do IBGE www.ibge.gov.br). Este programa pode ser utilizado para 1997 e 2003.

{marker options}{...}
{title:Opções}
{dlgtab:Main}
{phang}
{opt year(numlist)}  especifica o ano a ser extraído. Não é possível escolher os dois anos ao mesmo tempo. 

{phang}
{opt original(string)}  indica o caminho da pasta onde estão localizados os arquivos de dados
        originais. Todos os arquivos devem estar posicionados na mesma pasta para que o programa funcione
        adequadamente. O Portal não disponibiliza os dados originais.

{phang}
{opt saving(string)}  indica o caminho da pasta onde devem ser salvas as bases de dados
        produzidas pelo programa.

{phang}
{opt tipo(str)}  especifica para quais tipos de registros o usuário deseja obter os microdados. Os tipos são nomeados conforme a 
	documentação do IBGE: {opt domicilios}, {opt moradores}, {opt trabrend} para trabalho e rendimento, 
	{opt uecon} para unidade econômica, {opt pesocup} para características das pessoas ocupadas, 
	{opt indprop} para características individuais do proprietário  e {opt sebrae} para o suplemento Sebrae (somente para 2003). 


{marker examples}{...}
{title:Example}

{phang} datazoom_ecinf, year(1997) tipo(pesocup indprop uecon) original(D:/Finep/ECINF/dados) saving(D:/teste)


{title:Autor}
{p}

PUC-Rio - Departamento de Economia

Email {browse "mailto:datazoom@econ.puc-rio.br":datazoom@econ.puc-rio.br}


{title:Veja também}

Pacotes relacionados:

{help datazoom_censo} (se instalado) 
{help datazoom_pnad} (se instalado)  
{help datazoom_pmenova} (se instalado)  
{help datazoom_pmeantiga} (se instalado)  
{help datazoom_pof2008} (se instalado)  
{help datazoom_pof2002} (se instalado) 
{help datazoom_pof1995} (se instalado) 


{p} Digite "net from http://www.econ.puc-rio.br/datazoom/portugues" para instalar a versão em português desses pacotes. 
For the english version, type "net from http://www.econ.puc-rio.br/datazoom/english".
