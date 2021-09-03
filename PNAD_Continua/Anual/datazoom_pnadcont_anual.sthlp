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
{synopt:{opt years(numlist)}} anos da PNAD Contínua Anual {p_end}
{synopt:{opt original(str)}} caminho da pasta onde se localizam os arquivos de dados originais {p_end}
{synopt:{opt saving(str)}} caminho da pasta onde serão salvas as novas bases de dados {p_end}
{synopt:{opt english}} labels das variáveis em inglês {p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}

Digite {cmd:db datazoom_pnadcont_anual} para utilizar a função via caixa de diálogo.

{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:datazoom_pnadcont_anual} extrai e constrói bases de dados da PNAD Contínua Anual em formato Stata a partir
dos microdados originais do IBGE, para os anos de 2012 a 2019. 

{p 4 4 2}
Apesar da periodicidade de divulgação da pesquisa ser anual, este programa permite, a partir de 2016, a escolha de duas entrevistas específicas para extração: (2016_entr1 e 2017_entr1)
referentes à 1ªentrevista do domicílio e (2016_entr5 e 2017_entr5) referentes à 5ª entrevista do domicílio. Isso se deve à mudança na pesquisa do IBGE
com a transferência da investigação "Outras formas de trabalho" para a 5ª entrevista do domicílio nos anos de 2016 e 2017. Para cada entrevista, 
há uma base original em txt disponível no site do IBGE. Para maiores informações sobre a mudança da entrevista, olhar nota técnica da pesquisa no site do IBGE.

{p 4 4 2}
Como a pesquisa ainda é publicada pelo IBGE, este programa está em constante atualização.
  
{p 4 4 2}
O programa gera uma base para cada ano selecionado. Se for o caso, utilize o 
comando {help append} para empilhar as bases.

{marker options}{...}
{title:Options}
{dlgtab:Input}

{phang} 
{opt years(numlist)} especifica a lista de anos com os quais o usuário deseja trabalhar. Este programa 
pode ser utilizado para o período de 2012 a 2019. 

{phang} {opt original(str)} indica o caminho da pasta onde estão localizados os arquivos de dados originais. 
Existe um arquivo de microdados para cada ano da pesquisa, exceto para 2016 e 2017, nos quais há dois microdados por ano (um microdado referente à 1ª 
entrevista e outro referente à 5ª entrevista). Todos eles devem estar posicionados na mesma pasta para que o programa funcione adequadamente.
O Portal não disponibiliza os dados originais, que podem ser obtidos no site do IBGE.

{phang} {opt saving(str)} indica o caminho da pasta onde devem ser salvas as bases de dados produzidas pelo programa.

{marker examples}{...}
{title:Examples}

{p 4 4 2}
Bases de dados anuais 

{p 8 6 2}. datazoom_pnadcont_anual, years(2012 2014 2015) original("~/mydir") saving("~/mydir") 

{p 6 6 2}
Três bases de dados são geradas, uma para cada ano selecionado.

{title:Author}

{p 4 4 2}
DataZoom     {break}
PUC-Rio - Departamento de Economia      {break}
Contato pelo  {browse "https://github.com/datazoompuc/datazoom_social_Stata":Github}      {break}

{space 4}{hline}
