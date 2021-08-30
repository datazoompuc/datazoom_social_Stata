{smcl}
{viewerdialog "ECINF" "dialog datazoom_ecinf"}
{viewerdialog "Pacote" "dialog datazoom_social"}
{vieweralsosee "PNAD" "help datazoom_pnad"}{...}
{vieweralsosee "Censo" "help datazoom_censo"}{...}
{vieweralsosee "PNAD Contínua Trimestral" "help datazoom_pnadcontinua"}{...}
{vieweralsosee "PNAD Contínua Anual" "help datazoom_pnadcont_anual"}{...}
{vieweralsosee "PNAD Covid" "help datazoom_pnad_covid"}{...}
{vieweralsosee "PME" "help datazoom_pme"}{...}
{vieweralsosee "POF" "help datazoom_pof"}{...}
{vieweralsosee "Censo" "help datazoom_censo"}{...}
{viewerjumpto "Syntax" "datazoom_ecinf##syntax"}{...}
{viewerjumpto "Description" "datazoom_ecinf##description"}{...}
{viewerjumpto "Options" "datazoom_ecinf##options"}{...}
{viewerjumpto "Examples" "datazoom_ecinf##examples"}{...}
{p 8 8 2} {it:For the English version}, {help datazoom_ecinf_en}

{title:Title}

{p 4 4 2}
{cmd:datazoom_ecinf} {hline 2} Acesso aos microdados da ECINF

{marker syntax}{...}
{title:Syntax}

{p 8 8 2} {cmd:datazoom_ecinf} [, {it:options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{opt year(numlist)}} ano da pesquisa {p_end}
{synopt:{opt original(string)}} caminho da pasta onde se localizam os arquivos de dados originais {p_end}
{synopt:{opt saving(string)}} caminho da pasta onde serão salvas as novas bases de dados {p_end}
{synopt:{opt tipo(str)}} tipo de registro {p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}

Digite {cmd:db datazoom_ecinf} para utilizar a função via caixa de diálogo.

{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:datazoom_ecinf} extrai bases de dados da ECINF em formato Stata a partir dos microdados originais do IBGE. Este programa pode ser utilizado para 1997 e 2003.

{marker options}{...}
{title:Options}
{dlgtab:Main}
{phang}
{opt year(numlist)}  especifica o ano a ser extraído. Não é possível escolher os dois anos ao mesmo tempo. 

{phang}
{opt original(string)}  indica o caminho da pasta onde estão localizados os arquivos de dados
        originais. Todos os arquivos devem estar posicionados na mesma pasta para que o programa funcione
        adequadamente. O Portal não disponibiliza os dados originais.

{phang}
{opt saving(string)}  indica o caminho da pasta onde devem ser salvas as bases de dados
        produzidas pelo programa.

{phang}
{opt tipo(str)}  especifica para quais tipos de registros o usuário deseja obter os microdados. Os tipos são nomeados conforme a 
	documentação do IBGE: {opt domicilios}, {opt moradores}, {opt trabrend} para trabalho e rendimento, 
	{opt uecon} para unidade econômica, {opt pesocup} para características das pessoas ocupadas, 
	{opt indprop} para características individuais do proprietário  e {opt sebrae} para o suplemento Sebrae (somente para 2003). 


{marker examples}{...}
{title:Examples}

{p 8 6 2}. datazoom_ecinf, year(1997) tipo(pesocup indprop uecon) original("~/mydir") saving("~/mydir")


{title:Author}

{p 4 4 2}
DataZoom     {break}
PUC-Rio - Departamento de Economia      {break}
Contato pelo  {browse "https://github.com/datazoompuc/datazoom_social_Stata":Github}      {break}

{space 4}{hline}
