> <a href="http://www.econ.puc-rio.br/datazoom/">__DataZoom:__</a> Desenvolvido pelo Departamento de Economia da Pontifícia Universidade Católica do Rio de Janeiro (PUC-Rio)

# DataZoom Social Stata: 

<!-- badges: start -->
<!-- badges: end -->

<a href="https://github.com/datazoompuc/datazoom_social_Stata"><img src="https://github.com/datazoompuc/datazoom_social_Stata/raw/master/logo.png" align="left" width="140" hspace="10" vspace="6"></a>

O DataZoom Social Stata `datazoom_social` é um pacote que compatibiliza microdados de pesquisas realizadas pelo IBGE. Com o pacote, é possível fazer a leitura de todas as pesquisas domiciliares realizadas pelo IBGE: Censo Demográfico, Pesquisa Nacional por Amostra de Domicílios, Pesquisa Mensal do Emprego, Pesquisa de Orçamentos Familiares e Pesquisa de Economia Informal Urbana.

## Instalação

Para instalar o pacote pelo nosso repositório do GitHub, é necessário o comando `github`. Caso não tenha, instale com:

```
net install github, from("https://haghish.github.io/github/")
```

A instalação do pacote é feita com:

```
github install datazoompuc/datazoom_social_Stata
```

## Syntax

A syntax do pacote pode ser resumida como:

__datazoom_social__ [, *options*]

Onde as [*options*] podem ser:

| Opção             | Descrição                                                               |
|-------------------|-------------------------------------------------------------------------|
| `research(...)`   | Escolha da Pesquisa                                                     |
| `folder1(...)`    | Pasta onde o *raw data* estão salvos                                    |
| `folder2(...)`    | Pasta onde deseja salvar a base de dados gerada pelo Stata              |
| `date(...)`       | Data de referência dos dados compatibilizados                           |
| english           | Para obter variáveis em inglês, colocar essa opção no final do comando  |
| outras opções     | Opções específicas de cada pesquisa, relacionadas abaixo                |

Dado o número de pesquisas e opções relacionadas às pesquisas, recomendamos o uso da nossa Caixa de Diálogo para compatibilização dos dados

## Caixa de Diálogo

XXX

## Opções específicas de cada pesquisa

As opções `research(...)`, `folder1(...)`, `folder2(...)` e `date(...)` são mandatórias. A depender da pesquisa escolhida, outras opções serão requeridas

### PNS

__datazom_social, research(pns)__ *folder1(...) folder2(...) date(...)*

Os anos disponíveis para a PNS são 2013 e 2019. A função da PNS pode ser utilizada diretamente. Ver em `help(datazoom_pns)`

### Censo Demográfico

__datazom_social, research(censo)__ *folder1(...) folder2(...) date(...) state(...)* [*ops*]

Os anos disponíveis para o Censo são 1970, 1980, 1991, 2000 e 2010. Na opção de estado, pode ser colocado a sigla de quantos estados desejar para leitura de dados - ex.: `state(AP MS AM)`. Ainda há as seguintes opções:

| Ops               | Descrição                                                               |
|-------------------|-------------------------------------------------------------------------|
| `pes`             | Extrai dados para Pessoas                                               |
| `fam`             | Extrai dados para Famílias (disponível apenas para o Censo 2000         |
| `dom`             | Extrai dados para Domicílios                                            |
| `both`            | Extrai dados para Pessoas e Domicílios em um mesmo arquivo              |
| `all`             | Extrai dados para todas os tipos de Registro em um mesmo arquivo        |
| `comp`            | Solicita que a compatibilização de variáveis seja executada             |

A função do Censo pode ser utilizada diretamente. Ver em `help(datazoom_censo)`

