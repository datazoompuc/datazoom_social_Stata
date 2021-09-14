program write_compdct
syntax, folder(string) [saving(string)]

/* Macro com todos os arquivos de extensão .dct da pasta */

local files: dir "`folder'" files "*.dct"

foreach file in `files'{
	import delimited "`folder'/`file'", clear delimiter("qwerty", asstring) encoding(utf8)
	* lê o arquivo .dct para .dta, cada linha de texto vira uma observação 
	
	local nome_dct = substr("`file'", 1, length("`file'") - 4)
	* remove o .dct para o nome ficar limpo
	
	gen dct = "`nome_dct'"
	* identifica a qual dicionário cada linha pertence, vai servir para ler de volta para .dct
	
	tempfile `nome_dct'
	save ``nome_dct'', replace
	
	local lista "`lista' ``nome_dct''"
	* armazena o endereço de todas as tempfiles
	
	di "`lista'"
}

clear

append using `lista'

cap save `saving', replace

end

program read_compdct
syntax, compdct(string) dict_name(string) [out(string)]

use `compdct', clear

qui keep if dct == "`dict_name'"
* mantém só as linhas referentes ao dct desejado

drop dct

outfile using "`out'", replace noquote

end
