******************************************************
*             datazoom_pnadcontinua.ado              
******************************************************
*version stata 14.2
program define datazoom_pnadcontinua

syntax, years(numlist) original(str) saving(str) [nid idbas idrs english]

if "`english'" != "" local lang "_en"

cd "`saving'"
di "`original'"

tempfile dic
findfile dict.dta
read_compdct, compdct("`r(fn)'") dict_name("pnadcontinua`lang'") out("`dic'")

tokenize `years'
local y`1' = ""
local panel_list ""

local max_painel = 0
local min_painel = 999

foreach year in `years'{
    foreach trim in 01 02 03 04 {
        local file_name "PNADC_`trim'`year'"
        di as input "Extraindo arquivo PNADC_`trim'`year'  ..."
        cap infile using "`dic'", using("`original'/`file_name'.txt") clear
        if _rc == 0 {
            qui capture egen hous_id = concat(UPA V1008 V1014), format(%14.0g)
            qui destring hous_id, replace

            qui summ V1014
            local min_trim = r(min)
            local max_trim = r(max)

            if `max_trim' > `max_painel'  local max_painel = `max_trim'
            if `min_trim' < `min_painel'  local min_painel = `min_trim'

            pnadc_value_labels`lang'

            tempfile PNADC_`trim'`year'
            save "`PNADC_`trim'`year''", replace
        }
        else continue, break
    }
}

if _rc==901 exit    

capture mkdir pnadcontinua
if _rc == 693 {
   tempname numpasta
   local numpasta = 0
   while _rc == 693 {
      capture mkdir "pnadcontinua_`++numpasta'"
   }
   cd "pnadcontinua_`numpasta'"
}
else cd "pnadcontinua"

loc caminhoprin = c(pwd)

foreach aa in `years' { 
    use "`PNADC_01`aa''", clear
    foreach trim in 02 03 04 {
        capture append using "`PNADC_`trim'`aa''"
        if _rc != 0 continue, break
    }
    if "`nid'"~="" {
        save PNADC_trimestral_`aa'
        exit
    }
    else {
        tempfile PNADC`aa'
        save "PNADC`aa'", replace
    }
}

******************************
* Junta paineis 
******************************

foreach aa in `years' {
    forvalues pa = `min_painel'/`max_painel'{    
        use PNADC`aa', clear
        keep if V1014 == `pa'
        tempfile PNADC_Painel`pa'temp`aa'
        save "`PNADC_Painel`pa'temp`aa''", replace
    }
}

forvalues pa = `min_painel'/`max_painel'{  
    local first = 1
    foreach aa in `years' {
        if `first' {
            use "`PNADC_Painel`pa'temp`aa''", clear
            local first = 0
        }
        else append using "`PNADC_Painel`pa'temp`aa''"
        keep if V1014 == `pa'
    }
    save "PNADC_Painel`pa'", replace
}

global panels ""
local painel_temps ""

forvalues pa = `min_painel'/`max_painel'{
    capture confirm file "PNADC_Painel`pa'.dta"
    if !_rc {
        use "PNADC_Painel`pa'", clear
        qui count
        if r(N) != 0 {
            global panels "$panels `pa'"
            * monta lista de arquivos de painel com aspas
			local painel_temps `painel_temps' PNADC_Painel`pa'
        }
    }
}

display "$panels"

if "`nid'" == ""{

	pnadcont_`idbas'`idrs', temps(`painel_temps')

}

di _newline "Esta versão do função datazoom_pnadcontinua é compatível com a última versão dos microdados da PNAD Contínua Trimestral divulgados em 24/02/2022"
di _newline "As bases de dados foram salvas em `c(pwd)'"

end


******************************************************
*                IDENTIFICAÇÃO BÁSICA                
******************************************************
program pnadcont_idbas
syntax, temps(namelist)

local n : word count `temps'
local i = 1

foreach file in `temps' {

    local pa_name : word `i' of $panels
    local ++i

    noi di as text "Aplicando ID Básica em: `file' (painel `pa_name')"

    use "`file'", clear

    capture confirm numeric variable V1014
    if _rc destring V1014, replace ignore(" ")

    cap drop id_dom id_ind
    egen id_dom = group(UF UPA V1008 V1014)
    egen id_ind = group(id_dom V2003 V20082 V20081 V2008 V2007)

    tempvar num_app
    egen `num_app' = count(V1014), by(id_ind Ano Trimestre)
    replace id_ind = . if `num_app' != 1 

	noi di as error "DEBUG: antes de criar aux_id"
	noi list V1014 id_dom id_ind `num_app' in 1/20, abbrev(20)

	noi di as error "DEBUG: tipos"
	noi describe id_dom id_ind `num_app'
	
    tempvar aux_id
    egen `aux_id' = concat(V1014 id_ind), punct("")
    drop id_ind
    rename `aux_id' id_ind
	recast str20 id_ind

    label var id_ind "Basic identifier"

    capture drop __*
	
	* garante que id_ind existe
	capture confirm variable id_ind
	if _rc {
    di as error "ERRO FATAL: id_ind não existe em `file'"
    exit 459
	}

	* remove variáveis auxiliares
	capture drop hous_id
	capture drop aux_id
	capture drop num_app
	capture drop __*

	* organiza
	order id_dom id_ind, first
	compress

	save "`file'", replace

    * >>> alteração principal: grava o identificador no próprio arquivo do painel
    save "`file'", replace
}

end


******************************************************
*                IDENTIFICAÇÃO AVANÇADA         
******************************************************
program pnadcont_idrs
syntax, temps(namelist)

* primeiro gera a identificação básica
pnadcont_idbas, temps(`temps')

local n : word count `temps'
local i = 1

foreach file in `temps' {

    local pa_name : word `i' of $panels
    local ++i

    noi di as text "Aplicando ID Ribas-Soares em: `file' (painel `pa_name')"

    use "`file'", clear
    capture drop __*

    capture confirm numeric variable V1014
    if _rc destring V1014, replace ignore(" ")

    tempvar id_num_recuperado
    gen long `id_num_recuperado' = real(substr(id_ind, strpos(id_ind, "_")+1, .))
    qui sum `id_num_recuperado'
    local max_id = r(max)

    tempvar quarters_basic matched_basic
    egen `quarters_basic' = count(V1014), by(id_ind)
    gen `matched_basic' = (`quarters_basic' == 5)

    tempvar rs_group
    gen `rs_group' = 0
    replace `rs_group' = 1 if `matched_basic' != 1 & inlist(V2005, 1, 2, 3)
    replace `rs_group' = 2 if `matched_basic' != 1 & inlist(V2005, 4, 5) & V2009 >= 25

    tempvar id_dom_temp
    egen `id_dom_temp' = group(UF UPA V1008 V1014)

    tempvar id_rs_num
    egen `id_rs_num' = group(`id_dom_temp' V20081 V2008 V2003 `rs_group')
    replace `id_rs_num' = `id_rs_num' + `max_id'

    tempvar id_rs_string
    egen `id_rs_string' = concat(V1014 `id_rs_num'), punct("")
    replace id_ind = `id_rs_string' if `rs_group' > 0 & !missing(`id_rs_num')
	recast str20 id_ind

    tempvar quarters_adv matched_adv
    egen `quarters_adv' = count(V1014), by(id_ind)
    gen `matched_adv' = (`quarters_adv' == 5)

    * >>> grava identificação avançada no próprio arquivo do painel
    save "`file'", replace
}

end

**************************************************************************
