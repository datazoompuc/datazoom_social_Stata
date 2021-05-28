{smcl}
{* *! version 1.0 18 Jun 2013}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "Install command2" "ssc install command2"}{...}
{vieweralsosee "Help command2 (if installed)" "help command2"}{...}
{viewerjumpto "Description" "datazoom_pof2002##description"}{...}
{title:Title}

{phang}
{bf:datazoom_pof2002} {hline 2}  Acesso aos microdados da POF 2002-03 em formato STATA - Versão 1.2


{marker description}{...}
{title:Descrição}

{phang}
{cmd:datazoom_pof2002} é um pacote composto por três comandos.

{phang}
1) datazoom_pofstd_02: execute este comando para obter um base padronizada da POF 2002-03 standard database. 
Esta base contém variáveis de gasto/aquisição para uma cesta de consumo pré-definida com itens agredados, 
seguinto uma classificação disponibilizada pelo IBGE. Para mais informações ver {help datazoom_pofstd_02}.

{phang}
2) datazoom_pofsel_02: com este comando o usuário obtém uma base de dados persoanalizada, com as variáveis
 relacionadas aos itens escolhidos pelo próprio usuário. Para mais informações ver {help datazoom_pofsel_02}.
	
{phang}
3) datazoom_poftrs_02: execute este comando para obter as bases de dados originais em formato STATA sem manipulações
 de variáveis. A POF 2002-03 contém 14 tipos de registros. Para mais informações ver {help datazoom_poftrs_02}.
	
{phang}
Os dois primeiros comandos permitem ao usuário a escolha do nível de agregação das informações de gasto/aquisição: 
 Domicílio, Unidade de Consumo e Indivíduo. Note que alguns itens e informações não são válidas para todos os níveis.

{phang}
Digite "db datazoom_pof2002" na janela de comando para iniciar.


{title:Sobre a POF 2002-03}

{phang} A Pesquisa de Orçamentos Familiares - POF - é uma pesquisa domiciliar realizada pelo IBGE com o objetivo
 de investigar o padrão de consumo, gasto e/ou aquisição da população brasileira. É realizada a cada cinco anos
  desde 1996 (sua primeira versão foi lançada em 1988) e abrange todo o território nacional. Entre outras funções, 
  a POF serve de insumo para a construção de cestas de consumo utilizadas para o cálculo de índices de inflação, como o IPCA.
  
{phang} O que torna a POF peculiar quando comparada a pesquisas domiciliares mais conhecidas como o Censo ou a PNAD é o
 número e a diversidade de tipos de registro. Esse fato dificulta sua utilização e entendimento por parte do usuário
 não acostumado a trabalhar com pesquisas domiciliares.

{phang} Além de informações acerca dos domicílios (tais como existência de esgoto sanitário, paredes, veículos) e de pessoas 
(idade, nível de instrução e rendimentos), comuns no Censo e na PNAD, a POF contém tipos de registros diferentes para cada tipo 
de gasto/consumo/aquisição 
realizado. Cada tipo depende da periodicidade de realização (semanal, trimestral) e a quem é atribuío, se 
ao domicílio (como consumo de eletricidade) ou ao indivíduo (lanches fora do domicílio). Tanto a periodicidade quanto a
 atribuição são pré-definidas pelo IBGE antes da aplicação do questionário. O gasto com alimentos, por exemplo, é coletado por
 meio de uma caderneta preenchida diariamente pelo domicílio durante sete dias. Por sua vez, gasto com serviço de cabeleireiro
 são registrados individualmente para um período de 90 dias. 
 
{phang} Outra dificuldade ocorre com os códigos dos itens na base de dados. Para identificar um item é necessário combinar uma 
variável com os três primeiros dígitos de outra. Porém, esta segunda variável é diferente especificamente para o caso da caderneta de
 despesa coletiva. Ou seja, a variável utilizada em todos os demais tipos de registro existe na base de despesa coletiva, mas
 não deve ser utilizada.
 
{phang}  Dessa forma, a tarefa de contabilizar o gasto
 total de um domicílio ou indivíduo não é trivial. O objetivo dos programas descritos
 acima, principalmente os dois primeiros, é auxiliar o usuário no acesso a essa pesquisa. 
 
{title:Autor}
{p}

PUC-Rio - Departamento de Economia

Email {browse "mailto:datazoom@econ.puc-rio.br":datazoom@econ.puc-rio.br}


{title:Veja também}

Pacotes relacionados:

{help datazoom_censo} (se instalado) 
{help datazoom_pnad} (se instalado)  
{help datazoom_pmenova} (se instalado)  
{help datazoom_pmeantiga} (se instalado)  
{help datazoom_pof2008} (se instalado)  
{help datazoom_pof1995} (se instalado)  
{help datazoom_ecinf} (se instalado) 


{p} Digite "net from http://www.econ.puc-rio.br/datazoom/portugues" para instalar a versão em português desses pacotes. 
For the english version, type "net from http://www.econ.puc-rio.br/datazoom/english".


