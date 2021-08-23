{smcl}
{it:version 2.2} 

{vieweralsosee "PNAD" "help datazoom_pnas"}{...}
{vieweralsosee "Censo" "help datazoom_censo"}{...}

{viewerjumpto "Syntax" "datazoom_pns##synt"}{...}
{viewerjumpto "Description" "datazoom_pns##desc"}{...}
{viewerjumpto "Options" "datazoom_pns##opt"}{...}
{viewerjumpto "Examples" "datazoom_pns##ex"}{...}

{p 8 8 2} {it:For the English version}, {help datazoom_pns_en}

{title:Title}

{p 4 4 2}
{bf:datazoom_pns} {hline 2} Acesso aos microdados da PNS

{marker synt}

{title:Syntax}

{p 8 8 2} {bf:datazoom_pns} [, {it:options}]

{synoptset 20 tabbed}{...}

{synopthdr}
{synoptline}
{synopt:{opt original(str)}} caminho dos arquivos brutos no seu computador {p_end}
{synopt:{opt year(int)}} ano da pesquisa, 2013 ou 2019 {p_end}
{synopt:{opt saving(str)}} caminho da pasta onde serão salvas as novas bases de dados {p_end}
{synopt:{opt english}} labels em inglês {p_end}

{synoptline}
{p2colreset}{...}
{p 4 6 2}

Digite o comando {bf:db datazoom_pns} para utilizar a função via caixa de diálogo.      {break}

{marker desc}{...}

{title:Description}

{p 4 4 2}
Carrega os dados da PNS para o Stata com os nossos dicionários. Os dados podem ser lidos do armazenamento local ou baixados automaticamente.          {break}

{marker opt}{...}

{title:Options}
{dlgtab:Options}

{phang}
{opt source} Pode ser o caminho para uma pasta contendo os arquivos originais PNS_2013.txt ou PNS_2019.txt. Caso a opção seja omitida, os dados serão baixados do {browse "https://www.ibge.gov.br/estatisticas/sociais/saude/":site} do IBGE.              {break}

{marker ex}{...} 

{title:Examples}

    Para baixar e ler os dados da PNS 2019

        . datazoom_pns, year(2019)

    Caso o arquivo de dados brutos já esteja em seu computador

        . datazoom_pns, source(~/mydir) year(2019)


{title:Author}

{p 4 4 2}
DataZoom     {break}
PUC-Rio      {break}
Contato pelo  {browse "https://github.com/datazoompuc/datazoom_social_Stata":Github}      {break}

{space 4}{hline}

