program datazoom_pof1995
syntax, trs(string) [sel(string)] [std(string)] original(string) saving(string) [english]

load_pof95, trs(`trs') original(`original') `english'

local bases = r(bases)

* Caso só se queira os TRs crus, acaba por aqui
if "`sel'" == "" & "`std'" == ""{

cd "`saving'"

	foreach tr in{
		save pof1995_tr`tr', replace
	}

di as result "As bases foram salvas em `saving'"	
	
exit	
}

* Caso contrário, falta aplicar a função de bases selecionadas ou a de bases padronizadas

if "`sel'" != ""{
	pofsel95, trs(`trs') sel(`sel')
	
	salva etc
}
else if "`std'" != ""{
	pofstd95, trs(`trs') std(`std')
	
	salva etc
}

end

program load_pof95, rclass // Retorna um local com o path das tempfiles, armazenado em r(bases)
syntax, original(string) trs(string) [english]

if "`english'" != "" local lang "_en"

cd "`original'"

local ufs "BA CE DF GO MG PA PE PR RJ RS SP"

foreach tr in `trs'{
	if length("`tr'")==3 local suffix = substr("`tr'",3,1)
	else local suffix = substr("`tr'",3,2)
	
	tempfile dic

	findfile dict.dta

	read_compdct, compdct("`r(fn)'") dict_name("pof1995_tr`suffix'`lang'") out("`dic'")
	
	tempfile `tr'
	
	foreach uf of local ufs{
		qui infile using `dic', using("`uf'4x.txt") clear
		keep if v0020==`suffix'
		
		cap append using ``tr''
		
		save ``tr'', replace // Empilha todos os estados em cada TR
	}

local bases `bases' ``tr'' // Macro com o path de todos os TRs
}

return local bases `bases'

end
