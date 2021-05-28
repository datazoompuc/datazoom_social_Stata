#' @importFrom dplyr %>%
#' @importFrom labelled set_variable_labels
#' @importFrom purrr map map2
#' @importFrom readr cols read_csv col_double col_integer
#' @importFrom stringr str_pad

NULL






#' Loading and compilating PNAD COVID19 microdata
#'
#' Extracts and builds databases from the PNAD COVID19 survey in R format (.RData) from
#' the original microdata - for information on how to get the original data files, check IBGE's website -
#' www.ibge.gov.br .
#' Since the survey is still being published by IBGE,
#' this function is subject to frequent updates.
#' The function generates one database per month of the survey. If it is the case, use
#' the \code{\link{dplyr::bind_rows}} command to stack all data.
#'
#' @param dir_data Directory in which original .txt are located
#'
#' @param lang In which language will the variables be labelled. Default, \code{lang = "eng"} is
#' in English. For Brazilian Portuguese, set \code{lang = "pt_br"}.
#'
#' @param ... vectors with survey dates as in  \code{c('MM', 'YYYY')}
#'
#' @return Dataframe list, with each entry corresponding to a date in \code{...}
#' @encoding UTF-8
#' @export
#'
#' @examples
#' pnad_covid_microdata('./Desktop', c(5, 2020))
#'

