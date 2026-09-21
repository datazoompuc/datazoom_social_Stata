{smcl
{* *! version 2.0  2026}{...}
{title:Título}

    {cmd:datazoom_pnadcont_anual} -- Acesso aos microdados da PNAD Contínua - Divulgação Anual

{title:Sintaxe}

        {cmd:datazoom_pnadcont_anual} [{cmd:,} {it:opções}]

    {synoptset 20 tabbed}{...}
    {synopthdr:opções}
    {synoptline}
    {syntab:Entrada}
    {synopt :{opt years(lista)}}especifica os anos, visitas e trimestres a serem extraídos (ex: 2025_vis1, 2025_tri2){p_end}
    {synopt :{opt original(caminho)}}caminho da pasta onde estão os microdados originais (.txt){p_end}
    {synopt :{opt saving(caminho)}}caminho da pasta onde as bases tratadas (.dta) serão salvas{p_end}
    {synopt :{opt english}}aplica os rótulos (labels) das variáveis em inglês{p_end}
    {synoptline}

{p 4 4 2}Use o comando {cmd:db datazoom_pnadcont_anual} para acessar a interface por caixa de diálogo em português.{p_end}

{title:Descrição}

    {cmd:datazoom_pnadcont_anual} extrai e constrói bases de dados em formato Stata (.dta) a partir dos microdados originais da Divulgação Anual da PNAD Contínua do IBGE, cobrindo o período de {b:2012 a 2025}.

    A pesquisa contempla dados acumulados por entrevista/visita (Visita 1, Visita 2 e Visita 5) e dados concentrados em trimestres específicos (Trimestres 1, 2, 3 e 4). As opções incluem os suplementos mais recentes de 2025:
    - {b:2025_vis1}: Rendimento de outras fontes e características gerais dos moradores
    - {b:2025_tri2}: Educação
    - {b:2025_tri3}: Trabalho por meio de plataformas digitais
    - {b:2025_tri4}: Tecnologia da Informação e Comunicação (TIC / Internet e TV)

    O programa gera uma base de dados em formato Stata (.dta) para cada seleção realizada. Se necessário, utilize o comando {cmd:append} para consolidar múltiplos anos/suplementos.

{title:Opções}

    {cmd:years(}{it:lista}{cmd:)} especifica a lista de anos e combinações de visita/trimestre que deseja extrair. Exemplo de valores válidos: {it:2012_vis1 ... 2025_vis1 2025_tri2 2025_tri3 2025_tri4}.

    {cmd:original(}{it:caminho}{cmd:)} indica o diretório onde estão localizados os arquivos de texto (.txt) baixados do FTP do IBGE.

    {cmd:saving(}{it:caminho}{cmd:)} especifica a pasta onde as bases tratadas em Stata (.dta) serão salvas.

{title:Exemplos}

    Extração dos suplementos de Educação e Plataformas Digitais de 2025:

        {cmd:. datazoom_pnadcont_anual, years(2025_tri2 2025_tri3) original("~/meus_dados") saving("~/minhas_bases")}

{title:Autor}

    DataZoom
    PUC-Rio - Departamento de Economia
    Contato via GitHub
