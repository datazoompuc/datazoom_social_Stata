* Run: do tests/censo2022_txt.do "path/to/datazoom_social_Stata"
* Official layouts updated on 14 September 2026:
* https://ftp.ibge.gov.br/Censos/Censo_Demografico_2022/Microdados_e_Areas_de_Ponderacao/Documentacao/Layout%20e%20dicion%C3%A1rio/
version 16
clear all
set more off
args repo
if `"`repo'"' == "" local repo `"`c(pwd)'"'
run "`repo'/read_compdct.ado"

foreach access in pub con {
    * Independent fixture positions come from the IBGE layout, not the .dct.
    local position = cond("`access'" == "pub", 30, 73)
    local length = cond("`access'" == "pub", 257, 429)
    mata: st_local("record", invtokens(J(1, `length', " "), ""))
    local record = substr("`record'", 1, `position' - 1) + "F002081121" + substr("`record'", `position' + 10, .)
    local record = substr("`record'", 1, `length' - 1) + "1"
    if strlen("`record'") != `length' error 9
    tempfile raw
    tempname handle
    file open `handle' using "`raw'", write text replace
    file write `handle' ("`record'") _n
    file close `handle'

    foreach language in pt en {
        local suffix ""
        if "`language'" == "en" local suffix "_en"
        local name "censo2022pes_`access'`suffix'"
        foreach folder in Censo/dct dct {
            infile using "`repo'/`folder'/`name'.dct", using("`raw'") clear
            assert _N == 1
            assert P0115 == "F002"
            assert P0120 == "08"
            assert P0130 == "11"
            assert P0140 == "2"
            assert P0150 == "1"
            assert MP1220 == "1"
        }
        foreach compiled in dict.dta Censo/dict.dta {
            tempfile dictionary
            read_compdct, compdct("`repo'/`compiled'") dict_name("`name'") out("`dictionary'")
            infile using "`dictionary'", using("`raw'") clear
            assert _N == 1
            assert P0115 == "F002"
            assert P0120 == "08"
            assert P0130 == "11"
            assert P0140 == "2"
            assert P0150 == "1"
            assert MP1220 == "1"
        }
    }
}
display "PASS: 2022 person TXT dictionaries read P0115 and subsequent fields correctly"
