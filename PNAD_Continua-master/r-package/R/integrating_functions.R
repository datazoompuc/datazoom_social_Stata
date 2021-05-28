#' @importFrom dplyr %>%
#' @importFrom rlang .data

NULL

#' Loads and cleans PNAD Continua microdata from a specified directory.

#'
#' @encoding UTF-8
#' @param panel Defaults to \code{"no"}.
#' A string that indicates whether the user wants the data as a panel of individuals. If not,
#' set \code{panel = "no"}. If yes, set \code{panel = "basic"} or \code{panel = "advanced"} for either
#' type of identification. Check references for further explanation.
#'
#' @section Warning:
#' Beware that it may take a long time to prepare panel data, especially if \code{panel = "advanced"}
#'
#' @param sources A number of different sources are supported:
#'
#' Passing a list of dates will download the corresponding data from IBGE's website.
#'
#' Passing a string with a directory's path will read data from all files named
#'   "\code{path}/PNADC_XXXX.txt".
#'
#' Alternatively, \code{sources} may be a list of full file paths
#'
#' @param lang Should the data come in Portuguese or in English. Default is
#' \code{lang = 'english'}
#'
#' @param download_directory In case \code{sources} is such that data is downloaded
#' from IBGE, where should it be stored? Default is the working directory
#'
#'
#' @return In case \code{panel = "no"}, a list of dataframes with the microdata from each
#' required period. Else, returns a list with a dataframe for each panel in the original data.
#'
#' @examples
#'
#' \dontrun{
#' To download data, set \code{sources} as a list of vectors
#' of time periods
#'
#' dates <- list(c(1, 2012), c(2, 2012))
#'
#' microdata <- load_pnadc(panel = 'no', lang = 'english',
#'                         sources = dates,
#'                         download_directory = './Desktop')
#'
#' To load the data from a folder:
#'
#' microdata <- load_pnadc(panel = 'advanced', lang = 'english',
#'                         sources = './Desktop/folder_name')
#'
#' To load an individual .txt file corresponding to a given period of the survey:
#'
#'   microdata <- load_pnadc(panel = 'basic', sources = './PNADC_012020.txt')
#'}
#'


#' @export
load_pnadc <- function(panel = "no", lang = 'english',
                       sources, download_directory = getwd()) {

type_panel <- ifelse(panel == "basic", TRUE, FALSE)

dataset <- load_and_tidy_data(files = sources,
                              download_location = download_directory)

 if(panel != 'no'){

#### Binding the data to generate ids, then splitting by panel and naming
#### each dataset

   dataset <- dplyr::bind_rows(dataset) %>%
     build_panel(basic = type_panel) %>%
     purrr::map(~ .x %>%
                  dplyr::relocate(.data$idind) %>%
                  as.data.frame(.) %>%
                  dplyr::group_by(V1014) %>%
                  dplyr::group_split()) %>%
     purrr::flatten() %>%
     purrr::map(~ .x %>% dplyr::ungroup(.))

   panel_names <- purrr::map(dataset, ~ paste0('panel_', unique(.x$V1014)))

   names(dataset) <- panel_names

 } else{

   #### splitting by year/quarter and naming each dataset

   dataset <- dplyr::bind_rows(dataset) %>%
     dplyr::group_by(.data$ANO, .data$TRIMESTRE) %>%
     as.data.frame(.) %>%
     dplyr::group_split() %>%
     purrr::map(~ .x %>% dplyr::ungroup(.))

   dataset_names <- purrr::map(dataset, ~ paste0('pnadc_',
                                          stringr::str_pad(unique(.x$TRIMESTRE),
                                                 width = 2, pad = "0"),
                                          unique(.x$ANO)))
   names(dataset) <- dataset_names
 }


dataset <- purrr::map(dataset, convert_types)

dataset <- purrr::map(dataset, ~ translation_and_labels(df = .,
                                                 language = lang))

dataset <- purrr::map(dataset,
               ~ .x %>%
                 dplyr::mutate(
                   hous_id = paste0(.data$UPA, .data$V1008, V1014),
                   ind_id = paste0(.data$UPA, .data$V1008, V1014, .data$V2003)
                   ) %>%
                 dplyr::relocate(hous_id, ind_id)
               )



}


#' Builds PNAD Contínua panel data from a loaded object
#'
#' @encoding UTF-8
#' @param ... PNAD Contínua dataframes to be considered in panel
#' @param basic Basic or advanced identification. Defaults to \code{TRUE}
#' @param lang Idiom used on the original data. Defaults to \code{english}. If in Portuguese,
#' set \code{land = 'portuguese'}.
#' @return List of dataframes. Each element corresponds to a different
#' panel present in the original dataset.
#'
#' @examples
#'
#'\dontrun{
#' Let \code{data1} and \code{data2} be two dataframes with deidentified
#' PNAD-C data:
#'
#' panel <- pnadc_panel(data1, data2, basic = TRUE, lang = 'english')
#'
#' The user could also use a list of dataframes  \code{list_df}:
#'
#' panel <- pnadc_panel(list_df, basic = TRUE)
#' }

