program datazoom_pof2002
syntax, [trs(string)] [id(string)] [sel(string)] [std] original(string) saving(string) [english]

if "`sel'" != "" & "`id'" != "pess"{
	local trs tr5 tr6 tr7 tr8 tr9 tr10 tr11 tr12 tr13 tr14 // Apenas TRs de despesas e rendimentos
}
else if "`sel'" != "" & "`id'" == "pess"{
	local trs tr10 tr11 tr12 tr13 tr14 // Mantém somente os TRs individuais
}	
else if "`std'" != ""{
	local trs tr5 tr6 tr7 tr8 tr9 tr10 tr11 tr12 tr13 tr14 // Para std
}
else if "`trs'" == "" local trs tr1 tr2 tr3 tr4 tr5 tr6 tr7 tr8 tr9 tr10 tr11 tr12 tr13 tr14

foreach tr in `trs'{
	tempfile base_`tr' // Temps têm que ser criadas fora da função de load para serem recuperadas
	local bases `bases' `base_`tr'' // Local que armazena todas essas bases
}

load_pof02, trs(`trs') temps(`bases') original(`original') `english'

* Caso só se queira os TRs crus, acaba por aqui
if "`sel'" == "" & "`std'" == ""{
	
	cd "`saving'"

	foreach tr in `trs'{
		use `base_`tr'', clear
		save pof2002_`tr', replace
	}
}

* Caso contrário, falta aplicar a função de bases selecionadas ou a de bases padronizadas

