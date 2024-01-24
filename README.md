
<a href="https://github.com/datazoompuc/datazoom_social_Stata"><img src="https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/logo.jpg" align="left" width="100" hspace="10" vspace="6"></a>

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
de todas as pesquisas domiciliares realizadas pelo IBGE: Censo
Demográfico, Pesquisa Nacional por Amostra de Domicílios, Pesquisa
Mensal do Emprego, Pesquisa de Orçamentos Familiares e Pesquisa de
Economia Informal Urbana.

## Instalação <a name="instalacao"></a>

Digite o código abaixo na linha de comando do Stata para baixar e
instalar a versão mais recente do pacote

    net install datazoom_social, from("https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/") force

## Uso

Todas as funções do pacote podem ser usadas pelas caixas de diálogo.
Para acessá-las, digite o comando

    db datazoom_social

Clique nos botões abaixo para ir à explicação de cada função.

|                                                                                                                                                                                    |                                                                                                                                                                 |                                                                                                                                                             |                                                                                                                                                                    |
|:----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------:|:---------------------------------------------------------------------------------------------------------------------------------------------------------------:|:-----------------------------------------------------------------------------------------------------------------------------------------------------------:|:------------------------------------------------------------------------------------------------------------------------------------------------------------------:|
| <a href = "#censo-demográfico"> <kbd> <br>    <font size = 3> Censo </font>    <br><br> </kbd> </a> <br> <br> <small> Censo Demográfico </small> <br> <small> 1970 a 2010 </small> |  [<kbd> <br>    <font size = 3> ECINF </font>    <br><br> </kbd>](#ecinf) <br><br> <small> Economia Informal Urbana </small> <br> <small> 1997 e 2003 </small>  | [<kbd> <br>    <font size = 3> PME </font>    <br><br> </kbd>](#pme) <br><br> <small> Pesquisa Mensal de Emprego </small> <br> <small> 1990 a 2015 </small> |           [<kbd> <br>    <font size = 3> PNAD </font>    <br><br> </kbd>](#pnad) <br><br> <small> PNAD Antiga </small> <br> <small> 2001 a 2015 </small>           |
|    <a href = "#pnad-contínua"> <kbd> <br> <font size = 3> PNAD Contínua </font> <br><br> </kbd> </a> <br><br> <small> PNAD Contínua </small> <br> <small> 2012 a 2023 </small>     | <a href = "#pnad-covid"> <kbd> <br>   <font size = 3> PNAD Covid </font>   <br><br> </kbd> </a> <br><br> <small> PNAD Covid </small> <br> <small> 2020 </small> | [<kbd> <br>    <font size = 3> PNS </font>    <br><br> </kbd>](#pns) <br><br> <small> Pesquisa Nacional de Saúde </small> <br> <small> 2013 e 2019 </small> | [<kbd> <br>    <font size = 3> POF </font>    <br><br> </kbd>](#pof) <br><br> <small> Pesquisa de Orçamentos Familiares </small> <br> <small> 1995 a 2018 </small> |

<a href = "#créditos">![Static
Badge](https://img.shields.io/badge/Cr%C3%A9ditos%20-%20Departamento%20de%20Economia%20PUC%20Rio%20-%20blue)
</a> <a href = "#créditos"> ![Static
Badge](https://img.shields.io/badge/Cita%C3%A7%C3%A3o%20-%20green) </a>

## Censo Demográfico

![](dlg/censo.png)

## ECINF

![](dlg/ecinf.png)

## PME

![](dlg/pme.png)

## PNAD

![](dlg/pnad.png)

## PNAD Contínua

![](dlg/pnadcont_anual.png) ![](dlg/pnadcont_trimestral.png)

## PNAD Covid

![](dlg/pnad_covid.png)

## PNS

![](dlg/pns.png)

## POF

![](dlg/pof.png)

## Programas Auxiliares (Dicionários)

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
