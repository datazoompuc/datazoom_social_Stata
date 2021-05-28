



read_description <- function(directory) {
  dic <- read_dictionary(directory)
  input <- read_sas(directory)

  dplyr::full_join(dic, input, by = "variable") %>%
    mutate(factor = grepl(read_format, pattern = "^\\$")) %>% # Factors in SAS start with $
    mutate(double = grepl(read_format, pattern = "^[^\\$].*.$")) %>% # Doubles have dot separated numeric values
    mutate(format_size = gsub(read_format, pattern = "^\\$|\\.$", replacement = "")) %>% # Removes $ from beginning and . from end to get size
    dplyr::select(c("position", "variable", "label", "value", "value_label", "factor", "double", "format_size"))
}

read_dictionary <- function(directory) {
  xls <- dir(directory, pattern = "\\.xls$", full.names = TRUE)
  if (length(xls) == 0) {
    stop("Dictionary file not found in specified directory (maybe it is in a subdirectory?)")
  }

  col_names <- c("position", "size", "variable", "variable_category", "label", "value", "value_label")
  readxl::read_excel(
    xls,
    range = readxl::cell_limits(c(4, NA), c(NA, 7)), # Critical assumption: 4 useless rows and all information in first 7 columns
    col_names = col_names
  ) %>%
    tidyr::fill(position, size, variable, label) %>%
    dplyr::filter(grepl(position, pattern = "^\\d+$")) %>% # Removes more useless rows (section headers for example)
    dplyr::mutate(variable = toupper(variable)) # Need consistent variable names for subsequent join
}

read_sas <- function(directory) {
  sas_path <- dir(directory, pattern = "\\.txt$", full.names = TRUE)
  if (length(sas_path) == 0) {
    stop("Input file not found in specified directory (maybe it is in a subdirectory?)")
  }

  sas <- readr::read_lines(sas_path, locale = readr::locale(encoding = "latin1")) %>%
    gsub(pattern = "\\/\\*.*$", replacement = "") %>% # Removes comments
    trimws() %>% # Removes whitespace from edges
    paste0("\n") # Adds newline to avoid problems with strings ending in null byte

  body_begin <- grep(sas, pattern = "^INPUT", ignore.case = TRUE) + 1
  body_end <- dplyr::last(grep(sas, pattern = "^@"))

  readr::read_table2(
    sas[body_begin:body_end],
    col_names = c("at_position", "variable", "read_format"),
    col_types = readr::cols_only("c", "c", "c")
  ) %>%
    dplyr::mutate(variable = toupper(variable)) # Need consistent variable names for subsequent join
}


dictionary <- read_description("C:/users/arthu/Desktop/dicionario_pnadc")

dictionary <- dictionary %>%
  mutate(var_type = ifelse(factor == TRUE, "factor", "double")) %>%
  select(-c(factor, double))

dictionary_pt.br <- dictionary %>%
  select(variable, label, value, value_label, var_type) %>%
  rename(
    codigo_variavel = variable,
    descricao = label,
    valor = value,
    valor_descricao = value_label,
    classe_variavel = var_type
  )