else if "`sel'" != ""{
	pofsel_02, id(`id') sel(`sel') trs(`trs') temps(`bases') original(`original') `english'
	
	cd "`saving'"
	save pof2002_`id'_custom, replace
}
else{
	foreach type in `id'{
		pofstd_02, id(`type') trs(`trs') temps(`bases') original(`original') `english'
	
		cd "`saving'"
		save "pof2002_`type'_standard", replace
	}
}

di as result "As bases foram salvas em `saving'"

end

program load_pof02 // Armazena as bases nas temps fornecidas
syntax, temps(string) original(string) trs(string) [english]

if "`english'" != "" local lang "_en"

cd "`original'"

local registros "DOMICILIO MORADOR CONDICOES_DE_VIDA INVENTARIO DESPESA_90DIAS DESPESA_12MESES OUTRAS_DESPESAS SERVICO_DOMS CADERNETA_DESPESA DESPESA DESPESA_VEICULO RENDIMENTOS1 OUTROS_RECI DESPESA_ESP"

forvalues i = 1/`: word count `trs''{
	
	local tr: word `i' of `trs'
	local base: word `i' of `temps'
	
	local num = substr("`tr'", 3, .) // tr1 -> 1, tr11 -> 11
	local registro: word `num' of `registros'
	
	di as input "Extraindo TR`num': `registro'"
	
	tempfile dic

	findfile dict.dta

	read_compdct, compdct("`r(fn)'") dict_name("pof2002_`tr'`lang'") out("`dic'")
	
	qui infile using `dic', using("`original'/T_`registro'.txt") clear
	
	qui save `base', replace // Salva o TR na tempfile destinada a ele
}

end

program pofsel_02
syntax, id(string) sel(string) trs(string) temps(string) original(string) [english]

/* Lista de itens - desagregados e agregados */

* Alimentação no domicílio (DAD)
local Arroz  "63001/63003 63005 63033 63037"
local Feijao  "63012/63017 63019 63021/63026 63031"
local Outros_cereais_etc "63004 63006/63011 63027/63030 63032 63034 64051/64066 64068/64072 64074/64075 64078"
local Cereais_leguminosas_etc  `" `Arroz' `Feijao' `Outros_cereais_etc'"'
local Macarrao  "64032/64034"
local Farinha_de_trigo   "64010"
local Farinha_de_mandioca   "64014"
local Outras_farinhas_etc  "64001/64009 64011/64013 64015/64024 64026/64031 64035/64037 64042/64044"
local Farinhas_feculas_e_massas  `" `Macarrao' `Farinha_de_trigo' `Farinha_de_mandioca' `Outras_farinhas_etc'"'
local Batata_inglesa   "63051"
local Cenoura   "63062"
local Outros_tuberculos  "63052/63057 63059/63061 63063/63068"
local Tuberculos_e_raizes  `" `Batata_inglesa' `Cenoura' `Outros_tuberculos'"'
local Acucar_refinado   "67001"
local Acucar_cristal   "67002"
local Outros_acucares_etc  "67003/67056 67058/67063 67066/67077 67079"
local Acucares_e_derivados  `" `Acucar_refinado' `Acucar_cristal' `Outros_acucares_etc'"'  
local Tomate   "65051"
local Cebola   "65057"
local Alface   "65001"
local Outros_legumes_etc  "65002/65028 65030/65050 65052/65056 65058/65076"
local Legumes_e_verduras  `" `Tomate' `Cebola' `Alface' `Outros_legumes_etc'"'
local Banana  "66001/66011"
local Laranja  "66012/66015 66017/66018"
local Maca   "66030"
local Outras_frutas  "66019/66029 66031/66053 66055/66076 66086/66094"
local Frutas  `"`Banana' `Laranja' `Maca' `Outras_frutas'"'
local Carne_de_boi_de_primeira  "69001/69007 69014 69016 69099 69103 69126"
local Carne_de_boi_de_segunda  "69008/69013 69015 69017 69026 69108 69110 69112"
local Carne_de_suino  "69033/69037 69104/69106 69109 69124/69125 69134"
local Carnes_e_peixes_ind  "70004/70005 70014/70015 70024/70025 70034/70035 70044 70045 70054/70055 70064/70065 70074/70075 70084/70085 70094/70095 71004/71005 71014/71016 71024/71025 71034/71035 71044/71045 71054/71055 71064/71065 71084/71085 71094/71095 72004/72005 72014/72015 72024/72025 72034/72035 72044/72045 72054/72055 72064/72065 72074 72075 72084/72085 72094/72095 73004/73005 73014/73015 73024/73025 73034/73035 73044/73045 73054/73055 73064/73065 73084/73085 73094/73095 74004/74005 74014/74015 74024/74025 74034/74035 74044/74045 74054/74055 74064/74065 74074/74075 74084/74085 74094/74095 75004/75005 75034/75035 75044/75045 75054/75055 75074/75075 75084/75085 75094/75095 76004/76005 76014/76015 76024/76025 76044/76045 76054/76055 76064 76074 76084 76094 77004 77024 77034 77044 77054/77055 77064 77074/77075 77094/77095 78004 78024 78034/78035 80004/80005 80014/80015 80024/80025 80034/80035 80044/80045 80054/80055 80064/80065 80074/80075 80084/80085 80094/80095 81004/81005 81014/81015 81024/81025 81034/81035 81044/81045 81054/81055 81064/81065 81074/81075 81084/81085 81094/81095 82004/82005 82014/82015 82024/82025 82034/82035 82044/82045 82054/82055 82064/82065 82074/82075 82084/82085 82094/82095 83004/83005 83014/83015 83024/83025 83034/83035 83044/83045 83054/83055 83064/83065 83074/83075 83084/83085 83094/83095 84004/84005 84014/84015 84024/84025 84034 84044/84045 84054/84055 84064/84065 84074/84075 84084/84085 84094/84095 85004 85014/85015 89994/89995 91029 91031 91098 91101 92051/92060 92062/92079 92082/92085 92089 92091/92093 92095 92097/92098 92105 92108 92110/92112"
local Pescados_frescos  "70001/70003 70011/70013 70021/70023 70031/70033 70039 70041/70043 70049 70051/70053 70061/70063 70071/70073 70081/70083 70091/70093 71001/71003 71011/71013 71021/71023 71031/71033 71041/71043 71049 71051/71053 71061/71063 71069 71081/71083 71091/71093 72001/72003 72011/72013 72021/72023 72031/72033 72041/72043 72051/72053 72059 72061/72063 72071/72073 72081/72083 72089 72091/72093 73001/73003 73011/73013 73021/73023 73031/73033 73041/73043 73051/73053 73061/73063 73081/73083 73091/73093 74001/74003 74011/74013 74019 74021/74023 74031/74033 74041/74043 74051/74053 74061/74063 74071/74073 74081/74083 74091/74093 75001/75003 75031/75033 75041/75043 75051/75053 75071/75073 75081/75083 75091/75093 76001/76003 76006/76013 76021/76023 76041/76043 76051/76053 76056/76057 76061/76062 76071/76072 76081/76082 76091/76092 77001/77002 77011 77021/77022 77031/77033 77041/77042 77051/77053 77071/77073 77091/77093 78001 78021/78022 78031/78033 78041 78051 78061 78071 78082 80001/80003 80011/80013 80021/80023 80031/80033 80041/80043 80049 80051/80053 80061/80063 80071/80073 80081/80083 80091/80093 81001/81003 81009 81011/81013 81021/81023 81031/81033 81041/81043 81051/81053 81061/81063 81071/81073 81081/81083 81091/81093 82001/82003 82011/82013 82021/82023 82029 82031/82033 82041/82043 82051/82053 82061/82063 82071/82073 82076 82081/82083 82091/82093 83001/83003 83011/83013 83021/83023 83029 83031/83033 83041/83043 83049 83051/83053 83061/83063 83071/83073 83081/83083 83091/83093 84001/84003 84011/84013 84021/84023 84031/84032 84041/84043 84051/84053 84061/84063 84071/84073 84081/84083 84091/84093 85001/85002 85011/85013 85019 85021 85031 85041 85051 85061 85071 85081 85091 85101 85111 89991/89993 89999"
local Outros_carnes_etc  "69018/69025 69027/69032 69038/69058 69067 69069/69098 69100/69102 69107 69111 69113/69123 69127/69133"
local Carnes_visceras_etc  `"`Carne_de_boi_de_primeira' `Carne_de_boi_de_segunda' `Carne_de_suino' `Carnes_e_peixes_ind' `Pescados_frescos' `Outros_carnes_etc'"'
local Frango  "91001/91014 91025/91027 91032 91036 91038 91047/91048"
local Ovo_de_galinha   "91033"
local Outros_aves_etc  "91015/91024 91028 91030 91034/91035 91037 91039/91046 91049/91050 91090 91097 91099 91100"
local Aves_e_ovos  `" `Frango' `Ovo_de_galinha' `Outros_aves_etc'"'
local Leite_de_vaca  "91051/91052"
local Leite_em_po  "91056/91058"
local Queijos  "91067/91070 91072 91074/91080 91086/91087 91096"
local Outros_leites_etc  "91053/91055 91059/91066 91082 91085 91088/91089"
local Leites_e_derivados `"`Leite_de_vaca' `Leite_em_po' `Queijos' `Outros_leites_etc'"'
local Pao_frances   "92001"
local Biscoito  "92022/92024 92048/92049 92080/92081"
local Outros_panificados  "92002/92021 92025/92047 92050 92061 92086/92088 92090 92099/92104 92106/92107 92109"
local Panificados  `"`Pao_frances' `Biscoito' `Outros_panificados'"'
local Oleo_de_soja   "94003"
local Azeite_de_oliva   "94001"
local Outros_oleos_e_gorduras  "94002 94004/94038"
local Oleos_e_gorduras  `"`Oleo_de_soja' `Azeite_de_oliva' `Outros_oleos_e_gorduras'"'
local Cafe_moido   "93025"
local Refrigerantes  "93001/93006 93009/93014 93017/93019 93035 93041/93043 93046 93049 93054/93055 93057/93058 93067/93073"
local Cervejas_e_chopes  "96051/96052"
local Outras_bebidas_alcoolicas  "96053/96082"
local Outras_bebidas_etc  "64067 64073 64077 67057 67064/67065 67078 93020/93024 93026/93034 93036/93039 93044/93045 93047/93048 93050/93053 93056 93059/93065 96083"
local Bebidas_e_infusoes  `"`Cafe_moido' `Refrigerantes' `Cervejas_e_chopes' `Outras_bebidas_alcoolicas' `Outras_bebidas_etc'"'
local Enlatados_e_conservas  "90001/90061"
local Massa_de_tomate   "68047"
local Maionese   "68043"
local Sal_refinado   "68001"
local Outros_sal  "68002/68039 68041 68042 68044/68046 68048/68055 68057/68063 68065/68093"
local Sal_e_condimentos  `"`Massa_de_tomate' `Maionese'  `Sal_refinado' `Outros_sal'"'
local Alimentos_preparados  "93040 94051/94065 94067/94069 94071/94074 94076/94082 94084/94105"
local Outros_alimentacao_no_dom  "99090/99098"
local Alimentacao_no_dom  `" `Cereais_leguminosas_etc' `Farinhas_feculas_e_massas' `Tuberculos_e_raizes' `Acucares_e_derivados' `Legumes_e_verduras' `Frutas' `Carnes_visceras_etc' `Aves_e_ovos' `Leites_e_derivados' `Panificados' `Oleos_e_gorduras' `Bebidas_e_infusoes' `Enlatados_e_conservas' `Sal_e_condimentos' `Alimentos_preparados' `Outros_alimentacao_no_dom'"'

* Alimentação fora do domicílio (DAF)
local Almoco_e_jantar  "24001 24041/24042 24051/24052 24055 48044"
local Cafe_leite_chocolate  "24002 24005"
local Sanduiches_e_salgados  "24004 24043"
local Refri_e_outras_nao_alcoolicas  "24006/24007 24013 24020/24022 24028/24029 24031/24033 24036 24039/24040 24044/24049 24059/24060"
local Lanches  "24037 24053/24054 24056/24057 41006 49026"
local Cervejas_e_outras_alcoolicas  "24009/24012"
local Outras_alimentacao_fora_do_dom  "24003 24008 24014/24019 24023/24027 24030 24034/24035 24038 24050 24058 24061 24096/24098"
local Alimentacao_fora_do_dom `"`Almoco_e_jantar' `Cafe_leite_chocolate' `Sanduiches_e_salgados' `Refri_e_outras_nao_alcoolicas' `Lanches' `Cervejas_e_outras_alcoolicas'  `Outras_alimentacao_fora_do_dom'"'
local Despesa_com_alimentacao  `"`Alimentacao_no_dom'  `Alimentacao_fora_do_dom'"'

* Despesas diversas (DDI)
local Aluguel  "10005 10010 10016 10018 10090"
local Energia_eletrica  "7002"
local Telefone_fixo  "7004"
local Telefone_celular  "28055"
local Gas_domestico  "7003 7005"
local Agua_e_esgoto  "7001"
local Outros_servicos_etc  "7016/7017 10012 10019 12003 12005/12015 12017/12019 12021/12025 12026 12096"
local Servicos_e_taxas  `"`Energia_eletrica' `Telefone_fixo' `Telefone_celular' `Gas_domestico' `Agua_e_esgoto' `Outros_servicos_etc'"'
local Manutencao_do_lar  "7006/7012 7018/7020 7098 8001/8053 8055/8057 8059 8061/8062 8064 8067 8069/8071 8073 8080/8085 8098 19001/19030 19048 95057 95106"
local Artigos_de_limpeza  "95001/95008 95011 95014/95027 95030/95034 95042 95045 95056 95058 95060/95061 95063/95066 95069/95071 95073 95075 95077 95101/95103"
local Mobiliarios_e_artigos_do_lar  "16019 16021/16030 16035/16036 16041/16042 16044/16045 16047 16062 16070 16082 16089 16103/16104 16112 17001/17018 17020/17027 17029/17037 17040/17046 17060/17067 17069 17072 17074/17078 17080/17118 18001/18003 18005 18050/18098 37003/37006 37010/37013 37016 37020 37023/37024 37031/37033 37038/37040 37043 37045/37047 39001/39010 39012/39020 39022/39026 39028 39030/39044 39046/39105 40032 40037 40050 40068 40073 95009/95010 95012/95013 95028/95029 95035/95044 95046/95055 95059 95062 95067/95068 95072 95074 95076 95078/95085 95104/95105 95107/95108"
local Eletrodomesticos  "15001/15062 15064/15072 15074/15078 15080/15094 15096/15128 16014/16017 16031/16034 16037/16038 16048/16050 16052 16057 16060/16061 16063 16065 16069 16076 16093 16096/16097 16100 16102 16107/16110 16113/16115 30034 40067"
local Consertos_de_artigos_do_lar  "9001/9003 9006/9010 9012 9015 9020/9086 9098 39011 39045"
local Habitacao `"`Aluguel' `Servicos_e_taxas' `Manutencao_do_lar' `Artigos_de_limpeza' `Mobiliarios_e_artigos_do_lar' `Eletrodomesticos' `Consertos_de_artigos_do_lar'"'
local Roupa_de_homem  "34001/34039 34098"
local Roupa_de_mulher  "35001/35060 35098"
local Roupa_de_crianca  "36001/36053 36098"
local Calcados_e_apetrechos  "38001/38030 38032/38049 38098"
local Joias_e_bijuterias  "40001 40074 46001/46008 46010/46011 46098"
local Tecidos_e_armarinhos  "37001/37002 37008 37014/37015 37017/37019 37021 37025/37030 37034/37037 37044 37098"
local Vestuario  `"`Roupa_de_homem' `Roupa_de_mulher' `Roupa_de_crianca' `Calcados_e_apetrechos' `Joias_e_bijuterias' `Tecidos_e_armarinhos'"'
local Urbano  "23001/23005 23010/23011 23014/23016 23020/23027 23029/23030 23032/23034 23098 48045"
local Gasolina_para_veiculo_proprio  "23007 23028"
local Alcool_para_veiculo_proprio  "23006"
local Manutencao_de_veiculo_proprio  "23019 43001/43008 43012 43014/43018 43020/43023 43026 43030/43032"
local Aquisicao_de_veiculos  "50012 51001/51014 51020/51025 51098"
local Viagens  "23031 41001/41005 41007/41026 41098"
local Outros_transporte  "23008/23009 23012/23013 23017/23018 43009/43011 43013 43019 43024/43025 43027/43029 43033/43037 43098 50003 50005/50008 50010 50098"
local Transporte  `"`Urbano' `Gasolina_para_veiculo_proprio' `Alcool_para_veiculo_proprio'  `Manutencao_de_veiculo_proprio' `Aquisicao_de_veiculos' `Viagens' `Outros_transporte'"'
local Perfume  "30002"
local Produtos_para_cabelo  "30029 96004"
local Sabonete  "96003 96014 96019"
local Produtos_de_uso_pessoal  "30001 30003/30010 30013/30028 30030/30033 30098 96001/96002 96005/96009 96011/96013 96015/96018 96020"
local Higiene_e_cuidados_pessoais  `"`Perfume' `Produtos_para_cabelo' `Sabonete' `Produtos_de_uso_pessoal'"'
local Remedios  "29001/29050 29074 29084/29085 29088/29099 29101/29104 29106/29129 29131"
local Plano_Seguro_saude  "42014 42025 42031"
local Consulta_e_tratamento_dentario  "42003/42004 42037"
local Consulta_medica  "42038/42050"
local Tratamento_ambulatorial  "42010 42015 42020 42036 42051/42054"
local Servicos_de_cirurgia  "42005"
local Hospitalizacao  "42006"
local Exames_diversos  "42007/42009 42021 42030 42032/42033"
local Material_de_tratamento  "29051 29054/29060 29062/29067 29069/29073 29075/29078 29080/29083 29086/29087 29100 29130 29132 42011/42012 42023 42027/42028 42034"
local Outras_assistencia_saude  "29052/29053 29061 29068 29079 42002 42013 42016/42019 42022 42029 42098"
local Assistencia_a_saude  `"`Remedios' `Plano_Seguro_saude' `Consulta_e_tratamento_dentario' `Consulta_medica' `Tratamento_ambulatorial' `Servicos_de_cirurgia' `Hospitalizacao' `Exames_diversos' `Material_de_tratamento' `Outras_assistencia_saude'"'
local Cursos_regulares  "49001 49031/49032"
local Curso_superior  "49033"
local Outros_cursos  "49002 49011 49015 49022/49023 49034/49041 49043/49044 49047/49052 49057 49059"
local Livros_e_revistas_tecnicas  "49006/49008 49045"
local Artigos_escolares  "32001/32003 32009 32012/32015 32098 49019/49021 49025 49029"
local Outras_educacao  "48003 48013 48047 49003/49005 49009/49010 49012 49014 49016/49018 49024 49027/49028 49030 49042 49046 49053/49054 49058 49098"
local Educacao  `"`Cursos_regulares' `Curso_superior' `Outros_cursos' `Livros_e_revistas_tecnicas' `Artigos_escolares' `Outras_educacao'"'
local Brinquedos_e_jogos  "33001 33003/33005 33014 33016 33020"
local Celular_e_acessorios  "46051/46054"
local Periodicos_livros_e_revistas  "27001/27003 27006 32004/32005"
local Diversoes_e_esportes  "28001/28022 28025/28026 28028/28054 28056/28061 28098 33002 33007/33008 33017 49056"
local Outras_recreacao_etc  "16001 16005/16009 16011 16018 16043 16071 16078 16090 16099 16105/16106 16111 16116 27004/27005 27098 33006 33009/33013 33015 33018/33019 33021/33030 33098 37041/37042"
local Recreacao_e_cultura  `"`Brinquedos_e_jogos' `Celular_e_acessorios' `Periodicos_livros_e_revistas' `Diversoes_e_esportes' `Outras_recreacao_etc'"'
local Fumo  "25001 25003/25005 25007 25009/25019 25098 40060/40061 40071/40072"
local Cabeleireiro  "31001/31002 31043/31044 31048"
local Manicuro_e_pedicuro  "31003"
local Consertos_de_artigos_pessoais  "31004 31010 31013/31016 31018 31020/31024 31026/31027 31029/31031 31033 31040 31045/31046"
local Outras_servicos_pessoais  "31005/31009 31011/31012 31017 31019 31025 31028 31032 31034/31039 31041/31042 31047 31049/31051 31098"
local Servicos_pessoais  `"`Cabeleireiro' `Manicuro_e_pedicuro' `Consertos_de_artigos_pessoais' `Outras_servicos_pessoais'"'
local Jogos_e_apostas  "26001/26010 26012/26021 26031 26098"
local Comunicacao  "22001/22005 22098"
local Cerimonias_e_festas  "45001/45011 45013/45014 45098"
local Servicos_profissionais  "44001/44020"
local Imoveis_de_uso_ocasional  "47002/47004 47006/47008 47013 47096"
local Outras_despesas_diversas  "11081/11084 12004 12020 13001/13004 13006/13008 13010/13012 13015/13021 13098 16040 32006/32008 32010/32011 37007 37022 40002 40004/40007 40009 40011 40022/40023 40025/40026 40029/40031 40034/40036 40038 40042/40043 40049 40069 40075/40076 40098 44098 45012 95086 95091/95094 95099/95100"
local Despesas_diversas  `"`Jogos_e_apostas' `Comunicacao' `Cerimonias_e_festas' `Servicos_profissionais' `Imoveis_de_uso_ocasional' `Outras_despesas_diversas'"'
local Impostos  "10014 10020 10022/10024 47005 47011/47012 47014/47015 48038 48046 50001/50002 50004 50009 50013/50015 57001/57010 58001/58010"
local Contribuicoes_trabalhistas  "19501/19530 19548 48001 48018 48026 48039 56001/56010"
local Servicos_bancarios  "44051/44062"
local Pensoes_mesadas_e_doacoes  "48002 48004/48005 48021/48024 48040 48043 50011"
local Previdencia_privada  "48006 48033 48034"
local Outras_despesas  "48007/48008 48014 48017 48019 48025 48028/48032 48041 48048/48050 48098 59011/59014 59021/59022 59031/59033 59035/59042 59044 59046 59060 60001/60010 60012/60016 60023/60032 60034/60036 60038/60041 60043/60059 60091/60092 60097"
local Outras_despesas_correntes  `"`Impostos' `Contribuicoes_trabalhistas' `Servicos_bancarios' `Pensoes_mesadas_e_doacoes' `Previdencia_privada' `Outras_despesas'"'
local Imovel_aquisicao  "12001/12002 47001"
local Imovel_reforma  "11001/11017 11019/11059 11061/11062 11064 11067 11069/11071 11073 11080 11085/11093 11098"
local Outros_investimentos  "16039 16073 16098 16101 46009 47010 48020 48042"
local Aumento_do_ativo  `"`Imovel_aquisicao' `Imovel_reforma' `Outros_investimentos'"'
local Emprestimo_e_carne  "48011/48012 48015 48027"
local Prestacao_de_imovel  "10007 10017"
local Diminuicao_do_passivo  `"`Emprestimo_e_carne' `Prestacao_de_imovel'"'

* Rendimentos (REN)
local Empregado  "53001/53004 53031/53033 53042 53046 53060 53231/53233 53242 53246 53260 53332 53346 54001/54002 54045 54047 54201/54202 54245 54345"
local Empregador  "53006"
local Conta_propria  "53007"
local Rendimento_do_trabalho  `"`Empregado' `Empregador' `Conta_propria'"'
local Aposentadoria_prev_publica  "53011 53040 53044 54029 54445"
local Aposentadoria_prev_privada  "53012 54040 54057 54545"
local Bolsa_de_estudo  "53013"
local Pensao_aliment_mesada_doacao  "53014"
local Transferencias_transitorias  "53035/53039 53041 54005/54007 54012/54013 54023/54024 54026/54028 54032 54036 54038 54043"
local Transferencia  `"`Aposentadoria_prev_publica' `Aposentadoria_prev_privada' `Bolsa_de_estudo' `Pensao_aliment_mesada_doacao' `Transferencias_transitorias'"'
local Aluguel_de_bens_imoveis  "53021"
local Aluguel_de_bens_moveis  "53022"
local Rendimento_de_aluguel  `"`Aluguel_de_bens_imoveis' `Aluguel_de_bens_moveis'"'
local Vendas_esporadicas  "54008/54009 54016 54044 54048/54052 54091"
local Emprestimos  "54014 54025 54031"
local Aplicacoes_de_capital  "54015 54035 54046 55011/55014"	
local Outros_renda  "54003/54004 54010 54030 54034 54039 54041 54053/54056 54058/54059 54092 54097 55014"
local Outros_rendimentos `"`Vendas_esporadicas' `Empréstimos' `Aplicacoes_de_capital' `Outros_rendimentos'"'
local Rendimento_total `"`Rendimento_do_trabalho' `Tranferencia' `Rendimento_de_alguel' `Outros_renda'"'

foreach item in `sel'{
	if "`item'" == "Rendimento_nao_monetario" loc ren = 1
	else local codigos  `" `codigos' "``item''" "' /* Armazena o código de todos os itens selecionados.
												Por exemplo, se o item for Feijão, o código `Feijão' definido antes
												entra no local */
}

di as input "Itens selecionados:" _newline "`sel'"

/* Harmonização de variáveis e append */

tempfile gastos

forvalues i = 1/`: word count `trs''{
	local tr: word `i' of `trs'
	local base: word `i' of `temps'
	
	use `base', clear
	
	if "`tr'" == "tr9"{
		gen long cod_item_aux = int((100000*grupo + item)/100)
	}
	else if "`tr'" == "tr12"{
		gen long cod_item_aux = int((100000*quadro + pos_ocup*100)/100)
	}
	else{
		gen long cod_item_aux = int((100000*quadro + item)/100)
	}
	
	
	cap append using `gastos'
	save `gastos', replace
	
}

