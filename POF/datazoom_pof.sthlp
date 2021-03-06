{smcl}
{viewerdialog "POF" "dialog datazoom_pof"}
{viewerdialog "Pacote" "dialog datazoom_social"}
{vieweralsosee "PNAD" "help datazoom_pnad"}{...}
{vieweralsosee "Censo" "help datazoom_censo"}{...}
{vieweralsosee "PNAD Contínua Anual" "help datazoom_pnadcont_anual"}{...}
{vieweralsosee "PNS" "help datazoom_pns"}{...}
{vieweralsosee "PNAD Contínua Trimestral" "help datazoom_pnadcontinua"}{...}
{vieweralsosee "PME" "help datazoom_pme"}{...}
{vieweralsosee "PNAD Covid" "help datazoom_pnad_covid"}{...}
{vieweralsosee "ECINF" "help datazoom_ecinf"}{...}
{viewerjumpto "Syntax" "datazoom_pof##syntax"}{...}
{viewerjumpto "Description" "datazoom_pof##description"}{...}
{viewerjumpto "Options" "datazoom_pof##options"}{...}
{viewerjumpto "Sobre a POF" "datazoom_pof##remarks"}{...}
{viewerjumpto "Examples" "datazoom_pof##examples"}{...}
{p 8 8 2} {it:For the English version}, {help datazoom_pof_en}

{title:Title}

{p 4 4 2}
{cmd:datazoom_pof} {hline 2} Acesso aos microdados da POF

{marker syntax}{...}
{title:Syntax}

{p 8 8 2} {cmd:datazoom_pof1995} [, {it:options} {it:trs_options} {it:sel_options} {it:std_options}]

{p 8 8 2} {cmd:datazoom_pof2002} [, {it:options} {it:trs_options} {it:sel_options} {it:std_options}]

{p 8 8 2} {cmd:datazoom_pof2008} [, {it:options} {it:trs_options} {it:sel_options} {it:std_options}]

{p 8 8 2} {cmd:datazoom_pof2017} [, {it:options} {it:trs_options} {it:sel_options} {it:std_options}]

{synoptset 20 tabbed}{...}
{synopthdr: options}
{synoptline}
{syntab:Input}
{synopt:{opt original(string)}} caminho da pasta onde se localizam os arquivos de dados originais {p_end}
{synopt:{opt saving(string)}} caminho da pasta onde serão salvas as novas bases de dados {p_end}
{synopt:{opt english}} labels das variáveis em inglês {p_end}
{p2colreset}{...}

{synoptset 20 tabbed}{...}
{synopthdr: trs_options}
{synoptline}
{syntab:Tipos de Registro}
{synopt:{opt trs(string)}} tipos de registro {p_end}
{synoptline}
{p2colreset}{...}

{synoptset 20 tabbed}{...}
{synopthdr: sel_options}
{synoptline}
{syntab:Gastos Selecionados}
{synopt:{opt id(string)}} nível de identificação {p_end}
{synopt:{opt sel(string)}} lista de itens selecionados {p_end}
{p2colreset}{...}

{synoptset 20 tabbed}{...}
{synopthdr: std_options}
{synoptline}
{syntab:Bases Padronizadas}
{synopt:{opt id(string)}} nível de identificação {p_end}
{synopt:{opt std}} indica que se quer bases padronizadas {p_end}
{p2colreset}{...}
{p 4 6 2}

Digite {cmd:db datazoom_pof} para utilizar via caixa de diálogo.

{marker description}{...}
{title:Description}

{p 4 4 2}
Cada função {cmd:datazoom_pof}{it:(ano)} tem 3 modos de atuação. Recomenda-se fortemente utilizar via caixa de diálogo.

{p 4 4 2}
O modo de {bf:Tipos de Registro} produz as bases de dados originais em formato Stata sem manipulações
 de variáveis, para os Tipos de Registro desejados. Ele é acessado simplesmente indicando manualmente
 os {opt trs} desejados.

{p 4 4 2}
O modo de {bf:Gastos Selecionados} permite criar uma base de dados personalizada, com as variáveis
 relacionadas aos itens escolhidos pelo próprio usuário. Esse modo é utilizado quando é fornecida
 uma lista de bens na opção {opt sel}.

