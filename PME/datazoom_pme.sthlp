{smcl}
{viewerdialog "PME" "dialog datazoom_pme"}
{viewerdialog "Pacote" "dialog datazoom_social"}
{vieweralsosee "PNAD" "help datazoom_pnad"}{...}
{vieweralsosee "Censo" "help datazoom_censo"}{...}
{vieweralsosee "PNAD Contínua" "help datazoom_pnad_continua"}{...}
{vieweralsosee "PNAD Covid" "help datazoom_pnad_covid"}{...}
{vieweralsosee "PNS" "help datazoom_pns"}{...}
{vieweralsosee "POF" "help datazoom_pof"}{...}
{vieweralsosee "ECINF" "help datazoom_ecinf"}{...}
{viewerjumpto "Syntax" "datazoom_pns##syntax"}{...}
{viewerjumpto "Description" "datazoom_pns##description"}{...}
{viewerjumpto "Options" "datazoom_pns##options"}{...}
{viewerjumpto "Examples" "datazoom_pns##examples"}{...}
{p 8 8 2} {it:For the English version}, {help datazoom_pme_en}

{title:Title}

{p 4 4 2}
{bf:datazoom_pmeantiga} e {bf:datazoom_pmenova} {hline 2} Acesso aos microdados da PME

{marker syntax}
{title:Syntax}

{p 8 8 2} {bf:datazoom_pme}(antiga/nova) [, {it:options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Inputs}
{synopt:{opt years(numlist)}} anos da PME {p_end}
{synopt:{opt original(str)}} caminho da pasta onde se localizam os arquivos de dados originais {p_end}
{synopt:{opt saving(str)}} caminho da pasta onde serão salvas as novas bases de dados {p_end}

{syntab:Identificação do Indivíduo}
{synopt:{opt nid}} Sem identificação {p_end}
{synopt:{opt idbas}} Identificação básica {p_end}
{synopt:{opt idrs}} Avançada (Ribas-Soares) {p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}

Digite {bf:db datazoom_pme} para utilizar a função via caixa de diálogo.

{marker description}{...}

{title:Description}

{p 4 4 2}
{cmd:datazoom_pmeantiga} e {cmd:datazoom_pmenova} extraem e constroem bases a partir dos microdados originais da PME --- respectivamente para a metodologia Antiga e Nova.
Ambas funcionam da mesma forma, apenas reajustadas para os diferentes formatos dos microdados. 

A função {bf: datazoom_pmeantiga} abrange o período de 1991 a 2001, enquanto a {bf:datazoom_pmenova} abrange os anos de 2002 a 2016.

Apesar de ser uma pesquisa mensal, este programa não permite a escolha de meses específicos para extração, 
mas somente os anos. Os dados da PME antiga são deflacionados para dezembro de 2001, enquanto os da nova
para janeiro de 2016.

Apesar de ser um painel de domicílios, os indivíduos podem não apresentar o mesmo número de ordem ao longo das 
entrevistas. Caso o usuário necessite trabalhar com um painel de indivíduos, é necessário construir uma variável que 
identifique o mesmo indívíduo ao longo das pesquisas. Para isso, são utilizados os algoritmos propostos por Ribas e Soares (2008). Os autores 
elaboram uma identificação básica e outra avançada, sendo diferenciadas pelo número de variáveis utilizadas para realizar
a identificação do indivíduo em pesquisas distintas. A ideia dos algoritmos é verificar inconsistências no conjunto de 
variáveis. Em qualquer dessas opções de identificação, a depender da capacidade 
computacional utilizada, o programa pode consumir um tempo razoável para realizar a identificação, sendo recomendável
não executar o programa para mais de quatro ou cinco anos conjuntamente. Por outro lado, caso não haja 
interesse no painel de indivíduos (por exemplo, cálculo da taxa de desemprego mensal), existe a opção de não realizar a 
identificação, vantajosa em termos de tempo de execução do programa.

Se a opção {opt nid} for escolhida, uma base de dados para cada ano selecionado será gerada. Ao utilizar as outras opções, 
uma base de dados para cada painel da PME será o produto final. Um painel da PME é um conjunto de domicílios que ingressam 
e deixam o ciclo de entrevistas no mesmo mês, sendo identificados por letras maiúsculas. Se for o caso, utilize o 
comando {help append} para empilhar as bases.
  
{marker options}{...}
{title:Options}
{dlgtab:Inputs}

{phang} 
{opt years(numlist)} especifica a lista de anos com os quais o usuário deseja trabalhar. Podem ser de 1991 a 2001
para a {cmd:datazoom_pmeantiga} e de 2002 a 2016 para a {cmd:datazoom_pmenova}.

{phang} {opt original(str)} indica o caminho da pasta onde estão localizados os arquivos de dados originais. 
Existe um arquivo de microdados para cada mês da pesquisa. Todos eles devem estar posicionados na mesma pasta 
para que o programa funcione adequadamente. Os dados originais podem ser obtidos no site do IBGE.

{phang} {opt saving(str)} indica o caminho da pasta onde devem ser salvas as bases de dados produzidas pelo programa.

{dlgtab:Identificação do Indivíduo}

{phang}
{opt nid}  solicita que o programa não crie uma variável que identifique o mesmo indivíduo ao longo das
 entrevistas. Esta opção é recomendável para o caso de não haver interesse em trabalhar com um painel de
  indivíduos, pois consome menos tempo para preparar as bases de dados em formato Stata.

{phang}
{opt idbas}  solicita que seja gerada uma variável que identifique unicamente o indivíduo ao longo das pesquias. 
Essa variável é criada após a verificação de inconsistência em um conjunto de variáveis. Veja Ribas and Soares 
(2008) para mais detalhes sobre o algoritmo.

{phang}
{opt idrs}  solicita a criação de uma variável de identificação dos indivíduos por meio da verificação de inconsistências 
utilizando um conjunto maior de variáveis que o algoritmo básico. Esta opção é time-consuming.

{marker examples}{...} 
{title:Examples}

{p 4 4 2}
Sem identificação:

		. datazoom_pmeantiga, years(1991 1992) original("~/mydir") saving("~/mydir") nid

{p 6 6 2}
Três bases de dados são geradas, uma para cada ano selecionado. Cada base conterá as observações de todos os meses 
para os quais existem arquivos originais na pasta indicada.
	
{p 4 4 2}	
    Identificação avançada:

        . datazoom_pmenova, years(2005 2006) original("~/mydir") saving("~/mydir") idbas

{p 6 6 2}		
		Será criada uma base para cada painel da PME pesquisado em 2005 e 2006. Em cada base haverá uma variável 
 que identifica unicamente os indivíduos ao longo das pesquiasas. Haverá indivíduos com menos de oito entrevistas, seja porque o painel ao 
 qual pertence teve início antes de 2005, seja porque seu ciclo de entrevistas terminaria somente em 2007.

{title:Author}

{p 4 4 2}
DataZoom     {break}
PUC-Rio - Departamento de Economia      {break}
Contato pelo  {browse "https://github.com/datazoompuc/datazoom_social_Stata":Github}      {break}

{space 4}{hline}