/* Algumas manipulações */

replace val_def_anual = rend_def_anual if tipo_reg==12 | tipo_reg==13

keep tipo_reg uf seq dv domcl uc ordem obtencao val_def_anual cod_item_aux

tempvar credito
gen credito = cond(obtencao==3 | obtencao==4,val_def_anual,0) if obtencao!=.

tempvar n_monet
gen n_monet = cond(obtencao>=5 & obtencao <= 9,val_def_anual,0) if obtencao!=.

save `gastos', replace	

local nomes "Despesa_com_alimentacao Alimentacao_no_dom Cereais_leguminosas_etc Arroz Feijao Outros_cereais_etc Farinhas_feculas_e_massas Macarrao Farinha_de_trigo Farinha_de_mandioca Outras_farinhas_etc Tuberculos_e_raizes Batata_inglesa Cenoura Outros_tuberculos Acucares_e_derivados Acucar_refinado Acucar_cristal Outros_acucares_etc Legumes_e_verduras Tomate Cebola Alface Outros_legumes_etc Frutas Banana Laranja Maca Outras_frutas Carnes_visceras_etc Carne_de_boi_de_primeira Carne_de_boi_de_segunda Carne_de_suino Carnes_e_peixes_ind Pescados_frescos Outros_carnes_etc Aves_e_ovos Frango Ovo_de_galinha Outros_aves_etc Leites_e_derivados Leite_de_vaca Leite_em_po Queijos Outros_leites_etc Panificados Pao_frances Biscoito Outros_panificados Oleos_e_gorduras Oleo_de_soja Azeite_de_oliva Outros_oleos_e_gorduras Bebidas_e_infusoes Cafe_moido Refrigerantes Cervejas_e_chopes Outras_bebidas_alcoolicas Outras_bebidas_etc Enlatados_e_conservas Sal_e_condimentos Massa_de_tomate Maionese Sal_refinado Outros_sal Alimentos_preparados Outros_alimentacao_no_dom Alimentacao_fora_do_dom Almoco_e_jantar Cafe_leite_chocolate Sanduiches_e_salgados Refri_e_outras_nao_alcoolicas Lanches Cervejas_e_outras_alcoolicas Outras_alimentacao_fora_do_dom Habitacao Aluguel Servicos_e_taxas Energia_eletrica Telefone_fixo Telefone_celular Gas_domestico Agua_e_esgoto Outros_servicos_etc Manutencao_do_lar Artigos_de_limpeza Mobiliarios_e_artigos_do_lar Eletrodomesticos Consertos_de_artigos_do_lar Vestuario Roupa_de_homem Roupa_de_mulher Roupa_de_crianca Calcados_e_apetrechos Joias_e_bijuterias Tecidos_e_armarinhos Transporte Urbano Gasolina_para_veiculo_proprio Alcool_para_veiculo_proprio Manutencao_de_veiculo_proprio Aquisicao_de_veiculos Viagens Outros_transporte Higiene_e_cuidados_pessoais Perfume Produtos_para_cabelo Sabonete Produtos_de_uso_pessoal Assistencia_a_saude Remedios Plano_Seguro_saude Consulta_e_tratamento_dentario Consulta_medica Tratamento_ambulatorial Servicos_de_cirurgia Hospitalizacao Exames_diversos Material_de_tratamento Outras_assistencia_saude Educacao Cursos_regulares Curso_superior Outros_cursos Livros_e_revistas_tecnicas Artigos_escolares Outras_educacao Recreacao_e_cultura Brinquedos_e_jogos Celular_e_acessorios Periodicos_livros_e_revistas Diversoes_e_esportes Outras_recreacao_etc Fumo Servicos_pessoais Cabeleireiro Manicuro_e_pedicuro Consertos_de_artigos_pessoais Outras_servicos_pessoais Despesas_diversas Jogos_e_apostas Comunicacao Cerimonias_e_festas Servicos_profissionais Imoveis_de_uso_ocasional Outras_despesas_diversas Outras_despesas_correntes Impostos Contribuicoes_trabalhistas Servicos_bancarios Pensoes_mesadas_e_doacoes Previdencia_privada Outras_despesas Aumento_do_ativo Imovel_aquisicao Imovel_reforma Outros_investimentos Diminuicao_do_passivo Emprestimo_e_carne Prestacao_de_imovel Rendimento_total Rendimento_do_trabalho Empregado Empregador Conta_propria Transferencia Aposentadoria_prev_publica Aposentadoria_prev_privada Bolsa_de_estudo Pensao_aliment_mesada_doacao Transferencias_transitorias Rendimento_de_aluguel Aluguel_de_bens_imoveis Aluguel_de_bens_moveis Outros_rendimentos Vendas_esporadicas Emprestimos Aplicacoes_de_capital Outros_renda Rendimento_nao_monetario"
local numeros "da0 da1 da11	da111 da112	da113 da12 da121 da122 da123 da124 da13	da131 da132	da133 da14 da141 da142 da143 da15 da151	da152 da153	da154 da16 da161 da162 da163 da164 da17	da171 da172	da173 da174	da175 da176	da18 da181 da182 da183 da19	da191 da192	da193 da194	da11 da1101	da1102 da1103 da111	da1111 da1112 da1113 da112 da1121 da1122 da1123 da1124 da1125 da1131 da114 da1141 da1142 da1143	da1144 da115 da116 da2 da21	da22 da23 da24 da25	da26 da27 dd2 dd21 dd22 dd221 dd222 dd223 dd224 dd225 dd226	dd23 dd24 dd25 dd26 dd27 dd3 dd31 dd32 dd33 dd34 dd35 dd36 dd4 dd41 dd42 dd43 dd44 dd45	dd46 dd47 dd5 dd51 dd52	dd53 dd54 dd6 dd61 dd62	dd63 dd64 dd65 dd66	dd67 dd68 dd69 dd61	dd7	dd71 dd72 dd73 dd74	dd75 dd76 dd8 dd81 dd82 dd83 dd84 dd85 dd9 dd10	dd101 dd102	dd103 dd104	dd11 dd111 dd112 dd113 dd114 dd115 dd116 dd12 dd121	dd122 dd123	dd124 dd125	dd126 dd13 dd131 dd132 dd133 dd14 dd141	dd142 re0 re1 re11 re12	re13 re2 re21 re22 re23	re24 re25 re3 re31 re32 re4	re41 re42 re43 re44"

if "`id'" == "dom" {
	loc variaveis_ID = "uf seq dv domcl"
	loc TR_prin = "1"
	loc base_prin "T_DOMICILIO.txt"
	drop uc ordem
}
else if "`id'" == "uc" {
	loc variaveis_ID = "uf seq dv domcl uc"
	loc TR_prin = "3"
	loc base_prin "T_MORADOR.txt"
	drop ordem
	keep if tipo_reg>=2 & uc!=.
}
else if "`id'" == "pess" {
	loc variaveis_ID = "uf seq dv domcl uc ordem"
	loc TR_prin = "2"
	loc base_prin "T_MORADOR.txt"
	keep if tipo_reg>=10 & tipo_reg<=14 & ordem!=.
}