{p 4 4 2}
O modo de {bf:Bases Padronizadas} gera uma base padronizada da POF.
Esta base contém variáveis de gasto/aquisição para uma cesta de consumo pré-definida com itens agredados, 
seguindo uma classificação disponibilizada pelo IBGE. Basta indicar a opção {opt std}.

{p 4 4 2}
No caso de 2017, a opção de Bases Padronizadas se tornou subordinada à de Gastos Selecionados: ela apenas
 executa a função de Gastos Selecionados utilizando uma cesta de bens específica. Todas as identificações
 de bens vêm dos tradutores de Alimentação, Despesa Geral e de Rendimentos na documentação da POF. Os tradutores
 fornecem agregações de bens, que reproduzimos, e a cesta dos Gastos Selecionados é construída tomando sempre
 o agrupamento mais desagregado existente para cada bem.
	
{p 4 4 2}
Os dois últimos modos permitem ao usuário a escolha do nível de agregação das informações de gasto/aquisição: 
 Domicílio, Unidade de Consumo e Indivíduo. Note que alguns itens e informações não são válidas para todos os níveis.
 
{p 4 4 2}
Utilizando os comandos de Bases Padronizadas ou de Gastos Selecionados, os valores são anualizados e deflacionados: para setembro de 1996, no caso da POF 1995/96; para
janeiro de 2003, no caso da POF 2002/03; e para janeiro de 2009, no caso da POF 2008/09.

{p 4 4 2}
Todas podem ser executadas em caixa de diálogo pelo comando {cmd: db datazoom_pof}

{title: Tipos de Registro}

{p 4 4 2}
Extrai registros da POF em formato Stata a partir dos microdados originais do IBGE.
		
{p 4 4 2} 
Os microdados da POF são separados em Tipos de Registro, diferentes em cada edição. Pode-se selecionar 
os registros desejados para ler os dados via caixa de diálogo.

{title: Gastos Selecionados}

{p 4 4 2}
Extrai e contrói bases de dados personalizadas em formato Stata a partir dos microdados originais do IBGE.
		
{p 4 4 2}
Em {opt sel} o usuário define os itens que deseja incluir em sua cesta. Como cada item possui um nome específico
 pré-definido que deve ser inserido para incluí-lo na lista, recomenda-se fortemente o uso deste comando via caixa de diálogo, 
 por meio da qual pode-se observar todos os itens disponíveis por categoria (Alimentação, Outros gastos e Rendimentos).
 
{p 4 4 2} O gasto em cada item escolhido será agregado ao nível de identificação desejado: domicílio, unidade de consumo ou 
indivíduo. O mesmo vale para variáveis de rendimento.
 As variáveis de rendimento (renda bruta monetária, renda bruta não monetária e renda total) são correspondentes ao rendimento
 bruto mensal do domicílio ou da unidade de consumo (para registros de unidade de consumo e pessoas).Cada gasto está atrelado a
 um determinado nível de identificação. Assim, em particular, não é possível obter para o indivíduo o gasto com itens associados
 à unidade de consumo ou domicílio. Neste caso, execute o programa para cada
 nível de identificação e utilize o comando {help merge} para juntar as bases.
 
{p 4 4 2} A base final, sob qualquer nível de identificação,
	contém todas as variáveis de características do domicílio; e se Indivíduo for escolhido, as variáveis relacionadas às características 
	individuais são incorporadas.

{p 4 4 2} Para a construção de estimativas, é necessário utilizar um fator de expansão ou peso amostral presente entre as variáveis.

{title: Bases Padronizadas}

{p 4 4 2}
Extrai e constrói uma base de dados padronizada da POF a partir dos microdados originais do IBGE
		
{p 4 4 2}
Nesta base padronizada, o gasto em itens semelhantes são agregados em um único item. Por exemplo, gastos em qualquer tipo de arroz, 
feijão e outros são unificados sob gastos em Cereais, Leguminosas e Oleaginosas. As agregações seguem a documentação da POF 
(consulte "Tradutores"). Todas as agregações existentes naquele documento são incorporadas na base final. O usuário não pode escolher 
quais itens incluir nem especificar agregações de itens diferentes das existentes.
		  
