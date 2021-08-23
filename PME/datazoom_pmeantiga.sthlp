{smcl}
{* *! version 1.0 22 May 2013}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "Install command2" "ssc install command2"}{...}
{vieweralsosee "Help command2 (if installed)" "help command2"}{...}
{viewerjumpto "Syntax" "datazoom_pmeantiga##syntax"}{...}
{viewerjumpto "Description" "datazoom_pmeantiga##description"}{...}
{viewerjumpto "Options" "datazoom_pmeantiga##options"}{...}
{viewerjumpto "Remarks" "datazoom_pmeantiga##remarks"}{...}
{viewerjumpto "Examples" "datazoom_pmeantiga##examples"}{...}
{title:Title}

{phang}
{bf:datazoom_pmeantiga} {hline 2} Acesso aos microdados da PME-Antiga Metodologia em formato STATA - Versão 1.2

{marker syntax}{...}
{title:Syntax}
{p 8 17 2}
{cmdab:datazoom_pmeantiga}
[{cmd:,}
{it:options}]

{p}	OBS: digite 'db datazoom_pmeantiga' para utilizar o programa via caixa de diálogo

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

{marker description}{...}
{title:Descrição}

{phang}
{cmd:datazoom_pmeantiga} extrai e contrói bases de dados da PME-Antiga Metodologia em formato STATA (.dta) a partir
dos microdados originais, os quais  não são disponibilizados pelo Portal (informações sobre como obter
os arquivos originais de dados, consulte o site do IBGE www.ibge.gov.br). O programa pode ser utilizado para
o período entre 1991 e 2001. 

{phang} Apesar de ser uma pesquisa mensal, este programa não permite a escolha de meses específicos para extração, 
mas somente os anos. As variáveis monetárias são deflacionadas para Dezembro de 2001.

{phang} Apesar de ser um painel de domicílios, os indivíduos podem não apresentar o mesmo número de ordem ao longo das 
entrevistas. Caso o usuário necessite trabalhar com um painel de indivíduos, é necessário construir uma variável que 
identifique o mesmo indívíduo ao longo das pesquisas. Para isso, são utilizados os algoritmos propostos por Ribas e Soares (2008). Os autores 
elaboram uma identificação básica e outra avançada, sendo diferenciadas pelo número de variáveis utilizadas para realizar
 a identificação do indivíduo em pesquisas distintas. A ideia dos algoritmos é verificar inconsistências no conjunto de 
 variáveis. Em qualquer dessas opções de identificação, a depender da capacidade 
 computacional utilizada, o programa pode consumir um tempo razoável para realizar a identificação, sendo recomendável
  não executar o programa para mais de quatro ou cinco anos conjuntamente. Por outro lado, caso não haja 
  interesse no painel de indivíduos (por exemplo, cálculo da taxa de desemprego mensal), existe a opção de não realizar a 
  identificação, vantajosa em termos de tempo de execução do programa.
  
{phang} Se a opção {opt nid} for escolhida, uma base de dados para cada ano selecionado será gerada. Ao utilizar as outras opções, 
 uma base de dados para cada painel da PME será o produto final. Um painel da PME é um conjunto de domicílios que ingressam 
e deixam o ciclo de entrevistas no mesmo mês, sendo identificados por letras maiúsculas. Se for o caso, utilize o 
comando {help append} para empilhar as bases.

{marker options}{...}
{title:Opções}
{dlgtab:Inputs}

{phang} 
{opt years(numlist)} especifica a lista de anos com os quais o usuário deseja trabalhar. Este programa 
pode ser utilizado para o período de 1991 a 2001. Não é possível 
escolher meses específicos.

{phang} {opt original(str)} indica o caminho da pasta onde estão localizados os arquivos de dados originais. 
Existe um arquivo de microdados para cada mês da pesquisa. Todos eles devem estar posicionados na mesma pasta 
para que o programa funcione adequadamente. O Portal não disponibiliza os dados originais, mas os mesmos podem ser
 obtidos no site do IBGE.

{phang} {opt saving(str)} indica o caminho da pasta onde devem ser salvas as bases de dados produzidas pelo programa.

{dlgtab:Identificação do Indivíduo}

{phang}
{opt nid}  solicita que o programa não crie uma variável que identifique o mesmo indivíduo ao longo das
 entrevistas. Esta opção é recomendável para o caso de não haver interesse em trabalhar com um painel de
  indivíduos, pois consome menos tempo para preparar as bases de dados em formato STATA.

{phang}
{opt idbas}  solicita que seja gerada uma variável que identifique unicamente o indivíduo ao longo das pesquias. 
Essa variável é criada após a verificação de inconsistência em um conjunto de variáveis. Veja Ribas and Soares 
(2008) para mais detalhes sobre o algoritmo.

{phang}
{opt idrs}  solicita a criação de uma variável de identificação dos indivíduos por meio da verificação de inconsistências 
utilizando um conjunto maior de variáveis que o algoritmo básico. Esta opção é time-consuming.


{marker examples}{...}
{title:Exemplos}

{phang}  OBS: Recomenda-se a execução do programa por meio da caixa de diálogo. Digite "db datazoom_pmeantiga" na janela 
de comando do STATA para iniciar.

{phang} Exemplo 1: sem identificação.

{phang} datazoom_pmenova, years(1991 1992 2000) original(C:/pmeant) saving(D:/mydatabases) nid

{phang} Três bases de dados são geradas, uma para cada ano selecionado, contendo as observações de todos os meses do ano.

{phang}

{phang} Exemplo 2: identificação avançada.

{phang} datazoom_pmenova, years(1999 2000) original(C:/pmeant) saving(D:/mydatabases) idbas

{phang} Será criada uma base para cada painel da PME pesquisado em 1999 e 2000. Em cada base haverá uma variável 
 que identifica unicamente os indivíduos. Haverá indivíduos com menos de oito entrevistas, seja porque o painel ao 
 qual pertence teve início antes de 1999, seja porque seu ciclo de entrevistas terminaria somente em 2000.

 
{title:Autor}
{p}

PUC-Rio - Departmento de Economia

Email {browse "mailto:datazoom@econ.puc-rio.br":datazoom@econ.puc-rio.br}


{title:Veja também}

Pacotes relacionados:

{help datazoom_censo} (se instalado)  
{help datazoom_pnad} (se instalado)  
{help datazoom_pmenova} (se instalado)  
{help datazoom_pof2008} (se instalado)  
{help datazoom_pof2002} (se instalado)  
{help datazoom_pof1995} (se instalado)  
{help datazoom_ecinf} (se instalado) 


{p} Digite "net from http://www.econ.puc-rio.br/datazoom/portugues" para instalar a versão em português desses pacotes. 
For the english version, type "net from http://www.econ.puc-rio.br/datazoom/english".

{title:Referência} 

{pstd} Ribas, R. P. and Soares, S. S. D. (2008). Sobre o painel da Pesquisa Mensal de Emprego (PME) 
do IBGE. Brasília: IPEA (Texto para Discussão – 1348).