local iteracao = 1

di as input "Agregando as despesas"

forvalues i = 1/`: word count `sel''{
	local item: word `i' of `sel'
	local codigo: word `i' of `codigos'
	
	if "`codigo'" == "" continue
	
	forvalues j = 1/`: word count `nomes''{
		local nome: word `j' of `nomes'
		local numero: word `j' of `numeros'
		
		if "`item'" == "`nome'" & "`numero'" != ""{
		
			if "`item'"=="Rendimento_nao_monetario" {

				preserve
				
				replace n_monet = . if cod_item_aux==10090
				
				tempvar n_monet2
				g `n_monet2' = val_def_anual if cod_item_aux==10090
				foreach n of numlist 8001/8017 8019/8071 8084/8098 10014 10020 ///
						10023 10024 12005/12015 12017/12025 12096 {
					replace `n_monet2' = - val_def_anual if cod_item_aux==`n'	/* rendimento não monetario 2 */
				}

				collapse (sum) n_monet `n_monet2', by(`variaveis_ID')

				foreach var in n_monet `n_monet2' {
					replace `var' = . if `var'<0		/* para nao haver renda nao monetaria negativa*/
				}

				egen rnm = rowtotal(n_monet `n_monet2')
				lab var rnm "renda não monetária"
				keep `variaveis_ID' rnm

				tempfile item`iteracao'
				sort `variaveis_ID'
				save `item`iteracao'', replace

				restore
				
				loc iteracao = `iteracao' + 1
			}
			else{
				preserve
				g item = .
				foreach n of numlist `codigo' {
					replace item = 1 if cod_item_aux == `n'
				}
				keep if item==1
				cap collapse (sum) val_def_anual credito n_monet, by(`variaveis_ID')
				if _rc==2000 {
					restore
					continue, break
				}
				rename val_def_anual v`numero'
				rename credito cr`numero' 
				rename n_monet nm`numero' 
				
				if substr("`numero'",1,1)=="d" {
					lab var v`numero' "despesa total em `nome'"
					lab var cr`numero' "`nome' - despesa a credito"
					lab var nm`numero' "`nome' - despesa não monetária"
				}
				else {
					lab var v`numero' "rendimento de `nome'"
					drop cr* nm*
				}
				
				tempfile item`iteracao'
				sort `variaveis_ID'
				save `item`iteracao'', replace
				
				restore

				loc iteracao = `iteracao' + 1
			}
		}
	}	
}	

if `TR_prin'==1 {

	tempfile base_dom
	
	load_pof02, trs(tr1) temps(`base_dom') original(`original') `english'
	
	sort `variaveis_ID'
	loc iteracao = `iteracao' - 1
	forval j = 1/`iteracao' {
		sort `variaveis_ID'
		merge 1:1 `variaveis_ID' using `item`j'', nogen keep(match master)
	}
	egen id_`id'= group(`variaveis_ID')
}
else {
	tempfile base_pes
	
	load_pof02, trs(tr2) temps(`base_pes') original(`original') `english'
	egen id_dom = group(uf seq dv domcl)
	egen id_uc  = group(uf seq dv domcl uc)

	if `TR_prin'==3 {
		bys uf seq dv domcl uc: keep if _n==1
		keep uf seq dv domcl uc id_dom id_uc estrato fator_set fator renda
		loc iteracao = `iteracao' - 1
		forval j = 1/`iteracao' {
			merge 1:1 uf seq dv domcl uc using `item`j'', nogen keep(match master)
		}
	}
	else {
		loc iteracao = `iteracao' - 1
		forval j = 1/`iteracao' {
			merge 1:1 uf seq dv domcl uc ordem using `item`j'', nogen keep(match master)
		}
	}
}
g urbano = 1 if estrato<=9 & uf==11
replace urbano = 1 if estrato<=8 & uf==12
replace urbano = 1 if estrato<=10 & uf==13
replace urbano = 1 if estrato<=6 & uf==14
replace urbano = 1 if estrato<=14 & uf==15
replace urbano = 1 if estrato<=8 & uf==16
replace urbano = 1 if estrato<=10 & uf==17
replace urbano = 1 if estrato<=10 & uf==21
replace urbano = 1 if estrato<=10 & uf==22
replace urbano = 1 if estrato<=15 & uf==23
replace urbano = 1 if estrato<=10 & uf==24
replace urbano = 1 if estrato<=10 & uf==25
replace urbano = 1 if estrato<=15 & uf==26
replace urbano = 1 if estrato<=10 & uf==27
replace urbano = 1 if estrato<=9 & uf==28
replace urbano = 1 if estrato<=15 & uf==29
replace urbano = 1 if estrato<=14 & uf==31
replace urbano = 1 if estrato<=10 & uf==32
replace urbano = 1 if estrato<=25 & uf==33
replace urbano = 1 if estrato<=25 & uf==35
replace urbano = 1 if estrato<=15 & uf==41
replace urbano = 1 if estrato<=10 & uf==42
replace urbano = 1 if estrato<=15 & uf==43
replace urbano = 1 if estrato<=10 & uf==50
replace urbano = 1 if estrato<=10 & uf==51
replace urbano = 1 if estrato<=10 & uf==52
replace urbano = 1 if estrato<=10 & uf==53
replace urbano = 0 if urbano==.
lab var urbano "1 area urbana; 0 area rural"

end

program pofstd_02
syntax, id(string) trs(string) temps(string) original(string) [english]

* Alimentação no domicílio (DAD)
local Arroz  "63001/63003 63005 63033 63037"
local Feijao  "63012/63017 63019 63021/63026 63031"
local Outros_cereais_etc "63004 63006/63011 63027/63030 63032 63034 64051/64066 64068/64072 64074/64075 64078"
local Cereais_leguminosas_etc  `" `Arroz' `Feijao' `Outros_cereais_etc'"'
local Macarrao  "64032/64034"
local Farinha_de_trigo   "64010"
local Farinha_de_mandioca   "64014"
local Outras_farinhas_etc  "64001/64009 64011/64013 64015/64024 64026/64031 64035/64037 64042/64044"
local Farinhas_feculas_e_massas  `" `Macarrao' `Farinha_de_trigo' `Farinha_de_mandioca' `Outras_farinhas_etc'"'
local Batata_inglesa   "63051"
local Cenoura   "63062"
local Outros_tuberculos_etc  "63052/63057 63059/63061 63063/63068"
local Tuberculos_e_raizes  `" `Batata_inglesa' `Cenoura' `Outros_tuberculos_etc'"'
local Acucar_refinado   "67001"
local Acucar_cristal   "67002"
local Outros_acucares_etc  "67003/67056 67058/67063 67066/67077 67079"
local Acucares_e_derivados  `" `Acucar_refinado' `Acucar_cristal' `Outros_acucares_etc'"'  
local Tomate   "65051"
local Cebola   "65057"
local Alface   "65001"
local Outros_legumes_etc  "65002/65028 65030/65050 65052/65056 65058/65076"
local Legumes_e_verduras  `" `Tomate' `Cebola' `Alface' `Outros_legumes_etc'"'
local Banana  "66001/66011"
local Laranja  "66012/66015 66017/66018"
local Maca   "66030"
local Outras_frutas  "66019/66029 66031/66053 66055/66076 66086/66094"
local Frutas  `"`Banana' `Laranja' `Maca' `Outras_frutas'"'
local Carne_de_boi_de_primeira  "69001/69007 69014 69016 69099 69103 69126"
local Carne_de_boi_de_segunda  "69008/69013 69015 69017 69026 69108 69110 69112"
local Carne_de_suino  "69033/69037 69104/69106 69109 69124/69125 69134"
local Carnes_e_peixes_ind  "70004/70005 70014/70015 70024/70025 70034/70035 70044 70045 70054/70055 70064/70065 70074/70075 70084/70085 70094/70095 71004/71005 71014/71016 71024/71025 71034/71035 71044/71045 71054/71055 71064/71065 71084/71085 71094/71095 72004/72005 72014/72015 72024/72025 72034/72035 72044/72045 72054/72055 72064/72065 72074 72075 72084/72085 72094/72095 73004/73005 73014/73015 73024/73025 73034/73035 73044/73045 73054/73055 73064/73065 73084/73085 73094/73095 74004/74005 74014/74015 74024/74025 74034/74035 74044/74045 74054/74055 74064/74065 74074/74075 74084/74085 74094/74095 75004/75005 75034/75035 75044/75045 75054/75055 75074/75075 75084/75085 75094/75095 76004/76005 76014/76015 76024/76025 76044/76045 76054/76055 76064 76074 76084 76094 77004 77024 77034 77044 77054/77055 77064 77074/77075 77094/77095 78004 78024 78034/78035 80004/80005 80014/80015 80024/80025 80034/80035 80044/80045 80054/80055 80064/80065 80074/80075 80084/80085 80094/80095 81004/81005 81014/81015 81024/81025 81034/81035 81044/81045 81054/81055 81064/81065 81074/81075 81084/81085 81094/81095 82004/82005 82014/82015 82024/82025 82034/82035 82044/82045 82054/82055 82064/82065 82074/82075 82084/82085 82094/82095 83004/83005 83014/83015 83024/83025 83034/83035 83044/83045 83054/83055 83064/83065 83074/83075 83084/83085 83094/83095 84004/84005 84014/84015 84024/84025 84034 84044/84045 84054/84055 84064/84065 84074/84075 84084/84085 84094/84095 85004 85014/85015 89994/89995 91029 91031 91098 91101 92051/92060 92062/92079 92082/92085 92089 92091/92093 92095 92097/92098 92105 92108 92110/92112"
local Pescados_frescos  "70001/70003 70011/70013 70021/70023 70031/70033 70039 70041/70043 70049 70051/70053 70061/70063 70071/70073 70081/70083 70091/70093 71001/71003 71011/71013 71021/71023 71031/71033 71041/71043 71049  71051/71053 71061/71063 71069 71081/71083 71091/71093 72001/72003 72011/72013 72021/72023 72031/72033 72041/72043 72051/72053 72059 72061/72063 72071/72073 72081/72083 72089 72091/72093 73001/73003 73011/73013 73021/73023 73031/73033 73041/73043 73051/73053 73061/73063 73081/73083 73091/73093 74001/74003 74011/74013 74019 74021/74023 74031/74033 74041/74043 74051/74053 74061/74063 74071/74073 74081/74083 74091/74093 75001/75003 75031/75033 75041/75043 75051/75053 75071/75073 75081/75083 75091/75093 76001/76003 76014/76013 76021/76023 76041/76043 76051/76053 76056/76057 76061/76062 76071/76072 76081/76082 76091/76092 77001/77002 77011 77021/77022 77031/77033 77041/77042 77051/77053 77071/77073 77091/77093 78001 78021/78022 78031/78033 78041 78051 78061 78071 78082 80001/80003 80011/80013 80021/80023 80031/80033 80041/80043 80049 80051/80053 80061/80063 80071/80073 80081/80083 80091/80093 81001/81003 81009 81011/81013 81021/81023 81031/81033 81041/81043 81051/81053 81061/81063 81071/81073 81081/81083 81091/81093 82001/82003 82011/82013 82021/82023 82029 82031/82033 82041/82043 82051/82053 82061/82063 82071/82073 82076 82081/82083 82091/82093 83001/83003 83011/83013 83021/83023 83029 83031/83033 83041/83043 83049 83051/83053 83061/83063 83071/83073 83081/83083 83091/83093 84001/84003 84011/84013 84021/84023 84031/84032 84041/84043 84051/84053 84061/84063 84071/84073 84081/84083 84091/84093 85001/85002 85011/85013 85019 85021 85031 85041 85051 85061 85071 85081 85091 85101 85111 89991/89993 89999"
local Outros_carnes_etc  "69018/69025 69027/69032 69038/69058 69067 69069/69098 69100/69102 69107 69111 69113/69123 69127/69133"
local Carnes_visceras_etc  `"`Carne_de_boi_de_primeira' `Carne_de_boi_de_segunda' `Carne_de_suino' `Carnes_e_peixes_ind' `Pescados_frescos' `Outros_carnes_etc'"'
local Frango  "91001/91014 91025/91027 91032 91036 91038 91047/91048"
local Ovo_de_galinha   "91033"
local Outros_aves_etc  "91015/91024 91028 91030 91034/91035 91037 91039/91046 91049/91050 91090 91097 91099 91100"
local Aves_e_ovos  `" `Frango' `Ovo_de_galinha' `Outros_aves_etc'"'
local Leite_de_vaca  "91051/91052"
local Leite_em_po  "91056/91058"
local Queijos  "91067/91070 91072 91074/91080 91086/91087 91096"
local Outros_leites_etc  "91053/91055 91059/91066 91082 91085 91088/91089"
local Leites_e_derivados `"`Leite_de_vaca' `Leite_em_po' `Queijos' `Outros_leites_etc'"'
local Pao_frances   "92001"
local Biscoito  "92022/92024 92048/92049 92080/92081"
local Outros_panificados  "92002/92021 92025/92047 92050 92061 92086/92088 92090 92099/92104 92106/92107 92109"
local Panificados  `"`Pao_frances' `Biscoito' `Outros_panificados'"'
local Oleo_de_soja   "94003"
local Azeite_de_oliva   "94001"
local Outros_oleos_etc  "94002 94004/94038"
local Oleos_e_gorduras  `"`Oleo_de_soja' `Azeite_de_oliva' `Outros_oleos_etc'"'
local Cafe_moido   "93025"
local Refrigerantes  "93001/93006 93009/93014 93017/93019 93035 93041/93043 93046 93049 93054/93055 93057/93058 93067/93073"
local Cervejas_e_chopes  "96051/96052"
local Outras_bebidas_alcoolicas  "96053/96082"
local Outras_bebidas_etc  "64067 64073 64077 67057 67064/67065 67078 93020/93024 93026/93034 93036/93039 93044/93045 93047/93048 93050/93053 93056 93059/93065 96083"
local Bebidas_e_infusoes  `"`Cafe_moido' `Refrigerantes' `Cervejas_e_chopes' `Outras_bebidas_alcoolicas' `Outras_bebidas_etc'"'
local Enlatados_e_conservas  "90001/90061"
local Massa_de_tomate   "68047"
local Maionese   "68043"
local Sal_refinado   "68001"
local Outros_sal  "68002/68039 68041/68042 68044/68046 68048/68055 68057/68063 68065/68093"
local Sal_e_condimentos  `"`Massa_de_tomate' `Maionese'  `Sal_refinado' `Outros_sal'"'
local Alimentos_preparados  "93040 94051/94065 94067/94069 94071/94074 94076/94082 94084/94105"
local Outros_alimentacao_no_dom  "99090/99098"
local listaDAD `"Cereais_leguminosas_etc "`Cereais_leguminosas_etc'" Farinhas_feculas_e_massas "`Farinhas_feculas_e_massas'" Tuberculos_e_raizes "`Tuberculos_e_raizes'" Acucares_e_derivados "`Acucares_e_derivados'" Legumes_e_verduras "`Legumes_e_verduras'" Frutas "`Frutas'" Carnes_visceras_etc "`Carnes_visceras_etc'" Aves_e_ovos "`Aves_e_ovos'" Leites_e_derivados "`Leites_e_derivados'" Panificados "`Panificados'" Oleos_e_gorduras "`Oleos_e_gorduras'" Bebidas_e_infusoes "`Bebidas_e_infusoes'" Enlatados_e_conservas "`Enlatados_e_conservas'" Sal_e_condimentos "`Sal_e_condimentos'" Alimentos_preparados "`Alimentos_preparados'" Outros_alimentacao_no_dom "`Outros_alimentacao_no_dom'""'

* Alimentação fora do domicílio (DAF)
local Almoco_e_jantar  "24001 24041/24042 24051/24052 24055 48044"
local Cafe_leite_chocolate  "24002 24005"
local Sanduiches_e_salgados  "24004 24043"
local Refri_e_outras_nao_alcoolicas  "24006/24007 24013 24020/24022 24028/24029 24031/24033 24036 24039/24040 24044/24049 24059/24060"
local Lanches  "24037 24053/24054 24056/24057 41006 49026"
local Cervejas_e_outras_alcoolicas  "24009/24012"
local Outras_alimentacao_fora_do_dom  "24003 24008 24014/24019 24023/24027 24030 24034/24035 24038 24050 24058 24061 24096/24098"
local listaDAF `"Almoco_e_jantar "`Almoco_e_jantar'" Cafe_leite_chocolate "`Cafe_leite_chocolate'" Sanduiches_e_salgados "`Sanduiches_e_salgados'" Refri_e_outras_nao_alcoolicas "`Refri_e_outras_nao_alcoolicas'" Lanches "`Lanches'" Cervejas_e_outras_alcoolicas "`Cervejas_e_outras_alcoolicas'"  Outras_alimentacao_fora_do_dom "`Outras_alimentacao_fora_do_dom'""'

* Despesas diversas (DDI)
* Habitacao 
local Aluguel  "10005 10010 10016 10018 10090"
local Energia_eletrica  "7002"
local Telefone_fixo  "7004"
local Telefone_celular  "28055"
local Gas_domestico  "7003 7005"
local Água_e_esgoto  "7001"
local Outros_servicos_etc  "7016/7017 10012 10019 12003 12005/12015 12017/12019 12021/12025 12026 12096"
local Servicos_e_taxas  `"`Energia_eletrica' `Telefone_fixo' `Telefone_celular' `Gas_domestico' `Agua_e_esgoto' `Outros_servicos_etc'"'
local Manutencao_do_lar  "7006/7012 7018/7020 7098 8001/8053 8055/8057 8059 8061/8062 8064 8067 8069/8071 8073 8080/8085 8098 19001/19030 19048 95057 95106"
local Artigos_de_limpeza  "95001/95008 95011 95014/95027 95030/95034 95042 95045 95056 95058 95060/95061 95063/95066 95069/95071 95073 95075 95077 95101/95103"
local Mobiliarios_e_artigos_do_lar  "16019 16021/16030 16035/16036 16041/16042 16044/16045 16047 16062 16070 16082 16089 16103/16104 16112 17001/17018 17020/17027 17029/17037 17040/17046 17060/17067 17069 17072 17074/17078 17080/17118 18001/18003 18005 18050/18098 37003/37006 37010/37013 37016 37020 37023/37024 37031/37033 37038/37040 37043 37045/37047 39001/39010 39012/39020 39022/39026 39028 39030/39044 39046/39105 40032 40037 40050 40068 40073 95009/95010 95012/95013 95028/95029 95035/95044 95046/95055 95059 95062 95067/95068 95072 95074 95076 95078/95085 95104/95105 95107/95108"
local Eletrodomesticos  "15001/15062 15064/15072 15074/15078 15080/15094 15096/15128 16014/16017 16031/16034 16037/16038 16048/16050 16052 16057 16060/16061 16063 16065 16069 16076 16093 16096/16097 16100 16102 16107/16110 16113/16115 30034 40067"
local Consertos_de_artigos_do_lar  "9001/9003 9006/9010 9012 9015 9020/9086 9098 39011 39045"

* Vestuario  
local Roupa_de_homem  "34001/34039 34098"
local Roupa_de_mulher  "35001/35060 35098"
local Roupa_de_crianca  "36001/36053 36098"
local Calcados_e_apetrechos  "38001/38030 38032/38049 38098"
local Joias_e_bijuterias  "40001 40074 46001/46008 46010/46011 46098"
local Tecidos_e_armarinhos  "37001/37002 37008 37014/37015 37017/37019 37021 37025/37030 37034/37037 37044 37098"

* Transporte  
local Urbano  "23001/23005 23010/23011 23014/23016 23020/23027 23029/23030 23032/23034 23098 48045"
local Gasolina_para_veiculo_proprio  "23007 23028"
local Alcool_para_veiculo_proprio  "23006"
local Manutencao_de_veiculo_proprio  "23019 43001/43008 43012 43014/43018 43020/43023 43026 43030/43032"
local Aquisicao_de_veiculos  "50012 51001/51014 51020/51025 51098"
local Viagens  "23031 41001/41005 41007/41026 41098"
local Outros_transporte  "23008/23009 23012/23013 23017/23018 43009/43011 43013 43019 43024/43025 43027/43029 43033/43037 43098 50003 50005/50008 50010 50098"

* Higiene_e_cuidados_pessoais  
local Perfume  "30002"
local Produtos_para_cabelo  "30029 96004"
local Sabonete  "96003 96014 96019"
local Produtos_de_uso_pessoal  "30001 30003/30010 30013/30028 30030/30033 30098 96001/96002 96005/96009 96011/96013 96015/96018 96020"

* Assistencia_a_saude  
local Remedios  "29001/29050 29074 29084/29085 29088/29099 29101/29104 29106/29129 29131"
local Plano_seguro_saude  "42014 42025 42031"
local Consulta_e_tratamento_dentario  "42003/42004 42037"
local Consulta_medica  "42038/42050"
local Tratamento_ambulatorial  "42010 42015 42020 42036 42051/42054"
local Servicos_de_cirurgia  "42005"
local Hospitalizacao  "42006"
local Exames_diversos  "42007/42009 42021 42030 42032/42033"
local Material_de_tratamento  "29051 29054/29060 29062/29067 29069/29073 29075/29078 29080/29083 29086/29087 29100 29130 29132 42011/42012 42023 42027/42028 42034"
local Outras_assistencia_saude  "29052/29053 29061 29068 29079 42002 42013 42016/42019 42022 42029 42098"

* Educacao  
local Cursos_regulares  "49001 49031/49032"
local Curso_superior  "49033"
local Outros_cursos  "49002 49011 49015 49022/49023 49034/49041 49043/49044 49047/49052 49057 49059"
local Livros_e_revistas_tecnicas  "49006/49008 49045"
local Artigos_escolares  "32001/32003 32009 32012/32015 32098 49019/49021 49025 49029"
local Outras_educacao  "48003 48013 48047 49003/49005 49009/49010 49012 49014 49016/49018 49024 49027/49028 49030 49042 49046 49053/49054 49058 49098"

* Recreacao_e_cultura  
local Brinquedos_e_jogos  "33001 33003/33005 33014 33016 33020"
local Celular_e_acessorios  "46051/46054"
local Periodicos_livros_e_revistas  "27001/27003 27006 32004/32005"
local Diversoes_e_esportes  "28001/28022 28025/28026 28028/28054 28056/28061 28098 33002 33007/33008 33017 49056"
local Outras_recreacao_etc  "16001 16005/16009 16011 16018 16043 16071 16078 16090 16099 16105/16106 16111 16116 27004/27005 27098 33006 33009/33013 33015 33018/33019 33021/33030 33098 37041/37042"

* Servicos_pessoais  
local Fumo  "25001 25003/25005 25007 25009/25019 25098 40060/40061 40071/40072"
local Cabeleireiro  "31001/31002 31043/31044 31048"
local Manicuro_e_pedicuro  "31003"
local Consertos_de_artigos_pessoais  "31004 31010 31013/31016 31018 31020/31024 31026/31027 31029/31031 31033 31040 31045/31046"
local Outras_servicos_pessoais  "31005/31009 31011/31012 31017 31019 31025 31028 31032 31034/31039 31041/31042 31047 31049/31051 31098"

* Despesas_diversas  
local Jogos_e_apostas  "26001/26010 26012/26021 26031 26098"
local Comunicacao  "22001/22005 22098"
local Cerimonias_e_festas  "45001/45011 45013/45014 45098"
local Servicos_profissionais  "44001/44020"
local Imoveis_de_uso_ocasional  "47002/47004 47006/47008 47013 47096"
local Outras_despesas_diversas  "11081/11084 12004 12020 13001/13004 13006/13008 13010/13012 13015/13021 13098 16040 32006/32008 32010/32011 37007 37022 40002 40004/40007 40009 40011 40022/40023 40025/40026 40029/40031 40034/40036 40038 40042/40043 40049 40069 40075/40076 40098 44098 45012 95086 95091/95094 95099/95100"

* Outras_despesas_correntes  
local Impostos  "10014 10020 10022/10024 47005 47011/47012 47014/47015 48038 48046 50001/50002 50004 50009 50013/50015 57001/57010 58001/58010"
local Contribuicoes_trabalhistas  "19501/19530 19548 48001 48018 48026 48039 56001/56010"
local Servicos_bancarios  "44051/44062"
local Pensoes_mesadas_e_doacoes  "48002 48004/48005 48021/48024 48040 48043 50011"
local Previdencia_privada  "48006 48033 48034"
local Outras_despesas  "48007/48008 48014 48017 48019 48025 48028/48032 48041 48048/48050 48098 59011/59014 59021/59022 59031/59033 59035/59042 59044 59046 59060 60001/60010 60012/60016 60023/60032 60034/60036 60038/60041 60043/60059 60091/60092 60097"

* Aumento_do_ativo  
local Imovel_aquisicao  "12001/12002 47001"
local Imovel_reforma  "11001/11017 11019/11059 11061/11062 11064 11067 11069/11071 11073 11080 11085/11093 11098"
local Outros_investimentos  "16039 16073 16098 16101 46009 47010 48020 48042"

* Diminuicao_do_passivo  
local Emprestimo_e_carne  "48011/48012 48015 48027"
local Prestacao_de_imovel  "10007 10017"

local listaDDI `"Aluguel "`Aluguel'" Servicos_e_taxas "`Servicos_e_taxas'" Manutencao_do_lar "`Manutencao_do_lar'" Artigos_de_limpeza "`Artigos_de_limpeza'" Mobiliarios_e_artigos_do_lar "`Mobiliarios_e_artigos_do_lar'" Eletrodomesticos "`Eletrodomesticos'" Consertos_de_artigos_do_lar "`Consertos_de_artigos_do_lar'" Roupa_de_homem "`Roupa_de_homem'" Roupa_de_mulher "`Roupa_de_mulher'" Roupa_de_crianca "`Roupa_de_crianca'" Calcados_e_apetrechos "`Calcados_e_apetrechos'" Joias_e_bijuterias "`Joias_e_bijuterias'" Tecidos_e_armarinhos "`Tecidos_e_armarinhos'" Urbano "`Urbano'" Gasolina_para_veiculo_proprio "`Gasolina_para_veiculo_proprio'" Alcool_para_veiculo_proprio "`Alcool_para_veiculo_proprio'"  Manutencao_de_veiculo_proprio "`Manutencao_de_veiculo_proprio'" Aquisicao_de_veiculos "`Aquisicao_de_veiculos'" Viagens "`Viagens'" Outros_transporte "`Outros_transporte'" Perfume "`Perfume'" Produtos_para_cabelo "`Produtos_para_cabelo'" Sabonete "`Sabonete'" Produtos_de_uso_pessoal "`Produtos_de_uso_pessoal'" Remedios "`Remedios'" Plano_seguro_saude "`Plano_seguro_saude'" Consulta_e_tratamento_dentario "`Consulta_e_tratamento_dentario'" Consulta_medica "`Consulta_medica'" Tratamento_ambulatorial "`Tratamento_ambulatorial'" Servicos_de_cirurgia "`Servicos_de_cirurgia'" Hospitalizacao "`Hospitalizacao'" Exames_diversos "`Exames_diversos'" Material_de_tratamento "`Material_de_tratamento'" Outras_assistencia_saude "`Outras_assistencia_saude'" Cursos_regulares "`Cursos_regulares'" Curso_superior "`Curso_superior'" Outros_cursos "`Outros_cursos'" Livros_e_revistas_tecnicas "`Livros_e_revistas_tecnicas'" Artigos_escolares "`Artigos_escolares'" Outras_educacao "`Outras_educacao'" Brinquedos_e_jogos "`Brinquedos_e_jogos'" Celular_e_acessorios "`Celular_e_acessorios'" Periodicos_livros_e_revistas "`Periodicos_livros_e_revistas'" Diversoes_e_esportes "`Diversoes_e_esportes'" Outras_recreacao_etc "`Outras_recreacao_etc'" Fumo "`Fumo'" Cabeleireiro "`Cabeleireiro'" Manicuro_e_pedicuro "`Manicuro_e_pedicuro'" Consertos_de_artigos_pessoais "`Consertos_de_artigos_pessoais'" Outras_servicos_pessoais "`Outras_servicos_pessoais'" Jogos_e_apostas "`Jogos_e_apostas'" Comunicacao "`Comunicacao'" Cerimonias_e_festas "`Cerimonias_e_festas'" Servicos_profissionais "`Servicos_profissionais'" Imoveis_de_uso_ocasional "`Imoveis_de_uso_ocasional'" Outras_despesas_diversas "`Outras_despesas_diversas'" Impostos "`Impostos'" Contribuicoes_trabalhistas "`Contribuicoes_trabalhistas'" Servicos_bancarios "`Servicos_bancarios'" Pensoes_mesadas_e_doacoes "`Pensoes_mesadas_e_doacoes'" Previdencia_privada "`Previdencia_privada'" Outras_despesas "`Outras_despesas'" Imovel_aquisicao "`Imovel_aquisicao'" Imovel_reforma "`Imovel_reforma'" Outros_investimentos "`Outros_investimentos'" Emprestimo_e_carne "`Emprestimo_e_carne'" Prestacao_de_imovel "`Prestacao_de_imovel'""'

* Rendimentos (REN)
* Rendimento_do_trabalho  
local Empregado  "53001/53004 53031/53033 53042 53046 53060 53231/53233 53242 53246 53260 53332 53346 54001/54002 54045 54047 54201/54202 54245 54345"
local Empregador  "53006"
local Conta_propria  "53007"

* Transferencia  
local Aposentadoria_prev_publica  "53011 53040 53044 54029 54445"
local Aposentadoria_prev_privada  "53012 54040 54057 54545"
local Bolsa_de_estudo  "53013"
local Pensao_aliment_mesada_doacao  "53014"
local Transferencias_transitorias  "53035/53039 53041 54005/54007 54012/54013 54023/54024 54026/54028 54032 54036 54038 54043"

local Aluguel_de_bens_imoveis  "53021"
local Aluguel_de_bens_moveis  "53022"
local Rendimento_de_aluguel  `"`Aluguel_de_bens_imoveis' `Aluguel_de_bens_moveis'"'
local Vendas_esporadicas  "54008/54009 54016 54044 54048/54052 54091"
local Empréstimos  "54014 54025 54031"
local Aplicacoes_de_capital  "54015 54035 54046"	
local Outros_renda  "54003/54004 54010 54030 54034 54039 54041 54053/54056 54058/54059 54092 54097 55014"
local Outros_rendimentos `"`Vendas_esporadicas' `Empréstimos' `Aplicacoes_de_capital' `Outros_renda'"'

local listaREN `" Empregado "`Empregado'" Empregador "`Empregador'" Conta_propria  "`Conta_propria'" Aposentadoria_prev_publica "`Aposentadoria_prev_publica'" Aposentadoria_prev_privada "`Aposentadoria_prev_privada'" Bolsa_de_estudo "`Bolsa_de_estudo'" Pensao_aliment_mesada_doacao "`Pensao_aliment_mesada_doacao'" Transferencias_transitorias "`Transferencias_transitorias'" Rendimento_de_aluguel "`Rendimento_de_aluguel'" Outros_rendimentos "`Outros_rendimentos'""'
local Rendimento_nao_monetario

/* Harmonização de variáveis e append */

tempfile gastos

forvalues i = 1/`: word count `trs''{
	local tr: word `i' of `trs'
	local base: word `i' of `temps'
	
	use `base', clear
	
	if "`tr'" == "tr9"{
		gen long cod_item_aux = int((100000*grupo + item)/100)
	}
	else if "`tr'" == "tr12"{
		gen long cod_item_aux = int((100000*quadro + pos_ocup*100)/100)
	}
	else{
		gen long cod_item_aux = int((100000*quadro + item)/100)
	}
	
	
	cap append using `gastos'
	save `gastos', replace
	
}

replace val_def_anual = rend_def_anual if tipo_reg==12 | tipo_reg==13

keep tipo_reg uf seq dv domcl uc ordem obtencao val_def_anual cod_item_aux

g str itens = ""

foreach j in DAD DAF DDI REN {
	loc lista : copy local lista`j'
	
	if "`j'" == "DAD" | "`j'" == "DAF" {
		loc i = 1
		qui while `"`lista'"' ~="" {
			gettoken k lista: lista		/* para pular os nomes*/
			noi di "`k'"
			gettoken x lista: lista 	/* pega a lista de itens */
			foreach n of numlist `x' {
				if "`j'" == "DAD" {
					if `i'<10 replace itens = "da0`i'" if cod_item_aux == `n'
					else replace itens = "da`i'" if cod_item_aux == `n'
				}
				else {
					replace itens = "da2`i'" if cod_item_aux == `n'
				}
			}
			loc i = `i' + 1
		}
	}
	else if "`j'"=="DDI" {
		local k `""21/27" "31/36" "41/47" "51/54" "61/69 610" "71/76" "81/85" "90" "101/104" "111/116" "121/126" "131/133" "141/142""'
		tokenize `"`k'"'

		while `"`lista'"' ~="" {
			qui foreach i of numlist `1' {
				gettoken k lista: lista		/* para pular os nomes*/
				noi di "`k'"
				gettoken x lista: lista 	/* pega a lista de itens */
				foreach n of numlist `x' {
					if `i'<100 replace itens = "dd0`i'" if cod_item_aux == `n'
					else replace itens = "dd`i'" if cod_item_aux == `n'
				}
			}
			macro shift
		}
*		}
	}
	else {
		local z `""11/13" "21/25" 30 40"'
		tokenize `"`z'"'
		while `"`lista'"' ~="" {
			qui foreach ren of numlist `1' {
				gettoken k lista: lista		/* para pular os nomes*/
				noi di "`k'"
				gettoken x lista: lista 	/* pega a lista de itens */
				foreach n of numlist `x' {
					replace itens = "re`ren'" if cod_item_aux == `n'
				}
			}
			macro shift
		}
	}
}
tempfile gastos
save `gastos', replace

if "`id'" == "dom" {
	loc variaveis_ID = "uf seq dv domcl"
	loc TR_prin = "1"
}
else if "`id'" == "uc" {
	loc variaveis_ID = "uf seq dv domcl uc"
	loc TR_prin = "3"
}
else if "`id'" == "pess" {
	loc variaveis_ID = "uf seq dv domcl uc ordem"
	loc TR_prin = "2"
	keep if tipo_reg>=10 & tipo_reg<=14 & ordem~=.
}

