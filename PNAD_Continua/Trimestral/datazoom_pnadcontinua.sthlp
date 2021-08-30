{smcl}
{viewerdialog "PNAD Contínua Trimestral" "dialog datazoom_pnadcontinua"}
{viewerdialog "Pacote" "dialog datazoom_social"}
{vieweralsosee "PNAD" "help datazoom_pnad"}{...}
{vieweralsosee "Censo" "help datazoom_censo"}{...}
{vieweralsosee "PNAD Contínua Anual" "help datazoom_pnadcont_anual"}{...}
{vieweralsosee "PNS" "help datazoom_pns"}{...}
{vieweralsosee "PNAD Covid" "help datazoom_pnad_covid"}{...}
{vieweralsosee "PME" "help datazoom_pme"}{...}
{vieweralsosee "POF" "help datazoom_pof"}{...}
{vieweralsosee "ECINF" "help datazoom_ecinf"}{...}
{viewerjumpto "Syntax" "datazoom_pnadcontinua##syntax"}{...}
{viewerjumpto "Description" "datazoom_pnadcontinua##description"}{...}
{viewerjumpto "Options" "datazoom_pnadcontinua##options"}{...}
{viewerjumpto "Examples" "datazoom_pnadcontinua##examples"}{...}
{p 8 8 2} {it:For the English version}, {help datazoom_pnadcontinua_en}

{title:Title}

{p 4 4 2}
{cmd:datazoom_pnadcont_anual} {hline 2} Acesso aos microdados da PNAD Contínua {c -}  Divulgação Trimestral

{marker syntax}{...}
{title:Syntax}

{p 8 8 2} {cmd:datazoom_pnadcontinua} [, {it:options}]
	
{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Inputs}
{synopt:{opt years(numlist)}} anos da PNAD Contínua {p_end}
{synopt:{opt original(str)}} caminho da pasta onde se localizam os arquivos de dados originais {p_end}
{synopt:{opt saving(str)}} caminho da pasta onde serão salvas as novas bases de dados {p_end}

{syntab:Identificação do Indivíduo}
{synopt:{opt nid}} Sem identificação {p_end}
{synopt:{opt idbas}} Identificação básica {p_end}
{synopt:{opt idrs}} Avançada {p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}

Digite {cmd:db datazoom_pnadcontinua} para utilizar a função via caixa de diálogo.

{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:datazoom_pnadcontinua} extrai e constrói bases de dados da PNAD Contínua em formato STATA (.dta) a partir
dos microdados originais, os quais  não são disponibilizados pelo Portal (informações sobre como obter
os arquivos originais de dados, consulte o site do IBGE www.ibge.gov.br). O programa pode ser utilizado para
os anos 2012 a 2020. 

{p 4 4 2}
Embora seja uma pesquisa trimestral, este programa não permite a escolha de trimestres específicos para extração, 
somente anos. O pacote gera uma base única para o ano, com os trimestres empilhados. Como a pesquisa ainda é publicada pelo
IBGE, este programa está em constante atualização.
  
{p 4 4 2}
A Pnad Contínua Trimestral é uma pesquisa em painel, na qual cada domicílio é entrevistado cinco vezes, durante cinco trimestres 
consecutivos. Apesar de identificar corretamente o mesmo domicílio nas cinco entrevistas, a Pnad Contínua não atribui o 
mesmo número de identificação a cada membro do domicílio em todas as entrevistas. Caso o usuário necessite trabalhar com um painel
de indivíduos, é necessário construir uma variável que identifique o mesmo indivíduo ao longo das pesquisas. 
Para isso, são utilizados os algoritmos propostos por Ribas e Soares (2008). Os autores elaboram uma identificação básica e outra
avançada, sendo diferenciadas pelo número de variáveis utilizadas para realizar a identificação do indivíduo em pesquisas distintas.
A ideia dos algoritmos é verificar inconsistências no conjunto de variáveis. Em qualquer dessas opções de identificação, a depender
da capacidade computacional utilizada, o programa pode consumir um tempo razoável para realizar a identificação.

{p 4 4 2}
Se a opção {opt nid} for escolhida, uma base de dados para cada ano selecionado será gerada. Ao utilizar as outras opçãos 
(identificadas), é necessário selecionar todos os ano. As base de dados para cada painel da PNAD Contínua será o produto final.
Um painel da PNAD é um conjunto de domicílios que ingressam e deixam o ciclo de entrevistas no mesmo trimestre. Se for o caso,
utilize o comando {help append} para empilhar as bases.


{marker options}{...}
{title:Options}
{dlgtab:Input}

{phang} 
{opt years(numlist)} especifica a lista de anos com os quais o usuário deseja trabalhar. Este programa 
pode ser utilizado para o período de 2012 a 2020. Não é possível escolher trimestres específicos.

{phang} {opt original(str)} indica o caminho da pasta onde estão localizados os arquivos de dados originais. 
Existe um arquivo de microdados para cada trimestre da pesquisa. Todos eles devem estar posicionados na mesma pasta 
para que o programa funcione adequadamente. O Portal não disponibiliza os dados originais, que podem ser
 obtidos no site do IBGE.

{phang} {opt saving(str)} indica o caminho da pasta onde devem ser salvas as bases de dados produzidas pelo programa.

{marker examples}{...}
{title:Examples}

{p 4 4 2}
Bases de dados trimestrais 

{p 8 6 2}datazoom_pnadcontinua, years(2012 2013 2014) original(C:/pnadc) saving(D:/mydatabases) 

{p 6 6 2}
Três bases de dados são geradas, uma para cada ano selecionado.

{title:Author}

{p 4 4 2}
DataZoom     {break}
PUC-Rio - Departamento de Economia      {break}
Contato pelo  {browse "https://github.com/datazoompuc/datazoom_social_Stata":Github}      {break}

{space 4}{hline}