pnad_covid_microdata <- function(dir_data, lang = "eng",
                       ...){

  datas <- list(...)

# Mensagens de erro em caso de escolha errada de datas

  if (any(map(datas, length) != 2)) {stop('Pick the same number of months and years', call. = FALSE)}
  mes <- datas %>% map( ~ .x[[1]])
  ano <- datas %>% map( ~ .x[[2]])

  if (sum(mes %in% 5:12 == F) > 0) {stop('PNAD-Covid starts in May of 2020', call. = FALSE)}
  if (sum(ano != 2020) > 0) {stop('The survey considers data from 2020', call. = FALSE)}

# Nome do arquivo muda de acordo com a data escolhida

mes <- mes %>% map(~.x %>% str_pad(width = 2, pad = 0))
datas <- map2(mes, ano, paste0)

### Gerando caminhos dos arquivos

filepath_in <- datas %>% map(~ .x %>% paste0('PNAD_COVID_',., '.csv') %>%
                               file.path(dir_data, ., sep = '')
                             )
## Carregando arquivos

dados <- filepath_in %>%
  #####
map( ~ .x %>%
       read_csv(
         .,
         col_types = cols(
           Ano = col_integer(),
           UF = col_integer(),
           CAPITAL = col_integer(),
           RM_RIDE = col_integer(),
           V1008 = col_integer(),
           V1012 = col_integer(),
           V1013 = col_integer(),
           V1016 = col_integer(),
           V1022 = col_integer(),
           V1023 = col_integer(),
           posest = col_integer(),
           A001 = col_integer(),
           A001A = col_integer(),
           A001B1 = col_integer(),
           A001B2 = col_integer(),
           A001B3 = col_integer(),
           A002 = col_integer(),
           A003 = col_integer(),
           A004 = col_integer(),
           A005 = col_integer(),
           B0011 = col_integer(),
           B0012 = col_integer(),
           B0013 = col_integer(),
           B0014 = col_integer(),
           B0015 = col_integer(),
           B0016 = col_integer(),
           B0017 = col_integer(),
           B0018 = col_integer(),
           B0019 = col_integer(),
           B00110 = col_integer(),
           B00111 = col_integer(),
           B00112 = col_integer(),
           B002 = col_integer(),
           B0031 = col_integer(),
           B0032 = col_integer(),
           B0033 = col_integer(),
           B0034 = col_integer(),
           B0035 = col_integer(),
           B0036 = col_integer(),
           B0037 = col_integer(),
           B0041 = col_integer(),
           B0042 = col_integer(),
           B0043 = col_integer(),
           B0044 = col_integer(),
           B0045 = col_integer(),
           B0046 = col_integer(),
           B005 = col_integer(),
           B006 = col_integer(),
           B007 = col_integer(),
           C001 = col_integer(),
           C002 = col_integer(),
           C003 = col_integer(),
           C004 = col_integer(),
           C005 = col_integer(),
           C0051 = col_integer(),
           C0052 = col_integer(),
           C0053 = col_integer(),
           C006 = col_integer(),
           C007 = col_integer(),
           C007A = col_integer(),
           C007B = col_integer(),
           C007C = col_integer(),
           C007D = col_integer(),
           C007E = col_integer(),
           C007E1 = col_integer(),
           C007E2 = col_integer(),
           C008 = col_integer(),
           C009 = col_integer(),
           C010 = col_integer(),
           C0101 = col_integer(),
           C01011 = col_integer(),
           C01012 = col_double(),
           C0102 = col_integer(),
           C01021 = col_integer(),
           C01022 = col_double(),
           C0103 = col_integer(),
           C0104 = col_integer(),
           C011A = col_double(),
           C011A1 = col_integer(),
           C011A11 = col_integer(),
           C011A12 = col_double(),
           C011A2 = col_integer(),
           C011A21 = col_integer(),
           C011A22 = col_double(),
           C012 = col_integer(),
           C013 = col_integer(),
           C014 = col_integer(),
           C015 = col_integer(),
           C016 = col_integer(),
           C017A = col_integer(),
           D0011 = col_integer(),
           D0013 = col_double(),
           D0021 = col_integer(),
           D0023 = col_double(),
           D0031 = col_integer(),
           D0033 = col_double(),
           D0041 = col_integer(),
           D0043 = col_double(),
           D0051 = col_integer(),
           D0053 = col_double(),
           D0061 = col_integer(),
           D0063 = col_double(),
           D0071 = col_integer(),
           D0073 = col_double(),
           F001 = col_integer(),
           F0021 = col_double(),
           F0022 = col_integer(),
           F0061 = col_integer(),
           F006 = col_integer()
         )
       ))

### Definindo labels, em português ou inglês

Descricoes <- data.frame(
  Codigo_da_variavel = c(
    "Ano",
    "UF",
    "CAPITAL",
    "RM_RIDE",
    "V1008",
    "V1012",
    "V1013",
    "V1016",
    "Estrato",
    "UPA",
    "V1022",
    "V1023",
    "V1030",
    "V1031",
    "V1032",
    "posest",
    "A001",
    "A001A",
    "A001B1",
    "A001B2",
    "A001B3",
    "A002",
    "A003",
    "A004",
    "A005",
    "B0011",
    "B0012",
    "B0013",
    "B0014",
    "B0015",
    "B0016",
    "B0017",
    "B0018",
    "B0019",
    "B00110",
    "B00111",
    "B00112",
    "B002",
    "B0031",
    "B0032",
    "B0033",
    "B0034",
    "B0035",
    "B0036",
    "B0037",
    "B0041",
    "B0042",
    "B0043",
    "B0044",
    "B0045",
    "B0046",
    "B005",
    "B006",
    "B007",
    "C001",
    "C002",
    "C003",
    "C004",
    "C005",
    "C0051",
    "C0052",
    "C0053",
    "C006",
    "C007",
    "C007A",
    "C007B",
    "C007C",
    "C007D",
    "C007E",
    "C007E1",
    "C007E2",
    "C008",
    "C009",
    "C010",
    "C0101",
    "C01011",
    "C01012",
    "C0102",
    "C01021",
    "C01022",
    "C0103",
    "C0104",
    "C011A",
    "C011A1",
    "C011A11",
    "C011A12",
    "C011A2",
    "C011A21",
    "C011A22",
    "C012",
    "C013",
    "C014",
    "C015",
    "C016",
    "C017A",
    "D0011",
    "D0013",
    "D0021",
    "D0023",
    "D0031",
    "D0033",
    "D0041",
    "D0043",
    "D0051",
    "D0053",
    "D0061",
    "D0063",
    "D0071",
    "D0073",
    "F001",
    "F0021",
    "F0022",
    "F0061",
    "F006"
  ),
  descricao_port = c(
    "Ano de referência",
    "Unidade da Federação",
    "Capital",
    "Região Metropolitana e Região Administrativa Integrada de Desenvolvimento",
    "Número de seleção do domicílio",
    "Semana no mês",
    "Mês da pesquisa",
    "Número da entrevista no domicílio",
    "Estrato",
    "UPA",
    "Situação do domicílio",
    "Tipo de área",
    "Projeção da população",
    "Peso do domicílio e das pessoas",
    "Peso do domicílio e das pessoas",
    "Domínios de projeção",
    "Número de ordem",
    "Condição no domicílio",
    "Dia de nascimento",
    "Mês de nascimento",
    "Ano de nascimento",
    "Idade do morador",
    "Sexo",
    "Cor ou raça",
    "Escolaridade",
    "Nos últimos sete dias teve febre?",
    "Nos últimos sete dias teve tosse?",
    "Nos últimos sete dias teve dor de garganta?",
    "Nos últimos sete dias teve dificuldade para respirar?",
    "Nos últimos sete dias teve dor de cabeça?",
    "Nos últimos sete dias teve dor no peito?",
    "Nos últimos sete dias teve nausea?",
    "Nos últimos sete dias teve nariz entupido ou escorrendo?",
    "Nos últimos sete dias teve fadiga?",
    "Nos últimos sete dias teve dor nos olhos?",
    "Nos últimos sete dias teve perda de cheiro ou sabor?",
    "Nos últimos sete dias teve dor muscular?",
    "Por causa disso, foi a algum estabelecimento de saude?",
    "Providência tomada para recuperar dos sintomas foi ficar em casa",
    "Providência tomada para recuperar dos sintomas foi ligar para algum
    profissional de saúde",
    "Providência tomada  para recuperar dos sintomas foi comprar e/ou tomar
    remédio por conta própria",
    "Providência tomada para recuperar dos sintomas foi comprar
                              e/ou tomar remédio por orientação médica",
    "Providência tomada para recuperar dos sintomas foi
                              receber visita de algum profissional de saúde do
    SUS (equipe de saúde da família, agente comunitário, etc.)",
    "Providência tomada para recuperar dos sintomas foi receber
                              visita de profissional de saúde particular",
    "Providência tomada para recuperar dos sintomas foi outra",
    "Local que buscou atendimento foi posto de saúde/Unidade básica de
    saúde /Equipe de Saúde da Família (médico, enfermeiro, técnico de enfermagem
    ou agente comunitário de saúde)",
    "Local que buscou atendimento foi pronto socorro do SUS/UPA",
    "Local que buscou atendimento foi hospital do SUS",
    "Local que buscou atendimento foi ambulatório ou consultório privado ou
    ligado às forças armadas",
    "Local que buscou atendimento foi pronto socorro privado ou ligado às
    forças armadas",
    "Local que buscou atendimento foi hospital privado ou ligado às forças armadas",
    "Ao procurar o hospital, teve que ficar internado por um dia ou mais",
    "Durante a internação, foi sedado, entubado e colocado em
    respiração artificial com ventilador",
    "Tem algum plano de saúde médico, seja particular,
    de empresa ou de órgão público",
    "Na semana passada, por pelo menos uma hora, trabalhou ou fez algum bico?",
    "Na semana passada, estava temporariamente afastado de algum trabalho?",
    "Qual o principal motivo deste afastamento temporário?",
    "Continuou a ser remunerado (mesmo que parcialmente) por esse trabalho",
    "Há quanto tempo está afastado desse trabalho?",
    "Tempo que estava afastado (De 1 mês a menos de 1 ano)",
    "Tempo que estava afastado (De 1 ano a menos de 2 anos)",
    "Tempo que estava afastado (de 02 anos a 98 anos)",
    "Tem mais de um trabalho",
    "No trabalho (único ou principal) que tinha nessa semana, era:",
    "Esse trabalho era na área:",
    "Tem carteria de trabalho assinada ou é funcionário público estatutário?",
    "Que tipo de trabalho, cargo ou função você realiza no seu trabalho (único
    ou principal)?",
    "Qual é a principal atividade do local ou empresa em que você trabalha?",
    "Na semana passada, quantos empregados trabalhavam nesse negócio/empresa
    que ... tinha ?",
    "1 a 5 empregados",
    "6 a 10 empregados",
    "Quantas horas, por semana, normalmente trabalhava?",
    "Quantas horas, na semana passada, de fato trabalhou?",
    "Quanto recebia (ou retirava) normalmente em todos os seus trabalhos",
    "Recebia/retirava normalmente em dinheiro",
    "Número da faixa do rendimento/retirada em dinheiro",
    "Valor em dinheiro",
    "Recebia normalmente em produtos e mercadorias",
    "Número da faixa do rendimento/retirada em produtos e mercadorias",
    "Valor em produtos e mercadorias",
    "Recebia normalmente somente em benefícios",
    "Era não remunerado",
    "Quanto recebia (ou retirava) normalmente em todos os seus trabalhos",
    "Recebia/retirava normalmente em dinheiro",
    "Número da faixa do rendimento/retirada em dinheiro",
    "Valor em dinheiro",
    "Recebia normalmente em produtos e mercadorias",
    "Número da faixa do rendimento/retirada em produtos e mercadorias",
    "Valor em produtos e mercadorias",
    "Na maior parte do tempo, na semana passada,
                              esse trabalho (único ou principal) foi exercido
    no mesmo local em que costuma trabalhar?",
    "Na semana passada, o(a) Sr(a) estava em trabalho remoto
    (home office ou teletrabalho)?",
    "O(A) Sr(a) contribui para o INSS?",
    "Na semana passada ___ tomou alguma providência
    efetiva para conseguir trabalho?",
    "Qual o principal motivo de não ter procurado trabalho na semana passada?",
    "Algum outro morador deste domicílio trabalhou de forma
                              remunerada na semana passada?",
    "Rendimento recebido de aposentadoria e pensão por todos os moradores",
    "Somatório dos valores recebidos",
    "Rendimento de pensão alimentícia, doação ou mesada em dinheiro de pessoa
    que não morava no domicílio",
    "Somatório dos valores recebidos",
    "Rendimentos de Programa Bolsa Família",
    "Somatório dos valores recebidos",
    "No mês de ... (mês de referência), ... recebeu rendimentos de Benefício
    Assistencial de Prestação Continuada – BPC-LOAS?",
    "Somatório dos valores recebidos",
    "Auxilios emergenciais relacionados ao coronavirus",
    "Somatório dos valores recebidos",
    "Seguro desemprego",
    "Somatório dos valores recebidos",
    "Outros rendimentos, como aluguel, arrendamento, pervidência privada,
    bolsa de estudos, rendimentos de aplicação financeira etc.",
    "Somatório dos valores recebidos",
    "Este domicílio é:",
    "Qual foi o valor mensal do aluguel pago, ou que deveria ter sido pago, no mês de referência?",
    "Número da faixa do aluguel pago",
    "Quem respondeu ao questionário?",
    "Número de ordem do morador que prestou as informações"
  ),
  descricao_eng = c(
    "Year",
    "State",
    "Capital",
    "Metropolitan Region",
    "Household selection number",
    "Week of the month",
    "Month of the survey",
    "Household interview number",
    "Stratum",
    "District borders",
    "Type of situation in the household",
    "Area type",
    "Population projection",
    "Weight",
    "Weight",
    "Projecting domain",
    "Order number",
    "Household condition",
    "Day of birth",
    "Month of birth",
    "Year of birth",
    "Resident's age",
    "Gender",
    "Skin color or race",
    "Schooling",
    "In the last week did you have fever?",
    "In the last week did you have cough?",
    "In the last week did you have sore throat?",
    "In the last week did you have difficulty breathing?",
    "In the last week did you have headache?",
    "In the last week did you have chest pain?",
    "In the last week did you have nausea?",
    "In the last week did you have stuffy or runny nose?",
    "In the last week did you have fatigue?",
    "In the last week did you have eye pain?",
    "In the last week did you have loss of smell or taste?",
    "In the last week did you have muscle pain?",
    "Because of that, did you go to any health establishment?",
    "Providence taken to recover from symptoms was staying at home",
    "Providence taken to recover from symptoms was to call some
     healthcare professional",
    "Providence taken to recover from symptoms was to buy and/or
                    take medicine on their own",
    "Providence taken to recover from symptoms was to buy and/or
                    take medicine by medical advice",
    "Providence taken to recover from symptoms was a visit from
                    some public healthcare professional",
    "Providence taken to recover from symptoms was a visit from
                    some private healthcare professional",
    "Providence taken to recover from symptoms was another",
    "The place where you sought care was a health post/basic
                    health unit/
                    Family Health Team (doctor, nurse, nursing technician or
    community health worker)",
    "The place where you sought care was the SUS/UPA emergency room",
    "The place where you sought care was a SUS hospital",
    "The place where you sought care was an outpatient or
                    private practice  or linked to the armed forces",
    "Place that sought care was a private emergency room or
                    linked to the armed forces",
    "Place where he sought care was a private hospital or linked
                    to the armed forces",
    "When looking for the hospital, had to stay in the hospital
                    for a day or more",
    "During hospitalization, was sedated, intubated and placed in
     artificial respiration with ventilator",
    "Do you have a medical health plan, whether private,
                    company or public agency",
    "In the last week, for at least an hour, did you work in
                    any occupational activity?",
    "Last week, were you temporarily away from work?",
    "What is the main reason for this temporary removal?",
    "Continued to be paid (even partially) for this work",
    "How long have you been away from that job?",
    "Time away (From 1 month to less than 1 year)",
    "Time away (from 1 Year to less than 2 Years)",
    "Time away (from 2 Year to 98 Years)",
    "Has more than one job",
    "At work (single or main) I had that week, it was:",
    "This work was in the area:",
    "Do you have a formal contract and are you a public servant?",
    "What kind of job, role or function do you do in your job
                    (single or main)? ",
    "What is the main activity of local or company in which you
                    work?",
    "In the last week, how many employees worked in that firm/company
                    that ... you had?",
    "1 to 5 employees",
    "6 to 10 employees",
    "How many hours a week did you normally work?",
    "How many hours, in the last week, did you actually work?",
    "How much did he receive (or withdraw) normally in all
                    your jobs",
    "Received/withdrawn normally in cash",
    "Cash/withdrawal band number",
    "Cash value",
    "Usually received on products and merchandise",
    "Income/withdrawal range number on products and goods",
    "Value in products and goods",
    "Normally received only in benefits",
    "Was unpaid",
    "How much did you normally receive (or withdraw)
                    in all your jobs",
    "Received/withdrawn normally in cash",
    "Cash/withdrawal band number",
    "Cash value",
    "Usually received on products and merchandise",
    "Income/withdrawal range number on products and goods",
    "Value in products and goods",
    "Most of the time, in the last week, was this (single or
                    main) job performed in the same place you usually work?",
    "In the last week, were you  in remote work (home office
                    or telework)?",
    "Do you contribute to the INSS?",
    "In the last week ___ have you taken any effective steps
                    to get a job?",
    "What is the main reason for not looking for work
                    in the last week?",
    "Did any other resident of this household work in a paid way
                    in the last week?",
    "Income received from retirement and pension by all residents",
    "Sum of received values",
    "Income from alimony, donation or cash allowance of person
                    who did not live at home",
    "Sum of received values",
    "Income from Bolsa Família program",
    "Sum of received values",
    "On the Month of ... (Reference month), ... received income
                    from the assistance benefit of Continued Provision - BPC-LOAS?",
    "Sum of received values",
    "Emergency aid related to coronavirus",
    "Sum of received values",
    "Unemployment insurance",
    "Sum of received values",
    "Other income, with rent, lease, private pension, scholarship,
                    income from financial investments, etc.",
    "Sum of received values",
    "This address is:",
    "What was the monthly rent paid, or that should have been paid,
                    in the reference month?",
    "Track number of paid rent",
    "Who answered the questionnaire?",
    "Order number of the resident who provided the information"
  )
)


#####

### Escolhendo e adicionando labels de acordo com idioma escolhido
    if(lang == "pt_br"){
      legendas <- split(Descricoes$descricao_port, 1:nrow(Descricoes))
      } else{
        legendas <- split(Descricoes$descricao_eng, 1:nrow(Descricoes))
}
names(legendas) <- as.list(Descricoes$Codigo_da_variavel)

dados <-  dados %>% map(~.x %>% set_variable_labels(.labels = legendas))

names(dados) <- paste0('pnad_covid_',datas)
return(dados)
}