save `gastos', replace

di "`variaveis_ID'"

egen id_`id' = group(`variaveis_ID')

tempvar credit
g `credit' = cond(obtencao>=3  & obtencao<=4, val_def_anual,0) if obtencao~=0 		/* itens comprados a prazo */
g vre51 = cond(obtencao>=5  & obtencao<=9, val_def_anual,0) if obtencao~=0 		/* despesa nao monetaria */

sort id_`id' itens
by id_`id' itens: egen va = total(val_def_anual)	/* valor da despesa */
by id_`id' itens: egen cr = total(`credit')	/* valor da despesa a prazo */
by id_`id' itens: egen nm = total(vre51)	/* valor da despesa não monetaria */

preserve

/* renda nao monetaria */
replace vre51 = . if cod_item_aux==10090	/* rendimento nao monetario 1 */

g vre52 = val_def_anual if cod_item_aux==10090
foreach n of numlist 8001/8017 8019/8071 8084/8098 8999 10014 10020 ///
		10023/10024 12005/12015 12017/12025 12096 {
	replace vre52 = - val_def_anual if cod_item_aux==`n'	/* rendimento não monetario 2 */
}

/* variacao patrimonial */
g vvp0 = .
foreach n of numlist 54005 54016 54009 54007 54014 54046 { 
		replace vvp = val_def_anual if cod_item_aux==`n'
}

loc i = 55000
loc j = 55010
forval n = 1/4 {
	loc i = `i' + 1
	loc j = `j' + 1
	g vvp`n' = val_def_anual if cod_item_aux==`i'
	replace vvp`n' = - val_def_anual if cod_item_aux==`j'
}

