
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

Para usar os nossas funções, os microdados originais devem estar salvos
no seu computador. Temos tutoriais de como usar o pacote em nosso [canal
do YouTube](https://www.youtube.com/@datazoom9654/videos).

Clique nos botões abaixo para ver informações adicionais sobre cada
pesquisa.

|                                                                                                                                                                             |                                                                                                                                                                              |                                                                                                                                                                            |                                                                                                                                                                                   |
|:---------------------------------------------------------------------------------------------------------------------------------------------------------------------------:|:----------------------------------------------------------------------------------------------------------------------------------------------------------------------------:|:--------------------------------------------------------------------------------------------------------------------------------------------------------------------------:|:---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------:|
|   <a href = "#censo"> <kbd> <br>    <font size = 3> Censo </font>    <br><br> </kbd> </a> <br> <br> <small> Censo Demográfico </small> <br> <small> 1970 a 2010 </small>    | <a href = "#ecinf"> <kbd> <br>    <font size = 3> ECINF </font>    <br><br> </kbd> </a> <br><br> <small> Economia Informal Urbana </small> <br> <small> 1997 e 2003 </small> | <a href = "#pme"> <kbd> <br>    <font size = 3> PME </font>    <br><br> </kbd> </a> <br><br> <small> Pesquisa Mensal de Emprego </small> <br> <small> 1990 a 2015 </small> |           <a href = "#pnad"> <kbd> <br>    <font size = 3> PNAD </font>    <br><br> </kbd> </a> <br><br> <small> PNAD Antiga </small> <br> <small> 2001 a 2015 </small>           |
| <a href = "#pnad-contínua"> <kbd> <br> <font size = 3> PNAD Contínua </font> <br><br> </kbd> </a> <br><br> <small> PNAD Contínua </small> <br> <small> 2012 a 2023 </small> |       <a href = "#pnad-covid"> <kbd> <br>   <font size = 3> PNAD Covid </font>   <br><br> </kbd> </a> <br><br> <small> PNAD Covid </small> <br> <small> 2020 </small>        | <a href = "#pns"> <kbd> <br>    <font size = 3> PNS </font>    <br><br> </kbd> </a> <br><br> <small> Pesquisa Nacional de Saúde </small> <br> <small> 2013 e 2019 </small> | <a href = "#pof"> <kbd> <br>    <font size = 3> POF </font>    <br><br> </kbd> </a> <br><br> <small> Pesquisa de Orçamentos Familiares </small> <br> <small> 1995 a 2018 </small> |

<a href = "#créditos">![Static
Badge](https://img.shields.io/badge/Cr%C3%A9ditos%20-%20Departamento%20de%20Economia%20PUC%20Rio%20-%20blue)
</a> <a href = "#créditos"> ![Static
Badge](https://img.shields.io/badge/Cita%C3%A7%C3%A3o%20-%20green) </a>

## Censo

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

Em cada ano, os arquivos de microdados são separados por Unidade da
Federação (estado). Até 1991, para cada estado, havia um único arquivo
contendo os microdados referentes a domicílios e pessoas. A partir de
2000, as informações de domicílios e pessoas foram separadas em dois
arquivos distintos, disponíveis [neste
link](https://www.ibge.gov.br/estatisticas/sociais/saude/22827-censo-demografico-2022.html?=&t=microdados).

O IBGE disponibiliza gratuitamente para download os microdados e a
documentação para o Censo 2010. Nesta pesquisa, os microdados para 14
municípios sofreram correção, sendo disponibilizados dois novos arquivos
para as observações revistas na página de microdados. Para obter
informações a respeito de como adquirir os microdados para outros anos,
[clique aqui](https://loja.ibge.gov.br/catalogsearch/result/?q=censo).

O IBGE fez diversas alterações metodológicas entre os Censos. Desta
forma, algumas variáveis não estão disponíveis em todos os anos e/ou
podem não ter sido coletadas da mesma forma em anos diferentes. O Data
Zoom disponibiliza uma opção para compatibilizar as variáveis, com o
intuito de uniformizar as informações ao longo do tempo. Neste caso, as
variáveis da base de dados compatibilizada não possuem os nomes
sugeridos pelo dicionário original, sendo um novo dicionário
disponibilizado para download. O documento [Compatibilização dos
Censos](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/Censo/compatibilizacao.pdf)
explica todos os procedimentos adotados pelo programa.

### Arquivos de apoio

- [Microdados e documentação: Censos 2000 e
  2010](https://www.ibge.gov.br/estatisticas/sociais/saude/22827-censo-demografico-2022.html?=&t=microdados)
- [Dicionário
  compatibilizado](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/Censo/dicionario_compatibilizado.xlsx)

<details>
<summary>
Em português:
</summary>

- [Compatibilização dos
  Censos](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/Censo/compatibilizacao.pdf)
- [Dicionário Censo
  1970](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/Censo/dicionario_1970.pdf)
- [Dicionário Censo
  1980](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/Censo/dicionario_1980.xlsx)
- [Dicionário Censo
  1991](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/Censo/dicionario_1991.pdf)

</details>
<details>
<summary>
Em inglês:
</summary>

- [Compatibilização dos
  Censos](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/Censo/compatibilizacao_en.pdf)
- [Dicionário Censo
  1970](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/Censo/dicionario_1970_en.pdf)
- [Dicionário Censo
  1980](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/Censo/dicionario_1980_en.pdf)
- [Dicionário Censo
  1991](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/Censo/dicionario_1991_en.pdf)
- [Dicionário Censo
  2000](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/Censo/dicionario_2000_en.xlsx)
- [Dicionário Censo
  2010](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/Censo/dicionario_2010_en.xls)

</details>

## ECINF

A ECINF, Economia Informal Urbana, é uma pesquisa amostral realizada
pelo IBGE em 1997 e 2003 em todo o país, com o objetivo de investigar o
setor informal, considerando trabalhadores por conta própria e
empregadores com até cinco empregados. O principal interesse da pesquisa
são as características da unidade produtiva, tais como o local de
funcionamento, o tipo de clientela, se fez investimento no último ano e
o tempo de duração do negócio. A amostra da ECINF de 2003 cobria 54.595
domicílios com 195.504 indivíduos.

### Microdados

Devido à grande variedade de vários temas investigados, há diversos
arquivos de microdados para cada ano da pesquisa. Para utilizar o
pacote, o usuário deve possuir os microdados referentes aos anos de
interesse, os quais não são fornecidos pelo Data Zoom. Para obter
informações a respeito de como adquirir os microdados e os demais
arquivos, [clique
aqui](https://www.ibge.gov.br/estatisticas/sociais/trabalho/9025-economia-informal-urbana.html?=&t=downloads).

### Arquivos de apoio

- [Microdados e
  documentação](https://www.ibge.gov.br/estatisticas/sociais/trabalho/9025-economia-informal-urbana.html?=&t=downloads)

<details>
<summary>
Em português:
</summary>

- [Dicionário ECINF
  1997](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/ECINF/dicionario_1997.doc)
- [Dicionário ECINF
  2003](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/ECINF/dicionario_2003.xls)

</details>
<details>
<summary>
Em inglês:
</summary>

- [Dicionário ECINF
  1997](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/ECINF/dicionario_1997_en.xlsx)
- [Dicionário ECINF
  2003](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/ECINF/dicionario_2003_en.xlsx)

</details>

## PME

A PME é uma pesquisa amostral realizada mensalmente pelo IBGE desde
1980, em seis regiões metropolitanas do Brasil: Belo Horizonte, Porto
Alegre, Recife, Rio de Janeiro, Salvador e São Paulo. Essa pesquisa
investiga características de trabalho e rendimento da população e
fornece dados em painel, ou seja, entrevista o mesmo domicílio seguidas
vezes. A amostra da PME de outubro de 2014 cobria 34.307 domicílios com
96.138 indivíduos.

Há duas versões da PME, tradicionalmente chamadas de PME Antiga e PME
Nova. Em 2002, houve uma grande reformulação da pesquisa, dando origem à
PME-Nova. Essa reformulação ampliou significativamente o questionário,
alterando principalmente o conceito de trabalho e o esquema de rotação
da amostra. Até o fim de 2002, ambas as metodologias foram levadas a
campo pelo IBGE. Em dezembro de 2002, a PME Antiga foi descontinuada e
substituída definitivamente pela PME-Nova.

A PME é uma pesquisa em painel, na qual cada domicílio é entrevistado
oito vezes ao longo de 16 meses (entrevistado quatro meses consecutivos,
ausente por oito meses e volta a ser entrevistado outros quatro meses).
Apesar de identificar corretamente o mesmo domicílio nas oito
entrevistas, a PME não atribui o mesmo número de identificação a cada
membro do domicílio em todas as entrevistas. Para corrigir esse
problema, o Data Zoom oferece duas opções de identificação dos
indivíduos baseadas nos algoritmos propostos por [Ribas e Soares
(2008)](https://repositorio.ipea.gov.br/handle/11058/1522). A diferença
entre os algoritmos reside basicamente no número de características
checadas para identificar a mesma pessoa ao longo das entrevistas.

### Microdados

Os arquivos de microdados da PME Antiga são organizados por mês, região
metropolitana e tipo de registro (domicílios e pessoas). A PME Nova
possui um único arquivo por mês, contendo os microdados para os
indivíduos de todas as regiões metropolitanas (não há, portanto, arquivo
de domicílios).

O IBGE disponibiliza gratuitamente para download os microdados e toda a
documentação da PME Nova (março de 2002 em diante) [neste
link](https://www.ibge.gov.br/estatisticas/sociais/trabalho/9183-pesquisa-mensal-de-emprego-antiga-metodologia.html?=&t=microdados).
Para obter informações a respeito de como adquirir os microdados para a
PME Antiga, [clique
aqui](https://loja.ibge.gov.br/catalogsearch/result/?q=pme).

### Arquivos de apoio

- [Microdados e documentação: PME
  Nova](https://www.ibge.gov.br/estatisticas/sociais/trabalho/9183-pesquisa-mensal-de-emprego-antiga-metodologia.html?=&t=microdados)
- [Ribas e Soares
  (2008)](https://repositorio.ipea.gov.br/handle/11058/1522)

<details>
<summary>
Em português:
</summary>

- [Dicionário PME Antiga: 1991 a
  2000](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/PME/dicionario_pme_antiga_1991_2000.pdf)
- [Dicionário PME Antiga:
  2001](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/PME/dicionario_pme_antiga_2001.pdf)
- [Dicionário PME
  Nova](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/PME/dicionario_pme_nova.xls)

</details>
<details>
<summary>
Em inglês:
</summary>

- Dicionários PME Antiga: 1991 a 2000
  - [Domicílios](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/PME/dicionario_pme_antiga_1991_2000_dom_en.pdf),
    [Pessoas](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/PME/dicionario_pme_antiga_1991_2000_pess_en.pdf)
- Dicionários PME Antiga: 2001
  - [Domicílios](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/PME/dicionario_pme_antiga_2001_dom_en.pdf),
    [Pessoas](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/PME/dicionario_pme_antiga_2001_pess_en.pdf)
- [Dicionário PME
  Nova](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/PME/dicionario_pme_nova_en.xls)

</details>

## PNAD

A PNAD, Pesquisa Nacional por Amostra de Domicílios, é uma pesquisa
realizada anualmente pelo IBGE desde 1981. Essa pesquisa investiga
diversas características da população brasileira, tais como educação,
trabalho, rendimento, composição domiciliar e fecundidade. Em quase
todos os anos, ocorre também a investigação de um tema suplementar -
educação, saúde, qualificação profissional e segurança alimentar, entre
outros. A amostra da PNAD 2013 cobria 148.697 domicílios com 362.555
indivíduos.

### Microdados

Até 1990, havia um único arquivo por ano, contendo os microdados
referentes a domicílios e pessoas. A partir de 1992, as informações de
domicílios e pessoas foram separadas em dois arquivos distintos.

O IBGE disponibiliza gratuitamente para download os microdados e toda a
documentação para todas as PNADs desde 2001 [neste
link](https://www.ibge.gov.br/estatisticas/sociais/populacao/9127-pesquisa-nacional-por-amostra-de-domicilios.html?=&t=microdados).
Para obter informações a respeito de como adquirir os microdados para
outros anos, [clique
aqui](https://loja.ibge.gov.br/catalogsearch/result/?q=pnad).

Diversas alterações metodológicas foram realizadas pelo IBGE ao longo
dos anos. Desta forma, a mesma informação pode não estar disponível em
todos os anos e/ou pode não ter sido recolhida da mesma forma.
Especificamente, houve uma grande reformulação da PNAD em 1992, na qual
se destacam a alteração do conceito de trabalho e a adoção de um novo
formato do questionário, inclusive com alterações de nomes de variáveis.

O Data Zoom disponibiliza duas opções para compatibilizar as variáveis
ao longo do tempo. A primeira opção busca adaptar as décadas de 1990 e
2000 aos anos 1980. Entre outras implicações, diversas variáveis
existentes a partir de 1992 são excluídas no processo (todas as
variáveis relacionadas a trabalho infantil, por exemplo), pois não
existiam antes desse ano. Neste caso, as variáveis da base de dados
compatibilizada para os anos 1980 não possuem os nomes sugeridos pelo
dicionário original, sendo um novo dicionário disponibilizado para
download.

A segunda opção de compatibilização procura padronizar as variáveis
somente entre 1992 e 2012. Como houve poucas alterações no período,
foram mantidas com o nome original todas as variáveis que não sofreram
grandes modificações. Outro dicionário, indicando as variáveis
existentes nesta base compatibilizada para os anos 1990, é
disponibilizado para download. O documento [Compatibilização das
PNADs](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/PNAD/compatibilizacao.pdf)
explica todos os procedimentos adotados nas duas opções de
compatibilização do programa.

### Arquivos de apoio

- [Microdados e
  documentação](https://www.ibge.gov.br/estatisticas/sociais/populacao/9127-pesquisa-nacional-por-amostra-de-domicilios.html?=&t=microdados)
- [Dicionário
  compatibilizado](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/PNAD/dicionario_compatibilizado.xlsx)

<details>
<summary>
Em português:
</summary>

- [Compatibilização das
  PNADs](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/PNAD/compatibilizacao.pdf)
- Dicionários anos 1980
  - [1981](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/PNAD/dicionario_1981.pdf),
    [1982](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/PNAD/dicionario_1982.pdf),
    [1983](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/PNAD/dicionario_1983.pdf),
    [1984](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/PNAD/dicionario_1984.pdf),
    [1985](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/PNAD/dicionario_1985.pdf),
    [1986](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/PNAD/dicionario_1986.pdf),
    [1987](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/PNAD/dicionario_1987.pdf),
    [1988](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/PNAD/dicionario_1988.pdf),
    [1989](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/PNAD/dicionario_1989.pdf)
- Dicionários anos 1990
  - [1990](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/PNAD/dicionario_1990.pdf),
    [1992-1995
    (Domicílios)](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/PNAD/dicionario_1992_1995_dom.pdf),
    [1992-1995
    (Pessoas)](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/PNAD/dicionario_1992_1995_pess.pdf),
    [1996
    (Pessoas)](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/PNAD/dicionario_1996_pess.pdf),
    [1996-1997
    (Domicílios)](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/PNAD/dicionario_1996_1997_dom.pdf),
    [1997
    (Pessoas)](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/PNAD/dicionario_1997_pess.pdf),
    [1998
    (Pessoas)](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/PNAD/dicionario_1998_pess.pdf),
    [1998-1999
    (Domicílios)](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/PNAD/dicionario_1998_1999_dom.pdf),
    [1999
    (Pessoas)](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/PNAD/dicionario_1999_pess.pdf)
- [Dicionário 2000-2012
  (Domicílios)](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/PNAD/dicionario_2000s_dom.xlsx)
- [Dicionário 2000-2012
  (Pessoas)](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/PNAD/dicionario_2000s_pess.xlsx)

</details>
<details>
<summary>
Em inglês:
</summary>

- [Compatibilização das
  PNADs](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/PNAD/compatibilizacao_en.pdf)
- Dicionários anos 1980
  - [1981](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/PNAD/dicionario_1981_en.pdf),
    [1982](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/PNAD/dicionario_1982_en.pdf),
    [1983](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/PNAD/dicionario_1983_en.pdf),
    [1984](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/PNAD/dicionario_1984_en.pdf),
    [1985](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/PNAD/dicionario_1985_en.pdf),
    [1986](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/PNAD/dicionario_1986_en.pdf),
    [1987](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/PNAD/dicionario_1987_en.pdf),
    [1988](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/PNAD/dicionario_1988_en.pdf),
    [1989](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/PNAD/dicionario_1989_en.pdf)
- Dicionários anos 1990
  - [1990](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/PNAD/dicionario_1990_en.pdf),
    [1992-1995
    (Domicílios)](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/PNAD/dicionario_1992_1995_dom_en.pdf),
    [1992-1995
    (Pessoas)](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/PNAD/dicionario_1992_1995_pess_en.pdf),
    [1996
    (Pessoas)](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/PNAD/dicionario_1996_pess_en.pdf),
    [1996-1997
    (Domicílios)](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/PNAD/dicionario_1996_1997_dom_en.pdf),
    [1997
    (Pessoas)](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/PNAD/dicionario_1997_pess_en.pdf),
    [1998
    (Pessoas)](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/PNAD/dicionario_1998_pess_en.pdf),
    [1998-1999
    (Domicílios)](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/PNAD/dicionario_1998_1999_dom_en.pdf),
    [1999
    (Pessoas)](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/PNAD/dicionario_1999_pess_en.pdf)
- [Dicionário 2000-2012
  (Domicílios)](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/PNAD/dicionario_2000s_dom_en.xlsx)
- [Dicionário 2000-2012
  (Pessoas)](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/PNAD/dicionario_2000s_pess_en.xlsx)

</details>

## PNAD Contínua

A Pesquisa Nacional por Amostra de Domicílios Contínua, PNAD Contínua, é
uma pesquisa realizada pelo IBGE com o objetivo de produzir
continuamente informações sobre mercado de trabalho, associadas a
características demográficas e educacionais. Periodicamente, são
analisados temas adicionais permanentes, como trabalho infantil e outras
formas de trabalho, fecundidade e migração, e suplementares,
selecionados segundo necessidade, relativos ao desenvolvimento
socioeconômico do país.

A pesquisa fornece informações mensais para um conjunto restrito de
indicadores relativos à força de trabalho, trimestral para os
indicadores de força de trabalho, anual para temas permanentes e
adicionais sobre força e trabalho e variável para temas suplementares.
As informações mensais são representativas apenas em nível nacional e as
demais têm representatividade para os níveis geográficos: Brasil,
Grandes Regiões, Unidades da Federação, 20 Regiões Metropolitanas que
contêm Municípios das Capitais, Municípios das Capitais e Região
Integrada de Desenvolvimento da Grande Teresina.

A cada trimestre, são investigados cerca de 211.000 domicílios inseridos
em aproximadamente 16.000 setores censitários de 3.500 municípios.

Nosso pacote oferece a opção de criar um painel, ou seja, entrevistas de
um mesmo domicílio em diferentes visitas (trimestres). Esse painel é
feito como na PME e tem duas opções: uma identificação simples e uma
usando a [metodologia Ribas
Soares](https://www.puc-rio.br/ensinopesq/ccpg/pibic/relatorio_resumo2020/download/relatorios/CCS/ECO/ECO-Maria%20Mittelbach.pdf).

### Arquivos de apoio

- [Microdados e
  documentação](https://www.ibge.gov.br/estatisticas/multidominio/condicoes-de-vida-desigualdade-e-pobreza/17270-pnad-continua.html?=&t=microdados)
- [Relatório sobre algoritmo de identificação de
  painel](https://www.puc-rio.br/ensinopesq/ccpg/pibic/relatorio_resumo2020/download/relatorios/CCS/ECO/ECO-Maria%20Mittelbach.pdf)

## PNAD Covid

A PNAD Covid objetiva monitorar tanto o número estimado de indivíduos
com sintomas associados à síndrome gripal, típicos da COVID-19, quanto
os impactos da pandemia no mercado de trabalho brasileiro.

A coleta da PNAD Covid, iniciada no dia 4 de maio de 2020, consiste em
entrevistas realizadas por telefone em cerca de 193 mil domicílios por
mês em todo o Brasil. Primeiramente, pergunta-se sobre a ocorrência dos
principais sintomas da COVID-19 no período de referência da pesquisa, em
todos os moradores do domicílio. Para aqueles que apresentaram algum
sintoma, perguntam-se o que foi feito para o alívio dos sintomas; se
buscaram por atendimento médico; e o tipo de estabelecimento de saúde
procurado. Posteriormente, perguntam-se sobre questões de trabalho e
rendimentos.

A pesquisa fornece informações semanais para alguns indicadores, em
nível nacional, e divulgações mensais para um conjunto mais amplo de
indicadores, por Unidades da Federação.

### Arquivos de apoio

- [Microdados e
  documentação](https://www.ibge.gov.br/estatisticas/sociais/trabalho/27946-divulgacao-semanal-pnadcovid1.html?=&t=microdados)

## PNS

A PNS é uma pesquisa amostral realizada pelo IBGE em 2013 e em 2019 com
o objetivo de investigar as características do domicílio e aspectos
relativos à saúde dos moradores. A pesquisa tem enfoque em doenças
crônicas não transmissíveis, estilos de vida e acesso ao atendimento
médico. A amostra da PNS cobria 80.281 domicílios com 205.546
indivíduos.

### Arquivos de apoio

- [Microdados e
  documentação](https://www.ibge.gov.br/estatisticas/sociais/saude/9160-pesquisa-nacional-de-saude.html?=&t=microdados)

## POF

A POF é uma pesquisa amostral realizada pelo IBGE com o objetivo de
investigar o padrão de consumo e gastos da população brasileira, na qual
os domicílios são acompanhados por doze meses. A pesquisa é realizada a
cada seis-sete anos desde 1995 (sua primeira versão foi lançada em 1988)
e abrange todo o território nacional. O principal uso dos dados da POF é
a construção das cestas de consumo dos índices de preços ao consumidor
do IBGE - IPCA e INPC.

A POF contém informações sobre as pessoas (idade, nível de instrução e
rendimentos), os domicílios (existência de esgoto sanitário, paredes,
veículos) e registros diferentes para cada tipo de gasto realizado. Cada
tipo depende da periodicidade da realização do gasto e a quem o gasto é
atribuído, se ao domicílio ou ao indivíduo. Tanto a periodicidade quanto
a atribuição são definidas pelo IBGE antes da entrevista. O gasto com
alimentos, por exemplo, é coletado por meio de uma caderneta preenchida
diariamente pelo domicílio durante sete dias. Por sua vez, o gasto com
serviço de cabeleireiro é registrado individualmente para um período de
90 dias.

### Microdados

A POF produz diversos tipos de registro. Existem arquivos de dados
organizados por características do domicílio, características das
pessoas e de acordo com o inventário de bens duráveis. Além disso, há um
arquivo para cada tipo de gasto. O IBGE disponibiliza gratuitamente para
download os microdados e toda a documentação para as versões 1987-88,
1995-96, 2002-03, 2008-09 e 2017-18. Para obtenção dos microdados,
[clique
aqui](https://www.ibge.gov.br/estatisticas/sociais/populacao/24786-pesquisa-de-orcamentos-familiares-2.html?=&t=microdados).

O Data Zoom oferece programas separados para as POFs de 1995-96,
2002-03, 2008-09 e 2017-18. Cada pacote contém três ferramentas. A
primeira faz a leitura dos microdados para cada tipo de registro no
Stata sem qualquer manipulação dos dados. A segunda ferramenta gera uma
base de dados padronizada, contendo os gastos anualizados por domicílio
(ou unidade de consumo ou indivíduo) para todos os itens investigados,
onde os itens foram agregados de acordo com o documento “Tradutores” do
IBGE. Para as duas versões mais recentes, além do valor total dos
gastos, duas variáveis são geradas: uma indicando o valor desse gasto
realizado por meio de crédito e outra medindo o valor da aquisição
realizada por meios não monetários (como doações). Finalmente, a
terceira ferramenta permite que o usuário crie sua própria cesta de
consumo. Neste caso, é possível obter o valor do gasto anualizado em
itens um pouco mais desagregados do que os existentes na base padrão.

### Arquivos de apoio

- [Microdados e
  documentação](https://www.ibge.gov.br/estatisticas/sociais/populacao/24786-pesquisa-de-orcamentos-familiares-2.html?=&t=microdados)

<details>
<summary>
Em inglês:
</summary>

- POF 1995-96
  - [Dicionário](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/POF/dicionario_1995_en.pdf)
- POF 2002-03
  - [Dicionário](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/POF/dicionario_2002_en.pdf)
  - [Descrição da
    pesquisa](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/POF/descricao_2002_en.pdf)
  - [Descrição das
    variáveis](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/POF/variaveis_2002_en.xls)
- POF 2008-09
  - [Descrição da
    pesquisa](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/POF/descricao_2008_en.pdf)
  - [Descrição das
    variáveis](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/POF/variaveis_2008_en.xls)
  - [Tradutor de
    alimentos](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/POF/tradutor_alimentos_2008_en.pdf)
  - [Tradutor de
    despesas](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/POF/tradutor_despesas_2008_en.pdf)
  - [Tradutor de
    rendimentos](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/POF/tradutor_renda_2008_en.pdf)

</details>

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
