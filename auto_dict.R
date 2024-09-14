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

  dct <- readLines(original, encoding = "latin1")

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
  length <- dct[, 3] %>%
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
}

# verificar se links estão atualizados

dicts <- tibble::tribble(
  ~ output, ~ original,
  # por visita
  # visita 1
  "pnad_anual_2012a2014_vis1.dct", "https://ftp.ibge.gov.br/Trabalho_e_Rendimento/Pesquisa_Nacional_por_Amostra_de_Domicilios_continua/Anual/Microdados/Visita/Visita_1/Documentacao/input_PNADC_2012_a_2014_visita1_20220224.txt",
  "pnad_anual_2015_vis1.dct", "https://ftp.ibge.gov.br/Trabalho_e_Rendimento/Pesquisa_Nacional_por_Amostra_de_Domicilios_continua/Anual/Microdados/Visita/Visita_1/Documentacao/input_PNADC_2015_visita1_20220224.txt",
  "pnad_anual_2016_vis1.dct", "https://ftp.ibge.gov.br/Trabalho_e_Rendimento/Pesquisa_Nacional_por_Amostra_de_Domicilios_continua/Anual/Microdados/Visita/Visita_1/Documentacao/input_PNADC_2016_visita1_20220224.txt",
  "pnad_anual_2017_vis1.dct", "https://ftp.ibge.gov.br/Trabalho_e_Rendimento/Pesquisa_Nacional_por_Amostra_de_Domicilios_continua/Anual/Microdados/Visita/Visita_1/Documentacao/input_PNADC_2017_visita1_20220224.txt",
  "pnad_anual_2018_vis1.dct", "https://ftp.ibge.gov.br/Trabalho_e_Rendimento/Pesquisa_Nacional_por_Amostra_de_Domicilios_continua/Anual/Microdados/Visita/Visita_1/Documentacao/input_PNADC_2018_visita1_20220224.txt",
  "pnad_anual_2019_vis1.dct", "https://ftp.ibge.gov.br/Trabalho_e_Rendimento/Pesquisa_Nacional_por_Amostra_de_Domicilios_continua/Anual/Microdados/Visita/Visita_1/Documentacao/input_PNADC_2019_visita1_20230811.txt",
  "pnad_anual_2022_vis1.dct", "https://ftp.ibge.gov.br/Trabalho_e_Rendimento/Pesquisa_Nacional_por_Amostra_de_Domicilios_continua/Anual/Microdados/Visita/Visita_1/Documentacao/input_PNADC_2022_visita1_20231129.txt",
  "pnad_anual_2023_vis1.dct", "https://ftp.ibge.gov.br/Trabalho_e_Rendimento/Pesquisa_Nacional_por_Amostra_de_Domicilios_continua/Anual/Microdados/Visita/Visita_1/Documentacao/input_PNADC_2023_visita1_20240621.txt",
  # visita 2
  "pnad_anual_2020_vis2.dct", "https://ftp.ibge.gov.br/Trabalho_e_Rendimento/Pesquisa_Nacional_por_Amostra_de_Domicilios_continua/Anual/Microdados/Visita/Visita_2/Documentacao/input_PNADC_2020_visita2_20231130.txt",
  "pnad_anual_2021_vis2.dct", "https://ftp.ibge.gov.br/Trabalho_e_Rendimento/Pesquisa_Nacional_por_Amostra_de_Domicilios_continua/Anual/Microdados/Visita/Visita_2/Documentacao/input_PNADC_2021_visita2_20231130.txt",
  "pnad_anual_2023_vis2.dct", "https://ftp.ibge.gov.br/Trabalho_e_Rendimento/Pesquisa_Nacional_por_Amostra_de_Domicilios_continua/Anual/Microdados/Visita/Visita_2/Documentacao/input_PNADC_2023_visita2.txt",
  # visita 5
  "pnad_anual_2016_vis5.dct", "https://ftp.ibge.gov.br/Trabalho_e_Rendimento/Pesquisa_Nacional_por_Amostra_de_Domicilios_continua/Anual/Microdados/Visita/Visita_5/Documentacao/input_PNADC_2016_visita5_20231222.txt",
  "pnad_anual_2017_vis5.dct", "https://ftp.ibge.gov.br/Trabalho_e_Rendimento/Pesquisa_Nacional_por_Amostra_de_Domicilios_continua/Anual/Microdados/Visita/Visita_5/Documentacao/input_PNADC_2017_visita5_20231222.txt",
  "pnad_anual_2018_vis5.dct", "https://ftp.ibge.gov.br/Trabalho_e_Rendimento/Pesquisa_Nacional_por_Amostra_de_Domicilios_continua/Anual/Microdados/Visita/Visita_5/Documentacao/input_PNADC_2018_visita5_20231222.txt",
  "pnad_anual_2019_vis5.dct", "https://ftp.ibge.gov.br/Trabalho_e_Rendimento/Pesquisa_Nacional_por_Amostra_de_Domicilios_continua/Anual/Microdados/Visita/Visita_5/Documentacao/input_PNADC_2019_visita5_20231222.txt",
  "pnad_anual_2020_vis5.dct", "https://ftp.ibge.gov.br/Trabalho_e_Rendimento/Pesquisa_Nacional_por_Amostra_de_Domicilios_continua/Anual/Microdados/Visita/Visita_5/Documentacao/input_PNADC_2020_visita5_20220224.txt",
  "pnad_anual_2021_vis5.dct", "https://ftp.ibge.gov.br/Trabalho_e_Rendimento/Pesquisa_Nacional_por_Amostra_de_Domicilios_continua/Anual/Microdados/Visita/Visita_5/Documentacao/input_PNADC_2021_visita5.txt",
  "pnad_anual_2022_vis5.dct", "https://ftp.ibge.gov.br/Trabalho_e_Rendimento/Pesquisa_Nacional_por_Amostra_de_Domicilios_continua/Anual/Microdados/Visita/Visita_5/Documentacao/input_PNADC_2022_visita5_20231222.txt",
  # por trimestre
  # trimestre 1
  "pnad_anual_tri1.dct", "https://ftp.ibge.gov.br/Trabalho_e_Rendimento/Pesquisa_Nacional_por_Amostra_de_Domicilios_continua/Anual/Microdados/Trimestre/Trimestre_1/Documentacao/input_PNADC_trimestre1.txt",
  "pnad_anual_tri2.dct", "https://ftp.ibge.gov.br/Trabalho_e_Rendimento/Pesquisa_Nacional_por_Amostra_de_Domicilios_continua/Anual/Microdados/Trimestre/Trimestre_2/Documentacao/input_PNADC_trimestre2_20221221.txt",
  "pnad_anual_tri3.dct", "https://ftp.ibge.gov.br/Trabalho_e_Rendimento/Pesquisa_Nacional_por_Amostra_de_Domicilios_continua/Anual/Microdados/Trimestre/Trimestre_3/Documentacao/input_PNADC_trimestre3_20230707.txt",
  "pnad_anual_tri4.dct", "https://ftp.ibge.gov.br/Trabalho_e_Rendimento/Pesquisa_Nacional_por_Amostra_de_Domicilios_continua/Anual/Microdados/Trimestre/Trimestre_4/Documentacao/input_PNADC_trimestre4_20240425.txt"
)

