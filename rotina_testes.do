if "`c(username)'" == "igorr" {
	global dados "F:\Dados"
}

cd $dados

mkdir bases_teste

/* Censo (AP 2010) */

* Pessoas

datazoom_censo, years(2010) ufs( AP ) /*
				*/ original("$dados\Censo") /*
				*/ saving("$dados\bases_teste") /*
				*/ pes

* Domicílios

datazoom_censo, years(2010) ufs( AP ) /*
				*/ original("$dados\Censo") /*
				*/ saving("$dados\bases_teste") /*
				*/ dom

* Both

datazoom_censo, years(2010) ufs( AP ) /*
				*/ original("$dados\Censo") /*
				*/ saving("$dados\bases_teste") /*
				*/ both

* Both com compat

datazoom_censo, years(2010) ufs( AP ) /*
				*/ original("$dados\Censo") /*
				*/ saving("$dados\bases_teste") /*
				*/ both comp

/* ECINF */

* 1997

datazoom_ecinf, year( 1997 ) /*
				*/ original("$dados\ECINF\1997") /*
				*/ saving("$dados\bases_teste") /*
				*/ tipo( pesocup indprop uecon trabrend moradores domicilios )

* 2003

datazoom_ecinf, year( 2003 ) /*
				*/ original("$dados\ECINF\2003") /*
				*/ saving("$dados\bases_teste") /*
				*/ tipo( pesocup sebrae indprop uecon trabrend moradores domicilios  )
				
/* PME Antiga (1994) */

* sem id

datazoom_pmeantiga, years(1994) /*
					*/ original("$dados\PME") /*
					*/ saving("$dados\bases_teste") /*
					*/ nid
					
* idbas

datazoom_pmeantiga, years(1994) /*
					*/ original("$dados\PME") /*
					*/ saving("$dados\bases_teste") /*
					*/ idbas

*idrs				

datazoom_pmeantiga, years(1994) /*
					*/ original("$dados\PME") /*
					*/ saving("$dados\bases_teste") /*
					*/ idrs	
					
/* PME Nova (2008) */

datazoom_pmenova, years(2008) /*
					*/ original("$dados\PME") /*
					*/ saving("$dados\bases_teste") /*
					*/ nid
					
* idbas

datazoom_pmenova, years(2008) /*
					*/ original("$dados\PME") /*
					*/ saving("$dados\bases_teste") /*
					*/ idbas

*idrs				

datazoom_pmenova, years(2008) /*
					*/ original("$dados\PME") /*
					*/ saving("$dados\bases_teste") /*
					*/ idrs
					
/* PNAD */

* 2001

foreach id in pes dom both{
	foreach comp in ncomp comp81 comp92{
		datazoom_pnad, years(2001) /*
					*/ original("$dados\PNAD") /*
					*/ saving("$dados\bases_teste") /*
					*/ `id' `comp'
	}
}					

* 2002-2015

foreach id in pes dom both{
	foreach comp in ncomp comp81 comp92{
		datazoom_pnad, years(2002/2009 2011/2015) /*
					*/ original("$dados\PNAD") /*
					*/ saving("$dados\bases_teste") /*
					*/ `id' `comp'
	}
}

/* PNAD Contínua (2019 Visita 1) */

datazoom_pnadcont_anual, years(20191) /*
						*/ original("$dados\PNADC\Anual") /*
						*/ saving("$dados\bases_teste")
						
/* PNAD Covid */

datazoom_pnad_covid, months(05 06 07 08 09 10 11) /*
					*/ original("$dados\PNAD_COVID") /*
					*/ saving("$dados\bases_teste")
					
/* PNS */					

* 2013

datazoom_pns, year(2013) /*
			*/ original("$dados\PNS") /*
			*/ saving("$dados\bases_teste")
			
* 2019	

datazoom_pns, year(2019) /*
			*/ original("$dados\PNS") /*
			*/ saving("$dados\bases_teste")	
			
			