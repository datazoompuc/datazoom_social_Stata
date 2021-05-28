
download_quarter <- function(quarter, year, directory = getwd()) {
  if (!dir.exists(directory)) {
    stop("Provided directory doesn't exist")
  }
  if (!is_period_valid(quarter, year)) {
    stop("Provided period is not valid")
  }


  if (year >= 2019 & quarter >= 2 | year >= 2020) {
    quarter <- stringr::str_pad(quarter,
      width = 2,
      side = "left",
      pad = 0
    )
    file_name <- paste0("PNADC_", quarter, year, ".zip")
  } else {
    quarter <- stringr::str_pad(quarter,
      width = 2,
      side = "left",
      pad = 0
    )

    #### Ficar de olho para ver se o IBGE muda o seu padrão de nomes nos códigos
    file_name <- paste0("PNADC_", quarter, year, "_20190729.zip")
  }

  url_path <- file.path(
    "http://ftp.ibge.gov.br/Trabalho_e_Rendimento/Pesquisa_Nacional_por_Amostra_de_Domicilios_continua/Trimestral/Microdados",
    year,
    file_name
  )

  utils::download.file(
    url = url_path,
    destfile = file.path(directory, file_name),
    mode = "wb"
  )

  utils::unzip(
    zipfile = file.path(directory, file_name),
    exdir = file.path(directory, "PNADC_microdata")
  )

  return(file.path(directory, "PNADC_microdata"))
}

is_period_valid <- function(quarter, year) {
  quarter >= 1 && quarter <= 4 && year >= 2012 && year <= timeDate::getRmetricsOptions("currentYear")
}