description_en <-
  #######
  c(
    "ANO" = "Year",
    "TRIMESTRE" = "Quarter",
    "UF" = "State",
    "CAPITAL" = "Capital",
    "RM_RIDE" = "Metropolitan Region",
    "UPA" = "District borders",
    "ESTRATO" = "Stratum",
    "V1008" = "Household selection number",
    "V1014" = "Panel",
    "V1016" = "Household interview number",
    "V1022" = "Type of situation in the area",
    "V1023" = "Area type",
    "V1027" = "Weight without stratification",
    "V1028" = "Weight with stratification",
    "V1029" = "Population projection",
    "POSEST" = "Projecton domain",
    "V2001" = "Number of people in household",
    "V2003" = "Order number",
    "V2005" = "Role in the household",
    "V2007" = "Gender",
    "V2008" = "Day of birth",
    "V20081" = "Month of birth",
    "V20082" = "Year of birth",
    "V2009" = "Resident's age in the ref. date",
    "V2010" = "Skin color or race",
    "V3001" = "Knows how to read and write",
    "V3002" = "Attends school",
    "V3002A" = "The school that ... attends is",
    "V3003" = "Type of course attended (education)",
    "V3003A" = "Type of course attended (education)",
    "V3004" = "Course length",
    "V3005" = "The course is divided into grades",
    "V3005A" = "The course is organized into:",
    "V3006" = "Year/Grade that surveyed attends to",
    "V3006A" = "Stage that surveyed attends to",
    "V3007" = "Finished another graduation course",
    "V3008" = "Attended school before",
    "V3009" = "Highest level of education later completed",
    "V3009A" = "Highest level of education later completed",
    "V3010" = "Length of the last course attended by the surveyed",
    "V3011" = "The course was divided into grades",
    "V3011A" = "The course was divided into:",
    "V3012" = "Approved in the first grade of the course",
    "V3013" = "Last year/ grade completed",
    "V3013A" = "Stage attended by surveyed",
    "V3013B" = "Attended the first years of the course",
    "V3014" = "Finished the course",
    "V4001" = "Worked/Was an intern in paid activity in the form of",
    "V4002" = "Worked/Was an intern in paid activity in the",
    "V4003" = "Participated in an occasional paid activity",
    "V4004" = "Worked without remuneration for household",
    "V4005" = "Was temporally absent from his/her paid work",
    "V4006" = "Reasons for being temporarily absent of work",
    "V4006A" = "Reasons for being temporarily absent of work",
    "V4007" = "Received part of payment when absent of the work",
    "V4008" = "Period of absence from the workplace",
    "V40081" = "Time of Absence in the Workplace (1 to 11 months)",
    "V40082" = "Time of Absence in the Workplace (12 to 23 months)",
    "V40083" = "Time of Absence in the Workplace (2 years or more)",
    "V4009" = "Number of jobs in the reference week",
    "V4010" = "Occupation in the main job",
    "V4012" = "Occupation type",
    "V40121" = "Type of unpaid worker",
    "V4013" = "Code of the main activity from this business/company",
    "V40132" = "Section of economic activity",
    "V40132A" = "Section of economic activity",
    "V4014" = "This job was in the area",
    "V4015" = "Had help from at least one unpaid worker",
    "V40151" = "How many unpaid workers",
    "V401511" = "1 to 5 unpaid workers",
    "V401512" = "6 to 10 unpaid workers",
    "V4016" = "How many employees worked",
    "V40161" = "1 to 5 employees",
    "V40162" = "6 to 10 employees",
    "V40163" = "11 to 50 employees",
    "V4017" = "Had at least one partner in that business",
    "V40171" = "How many partners?",
    "V401711" = "1 to 5 partners",
    "V4018" = "How many people worked in this business",
    "V40181" = "1 to 5 individuals",
    "V40182" = "6 to 10 individuals",
    "V40183" = "11 to 50 individuals",
    "V4019" = "Business / company registered with CNPJ",
    "V4020" = "In what kind of place was this business/company?",
    "V4021" = "Was usually working in this business/company",
    "V4022" = "Then where was the surveyed usually working in this business/company?",
    "V4024" = "Worked in household services for more than one household",
    "V4025" = "Hired as a temporary worker",
    "V4026" = "Hired only by the person responsible for the business",
    "V4027" = "Was hired only by an intermediary",
    "V4028" = "Public servant",
    "V4029" = "Formally employed",
    "V4032" = "Contributed to a pension plan",
    "V4033" = "Monthly gross income (usually received) (auxiliary)",
    "V40331" = "Usually received payment in cash in this job",
    "V403311" = "Income (in cash) bracket (usually received)",
    "V403312" = "Gross income (in cash) (usually received)",
    "V40332" = "Usually received payment in goods in this job",
    "V403321" = "Income (in goods) bracket (usually received)",
    "V403322" = "Monthly gross income (in goods) (usually received)",
    "V40333" = "Usually rec. payment only in the form of benefits",
    "V403331" = "Type of usually rec.payment in the form of benefits",
    "V4034" = "Gross income in the month of ref. (auxiliary)",
    "V40341" = "Received income in cash in the month of ref",
    "V403411" = "Income (in cash) bracket in the month of ref",
    "V403412" = "Gross income (in cash) in the month of ref",
    "V40342" = "Received income (in goods) in the month of ref",
    "V403421" = "Income (in goods) bracket in the month of ref",
    "V403422" = "Gross income (in goods) in the month of ref",
    "V4039" = "Usual working hours (main job)",
    "V4039C" = "Actual working hours in reference week (main job)",
    "V4040" = "For how long have you been working for this job",
    "V40401" = "From 1 month to less than a year",
    "V40402" = "From 1 year to 2 years",
    "V40403" = "2 years or more",
    "V4041" = "Occupation in the secondary job",
    "V4043" = "Occupation type in secondary job",
    "V40431" = "Non-paid worker",
    "V4044" = "Economics activity in the secondary job",
    "V4045" = "This job was in the area",
    "V4046" = "This Business/company was registered with CNPJ",
    "V4047" = "Public servant (secondary job)",
    "V4048" = "Formally employed (secondary job)",
    "V4049" = "Contributed to a pension plan (secondary job)",
    "V4050" = "Monthly gross income (sec. job)",
    "V40501" = "Usually received payment in cash (sec. job)",
    "V405011" = "Income (in cash) bracket (sec. job)",
    "V405012" = "Monthly income in cash (sec. job)",
    "V40502" = "Usually received payment in goods (sec. job)",
    "V405021" = "Income usually received (in goods) bracket (sec. job)",
    "V405022" = "Monthly gross income usually received (in goods, sec. job)",
    "V40503" = "Usually rec. payment only in the form of benefits (sec. job)",
    "V405031" = "Type of usually rec.payment in the form of benefits (sec. job)",
    "V4051" = "Gross income in the month of ref. (sec. job)(auxiliary)",
    "V40511" = "Received income in cash in the month of ref (sec. job)",
    "V405111" = "Income (in cash) bracket in the month of ref (sec. job)",
    "V405112" = "Income (in cash) in the month of ref (sec. job)",
    "V40512" = "Received income (in goods) in the month of ref (sec. job)",
    "V405121" = "Income (in goods) bracket in the month of ref (sec. job)",
    "V405122" = "Gross income (in goods) in the month of ref (sec. job)",
    "V4056" = "Usual working hours (sec. job)",
    "V4056C" = "Actual working hours in reference week (sec. job)",
    "V4057" = "Contributed to a pension plan (other jobs)",
    "V4058" = "Monthly gross income usually received (other jobs)",
    "V40581" = "Usually received income in cash (other jobs)",
    "V405811" = "Income (in cash) bracket usually received (other jobs)",
    "V405812" = "Monthly income usually received in cash (other jobs)",
    "V40582" = "Usually received payment in goods (other jobs)",
    "V405821" = "Income usually received (in goods) bracket (other jobs)",
    "V405822" = "Monthly gross income usually received in goods (other jobs)",
    "V40583" = "Usually rec. payment only in the form of benefits (other jobs)",
    "V405831" = "Type of usually rec.payment in the form of benefits (other jobs)",
    "V40584" = "Unpaid worker (other jobs)",
    "V4059" = "Gross income in month of ref. (other jobs)(auxiliary)",
    "V40591" = "Received income (in cash) in the month of ref (other jobs)",
    "V405911" = "Income (in cash) bracket in the month of ref (other jobs)",
    "V405912" = "Income (in cash) in the month of ref (other jobs)",
    "V40592" = "Received income in  goods in the month of ref (other jobs)",
    "V405921" = "Income (in cash) bracket in the month of ref (other jobs)",
    "V405922" = "Gross income (in goods) in the month of ref (other jobs)",
    "V4062" = "Usual working hours (other jobs)",
    "V4062C" = "Actual working hours in reference week (other jobs)",
    "V4063" = "Willing to work for more hours than actually worked in ref week",
    "V4063A" = "Willing to work for more hours than actually worked in ref week",
    "V4064" = "Would be able to work for more hours than actually worked in ref week",
    "V4064A" = "Would be able to work for more hours than actually worked in ref week",
    "V4071" = "Made an effort to get a job in the last 30 days",
    "V4072" = "Main action taken to get a new job",
    "V4072A" = "Main action taken to get a new job",
    "V4073" = "Was willing to work (no efforts to work tough)",
    "V4074" = "Reasons for not starting to seek for work in the last 30 days",
    "V4074A" = "Reasons for not starting to seek for work",
    "V4075A" = "Time that it will take to start in this new job",
    "V4075A1" = "Months that it will take to start in this new job",
    "V4076" = "Ammount of time trying to get a job",
    "V40761" = "Ammount of time trying to get a job - 1 month to 1 year",
    "V40762" = "Ammount of time trying to get a job - 1 year to 2 years",
    "V40763" = "Ammount of time trying to get a job - more than 2 years",
    "V4077" = "Able to start working in the week of ref",
    "V4078" = "Reasons for not be willing to work in ref week",
    "V4078A" = "Reasons for not be willing to work in ref week",
    "V4082" = "Worked for at least an hour in the last year",
    "VD2002" = "Household condition",
    "VD2003" = "Number of individuals in the household",
    "VD2004" = "Type of domestic unit",
    "VD3004" = "Highest level of instruction completed",
    "VD3005" = "Years of study (5 years old or more)",
    "VD3006" = "Groupment of years of study (5 years old or more)",
    "VD4001" = "Condition in the workforce",
    "VD4002" = "Occupation's condition",
    "VD4003" = "Potential workforce",
    "VD4004" = "Sub-occupation due to lack of effective hours",
    "VD4004A" = "Sub-occupation due to lack of effective hours",
    "VD4005" = "Discouraged people",
    "VD4007" = "Position in the main job",
    "VD4008" = "Position in the main job",
    "VD4009" = "Position in the main job",
    "VD4010" = "Main activity groups in the workplace",
    "VD4011" = "Occupational groups in the main job",
    "VD4012" = "Contributed to a pension plan (any job)",
    "VD4013" = "Bracket - Usual working hours in all jobs",
    "VD4014" = "Bracket - Actual working hours in all jobs in ref week",
    "VD4015" = "Remuneration type in the main job",
    "VD4016" = "Usually received monthly income in the main job",
    "VD4017" = "Effective monthly income earned at the main job",
    "VD4018" = "Type of remuneration in all jobs",
    "VD4019" = "Usually received monthly income for all jobs",
    "VD4020" = "Effective monthly income for all jobs",
    "VD4023" = "Reasons for not be looking for a new job",
    "VD4030" = "Reasons for not be looking for a new job",
    "VD4031" = "Usual working hours in all jobs",
    "VD4032" = "Actual working hours in main job in ref week",
    "VD4033" = "Actual working hours in secondary job in ref week",
    "VD4034" = "Actual working hours in other jobs in ref week",
    "VD4035" = "Actual working hours in all jobs in ref week",
    "VD4036" = "Bracket - Usual working hours in the main job",
    "VD4037" = "Bracket - Actual working hours in the main job in ref week"
  )

