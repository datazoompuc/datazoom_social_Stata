/*
Rotina para atualizar o arquivo dict.dta quando algum dicionário for alterado
	
	1. Atualize o arquivo .dct na pasta da pesquisa
	2. Jogue essa nova versão na pasta datazoom_social_Stata/dct/
	3. Rode essa do-file
*/

* Para pegar o endereço da pasta do pacote
di as input _dup(59) "-" _newline "Qual o caminho até a pasta do pacote?" ///
		_newline "{it:Ex: C:/.../datazoom_social_Stata}" ///
		_request(pasta)

* Muda cd para essa pasta
cd "$pasta"

* Reseta automaticamente a pasta /dct/

shell rmdir "dct" /s // deleta versão anterior 

mkdir dct // cria uma nova pasta vazia

local dctfiles ""

* Transferindo todos os arquivos .dct

foreach folder in "Censo" "Ecinf" "PME" "PNAD" "PNAD_Continua/Anual" "PNAD_Continua/Trimestral" /*
	*/ "PNAD_Covid" "PNS" "POF/1995" "POF/2002" "POF/2008" "POF/2017" {
	
	local newfiles : dir "`folder'/dct" files "*.dct"
	
	foreach file of local newfiles {
		copy `folder'/dct/`file' dct/`file'
	}
}

* Executa o read_compdct.ado para definir a função que cria o dicionário
clear programs
qui do read_compdct.ado

* Escreve o novo arquivo dict.dta a partir da pasta /dct/
write_compdct, folder("$pasta/dct") saving("dict.dta")
