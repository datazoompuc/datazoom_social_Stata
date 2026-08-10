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
{cmd:datazoom_pnadcontinua} {hline 2} Acesso aos microdados da PNAD Contínua {c -}  Divulgação Trimestral

{marker syntax}{...}
{title:Syntax}

{p 8 8 2} {cmd:datazoom_pnadcontinua} [, {it:options}]
	
{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Input}
{synopt:{opt years(numlist)}} anos da PNAD Contínua {p_end}
{synopt:{opt original(str)}} caminho da pasta onde se localizam os arquivos de dados originais {p_end}
{synopt:{opt saving(str)}} caminho da pasta onde serão salvas as novas bases de dados {p_end}
{synopt:{opt english}} labels das variáveis em inglês {p_end}

{syntab:Identificação do Indivíduo (é necessário escolher uma das opções abaixo)}
{synopt:{opt nid}} Sem identificação {p_end}
{synopt:{opt idbas}} Identificação básica {p_end}
{synopt:{opt idrs}} Avançada (Ribas-Soares) {p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}

Digite {cmd:db datazoom_pnadcontinua} para utilizar a função via caixa de diálogo.

{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:datazoom_pnadcontinua} extrai e gera bases de dados da PNAD Contínua em formato Stata a partir 
dos microdados originais do IBGE, que devem ser previamente baixados. Atualmente programa pode ser utilizado para os anos de 2012 a 2025. 

{p 4 4 2}
Embora seja uma pesquisa trimestral, este programa não permite a escolha de trimestres específicos para extração, 
somente anos. O pacote gera uma base única para o ano, com os trimestres empilhados. Como a pesquisa ainda é publicada pelo
IBGE, este programa está em constante atualização.
  
{p 4 4 2}
A PNAD Contínua Trimestral é uma pesquisa em painel, na qual cada domicílio é entrevistado cinco vezes, durante cinco trimestres 
consecutivos. Apesar de identificar corretamente o mesmo domicílio nas cinco entrevistas, a PNAD Contínua não atribui o 
mesmo número de identificação a cada membro do domicílio em todas as entrevistas. Caso o usuário necessite trabalhar com um painel
de indivíduos, é necessário construir uma variável que identifique o mesmo indivíduo ao longo das pesquisas. 
Para isso, são utilizados os algoritmos propostos por Ribas e Soares (2008). Os autores elaboram uma identificação básica e outra
avançada, sendo diferenciadas pelo número de variáveis utilizadas para realizar a identificação do indivíduo em pesquisas distintas.
A ideia dos algoritmos é verificar inconsistências no conjunto de variáveis. Em qualquer dessas opções de identificação, a depender
da capacidade computacional utilizada, o programa pode consumir um tempo razoável para realizar a identificação.

{p 4 4 2}
Se a opção {opt nid} (sem identificação) for escolhida, uma base de dados para cada ano selecionado será gerada. Ao utilizar as outras opções 
(identificadas), é necessário selecionar todos os anos que compõem o painel de interesse. As base de dados para cada painel da PNAD Contínua que tem parte nos anos selecionados será o produto final. Um painel da PNAD é um conjunto de domicílios que ingressam e deixam o ciclo de entrevistas no mesmo trimestre. Se for o caso,
utilize o comando {help append} para empilhar as bases.


{marker options}{...}
{title:Options}
{dlgtab:Input}

{phang} 
{opt years(numlist)} especifica a lista de anos com os quais o usuário deseja trabalhar. Este programa atualmente
pode ser utilizado para o período de 2012 a 2025. Não é possível escolher trimestres específicos.

{phang} {opt original(str)} indica o caminho da pasta onde estão localizados os arquivos de dados originais. 
Existe um arquivo de microdados para cada trimestre da pesquisa. Todos eles devem estar posicionados na mesma pasta 
para que o programa funcione adequadamente.

{phang} {opt saving(str)} indica o caminho da pasta onde devem ser salvas as bases de dados produzidas pelo programa.

{phang} {opt nid} Sem identificação / {opt idbas} Identificação básica / {opt idrs} Avançada (Ribas-Soares)

{phang} {opt english} gera labels das variáveis em inglês (opcional)


{marker examples}{...}
{title:Examples}

{p 4 4 2}
Bases de dados trimestrais 

{p 8 6 2}datazoom_pnadcontinua, years(2012 2013 2014) original("~/mydata") saving("~/mydata") nid english

{p 6 6 2}
Três bases de dados são geradas, uma para cada ano selecionado, sem identificação de indivíduos ao longo dos painéis e com labels das variáveis em inglês.

{title:Author}

{p 4 4 2}
DataZoom     {break}
PUC-Rio - Departamento de Economia      {break}
Contato pelo  {browse "https://github.com/datazoompuc/datazoom_social_Stata":Github}      {break}

{space 4}{hline}
