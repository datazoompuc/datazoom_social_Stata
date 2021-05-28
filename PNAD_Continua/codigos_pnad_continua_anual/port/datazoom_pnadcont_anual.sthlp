{smcl}
{* *! version 1.0 09th June 2020}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "Install command2" "ssc install command2"}{...}
{vieweralsosee "Help command2 (if installed)" "help command2"}{...}
{viewerjumpto "Syntax" "datazoom_pnadcontinua##syntax"}{...}
{viewerjumpto "Description" "datazoom_pnadcontinua##description"}{...}
{viewerjumpto "Options" "datazoom_pnadcontinua##options"}{...}
{viewerjumpto "Remarks" "datazoom_pnadcontinua##remarks"}{...}
{viewerjumpto "Examples" "datazoom_pnadcontinua##examples"}{...}
{title:Title}

{phang}
{bf:datazoom_pnadcont_anual} {hline 2} Acesso aos microdados da PNAD Contínua Anual em formato STATA - Versão 1.0

{marker syntax}{...}
{title:Syntax}
{p 8 17 2}
{cmdab:datazoom_pnadcont_anual}
[{cmd:,}
{it:options}]

{p}	OBS: digite 'db datazoom_pnadcont_anual' para utilizar o programa via caixa de diálogo
	
{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Inputs}
{synopt:{opt years(numlist)}} anos da PNAD Contínua Anual {p_end}
{synopt:{opt original(str)}} caminho da pasta onde se localizam os arquivos de dados originais {p_end}
{synopt:{opt saving(str)}} caminho da pasta onde serão salvas as novas bases de dados {p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}

{marker description}{...}
{title:Descrição}

{phang}
{cmd:datazoom_pnadcont_anual} extrai e constrói bases de dados da PNAD Contínua Anual em formato STATA (.dta) a partir
dos microdados originais do IBGE, os quais  não são disponibilizados pelo Portal. Para informações sobre como obter
os arquivos originais de dados, consulte o site do IBGE www.ibge.gov.br. O programa pode ser utilizado para os anos de 2012 a 2019. 

{phang} Apesar da periodicidade de divulgação da pesquisa ser anual, este programa permite, a partir de 2016, a escolha de duas entrevistas específicas para extração: (2016_entr1 e 2017_entr1)
referentes à 1ªentrevista do domicílio e (2016_entr5 e 2017_entr5) referentes à 5ª entrevista do domicílio. Isso se deve à mudança na pesquisa do IBGE
com a transferência da investigação "Outras formas de trabalho" para a 5ª entrevista do domicílio nos anos de 2016 e 2017. Para cada entrevista, 
há uma base original em txt disponível no site do IBGE. Para maiores informações sobre a mudança da entrevista, olhar nota técnica da pesquisa no site do IBGE.

{phang} Como a pesquisa ainda é publicada pelo IBGE, este programa está em constante atualização.
  
{phang} O programa gera uma base para cada ano selecionado. Se for o caso, utilize o 
comando {help append} para empilhar as bases.


{marker options}{...}
{title:Opções}
{dlgtab:Inputs}

{phang} 
{opt years(numlist)} especifica a lista de anos com os quais o usuário deseja trabalhar. Este programa 
pode ser utilizado para o período de 2012 a 2019. 

{phang} {opt original(str)} indica o caminho da pasta onde estão localizados os arquivos de dados originais. 
Existe um arquivo de microdados para cada ano da pesquisa, exceto para 2016 e 2017, nos quais há dois microdados por ano (um microdado referente à 1ª 
entrevista e outro referente à 5ª entrevista). Todos eles devem estar posicionados na mesma pasta para que o programa funcione adequadamente.
O Portal não disponibiliza os dados originais, que podem ser obtidos no site do IBGE.

{phang} {opt saving(str)} indica o caminho da pasta onde devem ser salvas as bases de dados produzidas pelo programa.

{marker examples}{...}
{title:Exemplos}

{phang}  OBS: Recomenda-se a execução do programa por meio da caixa de diálogo. Digite "db datazoom_pnadcont_anual" na janela 
de comando do STATA para iniciar.

{phang} Exemplo 1: Bases de dados anuais 

{phang} datazoom_pnadcont_anual, years(2012 2014 2015) original(C:/pnadc) saving(D:/mydatabases) 

{phang} Três bases de dados são geradas, uma para cada ano selecionado.

{title:Autor}
{p}

PUC-Rio - Departamento de Economia

Email {browse "mailto:datazoom@econ.puc-rio.br":datazoom@econ.puc-rio.br}

{title:Veja também}

Pacotes relacionados:

{help datazoom_censo} (se instalado)  
{help datazoom_pnad} (se instalado)  
{help datazoom_pnadcontinua} (se instalado)  
{help datazoom_pmeantiga} (se instalado)
{help datazoom_pmenova} (se instalado)  
{help datazoom_pof2017} (se instalado) 
{help datazoom_pof2008} (se instalado)  
{help datazoom_pof2002} (se instalado)  
{help datazoom_pof1995} (se instalado)  
{help datazoom_ecinf} (se instalado) 
{help datazoom_pns} (se instalado) 

{p} Digite "net from http://www.econ.puc-rio.br/datazoom/portugues" para instalar a versão em português desses pacotes. For the english version, type "net from http://www.econ.puc-rio.br/datazoom/english".
