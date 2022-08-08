> <a href="http://www.econ.puc-rio.br/datazoom/">__DataZoom:__</a> Desenvolvido pelo Departamento de Economia da Pontifícia Universidade Católica do Rio de Janeiro (PUC-Rio)

# DataZoom Social Stata:

<!-- badges: start -->
<!-- badges: end -->

<a href="https://github.com/datazoompuc/datazoom_social_Stata"><img src="https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/logo.jpg" align="left" width="100" hspace="10" vspace="6"></a>

O DataZoom Social Stata `datazoom_social` é um pacote que compatibiliza microdados de pesquisas realizadas pelo IBGE. Com o pacote, é possível fazer a leitura de todas as pesquisas domiciliares realizadas pelo IBGE: Censo Demográfico, Pesquisa Nacional por Amostra de Domicílios, Pesquisa Mensal do Emprego, Pesquisa de Orçamentos Familiares e Pesquisa de Economia Informal Urbana.

## Conteúdo
1. [Instalação](#instalacao)
2. [Sintaxe](#syntax)
3. [Caixa de Diálogo](#caixa)
4. [Opções específicas de cada pesquisa](#opts)
    1. [PNS](#pns)
    2. [Censo Demográfico](#censo)
    1. [PNAD Contínua - Divulgação Anual](#pnad_anual)
    1. [PNAD Contínua - Divulgação Trimestral](#pnad_cont)
    1. [PNAD](#pnad)
    1. [PNAD Covid](#pnad_covid)
    1. [PME Nova](#pme_nova)
    1. [PME Antiga](#pme_antiga)
    1. [ECINF](#ecinf)
    1. [POF](#pof)
5. [Programas auxiliares (dicionários)](#aux)
6. [Estrutura dos programas](#estrutura)

## Instalação <a name="instalacao"></a>

Digite o código abaixo na linha de comando do Stata para baixar e instalar os arquivos referente ao pacote DataZoom Social

```
net install datazoom_social, from("https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/") force
```

## Syntax <a name="syntax"></a>

A syntax do pacote pode ser resumida como:

__datazoom_social__ [, *options*]

Onde as [*options*] podem ser:

| Opção             | Descrição                                                               |
|-------------------|-------------------------------------------------------------------------|
| `survey(...)`   | Escolha da Pesquisa                                                     |
| `source(...)`    | Pasta onde o *raw data* estão salvos                                    |
| `save(...)`    | Pasta onde deseja salvar a base de dados gerada pelo Stata              |
| `date(...)`       | Data de referência dos dados compatibilizados                           |
| english           | Para obter variáveis em inglês, colocar essa opção no final do comando  |
| outras opções     | Opções específicas de cada pesquisa, relacionadas abaixo                |

___Atenção:___ Dado o número de pesquisas e opções relacionadas às mesmas, recomendamos o uso da nossa Caixa de Diálogo para compatibilização dos dados

## Caixa de Diálogo <a name="caixa"></a>

A Caixa de Diálogo do pacote pode ser acessada utilizando o seguinte comando: `db datazoom_social`. A seguinte janela se abrirá:

<a href="https://github.com/datazoompuc/datazoom_social_Stata"><img src="https://raw.githubusercontent.com/datazoompuc/datazoom_social_stata/master/dlg.JPG" align="center" width="540" hspace="10" vspace="6"></a>

Basta navegar pelas opções da Caixa de Diálogo para fazer as leituras dos microdados do IBGE.

## Opções específicas de cada pesquisa <a name="opts"></a>

As opções `survey(...)`, `source(...)`, `save(...)` e `date(...)` são mandatórias. A depender da pesquisa escolhida, outras opções serão requeridas

### PNS <a name="pns"></a>

__datazoom_social, survey(pns)__ *source(...) save(...) date(...)*

Os anos disponíveis para a PNS são 2013 e 2019. A função da PNS pode ser utilizada diretamente. Ver `h datazoom_pns`

### Censo Demográfico <a name="censo"></a>

__datazoom_social, survey(censo)__ *source(...) save(...) date(...) state(...)* [*ops*]

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

### PNAD Contínua (PNADC) - Divulgação Anual <a name="pnad_anual"></a>

__datazoom_social, survey(pnadcontinua_anual)__ *source(...) save(...) date(...)*

Essa função compatibiliza os microdados referente a visita domiciliar específica de um ano. Os anos disponíveis para a PNADC Anual são de 2012 a 2019. A função da PNADC Anual pode ser utilizada diretamente. Ver `h datazoom_pnadcont_anual`

___Atenção:___ Na opção `source(...)` deve conter o caminho específico do arquivo com os microdados


### PNAD Contínua (PNADC) - Divulgação Trimestral <a name="pnad_cont"></a>

__datazoom_social, survey(pnadcontinua)__ *source(...) save(...) date(...)* [*ops*]

Os anos disponíveis para a PNADC Trimestral são de 2012 a 2021 (primeiro trimestre para este último ano). Para criação do painél, há as seguintes opções:

| Ops               | Descrição                                                               |
|-------------------|-------------------------------------------------------------------------|
| `nid`             | Sem identificação                                              |
| `idbas`             |  Identificação básica                |
| `idrs`             | Identificação Avançada (Metodologia Ribas e Soares)     |

Para criação do painel, os arquivos de microdados de todos os trimestres dos anos de interesse devem estar na pasta `source(...)`. A função da PNADC Trimestral pode ser utilizada diretamente. Ver `h datazoom_pnadcontinua`


### PNAD <a name="pnad"></a>

__datazoom_social, survey(pnad)__ *source(...) save(...) date(...)* [*ops*]

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


### PNAD Covid <a name="pnad_covid"></a>

__datazoom_social, survey(pnad_covid)__ *source(...) save(...) date(...)*

Os períodos disponíveis para a PNAD Covid são de Maio até Novembro de 2020. A função da PNAD Covid pode ser utilizada diretamente. Ver `h datazoom_pnad_covid`


### PME Nova <a name="pme_nova"></a>

__datazoom_social, survey(pmenova)__ *source(...) save(...) date(...)* [*ops*]

Os anos disponíveis para a PME são de 2002 a 2016. Para criação do painel, há as seguintes opções:

| Ops               | Descrição                                                               |
|-------------------|-------------------------------------------------------------------------|
| `nid`             | Sem identificação                                              |
| `idbas`             |  Identificação básica                |
| `idrs`             | Identificação Avançada (Metodologia Ribas e Soares)     |

Para criação do painel, os arquivos de microdados de todos os meses dos anos de interesse devem estar na pasta `source(...)`. A função da PME pode ser utilizada diretamente. Ver `h datazoom_pmenova`


### PME Antiga <a name="pme_antiga"></a>

__datazoom_social, survey(pmeantiga)__ *source(...) save(...) date(...)* [*ops*]

Os anos disponíveis para a PME são de 1991 a 2001. Para criação do painel, há as seguintes opções:

| Ops               | Descrição                                                               |
|-------------------|-------------------------------------------------------------------------|
| `nid`             | Sem identificação                                              |
| `idbas`             |  Identificação básica                |
| `idrs`             | Identificação Avançada (Metodologia Ribas e Soares)     |

Para criação do painel, os arquivos de microdados de todos os meses dos anos de interesse devem estar na pasta `source(...)`. A função da PME pode ser utilizada diretamente. Ver `h datazoom_pmeantiga`


### ECINF <a name="ecinf"></a>

__datazoom_social, survey(ecinf)__ *source(...) save(...) date(...) record(...)*

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


### POF <a name="pof"></a>

__datazoom_social, survey(pof)__ *source(...) save(...) date(...) datatype(...)* [*ops*]

Os anos disponíveis para POF são 1995, 2002, 2008 e 2017. O *input* `datatype(...)` deve ser preenchido com o tipo de dado que o usuário deseja extrair: Bases Padronizadas `datatype(std)`, Gastos Selecionados `datatype(sel)` e Tipos de Registro `datatype(trs)`. Para cada Tipo de Dado escolhido, há opções específicas:

* Bases Padronizadas:

__datazoom_social, survey(pof)__ *source(...) save(...) date(...) datatype(std) identification(...)*

| `identification`              | Descrição                                                               |
|-------------------|-------------------------------------------------------------------------|
| `dom`             | Domicílio                                              |
| `uc`             |  Unidade de Consumo               |
| `pess`             | Indivíduo     |

* Gastos Selecionados:

__datazoom_social, survey(pof)__ *source(...) save(...) date(...) datatype(sel) identification(...) list(...)*

`identification(...)` possui as mesmas opções do tópico anterior. Para `identification(...)` utilizar a Caixa de Diálogo para ver opções.

* Tipos de Registro

__datazoom_social, survey(pof)__ *source(...) save(...) date(...) datatype(std) registertype(...)*

Para `registertype(...)`, há diferentes tipos de registro a depender do ano, numerados conforme a documentação do IBGE. Utilizar Caixa de Diálogo para ver opções.

As funções da POF podem ser utilizada diretamente. Ver `help datazoom_pof`.

___Atenção:___ Para a POF 2017-2018, Bases Padronizadas e Gastos Selecionados não estão disponíveis.

## Programas auxiliares (dicionários) <a name="aux"></a>

A maioria dos programas do pacote se deparam com dados originais
armazenados em formato *.txt*, que precisam de dicionários – formato *.dct*
no Stata – para serem lidos. A consequência é um volume de dicionários
que supera o limite de 100 arquivos permitido para um pacote do Stata
poder ser instalado. Por isso, os dicionários individuais são
compactados em um arquivo *.dta* único, que é lido dentro de cada
programa. Ambas as funções usadas para isso são definidas no arquivo
*read\_compdct.ado*.

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

que extrai o *“dic original”* do arquivo *dict.dta* e o salva para *“dic extraído.dct”*.
Como exemplo, veja o uso dessa função no programa
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
*datazoom\_social.pkg*, e portanto, não são instalados no computador do
usuário. Apenas o arquivo *dict.dta* é enviado.

## Estrutura dos programas <a name="estrutura"></a>

As funções do pacote, em geral, seguem o seguinte esqueleto

    program datazoom_exemplo
    syntax, original(string) ... // Função principal, que será executada pelas
                                 // caixas de diálogo ou pelo datazoom_social

    ...

    load_exemplo, opções // Programa de leitura dos dados definido em seguida

    ...

    (Carregamento dos dados)

    treat_exemplo // Eventuais tratamentos de dados

    ...  

    save  

    end

    program load_exemplo

    ...

    end

    program treat_exemplo

    ...

    end

**Carregamento dos dados:** Como exemplo, vejamos um trecho do programa
da PNS

    program load_pns
    syntax, original(str) year(integer) [english]

    if "`english'" != "" local lang "_en"

    tempfile dic (*)

    findfile dict.dta (*)

    read_compdct, compdct("`r(fn)'") dict_name("pns`year'`lang'") out("`dic'") (*)

    qui infile using `dic', using(PNS_`year'.txt) clear

    end

As linhas marcadas com (\*) apenas extraem o dicionário necessário para
ler os dados, como explicado na seção anterior. Vendo as opções do
programa, o `load_pns` recebe a pasta que armazena os dados brutos, o
ano escolhido, e a opção de *labels* em inglês, que faz com que o
dicionário pns20xx\_en seja lido ao invés do pns20xx.

A primeira linha dentro dessa função está na maioria dos programas do
pacote: quando o usuário escolhe a opção *english*, um local de mesmo nome
é salvo, armazenado a string “english”. Como todos os dicionários em
inglês são armazenados com sufixo \_en, essa linha diz que, caso essa
macro english não seja vazia – que só ocorre quando o usuário escolhe
essa opção –, é criado o local lang com a string "\_en", que serve de
sufixo para o nome do dicionário a ser lido.

O centro dessa função de `load` está na linha de infile, que usa o
dicionário extraído para ler o arquivo de dados brutos, e o carrega para
a memória do Stata.