collapse (sum) vre51 vre52 vvp*, by(`variaveis_ID' id_`id')

foreach var in vre52 vvp1 vvp2 vvp3 vvp4 {
	replace `var' = . if `var'<0	/* para nao haver renda nao monetaria negativa*/
}

egen vre5 = rowtotal(vre51 vre52)
egen vvp = rowtotal(vvp*)
lab var vre5 "renda não monetária"
lab var vvp "variação patrimonial"
keep `variaveis_ID' id_`id' vre5 vvp

tempfile rendanm
save `rendanm', replace

restore

drop vre51
drop if itens==""

bys id_`id' itens: keep if _n==1 & itens~=""	
keep `variaveis_ID' id_`id' itens va cr nm

reshape wide va cr nm , i(id_`id') j(itens) string

drop crre* nmre* // exclui credito e nao monetario relacionados a rendimentos

/* introduzindo labels a partir das listas */
loc lista: copy local listaDAD
foreach n in 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 {
	gettoken k lista: lista
	di "`k'"
	cap {
		lab var vada`n' "despesa total em `k'"
		lab var crda`n' "`k' - despesa a prazo" 
		lab var nmda`n' "`k' - despesa não monetária" 
	}
	gettoken k lista: lista
}
loc lista: copy local listaDAF
foreach n of numlist 21/27 {
	gettoken k lista: lista
	di "`k'"
	cap {
		lab var vada`n' "despesa total em `k'"
		lab var crda`n' "`k' - despesa a prazo" 
		lab var nmda`n' "`k' - despesa não monetária" 
	}
	gettoken k lista: lista
}
loc lista: copy local listaDDI
foreach n of numlist 21/27 31/36 41/47 51/54 61/69 610 71/76 81/85 ///
		90 101/104 111/116 121/126 131/133 141/142 {
	gettoken k lista: lista
	di "`k'"
	if `n'<100 {
		cap {
			lab var vadd0`n' "despesa total em `k'"
			lab var crdd0`n' "`k' - despesa a prazo" 
			lab var nmdd0`n' "`k' - despesa não monetária" 
		}
	}
	else {
		cap {
			lab var vadd`n' "despesa total em `k'"
			lab var crdd`n' "`k' - despesa a prazo" 
			lab var nmdd`n' "`k' - despesa não monetária" 
		}
	}
	gettoken k lista: lista
}
loc lista: copy local listaREN
foreach n of numlist 11/13 21/25 30 40 {
	gettoken k lista: lista
	di "`k'"
	cap {
		lab var vare`n' "rendimento proveniente de `k'"
	}
	gettoken k lista: lista
}

