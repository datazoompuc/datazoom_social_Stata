program define datazoom_poftrs_95
syntax, trs(string) original(string) saving(string) [english]

if "`english'" != "" local lang "_en"

cd "`original'"
tokenize `trs'

local uf "BA CE DF GO MG PA PE PR RJ RS SP"

while "`*'"!="" {
	if length("`1'")==3 local a=substr("`1'",3,1)
	else local a=substr("`1'",3,2)
	
	tempfile dic

	findfile dict.dta

	read_compdct, compdct("`r(fn)'") dict_name("pof1995_tr`a'`lang'") out("`dic'")
	
	foreach x of local uf {
		qui infile using `dic', using("`x'4x.txt") clear
		keep if v0020==`a'
		tempfile `x'
		save ``x''
	}

	ap using `BA' `CE' `DF' `GO' `MG' `PA' `PE' `PR' `RJ' `RS'

	save "`saving'/pof1995_`1'", replace
		
	macro shift
}

end
