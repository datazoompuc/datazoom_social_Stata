import dbase "C:\Users\felip\OneDrive\Documentos\PUC\Data Zoom\Censo\1991\dbf\dados\Região Sudeste\CD91AMOUP33.dbf", clear

rename *, lower
						
					/* Renomeando as variáveis */
					// Arquivo em formato dbf não contém algumas variáveis que tem em dat
					drop ufnom
					qui rename ufnum v1101
					drop mesonom
					qui rename mesonum v7001
					drop micronom
					qui rename micronum v7002
					drop municnom
					qui rename metrop v7003
					qui rename municnum v1102
					qui rename sitset v1061




					qui rename agua v0205
					qui rename aluguefx v2094
					qui rename aluguel v0209
					qui rename aspirpo v0227
					qui rename autpart v0218
					qui rename auttrab v0219
					qui rename banheiro v0213
					qui rename cd107 v0109
					qui rename cobertur v0204
					qui rename combcozi v0210
					qui rename comodor v0212
					qui rename comodos v0211
					qui rename condocup v0208
					qui rename democofx v2112
					qui rename democomo v2111
					qui rename demodofx v2122
					qui rename demodorm v2121
					qui rename especie v0201
					qui rename filtro v0216
					qui rename freezer v0225
					qui rename geladeir v0222
					qui rename ilumina v0221
					qui rename lixo v0214
					qui rename localiza v0202
					qui rename maqlavar v0226
					qui rename paredes v0203
					qui rename peso v7300
					qui rename radio v0220
					qui rename rdomiciv v2012
					qui rename rdonomif v2013
					qui rename rdorealf v2014
					qui rename sanescoa v0206
					qui rename sanuso v0207
					qui rename telefone v0217
					qui rename tvcores v0223
					qui rename tvpreto v0224




					qui rename espfam v2011
					qui rename numfam v0304
					qui rename rfachcaf v3044
					qui rename rfachcav v3043
					qui rename rfamiliv v3045
					qui rename rfanomif v3046
					qui rename rfapcapf v3049
					drop rfapcapv
					qui rename rfarealf v3047

					qui rename apopens v0359
					qui rename atividad v0347
					qui rename ativiset v3471
					qui rename cartass v0350
					qui rename conprev v0353
					qui rename deficie v0311
					qui rename edanoest v3241
					qui rename edcursns v0326
					qui rename edcurso v0329
					qui rename edgrau v0325
					qui rename edsabele v0323
					qui rename edserie v0324
					qui rename edulgrau v0328
					qui rename edulseri v0327
					qui rename empestb v0351
					qui rename fldomich v0335
					qui rename fldomicm v0336
					qui rename flmortoh v0339
					qui rename flmortom v0340
					qui rename flnamorh v0341
					qui rename flnamorm v0342
					qui rename flnamort v3357
					qui rename flnaodoh v0337
					qui rename flnaodom v0338
					qui rename flnavivh v3355
					qui rename flnavivm v3356
					qui rename flnavivt v3354
					qui rename fltidosh v3352
					qui rename fltidosm v3353
					qui rename fltidost v3351
					qui rename flvivosh v3361
					qui rename flvivosm v3362
					qui rename flvivost v3360
					qui rename horoutr v0355
					qui rename hortrab v0354
					qui rename idadeano v3072
					qui rename idademes v3073
					qui rename idadetip v3071
					qui rename loctrab v0352
					qui rename mianmomu v0318
					qui rename mianmouf v0317
					qui rename mianores v3152
					qui rename miantemu v3191
					qui rename mianteuf v0319
					qui rename miantezn v0320
					qui rename mimo86mu v3211
					qui rename mimo86uf v0321
					qui rename mimo86zn v0322
					qui rename mimumozn v0312
					qui rename minacion v3151
					qui rename minascmu v0314
					qui rename miufpais v0316
					qui rename miultmud v0313
					qui rename nordmae v3005
					qui rename ocupacao v0346
					qui rename ocupagrp v3461
					qui rename parendom v0302
					qui rename parenfam v0303
					qui rename pessoan v0098
					qui rename posocup v0349
					qui rename racacor v0309
					qui rename raposenf v3604
					qui rename raposenv v0360
					qui rename religiao v0310
					qui rename routocuf v3574
					qui rename routocuv v0357
					qui rename routrenf v3614
					qui rename routrenv v0361
					qui rename rprincif v3564
					qui rename rprinciv v0356
					qui rename rtonomif v3562
					qui rename rtorealf v3563
					qui rename rtotalpv v3561
					qui rename scatual v3342
					qui rename scdurasc v3341
					qui rename scid1uni v3311
					qui rename scidisca v3312
					qui rename scnaouni v0333
					qui rename scnatuni v0332
					qui rename scvivcon v0330
					qui rename sexo v0301
					qui rename sitdeso v0358
					qui rename trul12m v0345
					qui rename uvividad v3443
					qui rename uvividtp v3444
					qui rename uvivsexo v0343




					gen v0102 = .
					gen v3041 = .
					gen v3042 = .
					gen v7004 = .
					gen v0111 = .
					gen v0112 = .
					gen v7301 = v7300
															
										
				cap gen ano = 1991
				lab var ano "ano da pesquisa"
				
				egen munic = concat(v1101 v1102)
					destring munic, replace
					lab var munic "municipality codes without DV (6 digits)"
					
					
					
					
					lab var v1101 "uf"

