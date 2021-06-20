{smcl}
{it:version 2.0} 

{phang} {it:For the English version}, {help datazoom_pns_en}


{title:datazoom_pns}

{p 4 4 2}
Acesso aos microdados da PNS


{title:Syntax}

{p 8 8 2} {bf:datazoom_pns} [, {it:options}]

{col 5}{it:option}{col 24}{it:Description}
{space 4}{hline 44}
{col 5}source		{col 24}Local dos dados brutos
{col 5}year		{col 24}2013 ou 2019
{col 5}saving		{col 24}Local para salvar
{col 5}english		{col 24}Labels em inglês       {break}
{space 4}{hline 44}


{title:Description}

{p 4 4 2}
Carrega os dados da PNS para o Stata com os nossos dicionários. Os dados podem vir do armazenamento do computador ou diretamente do site do IBGE

{p 4 4 2}
Digite {bf:db datazoom_pns} para utilizar a função via caixa de diálo


{title:Options}

{phang}
{opt source} Pode ser o caminho para uma pasta contendo os arquivos originais PNS_2013.txt ou PNS_2019.txt files. Caso a opção seja omitida, os dados serão baixados do  {browse "https://www.ibge.gov.br/estatisticas/sociais/saude/9160-pesquisa-nacional-de-saude.html?=&t=microdados":site} do IB


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


{title:License}

{p 4 4 2}
Specify the license of the software

{space 4}{hline}

{p 4 4 2}
This help file was dynamically produced by 
{browse "http://www.haghish.com/markdoc/":MarkDoc Literate Programming package} 


