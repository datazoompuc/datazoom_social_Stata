program datazoom_pns
syntax, original(str) [saving(str)] year(integer) [english]

cd "`original'"

load_pns, year(`year') `english'

if "`saving'" != ""{
save "`saving'/pns_`year'", replace 

display as result "A base de dados foi salva na pasta `saving'!"
}

end

program load_pns
syntax, year(integer) [english]

if "`english'" != "" local lang "_en"

qui findfile pns`year'`lang'.dct
cap infile using "`r(fn)'", using(PNS_`year'.txt) clear

end
