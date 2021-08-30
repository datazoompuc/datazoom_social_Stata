{smcl}
{* *! version 1.0 20 May 2013}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "Install command2" "ssc install command2"}{...}
{vieweralsosee "Help command2 (if installed)" "help command2"}{...}
{viewerjumpto "Syntax" "datazoom_pofstd_08##syntax"}{...}
{viewerjumpto "Description" "datazoom_pofstd_08##description"}{...}
{viewerjumpto "Options" "datazoom_pofstd_08##options"}{...}
{viewerjumpto "Remarks" "datazoom_pofstd_08##remarks"}{...}
{viewerjumpto "Examples" "datazoom_pofstd_08##examples"}{...}
{title:Title}

{phang}
{bf:datazoom_pofstd_08} {hline 2} Acesso à bases padronizadas da POF 2008-09 em formato STATA - Versão 1.2

{marker syntax}{...}
{title:Syntax}
{p 8 17 2}
{cmdab:datazoom_pofstd_08}
[{cmd:,}
{it:options}]

{phang}	OBS: digite 'db datazoom_pof2008' na janela de comando para utilizar o programa via caixa de diálogo

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{opt id(string)}} nível de identificação {p_end}
{synopt:{opt original(string)}} caminho da pasta onde se localizam os arquivos de dados originais {p_end}
{synopt:{opt saving(string)}} caminho da pasta onde serão salvas as novas bases de dados {p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}

{marker description}{...}
{title:Descrição}

{phang}
{cmd:datazoom_pofstd_08} extrai e constrói uma base de dados padronizada da POF 2008-09 a partir dos microdados originais, 
	os quais não são disponibilizados pelo Portal (informações sobre como obter os arquivos originais de dados, consulte o
        site do IBGE www.ibge.gov.br). Este programa é parte do pacote POF 2008-09, que inclui {help datazoom_poftrs_08} e
		{help datazoom_pofsel_08} (todos os programas são independentes uns dos outros).
		
{phang} Nesta base padronizada, o gasto em itens semelhantes são agregados em um único
		 item. Por exemplo, gastos em qualquer tipo de arroz, feijão e outros são unificados sob 
		 gastos em Cereais, Leguminosas e Oleaginosas. As agregações seguem a documentação da POF 
		 (consulte "Tradutores"). Todas as agregações existentes naquele documento
		  são incorporadas na base final. O usuário não pode escolher quais itens incluir nem especificar agregações 
		  de itens diferentes das existentes. Todos os valores são anualizados e deflacionados para janeiro/2009.
		  
{phang} Cada gasto está atrelado a um determinado nível de identificação (domicílio, unidade de consumo 
	ou indivíduo). Ao escolher o nível de identificação, o programa computa o gasto para o nível escolhido, somando o 
	gasto individual dentro do nível, quando for o caso. Em particular, quando o nível de identificação é o indivíduo, 
	o gasto com itens associados à unidade de consumo ou domicílio são desconsiderados. Caso haja interesse nesses gastos
	 em uma base de indivíduos, execute o programa para cada nível de identificação e utilize o
        comando merge para juntar as bases.

{phang} Vale lembrar que as variáveis de rendimento também possuem níveis de identificação, assim como os gastos. As variáveis de rendimento (renda bruta monetária,
 renda bruta não monetária e renda total) são correspondentes ao rendimento bruto mensal do domicílio ou da unidade de consumo (para registros de unidade
 de consumo e pessoas).
 
{phang}	A base final, sob qualquer nível de identificação,
	contém todas as variáveis de características do domicílio. Se Unidade de Consumo for escolhido, são adicionadas
	as variáveis de condições de vida. E se Indivíduo for escolhido, as variáveis relacionadas às características 
	individuais são incorporadas.
	
{phang} Para a construção de estimativas, é necessário o uso do fator de expansão 2 como fator de ponderação.
		Para mais informações ver {help weight}.	
	
		 
{marker options}{...}
{title:Opções}
{dlgtab:Main}
{phang}
{opt id(string)}  especifica o nível de identificação para o qual o gasto deve se referir. São três opções: 
domicílio ({opt dom}), unidade de consumo ({opt uc}) e indivíduo ({opt pess}). De acordo com a definição do IBGE, uma unidade de consumo é um 
conjunto de moradores do domicílio (que pode ter apenas um morador) que compartilham da mesma fonte de alimentos.

{phang}
{opt original(string)}  indica o caminho da pasta onde estão localizados os arquivos de dados
        originais. Todos os 16 arquivos devem estar posicionados na mesma pasta para que o programa funcione
        adequadamente. O Portal não disponibiliza os dados originais.

{phang}
{opt saving(string)}  indica o caminho da pasta onde devem ser salvas as bases de dados
        produzidas pelo programa.


{marker examples}{...}
{title:Examplo}

{phang}  OBS: Recomenda-se a execução do programa por meio da caixa de diálogo. Digite "db
        datazoom_pof2008" na janela de comando do STATA para iniciar.

{phang} datazoom_pofstd_08, id(uc pess ) original(c:/mydata) saving(c:/pof)

{pstd}
O comando acima produz duas bases de dados padronizadas, uma para a unidade de consumo e outra para o indivíduo.


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
{help datazoom_pof2002} (se instalado)  
{help datazoom_pof1995} (se instalado)  
{help datazoom_ecinf} (se instalado) 


{p} Digite "net from http://www.econ.puc-rio.br/datazoom/portugues" para instalar a versão em português desses pacotes. 
For the english version, type "net from http://www.econ.puc-rio.br/datazoom/english".
