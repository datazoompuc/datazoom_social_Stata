
Para a versão em português, clique no escudo abaixo:
<!-- badges: start -->
[![pt-br](https://img.shields.io/badge/lang-pt--br-blue.svg)](https://github.com/datazoompuc/datazoom_social_Stata/blob/English-READ.ME/README.md)

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

The `datazoom_social` package reads and processes microdata from IBGE
surveys. We read all IBGE household surveys into Stata format, as well
as making different Census instances compatible, generating individual
identification for the Continuous PNAD, and much more.

## Installation <a name="instalacao"></a>

Enter the code below in the Stata command line to download and install
the latest version of the package

    net install datazoom_social, from("https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/") force

## Usage

All of our functions can be used through interactive dialog boxes. To
access them, type

    db datazoom_social

Across all of our functions, the original microdata must be saved in
your computer for them to work. Our [YouTube
channel](https://www.youtube.com/@datazoom9654/videos) has tutorials
explaining how to use our package.

Click on the buttons below for additional information on each survey.

|                                                                                                                                                                                |                                                                                                                                                                              |                                                                                                                                                                            |                                                                                                                                                                              |
|:------------------------------------------------------------------------------------------------------------------------------------------------------------------------------:|:----------------------------------------------------------------------------------------------------------------------------------------------------------------------------:|:--------------------------------------------------------------------------------------------------------------------------------------------------------------------------:|:----------------------------------------------------------------------------------------------------------------------------------------------------------------------------:|
|    <a href = "#censo"> <kbd> <br>    <font size = 3> Censo </font>    <br><br> </kbd> </a> <br> <br> <small> Demographic Census </small> <br> <small> 1970 to 2010 </small>    | <a href = "#ecinf"> <kbd> <br>    <font size = 3> ECINF </font>    <br><br> </kbd> </a> <br><br> <small> Urban Informal Economy </small> <br> <small> 1997 and 2003 </small> | <a href = "#pme"> <kbd> <br>    <font size = 3> PME </font>    <br><br> </kbd> </a> <br><br> <small> Monthly Employment Survey </small> <br> <small> 1990 to 2015 </small> |         <a href = "#pnad"> <kbd> <br>    <font size = 3> PNAD </font>    <br><br> </kbd> </a> <br><br> <small> Old PNAD </small> <br> <small> 2001 to 2015 </small>          |
| <a href = "#pnad-contínua"> <kbd> <br> <font size = 3> PNAD Contínua </font> <br><br> </kbd> </a> <br><br> <small> Continuous PNAD </small> <br> <small> 2012 to 2023 </small> |       <a href = "#pnad-covid"> <kbd> <br>   <font size = 3> PNAD Covid </font>   <br><br> </kbd> </a> <br><br> <small> PNAD Covid </small> <br> <small> 2020 </small>        |  <a href = "#pns"> <kbd> <br>    <font size = 3> PNS </font>    <br><br> </kbd> </a> <br><br> <small> National Health Survey </small> <br> <small> 2013 and 2019 </small>  | <a href = "#pof"> <kbd> <br>    <font size = 3> POF </font>    <br><br> </kbd> </a> <br><br> <small> Consumer Expenditure Survey </small> <br> <small> 1995 to 2018 </small> |

<a href = "#credits">![Static
Badge](https://img.shields.io/badge/Credits%20-%20PUC%20Rio%20Department%20of%20Economics%20-%20blue)
</a> <a href = "#credits"> ![Static
Badge](https://img.shields.io/badge/Citation%20-%20green) </a>

## Censo

The Census (Censo Demográfico) is conducted every ten years by IBGE. All
households in the country are visited by IBGE agents. This survey counts
the population and collects basic information about residents, such as
age and gender.

IBGE also conducts a more detailed interview on a large random sample of
households, investigating household members’ socio-demographic
characteristics (schooling, income etc.), household’s characteristics
(wall materials, plumbing etc.), and possession of physical assets
(refrigerator, car etc.). In the 2010 Census sample, there are 6.2
million households and 20.6 million individuals.

### Microdata

For each year, there is a data file for each unit of the federation
(state). Until 1991, there was only one file for both household and
individual characteristics. Since 2000, there is one file for each type
of record.

Our Census program applies to the 1970, 1980, 1991, 2000 and 2010 rounds
of the Census. The 2000 and 2010 microdata and documentation are
available for download from the IBGE website on [this
link](https://www.ibge.gov.br/estatisticas/sociais/populacao/22827-censo-2020-censo4.html?=&t=microdados).
For information on how to acquire other rounds, [click
here](https://loja.ibge.gov.br/catalogsearch/result/?q=censo).

Because of methodological changes made by IBGE over the years, the same
information may not be available every year and/or may not have been
collected in the same way. Data Zoom offers an option to manipulate the
variables subject to compatibility in order to standardize information
over time. In this case, variable names are not the ones suggested by
the original dictionary and a new dictionary is provided for download.
The document titled [Making Censuses
Compatible](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/Censo/compatibilizacao_en.pdf)
explains all the procedures adopted in the process.

In the 2010 Census, microdata for 14 municipalities were corrected, thus
two new files were released for the observations reviewed. It is
necessary to download, in addition to the file containing the microdata,
the following file
“microdados_14_municipios_com_areas_redefinidas_20160331” available at
[this
link](https://www.ibge.gov.br/estatisticas/sociais/saude/22827-censo-demografico-2022.html?=&t=microdados)
and add it to the same folder where the microdata is located on your
computer.

### Supporting files

- [Microdata and documentation: 2000 and 2010
  Censuses](https://www.ibge.gov.br/estatisticas/sociais/saude/22827-censo-demografico-2022.html?=&t=microdados)
- [Compatibilized
  dictionary](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/Censo/dicionario_compatibilizado.xlsx)

<details>
<summary>
In English:
</summary>

- [Making Censuses
  compatible](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/Censo/compatibilizacao_en.pdf)
- [Censo 1970
  dictionary](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/Censo/dicionario_1970_en.pdf)
- [Censo 1980
  dictionary](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/Censo/dicionario_1980_en.pdf)
- [Censo 1991
  dictionary](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/Censo/dicionario_1991_en.pdf)
- [Censo 2000
  dictionary](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/Censo/dicionario_2000_en.xlsx)
- [Censo 2010
  dictionary](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/Censo/dicionario_2010_en.xls)

</details>
<details>
<summary>
In Portuguese:
</summary>

- [Making Censuses
  compatible](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/Censo/compatibilizacao.pdf)
- [Censo 1970
  dictionary](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/Censo/dicionario_1970.pdf)
- [Censo 1980
  dictionary](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/Censo/dicionario_1980.xlsx)
- [Censo 1991
  dictionary](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/Censo/dicionario_1991.pdf)

</details>

## ECINF

ECINF, the Urban Informal Economy survey, is a sample survey that was
conducted by IBGE in 1997 and 2003 to investigate the informal sector in
Brazil, characterized by self-employed workers and employers running a
business with up to five employees. The main interest of this survey are
businesses’ characteristics, such as operating location (whether it
operates in a store, in a motorized vehicle etc.), type of clientele,
investments made in the previous year, age of the business, etc. In
2003, ECINF’s sample covered 54,595 households, with a total of 195,504
individuals.

### Microdata

Due to the large number of topics investigated, there are several
microdata files in each year. For information on how to acquire the
microdata and other files, [click
here](https://www.ibge.gov.br/estatisticas/sociais/trabalho/9025-economia-informal-urbana.html?=&t=downloads).

### Supporting files

- [Microdata and
  documentation](https://www.ibge.gov.br/estatisticas/sociais/trabalho/9025-economia-informal-urbana.html?=&t=downloads)

</details>
<details>
<summary>
In English:
</summary>

- [ECINF 1997
  dictionary](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/ECINF/dicionario_1997_en.xlsx)
- [ECINF 2003
  dictionary](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/ECINF/dicionario_2003_en.xlsx)

</details>
<details>
<summary>
In Portuguese:
</summary>

- [ECINF 1997
  dictionary](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/ECINF/dicionario_1997.doc)
- [ECINF 2003
  dictionary](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/ECINF/dicionario_2003.xls)

## PME

PME, the Brazilian Monthly Employment Survey, is a sample survey
conducted monthly by IBGE since 1980 in six metropolitan areas: Belo
Horizonte, Porto Alegre, Recife, Rio de Janeiro, Salvador and São Paulo.
The survey collects labor and income information from the population.
PME is mainly used to compute the main unemployment index in the country
(until 2014). It is the only IBGE survey in longitudinal format.
Households are visited for two periods of four consecutive months, eight
months apart from each other. In March 2014, PME’s sample consisted of
33,809 households with 95,122 individuals.

There are two versions of PME, traditionally called by PME Antiga (old
PME) and PME Nova (new PME). The PME Antiga is the original survey. In
2002, this survey underwent a major change in design, giving rise to the
PME Nova, with a significantly larger questionnaire and differences in
the definition of labor market participation, as well as in the rotation
scheme of the samples. Until the end of 2002, the two methodologies were
taken to the field. In December 2002, PME Antiga was closed down and
replaced by PME Nova.

PME is a panel survey, in which each household is interviewed 8 times
over a 16-months period (the household is surveyed for 4 consecutive
months, out for 8, and then returns for another 4 months of interviews).
Households are correctly identified throughout all eight interviews.
However, PME does not assign the same identification number to each
individual in the household across interviews. To reduce attrition
related to this problem, each Data Zoom package offers two
identification algorithms based on [Ribas and Soares
(2008)](https://repositorio.ipea.gov.br/handle/11058/1522). The
algorithms differ essentially according to the number of characteristics
checked in order to identify the same individual across interviews.

PME Nova was discontinued in February 2016 and replaced by the PNAD
Contínua, a quarterly survey started in the first quarter of 2012. The
two surveys coexisted between 2012 and 2016.

### Microdata

PME Antiga microdata files are separated by month, metropolitan area and
type of register (individual and household). PME Nova contains a single
file for each month including individual and household information for
all metropolitan areas.

For PME Nova (March 2002 onwards), all microdata and documentation are
available from [IBGE’s
website](https://www.ibge.gov.br/estatisticas/sociais/trabalho/9183-pesquisa-mensal-de-emprego-antiga-metodologia.html?=&t=microdados).
For information on how to acquire other waves, [click
here](https://loja.ibge.gov.br/catalogsearch/result/?q=pme).

### Supporting files

- [Microdata and documentation: PME
  Nova](https://www.ibge.gov.br/estatisticas/sociais/trabalho/9183-pesquisa-mensal-de-emprego-antiga-metodologia.html?=&t=microdados)
- [Ribas and Soares
  (2008)](https://repositorio.ipea.gov.br/handle/11058/1522)

<details>
<summary>
In English:
</summary>

- PME Antiga dictionaries: 1991 to 2000
  - [Households](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/PME/dicionario_pnad_antiga_1991_2000_dom_en.pdf),
    [Individuals](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/PME/dicionario_pnad_antiga_1991_2000_pess_en.pdf)
- PME Antiga dictionaries: 2001
  - [Households](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/PME/dicionario_pme_antiga_2001_dom_en.pdf),
    [Individuals](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/PME/dicionario_pme_antiga_2001_pess_en.pdf)
- [PME Nova
  dictionary](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/PME/dicionario_pme_nova_en.xls)

</details>
<details>
<summary>
In Portuguese:
</summary>

- [PME Antiga dictionary: 1991 to
  2000](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/PME/dicionario_pnad_antiga_1991_2000.pdf)
- [PME Antiga dictionary:
  2001](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/PME/dicionario_pme_antiga_2001.pdf)
- [PME Nova
  dictionary](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/PME/dicionario_pme_nova.xls)

</details>

## PNAD

PNAD, the Brazilian National Household Sample Survey, is a survey
conducted annually by IBGE since 1981. PNAD investigates several
characteristics of the population such as household composition,
education, labor, income and fertility. Moreover, almost every year,
there is an investigation of an additional topic, such as education,
health, professional training and food security. PNAD’s sample in 2012
consisted of 147,203 households, with 362,451 individuals.

### Microdata

Until 1990, there was only one file for both household and individual
characteristics. Since 1992, there is one file for each type of record.

Our package applies to all surveys starting in 1981. From 2001 onward,
all microdata and documentation are available from [IBGE’s
website](https://www.ibge.gov.br/estatisticas/sociais/populacao/9127-pesquisa-nacional-por-amostra-de-domicilios.html?=&t=microdados).
For information on how to acquire other rounds, [click
here](https://loja.ibge.gov.br/catalogsearch/result/?q=pnad).

Because of changes made over the years, the same information may not be
available every year and/or may not have been collected in the same way.
Specifically, there was a major reformulation of the survey in 1992,
when labor activities were redefined, together with the questionnaire
itself, leading to changes in the names of variables.

Data Zoom offers two options to manipulate the variables in order to
standardize information over time. The first option aims to adapt
variables from the 1990s and 2000s to those from the 1980s. This
implies, for instance, that variables created after 1990 - such as all
variables related to child labor - are excluded in the process. With
this option, variable names are not those suggested by the original
dictionary, so that a new dictionary is provided for download.

The second option attempts to only reconcile variables from 1992 to
2012. In this case, there are relatively few changes during the period.
Therefore, we keep the original names of all variables that did not
change or remained reasonably stable. A new dictionary is also provided.
The document [Making PNADs
compatible](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/PNAD/compatibilizacao_en.pdf)
explains all the procedures adopted in the process.

### Supporting files

- [Microdata and
  documentation](https://www.ibge.gov.br/estatisticas/sociais/populacao/9127-pesquisa-nacional-por-amostra-de-domicilios.html?=&t=microdados)
- [Compatibilized
  dictionary](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/PNAD/dicionario_compatibilizado.xlsx)

<details>
<summary>
In English:
</summary>

- [Making PNADs
  compatible](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/PNAD/compatibilizacao_en.pdf)
- Dicionaries for the 1980s
  - [1981](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/PNAD/dicionario_1981_en.pdf),
    [1982](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/PNAD/dicionario_1982_en.pdf),
    [1983](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/PNAD/dicionario_1983_en.pdf),
    [1984](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/PNAD/dicionario_1984_en.pdf),
    [1985](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/PNAD/dicionario_1985_en.pdf),
    [1986](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/PNAD/dicionario_1986_en.pdf),
    [1987](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/PNAD/dicionario_1987_en.pdf),
    [1988](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/PNAD/dicionario_1988_en.pdf),
    [1989](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/PNAD/dicionario_1989_en.pdf)
- Dicionaries for the 1990s
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
- [Dicionary for 2000-2012
  (Households)](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/PNAD/dicionario_2000s_dom_en.xlsx)
- [Dicionary for 2000-2012
  (Individuals)](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/PNAD/dicionario_2000s_pess_en.xlsx)

</details>
<details>
<summary>
In Portuguese:
</summary>

- [Making PNADs
  compatible](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/PNAD/compatibilizacao.pdf)
- Dicionaries for the 1980s
  - [1981](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/PNAD/dicionario_1981.pdf),
    [1982](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/PNAD/dicionario_1982.pdf),
    [1983](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/PNAD/dicionario_1983.pdf),
    [1984](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/PNAD/dicionario_1984.pdf),
    [1985](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/PNAD/dicionario_1985.pdf),
    [1986](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/PNAD/dicionario_1986.pdf),
    [1987](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/PNAD/dicionario_1987.pdf),
    [1988](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/PNAD/dicionario_1988.pdf),
    [1989](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/PNAD/dicionario_1989.pdf)
- Dicionaries for the 1990s
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
- [Dicionary for 2000-2012
  (Households)](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/PNAD/dicionario_2000s_dom.xlsx)
- [Dicionary for 2000-2012
  (Individuals)](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/PNAD/dicionario_2000s_pess.xlsx)

</details>

## PNAD Contínua

The Continuous National Household Sample Survey, PNAD Contínua, is a
survey conducted by IBGE in order to continuously produce information on
the labor market, tied to demographic and educational characteristics.
Periodically, the survey analyzes permanent additional topics, such as
child labor and other forms of work, fertility and migration, and
supplementary topics about the socioeconomic development of the country.

The survey provides monthly information to a restricted set of labor
force indicators (quarterly for workforce indicators; annually for
permanent and additional topics on workforce; and variable intervals to
additional topics). The monthly data is representative only at national
level and the rest are representative at the following geographical
level: Brazil, Major Regions, Federative Units, 20 metropolitan areas
that contain the Capital Municipalities, municipalities of the Capital
Region and the Developed integrated region of Greater Teresina.

Each quarter, about 211,000 households are interviewed, covering
approximately 16,000 census sectors of 3,500 municipalities. Selected
households are interviewed for five consecutive semesters; the
households are visited every three months. Therefore a survey of panel
data is generated. Progressively, Continuous PNAD replaced job
statistics obtained from the Monthly Employment Survey, PME, and
Brazilian National Household Sample Survey, PNAD.

Our package offers the option to create a panel, i.e., same household
survey in different visits (quarters). This panel is made as PME panels
and have two options: a simple identification or using [Ribas and
Soares](https://www.puc-rio.br/ensinopesq/ccpg/pibic/relatorio_resumo2020/download/relatorios/CCS/ECO/ECO-Maria%20Mittelbach.pdf)
methodology.

### Supporting files

- [Microdata and
  documentation](https://www.ibge.gov.br/estatisticas/multidominio/condicoes-de-vida-desigualdade-e-pobreza/17270-pnad-continua.html?=&t=microdados)
- [Report on the panel identification algorithm (in
  Portuguese)](https://www.puc-rio.br/ensinopesq/ccpg/pibic/relatorio_resumo2020/download/relatorios/CCS/ECO/ECO-Maria%20Mittelbach.pdf)

## PNAD Covid

The PNAD-Covid aims to monitor the estimated number of individuals with
symptoms associated with flu-like illness, typical of Covid-19, and its
impacts on the Brazilian labor market.

PNAD-Covid survey comprises interviews performed monthly. The survey
contemplates questions about the occurrence of the major symptoms of
COVID-19 in all residents of the household. For those who have any
symptoms, the survey asks what they did to relieve the symptoms; if they
sought medical care; and the type of health facility sought.
Additionally, questions are questions about labor and income.

### Supporting files

- [Microdata and
  documentation](https://www.ibge.gov.br/estatisticas/sociais/trabalho/27946-divulgacao-semanal-pnadcovid1.html?=&t=microdados)

## PNS

The National Health Survey, PNS, is a sample survey conducted by IBGE in
2013 in order to investigate household characteristics and aspects of
resident’s health. The research has focused on chronic non-communicable
diseases, lifestyles and access to health care. The sample of PNS
covered 80,281 households with 205,546 individuals.

### Supporting files

- [Microdata and
  documentation](https://www.ibge.gov.br/estatisticas/sociais/saude/9160-pesquisa-nacional-de-saude.html?=&t=microdados)

## POF

POF, the Brazilian Consumer Expenditure Survey, is a household survey
conducted by IBGE in order to investigate the pattern of consumption and
expenditure of the Brazilian population. Households are followed for 12
months. This survey is conducted every six or seven years starting in
1988 and covers the entire national territory. Among other uses, POF
data serves as input for the construction of consumption baskets used to
estimate IBGE consumer price indexes: IPCA (the main consumer price
index in Brazil) and INPC.

POF provides information on individuals (age, level of education and
income) and households (such as existence of sewage, walls, vehicles)
and different records for each type of expenditure for each household
and individual. The type of record depends on the expenditure frequency
and whether the expenditure is computed at the household or the
individual level. The frequency and level in which expenditures are
recorded are defined by IBGE before the interview occurs. Expenditure on
food, for example, is collected through a booklet filled out daily at
the households for seven days. Meanwhile, expenditure on hairdressing
services is recorded individually and refers to a period of 90 days.

### Microdata

There are distinct files for household and individual characteristics,
possession of durable goods, as well as for each type of expenditure.
Our package can read data from the POF editions of 1995-96, 2002-03,
2008-09, and 2017-18. For each, we offer three tools three tools. The
first one reads POF microdata files into Stata without any data
manipulation. The second tool generates a “standard” database which
contains annualized expenditures per household (or consumer unit,
i.e. family, or individual) in all items, where the items are aggregated
according to the IBGE document “Tradutores”. For the two most recent
rounds, in addition to the total amount of expenditure, two variables
are generated: one measuring the total of expenditures paid with credit
and the other measuring the total of expenditures paid in kind
(donations etc.). Finally, the third tool allows the user to create her
own consumption basket and obtain its expenditure value. In this case,
it is possible to obtain expenditures in a more disaggregated level than
those obtained from the standard database.

### Supporting files

- [Microdata and
  documentation](https://www.ibge.gov.br/estatisticas/sociais/populacao/24786-pesquisa-de-orcamentos-familiares-2.html?=&t=microdados)

<details>
<summary>
In English:
</summary>

- POF 1995-96
  - [Dictionary](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/POF/dicionario_1995_en.pdf)
- POF 2002-03
  - [Dictionary](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/POF/dicionario_2002_en.pdf)
  - [Survey
    description](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/POF/descricao_2002_en.pdf)
  - [Variable
    description](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/POF/variaveis_2002_en.xls)
- POF 2008-09
  - [Survey
    description](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/POF/descricao_2008_en.pdf)
  - [Variable
    description](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/POF/variaveis_2008_en.xls)
  - [Translator for food item
    codes](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/POF/tradutor_alimentos_2008_en.pdf)
  - [Translator for expense
    codes](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/POF/tradutor_despesas_2008_en.pdf)
  - [Translator for income
    codes](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/POF/tradutor_renda_2008_en.pdf)

</details>

## Auxiliary Programs (Dictionaries)

Most of the package programs encounter original data stored in *.txt*
format, which requires dictionaries – *.dct* format in Stata – to be
read. The result is a volume of dictionaries that exceeds the 100-file
limit allowed for a Stata package to be installed. Therefore, individual
dictionaries are compressed into a single *.dta* file, read within each
program. Both functions are defined in the file *read_compdct.ado*.

The first program defined in this file is `write_compdct`, which can be
used as follows: after running the *.ado* file to define the function,
simply use the code:

    write_compdct, folder("/folder with dictionaries") saving("/path/dict.dta")

The function then reads all *.dct* files present in the folder and
combines them into the *dict.dta* file, with each dictionary identified
by a variable with its name.

To transform this compressed file back into the original dictionary, we
reccomend using the `read_compdct` program:

    read_compdct, compdct("dict.dta") dict_name("original_dict") out("extracted_dict.dct")

which extracts the *original_dict* from the *dict.dta* file and saves it
as *extracted_dict.dct*. As an example, see the use of this function in
the `datazoom_pnadcontinua` program:

    tempfile dic // Temporary file where the extracted .dct will be saved

    findfile dict.dta // Finds the dict.dta file saved by the package installation
                      // in the /ado/ folder and stores the path to it in the r(fn) 
                      //macro.

    read_compdct, compdct("`r(fn)'") dict_name("pnadcontinua`lang'") out("`dic'")
      // Reads the compacted dict.dta dictionary, extracts the pnadcontinua 
      // dictionary (or pnadcontinua_en, `lang` is empty or "_en"), and saves the 
      // final file in the tempfile dic, which is used to read the data.

For our internal organization, each folder corresponding to a program
stores the dictionaries in the */dct/* sub-folder. All these
dictionaries are also stored together in the */dct/* folder directly,
which is used to generate the *dict.dta* file using `write_compdct`.
Note that no *.dct* files are actually listed in the
*datazoom_social.pkg* file, and therefore, they are not installed on the
user’s computer. Only the *dict.dta* file is sent.

The automated do-file `atualizacao_dict.do` is used to update
`dict.dta`.

## Credits

[Data Zoom](https://www.econ.puc-rio.br/datazoom/)is developed by a team
at the PUC-Rio Department of Economics.

To cite package `datazoom_social`, use:

> Data Zoom (2023). Data Zoom: Simplifying Access To Brazilian
> Microdata.  
> <https://www.econ.puc-rio.br/datazoom/english/index.html>

Or in BibTeX format:

    @Unpublished{DataZoom2023,
        author = {Data Zoom},
        title = {Data Zoom: Simplifying Access To Brazilian Microdata},
        url = {https://www.econ.puc-rio.br/datazoom/english/index.html},
        year = {2023},
    }