######

description_en <- data.frame(
  label_en = description_en,
  variable = names(description_en)
)

dictionary_eng <- left_join(dictionary, description_en)


label_description_en <-
  ######
  c(
    "Número do trimestre (1 a 4)" = "1 to 4",
    "Rondônia" = "Rondônia",
    "Acre" = "Acre",
    "Amazonas" = "Amazonas",
    "Roraima" = "Roraima",
    "Pará" = "Pará",
    "Amapá" = "Amapá",
    "Tocantins" = "Tocantins",
    "Maranhão" = "Maranhão",
    "Piauí" = "Piauí",
    "Ceará" = "Ceará",
    "Rio Grande do Norte" = "Rio Grande do Norte",
    "Paraíba" = "Paraíba",
    "Pernambuco" = "Pernambuco",
    "Alagoas" = "Alagoas",
    "Sergipe" = "Sergipe",
    "Bahia" = "Bahia",
    "Minas Gerais" = "Minas Gerais",
    "Espírito Santo" = "Espírito Santo",
    "Rio de Janeiro" = "Rio de Janeiro",
    "São Paulo" = "São Paulo",
    "Paraná" = "Paraná",
    "Santa Catarina" = "Santa Catarina",
    "Rio Grande do Sul" = "Rio Grande do Sul",
    "Mato Grosso do Sul" = "Mato Grosso do Sul",
    "Mato Grosso" = "Mato Grosso",
    "Goiás" = "Goiás",
    "Distrito Federal" = "Distrito Federal",
    "Município de Porto Velho (RO)" = "Porto Velho (RO) municipality",
    "Município de Rio Branco (AC)" = "Rio Branco (AC) municipality",
    "Município de Manaus (AM)" = "Manaus (AM) municipality",
    "Município de Boa Vista (RR)" = "Boa Vista (RR) municipality",
    "Município de Belém (PA)" = "Belém (PA) municipality",
    "Município de Macapá (AP)" = "Macapá (AP) municipality",
    "Município de Palmas (TO)" = "Palmas (TO) municipality",
    "Município de São Luís (MA)" = "São Luís (MA) municipality",
    "Município de Teresina (PI)" = "Teresina (PI) municipality",
    "Município de Fortaleza (CE)" = "Fortaleza (CE) municipality",
    "Município de Natal (RN)" = "Natal (RN) municipality",
    "Município de João Pessoa (PB)" = "João Pessoa (PB) municipality",
    "Município de Recife (PE)" = "Recife (PE) municipality",
    "Município de Maceió (AL)" = "Maceió (AL) municipality",
    "Município de Aracaju (SE)" = "Aracaju (SE) municipality",
    "Município de Salvador (BA)" = "Salvador (BA) municipality",
    "Município de Belo Horizonte (MG)" = "Belo Horizonte (MG) municipality",
    "Município de Vitória (ES)" = "Vitória (ES) municipality",
    "Município de Rio de Janeiro (RJ)" = "Rio de Janeiro (RJ) municipality",
    "Município de São Paulo (SP)" = "São Paulo (SP) municipality",
    "Município de Curitiba (PR)" = "Curitiba (PR) municipality",
    "Município de Florianópolis (SC)" = "Florianópolis (SC) municipality",
    "Município de Porto Alegre (RS)" = "Porto Alegre (RS) municipality",
    "Município de Campo Grande (MS)" = "Campo Grande (MS) municipality",
    "Município de Cuiabá (MT)" = "Cuiabá (MT) municipality",
    "Município de Goiânia (GO)" = "Goiânia (GO) municipality",
    "Município de Brasília (DF)" = "Brasília (DF) municipality",
    "Região Metropolitana de Manaus (AM)" = "Manaus (AM) metropolitan region",
    "Região Metropolitana de Belém (PA)" = "Belém (PA) metropolitan region",
    "Região Metropolitana de Macapá (AP)" = "Macapá (AP) metropolitan region",
    "Região Metropolitana de Grande São\nLuís (MA)" = "São Luís (MA) metropolitan region",
    "Região Administrativa Integrada\nde Desenvolvimento da Grande Teresina (PI)" =
      "Administrative integrated development region of Teresina (PI)",
    "Região Metropolitana de Fortaleza (CE)" = "Fortaleza (CE) metropolitan region",
    "Região Metropolitana de Natal (RN)" = "Natal (RN) metropolitan region",
    "Região Metropolitana de João Pessoa (PB)" = "João Pessoa (PB) metropolitan region",
    "Região Metropolitana de Recife (PE)" = "Recife (PE) metropolitan region",
    "Região Metropolitana de Maceió (AL)" = "Maceió (AL) metropolitan region",
    "Região Metropolitana de Aracaju (SE)" = "Aracaju (SE) metropolitan region",
    "Região Metropolitana de Salvador (BA)" = "Salvador (BA) metropolitan region",
    "Região Metropolitana de Belo Horizonte (MG)" = "Belo Horizonte (MG) metropolitan region",
    "Região Metropolitana de Grande Vitória (ES)" = "Vitória (ES) metropolitan region",
    "Região Metropolitana de Rio de Janeiro (RJ)" = "Rio de Janeiro (RJ) metropolitan region",
    "Região Metropolitana de São Paulo (SP)" = "São Paulo (SP) metropolitan region",
    "Região Metropolitana de Curitiba (PR)" = "Curitiba (PR) metropolitan region",
    "Região Metropolitana de Florianópolis (SC)" = "Florianópolis (SC) metropolitan region",
    "Região Metropolitana de Porto Alegre (RS)" = "Porto Alegre (RS) metropolitan region",
    "Região Metropolitana de Vale do Rio Cuiabá (MT)" = "Vale do Rio Cuiabá (MT) met
    ropolitan region",
    "Região Metropolitana de Goiânia (GO)" = "Goiânia (GO) metropolitan region",
    "UF (2) + Número Sequencial (6) + DV (1)" = "UF (2) + Sequential Number (6) + DV (1)",
    "As 2 primeiras posições representam o código da Unidade da Federação" =
      "The first two positions represent the state code",
    "Número do domicílio" = "Household number",
    "Grupo de amostra" = "Sample group",
    "Número da entrevista (1 a 5)" = "Interview number (1 to 5)",
    "Urbana" = "Urban",
    "Rural" = "Rural",
    "Capital" = "Capital",
    "Resto da RM (Região Metropolitana, excluindo a capital)" =
      "Rest of metropolitan region (RM), excluding capital",
    "Resto da RIDE (Região Integrada de Desenvolvimento Econômico, excluindo a capital)" =
      "Rest of integrated region of economic development (RIDE)",
    "Resto da UF  (Unidade da Federação, excluindo a região metropolitana e a RIDE)" =
      "Rest of state, excludindg RM and RIDE",
    "Peso trimestral com correção de não entrevista sem pós estratificação pela projeção de população" =
      "Quarter weight with correction for non-interview without post stratification by
    population projection",
    "Peso trimestral com correção de não entrevista com pós estratificação pela projeção de população" =
      "Quarter weight with correction for non-interview with post stratification by
    population projection",
    "Projeção da população do trimestre (referência: mês do meio)" = "Population
    projection in the quarter (reference: middle month)",
    "As 2 primeiras posições representam o código da Unidade da Federação e a última, o tipo de área. UF(2) + V1023(1)" =
      "The first 2 positions represent the state code, and the last, the type of
    area, UF(2) + V1023(1)",
    "Pessoa responsável pelo domicílio" = "Person responsible for the household",
    "Cônjuge ou companheiro(a) de sexo diferente" = "Spouse or partner of opposite sex",
    "Cônjuge ou companheiro(a) do mesmo sexo" = "Spouse or partner of the same sex",
    "Filho(a) do responsável e do cônjuge" = "Son/Daughter of the householder and spouse",
    "Filho(a) somente do responsável" = "Son/Daughter of the householder only",
    "Enteado(a)" = "Stepson or stepdaughter",
    "Genro ou nora" = "Son or daugther in law",
    "Pai, mãe, padrasto ou madrasta" = "Father, mother, stepfather or stepmother",
    "Sogro(a)" = "Father or mother in law",
    "Neto(a)" = "Grandson or granddaughter",
    "Bisneto(a)" = "Great grandson or granddaughter",
    "Irmão ou irmã" = "Brother or sister",
    "Avô ou avó" = "Grandfather or grandmother",
    "Outro parente" = "Other relative",
    "Agregado(a) - Não parente que não compartilha despesas" = "In law that does not share expenses",
    "Convivente - Não parente que compartilha despesas" = "In law that shares expenses",
    "Pensionista" = "Pensioner",
    "Empregado(a) doméstico(a)" = "Housekeeper",
    "Parente do(a) empregado(a) doméstico(a)" = "Housekeeper's relative",
    "Homem" = "Mulher",
    "Mulher" = "Woman",
    "Dia de nascimento" = "Day of birth",
    "Não informado" = "Not informed",
    "Mês" = "Month",
    "Ano" = "Year",
    "Idade (em anos)" = "Age (years)",
    "Branca" = "White",
    "Preta" = "Black",
    "Amarela" = "Yellow",
    "Parda" = "Brown",
    "Indígena" = "Indigenous",
    "Ignorado" = "Ignored",
    "Sim" = "Yes",
    "Não" = "No",
    "Não aplicável" = "Does not apply",
    "Rede privada" = "Private",
    "Rede pública" = "Public",
    "Pré-escolar (maternal e jardim de infância)" = "Preschool (kindergarten)",
    "Alfabetização de jovens e adultos" = "Literacy for youth and adults",
    "Regular do ensino fundamental" = "Regular elementary school",
    "Regular do ensino médio" = "Regular high school",
    "Regular do ensino médio ou do 2º grau" = "Regular high school",
    "Educação de jovens e adultos (EJA) ou supletivo do ensino médio" =
      "Youth and adult education (EJA) or supplementary high school",
    "Educação de jovens e adultos (EJA) ou supletivo do ensino fundamental" =
      "Youth and adult education (EJA) or supplementary elementary school",
    "Superior - graduação" = "Higher education - undergraduate",
    "Mestrado" = "Masters",
    "Doutorado" = "Doctorate",
    "Creche (disponível apenas no questionário anual de educação)" =
      "Nursery (available only on the annual education questionnaire)",
    "Pré-escola" = "Preschool",
    "Educação de jovens e adultos (EJA) do ensino fundamental" =
      "Youth and adult education (EJA) for elementary school",
    "Educação de jovens e adultos (EJA) do ensino médio" =
      "Youth and adult school (EJA) for high school",
    "Especialização de nível superior" = "Higher education especialization",
    "8 anos" = "8 years",
    "9 anos" = "9 years",
    "Períodos semestrais" = "Semester periods",
    "Anos" = "Years",
    "Outra forma" = "Other",
    "Primeira (o)" = "First",
    "Segunda (o)" = "Second",
    "Terceira (o)" = "Third",
    "Quarta (o)" = "Fourth",
    "Quinta (o)" = "Fifth",
    "Sexta (o)" = "Sixth",
    "Sétima (o)" = "Seventh",
    "Oitava (o)" = "Eigth",
    "Nona (o)" = "Ninth",
    "Décimo" = "Tenth",
    "Décimo primeiro" = "Eleventh",
    "Décimo segundo" = "Twelfth",
    "Curso não classificado em séries ou anos" = "Course not classified in grades
    or years",
    "Classe de alfabetização - CA" = "Literacy class",
    "Anos iniciais (primeiro segmento)" = "Initial years (first segment)",
    "Anos finais (segundo segmento)" = "Final years (second segment)",
    "Regular do ensino fundamental ou do 1º grau" = "Regular elementary school",
    "Antigo primário (elementar)" = "Elementary school (old classification)",
    "Antigo ginásio (médio 1º ciclo)" = "High school (old classification)",
    "Antigo científico, clássico, etc. (médio 2º ciclo)" = "Old high school",
    "Educação de jovens e adultos (EJA) ou supletivo do 1º grau" =
      "Youth and adult education (EJA) or supplementary elementary school",
    "Regular do ensino médio óu do 2º grau" = "Regular high school",
    "Educação de jovens e adultos (EJA) ou supletivo do 2º grau" =
      "Youth and adult education (EJA) or supplementary high school",
    "Concluiu" = "Concluded",
    "Não concluiu" = "Did not conclude",
    "Férias, folga ou jornada de trabalho variável" = "Vacation, time off or variable
    working hours",
    "Licença maternidade" = "Maternity leave",
    "Licença remunerada por motivo de doença ou acidente da própria pessoa" =
      "Paid leave due to illness or accident of the person himself",
    "Outro tipo de licença remunerada (estudo, paternidade, casamento, licença prêmio, etc.)" =
      "Other type of paid leave (study, paternity, wedding, etc.)",
    "Fatores ocasionais (tempo, paralisação nos serviços de transportes, etc.)" =
      "Occasional factors (weather, stoppage in transportation services, etc.)",
    "Greve ou paralisação" = "Strike or stoppage",
    "Outro motivo" = "Other reason",
    "Licença maternidade ou paternidade" = "Paternity or maternity leave",
    "Licença remunerada por motivo de saúde ou acidente da própria pessoa" =
      "Paid leave because of health or accident from the person himself",
    "Menos de 1 mês" = "Less than a month",
    "De 1 mês a menos de 1 ano" = "From one month to less than one year",
    "De 1 ano a menos de 2 anos" = "From one year to less than two years",
    "2 anos ou mais" = "Two years or more",
    "01 a 11 meses" = "1 to 11 months",
    "00 a 11 meses" = "0 to 11 months",
    "02 anos ou mais" = "2 years or more",
    "Um" = "One",
    "Dois" = "Two",
    "Três ou mais" = "Three or more",
    "Ver  \"Composição dos Grupamentos Ocupacionais\" e \"Classificação de Ocupações para as Pesquisas Domiciliares – COD\" em ANEXO de Notas Metodológicas" =
      'See \"Composição dos Grupamentos Ocupacionais\" e \"Classificação de
    Ocupações para as Pesquisas Domiciliares – COD\" attached to methodological notes',
    "Agricultura, pecuária silvicultura, exploração florestal, pesca ou aquicultura" =
      "Agriculture, livestock, forestry, fishery or aquaculture",
    "Trabalhador doméstico" = "Housekeeper",
    "Militar do exército, da marinha, da aeronáutica, da polícia militar ou do corpo de bombeiros militar" =
      "Military from army, navy, air-force, military police or from military firefighters",
    "Empregado do setor privado" = "Private sector employee",
    "Empregado do setor público (inclusive empresas de economia mista)" =
      "Public sector employees (including mixed companies)",
    "Empregador" = "Employer",
    "Conta própria" = "Self employed",
    "Trabalhador familiar não remunerado" = "Unpaid family worker",
    "Em ajuda a conta própria ou empregador" = "In help to self employed or employer",
    "Em ajuda a empregado" = "In help to employee",
    "Em ajuda a trabalhador doméstico" = "In help to housekeeper",
    "Ver \"Composição dos Grupamentos de Atividade\" e “Relação de Códigos de Atividades” da CNAE-Domiciliar" =
      'See \"Composição dos Grupamentos de Atividade\" and
    “Relação de Códigos de Atividades” from CNAE-Domiciliar attached to methodological notes',
    "Outra atividade, inclusive as atividades de apoio à agricultura, pecuária, silvicultura, exploração florestal, pesca ou aquicultura." =
      "Other activity, including activities in support of agriculture, livestock,
    forestry, fishery or aquaculture",
    "Agricultura, pecuária silvicultura, exploração florestal, pesca ou aquicultura e atividades de apoio à agricultura, pecuária, silvicultura, exploração florestal, pesca ou aquicultura." =
      "Agriculture, livestock, forestry, fishery or aquaculture",
    "Outra atividade" = "Other activity",
    "Federal" = "Federal",
    "Estadual" = "State",
    "Municipal" = "Municipal",
    "1 a 5 trabalhadores não remunerados" = "1 to 5 unpaid workers",
    "6 a 10 trabalhadores não remunerados" = "6 to 10 unpaid workers",
    "11 ou mais trabalhadores não remunerados" = "11 or more unpaid workers",
    "06 a 10 trabalhadores não remunerados" = "6 to 10 unpaid workers",
    "1 a 5 empregados" = "1 to 5 employees",
    "6 a 10 empregados" = "6 to 10 employees",
    "11 a 50 empregados" = "11 to 50 employees",
    "51 ou mais empregados" = "51 or more employees",
    "06 a 10 empregados" = "6 to 10 employees",
    "1 a 5 sócios" = "1 to 5 partners",
    "6 ou mais sócios" = "6 or more partners",
    "1 a 5 pessoas" = "1 to 5 people",
    "6 a 10 pessoas" = "6 to 10 people",
    "11 a 50 pessoas" = "11 to 50 people",
    "51 ou mais pessoas" = "51 or more people",
    "06 a 10 pessoas" = "6 to 10 people",
    "Em loja, escritório, galpão, etc." = "In store, office, warehouse, etc.",
    "Em fazenda, sítio, granja, chácara, etc." = "On farm",
    "Não tinha estabelecimento para funcionar" = "There was no establishment to operate",
    "Em estabelecimento de outro négocio/empresa" = "In an establishment of another business",
    "Em local designado pelo empregador, cliente ou freguês" = "At a location designated
    by the employer or by the customer",
    "Em domicílio de empregador, patrão, sócio ou freguês" = "At the home of an employer,
    boss, customer or partner",
    "No domicílio de residência, em local exclusivo para o desempenho da atividade" =
      "At home, in an exclusive place for performance of the activity",
    "No domicílio de residência, sem local exclusivo para o desempenho da atividade" =
      "At home, without an exclusive place for performance of the activity",
    "Em veículo automotor (táxi, ônibus, caminhão, automóvel, embarcação, etc.)" =
      "In a motor vehicle (taxi, bus, truck, car, boat, etc.)",
    "Em via ou área pública (rua, rio, manguezal, mata pública, praça, praia etc.)" =
      "In public area (street, river, mangrove, public forest, square, beach, etc.)",
    "Em outro local, especifique" = "In other place, specify",
    "Indica se o quesito foi respondido" = "Indicates if the question was answered",
    "Em dinheiro" = "In cash",
    "Não ou não aplicável" = "No or does not apply",
    "1 a [0,5SM]" = "1 to [0.5 MW]",
    "[0,5SM]+1 a [1SM]" = "[0.5 MW]+1 to [1 MW]",
    "[1SM]+1 a [2SM]" = "[1 MW]+1 to [2 MW]",
    "[2SM]+1 a [3SM]" = "[2 MW]+1 to [3 MW]",
    "[3SM]+1 a [5SM]" = "[3 MW]+1 to [5 MW]",
    "[5SM]+1 a [10SM]" = "[5 MW]+1 to [10 MW]",
    "[10SM]+1 a [20SM]" = "[19 MW]+1 to [20 MW]",
    "[20SM]+1 ou mais" = "[20 MW]+1 or more",
    "R$" = "R$",
    "Em produtos ou mercadorias" = "In products",
    "Em benefícios" = "In benefits",
    "Pessoa recebendo somente em beneficios, exceto aprendizado" =
      "Person receiving only in benefits, except apprenticeship",
    "Aprendiz ou estagiário recebendo em aprendizado e outros beneficios" =
      "Apprentice of intern receiving in apprenticeship and other benefits",
    "Aprendiz ou estagiário recebendo somente em aprendizado" =
      "Apprentice or intern receiving only in apprenticeship",
    "0" = "0",
    "Horas" = "Hours",
    "01 mês a 11 meses" = "1 to 11 months",
    "Ver \"Classificação nacional de ocupações para pesquisas domiciliares (COD) 2010\"" =
      'See \"Classificação nacional de ocupações para pesquisas domiciliares (COD) 2010\"',
    "Trabalhador não remunerado em ajuda a membro do domicílio ou parente" =
      "Unpaid worker in help of member of the household or relative",
    "Ver \"Composição dos Grupamentos de Atividade\" e
    “Relação de Códigos de Atividades” da CNAE-Domiciliar" =
      'See \"Composição dos Grupamentos de Atividade\" and
    “Relação de Códigos de Atividades” from CNAE-Domiciliar',
    "Produtos ou mercadorias" = "Goods",
    "Não remunerado" = "Unpaid",
    "Entrou diretamente em contato com empregador (em fábrica, fazenda, mercado, loja ou outro local de trabalho)" =
      "Directly contacted employer (in factory, farm, market, store or other workplace)",
    "Fez ou inscreveu-se em concurso" = "Done or signed up for tender",
    "Consultou agência privada ou sindicato" = "Consulted on private agency or union",
    "Consultou agência municipal, estadual ou o Sistema Nacional de Emprego (SINE)" =
      "Consulted on municipal or state agency or the Nacional Employment System (SINE)",
    "Colocou ou respondeu anúncio" = "Posted or answered to ad",
    "Consultou parente, amigo ou colega" = "Consulted a relative, friend or colleague",
    "Buscou ajuda financeira para iniciar o próprio negócio" = "Looked for financial help to
    start own business",
    "Procurou local, equipamento ou maquinário para iniciar o próprio negócio" =
      "Looked for place, equipment or machinery to start own business",
    "Solicitou registro ou licença para iniciar o próprio negócio" =
      "Requested registration or license to start own business",
    "Tomou outra providência" = "Took other measure",
    "Não tomou providência efetiva" = "Did not take effective measure",
    "Entrou em contato com empregador (pessoalmente, por telefone, por email ou pelo portal da empresa, inclusive enviando currículo)" =
      "Contacted employer (in person, by phone, email, company's website, including
      sending CV",
    "Consultou ou inscreveu-se em agência de emprego privada ou sindicato" =
      "Consulted or signed up at private employment agency or union",
    "Consultou ou inscreveu-se em agência de emprego municipal, estadual ou no Sistema Nacional de Emprego (SINE)" =
      "Consulted or signed up at municipal or state agency or the Nacional Employment System (SINE)",
    "Tomou medida para iniciar o próprio negócio (recursos financeiros, local para instalação, equipamentos, legalização etc.)" =
      "Took measure to start own business (financial resources, place for installation,
    equipments, legalization etc.)",
    "Tomou outra providência, especifique:" = "Took other measure, specify:",
    "Conseguiu proposta de trabalho para começar após a semana de referência" =
      "Got job offer to start after reference week ",
    "Aguardando resposta de medida tomada para conseguir trabalho" =
      "Waiting for answer on measure taken to get job",
    "Desistiu de procurar por não conseguir encontrar trabalho" =
      "Gave up on searching because of not finding job",
    "Acha que não vai encontrar trabalho por ser muito jovem ou muito idoso" =
      "Thinks will not be able to get job because of being to young or too old",
    "Tinha que cuidar de filho(s), de outro(s) dependente(s) ou dos afazeres domésticos" =
      "Had to take care of of son(s), of other dependent(s) or household chores",
    "Estudo" = "Study",
    "Incapacidade física, mental ou doença permanente" = "Physical or mental disability or
    permanent illness",
    "Estava aguardando resposta de medida tomada para conseguir trabalho" =
      "Was waiting for answer on measure taken to get job",
    "Não conseguia trabalho adequado" = "Could not get adequate job",
    "Não tinha experiência profissional ou qualificação" =
      "Did not have professional experience or qualification",
    "Não conseguia trabalho por ser considerado muito jovem ou muito idoso" =
      "Was not able to get job because of being to young or too old",
    "Não havia trabalho na localidade" = "There was no job in location",
    "Tinha que cuidar dos afazeres domésticos, do(s) filho(s) ou de outro(s) parente(s)" =
      "Had to take care of of son(s), of other dependent(s) or household chores",
    "Estava estudando (curso de qualquer tipo ou por conta própria)" =
      "Was studying (course of any kind, or by himself)",
    "Por problema de saúde ou gravidez" = "For health problem or pregnancy",
    "Outro motivo, especifique" = "Other reason, specify",
    "1 ano ou mais" = "1 year or more",
    "Aposentado ou idoso para trabalhar" = "Retired or elderly to work",
    "Muito jovem para trabalhar" = "Too young to work",
    "Não desejava trabalhar" = "Did not wish to work",
    "Estava estudando (em curso de qualquer tipo ou por conta própria)" =
      "Was studying (course of any kind, or by himself)",
    "Por ser muito jovem ou muito idoso para trabalhar" =
      "For being too young or old to work",
    "Por não querer trabalhar" = "For not wanting to work",
    "Outro motivo, especifique:" = "Other reason, specify",
    "Pessoa responsável" = "Responsible person",
    "Cônjuge ou companheiro(a)" = "Spouse or partner",
    "Filho(a)" = "Son or daughter",
    "Agregado(a)" = "In law that shares expenses",
    "Convivente" = "In law that does not shares expenses",
    "Unipessoal" = "Unipersonal",
    "Nuclear" = "Nuclear",
    "Estendida" = "Extended",
    "Composta" = "Composite",
    "Sem instrução e menos de 1 ano de estudo" = "No instruction and less than
    1 years of study",
    "Fundamental incompleto ou equivalente" = "Incomplete elementary school or
    equivalent",
    "Fundamental completo ou equivalente" = "Concluded elementary school or equivalent",
    "Médio incompleto ou equivalente" = "Incomplete high school or equivalent",
    "Médio completo ou equivalente" = "Concluded high school or equivalent",
    "Superior incompleto ou equivalente" = "Incomplete higher education or equivalent",
    "Superior completo" = "Concluded higher education",
    "1 ano de estudo" = "1 year of study",
    "2 anos de estudo" = "2 years of study",
    "3 anos de estudo" = "3 years of study",
    "4 anos de estudo" = "4 years of study",
    "5 anos de estudo" = "5 years of study",
    "6 anos de estudo" = "6 years of study",
    "7 anos de estudo" = "7 years of study",
    "8 anos de estudo" = "8 years of study",
    "9 anos de estudo" = "9 years of study",
    "10 anos de estudo" = "10 years of study",
    "11 anos de estudo" = "11 years of study",
    "12 anos de estudo" = "12 years of study",
    "13 anos de estudo" = "13 years of study",
    "14 anos de estudo" = "14 years of study",
    "15 anos de estudo" = "15 years of study",
    "16 anos ou mais de estudo" = "16 years or more of study",
    "1 a 4 anos de estudo" = "1 to 4 years of study",
    "5 a 8 anos de estudo" = "5 to 8 years of study",
    "9 a 11 anos de estudo" = "9 to 11 years of study",
    "12 a 15 anos de estudo" = "12 to 15 years of study",
    "Pessoas na força de trabalho" = "People in the workforce",
    "Pessoas fora da força de trabalho" = "People out of the workforce",
    "Pessoas ocupadas" = "Occupied people",
    "Pessoas desocupadas" = "Unoccupied people",
    "Pessoas fora da força de trabalho e na força de trabalho potencial" =
      "People out of the workforce and in the potential workforce",
    "Pessoas fora da força de trabalho e fora da força de trabalho potencial" =
      "People out of the workforce and out of the potential workforce",
    "Pessoas subocupadas" = "Sub-occupied people",
    "Pessoas desalentadas" = "Discouraged people",
    "Empregado (inclusive trabalhador doméstico)" = "Employee (including domestic workers)",
    "Trabalhador familiar auxiliar" = "Auxiliary family worker",
    "Empregado no setor privado" = "Employed in the private sector",
    "Empregado no setor público (inclusive servidor estatutário e militar)" =
      "Employed in the public sector (including statutary servant and the military)",
    "Conta-própria" = "Self employed",
    "Empregado no setor privado com carteira de trabalho assinada" =
      "Employed in the private sector with a formal contract",
    "Empregado no setor privado sem carteira de trabalho assinada" =
      "Employed in the private sector without a formal contract",
    "Trabalhador doméstico com carteira de trabalho assinada" =
      "Housekeeper employed with a formal contract",
    "Trabalhador doméstico sem carteira de trabalho assinada" =
      "Housekeeper employed without a formal contract",
    "Empregado no setor público com carteira de trabalho assinada" =
      "Employed in the public sector with a formal contract",
    "Empregado no setor público sem carteira de trabalho assinada" =
      "Employed in the public sector without a formal contract",
    "Militar e servidor estatutário" = "Military and statutory worker",
    "Agricultura, pecuária, produção florestal, pesca e aquicultura" =
      "Agriculture, livestock, forestry, fishery and aquaculture",
    "Indústria geral" = "Manufacturing in general",
    "Construção" = "Construction",
    "Comércio, reparação de veículos automotores e motocicletas" =
      "Commerce, repair of motor vehicles and motorcycles",
    "Informação, comunicação e atividades financeiras, imobiliárias, profissionais e administrativas" =
      "Information, communication and financial, real estate, professional, and
    administrative activities",
    "Educação, saúde humana e serviços sociais" = "Education, human health, and
    social services",
    "Outros Serviços" = "Other services",
    "Serviços domésticos" = "Domestic services",
    "Atividades mal definidas" = "Ill-defined activities",
    "Diretores e gerentes" = "Directors and managers",
    "Profissionais das ciências e intelectuais" = "Science professionals and intellectuals",
    "Técnicos e profissionais de nível médio" = "Mid-level technicians and professionals",
    "Trabalhadores de apoio administrativo" = "Administrative support workers",
    "Trabalhadores dos serviços, vendedores dos comércios e mercados" =
      "Service workers, shop sellers and markets",
    "Trabalhadores qualificados da agropecuária, florestais, da caça e da pesca" =
      "Skilled agricultural, forestry, hunting and fishing workers",
    "Trabalhadores qualificados, operários e artesões da construção, das artes mecânicas e outros ofícios" =
      "Skilled workers, construction workers and artisans, mechanical, and other crafts",
    "Operadores de instalações e máquinas e montadores" = "Plant and machine operators
    and assemblers",
    "Ocupações elementares" = "Elementary occupations",
    "Membros das forças armadas, policiais e bombeiros militares" =
      "Members of the armed forces, policemen and military firemen",
    "Ocupações maldefinidas" = "Ill defined occupations",
    "Contribuinte" = "Contributor",
    "Não contribuinte" = "Not contributor",
    "Até 14 horas" = "At most 14 hours",
    "15 a 39 horas" = "15 to 39 hours",
    "40 a 44 horas" = "40 to 44 hours",
    "45 a 48 horas" = "45 to 48 hours",
    "49 horas ou mais" = "49 hours or more",
    "Remuneração em dinheiro, produtos ou mercadorias no trabalho principal" =
      "Payment in cash, products or goods on the main job",
    "Remuneração em benefícios ou sem remuneração no trabalho principal" =
      "Payment in benefits or without payment on the main job",
    "Remuneração em dinheiro, produtos ou mercadorias em pelo menos um dos trabalhos" =
      "Payment in cash, products or goods on at least one of the jobs",
    "Remuneração em benefícios ou sem remuneração em todos os trabalhos" =
      "Payment in benefits or withou payment on all jobs",
    "Tinha que cuidar dos afazeres domésticos, do(s) filho(s) ou de outro(s) dependente(s)" =
      "Had to take care of of son(s), of other dependent(s) or household chores",
    "Estava estudando" = "Was studying",
    "Por incapacidade física, mental ou doença permanente" = "For physical or mental
    disability or permanent illness",
    "Por outro motivo" = "For other reason",
    "Não se aplica" = "Does not apply",
    "Afastamento do próprio negócio/empresa por motivo de gestação, doença, acidente, etc., sem ser remunerado por instituto de previdência" =
      "Temporary absence of own business because of pregnancy, illness, accident, etc.,
    without payment by pension institution",
    "Ver \"Composição dos Grupamentos de Atividade\" e “Relação de Códigos de Atividades” da CNAE-Domiciliar  em ANEXO de Notas Metodológicas" =
      'See \"Composição dos Grupamentos de Atividade\" and “Relação de Códigos de Atividades” of CNAE-Domiciliar  in appendix with methodological notes',
    "Colocou ou respondeu anúncio de trabalho em jornal ou revista" =
      "Placed or replied job advertisement in newspaper or magazine",
    "Pessoa(s)" = "People",
    "Alojamento e alimentação " = "Accomodation and food",
    "Administração pública, defesa e seguridade social " =
      "Public administration, defense and social security",
    "Transporte, armazenagem e correio" = "Transportation, storage, and mail"
  )