purrr::map2(
  dicts$original, dicts$output,
  function(orig, out) {
    message(out)
    auto_dict(
      orig,
      file.path("C:/Users/User/Documents/GitHub/datazoom_social_Stata/PNAD_Continua/Anual/dct", out),
      FALSE
    )
  }
)

# PNAD Trimestral

auto_dict(
  "C:/Users/User/Downloads/input_PNADC_trimestral.txt",
  file.path("C:/Users/User/Documents/GitHub/datazoom_social_Stata/PNAD_Continua/Trimestral/dct", "pnadcontinua.dct"),
  FALSE
)

auto_dict(
  dicts$original[16],
  file.path("C:/Users/User/Documents/GitHub/datazoom_social_Stata/PNAD_Continua/Anual/dct", "pnad_anual_2020_vis5_en.dct"),
  TRUE,
  api_key
)

auto_dict(
  dicts$original[17],
  file.path("C:/Users/User/Documents/GitHub/datazoom_social_Stata/PNAD_Continua/Anual/dct", "pnad_anual_2021_vis5_en.dct"),
  TRUE,
  api_key
)

auto_dict(
  dicts$original[18],
  file.path("C:/Users/User/Documents/GitHub/datazoom_social_Stata/PNAD_Continua/Anual/dct", "pnad_anual_2022_vis5_en.dct"),
  TRUE,
  api_key
)