{p 4 4 2}
Cada gasto está atrelado a um determinado nível de identificação (domicílio, unidade de consumo ou indivíduo). Ao escolher o nível de identificação, 
o programa computa o gasto para o nível escolhido, somando o gasto individual dentro do nível, quando for o caso. Em particular, quando o nível de 
identificação é o indivíduo, o gasto com itens associados à unidade de consumo ou domicílio são desconsiderados. Caso haja interesse nesses gastos
em uma base de indivíduos, execute o programa para cada nível de identificação e utilize o comando merge para juntar as bases.
	 
{p 4 4 2}
Vale lembrar que as variáveis de rendimento também possuem níveis de identificação, assim como os gastos. As variáveis de rendimento (renda bruta monetária, 
renda bruta não monetária e renda total) são correspondentes ao rendimento bruto mensal do domicílio ou da unidade de consumo (para registros de unidade 
de consumo e pessoas).
 
{p 4 4 2}
A base final, sob qualquer nível de identificação, contém todas as variáveis de características do domicílio; e se Indivíduo for escolhido, as variáveis 
relacionadas às características individuais são incorporadas.
	
{p 4 4 2} Para a construção de estimativas, é necessário utilizar um fator de expansão ou peso amostral presente entre as variáveis.

{p 4 4 2}
Para 2017, são calculadas a Renda Não Monetária e a Variação Patrimonial seguindo um algoritmo presente na pasta de Memórias de Cálculo da
 documentação do IBGE.	
	
{marker options}{...}
{title:Options}
{dlgtab:Input}

{phang}
{opt original(string)}  indica o caminho da pasta onde estão localizados os arquivos de dados
        originais. Todos os arquivos devem estar posicionados na mesma pasta para que o programa funcione
        adequadamente.

{phang}
{opt saving(string)}  indica o caminho da pasta onde devem ser salvas as bases de dados
        produzidas pelo programa.

{phang}
{opt english}  labels das variáveis em inglês

{dlgtab:Tipos de Registro}

{phang}
{opt trs(string)}  especifica o(s) tipo(s) de registro(s) que o usuário deseja obter.

{dlgtab:Gastos Selecionados}
{phang}
{opt id(string)}  especifica o nível de identificação para o qual o gasto deve se referir. São três opções: 
	domicílio ({opt dom}), unidade de consumo ({opt uc}) e indivíduo ({opt pess}). De acordo com a definição 
	do IBGE, uma unidade de consumo é um 
	conjunto de moradores do domicílio (que pode ter apenas um morador) que compartilham da mesma fonte de alimentos.

{phang}
{opt sel(string)}  opção que define o modo de Gastos Selecionados. estabelece os itens para os quais os gastos devem ser
 computados e incluídos na base final. Pode contar variáveis de rendimento também.	

{dlgtab:Bases Padronizadas}
{phang}
{opt id(string)}  especifica o nível de identificação para o qual o gasto deve se referir. São três opções: 
domicílio ({opt dom}), unidade de consumo ({opt uc}) e indivíduo ({opt pess}). De acordo com a definição do IBGE, uma unidade de consumo é um 
conjunto de moradores do domicílio (que pode ter apenas um morador) que compartilham da mesma fonte de alimentos.

{phang}
{opt std}  opção que define o modo de Bases Padronizadas.

{marker examples}{...}
{title:Examples}

{p 8 6 2}. datazoom_pof1995, id(uc pess ) original("~/mydata") saving("~/mydata") std

{p 6 6 2}
O comando acima produz duas bases de dados padronizadas para 1995, sendo uma para a unidade de consumo e outra para o indivíduo.

{p 8 6 2}. datazoom_pof2002, id(uc) original("~/mydata") saving("~/mydata") sel(frutas farinha_de_trigo açúcar_refinado)

{p 6 6 2}
Para gastos selecionados de 2002, contém gastos anualizados em frutas, farinha de trigo e açúcar refinado para unidades de consumo.