merge 1:1 id_`id' using `rendanm', nogen keep(match)

tempfile gasto_temp
sort uf seq dv domcl
save `gasto_temp', replace

tempfile base_dom
load_pof02, trs(tr1) temps(`base_dom') original(`original') `english'

g urbano = 1 if estrato<=9 & uf==11
replace urbano = 1 if estrato<=8 & uf==12
replace urbano = 1 if estrato<=10 & uf==13
replace urbano = 1 if estrato<=6 & uf==14
replace urbano = 1 if estrato<=14 & uf==15
replace urbano = 1 if estrato<=8 & uf==16
replace urbano = 1 if estrato<=10 & uf==17
replace urbano = 1 if estrato<=10 & uf==21
replace urbano = 1 if estrato<=10 & uf==22
replace urbano = 1 if estrato<=15 & uf==23
replace urbano = 1 if estrato<=10 & uf==24
replace urbano = 1 if estrato<=10 & uf==25
replace urbano = 1 if estrato<=15 & uf==26
replace urbano = 1 if estrato<=10 & uf==27
replace urbano = 1 if estrato<=9 & uf==28
replace urbano = 1 if estrato<=15 & uf==29
replace urbano = 1 if estrato<=14 & uf==31
replace urbano = 1 if estrato<=10 & uf==32
replace urbano = 1 if estrato<=25 & uf==33
replace urbano = 1 if estrato<=25 & uf==35
replace urbano = 1 if estrato<=15 & uf==41
replace urbano = 1 if estrato<=10 & uf==42
replace urbano = 1 if estrato<=15 & uf==43
replace urbano = 1 if estrato<=10 & uf==50
replace urbano = 1 if estrato<=10 & uf==51
replace urbano = 1 if estrato<=10 & uf==52
replace urbano = 1 if estrato<=10 & uf==53
replace urbano = 0 if urbano==.
lab var urbano "1 area urbana; 0 area rural"

if "`id'" == "dom" merge 1:1 `variaveis_ID' using `gasto_temp', nogen keep(match)
else merge 1:n uf seq dv domcl using `gasto_temp', nogen keep(match)
	

if "`id'" == "uc" {
	preserve

	tempfile tr3
	load_pof02, trs(tr3) temps(`tr3') original(`original') `english'
	
	restore

	merge 1:1 `variaveis_ID' using `tr3', nogen keep(match master)
}

if "`id'" == "pess" {
	preserve

	tempfile tr2
	load_pof02, trs(tr2) temps(`tr2') original(`original') `english'
	
	restore

	merge 1:1 `variaveis_ID' using `tr2', nogen keep(match)
}

end
