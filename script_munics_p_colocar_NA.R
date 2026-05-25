library(dplyr)
library(haven)

ref_dir  <- "C:\\Users\\felip\\OneDrive\\Documentos\\PUC\\Data Zoom\\Censo\\1991\\tarefa_18mai\\Norte_dat" # arquivos dta
test_dir <- "C:\\Users\\felip\\OneDrive\\Documentos\\PUC\\Data Zoom\\Censo\\1991\\dbf\\tarefa\\com_id_dom_18mai" 
out_dir  <- "C:\\Users\\felip\\OneDrive\\Documentos\\PUC\\Data Zoom\\Censo\\1991\\tarefa_18mai\\dbf_comNA"

dir.create(out_dir, showWarnings = FALSE)

# --------------------------------------------------
# Lista arquivos
# --------------------------------------------------
municipios_ruins <- data.frame(UF = character(), MUNICNUM = character())

ref_files  <- list.files(ref_dir,  pattern = "\\.dta$", full.names = TRUE)
test_files <- list.files(test_dir, pattern = "\\.dta$", full.names = TRUE)

# --------------------------------------------------
# Extrai código da UF
# Ex: CD91AMOUP11.dta -> 11
# --------------------------------------------------

get_uf <- function(x) {
  sub(".*([0-9]{2})\\.dta$", "\\1", basename(x))
}

ref_ufs  <- sapply(ref_files,  get_uf)
test_ufs <- sapply(test_files, get_uf)

ufs <- intersect(ref_ufs, test_ufs)

# --------------------------------------------------
# Loop pelas UFs
# --------------------------------------------------

for (uf in ufs) {
  
  cat("\n========================\n")
  cat("UF:", uf, "\n")
  
  ref_path  <- ref_files[ref_ufs == uf]
  test_path <- test_files[test_ufs == uf]
  
  # --------------------------------------------------
  # Lê apenas colunas necessárias
  # --------------------------------------------------
  
  ref <- read_dta(
    ref_path,
    col_select = c(v1102, v0102)
  )
  
  test <- read_dta(
    test_path,
    col_select = c(MUNICNUM, id_dom)
  )
  
  # --------------------------------------------------
  # Padroniza nomes
  # --------------------------------------------------
  
  ref <- ref %>%
    rename(
      MUNICNUM = v1102,
      id_dom   = v0102
    )
  
  ref$MUNICNUM  <- formatC(as.numeric(ref$MUNICNUM),  width = 4, flag = "0")
  test$MUNICNUM <- formatC(as.numeric(test$MUNICNUM), width = 4, flag = "0")
  
  # --------------------------------------------------
  # 1. Compara UF inteira
  # --------------------------------------------------
  
  n_ref  <- n_distinct(ref$id_dom)
  n_test <- n_distinct(test$id_dom)
  
  cat("Referência:", n_ref, "\n")
  cat("Teste:", n_test, "\n")
  
  # Se bater, salva e passa pra próxima UF
  if (n_ref == n_test) {
    
    cat("UF OK\n")
    
    write_dta(
      test,
      file.path(out_dir,
                paste0("UF_", uf, ".dta"))
    )
    
    next
  }
  
  cat("Diferença encontrada. Comparando municípios...\n")
  
  # --------------------------------------------------
  # 2. Contagem por município
  # --------------------------------------------------
  
  mun_ref <- ref %>%
    group_by(MUNICNUM) %>%
    summarise(
      n_ref = n_distinct(id_dom),
      .groups = "drop"
    )
  
  mun_test <- test %>%
    group_by(MUNICNUM) %>%
    summarise(
      n_test = n_distinct(id_dom),
      .groups = "drop"
    )
  
  comp <- full_join(
    mun_ref,
    mun_test,
    by = "MUNICNUM"
  ) %>%
    mutate(
      diferente = n_ref != n_test
    )
  
  # Municípios problemáticos
  ruins <- comp %>%
    filter(diferente == TRUE) %>%
    pull(MUNICNUM)
  
  cat("Municípios problemáticos:",
      length(ruins), "\n")
  
  municipios_ruins <- bind_rows(
    municipios_ruins,
    data.frame(UF = uf, MUNICNUM = ruins)
  )
  
  # --------------------------------------------------
  # 3. Coloca NA no id_dom
  # --------------------------------------------------
  
  test$id_dom[
    test$MUNICNUM %in% ruins
  ] <- NA
  
  # --------------------------------------------------
  # 4. Salva resultado
  # --------------------------------------------------
  
  write_dta(
    test,
    file.path(
      out_dir,
      paste0("UF_", uf, ".dta")
    )
  )
}

cat("\n========================\n")
cat("Total de municípios problemáticos:", nrow(municipios_ruins), "\n")
print(municipios_ruins)



mun_total <- bind_rows(
  lapply(ufs, function(uf) {
    test_path <- test_files[test_ufs == uf]
    test <- read_dta(test_path, col_select = c(MUNICNUM))
    data.frame(UF = uf, n_total = n_distinct(test$MUNICNUM))
  })
)


write_dta(data = municipios_ruins, path = "C:\\Users\\felip\\OneDrive\\Documentos\\PUC\\Data Zoom\\Censo\\1991\\tarefa_18mai\\municipios_inconsistentes.dta")
