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
{cmd:datazoom_pof}{it:(ano)} {hline 2} Acesso aos microdados da POF

{marker syntax}{...}
{title:Syntax}

{p 8 8 2} {cmd:datazoom_pof}{it:(ano)}{cmd:std} [, {it:trs_options}]

{p 8 8 2} {cmd:datazoom_pof}{it:(ano)}{cmd:sel} [, {it:std_options}]

{p 8 8 2} {cmd:datazoom_pof}{it:(ano)}{cmd:trs} [, {it:sel_options}]

Digite {cmd:db datazoom_pof} para utilizar via caixa de diálogo.

{marker description}{...}
{title:Description}

{p 4 4 2}
Para cada ano, há três comandos da forma {cmd:datazoom_pof}{it:(ano)} é um pacote composto por três comandos.

{p 4 4 2}
Estão disponíveis {help datazoom_pof1995}, {help datazoom_pof2002}, {help datazoom_pof2008} e {help datazoom_pof2017}

{p 4 4 2}
Todas podem ser executadas em caixa de diálogo pelo comando {cmd: db datazoom_pof}

{marker remarks}
{title:Sobre a POF 1995-96}

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

