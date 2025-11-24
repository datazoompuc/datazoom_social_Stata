******************************************************
*             datazoom_pnadcontinua.ado              *
******************************************************
*version stata 14.2
program define datazoom_pnadcontinua

syntax, years(numlist) original(str) saving(str) [nid idbas idrs english]

if "`english'" != "" local lang "_en"

/* Pastas para guardar arquivos da sessão */
cd "`saving'"

di "`original'"
	
/* Dicionário */

tempfile dic

findfile dict.dta

read_compdct, compdct("`r(fn)'") dict_name("pnadcontinua`lang'") out("`dic'")

/* Extração dos arquivos */
tokenize `years'

local y`1' = ""

local max_panel = 0 // para armazenar painel máximo
	
foreach year in `years'{
	foreach trim in 01 02 03 04 {
		local file_name "PNADC_`trim'`year'"
			
		
	di as input "Extraindo arquivo PNADC_`trim'`year'  ..."
			cap infile using "`dic'", using("`original'/`file_name'.txt") clear
			if _rc == 0 {
					// adding value labels
					pnadc_value_labels`lang'
					
					// detecting highest panel
					qui sum V1014
					local max_panel = max(`max_panel', r(max))
					
					tempfile PNADC_`trim'`year'
					save "`PNADC_`trim'`year''", replace
			}
			else continue, break
	}
}	

if _rc==901 exit	

********************************************************************
*                            Painel                                
********************************************************************

/* Criando pastas para guardar arquivos da sessão */
capture mkdir pnadcontinua

if _rc == 693 {
   tempname numpasta
   local numpasta = 0
   while _rc == 693 {
      capture mkdir "pnadcontinua_`++numpasta'"
   }
   cd "pnadcontinua_`numpasta'"
}
else {
   cd "pnadcontinua"
}

loc caminhoprin = c(pwd)

foreach aa in `years' {    
    use "``PNADC_01`aa'''", clear // (Nota: use as aspas duplas extras para segurança)
    foreach trim in 02 03 04 {
        capture append using "``PNADC_`trim'`aa'''"
        if _rc != 0 {
            continue, break    
        }
    }
    
    // CORREÇÃO: Salva o trimestral se pedir NID, mas NÃO usa exit.
    if "`nid'" != "" {
        save "PNADC_trimestral_`aa'.dta", replace
        // O código vai simplesmente continuar para o próximo ano
    }
    else {
        tempfile PNADC`aa'
        save "`PNADC`aa''", replace
    }
}

// CORREÇÃO: Envolvemos todo o resto do código (painel) neste bloco IF
if "`nid'" == "" {
   // ... O resto do código do painel entra aqui ...

******************************
* Junta paineis 
******************************

clear

forvalues pa = 1/`max_panel' { 

	// tempfile to store all years of this panel
	tempfile PNADC_Painel`pa'
	
	clear

	foreach aa in `years' {
		use PNADC`aa', clear
		keep if V1014 == `pa'
		
		append using "`PNADC_Painel`pa''"
		
		save "`PNADC_Painel`pa''", replace
	}
}

forvalues pa = 1/`max_panel' { 

	use "`PNADC_Painel`pa''", clear
	
	noi di as result "Executando Identificação"
	
	// Roda identificação
	pnadcont_`idbas'`idrs'
	
	cap drop __* // remove tempvars
	
	local suffix = substr(`idbas'`idrs', 3, .)
	
	// Salva o arquivo
	save PNAD_painel_`pa'_`suffix', replace
	
}
}

datazoom_message

di _newline "As bases de dados foram salvas em `c(pwd)'"

end


/*_______________________________________________________________________*/
/*______________________Executa a identificação Básica___________________*/
/*_______________________________________________________________________*/

program pnadcont_idbas
syntax, temps(string)
		
	// Rodando identificação básica
		
	egen id_dom = group(UF UPA V1008 V1014)
	egen id_ind = group(id_dom V2003 V20082 V20081 V2008 V2007)

	// Removendo "gêmeos"
	// Observações que aparecem mais de uma vez por trimestre
		
	tempvar num_app
		
	egen `num_app' = count(V1014), by(id_ind Ano Trimestre) // contando aparições
		
	replace id_ind = . if `num_app' != 1 // em caso de esquisitisses, ID é missing
		
	// Fazendo paste no número do painel antes do código de ID
		
	tempvar aux_id
		
	egen aux_id = concat(V1014 id_ind), punct("_")
		
    drop id_ind
	rename aux_id id_ind
		
	label var id_ind "Basic identifier"
}

end


/*_______________________________________________________________________*/
/*___________________Executa a identificação Ribas Soares________________*/
/*_______________________________________________________________________*/

program pnadcont_idrs
syntax, temps(string)

/*Executa a identificação de Ribas & Soares*/

	// Primeiro rodando a identificação básica
	
	pnadcont_idbas
		
	qui sum id_ind
		
	local max_id = r(max) // para evitar overlap entre ids básicas e avançadas
		
	// Marcando as observações já emparelhadas
		
	tempvar quarters_basic matched_basic
		
	egen `quarters_basic' = count(V1014), by(id_ind)
		
	gen `matched_basic' = (`quarters_basic' == 5)
		
	// Definindo observações que entram na segunda etapa
		
	tempvar rs_group
		
	gen `rs_group' = 0
	replace `rs_group' = 1 if `matched_basic' != 1 & inlist(V2005, 1, 2, 3)
	replace `rs_group' = 2 if `matched_basic' != 1 & inlist(V2005, 4, 5) & V2009 >= 25
		
	// Rodando a segunda etapa
	// Sem data exata de nascimento
		
	egen id_rs = group(id_dom V20081 V2008 V2003 `rs_group')
		
	replace id_rs = id_rs + `max_id'
		
	replace id_rs = id_ind if missing(id_rs)
		
	// Vendo quem foi matcheado novamente
		
	tempvar quarters_adv matched_adv
		
	egen `quarters_adv' = count(V1014), by(id_ind)
		
	gen `matched_adv' = (`quarters_adv' == 5)

end

********************************************************************


