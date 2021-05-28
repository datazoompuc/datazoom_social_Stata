# Datazoom PNAD Covid
O Data Zoom permite a leitura dos microdados por meio do programa R para todas os meses da PNAD COVID a partir de Maio de 2020, gerando bases de dados no formato do programa. 
Todas as variáveis originais possuem os nomes sugeridos pelo IBGE em seu dicionário. Para utilizar o pacote, o usuário deve obter os microdados referentes as semanas 
dos meses de interesse no site do [IBGE](https://www.ibge.gov.br/).


## Instruções de uso
Uma vez baixados e descompactados os microdados, instale, se necessário, o pacote ```devtools``` no R:

```
if(!require(devtools)) install.packages("devtools")
devtools::install_github('datazoompuc/PNAD_Covid/R/datazoom_pnad_covid')
```
Uma vez instalado, carregue o pacote:

```
library(datazoomPNADcovid)
```
Para carregar os dados de maio de 2020 em inglês:

```
x <- pnad_covid_microdata('./path', lang = "eng", c(5,2020))
```
Em que ```'./path'``` é o endereço da pasta em que os microdados estão localizados no computador. Se for necessário carregar dados para mais de uma data, basta escrever
```pnad_covid_microdata('./path', c(data1), c(data2))```. Os arquivos para ambas as datas precisam estar na mesma pasta. O idioma padrão é o inglês. Para carregar variáveis em inglês, use ```idioma = "pt_br```.

Como resultado, ```x``` é uma lista de dataframes, um para cada data. Caso queira juntá-los em uma única base de dados, faça ```dplyr::bind_rows(x)```.

### Observações
Como a pesquisa PNAD Covid ainda está em elaboração, os dados e o pacote em questão estão sujeitos a constante atualização. O pacote corresponde à divulgação mais recente, 
de 01/07/2020.

Para mais informações, consulte [nosso site](http://www.econ.puc-rio.br/datazoom/index.html) ou entre em contato por datazoom@econ.puc-rio.br

