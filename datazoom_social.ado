******************************************************
*                   datazoom_social.ado                  *
******************************************************
* version 1.0

program define datazoom_social
syntax, research(str) folder1(str) folder2(str) date(integer) [state(str)] [nid idbas idrs comp pes fam dom both all]


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
	display "DataZoom Social - PNAD Continua"
}

end
