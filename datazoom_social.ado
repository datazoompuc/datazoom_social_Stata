******************************************************
*                   datazoom_social.ado                  *
******************************************************
* version 1.0

program define datazoom_social
syntax, research(str) folder1(str) folder2(str) date(integer) [state(str)] [comp pes fam dom both all nid idbas idrs ncomp comp81 comp92]


if "`research'" == "pns" {
	datazoom_pns, original(`folder1') saving(`folder2') year(`date')
}



if "`research'" == "censo" {
	if "`pes'" == "" & "`fam'" == "" & "`dom'" == "" & "`both'" == "" & "`all'" == "" {
		display "É necessário escolher um Tipo de Registro: Pessoas, Domicílios ou Ambos"
	}
	else {
		if "`comp'" == "" {
			if "`pes'" != "" {
				datazoom_censo, years(`date') ufs(`state') original(`folder1') saving(`folder2') pes
			}
			else if "`fam'" != "" {
				datazoom_censo, years(`date') ufs(`state') original(`folder1') saving(`folder2') fam
			}
			else if "`dom'" != "" {
				datazoom_censo, years(`date') ufs(`state') original(`folder1') saving(`folder2') dom
			}
			else if "`both'" != "" {
				datazoom_censo, years(`date') ufs(`state') original(`folder1') saving(`folder2') both
			}
			else if "`all'" != "" {
				datazoom_censo, years(`date') ufs(`state') original(`folder1') saving(`folder2') all
			}
		}
		else {
			if "`pes'" != "" {
				datazoom_censo, years(`date') ufs(`state') original(`folder1') saving(`folder2') comp pes
			}
			else if "`fam'" != "" {
				datazoom_censo, years(`date') ufs(`state') original(`folder1') saving(`folder2') comp fam
			}
			else if "`dom'" != "" {
				datazoom_censo, years(`date') ufs(`state') original(`folder1') saving(`folder2') comp dom
			}
			else if "`both'" != "" {
				datazoom_censo, years(`date') ufs(`state') original(`folder1') saving(`folder2') comp both
			}
			else if "`all'" != "" {
				datazoom_censo, years(`date') ufs(`state') original(`folder1') saving(`folder2') comp all
			}
		}
	}
}



if "`research'" == "pnadcontinua_anual" {  /* Para pnad continua anual ficar atendo ao construir a caixa de diálogo para a opção do ano */
	datazoom_pnadcont_anual, years(`date') original(`folder1') saving(`folder2') 
}



if "`research'" == "pnadcontinua" {
	if "`nid'" == "" & "`idbas'" == "" & "`idrs'" == "" {
		datazoom_pnadcontinua, years(`date') original(`folder1') saving(`folder2') nid
	}
	else {
		if "`nid'" != "" {
			datazoom_pnadcontinua, years(`date') original(`folder1') saving(`folder2') nid
		}
		else if "`idbas'" != "" {
			datazoom_pnadcontinua, years(`date') original(`folder1') saving(`folder2') idbas
		}
		else if "`idrs'" != "" {
			datazoom_pnadcontinua, years(`date') original(`folder1') saving(`folder2') idrs
		}
	}
}



if "`research'" == "pnad" { /* ncomp comp81 comp92 */ 
	if "`comp81'" == "" & "`comp92'" == "" {
		if "`pes'" == "" & "`dom'" == "" & "`both'" == "" {
			display "É necessário escolher um tipo de registro: Pessoas, Domicílios ou Ambos"
		}
		else if "`pes'" != "" {
			datazoom_pnad, years(`date') original(`folder1') saving(`folder2') pes ncomp
		}
		else if "`dom'" != "" {
			datazoom_pnad, years(`date') original(`folder1') saving(`folder2') dom ncomp
		}
		else if "`both'" != ""{
			datazoom_pnad, years(`date') original(`folder1') saving(`folder2') both ncomp
		}
	}
	else {
		if "`comp81'" != "" {
			if "`pes'" == "" & "`dom'" == "" & "`both'" == "" {
				display "É necessário escolher um tipo de registro: Pessoas, Domicílios ou Ambos"
			}
			else if "`pes'" != "" {
				datazoom_pnad, years(`date') original(`folder1') saving(`folder2') pes comp81
			}
			else if "`dom'" != "" {
				datazoom_pnad, years(`date') original(`folder1') saving(`folder2') dom comp81
			}
			else if "`both'" != ""{
				datazoom_pnad, years(`date') original(`folder1') saving(`folder2') both comp81
			}
		}
		else if "`comp92'" != "" {
			if "`pes'" == "" & "`dom'" == "" & "`both'" == "" {
				display "É necessário escolher um tipo de registro: Pessoas, Domicílios ou Ambos"
			}
			else if "`pes'" != "" {
				datazoom_pnad, years(`date') original(`folder1') saving(`folder2') pes comp92
			}
			else if "`dom'" != "" {
				datazoom_pnad, years(`date') original(`folder1') saving(`folder2') dom comp92
			}
			else if "`both'" != ""{
				datazoom_pnad, years(`date') original(`folder1') saving(`folder2') both comp92
			}
		}
	}
}



if "`research'" == "pnad_covid" {
	datazoom_pnad_covid, months(`date') original(`folder1') saving(`folder2')
}



if "`research'" == "pmenova" {
	if "`nid'" == "" & "`idbas'" == "" & "`idrs'" == "" {
		datazoom_pmenova, years(`date') original(`folder1') saving(`folder2') nid
	}
	else {
		if "`nid'" != "" {
			datazoom_pmenova, years(`date') original(`folder1') saving(`folder2') nid
		}
		else if "`idbas'" != "" {
			datazoom_pmenova, years(`date') original(`folder1') saving(`folder2') idbas
		}
		else if "`idrs'" != "" {
			datazoom_pmenova, years(`date') original(`folder1') saving(`folder2') idrs
		}
	}
}




if "`research'" == "pmeantiga" {
	if "`nid'" == "" & "`idbas'" == "" & "`idrs'" == "" {
		datazoom_pmeantiga, years(`date') original(`folder1') saving(`folder2') nid
	}
	else {
		if "`nid'" != "" {
			datazoom_pmeantiga, years(`date') original(`folder1') saving(`folder2') nid
		}
		else if "`idbas'" != "" {
			datazoom_pmeantiga, years(`date') original(`folder1') saving(`folder2') idbas
		}
		else if "`idrs'" != "" {
			datazoom_pmeantiga, years(`date') original(`folder1') saving(`folder2') idrs
		}
	}
}




end
