******************************************************
*                   datazoom_social.ado                  *
******************************************************
* version 1.0

program define datazoom_social
syntax, research(str) folder1(str) folder2(str) date(integer) [state(str)] [record(str)]
	[datatype(str)] [identification(str)] [list(str asis)] [registertype(str)] /* Opções da POF */
	[language(str)] [comp pes fam dom both all nid idbas idrs ncomp comp81 comp92] /* Opções gerais */


if "`research'" == "pns" {
	datazoom_pns, original(`folder1') saving(`folder2') year(`date') `language'
}



if "`research'" == "censo" {
	if "`pes'" == "" & "`fam'" == "" & "`dom'" == "" & "`both'" == "" & "`all'" == "" {
		display "É necessário escolher um Tipo de Registro: Pessoas, Domicílios ou Ambos"
	}
	else {
		if "`comp'" == "" {
			if "`pes'" != "" {
				datazoom_censo, years(`date') ufs(`state') original(`folder1') saving(`folder2') pes `language'
			}
			else if "`fam'" != "" {
				datazoom_censo, years(`date') ufs(`state') original(`folder1') saving(`folder2') fam `language'
			}
			else if "`dom'" != "" {
				datazoom_censo, years(`date') ufs(`state') original(`folder1') saving(`folder2') dom `language'
			}
			else if "`both'" != "" {
				datazoom_censo, years(`date') ufs(`state') original(`folder1') saving(`folder2') both `language'
			}
			else if "`all'" != "" {
				datazoom_censo, years(`date') ufs(`state') original(`folder1') saving(`folder2') all `language'
			}
		}
		else {
			if "`pes'" != "" {
				datazoom_censo, years(`date') ufs(`state') original(`folder1') saving(`folder2') comp pes `language'
			}
			else if "`fam'" != "" {
				datazoom_censo, years(`date') ufs(`state') original(`folder1') saving(`folder2') comp fam `language'
			}
			else if "`dom'" != "" {
				datazoom_censo, years(`date') ufs(`state') original(`folder1') saving(`folder2') comp dom `language'
			}
			else if "`both'" != "" {
				datazoom_censo, years(`date') ufs(`state') original(`folder1') saving(`folder2') comp both `language'
			}
			else if "`all'" != "" {
				datazoom_censo, years(`date') ufs(`state') original(`folder1') saving(`folder2') comp all `language'
			}
		}
	}
}



if "`research'" == "pnadcontinua_anual" {  /* Para pnad continua anual ficar atendo ao construir a caixa de diálogo para a opção do ano */
	datazoom_pnadcont_anual, years(`date') original(`folder1') saving(`folder2') `language'
}


if "`research'" == "pnadcontinua" {
	if "`nid'" == "" & "`idbas'" == "" & "`idrs'" == "" {
		datazoom_pnadcontinua, years(`date') original(`folder1') saving(`folder2') nid `language'
	}
	else {
		if "`nid'" != "" {
			datazoom_pnadcontinua, years(`date') original(`folder1') saving(`folder2') nid `language'
		}
		else if "`idbas'" != "" {
			datazoom_pnadcontinua, years(`date') original(`folder1') saving(`folder2') idbas `language'
		}
		else if "`idrs'" != "" {
			datazoom_pnadcontinua, years(`date') original(`folder1') saving(`folder2') idrs `language'
		}
	}
}



if "`research'" == "pnad" { /* ncomp comp81 comp92 */ 
	if "`comp81'" == "" & "`comp92'" == "" {
		if "`pes'" == "" & "`dom'" == "" & "`both'" == "" {
			display "É necessário escolher um tipo de registro: Pessoas, Domicílios ou Ambos"
		}
		else if "`pes'" != "" {
			datazoom_pnad, years(`date') original(`folder1') saving(`folder2') pes ncomp `language'
		}
		else if "`dom'" != "" {
			datazoom_pnad, years(`date') original(`folder1') saving(`folder2') dom ncomp `language'
		}
		else if "`both'" != ""{
			datazoom_pnad, years(`date') original(`folder1') saving(`folder2') both ncomp `language'
		}
	}
	else {
		if "`comp81'" != "" {
			if "`pes'" == "" & "`dom'" == "" & "`both'" == "" {
				display "É necessário escolher um tipo de registro: Pessoas, Domicílios ou Ambos"
			}
			else if "`pes'" != "" {
				datazoom_pnad, years(`date') original(`folder1') saving(`folder2') pes comp81 `language'
			}
			else if "`dom'" != "" {
				datazoom_pnad, years(`date') original(`folder1') saving(`folder2') dom comp81 `language'
			}
			else if "`both'" != ""{
				datazoom_pnad, years(`date') original(`folder1') saving(`folder2') both comp81 `language'
			}
		}
		else if "`comp92'" != "" {
			if "`pes'" == "" & "`dom'" == "" & "`both'" == "" {
				display "É necessário escolher um tipo de registro: Pessoas, Domicílios ou Ambos"
			}
			else if "`pes'" != "" {
				datazoom_pnad, years(`date') original(`folder1') saving(`folder2') pes comp92 `language'
			}
			else if "`dom'" != "" {
				datazoom_pnad, years(`date') original(`folder1') saving(`folder2') dom comp92 `language'
			}
			else if "`both'" != ""{
				datazoom_pnad, years(`date') original(`folder1') saving(`folder2') both comp92 `language'
			}
		}
	}
}



if "`research'" == "pnad_covid" {
	datazoom_pnad_covid, months(`date') original(`folder1') saving(`folder2') `language'
}



if "`research'" == "pmenova" {
	if "`nid'" == "" & "`idbas'" == "" & "`idrs'" == "" {
		datazoom_pmenova, years(`date') original(`folder1') saving(`folder2') nid `language'
	}
	else {
		if "`nid'" != "" {
			datazoom_pmenova, years(`date') original(`folder1') saving(`folder2') nid `language'
		}
		else if "`idbas'" != "" {
			datazoom_pmenova, years(`date') original(`folder1') saving(`folder2') idbas `language'
		}
		else if "`idrs'" != "" {
			datazoom_pmenova, years(`date') original(`folder1') saving(`folder2') idrs `language'
		}
	}
}




if "`research'" == "pmeantiga" {
	if "`nid'" == "" & "`idbas'" == "" & "`idrs'" == "" {
		datazoom_pmeantiga, years(`date') original(`folder1') saving(`folder2') nid `language'
	}
	else {
		if "`nid'" != "" {
			datazoom_pmeantiga, years(`date') original(`folder1') saving(`folder2') nid `language'
		}
		else if "`idbas'" != "" {
			datazoom_pmeantiga, years(`date') original(`folder1') saving(`folder2') idbas `language'
		}
		else if "`idrs'" != "" {
			datazoom_pmeantiga, years(`date') original(`folder1') saving(`folder2') idrs `language'
		}
	}
}



if "`research'" == "ecinf" {
	datazoom_ecinf, year(`date') tipo(`record') original(`folder1') saving(`folder2') `language'
}



if "`research'" == "pof"{
	ano = substr("`date'",-2,2)
	
	
	if "`datatype'" == "" {
		display "Escolha o tipo de dado: Base Padronizada, Gastos Selecionados ou Tipo de Registro"
	}
	else {
		if "`datatype'" == "std" {
			datazoom_pof`datatype'_`ano', id(`identification') original(`folder1') saving(`folder2') `language'
		}
		else if "`datatype'" == "sel" {
			datazoom_pof`datatype'_`ano', id(`identification') lista(`list') original(`folder1') saving(`folder2') `language'
		}
		else if "`datatype'" == "trs" {
			datazoom_pof`datatype'_`ano', trs(`registertype') original(`folder1') saving(`folder2') `language'
		}
	}
}



end
