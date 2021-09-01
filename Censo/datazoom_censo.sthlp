{smcl}
{viewerdialog "Censo" "dialog datazoom_censo"}
{viewerdialog "Pacote" "dialog datazoom_social"}
{vieweralsosee "PNAD" "help datazoom_pnad"}{...}
{vieweralsosee "PNS" "help datazoom_pns"}{...}
{vieweralsosee "PNAD Contínua Trimestral" "help datazoom_pnadcontinua"}{...}
{vieweralsosee "PNAD Contínua Anual" "help datazoom_pnadcont_anual"}{...}
{vieweralsosee "PNAD Covid" "help datazoom_pnad_covid"}{...}
{vieweralsosee "PME" "help datazoom_pme"}{...}
{vieweralsosee "POF" "help datazoom_pof"}{...}
{vieweralsosee "ECINF" "help datazoom_ecinf"}{...}
{viewerjumpto "Syntax" "datazoom_censo##syntax"}{...}
{viewerjumpto "Description" "datazoom_censo##description"}{...}
{viewerjumpto "Options" "datazoom_censo##options"}{...}
{viewerjumpto "Examples" "datazoom_censo##examples"}{...}
{viewerjumpto "Nota sobre os dados" "datazoom_censo##remarks"}{...}
{p 8 8 2} {it:For the English version}, {help datazoom_censo_en}

{title:Title}

{p 4 4 2}
{cmd:datazoom_censo} {hline 2} Acesso aos microdados do Censo

{marker syntax}{...}
{title:Syntax}