#' @export

pnadc_panel <- function(..., basic = TRUE, lang = 'english'){


  dataset <- list(...)

if(purrr::map_lgl(dataset, ~ !is.data.frame(.)) %>% all()){

  dataset <- purrr::flatten(dataset)
}

  #Converting factor variables back to numeric

dataset <- dataset %>%
  purrr::map(~ .x %>%
    dplyr::mutate(
      dplyr::across(
        c(.data$V2009, .data$V2005, .data$V2008, .data$V20081, .data$VD3004, .data$V20082, .data$V2003),
        ~ as.character(.) %>% as.numeric(.)
      )
    ))

### translate to pt-br to make panel
if(lang == 'english'){

  dataset <- purrr::map(dataset,
                 ~ .x %>%
                   dplyr::rename(
                     ANO = Year,
                     TRIMESTRE = Quarter,
                     CAPITAL = Capital,
                     ESTRATO = Stratum
                     )
                 )
}

### build panel
  dataset <- dplyr::bind_rows(dataset) %>%
    build_panel(basic = basic) %>%
    purrr::map( ~ .x %>%
                  dplyr::relocate(idind) %>%
                  dplyr::group_by(V1014) %>%
                  as.data.frame(.) %>%
                  dplyr::group_split()) %>%
    purrr::flatten() %>%
    purrr::map( ~ .x %>% dplyr::ungroup(.))

  panel_names <- purrr::map(dataset, ~ paste0('panel_', unique(.x$V1014)))

  names(dataset) <- panel_names

### Adding back labels

  dataset <- purrr::map(dataset, convert_types)

  dataset <- purrr::map(dataset, ~ translation_and_labels(df = .,
                                                   language = lang) %>%
                   dplyr::relocate(hous_id, ind_id))
  dataset
}

#### Separates columns according to dictionary, changes column types.
#### Label addition is left to later, after building panel


load_and_tidy_data <- function(files, download_location = getwd()){

  #### In case user wants to download from IBGE

  if (purrr::map_lgl(files, is.numeric) %>% all()) {

    quarters <- purrr::map(files, ~ .[[1]])
    years <- purrr::map(files, ~ .[[2]])

    download_path <- purrr::map2(quarters, years, ~ download_quarter(quarter = .x, year = .y,
                                                              directory = download_location))

    files <- list.files(download_path[[1]], full.names = TRUE)

    #### In case the user provides a directory with the data

  } else if(is.character(files) && length(files) == 1 && dir.exists(files)){

    files <-
      list.files(path = files, full.names = TRUE,
                 pattern = "PNADC_.*.txt$")

  }

  raw_data <- purrr::map(files, ~ readr::read_tsv(. , col_names = 'a', n_max = 1000))

  tidy_data <- purrr::map(raw_data, ~ spread_columns(dataset = ., original_column = a))

  return(tidy_data)


}

spread_columns <- function(dataset, original_column) {
  dataset %>%
    tidyr::separate({{original_column}},
                    into = data_labels$variable_pt.br, sep = data_labels$position[-1] - 1) %>%
    dplyr::mutate(dplyr::across(c(.data$V2009, .data$VD3004, .data$V2005,
                                  .data$V2008, .data$V20081, .data$V20082),
                  as.numeric))
}

convert_types <- function(df){

  df %>%
    dplyr::mutate(
      dplyr::across(tidyselect::vars_select_helpers$where(is.factor),
                    ~ ifelse(.data == '.', "", .) %>%
                      as.character(.data)),
      dplyr::across(tidyselect::everything(), ~ ifelse(stringr::str_trim(.) == "", NA, .) %>%
               as.factor(.)),
      dplyr::across(data_labels$variable_pt.br[data_labels$var_type == "factor"],
             as.factor),
      dplyr::across(data_labels$variable_pt.br[data_labels$var_type == "double"],
             as.double)
    )
      }


translation_and_labels <- function(df, language){

if(language == 'english'){

  labels_key <- as.list(data_labels$label_eng) %>%
    stats::setNames(data_labels$variable_pt.br)

} else{

  labels_key <- as.list(data_labels$label_pt.br) %>%
    stats::setNames(data_labels$variable_pt.br)

}

df <- df %>%
    labelled::set_variable_labels(.labels = labels_key)

if(language == 'english'){

  df <- df %>%
    dplyr::rename(
      Year = .data$ANO,
      Quarter = .data$TRIMESTRE,
      Capital = .data$CAPITAL,
      Stratum = .data$ESTRATO
    )

}
df
}
