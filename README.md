> <a href="http://www.econ.puc-rio.br/datazoom/">__DataZoom:__</a> Desenvolvido pelo Departamento de Economia da Pontifícia Universidade Católica do Rio de Janeiro (PUC-Rio)

# DataZoom Social Stata: 

<!-- badges: start -->
<!-- badges: end -->

<a href="https://github.com/datazoompuc/datazoom_social_Stata"><img src="https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/logo.jpg" align="left" width="140" hspace="10" vspace="6"></a>

O DataZoom Social Stata `datazoom_social` é um pacote que compatibiliza microdados de pesquisas realizadas pelo IBGE. Com o pacote, é possível fazer a leitura de todas as pesquisas domiciliares realizadas pelo IBGE: Censo Demográfico, Pesquisa Nacional por Amostra de Domicílios, Pesquisa Mensal do Emprego, Pesquisa de Orçamentos Familiares e Pesquisa de Economia Informal Urbana.

## Instalação

Digite o código abaixo na linha de comando do Stata para baixar e instalar os arquivos referente ao pacote DataZoom Social 

```
net install datazoom_social1, from("https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/") replace
net install datazoom_social2, from("https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/") replace
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

___Atenção:___ Dado o número de pesquisas e opções relacionadas às mesmas, recomendamos o uso da nossa Caixa de Diálogo para compatibilização dos dados

## Caixa de Diálogo

A Caixa de Diálogo do pacote pode ser acessada utilizando o seguinte comando: `db datazoom_social`. A seguinte janela se abrirá:

<a href="https://github.com/datazoompuc/datazoom_social_Stata"><img src="https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/dlg.jpg" align="center" width="140" hspace="10" vspace="6"></a>

Basta navegar pelas opções da Caixa de Diálogo para fazer as leituras dos microdados do IBGE.

## Opções específicas de cada pesquisa

As opções `research(...)`, `folder1(...)`, `folder2(...)` e `date(...)` são mandatórias. A depender da pesquisa escolhida, outras opções serão requeridas

### PNS

__datazom_social, research(pns)__ *folder1(...) folder2(...) date(...)*

Os anos disponíveis para a PNS são 2013 e 2019. A função da PNS pode ser utilizada diretamente. Ver `h datazoom_pns`

### Censo Demográfico

__datazom_social, research(censo)__ *folder1(...) folder2(...) date(...) state(...)* [*ops*]

Os anos disponíveis para o Censo são 1970, 1980, 1991, 2000 e 2010. Na opção de estado, pode ser colocado a sigla de quantos estados desejar para leitura de dados - ex.: `state(AP MS AM)`. Ainda há as seguintes opções:

| Ops               | Descrição                                                               |
|-------------------|-------------------------------------------------------------------------|
| `pes`             | Extrai dados para Pessoas                                               |
| `fam`             | Extrai dados para Famílias (disponível apenas para o Censo 2000)         |
| `dom`             | Extrai dados para Domicílios                                            |
| `both`            | Extrai dados para Pessoas e Domicílios em um mesmo arquivo              |
| `all`             | Extrai dados para todas os tipos de Registro em um mesmo arquivo        |
| `comp`            | Solicita que a compatibilização de variáveis seja executada             |

A função do Censo pode ser utilizada diretamente. Ver `h datazoom_censo`

### PNAD Contínua (PNADC) - Divulgação Anual

__datazom_social, research(pnadcontinua_anual)__ *folder1(...) folder2(...) date(...)*

Essa função compatibiliza os microdados referente a visita domiciliar específica de um ano. Os anos disponíveis para a PNADC Anual são de 2012 a 2019. A função da PNADC Anual pode ser utilizada diretamente. Ver `h datazoom_pnadcont_anual`

___Atenção:___ Na opção `folder1(...)` deve conter o caminho específico do arquivo com os microdados


### PNAD Contínua (PNADC) - Divulgação Trimestral

__datazom_social, research(pnadcontinua)__ *folder1(...) folder2(...) date(...)* [*ops*]

Os anos disponíveis para a PNADC Trimestral são de 2012 a 2021 (primeiro trimestre para este último ano). Para criação do painél, há as seguintes opções:

| Ops               | Descrição                                                               |
|-------------------|-------------------------------------------------------------------------|
| `nid`             | Sem identificação                                              |
| `idbas`             |  Identificação básica                |
| `idrs`             | Identificação Avançada (Metodologia Ribas e Soares)     |

Para criaçao do painel, os arquivos de microdados de todos os trimestres dos anos de interesse devem estar na pasta `folderl(...)`. A função da PNADC Trimestral pode ser utilizada diretamente. Ver `h datazoom_pnadcontinua`


### PNAD

__datazom_social, research(pnad)__ *folder1(...) folder2(...) date(...)* [*ops*]

Os anos disponíveis para a PNAD são de 1981 a 2015, quando foi descontinuada. Ainda há as seguintes opções:

| Ops               | Descrição                                                               |
|-------------------|-------------------------------------------------------------------------|
| `pes`             | Extrai dados para Pessoas                                               |
| `dom`             | Extrai dados para Domicílios                                            |
| `both`            | Extrai dados para Pessoas e Domicílios em um mesmo arquivo              |
| `ncomp`             | Solicita que compatibilização de variáveis **não** seja executada        |
| `comp81`             | Solicita que variáveis sejam compatíveis com os anos 1980        |
| `comp92`            | Solicita que variáveis sejam compatíveis com os anos 1990 (opção não válida para variáveis dos anos 1980)            |

A função da PNAD pode ser utilizada diretamente. Ver `h datazoom_pnad`


### PNAD Covid

__datazom_social, research(pnad_covid)__ *folder1(...) folder2(...) date(...)*

Os períodos disponíveis para a PNAD Covid são de Maio até Novembro de 2020. A função da PNAD Covid pode ser utilizada diretamente. Ver `h datazoom_pnad_covid`


### PME Nova

__datazom_social, research(pmenova)__ *folder1(...) folder2(...) date(...)* [*ops*]

Os anos disponíveis para a PME são de 2002 a 2016. Para criação do painél, há as seguintes opções:

| Ops               | Descrição                                                               |
|-------------------|-------------------------------------------------------------------------|
| `nid`             | Sem identificação                                              |
| `idbas`             |  Identificação básica                |
| `idrs`             | Identificação Avançada (Metodologia Ribas e Soares)     |

Para criaçao do painel, os arquivos de microdados de todos os meses dos anos de interesse devem estar na pasta `folderl(...)`. A função da PME pode ser utilizada diretamente. Ver `h datazoom_pmenova`


### PME Antiga

__datazom_social, research(pmeantiga)__ *folder1(...) folder2(...) date(...)* [*ops*]

Os anos disponíveis para a PME são de 1991 a 2001. Para criação do painél, há as seguintes opções:

| Ops               | Descrição                                                               |
|-------------------|-------------------------------------------------------------------------|
| `nid`             | Sem identificação                                              |
| `idbas`             |  Identificação básica                |
| `idrs`             | Identificação Avançada (Metodologia Ribas e Soares)     |

Para criaçao do painel, os arquivos de microdados de todos os meses dos anos de interesse devem estar na pasta `folderl(...)`. A função da PME pode ser utilizada diretamente. Ver `h datazoom_pmeantiga`


### ENCIF

__datazom_social, research(ecinf)__ *folder1(...) folder2(...) date(...) record(...)*

A ECINF está disponível para os anos de 1997 e 2003. O *input* `record(...)`deve ser preenchido com o Tipo de Registro:

| Código               | Tipo de Registro                                                               |
|-------------------|-------------------------------------------------------------------------|
| `domicilios`             | Domicílios                         |
| `moradores`             |  Moradores                |
| `trabrend`             | Trabalho e Rendimento     |
| `uecon`             | Unidade Econômica     |
| `pesocup`             | Pessoas Ocupadas     |
| `indprop`             | Proprietário     |
| `sebrae`             | Sebrae (disponível apenas para 2003)    |

A função da ECINF pode ser utilizada diretamente. Ver `h datazoom_ecinf`


### POF

__datazom_social, research(pof)__ *folder1(...) folder2(...) date(...) datatype(...)* [*ops*]

Os anos disponíveis para POF são 1995, 2002, 2008 e 2017. O *input* `datatype(...)` deve ser preenchido com o tipo de dado que o usuário deseja extrair: Bases Padronizadas `datatype(std)`, Gastos Selecionados `datatype(sel)` e Tipos de Registro `datatype(trs)`. Para cada Tipo de Dado escolhido, há opções específicas:

* Bases Padronizadas:

__datazom_social, research(pof)__ *folder1(...) folder2(...) date(...) datatype(std) identification(...)*

| `identification`              | Descrição                                                               |
|-------------------|-------------------------------------------------------------------------|
| `dom`             | Domicílio                                              |
| `uc`             |  Unidade de Consumo               |
| `pess`             | Indivíduo     |

* Gastos Selecionados:

__datazom_social, research(pof)__ *folder1(...) folder2(...) date(...) datatype(sel) identification(...) list(...)*

`identification(...)` possui as mesmas opções do tópico anterior. Para `identification(...)` utilizar a Caixa de Diálogo para ver opções.

* Tipos de Registro

__datazom_social, research(pof)__ *folder1(...) folder2(...) date(...) datatype(std) registertype(...)*

Para `registertype(...)` há 7 tipos de registros, numerados conforme a documentação do IBGE. Utilizar Caixa de Diálogo para ver opções.

___Atenção:___ Para a POF 2017-2018, Bases Padronizadas e Gastos Selecionados não estão disponíveis.

As funções da POF podem ser utilizada diretamente. Ver `h datazoom_pofXXXX` com `XXXX`igual ao ano de interesse.
