
Para a versão em português, clique no escudo abaixo:
<!-- badges: start -->
[![pt-br](https://img.shields.io/badge/lang-pt--br-blue.svg)](https://github.com/datazoompuc/datazoom_social_Stata/blob/English-READ.ME/README.md)
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

The `datazoom_social` package reads and processes microdata from IBGE
surveys. We read all IBGE household surveys into Stata format, as well
as making different Census instances compatible, generating individual
identification for the Continuous PNAD, and much more.

Note: This package does **not** download microdata. You must have the
microdata you want to read already downloaded in order to use this
package. The data are available on the
[IBGE](https://www.ibge.gov.br/en/statistics/downloads-statistics.html?lang=en-GB)
website.

## Installation <a name="instalacao"></a>

Enter the code below in the Stata command line to download and install
the latest version of the package

    net install datazoom_social, from("https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/main/") force

## Usage

All of our functions can be used through interactive dialog boxes. To
access them, type

    db datazoom_social

Across all of our functions, the original microdata must be saved in
your computer for them to work. Our [YouTube
channel](https://www.youtube.com/@datazoom9654/videos) has tutorials
explaining how to use our package.

Click on the buttons below for additional information on each survey.

|  |  |  |  |
|:--:|:--:|:--:|:--:|
| <a href = "#censo"> <kbd> <br>    <font size = 3> Censo </font>    <br><br> </kbd> </a> <br> <br> <small> Demographic Census </small> <br> <small> 1970 to 2010 </small> | <a href = "#ecinf"> <kbd> <br>    <font size = 3> ECINF </font>    <br><br> </kbd> </a> <br><br> <small> Urban Informal Economy </small> <br> <small> 1997 and 2003 </small> | <a href = "#pme"> <kbd> <br>    <font size = 3> PME </font>    <br><br> </kbd> </a> <br><br> <small> Monthly Employment Survey </small> <br> <small> 1990 to 2015 </small> | <a href = "#pnad"> <kbd> <br>    <font size = 3> PNAD </font>    <br><br> </kbd> </a> <br><br> <small> Old PNAD </small> <br> <small> 1981 to 2015 </small> |
| <a href = "#pnad-contínua"> <kbd> <br> <font size = 3> PNAD Contínua </font> <br><br> </kbd> </a> <br><br> <small> Continuous PNAD </small> <br> <small> 2012 to present </small> | <a href = "#pnad-covid"> <kbd> <br>   <font size = 3> PNAD Covid </font>   <br><br> </kbd> </a> <br><br> <small> PNAD Covid </small> <br> <small> 2020 </small> | <a href = "#pns"> <kbd> <br>    <font size = 3> PNS </font>    <br><br> </kbd> </a> <br><br> <small> National Health Survey </small> <br> <small> 2013 and 2019 </small> | <a href = "#pof"> <kbd> <br>    <font size = 3> POF </font>    <br><br> </kbd> </a> <br><br> <small> Consumer Expenditure Survey </small> <br> <small> 1995 to 2018 </small> |

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
of the Census. The microdata and documentation are available for
download from the IBGE website on [this
link](https://www.ibge.gov.br/estatisticas/sociais/populacao/22827-censo-2020-censo4.html?=&t=microdados).

Because of methodological changes made by IBGE over the years, the same
information may not be available every year and/or may not have been
collected in the same way. Data Zoom offers an option to manipulate the
variables subject to compatibility in order to standardize information
over time. In this case, variable names are not the ones suggested by
the original dictionary and a new dictionary is provided for download.
The document titled [Making Censuses
Compatible](https://raw.githubusercontent.com/datazoompuc/datazoom_social_Stata/main/docs/en/Censo/compatibilizacao_en.pdf)
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

There have recently been changes in the availability of microdata from
the 1970, 1980, and 1991 censuses. Previously, they were available only
for purchase, but they are now available for free on the IBGE website.
In addition, this process involved significant changes for the 1991
Census, such as the switch to the .DBF format and the omission of the
household identifier. As a result, Data Zoom had to adjust its code,
primarily to create a new household identifier for the 1991 Census.

It is still possible to process the 1991 Census microdata for those who
have the older data (in .TXT or .DAT format), but it is now also
possible to use the data currently made available by the IBGE on its
official website (in .DBF format).

Expand the section below to view the main changes to the 1991 Census
data import process and the documentation for the new household
identifier constructed by Data Zoom.

<details>

<summary style="font-size:1.5em">

<strong> Reading of the 1991 Census DBF files and Household Identifier
(id_dom) Construction </strong>
</summary>

<h3>

Reading of the 1991 Census DBF files: Overview and Variables
</h3>

Compared to the older version (in .DAT or .TXT format), the DBF data
available on the IBGE website no longer includes the following
variables:

- v0102 Questionnaire ID (household identifier)
- v3041 Men in the family
- v3042 Women in the family
- v0111 Number of men in the household
- v0112 Number of women in the household

Thus, the household identifier is not included in the original .DBF
files and must be reconstructed.

The section below describes the method used in `datazoom_censo` to
identify households (`id_dom`) from the 1991 Census microdata read in
.DBF format.

<h3>

Household Identifier (id_dom) Construction
</h3>

<h4>

Assumptions of the Method
</h4>

The method is based on three assumptions regarding the data structure:

1.  **Sequential Order**: Records for individuals from the same
    household appear in sequence in the file (there is no interleaving
    of records from different households).

2.  **A household changes when any household variable changes:** Records
    for the same household must have identical values for household
    variables. That is, if two consecutive rows belong to the same
    household, they must have exactly the same values for all household
    variables.

3.  **Consecutive observations with the same household data belong to
    the same household:** There are 37 household variables, some of
    which are continuous, such as rent and nominal income; therefore, it
    is extremely unlikely that two consecutive households would have
    exactly the same data for each of the household variables, unless
    they belong to the same household.

Based on this, a new household is identified when **any** of the
following conditions is true, relative to the previous observation
(`_n-1`):

- the municipality changes (`MUNICNUM`);
- the household type changes (`ESPECIE`);
- the individual lives alone (`PARENDOM == 20`) — in this case, a new
  household is forced regardless of the other variables;
- any of the household variables listed below changes.

<h4>

Code (Stata)
</h4>

``` stata

gen long id_dom = sum( ///
      (MUNICNUM != MUNICNUM[_n-1])  | /// municipality changes
      (ESPECIE  != ESPECIE[_n-1])   | /// household type changes
      (PARENDOM == 20)              | /// individual lives alone
      (RDOMICIV != RDOMICIV[_n-1])  | (ALUGUEL  != ALUGUEL[_n-1])  | ///
      (PESO     != PESO[_n-1])      | (DEMODORM != DEMODORM[_n-1]) | ///
      (COMBCOZI != COMBCOZI[_n-1])  | (AGUA     != AGUA[_n-1])     | ///
      (ALUGUEFX != ALUGUEFX[_n-1])  | (ASPIRPO  != ASPIRPO[_n-1])  | ///
      (AUTPART  != AUTPART[_n-1])   | (AUTTRAB  != AUTTRAB[_n-1])  | ///
      (BANHEIRO != BANHEIRO[_n-1])  | (CD107    != CD107[_n-1])    | ///
      (COBERTUR != COBERTUR[_n-1])  | (COMODOR  != COMODOR[_n-1])  | ///
      (COMODOS  != COMODOS[_n-1])   | (CONDOCUP != CONDOCUP[_n-1]) | ///
      (DEMOCOFX != DEMOCOFX[_n-1])  | (DEMOCOMO != DEMOCOMO[_n-1]) | ///
      (DEMODOFX != DEMODOFX[_n-1])  | (FILTRO   != FILTRO[_n-1])   | ///
      (FREEZER  != FREEZER[_n-1])   | (GELADEIR != GELADEIR[_n-1]) | ///
      (ILUMINA  != ILUMINA[_n-1])   | (LIXO     != LIXO[_n-1])     | ///
      (LOCALIZA != LOCALIZA[_n-1])  | (MAQLAVAR != MAQLAVAR[_n-1]) | ///
      (PAREDES  != PAREDES[_n-1])   | (RADIO    != RADIO[_n-1])    | ///
      (RDONOMIF != RDONOMIF[_n-1])  | (RDOREALF != RDOREALF[_n-1]) | ///
      (SANESCOA != SANESCOA[_n-1])  | (SANUSO   != SANUSO[_n-1])   | ///
      (TELEFONE != TELEFONE[_n-1])  | (TVCORES  != TVCORES[_n-1])  | ///
      (TVPRETO  != TVPRETO[_n-1]) )
```

More specific information about each of these variables can be found in
the [dictionary provided by
IBGE](https://github.com/datazoompuc/datazoom_social_Stata/blob/main/docs/en/Censo/dicionario_1991_dbf_en.xlsx).

<h4>

How `sum()` works
</h4>

`sum()` in Stata is a cumulative sum. Each condition within parentheses
is a binary expression (0/1). Whenever **at least one** condition is
true in row `_n`, the result of the Boolean sum for that row is 1, which
increases the cumulative total—thus creating a new value for `id_dom`.
When no conditions are true, the cumulative total remains the same as in
the previous row, and the observation is assigned to the same household.

In the first observation of the dataset (`_n-1` does not exist), Stata
treats the components `X[_n-1]` as *missing*, and any comparison with
*missing* returns true—which ensures that the first row always starts a
new household (`id_dom == 1`).

<h4>

Comparison of distinct identifiers generated using the constructed
Household Identifier (id_dom) and the original identifier
</h4>

The following table shows the number of households based on the .DBF
data using the household identifier generated by Data Zoom and compares
it with the number of households based on the .DAT data using the
original IBGE household identifier (available only in the .DAT data):

| State | IBGE State Code | .DBF (Data Zoom) | .DAT (Original) | Difference | % Difference |
|----|----|----|----|----|----|
| Rondônia | 11 | 26,859 | 26,850 | 9 | 0.0335% |
| Acre | 12 | 9,824 | 9,824 | 0 | 0.0000% |
| Amazonas | 13 | 45,583 | 45,583 | 0 | 0.0000% |
| Roraima | 14 | 5,485 | 5,486 | -1 | -0.0182% |
| Pará | 15 | 103,849 | 103,849 | 0 | 0.0000% |
| Amapá | 16 | 6,073 | 6,073 | 0 | 0.0000% |
| Tocantins | 17 | 29,801 | 29,801 | 0 | 0.0000% |
| Maranhão | 21 | 105,843 | 105,841 | 2 | 0.0019% |
| Piauí | 22 | 66,477 | 66,477 | 0 | 0.0000% |
| Ceará | 23 | 151,181 | 151,181 | 0 | 0.0000% |
| Rio Grande do Norte | 24 | 72,051 | 72,051 | 0 | 0.0000% |
| Paraíba | 25 | 89,691 | 89,692 | -1 | -0.0011% |
| Pernambuco | 26 | 172,781 | 172,781 | 0 | 0.0000% |
| Alagoas | 27 | 61,493 | 61,493 | 0 | 0.0000% |
| Sergipe | 28 | 42,139 | 42,139 | 0 | 0.0000% |
| Bahia | 29 | 306,696 | 306,697 | -1 | -0.0003% |
| Minas Gerais | 31 | 462,237 | 462,239 | -2 | -0.0004% |
| Espírito Santo | 32 | 70,507 | 70,507 | 0 | 0.0000% |
| Rio de Janeiro | 33 | 357,009 | 357,010 | -1 | -0.0003% |
| São Paulo | 35 | 879,368 | 879,371 | -3 | -0.0003% |
| Paraná | 41 | 249,309 | 249,310 | -1 | -0.0004% |
| Santa Catarina | 42 | 141,031 | 141,032 | -1 | -0.0007% |
| Rio Grande do Sul | 43 | 292,564 | 292,564 | 0 | 0.0000% |
| Mato Grosso do Sul | 50 | 52,966 | 52,966 | 0 | 0.0000% |
| Mato Grosso | 51 | 60,831 | 60,831 | 0 | 0.0000% |
| Goiás | 52 | 124,488 | 124,488 | 0 | 0.0000% |
| Brasília (DF) | 53 | 38,407 | 38,407 | 0 | 0.0000% |

The slight difference observed indicates that the household identifier
generated by Data Zoom is able to replicate the original household
identifier with a high degree of accuracy.

<h4>

Limitations and points to note
</h4>

- The method relies on the dataset being **properly sorted** before
  being passed to the program, that is, with observations belonging to
  the same household appearing consecutively in the dataset. Any
  disruption to this sequential ordering may result in spurious
  households. At the time of writing (July 2026), the original IBGE
  datasets are already sorted in this way.

- If two different households in the same municipality, by coincidence,
  have identical values for **all** household variables, the residents
  do not live alone, and they appear consecutively in the file, the
  program will treat them as a single household (false negative).

- If there is an error in the data such that people from the same
  household have different household information, this error will result
  in one more household than there should be (false positive).

------------------------------------------------------------------------

</details>

### Supporting files

- [Microdata and documentation: 2000 and 2010
  Censuses](https://www.ibge.gov.br/estatisticas/sociais/saude/22827-censo-demografico-2022.html?=&t=microdados)
- [Compatibilized
  dictionary](https://raw.githubusercontent.com/datazoompuc/datazoom_social_Stata/main/docs/pt/Censo/dicionario_compatibilizado.xlsx)

<details>

<summary>

In English:
</summary>

- <details>

  <summary>

  Dictionaries and Compatibilization
  </summary>

  - [Making Censuses
    compatible](https://raw.githubusercontent.com/datazoompuc/datazoom_social_Stata/main/docs/en/Censo/compatibilizacao_en.pdf)
  - [Censo 1970
    dictionary](https://raw.githubusercontent.com/datazoompuc/datazoom_social_Stata/main/docs/en/Censo/dicionario_1970_en.pdf)
  - [Censo 1980
    dictionary](https://raw.githubusercontent.com/datazoompuc/datazoom_social_Stata/main/docs/en/Censo/dicionario_1980_en.pdf)
  - [Censo 1991
    dictionary](https://raw.githubusercontent.com/datazoompuc/datazoom_social_Stata/main/docs/en/Censo/dicionario_1991_en.pdf)
  - [Censo 2000
    dictionary](https://raw.githubusercontent.com/datazoompuc/datazoom_social_Stata/main/docs/en/Censo/dicionario_2000_en.xlsx)
  - [Censo 2010
    dictionary](https://raw.githubusercontent.com/datazoompuc/datazoom_social_Stata/main/docs/en/Censo/dicionario_2010_en.xls)

  </details>

- <details>

  <summary>

  Questionnaires
  </summary>

  - [Questionário Censo
    1970](https://raw.githubusercontent.com/datazoompuc/datazoom_social_Stata/main/docs/en/Censo/Questionario%20da%20Amostra_1970.pdf)
  - [Questionário Censo
    1980](https://raw.githubusercontent.com/datazoompuc/datazoom_social_Stata/main/docs/en/Censo/Questionario%20da%20Amostra_1980.pdf)
  - [Questionário Censo
    1991](https://raw.githubusercontent.com/datazoompuc/datazoom_social_Stata/main/docs/en/Censo/Question%C3%A1rio%20da%20Amostra_1991.pdf)
  - [Questionário Censo
    2000](https://raw.githubusercontent.com/datazoompuc/datazoom_social_Stata/main/docs/en/Censo/Questionario%20da%20Amostra_2000.pdf)
  - [Questionário Censo
    2010](https://raw.githubusercontent.com/datazoompuc/datazoom_social_Stata/main/docs/en/Censo/Questionario%20da%20Amostra_2010.pdf)
  - [Questionário Censo
    2022](https://raw.githubusercontent.com/datazoompuc/datazoom_social_Stata/main/docs/en/Censo/Questionario%20da%20Amostra_2022.pdf)

  </details>

- <details>

  <summary>

  Census Taker Manuals
  </summary>

  - [Manual do Recenseador Censo
    1970](https://raw.githubusercontent.com/datazoompuc/datazoom_social_Stata/main/docs/en/Censo/Manual%20do%20Recenseador_1970.pdf)
  - [Manual do Recenseador Censo
    1980](https://raw.githubusercontent.com/datazoompuc/datazoom_social_Stata/main/docs/en/Censo/Manual%20do%20Recenseador_1980.pdf)
  - [Manual do Recenseador Censo
    1991](https://raw.githubusercontent.com/datazoompuc/datazoom_social_Stata/main/docs/en/Censo/Manual%20do%20Recenseador_1991.pdf)
  - [Manual do Recenseador Censo
    2000](https://raw.githubusercontent.com/datazoompuc/datazoom_social_Stata/main/docs/en/Censo/Manual%20do%20Recenseador_2000.pdf)
  - [Manual do Recenseador Censo
    2010](https://raw.githubusercontent.com/datazoompuc/datazoom_social_Stata/main/docs/en/Censo/Manual%20do%20Recenseador_2010.pdf)
  - [Manual do Recenseador Censo
    2022](https://raw.githubusercontent.com/datazoompuc/datazoom_social_Stata/main/docs/en/Censo/Manual%20do%20Recenseador_2022.pdf)

  </details>

</details>

<details>

<summary>

In Portuguese:
</summary>

- <details>

  <summary>

  Dicionários e Compatibilização
  </summary>

  - [Compatibilização dos
    Censos](https://raw.githubusercontent.com/datazoompuc/datazoom_social_Stata/main/docs/pt/Censo/compatibilizacao.pdf)
  - [Dicionário Censo
    1970](https://raw.githubusercontent.com/datazoompuc/datazoom_social_Stata/main/docs/pt/Censo/dicionario_1970.pdf)
  - [Dicionário Censo
    1980](https://raw.githubusercontent.com/datazoompuc/datazoom_social_Stata/main/docs/pt/Censo/dicionario_1980.xlsx)
  - [Dicionário Censo
    1991](https://raw.githubusercontent.com/datazoompuc/datazoom_social_Stata/main/docs/pt/Censo/dicionario_1991.pdf)
  - [Dicionário Censo
    2000](https://raw.githubusercontent.com/datazoompuc/datazoom_social_Stata/main/docs/pt/Censo/dicionario_2000.xlsx)
  - [Dicionário Censo
    2010](https://raw.githubusercontent.com/datazoompuc/datazoom_social_Stata/main/docs/pt/Censo/dicionario_2010.xls)

  </details>

- <details>

  <summary>

  Questionários
  </summary>

  - [Questionário Censo
    1970](https://raw.githubusercontent.com/datazoompuc/datazoom_social_Stata/main/docs/pt/Censo/Questionario%20da%20Amostra_1970.pdf)
  - [Questionário Censo
    1980](https://raw.githubusercontent.com/datazoompuc/datazoom_social_Stata/main/docs/pt/Censo/Questionario%20da%20Amostra_1980.pdf)
  - [Questionário Censo
    1991](https://raw.githubusercontent.com/datazoompuc/datazoom_social_Stata/main/docs/pt/Censo/Question%C3%A1rio%20da%20Amostra_1991.pdf)
  - [Questionário Censo
    2000](https://raw.githubusercontent.com/datazoompuc/datazoom_social_Stata/main/docs/pt/Censo/Questionario%20da%20Amostra_2000.pdf)
  - [Questionário Censo
    2010](https://raw.githubusercontent.com/datazoompuc/datazoom_social_Stata/main/docs/pt/Censo/Questionario%20da%20Amostra_2010.pdf)
  - [Questionário Censo
    2022](https://raw.githubusercontent.com/datazoompuc/datazoom_social_Stata/main/docs/pt/Censo/Questionario%20da%20Amostra_2022.pdf)

  </details>

- <details>

  <summary>

  Manuais do Recenseador
  </summary>

  - [Manual do Recenseador Censo
    1970](https://raw.githubusercontent.com/datazoompuc/datazoom_social_Stata/main/docs/pt/Censo/Manual%20do%20Recenseador_1970.pdf)
  - [Manual do Recenseador Censo
    1980](https://raw.githubusercontent.com/datazoompuc/datazoom_social_Stata/main/docs/pt/Censo/Manual%20do%20Recenseador_1980.pdf)
  - [Manual do Recenseador Censo
    1991](https://raw.githubusercontent.com/datazoompuc/datazoom_social_Stata/main/docs/pt/Censo/Manual%20do%20Recenseador_1991.pdf)
  - [Manual do Recenseador Censo
    2000](https://raw.githubusercontent.com/datazoompuc/datazoom_social_Stata/main/docs/pt/Censo/Manual%20do%20Recenseador_2000.pdf)
  - [Manual do Recenseador Censo
    2010](https://raw.githubusercontent.com/datazoompuc/datazoom_social_Stata/main/docs/pt/Censo/Manual%20do%20Recenseador_2010.pdf)
  - [Manual do Recenseador Censo
    2022](https://raw.githubusercontent.com/datazoompuc/datazoom_social_Stata/main/docs/pt/Censo/Manual%20do%20Recenseador_2022.pdf)

  </details>

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

</details>

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
  - [Households](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/PME/dicionario_pme_antiga_1991_2000_dom_en.pdf),
    [Individuals](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/PME/dicionario_pme_antiga_1991_2000_pess_en.pdf)
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
  2000](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/PME/dicionario_pme_antiga_1991_2000.pdf)
- [PME Antiga dictionary:
  2001](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/PME/dicionario_pme_antiga_2001.pdf)
- [PME Nova
  dictionary](https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/docs/PME/dicionario_pme_nova.xls)

</details>

## PNAD

PNAD, the Brazilian National Household Sample Survey, is a survey that
used to be conducted annually by IBGE since 1967. PNAD investigates
several characteristics of the population such as household composition,
education, labor, income and fertility. Moreover, almost every year,
there is an investigation of an additional topic, such as education,
health, professional training and food security. PNAD’s sample in 2013
consisted of 148,697 households, with 362,555 individuals.

### Microdata

Until 1990, there was only one file for both household and individual
characteristics. Since 1992, there is one file for each type of record.

Our package applies to all surveys starting in 1981. From 1976 onward,
all microdata and documentation are available from [IBGE’s
website](https://www.ibge.gov.br/estatisticas/sociais/populacao/9127-pesquisa-nacional-por-amostra-de-domicilios.html?=&t=microdados).

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
compatible](https://github.com/datazoompuc/datazoom_social_Stata/blob/main/docs/en/PNAD/compatibilizacao_en.pdf)
explains all the procedures adopted in the process.

### Supporting files

- [Microdata and
  documentation](https://www.ibge.gov.br/estatisticas/sociais/populacao/9127-pesquisa-nacional-por-amostra-de-domicilios.html?=&t=microdados)
- [Compatibilized
  dictionary](https://github.com/datazoompuc/datazoom_social_Stata/blob/main/docs/en/PNAD/dicionario_compatibilizado.xlsx)

<details>

<summary>

In English:
</summary>

- [Making PNADs
  compatible](https://github.com/datazoompuc/datazoom_social_Stata/blob/main/docs/en/PNAD/compatibilizacao_en.pdf)
- Dictionaries for the 1980s
  - [1981](https://github.com/datazoompuc/datazoom_social_Stata/blob/main/docs/en/PNAD/dicionario_1981_en.pdf),
    [1982](https://github.com/datazoompuc/datazoom_social_Stata/blob/main/docs/en/PNAD/dicionario_1982_en.pdf),
    [1983](https://github.com/datazoompuc/datazoom_social_Stata/blob/main/docs/en/PNAD/dicionario_1983_en.pdf),
    [1984](https://github.com/datazoompuc/datazoom_social_Stata/blob/main/docs/en/PNAD/dicionario_1984_en.pdf),
    [1985](https://github.com/datazoompuc/datazoom_social_Stata/blob/main/docs/en/PNAD/dicionario_1985_en.pdf),
    [1986](https://github.com/datazoompuc/datazoom_social_Stata/blob/main/docs/en/PNAD/dicionario_1986_en.pdf),
    [1987](https://github.com/datazoompuc/datazoom_social_Stata/blob/main/docs/en/PNAD/dicionario_1987_en.pdf),
    [1988](https://github.com/datazoompuc/datazoom_social_Stata/blob/main/docs/en/PNAD/dicionario_1988_en.pdf),
    [1989](https://github.com/datazoompuc/datazoom_social_Stata/blob/main/docs/en/PNAD/dicionario_1989_en.pdf)
- Dictionaries for the 1990s
  - [1990](https://github.com/datazoompuc/datazoom_social_Stata/blob/main/docs/en/PNAD/dicionario_1990_en.pdf),
    [1992-1995
    (Households)](https://github.com/datazoompuc/datazoom_social_Stata/blob/main/docs/en/PNAD/dicionario_1992_1995_dom_en.pdf),
    [1992-1995
    (Individuals)](https://github.com/datazoompuc/datazoom_social_Stata/blob/main/docs/en/PNAD/dicionario_1992_1995_pess_en.pdf),
    [1996
    (Individuals)](https://github.com/datazoompuc/datazoom_social_Stata/blob/main/docs/en/PNAD/dicionario_1996_pess_en.pdf),
    [1996-1997
    (Households)](https://github.com/datazoompuc/datazoom_social_Stata/blob/main/docs/en/PNAD/dicionario_1996_1997_dom_en.pdf),
    [1997
    (Individuals)](https://github.com/datazoompuc/datazoom_social_Stata/blob/main/docs/en/PNAD/dicionario_1997_pess_en.pdf),
    [1998
    (Individuals)](https://github.com/datazoompuc/datazoom_social_Stata/blob/main/docs/en/PNAD/dicionario_1998_pess_en.pdf),
    [1998-1999
    (Households)](https://github.com/datazoompuc/datazoom_social_Stata/blob/main/docs/en/PNAD/dicionario_1998_1999_dom_en.pdf),
    [1999
    (Individuals)](https://github.com/datazoompuc/datazoom_social_Stata/blob/main/docs/en/PNAD/dicionario_1999_pess_en.pdf)
- [Dictionary for 2000-2012
  (Households)](https://github.com/datazoompuc/datazoom_social_Stata/blob/main/docs/en/PNAD/dicionario_2000s_dom_en.xlsx)
- [Dictionary for 2000-2012
  (Individuals)](https://github.com/datazoompuc/datazoom_social_Stata/blob/main/docs/en/PNAD/dicionario_2000s_pess_en.xlsx)

</details>

<details>

<summary>

In Portuguese:
</summary>

- [Making PNADs
  compatible](https://github.com/datazoompuc/datazoom_social_Stata/blob/main/docs/pt/PNAD/compatibilizacao.pdf)
- Dictionaries for the 1980s
  - [1981](https://github.com/datazoompuc/datazoom_social_Stata/blob/main/docs/pt/PNAD/dicionario_1981.pdf),
    [1982](https://github.com/datazoompuc/datazoom_social_Stata/blob/main/docs/pt/PNAD/dicionario_1982.pdf),
    [1983](https://github.com/datazoompuc/datazoom_social_Stata/blob/main/docs/pt/PNAD/dicionario_1983.pdf),
    [1984](https://github.com/datazoompuc/datazoom_social_Stata/blob/main/docs/pt/PNAD/dicionario_1984.pdf),
    [1985](https://github.com/datazoompuc/datazoom_social_Stata/blob/main/docs/pt/PNAD/dicionario_1985.pdf),
    [1986](https://github.com/datazoompuc/datazoom_social_Stata/blob/main/docs/pt/PNAD/dicionario_1986.pdf),
    [1987](https://github.com/datazoompuc/datazoom_social_Stata/blob/main/docs/pt/PNAD/dicionario_1987.pdff),
    [1988](https://github.com/datazoompuc/datazoom_social_Stata/blob/main/docs/pt/PNAD/dicionario_1988.pdf),
    [1989](https://github.com/datazoompuc/datazoom_social_Stata/blob/main/docs/pt/PNAD/dicionario_1989.pdf)
- Dictionaries for the 1990s
  - [1990](https://github.com/datazoompuc/datazoom_social_Stata/blob/main/docs/pt/PNAD/dicionario_1990.pdf),
    [1992-1995
    (Households)](https://github.com/datazoompuc/datazoom_social_Stata/blob/main/docs/pt/PNAD/dicionario_1992_1995_dom.pdf),
    [1992-1995
    (Individuals)](https://github.com/datazoompuc/datazoom_social_Stata/blob/main/docs/pt/PNAD/dicionario_1992_1995_pess.pdf),
    [1996
    (Individuals)](https://github.com/datazoompuc/datazoom_social_Stata/blob/main/docs/pt/PNAD/dicionario_1996_pess.pdf),
    [1996-1997
    (Households)](https://github.com/datazoompuc/datazoom_social_Stata/blob/main/docs/pt/PNAD/dicionario_1996_1997_dom.pdf),
    [1997
    (Individuals)](https://github.com/datazoompuc/datazoom_social_Stata/blob/main/docs/pt/PNAD/dicionario_1997_pess.pdf),
    [1998
    (Individuals)](https://github.com/datazoompuc/datazoom_social_Stata/blob/main/docs/pt/PNAD/dicionario_1998_pess.pdf),
    [1998-1999
    (Households)](https://github.com/datazoompuc/datazoom_social_Stata/blob/main/docs/pt/PNAD/dicionario_1998_1999_dom.pdf),
    [1999
    (Individuals)](https://github.com/datazoompuc/datazoom_social_Stata/blob/main/docs/pt/PNAD/dicionario_1999_pess.pdf)
- [Dictionary for 2000-2012
  (Households)](https://github.com/datazoompuc/datazoom_social_Stata/blob/main/docs/pt/PNAD/dicionario_2000s_dom.xlsx)
- [Dictionary for 2000-2012
  (Individuals)](https://github.com/datazoompuc/datazoom_social_Stata/blob/main/docs/pt/PNAD/dicionario_2000s_pess.xlsx)

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