{p 8 6 2}. datazoom_pof1995, id(pess) original("~/mydata") saving("~/mydata") sel(frutas farinha_de_trigo açúcar_refinado)

{p 6 6 2}
como os gastos registrados na caderneta de poupança são para a unidade de consumo, o comando é inválido, 
já que o nível de identificação escolhido foi "pess", ou seja, para indivíduos.

{p 8 6 2}. datazoom_pof2008, id(dom) original("~/mydata") saving("~/mydata") sel(Feijao Cenoura Roupa_de_crianca Transferencia)

{p 6 6 2}
base final contém gastos anualizados de 2008 com feijão, cenoura e roupa de criança, além de rendimentos recebidos 
de transferências (aponsentadorias, pensões, bolsas de estudo, transfências transitórias). Todos os valores são agregados 
ao nível do domicílio, portanto, os rendimentos, por exemplo, que são individuais, são somados dentre de cada domicílio. 

{p 8 6 2}.datazoom_pof2017, trs(tr1 tr6 tr7) original("~/mydata") saving("~/mydada")

{p 6 6 2}
A execução do exemplo acima gera três bases de dados de 2017, uma para cada tipo de registro especificado 
(1 - Domicílio; 6 - Rendimento do Trabalho; 7 - Outros Rendimentos). As três bases serão salvas na pasta
"~/mydata".

{marker remarks}
{title:Sobre a POF}

{p 4 4 2}
A Pesquisa de Orçamentos Familiares - POF - é uma pesquisa domiciliar realizada pelo IBGE com o objetivo
 de investigar o padrão de consumo, gasto e/ou aquisição da população brasileira. É realizada a cada cinco anos
  desde 1996 (sua primeira versão foi lançada em 1988) e abrange todo o território nacional. Entre outras funções, 
  a POF serve de insumo para a construção de cestas de consumo utilizadas para o cálculo de índices de inflação, como o IPCA.
  
{p 4 4 2}
O que torna a POF peculiar quando comparada a pesquisas domiciliares mais conhecidas como o Censo ou a PNAD é o
 número e a diversidade de tipos de registro. Esse fato dificulta sua utilização e entendimento por parte do usuário
 não acostumado a trabalhar com pesquisas domiciliares.

{p 4 4 2}
Além de informações acerca dos domicílios (tais como existência de esgoto sanitário, paredes, veículos) e de pessoas 
(idade, nível de instrução e rendimentos), comuns no Censo e na PNAD, a POF contém tipos de registros diferentes para cada tipo 
de gasto/consumo/aquisição 
realizado. Cada tipo depende da periodicidade de realização (semanal, trimestral) e a quem é atribuío, se 
ao domicílio (como consumo de eletricidade) ou ao indivíduo (lanches fora do domicílio). Tanto a periodicidade quanto a
 atribuição são pré-definidas pelo IBGE antes da aplicação do questionário. O gasto com alimentos, por exemplo, é coletado por
 meio de uma caderneta preenchida diariamente pelo domicílio durante sete dias. Por sua vez, gasto com serviço de cabeleireiro
 são registrados individualmente para um período de 90 dias. 
 
{p 4 4 2}Outra dificuldade ocorre com os códigos dos itens na base de dados. Para identificar um item é necessário combinar uma 
variável com os três primeiros dígitos de outra. Porém, esta segunda variável é diferente especificamente para o caso da caderneta de
 despesa coletiva. Ou seja, a variável utilizada em todos os demais tipos de registro existe na base de despesa coletiva, mas
 não deve ser utilizada.
 
{p 4 4 2}Dessa forma, a tarefa de contabilizar o gasto
 total de um domicílio ou indivíduo não é trivial. O objetivo dos programas descritos
 acima, principalmente os dois primeiros, é auxiliar o usuário no acesso a essa pesquisa. 

{title:Author}

{p 4 4 2}
DataZoom     {break}
PUC-Rio - Departamento de Economia      {break}
Contato pelo  {browse "https://github.com/datazoompuc/datazoom_social_Stata":Github}      {break}

{space 4}{hline}