lab var v7001 "mesorregião"
lab var v7002 "microrregião"
lab var v7003 "região metropolitana"
lab var v1102 "município"
lab var v1061 "situação do domicílio"





lab var v0205 "abastecimento de água"
lab var v2094 "faixas de aluguel mensal"
lab var v0209 "aluguel mensal"
lab var v0227 "aspirador de pó"
lab var v0218 "automóvel particular"
lab var v0219 "automóvel para trabalho"
lab var v0213 "banheiros"
lab var v0109 "número do domicílio"
lab var v0204 "cobertura"
lab var v0210 "combustível usado para cozinhar"
lab var v0212 "cômodos servindo de dormitório"
lab var v0211 "total de cômodos"
lab var v0208 "condição de ocupação do domicílio"
lab var v2112 "faixas de densidade de moradores/cômodo"
lab var v2111 "densidade de moradores por cômodo"
lab var v2122 "faixas de densidade de moradores/dormitório"
lab var v2121 "densidade de moradores por dormitório"
lab var v0201 "espécie do domicílio"
lab var v0216 "filtro de água"
lab var v0225 "freezer"
lab var v0222 "geladeira"
lab var v0221 "iluminação"
lab var v0214 "destino do lixo"
lab var v0202 "tipo de domicílio"
lab var v0226 "máquina de lavar roupa"
lab var v0203 "paredes"
lab var v7300 "peso amostral"
lab var v0220 "rádio"
lab var v2012 "rendimento nominal médio mensal domiciliar"
lab var v2013 "faixas de rendimento nominal domiciliar"
lab var v2014 "faixas de rendimento real domiciliar"
lab var v0206 "instalação sanitária"
lab var v0207 "uso da instalação sanitária"
lab var v0217 "telefone"
lab var v0223 "televisão preto e branco"
lab var v0224 "televisão em cores"




lab var v2011 "espécie da família"
lab var v0304 "tipo de família"
lab var v3044 "faixas de renda do casal"
lab var v3043 "renda do casal"
lab var v3045 "rendimento nominal médio mensal familiar"
lab var v3046 "faixas de rendimento nominal familiar"
lab var v3049 "faixas de rendimento nominal familiar pc"

lab var v3047 "faixas de rendimento real familiar"




