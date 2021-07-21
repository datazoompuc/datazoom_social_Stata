{smcl}
{* *! version 1.0 08th April 2020}{...}
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
{bf:datazoom_pnadcontinua} {hline 2} Acesso aos microdados da PNAD Contínua em formato STATA - Versão 1.0

{marker syntax}{...}
{title:Syntax}
{p 8 17 2}
{cmdab:datazoom_pnadcontinua}
[{cmd:,}
{it:options}]

{p}	OBS: digite 'db datazoom_pnadcontinua' para utilizar o programa via caixa de diálogo
	
{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Inputs}
{synopt:{opt years(numlist)}} anos da PNAD Contínua {p_end}
{synopt:{opt original(str)}} caminho da pasta onde se localizam os arquivos de dados originais {p_end}
{synopt:{opt saving(str)}} caminho da pasta onde serão salvas as novas bases de dados {p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}

{syntab:Identificação do Indivíduo}
{synopt:{opt nid}} Sem identificação {p_end}
{synopt:{opt idbas}} Identificação básica {p_end}
{synopt:{opt idrs}} Avançada {p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}

{marker description}{...}
{title:Descrição}

{phang}
{cmd:datazoom_pnadcontinua} extrai e constrói bases de dados da PNAD Contínua em formato STATA (.dta) a partir
dos microdados originais, os quais  não são disponibilizados pelo Portal (informações sobre como obter
os arquivos originais de dados, consulte o site do IBGE www.ibge.gov.br). O programa pode ser utilizado para
os anos 2012 a 2020. 

{phang} Embora seja uma pesquisa trimestral, este programa não permite a escolha de trimestres específicos para extração, 
somente anos. O pacote gera uma base única para o ano, com os trimestres empilhados. Como a pesquisa ainda é publicada pelo
IBGE, este programa está em constante atualização.
  
{phang} A Pnad Contínua Trimestral é uma pesquisa em painel, na qual cada domicílio é entrevistado cinco vezes, durante cinco trimestres 
consecutivos. Apesar de identificar corretamente o mesmo domicílio nas cinco entrevistas, a Pnad Contínua não atribui o 
mesmo número de identificação a cada membro do domicílio em todas as entrevistas. Caso o usuário necessite trabalhar com um painel
de indivíduos, é necessário construir uma variável que identifique o mesmo indivíduo ao longo das pesquisas. 
Para isso, são utilizados os algoritmos propostos por Ribas e Soares (2008). Os autores elaboram uma identificação básica e outra
avançada, sendo diferenciadas pelo número de variáveis utilizadas para realizar a identificação do indivíduo em pesquisas distintas.
A ideia dos algoritmos é verificar inconsistências no conjunto de variáveis. Em qualquer dessas opções de identificação, a depender
da capacidade computacional utilizada, o programa pode consumir um tempo razoável para realizar a identificação.

{phang} Se a opção {opt nid} for escolhida, uma base de dados para cada ano selecionado será gerada. Ao utilizar as outras opçãos 
(identificadas), é necessário selecionar todos os ano. As base de dados para cada painel da PNAD Contínua será o produto final.
Um painel da PNAD é um conjunto de domicílios que ingressam e deixam o ciclo de entrevistas no mesmo trimestre. Se for o caso,
utilize o comando {help append} para empilhar as bases.


{marker options}{...}
{title:Opções}
{dlgtab:Inputs}

{phang} 
{opt years(numlist)} especifica a lista de anos com os quais o usuário deseja trabalhar. Este programa 
pode ser utilizado para o período de 2012 a 2020. Não é possível escolher trimestres específicos.

{phang} {opt original(str)} indica o caminho da pasta onde estão localizados os arquivos de dados originais. 
Existe um arquivo de microdados para cada trimestre da pesquisa. Todos eles devem estar posicionados na mesma pasta 
para que o programa funcione adequadamente. O Portal não disponibiliza os dados originais, que podem ser
 obtidos no site do IBGE.

{phang} {opt saving(str)} indica o caminho da pasta onde devem ser salvas as bases de dados produzidas pelo programa.

{marker examples}{...}
{title:Exemplos}

{phang}  OBS: Recomenda-se a execuçãoo do programa por meio da caixa de diálogo. Digite "db datazoom_pnadcontinua" na janela 
de comando do STATA para iniciar.

{phang} Exemplo 1: Bases de dados trimestrais 

{phang} datazoom_pnadcontinua, years(2012 2013 2014) original(C:/pnadc) saving(D:/mydatabases) 

{phang} Três bases de dados são geradas, uma para cada ano selecionado.

{title:Autor}
{p}

PUC-Rio - Departmento de Economia

Email {browse "mailto:datazoom@econ.puc-rio.br":datazoom@econ.puc-rio.br}

{title:Veja também}

Pacotes relacionados:

{help datazoom_censo} (se instalado)  
{help datazoom_pnad} (se instalado)  
{help datazoom_pmeantiga} (se instalado)
{help datazoom_pmenova} (se instalado)  
{help datazoom_pof2017} (se instalado)
{help datazoom_pof2008} (se instalado)  
{help datazoom_pof2002} (se instalado)  
{help datazoom_pof1995} (se instalado)  
{help datazoom_ecinf} (se instalado) 
{help datazoom_pns} (se instalado) 


{p} Digite "net from http://www.econ.puc-rio.br/datazoom/portugues" para instalar a versão em português desses pacotes. 
For the english version, type "net from http://www.econ.puc-rio.br/datazoom/english".
