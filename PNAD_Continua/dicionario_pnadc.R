library(readxl)
library(stringr)
library(tidyverse)
library(tidyr)

#Importando o dicionario
dicionario_das_variaveis_PNAD_Continua_microdados <- 
  read_excel("~/GitHub/dicionario_das_variaveis_PNAD_Continua_microdados.xls")

#Selecionando as colunas referentes ao Codigo e Tipo da Variavel
dic_pnadc <- dicionario_das_variaveis_PNAD_Continua_microdados[, c(3, 5, 6, 7)]
dic_pnadc <- dic_pnadc %>% rename(c(Variavel = ...3, Descricao = ...5, Valor = ...6, Label = ...7))
dic_pnadc <- dic_pnadc %>% tail(-3)
dic_pnadc <- dic_pnadc %>% fill(c(Variavel, Descricao))
dic_pnadc <- dic_pnadc %>% filter(!is.na(Valor) | !is.na(Label))

#Deixando apenas numeros discretos na coluna Valor
dic_pnadc$Valor <- as.numeric(dic_pnadc$Valor)
dic_pnadc <- dic_pnadc %>% filter(!is.na(Valor))

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
dic_pnadc <- dic_pnadc %>% select(Label)
writeLines(dic_pnadc$Label, "bbbb.txt")