{smcl}
{viewerdialog "PNAD Covid" "dialog datazoom_pof"}
{viewerdialog "Pacote" "dialog datazoom_social"}
{vieweralsosee "PNAD" "help datazoom_pnad"}{...}
{vieweralsosee "Censo" "help datazoom_censo"}{...}
{vieweralsosee "PNAD Contínua Anual" "help datazoom_pnadcont_anual"}{...}
{vieweralsosee "PNS" "help datazoom_pns"}{...}
{vieweralsosee "PNAD Contínua Trimestral" "help datazoom_pnadcontinua"}{...}
{vieweralsosee "PME" "help datazoom_pme"}{...}
{vieweralsosee "PNAD Covid" "help datazoom_pnad_covid"}{...}
{vieweralsosee "ECINF" "help datazoom_ecinf"}{...}
{viewerjumpto "Syntax" "datazoom_pof##syntax"}{...}
{viewerjumpto "Description" "datazoom_pof##description"}{...}
{viewerjumpto "Options" "datazoom_pof##options"}{...}
{viewerjumpto "Examples" "datazoom_pof##examples"}{...}
{p 8 8 2} {it:For the English version}, {help datazoom_pof_en}

{title:Title}

{p 4 4 2}
{cmd:datazoom_pof}(ano) {hline 2} Acesso aos microdados da POF

{marker syntax}{...}
{title:Syntax}

{p 8 8 2} {cmd:datazoom_pof}{it:(ano)}{cmd:trs} [, {it:trs_options}]

{p 8 8 2} {cmd:datazoom_pof}{it:(ano)}{cmd:std} [, {it:std_options}]

{p 8 8 2} {cmd:datazoom_pof}{it:(ano)}{cmd:sel} [, {it:sel_options}]

{marker description}{...}
{title:Description}

{p 4 4 2}
Para cada ano, há três comandos da forma {cmd:datazoom_pof}{it:(ano)} é um pacote composto por três comandos.

{p 4 4 2}
Estão disponíveis {help datazoom_pof95}, {help datazoom_pof02}, {help datazoom_pof08} e {help datazoom_pof17}

{p 4 4 2}
Todas podem ser executadas em caixa de diálogo pelo comando {cmd: db datazoom_pof}

{title:Author}

{p 4 4 2}
DataZoom     {break}
PUC-Rio - Departamento de Economia      {break}
Contato pelo  {browse "https://github.com/datazoompuc/datazoom_social_Stata":Github}      {break}

{space 4}{hline}

