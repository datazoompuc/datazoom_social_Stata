{smcl}
{viewerdialog "PNAD Contínua Anual" "dialog datazoom_pnadcont_anual"}
{viewerdialog "Pacote" "dialog datazoom_social"}
{vieweralsosee "PNAD" "help datazoom_pnad"}{...}
{vieweralsosee "Censo" "help datazoom_censo"}{...}
{vieweralsosee "PNAD Contínua Trimestral" "help datazoom_pnadcontinua"}{...}
{vieweralsosee "PNS" "help datazoom_pns"}{...}
{vieweralsosee "PNAD Covid" "help datazoom_pnad_covid"}{...}
{vieweralsosee "PME" "help datazoom_pme"}{...}
{vieweralsosee "POF" "help datazoom_pof"}{...}
{vieweralsosee "ECINF" "help datazoom_ecinf"}{...}
{viewerjumpto "Syntax" "datazoom_pnadcont_anual##syntax"}{...}
{viewerjumpto "Description" "datazoom_pnadcont_anual##description"}{...}
{viewerjumpto "Options" "datazoom_pnadcont_anual##options"}{...}
{viewerjumpto "Examples" "datazoom_pnadcont_anual##examples"}{...}
{p 8 8 2} {it:For the English version}, {help datazoom_pnadcont_anual_en}

{title:Title}

{p 4 4 2}
{cmd:datazoom_pnadcont_anual} {hline 2} Acesso aos microdados da PNAD Contínua {c -}  Divulgação Anual

{marker syntax}{...}
{title:Syntax}

{p 8 8 2} {cmd:datazoom_pnadcont_anual} [, {it:options}]
	
{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Input}
{synopt:{opt years(numlist)}} anos seguidos por visitas ou trimestres da PNAD Contínua Anual {p_end}
{synopt:{opt original(str)}} caminho da pasta onde se localizam os arquivos de dados originais {p_end}
{synopt:{opt saving(str)}} caminho da pasta onde serão salvas as novas bases de dados {p_end}
{synopt:{opt english}} define que labels das variáveis sejam apresentados em inglês {p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}

Digite {cmd:db datazoom_pnadcont_anual} para utilizar a função via caixa de diálogo.

{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:datazoom_pnadcont_anual} extrai e constrói bases de dados da PNAD Contínua Anual em formato Stata a partir
dos microdados originais do IBGE, para os anos de 2012 a 2024.

{p 4 4 2}
Este programa permite, para cada ano, a escolha de entrevistas (visitas) e trimestres específicos para extração. Ex: years(2016_vis1 2017_tri2) são
referentes às 1ªentrevistas (acumuladas) do domicílio em 2016 e ao 2°trimestre de 2017. Os dados da PNAD Contínua Anual são especialmente úteis para analisar
os suplementos da PNAD Contínua, em que o IBGE faz perguntas adicionais de temas específicos em trimestres e visitas específicas em determinados anos.
Para ver em quais períodos estão cada suplemento, consulte o Guia de Suplementos. Você pode gerar um link de download usando nossa dialog box,
ou pode pesquisar diretamente no site do IBGE.
Para maiores informações sobre os dados de visitas acumuladas, trimestres e suplementos, olhar nota técnica da pesquisa no site do IBGE.
Para cada visita e cada trimestre, há uma base original em txt disponível no site do IBGE. Faça o download dos dados originais e coloque o caminho dessa pasta como parâmetro de "original" para usar corretamente a função.


{p 4 4 2}
Como a pesquisa ainda é publicada pelo IBGE, este programa está em constante atualização.
  
{p 4 4 2}
O programa gera uma base para cada período (ano_visita e/ou ano_trimestre) selecionado. Pode ser útil utilizar o comando {help append} para empilhar as bases, caso sejam compatíveis.

{marker options}{...}
{title:Options}
{dlgtab:Input}

{phang} 
{opt years(numlist)} especifica a lista de anos, com suas visitas e/ou trimestres com os quais o usuário deseja trabalhar. Este programa 
pode ser utilizado para o período de 2012 a 2024, com visitas e trimestres específicos. Não há arquivos de microdados na disseminação anual para todo trimestre ou visita.
Portanto, é necessário verificar quais trimestres e visitas estão disponível para chamar corretamente a função.

{phang} {opt original(str)} indica o caminho da pasta onde estão localizados os arquivos de dados originais. 
Existem arquivos de microdados para cada ano da pesquisa, podendo haver um ou mais por ano, referentes às visitas acumuladas e aos trimestres. 
Todos eles devem estar na mesma pasta para que o programa funcione adequadamente.
O Portal não disponibiliza os dados originais, que podem ser obtidos no site do IBGE.

{phang} {opt saving(str)} indica o caminho da pasta onde devem ser salvas as bases de dados produzidas pelo programa.

{phang} {opt english} especifica que os rótulos das variáveis sejam apresentados em inglês. O padrão é português (Brasil).

{marker examples}{...}
{title:Examples}

{p 4 4 2}
Bases de dados anuais

{p 8 6 2}. datazoom_pnadcont_anual, years(2012_vis1 2014_vis1 2024_tri4) original("~/mydir") saving("~/mydir") 

{p 6 6 2}
Três bases de dados são geradas, uma para cada visita e trimestre selecionado.

{title:Author}

{p 4 4 2}
DataZoom     {break}
PUC-Rio - Departamento de Economia      {break}
Contato pelo  {browse "https://github.com/datazoompuc/datazoom_social_Stata":Github}      {break}

{space 4}{hline}
