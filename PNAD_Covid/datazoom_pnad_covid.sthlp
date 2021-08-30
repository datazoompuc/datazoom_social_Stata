{smcl}
{viewerdialog "PNAD Covid" "dialog datazoom_pnad_covid"}
{viewerdialog "Pacote" "dialog datazoom_social"}
{vieweralsosee "PNAD" "help datazoom_pnad"}{...}
{vieweralsosee "Censo" "help datazoom_censo"}{...}
{vieweralsosee "PNAD Contínua Anual" "help datazoom_pnadcont_anual"}{...}
{vieweralsosee "PNS" "help datazoom_pns"}{...}
{vieweralsosee "PNAD Contínua Trimestral" "help datazoom_pnadcontinua"}{...}
{vieweralsosee "PME" "help datazoom_pme"}{...}
{vieweralsosee "POF" "help datazoom_pof"}{...}
{vieweralsosee "ECINF" "help datazoom_ecinf"}{...}
{viewerjumpto "Syntax" "datazoom_pnad_covid##syntax"}{...}
{viewerjumpto "Description" "datazoom_pnad_covid##description"}{...}
{viewerjumpto "Options" "datazoom_pnad_covid##options"}{...}
{viewerjumpto "Examples" "datazoom_pnad_covid##examples"}{...}
{p 8 8 2} {it:For the English version}, {help datazoom_pnad_covid_en}

{title:Title}

{p 4 4 2}
{cmd:datazoom_pnad_covid} {hline 2} Acesso aos microdados da PNAD Covid

{marker syntax}{...}
{title:Syntax}

{p 8 8 2} {cmd:datazoom_pnad_covid} [, {it:options}]
	
{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Inputs}
{synopt:{opt month(numlist)}} meses da PNAD COVID19 {p_end}
{synopt:{opt original(str)}} caminho da pasta onde se localizam os arquivos de dados originais {p_end}
{synopt:{opt saving(str)}} caminho da pasta onde serão salvas as novas bases de dados {p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}

Digite {cmd:db datazoom_pnad_covid} para utilizar a função via caixa de diálogo.

{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:datazoom_pnad_covid} extrai e constrói bases de dados da PNAD COVID19 em formato Stata a partir
dos microdados originais do IBGE. Os dados abrangem vários meses do ano de 2020.
  
{p 4 4 2}
O programa gera uma base para cada mês. Se for o caso, utilize o 
comando {help append} para empilhar as bases.


{marker options}{...}
{title:Options}
{dlgtab:Inputs}

{phang} 
{opt month(numlist)} especifica a lista de meses com os quais o usuário deseja trabalhar. 


{phang} {opt original(str)} indica o caminho da pasta onde estão localizados os arquivos de dados originais. 
Existe um arquivo de microdados para cada mês da pesquisa. Todos eles devem estar posicionados na mesma pasta para que o programa funcione adequadamente. O Portal não disponibiliza os dados originais, que podem ser
 obtidos no site do IBGE.

{phang} {opt saving(str)} indica o caminho da pasta onde devem ser salvas as bases de dados produzidas pelo programa.

{marker examples}{...}
{title:Examples}

{p 4 4 2}
Lendo os dados de Junho e Julho de 2020

{p 8 6 2}. datazoom_pnad_covid, month(06 07) original("~/mydir") saving("~/mydir")

{p 6 6 2}
Gera duas bases em formato .dta, uma para cada mês.

{title:Author}

{p 4 4 2}
DataZoom     {break}
PUC-Rio - Departamento de Economia      {break}
Contato pelo  {browse "https://github.com/datazoompuc/datazoom_social_Stata":Github}      {break}

{space 4}{hline}
