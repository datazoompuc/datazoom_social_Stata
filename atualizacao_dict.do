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

* Executa o read_compdct.ado para definir a função que cria o dicionário
clear programs
qui do read_compdct.ado

* Escreve o novo arquivo dict.dta a partir da pasta /dct/
write_compdct, folder("$pasta/dct") saving("dict.dta")
