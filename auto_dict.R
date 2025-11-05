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

# basta rodar a função auto_dict com as opções
# original: caminho até o dicionário original em .txt, ou até link para o site
# output: caminho para salvar o produto final, com .dct
# eng: TRUE/FALSE determinando se vai traduzir ou não
# api_key: caso queira traduzir, chave de API do DeepL

auto_dict <- function(original, output, eng, api_key = "") {
  # Lendo o dicionário

  dct <- readLines(original, encoding = "latin1", warn = FALSE)

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

  desc <- dct[, 2] %>%
    str_remove(fixed("*/")) %>%
    str_trim()

  # resto do dicionario
  dct <- dct[, 1]

  # agora separo as outras colunas com base em espaços
  dct <- dct %>%
    str_split(" ", simplify = TRUE)

  # removo colunas vazias
  dct <- dct[, colSums(dct != "") > 0]

  # coluna de posicao
  # @1234 -> _column(1234)

  position <- dct[, 1] %>%
    str_replace("@(\\d+)", "_column(\\1)")

  # nomes das variáveis
  names <- dct[, 2]

  # comprimento
  length_num <- dct[, 3] %>%
    str_extract("\\d+") %>%
    as.numeric()

  length <- length_num %>%
    sprintf("%%%sf", .)

  # agora os data types

  types <- dplyr::case_when(
    length_num <= 2 ~ "byte",
    length_num <= 4 ~ "int",
    length_num <= 9 ~ "long",
    .default = "float"
  )

  # opcional: tradução para inglês

  if (eng) {
    deeplr::usage2(auth_key = api_key)

    desc <- purrr::map(

        # Splitting the data into batches of 10 rows
        split(desc, ceiling(seq_along(desc) / 5)),
        function(x) {

          res <- deeplr::translate2(
            text = x,
            source_lang = "PT",
            target_lang = "EN",
            auth_key = api_key
          )

          cat("Time for a break!\n")
          Sys.sleep(10)

          return(res)

        }
      ) %>%
      unlist()
  }

  # acrescento aspas
  desc <- sprintf("`\"%s\"'", desc)

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

  # salvando (corrigindo acentos)
  con <- file(output, open = "w", encoding = "UTF-8")
  writeLines(dct, con)     # sem useBytes=TRUE
  close(con)
}