lab var v0359 "aposentado ou pensionista"
lab var v0347 "código da atividade"
lab var v3471 "setor de atividade"
lab var v0350 "posse de carteira de trabalho assinada"
lab var v0353 "contribuição para instituto de previdência pública"
lab var v0311 "deficiência física ou mental"
lab var v3241 "anos de estudo"
lab var v0326 "grau que freqüenta em curso não seriado"
lab var v0329 "curso concluído"
lab var v0325 "grau que freqüenta em curso seriado"
lab var v0323 "alfabetização"
lab var v0324 "série que frequenta"
lab var v0328 "grau da última série concluída com aprovação"
lab var v0327 "última série concluída com aprovação"
lab var v0351 "no. de empregados no estabelecimento, etc."
lab var v0335 "filhos tidos que moram no domicílio"
lab var v0336 "filhas tidas que moram no domicílio"
lab var v0339 "filhos tidos vivos que já morreram (homens)"
lab var v0340 "filhas tidas vivas que já morreram (mulheres)"
lab var v0341 "filhos tidos nascidos mortos (homens)"
lab var v0342 "filhas tidas nascidas mortas (mulheres)"
lab var v3357 "total de filhos tidos nascidos mortos"
lab var v0337 "filhos tidos que moram em outro domicílio (homens)"
lab var v0338 "filhas tidas que moram em outro domicílio (mulheres)"
lab var v3355 "número de filhos tidos nascidos vivos (homens)"
lab var v3356 "número de filhas tidas nascidas vivas (mulheres)"
lab var v3354 "total de filhos tidos nascidos vivos"
lab var v3352 "número de filhos tidos (homens)"
lab var v3353 "número de filhos tidos (mulheres)"
lab var v3351 "total de filhos tidos"
lab var v3361 "número de filhos vivos (homens)"
lab var v3362 "número de filhas vivas (mulheres)"
lab var v3360 "total de filhos(as) vivos(as)"
lab var v0355 "horas trabalhadas em outras ocupações"
lab var v0354 "horas trabalhadas por semana na ocupação principal"
lab var v3072 "idade (em anos completos)"
lab var v3073 "idade (em meses completos)"
lab var v3071 "tipo de idade"
lab var v0352 "local de trabalho"
lab var v0318 "anos em que mora no município"
lab var v0317 "anos em que mora na unidade da federação"
lab var v3152 "ano que fixou residência no país"
lab var v3191 "município/país estrangeiro em que morava no mês de ref."
lab var v0319 "uf e município ou país estrangeiro que morava antes"
lab var v0320 "situação do domicílio de residência anterior"
lab var v3211 "município/país estrangeiro de residência no mês de ref."
lab var v0321 "uf e município/país estrangeiro em que morava no mês de ref."
lab var v0322 "situação do domicílio de residência no mês de ref."
lab var v0312 "morou neste município"
lab var v3151 "nacionalidade"
lab var v0314 "nasceu neste município"
lab var v0316 "uf ou país estrangeiro de nascimento"
lab var v0313 "anos de moradia na situação do domicílio"
lab var v3005 "número de ordem da mãe"
lab var v0346 "código da ocupação"
lab var v3461 "grupo de ocupação"
lab var v0302 "condição no domicílio"
lab var v0303 "condição na família"
lab var v0098 "ordem da pessoa"
lab var v0349 "posição na ocupação"
lab var v0309 "raça ou cor"
lab var v3604 "faixas de rendimento de aposentadoria e/ou pensão"
lab var v0360 "rendimento bruto de aposentadoria e/ou pensão"
lab var v0310 "religião"
lab var v3574 "faixas de rendimento de outras ocupações"
lab var v0357 "rendimento bruto de outras ocupações"
lab var v3614 "faixas de outros rendimentos"
lab var v0361 "rendimento bruto ou média mensal - outros rend."
lab var v3564 "faixas de rendimento da ocupação principal"
lab var v0356 "rendimento bruto da ocupação principal"
lab var v3562 "faixas de rendimento nominal total"
lab var v3563 "faixas de rendimento real total"
lab var v3561 "rendimento nominal total"
lab var v3342 "situação conjugal atual da pessoa"
lab var v3341 "duração da situação conjugal atual da pessoa"
lab var v3311 "idade da pessoa ao contrair primeira união"
lab var v3312 "idade da pessoa ao iniciar a situação conjugal atual"
lab var v0333 "estado conjugal (situação conjugal)"
lab var v0332 "estado conjugal (natureza da união)"
lab var v0330 "vive ou viveu com cônjuge"
lab var v0301 "sexo"
lab var v0358 "condição de atividade"
lab var v0345 "trabalhou em todos ou em parte dos últimos 12 meses"
lab var v3443 "idade calculada do último filho nascido vivo"
lab var v3444 "tipo de idade do último filho nascido vivo"
lab var v0343 "sexo do último filho nascido vivo"




lab var v0102 "identificação do questionário"
lab var v3041 "Homens na familia"
lab var v3042 "Mulheres na familia"
lab var ano "ano da pesquisa"
lab var munic "municipality codes without DV (6 digits)"
lab var v7004 "macroregião"
lab var v0111 "número de homens no domicílio"
lab var v0112 "número de muleres no domicílio"
lab var v7301 "peso amostral"
					
					save "C:\Users\felip\OneDrive\Documentos\PUC\Data Zoom\Censo\1991\dbf\tarefa\CD9133dbf.dta", replace