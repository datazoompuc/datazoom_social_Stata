******************************************************
*                   datazoom_social.ado                  *
******************************************************
* version 1.0

program define datazoom_social
syntax, survey(str) source(str) save(str) date(numlist) [state(str)] [record(str)] /*
*/	[datatype(str)] [identification(str)] [list(str asis)] [registertype(str)] /* Opções da POF 
*/	[language(str)] [comp pes fam dom both all nid idbas idrs ncomp comp81 comp92] /* Opções gerais */


if "`survey'" == "pns" {
	datazoom_pns, original(`source') saving(`save') year(`date') `language'
}



if "`survey'" == "censo" {
	if "`pes'" == "" & "`fam'" == "" & "`dom'" == "" & "`both'" == "" & "`all'" == "" {
		display "É necessário escolher um Tipo de Registro: Pessoas, Domicílios ou Ambos"
	}
	else {
		if "`comp'" == "" {
			if "`pes'" != "" {
				datazoom_censo, years(`date') ufs(`state') original(`source') saving(`save') pes `language'
			}
			else if "`fam'" != "" {
				datazoom_censo, years(`date') ufs(`state') original(`source') saving(`save') fam `language'
			}
			else if "`dom'" != "" {
				datazoom_censo, years(`date') ufs(`state') original(`source') saving(`save') dom `language'
			}
			else if "`both'" != "" {
				datazoom_censo, years(`date') ufs(`state') original(`source') saving(`save') both `language'
			}
			else if "`all'" != "" {
				datazoom_censo, years(`date') ufs(`state') original(`source') saving(`save') all `language'
			}
		}
		else {
			if "`pes'" != "" {
				datazoom_censo, years(`date') ufs(`state') original(`source') saving(`save') comp pes `language'
			}
			else if "`fam'" != "" {
				datazoom_censo, years(`date') ufs(`state') original(`source') saving(`save') comp fam `language'
			}
			else if "`dom'" != "" {
				datazoom_censo, years(`date') ufs(`state') original(`source') saving(`save') comp dom `language'
			}
			else if "`both'" != "" {
				datazoom_censo, years(`date') ufs(`state') original(`source') saving(`save') comp both `language'
			}
			else if "`all'" != "" {
				datazoom_censo, years(`date') ufs(`state') original(`source') saving(`save') comp all `language'
			}
		}
	}
}



if "`survey'" == "pnadcontinua_anual" {  /* Para pnad continua anual ficar atendo ao construir a caixa de diálogo para a opção do ano */
	datazoom_pnadcont_anual, years(`date') original(`source') saving(`save') `language'
}


if "`survey'" == "pnadcontinua" {
	if "`nid'" == "" & "`idbas'" == "" & "`idrs'" == "" {
		datazoom_pnadcontinua, years(`date') original(`source') saving(`save') nid `language'
	}
	else {
		if "`nid'" != "" {
			datazoom_pnadcontinua, years(`date') original(`source') saving(`save') nid `language'
		}
		else if "`idbas'" != "" {
			datazoom_pnadcontinua, years(`date') original(`source') saving(`save') idbas `language'
		}
		else if "`idrs'" != "" {
			datazoom_pnadcontinua, years(`date') original(`source') saving(`save') idrs `language'
		}
	}
}



if "`survey'" == "pnad" { /* ncomp comp81 comp92 */ 
	if "`comp81'" == "" & "`comp92'" == "" {
		if "`pes'" == "" & "`dom'" == "" & "`both'" == "" {
			display "É necessário escolher um tipo de registro: Pessoas, Domicílios ou Ambos"
		}
		else if "`pes'" != "" {
			datazoom_pnad, years(`date') original(`source') saving(`save') pes ncomp `language'
		}
		else if "`dom'" != "" {
			datazoom_pnad, years(`date') original(`source') saving(`save') dom ncomp `language'
		}
		else if "`both'" != ""{
			datazoom_pnad, years(`date') original(`source') saving(`save') both ncomp `language'
		}
	}
	else {
		if "`comp81'" != "" {
			if "`pes'" == "" & "`dom'" == "" & "`both'" == "" {
				display "É necessário escolher um tipo de registro: Pessoas, Domicílios ou Ambos"
			}
			else if "`pes'" != "" {
				datazoom_pnad, years(`date') original(`source') saving(`save') pes comp81 `language'
			}
			else if "`dom'" != "" {
				datazoom_pnad, years(`date') original(`source') saving(`save') dom comp81 `language'
			}
			else if "`both'" != ""{
				datazoom_pnad, years(`date') original(`source') saving(`save') both comp81 `language'
			}
		}
		else if "`comp92'" != "" {
			if "`pes'" == "" & "`dom'" == "" & "`both'" == "" {
				display "É necessário escolher um tipo de registro: Pessoas, Domicílios ou Ambos"
			}
			else if "`pes'" != "" {
				datazoom_pnad, years(`date') original(`source') saving(`save') pes comp92 `language'
			}
			else if "`dom'" != "" {
				datazoom_pnad, years(`date') original(`source') saving(`save') dom comp92 `language'
			}
			else if "`both'" != ""{
				datazoom_pnad, years(`date') original(`source') saving(`save') both comp92 `language'
			}
		}
	}
}



if "`survey'" == "pnad_covid" {
	datazoom_pnad_covid, months(`date') original(`source') saving(`save') `language'
}



if "`survey'" == "pmenova" {
	if "`nid'" == "" & "`idbas'" == "" & "`idrs'" == "" {
		datazoom_pmenova, years(`date') original(`source') saving(`save') nid `language'
	}
	else {
		if "`nid'" != "" {
			datazoom_pmenova, years(`date') original(`source') saving(`save') nid `language'
		}
		else if "`idbas'" != "" {
			datazoom_pmenova, years(`date') original(`source') saving(`save') idbas `language'
		}
		else if "`idrs'" != "" {
			datazoom_pmenova, years(`date') original(`source') saving(`save') idrs `language'
		}
	}
}




if "`survey'" == "pmeantiga" {
	if "`nid'" == "" & "`idbas'" == "" & "`idrs'" == "" {
		datazoom_pmeantiga, years(`date') original(`source') saving(`save') nid `language'
	}
	else {
		if "`nid'" != "" {
			datazoom_pmeantiga, years(`date') original(`source') saving(`save') nid `language'
		}
		else if "`idbas'" != "" {
			datazoom_pmeantiga, years(`date') original(`source') saving(`save') idbas `language'
		}
		else if "`idrs'" != "" {
			datazoom_pmeantiga, years(`date') original(`source') saving(`save') idrs `language'
		}
	}
}



if "`survey'" == "ecinf" {
	datazoom_ecinf, year(`date') tipo(`record') original(`source') saving(`save') `language'
}



if "`survey'" == "pof"{
	ano = substr("`date'",-2,2)
	
	
	if "`datatype'" == "" {
		display "Escolha o tipo de dado: Base Padronizada, Gastos Selecionados ou Tipo de Registro"
	}
	else {
		if "`datatype'" == "std" {
			datazoom_pof`date', id(`identification') original(`source') saving(`save') std `language'
		}
		else if "`datatype'" == "sel" {
			datazoom_pof`date', id(`identification') sel(`list') original(`source') saving(`save') `language'
		}
		else if "`datatype'" == "trs" {
			datazoom_pof`date', trs(`registertype') original(`source') saving(`save') `language'
		}
	}
}

datazoom_message

end
