library(magrittr)
library(stringr)

# Script para construir automaticamente dicionários da PNADC
# Lê dicionários de SAS em formato .txt
# COnverte em .dct do Stata

# Componentes:
# 1. Posição
# 2. Data type do Stata
# 3. Nome da variável
# 4. Comprimento, %2f
# 5. Descrição

dct_original <- readline("Digite o caminho até o arquivo de dicionário .txt\n")

output <- readline("Digite o caminho para salvar o produto final em .dct\n")

eng <- readline("Deseja o dicionário traduzido para inglês? TRUE/FALSE\n É necessário registro no DeepL com uma chave de API\n") == "TRUE"

# Lendo o dicionário

dct <- readLines(dct_original, encoding = "latin1")

# Removendo linhas estranhas
# mantendo apenas o que começa com @
# onde tem variáveis

dct <- dct[str_detect(dct, "@.*")]

# iniciando a conversão de SAS para Stata

# primeiro separo a descrição das variáveis do resto
# separador é /*

dct <- dct %>%
  str_split(fixed("/*"), simplify = TRUE)

# salvo a descrição em um vetor

desc <- dct[,2] %>%
  str_remove(fixed("*/")) %>%
  str_trim()

# resto do dicionario
dct <- dct[,1]

# agora separo as outras colunas com base em espaços
dct <- dct %>%
  str_split(" ", simplify = TRUE)

# removo colunas vazias
dct <- dct[, colSums(dct != "") > 0]

# coluna de posicao
# @1234 -> _column(1234)

position <- dct[,1] %>%
  str_replace("@(\\d+)", "_column(\\1)")

# nomes das variáveis
names <- dct[,2]

# comprimento
length <- dct[,3] %>%
  str_extract("\\d+") %>%
  sprintf("%%%sf", .)

# agora os data types

types <- dplyr::case_when(
  length <= 2 ~ "byte",
  length <= 4 ~ "int",
  length <= 9 ~ "long",
  .default = "float"
)

# opcional: tradução para inglês

if (eng) {
  api_key <- readline("Digite sua API Key do DeepL")
  
  deeplr::usage2(auth_key = api_key)
  
  desc <- deeplr::translate2(
    text = desc,
    source_lang = "PT",
    target_lang = "EN",
    auth_key = api_key
  )
}

# acrescento aspas
desc <- sprintf("\"%s\"", desc)

# montando o dicionário

dct <- paste(
  position, types, names, length, desc,
  sep = "\t"
)

# header e footer

dct <- c(
  "dictionary{",
  dct,
  "}"
)

# salvando

writeLines(dct, output)
