{smcl}
{* *! version 1.0 20 May 2013}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "Install command2" "ssc install command2"}{...}
{vieweralsosee "Help command2 (if installed)" "help command2"}{...}
{viewerjumpto "Syntax" "datazoom_pofsel_95##syntax"}{...}
{viewerjumpto "Description" "datazoom_pofsel_95##description"}{...}
{viewerjumpto "Options" "datazoom_pofsel_95##options"}{...}
{viewerjumpto "Remarks" "datazoom_pofsel_95##remarks"}{...}
{viewerjumpto "Examples" "datazoom_pofsel_95##examples"}{...}
{title:Title}

{phang}
{bf:datazoom_pofsel_95} {hline 2} Acesso à bases personalizadas da POF 1995-96 em formato STATA - Versão 1.2

{marker syntax}{...}
{title:Syntax}
{p 8 17 2}
{cmdab:datazoom_pofsel_95}
[{cmd:,}
{it:options}]

{phang}	OBS: digite 'db datazoom_pof1995' na janela de comando para utilizar o programa via caixa de diálogo 
	(fortemente recomentado)

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{opt id(string)}} nível de identificação {p_end}
{synopt:{opt lista(string asis)}} lista de itens {p_end}
{synopt:{opt original(string)}} caminho da pasta onde se localizam os arquivos de dados originais {p_end}
{synopt:{opt saving(string)}} caminho da pasta onde serão salvas as novas bases de dados {p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}

{marker description}{...}
{title:Descrição}

{phang}
{cmd:datazoom_pofsel_95} extrai e contrói bases de dados personalizadas em formato STATA (.dta) a partir dos microdados originais, 
	os quais não são disponibilizados pelo Portal (informações sobre como obter os arquivos originais de dados, consulte o
        site do IBGE www.ibge.gov.br). Este programa é parte do pacote POF 1995-96, que inclui {help datazoom_poftrs_95} e
		{help datazoom_pofstd_95} (todos os programas são independentes uns dos outros).
		
{phang} Em {opt lista} o usuário define os itens que deseja incluir em sua cesta. Como cada item possui um nome específico
 pré-definido que deve ser inserido para incluí-lo na lista, recomenda-se fortemente o uso deste comando via caixa de diálogo, 
 por meio da qual pode-se observar todos os itens disponíveis por categoria (Alimentação, Outros gastos e Rendimentos).
 
{phang} O gasto em cada item escolhido será agregado ao nível de identificação desejado: domicílio, unidade de consumo ou 
indivíduo. O mesmo vale para variáveis de rendimento. Todos os valores são anualizados e deflacionados para setembro/1996.
 As variáveis de rendimento (renda bruta monetária, renda bruta não monetária e renda total) são correspondentes ao rendimento
 bruto mensal do domicílio ou da unidade de consumo (para registros de unidade de consumo e pessoas).Cada gasto está atrelado a
 um determinado nível de identificação. Assim, em particular, não é possível obter para o indivíduo o gasto com itens associados
 à unidade de consumo ou domicílio. Neste caso, execute o programa para cada
 nível de identificação e utilize o comando {help merge} para juntar as bases.
 
{phang} A base final, sob qualquer nível de identificação,
	contém todas as variáveis de características do domicílio; e se Indivíduo for escolhido, as variáveis relacionadas às características 
	individuais são incorporadas.

{phang} Para a construção de estimativas, é necessário o uso do fator de expansão 2 como fator de ponderação.
Para mais informações ver {help weight}.
	
{marker options}{...}
{title:Opções}
{dlgtab:Main}
{phang}
{opt id(string)}  especifica o nível de identificação para o qual o gasto deve se referir. São três opções: 
	domicílio ({opt dom}), unidade de consumo ({opt uc}) e indivíduo ({opt pess}). De acordo com a definição 
	do IBGE, uma unidade de consumo é um 
	conjunto de moradores do domicílio (que pode ter apenas um morador) que compartilham da mesma fonte de alimentos.

{phang}
{opt lista(string asis)}  estabelece os itens para os quais os gastos devem ser computados e incluídos na base final.
 Pode contar variáveis de rendimento também.	

{phang}
{opt original(string)}  indica o caminho da pasta onde estão localizados os arquivos de dados
        originais. Todos os 12 arquivos devem estar posicionados na mesma pasta para que o programa funcione
        adequadamente. O Portal não disponibiliza os dados originais.

{phang}
{opt saving(string)}  indica o caminho da pasta onde devem ser salvas as bases de dados
        produzidas pelo programa.


{marker examples}{...}
{title:Exemplos}

{p}	OBS: (fortemente recomentado) digite 'db datazoom_pof1995' na janela de comando para utilizar o programa via caixa de diálogo 

{p} Exemplo 1: base final contém gastos anualizados em frutas, farinha de trigo e açúcar refinado para unidades de consumo.

{phang} datazoom_pofsel_95, id(uc) original(c:/mydata) saving(c:/pof) lista(frutas farinha_de_trigo açúcar_refinado)


{p} Exemplo 2: como os gastos registrados na caderneta de poupança são para a unidade de consumo, o comando abaixo é inválido, 
já que o nível de identificação escolhido foi "pess", ou seja, para indivíduos.

{phang} datazoom_pofsel_95, id(pess) original(c:/mydata) saving(c:/pof) lista(frutas farinha_de_trigo açúcar_refinado)


{p} Exemplo 3: base final contém gastos anualizados com feijão, cenoura e roupa de criança, além de rendimentos recebidos 
de transferências (aponsentadorias, pensões, bolsas de estudo, transfências transitórias). Todos os valores são agregados 
ao nível do domicílio, portanto, os rendimentos, por exemplo, que são individuais, são somados dentre de cada domicílio. 

{phang} datazoom_pofsel_95, id(dom) original(c:/mydata) saving(c:/pof) lista(Feijao Cenoura Roupa_de_crianca Transferencia)


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
{help datazoom_pof2002} (se instalado)  
{help datazoom_ecinf} (se instalado) 


{p} Digite "net from http://www.econ.puc-rio.br/datazoom/portugues" para instalar a versão em português desses pacotes. 
For the english version, type "net from http://www.econ.puc-rio.br/datazoom/english".