######

label_description_en <- data.frame(
  value_label_en = label_description_en,
  value_label = names(label_description_en)
)

dictionary_eng <- left_join(dictionary_eng, label_description_en)

dictionary_eng$value_label_en[862] <- "Transportation, storage, and mail"
dictionary_eng$value_label_en[863] <- "Accommodation and food"
dictionary_eng$value_label_en[865] <- "Public administration, defense and social security"

dictionary_eng <- dictionary_eng %>%
  mutate(
    variable = case_when(
      variable == "ANO" ~ "Year",
      variable == "TRIMESTRE" ~ "Quarter",
      variable == "CAPITAL" ~ "Capital",
      variable == "ESTRATO" ~ "Stratum",
      TRUE ~ variable
    )
  )

data_labels <- data.frame(
  variable_eng = dictionary_eng$variable,
  variable_pt.br = dictionary_pt.br$codigo_variavel,
  position = dictionary_eng$position,
  label_eng = dictionary_eng$label_en,
  label_pt.br = dictionary_pt.br$descricao
)

data_labels <- distinct(data_labels)

data_labels$position <- as.numeric(data_labels$position)


dictionary_eng <- dictionary_eng %>%
  select(variable, label_en, value, value_label_en, var_type) %>%
  rename(
    label = label_en,
    value_label = value_label_en
  )


save(dictionary_eng, dictionary_pt.br,
  file = "./data/data.RData"
)
