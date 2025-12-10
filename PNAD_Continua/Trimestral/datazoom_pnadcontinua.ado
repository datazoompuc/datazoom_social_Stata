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

local panel_list "" // armazena paineis
	
local max_painel = 0
local min_painel = 0
	
foreach year in `years'{
	foreach trim in 01 02 03 04 {
		local file_name "PNADC_`trim'`year'"
			
		
	di as input "Extraindo arquivo PNADC_`trim'`year'  ..."
			cap infile using "`dic'", using("`original'/`file_name'.txt") clear
			if _rc == 0 {
					qui capture egen hous_id = concat(UPA V1008 V1014), format(%14.0g)
					qui destring hous_id, replace
					
					qui summ V1014
					
					local min_trim = r(min) // menor valor de v1014 naquele momento
					local max_trim = r(max) // maior valor de v1014 naquele momento
					
					if `max_trim' > `max_painel'  {
					    local max_painel = `max_trim'
					}
					if `min_trim' < `min_painel' {
					    local min_painel = `min_trim'
					}
					
					// adding value labels
					pnadc_value_labels`lang'
					
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

* juntando os trimestres de cada ano
foreach aa in `years' {	
	use "`PNADC_01`aa''", clear
	foreach trim in 02 03 04 {
		capture append using "`PNADC_`trim'`aa''"
		if _rc != 0 {
			continue, break	
		}
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
 	*Combinações

*tokenize `years'
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
	    use   "`PNADC_Painel`pa'temp`aa''", clear
		local first = 0
		}
	else {
		append using "`PNADC_Painel`pa'temp`aa''"
	}
	keep if V1014 == `pa'
	}
	save "`PNADC_Painel`pa''", replace	
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
            local painel_temps `"`painel_temps' "PNADC_Painel`pa'""'
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

/*_______________________________________________________________________*/
/*______________________Executa a identificação Básica___________________*/
/*_______________________________________________________________________*/

program pnadcont_idbas
syntax, temps(string)
		
	// Loop para processar cada arquivo temporário da lista
	foreach file in `temps' {
		
		noi di as text "Aplicando ID Básica em: `file'"
		use "`file'", clear
		
		capture confirm numeric variable V1014
if _rc {
    destring V1014, replace ignore(" ")
}
		
		// 1. Criação dos Identificadores Numéricos
		// Garante que não há lixo de tentativas anteriores
		cap drop id_dom id_ind
		
		egen id_dom = group(UF UPA V1008 V1014)
		egen id_ind = group(id_dom V2003 V20082 V20081 V2008 V2007)

		// 2. Removendo "gêmeos" (Observações duplicadas no mesmo trimestre)
		tempvar num_app
		egen `num_app' = count(V1014), by(id_ind Ano Trimestre)
		
		// Se houver inconsistência (duplicata), anula o ID
		replace id_ind = . if `num_app' != 1 
		
		// 3. Convertendo para Identificador Final (Texto: "Painel_ID")
		tempvar aux_id
		// Concatena o número do painel (V1014) com o ID gerado
		egen `aux_id' = concat(V1014 id_ind), punct("_")
		
		// Substituição segura: deleta o numérico e renomeia a string
		drop id_ind
		rename `aux_id' id_ind
		
		label var id_ind "Basic identifier"
		
		capture drop __*
		order id_ind, after(V2003)

		
		// Salva o arquivo com as alterações
		save "`file'", replace
	}

end


/*_______________________________________________________________________*/
/*___________________Executa a identificação Avançada________________*/
/*_______________________________________________________________________*/

program pnadcont_idrs
syntax, temps(string)

/*Executa a identificação de Ribas & Soares*/

	// 1. Roda a identificação básica primeiro
	// Passamos a lista 'temps' para garantir que ela processe os arquivos certos
	pnadcont_idbas, temps(`temps')
		
	// 2. Loop para processar a parte avançada em cada arquivo
	foreach file in `temps' {
		
		noi di as text "Aplicando ID Ribas-Soares em: `file'"
		use "`file'", clear
		
		capture drop __*
		
		   capture confirm numeric variable V1014
    if _rc {
        destring V1014, replace ignore(" ")
    }
		
		// --- Recuperando o Max ID Numérico ---
		// Como o idbas transformou o id_ind em texto (ex: "1_503"), 
		// precisamos extrair a parte numérica para calcular o máximo e não sobrepor IDs.
		tempvar id_num_recuperado
		gen long `id_num_recuperado' = real(substr(id_ind, strpos(id_ind, "_")+1, .))
		
		qui sum `id_num_recuperado'
		local max_id = r(max) 
		
		
		// --- Lógica Ribas & Soares ---
		
		// Marcando as observações já emparelhadas (sucesso na básica)
		tempvar quarters_basic matched_basic
		egen `quarters_basic' = count(V1014), by(id_ind)
		gen `matched_basic' = (`quarters_basic' == 5)
		
		// Definindo observações que entram na segunda etapa (Recuperação)
		tempvar rs_group
		gen `rs_group' = 0
		
		// Critérios de recuperação (quem falhou no básico mas tem atributos consistentes)
		replace `rs_group' = 1 if `matched_basic' != 1 & inlist(V2005, 1, 2, 3)
		replace `rs_group' = 2 if `matched_basic' != 1 & inlist(V2005, 4, 5) & V2009 >= 25
		
		// Recria id_dom temporário (necessário pois variáveis temporárias se perdem no reload)
		tempvar id_dom_temp
		egen `id_dom_temp' = group(UF UPA V1008 V1014)
		
		// Gerando o ID Avançado (Numérico)
		tempvar id_rs_num
		egen `id_rs_num' = group(`id_dom_temp' V20081 V2008 V2003 `rs_group')
		
		// Desloca o ID para não colidir com o ID básico existente
		replace `id_rs_num' = `id_rs_num' + `max_id'
		
		
		// --- Atualizando o id_ind Final ---
		
		// O id_ind é texto (Painel_ID). O id_rs_num é número.
		// Precisamos converter o id_rs_num para o formato texto "Painel_ID" antes de substituir.
		
		tempvar id_rs_string
		egen `id_rs_string' = concat(V1014 `id_rs_num'), punct("_")
		
		// Se a pessoa foi recuperada pelo método RS (rs_group > 0), atualizamos o ID dela.
		replace id_ind = `id_rs_string' if `rs_group' > 0 & !missing(`id_rs_num')
		
		
		// --- Verificação Final (Opcional) ---
		tempvar quarters_adv matched_adv
		egen `quarters_adv' = count(V1014), by(id_ind)
		gen `matched_adv' = (`quarters_adv' == 5)

		// Salva o arquivo final
		save "`file'", replace
	}

end

**************************************************************************