{p 8 8 2} {cmd:datazoom_censo} [, {it:options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Input}
{synopt:{opt years(numlist)}} anos do Censo {p_end}
{synopt:{opt original(str)}} caminho da pasta onde se localizam os arquivos de dados originais (.txt ou .dat) {p_end}
{synopt:{opt saving(str)}} caminho da pasta onde serão salvas as novas bases de dados {p_end}
{synopt:{opt ufs(str)}} códigos dos estados {p_end}
{synopt:{opt english}} labels das variáveis em inglês {p_end}

{syntab:Compatibilidade}
{synopt:{opt comp}} compatibiliza variáveis ao longo dos anos {p_end}

{syntab:Tipos de Registro}
{synopt:{opt pes}} pessoas {p_end}
{synopt:{opt dom}} domicílios {p_end}
{synopt:{opt fam}} famílias (2000) {p_end}
{synopt:{opt both}} pessoas e domicílios em um mesmo arquivo {p_end}
{synopt:{opt all}} pessoas, famílias e domicílios em um mesmo arquivo (2000) {p_end}

{synoptline}
{p2colreset}{...}
{p 4 6 2}

Digite {cmd:db datazoom_censo} para utilizar a função via caixa de diálogo.

{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:datazoom_censo} extrai e contrói bases de dados do Censo Demográfico em formato Stata (.dta) a partir
dos microdados originais, que podem ser obtidos do site do IBGE. O programa pode ser utilizado para
os anos de 1970 a 2010.

{p 4 4 2}
Adicionalmente, existe a opção de compatibilizar variáveis ao longo dos anos. Isso é feito para
as variáveis existentes ao menos em dois anos do Censo e que são passíveis de compatibilização em
termos metodológicos. O processo de compatibilização está documentado em
"Censo - Compatibilização", disponível para download no site do Portal. Nesta opção,
somente as variáveis compatibilizadas permanecem na base de dados final (além das variáveis
de controle). Além disso, são incorporadas variáveis relacionadas a mudanças geopolíticas ocorridas no 
período, as chamadas Áreas Mínimas Comparáveis. Finalmente, as variáveis monetárias são deflacionadas 
para agosto de 2010.

{p 4 4 2}
O programa gera uma base de dados para cada unidade da federação e ano escolhidos. Se for o caso, use o comando 
{help append} para juntar todos os estados. 

{p 4 4 2}
Se apenas uma das opções dentre {opt pes}, {opt fam} ou {opt dom} for escolhida, o programa gera uma base de dados com as variáveis 
correspondentes à seleção em um único arquivo. O arquivo família existe somente para o Censo 2000. Se a opção {opt both} for escolhida, o programa 
gera uma base de dados inclindo as variáveis de domicílios e pessoas no mesmo arquivo. Se a opção {opt all} for escolhida, disponível apenas para 
o ano 2000, o programa gera uma base de dados inclindo as variáveis de domicílios, famílias e pessoas no mesmo arquivo.

{marker options}{...}
{title:Options}
{dlgtab:Input}

{phang} {opt years(numlist)}  especifica a lista de anos com os quais o usuário deseja trabalhar. Este programa 
pode ser utilizado para os anos de 1970 a 2010.

{phang} {opt original(str)} indica o caminho da pasta onde estão localizados os arquivos de dados originais. Para
todos os Censos existem ao menos um arquivo para cada estado. Todos eles devem estar posicionados na mesma pasta 
para que o programa funcione adequadamente.

{phang} {opt saving(str)} indica o caminho da pasta onde devem ser salvas as bases de dados produzidas pelo programa.

{phang} {opt ufs(str)} especifica os estados para os quais o programa deve gerar uma base de dados. Cada estado é
identificado por meio de um código de duas letras, o mesmo usualmente utilizado como referência para cada estado: 
Rondônia RO, Acre AC, Amazonas AM, Roraima RR, 
Pará PA, Amapá AP, Tocantins TO, Fernando de Noronha FN, Maranhão MA, Piaui PI, Ceará CE, Rio Grande do Norte RN, 
Paraíba PB, Pernambuco PE, Alagoas AL, Sergipe SE, Bahia BA, Minas Gerais MG, Espírito Santo ES, Rio de Janeiro RJ, 
Guanabara GB, São Paulo SP, Paraná PR, Santa Catarina SC, Rio Grande do Sul RS, Mato Grosso do Sul MS, Mato Grosso 
MT, Goiás GO, Distrito Federal DF.

{dlgtab:Compatibilidade}

{phang}
{opt comp}  solicita que a compatibilização de variáveis seja executada. Sob essa opção, o número de variáveis
na base final é reduzida ao conjunto de variáveis que aparecem em ao menos dois anos do Censo. Por conta de mudanças
metodológicas aplicadas pelo IBGE de ano para ano na realização da pesquisa, embora existam em mais de um ano, 
algumas variáveis não são passíveis de compatibilização, sendo excluídas no processo.

{dlgtab:Tipo de Registro}

{phang}
{opt pes}  especifica que o usuário deseja obter apenas o arquivo de pessoas, compatibilizado ou não. 
Se nenhum tipo de registro for escolhido, o programa automaticamente executa essa opção. (Não pode ser
combinada com {opt dom}, {opt fam}, {opt both} ou {opt all}).

{phang}
{opt dom}  especifica que o usuário deseja obter apenas o arquivo de domicílios, compatibilizado ou não. 
(Não pode ser combinada com {opt pes}, {opt fam}, {opt both} ou {opt all}).

{phang}
{opt fam}  especifica que o usuário deseja obter apenas o arquivo de famílias para o ano 2000. 
(Não pode ser combinada com {opt pes}, {opt dom}, {opt both} ou {opt all}).

{phang} 
{opt both} especifica que o usuário deseja obter as variáveis de pessoas e domicílios em uma única base de dados,
 compatibilizada ou não, ou seja, o programa executa o comando {help merge} automaticamente para unir os
 dois tipos de registro. (Não pode ser combinada com {opt pes}, {opt dom}, {opt fam} ou {opt all}).

{phang} 
{opt all} especifica que o usuário deseja obter as variáveis de pessoas, famílias e domicílios em uma única base de dados 
para o ano 2000, ou seja, o programa executa o comando {help merge} automaticamente para unir os
 três tipos de registro. (Não pode ser combinada com {opt pes}, {opt dom}, {opt fam} ou {opt both}).

{marker examples}{...}
{title:Exemplos}

{p 4 4 2}
Produz oito bases de dados, uma para cada estado e anos escolhidos. As variáveis não são compatibilizadas.

{p 8 6 2}. datazoom_censo, years(1970 2000) original("~/mydir") saving("~/mydir") ufs(BA RJ SP DF) pes

{p 4 4 2}
As mesmas oito bases de dados do exemplo anterior. A diferença é que cada base contém as variáveis de pessoas e domicílios, todas compatibilizadas.

{p 8 6 2}. datazoom_censo, years(1970 2000) original("~/mydir") saving("~/mydir") ufs(BA RJ SP DF) comp both
 
{marker remarks}{...}
{title:Nota sobre os dados originais}

{phang}
Os nomes e a quantidade de arquivos de microdados disponibilizados pelo IBGE mudam a cada versão do Censo. 
Abaixo, segue uma lista com os nomes e a quantidade de arquivos esperados pelo {cmd:datazoom_censo} para cada 
ano e unidade da federação. 

{phang}
Caso haja diferenças entre a lista abaixo e os arquivos do usuário, o programa 
não irá funcionar adequadamente para as UFs em que há disparidade. 

{phang}
Se a quantidade de arquivos por UF for a mesma da lista, mas houver diferenças nos nomes, o programa 
deve funcionar corretamente após o usuário renomear seus arquivos de dados adaptando-os à lista. 

{phang}
No entanto, é possível que a estrutura dos dados utilizados pelo Data Zoom seja diferente da estrutura 
dos dados possuídos pelo usuário mesmo no caso em que há apenas diferenças nos nomes. Se isso ocorrer, 
o programa não irá funcionar corretamente. Para verificar se há diferenças estruturais, confira o dicionário de 
variáveis disponível para download em www.econ.puc-rio.br/datazoom e compare com o dicionário em mãos.

{phang} - Lista dos nomes dos arquivos de microdados. De 1991 em diante, os números dos sufixos, em geral, referem-se
 aos códigos IBGE de cada estado.

{phang} 1970

{phang} - prefixo para todos arquivos: Damo70

{phang} - sufixos: RO AC AM RR PA AP FN MA PI CE RN PB PE AL SE BA MG ES RJ GB SP PR SC RS MT GO DF

{phang} 1980

{phang} - prefixo para todos arquivos: AMO80.UF

{phang} - sufixos: RO AC AM RR PA AP MA PI CE RN PB PE AL SE BA MG ES RJ SP PR SC RS MS MT GO DF

{phang} 1991 

{phang} - prefixo para todos arquivos: CD102U

{phang} - sufixos: U11 U12 U13 U14 U15 U16 U17 U21 U22 U23 U24 U25 U26 U27 U28 U29 U31 U32 U33 P35 P36 U41 U42 U43 U50 U51 U52 U53

{phang} - note que P35 e P36 referem-se aos dados para SP

{phang} 2000

{phang} - prefixos: Pes (para pessoas), Dom (para domicílios) e Fami (para família)

{phang} - sufixos: 11 12 13 14 15 16 17 21 22 23 24 25 26 27 28 29 31 32 33 35 41 42 43 50 51 52 53

{phang} 2010

{phang} - prefixos: Amostra_Pessoas_ (para pessoas) e Amostra_Domicilios_ (para domicílios)

{phang} - sufixos: 11 12 13 14 15 16 17 21 22 23 24 25 26 27 28 29 31 32 33 35_outras 35_RMSP 41 42 43 50 51 52 53 14munic

{phang} - note que 35_outras e 35_RMSP referem-se aos dados para SP

{phang} - note que 14munic refere-se aos dados redefinidos pelo IBGE para 14 municípios
 
 
{title:Author}

{p 4 4 2}
DataZoom     {break}
PUC-Rio - Departamento de Economia      {break}
Contato pelo  {browse "https://github.com/datazoompuc/datazoom_social_Stata":Github}      {break}

{space 4}{hline}
