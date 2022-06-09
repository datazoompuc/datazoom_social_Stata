/* Código para encontrar erros nos dcts. */

local dct "caminho/até/o/.dct"
local arquivo "caminho/até/.txt"
infile using "`dct'", using("`arquivo'") clear

/* onde .txt é o input disponibilizado pelo IBGE */
