
For the English version, click on the Shield below:
<!-- badges: start -->
[![en](https://img.shields.io/badge/lang-en-red.svg)](https://github.com/datazoompuc/datazoom_social_Stata/blob/main/README_en.md)
<!-- badges: end -->

<a href="https://github.com/datazoompuc/datazoom_social_Stata"><img src="https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/logo.png" align="left" width="100" hspace="10" vspace="6"></a>

<!-- README.md is generated from README.Rmd. Please edit that file -->

# datazoom_social

<!-- badges: start -->

![Languages](https://img.shields.io/github/languages/count/datazoompuc/datazoom_social_Stata?style=flat)
![Commits](https://img.shields.io/github/commit-activity/y/datazoompuc/datazoom_social_Stata?style=flat)
![Open
Issues](https://img.shields.io/github/issues-raw/datazoompuc/datazoom_social_Stata?style=flat)
![Closed
Issues](https://img.shields.io/github/issues-closed-raw/datazoompuc/datazoom_social_Stata?style=flat)
![Files](https://img.shields.io/github/directory-file-count/datazoompuc/datazoom_social_Stata?style=flat)
![Followers](https://img.shields.io/github/followers/datazoompuc?style=flat)
<!-- badges: end -->

O `datazoom_social` é um pacote que compatibiliza microdados de
pesquisas realizadas pelo IBGE. Com o pacote, é possível fazer a leitura
de todas as pesquisas domiciliares realizadas pelo IBGE, compatibilizar
os Censos Demográficos de diferentes anos, gerar identificação dos
indivíduos da PNAD Contínua, e muito mais.

## Instalação <a name="instalacao"></a>

Digite o código abaixo na linha de comando do Stata para baixar e
instalar a versão mais recente do pacote

    net install datazoom_social, from("https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/") force

## Uso

Todas as funções do pacote podem ser usadas pelas caixas de diálogo.
Para acessá-las, digite o comando

    db datazoom_social

Clique nos botões abaixo para ir à helpfile de cada função. Elas são
melhor visualizadas abrindo no Stata, com `help função`.

|                                                                                                                                                                                                                   |                                                                                                                                                                                                  |                                                                                                                                                                                              |                                                                                                                                                                                                     |
|:-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------:|:------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------:|:--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------:|:---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------:|
|                      <a href = "#censo"> <kbd> <br>    <font size = 3> Censo </font>    <br><br> </kbd> </a> <br> <br> <small> Censo Demográfico </small> <br> <small> 1970 a 2010 </small>                       | <a href = "ECINF/datazoom_ecinf.sthlp"> <kbd> <br>    <font size = 3> ECINF </font>    <br><br> </kbd> </a> <br><br> <small> Economia Informal Urbana </small> <br> <small> 1997 e 2003 </small> | <a href = "PME/datazoom_pme.sthlp"> <kbd> <br>    <font size = 3> PME </font>    <br><br> </kbd> </a> <br><br> <small> Pesquisa Mensal de Emprego </small> <br> <small> 1990 a 2015 </small> |          <a href = "PNAD/datazoom_pnad.sthlp"> <kbd> <br>    <font size = 3> PNAD </font>    <br><br> </kbd> </a> <br><br> <small> PNAD Antiga </small> <br> <small> 2001 a 2015 </small>           |
| <a href = "PNAD_Continua/Trimestral/datazoom_pnadcontinua.sthlp"> <kbd> <br> <font size = 3> PNAD Contínua </font> <br><br> </kbd> </a> <br><br> <small> PNAD Contínua </small> <br> <small> 2012 a 2023 </small> |     <a href = "PNAD_Covid/datazoom_pnad_covid.sthlp"> <kbd> <br>   <font size = 3> PNAD Covid </font>   <br><br> </kbd> </a> <br><br> <small> PNAD Covid </small> <br> <small> 2020 </small>     | <a href = "PNS/datazoom_pns.sthlp"> <kbd> <br>    <font size = 3> PNS </font>    <br><br> </kbd> </a> <br><br> <small> Pesquisa Nacional de Saúde </small> <br> <small> 2013 e 2019 </small> | <a href = "POF/datazoom_pof.sthlp"> <kbd> <br>    <font size = 3> POF </font>    <br><br> </kbd> </a> <br><br> <small> Pesquisa de Orçamentos Familiares </small> <br> <small> 1995 a 2018 </small> |

<a href = "#créditos">![Static
Badge](https://img.shields.io/badge/Cr%C3%A9ditos%20-%20Departamento%20de%20Economia%20PUC%20Rio%20-%20blue)
</a> <a href = "#créditos"> ![Static
Badge](https://img.shields.io/badge/Cita%C3%A7%C3%A3o%20-%20green) </a>

## Censo

### Sobre

O Censo Demográfico é uma pesquisa realizada pelo IBGE uma vez a cada
dez anos, na qual todos os domicílios do território brasileiro são
visitados. O Censo fornece uma contagem da população e recolhe
informações básicas dos moradores, como idade e gênero.

Por ocasião do Censo, o IBGE realiza uma entrevista mais detalhada com
uma grande amostra aleatória dos domicílios, na qual investiga
características sociodemográficas dos moradores (como escolaridade e
rendimentos), características físicas do local de residência (material
das paredes, existência de água encanada, etc.) e posse de bens (como
geladeira e automóvel). No Censo de 2010, tal amostra cobria 6,2 milhões
de domicílios com 20,6 milhões de indivíduos.

### Microdados

As informações coletadas pelos Censos podem ser acessadas pelo público
por meio dos microdados. Em cada ano, os arquivos de microdados são
separados por Unidade da Federação (estado). Até 1991, para cada estado,
havia um único arquivo contendo os microdados referentes a domicílios e
pessoas. A partir de 2000, as informações de domicílios e pessoas foram
separadas em dois arquivos distintos, disponíveis [neste
link](https://www.ibge.gov.br/estatisticas/sociais/saude/22827-censo-demografico-2022.html?=&t=microdados).

O Data Zoom permite a leitura dos microdados por meio do programa Stata
para os Censos de 1970, 1980, 1991, 2000 e 2010, gerando bases de dados
no formato do programa (formato `.dta`). Todas as variáveis originais
seguem os nomes sugeridos pelo IBGE em seu dicionário. Para utilizar o
pacote, o usuário deve obter os microdados referentes aos anos de
interesse, não fornecidos pelo Data Zoom. O IBGE disponibiliza
gratuitamente para download os microdados e a documentação para o Censo
2010. Nesta pesquisa, os microdados para 14 municípios sofreram
correção, sendo disponibilizados dois novos arquivos para as observações
revistas na página de microdados. Para obter informações a respeito de
como adquirir os microdados para outros anos, [clique
aqui](https://loja.ibge.gov.br/catalogsearch/result/?q=censo).

O IBGE fez diversas alterações metodológicas entre um Censo e outro.
Desta forma, algumas variáveis não estão disponíveis em todos os anos
e/ou podem não ter sido coletadas da mesma forma em anos diferentes. O
Data Zoom disponibiliza uma opção para compatibilizar as variáveis, com
o intuito de uniformizar as informações ao longo do tempo. Neste caso,
as variáveis da base de dados compatibilizada não possuem os nomes
sugeridos pelo dicionário original, sendo um novo dicionário
disponibilizado para download. O documento [Compatibilização dos
Censos](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/Censo/compatibilizacao.pdf)
explica todos os procedimentos adotados pelo programa.

### Arquivos de apoio

- [Compatibilização dos
  Censos](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/Censo/compatibilizacao.pdf)
- [Dicionário
  compatibilizado](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/Censo/dicionario_compatibilizado.xlsx)
- [Dicionário Censo
  1980](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/Censo/dicionario_1980.xlsx)
- [Dicionário Censo
  1991](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/Censo/dicionario_1991.pdf)
- [Dicionário Censo
  2000](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/Censo/dicionario_2000.xlsx)
- [Dicionário Censo
  2010](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/Censo/dicionario_2010.xls)

## Programas Auxiliares (Dicionários)

A maioria dos programas do pacote lidam com dados originais armazenados
em formato *.txt*, que precisam de dicionários – formato *.dct* no Stata
– para serem lidos. A consequência é um volume de dicionários que supera
o limite de 100 arquivos permitido para um pacote do Stata poder ser
instalado. Por isso, os dicionários individuais são compactados em um
arquivo *.dta* único, que é lido dentro de cada programa. Ambas as
funções usadas para isso são definidas no arquivo *read_compdct.ado*.

O primeiro programa definido nesse arquivo é `write_compdct`, que pode
ser usado como a seguir: após rodar o arquivo *.ado* para definir a
função, basta usar o código

    write_compdct, folder("/pasta com os dicionários") saving("/caminho/dict.dta")

A função então lê todos os arquivos *.dct* presentes na pasta, e junta
todos no arquivo *dict.dta*, com cada dicionário identificado por uma
variável com seu nome.

Para transformar esse arquivo compactado novamente do dicionário
original, se usa o programa `read_compdct`:

    read_compdct, compdct("dict.dta") dict_name("dic original") out("dic extraído.dct")

que extrai o *“dic original”* do arquivo *dict.dta* e o salva para *“dic
extraído.dct”*. Como exemplo, veja o uso dessa função no programa
`datazoom_pnadcontinua`

    tempfile dic // Arquivo temporário onde o .dct extraído será salvo

    findfile dict.dta // Acha o arquivo dict.dta salvo pela instalação
                      // do pacote na pasta /ado/, e armazena o caminho
                      // até ele na macro r(fn)

    read_compdct, compdct("`r(fn)'") dict_name("pnadcontinua`lang'") out("`dic'")
      // Lê o dicionário compactado dict.dta, extrai o dicionário pnadcontinua
      // (ou pnadcontinua_en, `lang` é vazio ou "_en"), e salva o arquivo final
      // na tempfile dic, que é usada para ler os dados

Para a nossa organização interna, cada pasta correspondente a um
programa armazena os dicionários na sub-pasta */dct/*. Todos esses
dicionários são também armazenados juntos na pasta */dct/* diretamente,
que é usada para gerar o *dict.dta* através do `write_compdct`. Note que
nenhum arquivo *.dct* é efetivamente listado no arquivo
*datazoom_social.pkg*, e portanto, não são instalados no computador do
usuário. Apenas o arquivo *dict.dta* é enviado.

Periodicamente, na manutenção do pacote, temos que rodar a do-file
`atualizacao_dict.do` e seguir as instruções.

## Créditos

O [Data Zoom](https://www.econ.puc-rio.br/datazoom/) é desenvolvido por
uma equipe do Departamento de Economia da Pontifícia Universidade
Católica do Rio de Janeiro (PUC-Rio)

Para citar o pacote `datazoom_social`, utilize:

> Data Zoom (2023). Data Zoom: Simplifying Access To Brazilian
> Microdata.  
> <https://www.econ.puc-rio.br/datazoom/english/index.html>

Ou, em formato BibTeX:

    @Unpublished{DataZoom2023,
        author = {Data Zoom},
        title = {Data Zoom: Simplifying Access To Brazilian Microdata},
        url = {https://www.econ.puc-rio.br/datazoom/english/index.html},
        year = {2023},
    }
