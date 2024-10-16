# Script to generate value labels for PNADC variables
# It automatically reads the IBGE dictionary, parses it
# and writes Stata code

# Packages

library(readxl)
library(stringr)
library(tidyverse)
library(tidyr)

# Defining path for the IBGE dictionary
message("Type the path of the IBGE PNADC dictionary in .xls")

ibge_path <- readline()

# Choosing whether to translate to English
message("Which language? pt or en?")

lang <- readline()

## Starting manipulation

#Importando o dicionario
dic_pnadc <- read_excel(ibge_path)

#Selecionando as colunas referentes ao Codigo e Tipo da Variavel
dic_pnadc <- dic_pnadc[, c(3, 5, 6, 7)]
dic_pnadc <- dic_pnadc %>% rename(c(Variavel = ...3, Descricao = ...5, Valor = ...6, Label = ...7))
dic_pnadc <- dic_pnadc %>% tail(-3)
dic_pnadc <- dic_pnadc %>% fill(c(Variavel, Descricao))
dic_pnadc <- dic_pnadc %>% filter(!is.na(Valor) | !is.na(Label))

#Deixando apenas numeros discretos na coluna Valor
dic_pnadc$Valor <- as.numeric(dic_pnadc$Valor)
dic_pnadc <- dic_pnadc %>% filter(!is.na(Valor))

vars_list <- dic_pnadc$Variavel %>%
  unique()

# fixing some strings
dic_pnadc$Label <- dic_pnadc$Label %>%
  gsub("\n", " ", .)

#Juntando as colunas Valor e Label
dic_pnadc <- dic_pnadc %>% mutate(Label = paste0("\"", Label, "\""))
dic_pnadc <- dic_pnadc %>% mutate(Label = str_c(Valor, Label, sep = " "))
dic_pnadc <- dic_pnadc %>% select(Variavel, Label)

#Concatenando cada categoria de Variavel
dic_pnadc <- dic_pnadc %>% group_by(Variavel) %>%                    
  summarise(Label = paste(Label, collapse = " "))

dic_pnadc <- dic_pnadc %>% mutate(Variavel = paste0("label_", Variavel, sep = ""))
dic_pnadc <- dic_pnadc %>% mutate(Label = str_c(Variavel, Label, sep = " "))
dic_pnadc <- dic_pnadc %>% mutate(Label = paste0("label define ", Label, sep = " "))
dic_pnadc <- dic_pnadc$Label

# attributing labels

vars_list <- paste0("cap label values ", vars_list, " label_", vars_list)

# combining

dic_pnadc <- c(
  "program define pnadc_value_labels",
  dic_pnadc,
  vars_list,
  "end"
)

# Choose where to save file

message("Folder to save the code")

save_to <- readline()

writeLines(dic_pnadc, save_to)
