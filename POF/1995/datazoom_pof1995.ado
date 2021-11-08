program datazoom_pof1995
syntax, [trs(string)] [id(string)] [sel(string)] [std] original(string) saving(string) [english]

if "`sel'" != "" & "`id'" != "pess"{
	local trs tr3 tr4 tr6 tr7 tr8 tr9 tr10 tr11 tr12 // Apenas TRs de despesas e rendimentos
}
else if "`sel'" != "" & "`id'" == "pess"{
	local trs tr9 tr10 tr11 tr12 // Mantém somente os TRs individuais
}	
else if "`trs'" == "" local trs tr1 tr2 tr3 tr4 tr5 tr6 tr7 tr8 tr9 tr10 tr11 tr12

foreach tr in `trs'{
	tempfile base_`tr' // Temps têm que ser criadas fora da função de load para serem recuperadas
	local bases `bases' `base_`tr'' // Local que armazena todas essas bases
}

load_pof95, trs(`trs') temps(`bases') original(`original') `english'

* Caso só se queira os TRs crus, acaba por aqui
if "`sel'" == "" & "`std'" == ""{
	
	cd "`saving'"

	foreach tr in `trs'{
		use `base_`tr'', clear
		save pof1995_`tr', replace
	}
}

* Caso contrário, falta aplicar a função de bases selecionadas ou a de bases padronizadas

else if "`sel'" != ""{
	pofsel_95, id(`id') sel(`sel') trs(`trs') temps(`bases') original(`original') `english'
	
	cd "`saving'"
	save pof1995_`id'_custom, replace
}
else{
	pofstd_95, id(`id') trs(`trs') temps(`bases') original(`original') `english'
	
	salva etc
}

di as result "As bases foram salvas em `saving'"

end

program load_pof95 // Armazena as bases nas temps fornecidas
syntax, temps(string) original(string) trs(string) [english]

if "`english'" != "" local lang "_en"

cd "`original'"

local ufs "BA CE DF GO MG PA PE PR RJ RS SP"

forvalues i = 1/`: word count `trs''{

	local tr: word `i' of `trs'
	local base: word `i' of `temps'

	if length("`tr'")==3 local suffix = substr("`tr'",3,1)
	else local suffix = substr("`tr'",3,2)
	
	di as input "Extraindo TR`suffix'"
	
	tempfile dic

	findfile dict.dta

	read_compdct, compdct("`r(fn)'") dict_name("pof1995_tr`suffix'`lang'") out("`dic'")
	
	foreach uf of local ufs{
		qui infile using `dic', using("`uf'4x.txt") clear
		qui keep if v0020==`suffix'
		
		cap append using `base'
		
		qui save `base', replace // Empilha todos os estados em cada TR
	}
}

end

program pofsel_95
syntax, id(string) sel(string) trs(string) temps(string) original(string) [english]

/* Lista de itens - desagregados e agregados */

{
* Alimentação no domicílio (DAD)
local Arroz  "6301/6303 6333 6337"
local Feijao  "6313/6325 6331 6336"
local Outros_cereais_etc "6304/6312 6326/6330 6332 6335"
local Cereais_leguminosas_etc  `" `Arroz' `Feijao' `Outros_cereais_etc'"'
local Macarrao  "6427/6434"
local Farinha_de_trigo   "6410"
local Farinha_de_mandioca   "6414"
local Outras_farinhas_etc  "6401/6409 6411/6413 6415/6426 6435/6439 6442/6444"
local Farinhas_feculas_e_massas  `" `Macarrao' `Farinha_de_trigo' `Farinha_de_mandioca' `Outras_farinhas_etc'"'
local Batata_inglesa   "6351"
local Cenoura   "6362"
local Outros_tuberculos  "6352/6361 6363/6366"
local Tuberculos_e_raizes  `" `Batata_inglesa' `Cenoura' `Outros_tuberculos'"'
local Acucar_refinado   "6701"
local Acucar_cristal   "6702"
local Outros_acucares_etc  "6703/6765"
local Acucares_e_derivados  `" `Acucar_refinado' `Acucar_cristal' `Outros_acucares_etc'"'  
local Tomate   "6551"
local Cebola   "6557"
local Alface   "6501"
local Outros_legumes_etc  "6502/6550 6552/6556 6558/6562"
local Legumes_e_verduras  `" `Tomate' `Cebola' `Alface' `Outros_legumes_etc'"'
local Banana  "6601/6611"
local Laranja  "6612/6618"
local Maca   "6630"
local Outras_frutas  "6451 6452 6459/6464 6466/6469 6471 6619/6629 6631/6688"
local Frutas  `"`Banana' `Laranja' `Maca' `Outras_frutas'"'
local Carne_de_boi_de_primeira  "6901/6907 6914 6916"
local Carne_de_boi_de_segunda  "6908/6913 6915 6917 6926"
local Carne_de_suino  "6933/6937"
local Carnes_e_peixes_ind  "7004/7005 7014/7015 7024/7025 7034/7035 7044 7045 7054/7055 7064/7065 7074/7075 7084/7085 7094/7095 7104/7105 7114/7116 7124/7125 7134/7135 7144/7145 7154/7155 7164/7165 7184/7185 7194/7195 7204/7205 7214/7215 7224/7225 7234/7235 7244/7245 7254/7255 7264/7265 7274 7275 7284/7285 7294/7295 7304/7305 7314/7315 7324/7325 7334/7335 7344/7345 7354/7355 7364/7365 7384/7385 7394/7395 7404/7405 7414/7415 7424/7425 7434/7435 7444/7445 7454/7455 7464/7465 7474/7475 7484/7485 7494/7495 7504/7505 7534/7535 7544/7545 7554/7555 7574/7575 7584/7585 7594/7595 7604/7605 7614/7615 7624/7625 7644/7645 7654/7655 7664 7674 7684 7694 7704 7724 7734 7744 7754/7755 7764 7774/7775 7784 7794/7795 7804 7814/7815 7824 7834/7835 7844/7845 7854/7855 8004/8005 8014/8015 8024/8025 8034/8035 8044/8045 8054/8055 8064/8065 8074/8075 8084/8085 8094/8095 8104/8105 8114/8115 8124/8125 8134/8135 8144/8145 8154/8155 8164/8165 8174/8175 8184/8185 8194/8195 8204/8205 8214/8215 8224/8225 8234/8235 8244/8245 8254/8255 8264/8265 8274/8275 8284/8285 8294/8295 8304/8305 8314/8315 8324/8325 8334/8335 8344/8345 8354/8355 8364/8365 8374/8375 8384/8385 8394/8395 8404/8405 8414/8415 8424/8425 8434 8444/8445 8454/8455 8464/8465 8474/8475 8484/8485 8494/8495 8504 8514/8515"
local Pescados_frescos  "7001/7003 7011/7013 7021/7023 7031/7033 7041/7043 7051/7053 7061/7063 7071/7073 7081/7083 7091/7093 7101/7103 7111/7113 7121/7123 7131/7133 7141/7143 7149 7151/7153 7161/7163 7169 7181/7183 7191/7193 7201/7203 7211/7213 7221/7223 7231/7233 7241/7243 7251/7253 7261/7263 7271/7273 7281/7283 7291/7293 7301/7303 7311/7313 7321/7323 7331/7333 7341/7343 7351/7353 7361/7363 7381/7383 7391/7393 7401/7403 7411/7413 7419 7421/7423 7431/7433 7441/7443 7451/7453 7461/7463 7471/7473 7481/7483 7491/7493 7501/7503 7531/7533 7541/7543 7551/7553 7571/7573 7581/7583 7591/7593 7601/7603 7614/7613 7621/7623 7641/7643 7651/7653 7656/7657 7661/7662 7671/7672 7681/7682 7691/7692 7701/7702 7711 7721/7722 7731/7733 7741/7742 7751/7753 7771/7773 7781/7783 7791/7793 7801 7811/7813 7821/7822 7831/7833 7841/7843 7851/7853 8001/8003 8011/8013 8021/8023 8031/8033 8041/8043 8049 8051/8053 8061/8063 8071/8073 8081/8083 8091/8093 8101/8103 8111/8113 8121/8123 8131/8133 8141/8143 8151/8153 8161/8163 8171/8173 8181/8183 8191/8193 8201/8203 8211/8213 8221/8223 8231/8233 8241/8243 8251/8253 8261/8263 8271/8273 8281/8283 8291/8293 8301/8303 8311/8313 8321/8323 8329 8331/8333 8341/8343 8349 8351/8353 8361/8363 8371/8373 8381/8383 8391/8393 8401/8403 8411/8413 8421/8423 8431/8432 8441/8443 8451/8453 8461/8463 8471/8473 8481/8483 8491/8493 8501/8502 8511/8513"
local Outros_carnes_etc  "6918/6925 6927/6932 6938/6957 6967 6969/6986 6988"
local Carnes_visceras_etc  `"`Carne_de_boi_de_primeira' `Carne_de_boi_de_segunda' `Carne_de_suino' `Carnes_e_peixes_ind' `Pescados_frescos' `Outros_carnes_etc'"'
local Frango  "9101/9114 9136 91047/91048"
local Ovo_de_galinha   "9133"
local Outros_aves_etc  "9115/9122 9130 9134/9135 9137/9143"
local Aves_e_ovos  `" `Frango' `Ovo_de_galinha' `Outros_aves_etc'"'
local Leite_de_vaca  "9151/9152"
local Leite_em_po  "9156/9158"
local Queijos  "9167/9180 9186/9187 9196"
local Outros_leites_etc  "9153/9155 9159/9166 9182 9185 9188/9189"
local Leites_e_derivados `"`Leite_de_vaca' `Leite_em_po' `Queijos' `Outros_leites_etc'"'
local Pao_frances   "9201"
local Biscoito  "9222/9224"
local Outros_panificados  "9202/9221 9225/9245 92061 92086/92088 92090 92099/92104 92106/92107 92109"
local Panificados  `"`Pao_frances' `Biscoito' `Outros_panificados'"'
local Oleo_de_soja   "9403"
local Azeite_de_oliva   "9401"
local Outros_oleos_e_gorduras  "9402 9404/9429"
local Oleos_e_gorduras  `"`Oleo_de_soja' `Azeite_de_oliva' `Outros_oleos_e_gorduras'"'
local Cafe_moido   "9325"
local Refrigerantes  "9301/9319 9335 9339/9343 9346 9349 9350 9354/9355 9357/9358 9360"
local Cervejas_e_chopes  "9701/9702"
local Outras_bebidas_alcoolicas  "9703/9730"
local Outras_bebidas_etc  "6467 6757 6764/6765 9320/9324 9326/9334 9336/9338 9344/9345 9347/9348 9351/9353 93056 9359 9361/9365"
local Bebidas_e_infusoes  `"`Cafe_moido' `Refrigerantes' `Cervejas_e_chopes' `Outras_bebidas_alcoolicas' `Outras_bebidas_etc'"'
local Enlatados_e_conservas  "9001/9055"
local Massa_de_tomate   "6847"
local Maionese   "6843"
local Sal_refinado   "6801"
local Outros_sal  "6802/6842 6844/6846 6848/6875"
local Sal_e_condimentos  `"`Massa_de_tomate' `Maionese'  `Sal_refinado' `Outros_sal'"'
local Alimentos_preparados  "9451/9482"
local Outros_alimentacao_no_dom  "9993/9998"
local listaDAD `"Cereais_leguminosas_etc "`Cereais_leguminosas_etc'" Farinhas_feculas_e_massas "`Farinhas_feculas_e_massas'" Tuberculos_e_raizes "`Tuberculos_e_raizes'" Acucares_e_derivados "`Acucares_e_derivados'" Legumes_e_verduras "`Legumes_e_verduras'" Frutas "`Frutas'" Carnes_visceras_etc "`Carnes_visceras_etc'" Aves_e_ovos "`Aves_e_ovos'" Leites_e_derivados "`Leites_e_derivados'" Panificados "`Panificados'" Oleos_e_gorduras "`Oleos_e_gorduras'" Bebidas_e_infusoes "`Bebidas_e_infusoes'" Enlatados_e_conservas "`Enlatados_e_conservas'" Sal_e_condimentos "`Sal_e_condimentos'" Alimentos_preparados "`Alimentos_preparados'" Outros_alimentacao_no_dom "`Outros_alimentacao_no_dom'""'

* Alimentação fora do domicílio (DAF)
local Almoco_e_jantar  "2401 4844"
local Cafe_leite_chocolate  "2402 2405"
local Sanduiches_e_salgados  "2404"
local Refri_e_outras_nao_alcoolicas  "2406/2407 2413 2420/2422 2428/2429 2431/2433 2436 2439/2440"
local Lanches  "2437 24053/24054 24056/24057 41006 49026"
local Cervejas_e_outras_alcoolicas  "2409/2412"
local Outras_alimentacao_fora_do_dom  "2403 2408 2414/2419 2423/2427 2430 2434/2435 2438 24050 24058 24061 24096/24098"
local listaDAF `"Almoco_e_jantar "`Almoco_e_jantar'" Cafe_leite_chocolate "`Cafe_leite_chocolate'" Sanduiches_e_salgados "`Sanduiches_e_salgados'" Refri_e_outras_nao_alcoolicas "`Refri_e_outras_nao_alcoolicas'" Lanches "`Lanches'" Cervejas_e_outras_alcoolicas "`Cervejas_e_outras_alcoolicas'"  Outras_alimentacao_fora_do_dom "`Outras_alimentacao_fora_do_dom'""'

* Despesas diversas (DDI)
local Aluguel  "1005 1010 1016 1018"
local Energia_eletrica  "4707"
local Telefone_fixo  "0704 0713/0714"
local Telefone_celular  "0715"
local Gas_domestico  "0703 0705 0708"
local Agua_e_esgoto  "0701"
local Outros_servicos_etc  "0706/0707 0709 0711/0712 0798"
local Servicos_e_taxas  `"`Energia_eletrica' `Telefone_fixo' `Telefone_celular' `Gas_domestico' `Agua_e_esgoto' `Outros_servicos_etc'"'

local Manutencao_do_lar  "0801/0864 0866/0873 0898 1901/1930 1948"
local Artigos_de_limpeza  "9501/ 9581"
local Mobiliarios_e_artigos_do_lar  "1619 1621/1630 1635/1636 1641/1642 1644/1645 1647 1662 1670 1682 1689 1701/1718 1720/1727 1729/1737 1740/1746 1760/1767 1769 1772 1774/1778 1780/1795 1797 1801/1803 1805 1850/1898 3703/3706 3710/3713 3716 3720 3723/3725 3901/3910 3912/3920 3922/3926 3928 3930/3944 3946/3955 3998 4032 4037 4050 4068 9509/9510 9512/9513 9528/9529 9535/9544 9546/9555 9559 9562 9567/9568 9572 9574 9576 9578/9581"
local Eletrodomesticos  "1501/1596 1614/1617 1631/1634 1637/1638 1648/1650 1652 1657 1660/1661 1663 1665 1669 1676 1693 1696/1697 4067"
local Consertos_de_artigos_do_lar  "0901/0903 0906/0910 0912 0915 0920/0977 0998"
local Habitacao `"`Aluguel' `Servicos_e_taxas' `Manutencao_do_lar' `Artigos_de_limpeza' `Mobiliarios_e_artigos_do_lar' `Eletrodomesticos' `Consertos_de_artigos_do_lar'"'

local Roupa_de_homem  "3401/3437 3498"
local Roupa_de_mulher  "3501/3552 3598"
local Roupa_de_crianca  "3601/3652 3698"
local Calcados_e_apetrechos  "3801/3830 3832/3838 3898"
local Joias_e_bijuterias  "4001 4601/4608 4610/4611 4698"
local Tecidos_e_armarinhos  "3701/3702 3708 3714/3715 3717/3719 3721 3725/3726 3798"
local Vestuario  `"`Roupa_de_homem' `Roupa_de_mulher' `Roupa_de_crianca' `Calcados_e_apetrechos' `Joias_e_bijuterias' `Tecidos_e_armarinhos'"'

local Urbano  "2301/2305 2310/2311 2314/2316 2320/2326 2398 4845"
local Gasolina_para_veiculo_proprio  "2307"
local Alcool_para_veiculo_proprio  "2306"
local Manutencao_de_veiculo_proprio  "4301/4308 4312 4314/4318 4320/4323 4326 4330/4332"
local Aquisicao_de_veiculos  "5012 5101/5113 5120/5124 5151"
local Viagens  "4101/4105 4107/4124 4198"
local Outros_transporte  "2308/2309 2312/2313 2317/2318 4309/4311 4313 4319 4324/4325 4327/4329 4333/4335 4398 5003 5005/5008 5010 5098"
local Transporte  `"`Urbano' `Gasolina_para_veiculo_proprio' `Alcool_para_veiculo_proprio'  `Manutencao_de_veiculo_proprio' `Aquisicao_de_veiculos' `Viagens' `Outros_transporte'"'

local Perfume  "3002"
local Produtos_para_cabelo  "9604"
local Sabonete  "9603 9614"
local Produtos_de_uso_pessoal  "3001 3003/3010 3013/3024 3098 9601/9602 9605/9609 9611/9613 9615/9616"
local Higiene_e_cuidados_pessoais  `"`Perfume' `Produtos_para_cabelo' `Sabonete' `Produtos_de_uso_pessoal'"'

local Remedios  "2901/2937 2974"
local Plano_Seguro_saude  "4214 4225 4231"
local Consulta_e_tratamento_dentario  "4203/4204"
local Consulta_medica  "4201"
local Tratamento_ambulatorial  "4210 4215 4220"
local Servicos_de_cirurgia  "4205"
local Hospitalizacao  "4206"
local Exames_diversos  "4207/4209 4221 4230 4232/4233"
local Material_de_tratamento  "2951 2954/2960 2962/2967 2969/2973 2975/2978 2980/2982 4211/4212 4223 4227/4228 4234"
local Outras_assistencia_saude  "2952/2953 2961 2968 2979 2998 4202 4213 4216/4219 4222 4229 4298"
local Assistencia_a_saude  `"`Remedios' `Plano_seguro_saude' `Consulta_e_tratamento_dentario' `Consulta_medica' `Tratamento_ambulatorial' `Servicos_de_cirurgia' `Hospitalizacao' `Exames_diversos' `Material_de_tratamento' `Outras_assistencia_saude' "'

local Cursos_regulares  "4901 4931/4932"
local Curso_superior  "4933"
local Outros_cursos  "4902 4911 4915 4922/4923 4934/4941 4943/4944 4947/4950 4959"
local Livros_e_revistas_tecnicas  "4906/4908 4945"
local Artigos_escolares  "3201/3203 3209 3212/3213 3298 4919/4921 4925 4929"
local Outras_educacao  "4803 4813 4847 4903/4905 4909/4910 4912 4914 4916/4918 4924 4927/4928 4930 4942 4946 4998"
local Educacao  `"`Cursos_regulares' `Curso_superior' `Outros_cursos' `Livros_e_revistas_tecnicas' `Artigos_escolares' `Outras_educacao'"'

local Brinquedos_e_jogos  "3301 3303/3305 3314 3316 3320"
local Celular_e_acessorios  "1672 1677"
local Periodicos_livros_e_revistas  "2701/2703 3204/3205"
local Diversoes_e_esportes  "2801/2822 2825 2828/2854 2898 3302 3307/3308 3317"
local Outras_recreacao_etc  "1601 1605/1609 1611 1618 1643 1671 1678 1690 2704/2705 2798 3306 3309/3313 3315 3318/3319 3321 3398"
local Recreacao_e_cultura  `"`Brinquedos_e_jogos' `Celular_e_acessorios' `Periodicos_livros_e_revistas' `Diversoes_e_esportes' `Outras_recreacao_etc'"'

local Fumo  "2501 2503/2505 2507 2509/2518 2598 4060/4061 4071/4072"
local Cabeleireiro  "3101/3102 3148"
local Manicuro_e_pedicuro  "3103"
local Consertos_de_artigos_pessoais  "3104 3110 3113/3116 3118 3120/3124 3126/3127 3129/3131 3133 3140"
local Outras_servicos_pessoais  "3105/3109 3111/3112 3117 3119 3125 3128 3132 3135/3139 3141 3198"
local Servicos_pessoais  `"`Cabeleireiro' `Manicuro_e_pedicuro' `Consertos_de_artigos_pessoais' `Outras_servicos_pessoais'"'

local Jogos_e_apostas  "2601/2610 2612/2616 2698"
local Comunicacao  "2201/2202 2298"
local Cerimonias_e_festas  "4501/4510 4598"
local Servicos_profissionais  "4401/4418"
local Imoveis_de_uso_ocasional  "4702/4704 4706/4708 4713 4796"
local Outras_despesas_diversas  "1204 1220 1301/1304 1306/1308 1310/1312 1315/1319 1398 1640 3206/3208 3210/3211 3707 3722 4002 4005/4007 4009 4011 4022/4023 4025/4026 4029/4031 4034/4036 4038 4042/4043 4049 4069 4098 4498 9591/9594 9599"
local Despesas_diversas  `"`Jogos_e_apostas' `Comunicacao' `Cerimonias_e_festas' `Servicos_profissionais' `Imoveis_de_uso_ocasional' `Outras_despesas_diversas'"'

local Impostos  "1014 1022/1023 4705 4711/4712 4714 4838 4846 5001/5002 5004 5009 5701/5706 5801/5806"
local Contribuicoes_trabalhistas  "1951/1980 1998 4801 4818 4826 4839 5601/5606"
local Servicos_bancarios  "4809/4810 4833/4837 4848 4861"
local Pensoes_mesadas_e_doacoes  "4802 4804/4805 4821/4824 4840 4843 5011"
local Previdencia_privada  "4806 5311/5312"
local Outras_despesas  "4807/4808 4814 4817 4819 4825 4828/4832 4841 4898"
local Outras_despesas_correntes  `"`Impostos' `Contribuicoes_trabalhistas' `Servicos_bancarios' `Pensoes_mesadas_e_doacoes' `Previdencia_privada' `Outras_despesas'"'

local Imovel_aquisicao  "1201/1202 4701"
local Imovel_reforma  "0801/0873 0898"
local Outros_investimentos  "1639 1673 1689 4609 4710 4820 4842"
local Aumento_do_ativo  `"`Imovel_aquisicao' `Imovel_reforma' `Outros_investimentos'"'

local Emprestimo_e_carne  "4811/4812 4815 4827"
local Prestacao_de_imovel  "1007 1017"
local Diminuicao_do_passivo  `"`Emprestimo_e_carne' `Prestacao_de_imovel'"'

local listaDDI `"Aluguel "`Aluguel'" Servicos_e_taxas "`Servicos_e_taxas'" Manutencao_do_lar "`Manutencao_do_lar'" Artigos_de_limpeza "`Artigos_de_limpeza'" Mobiliarios_e_artigos_do_lar "`Mobiliarios_e_artigos_do_lar'" Eletrodomesticos "`Eletrodomesticos'" Consertos_de_artigos_do_lar "`Consertos_de_artigos_do_lar'" Roupa_de_homem "`Roupa_de_homem'" Roupa_de_mulher "`Roupa_de_mulher'" Roupa_de_crianca "`Roupa_de_crianca'" Calcados_e_apetrechos "`Calcados_e_apetrechos'" Joias_e_bijuterias "`Joias_e_bijuterias'" Tecidos_e_armarinhos "`Tecidos_e_armarinhos'" Urbano "`Urbano'" Gasolina_para_veiculo_proprio "`Gasolina_para_veiculo_proprio'" Alcool_para_veiculo_proprio "`Alcool_para_veiculo_proprio'"  Manutencao_de_veiculo_proprio "`Manutencao_de_veiculo_proprio'" Aquisicao_de_veiculos "`Aquisicao_de_veiculos'" Viagens "`Viagens'" Outros_transporte "`Outros_transporte'" Perfume "`Perfume'" Produtos_para_cabelo "`Produtos_para_cabelo'" Sabonete "`Sabonete'" Produtos_de_uso_pessoal "`Produtos_de_uso_pessoal'" Remedios "`Remedios'" Plano_seguro_saude "`Plano_seguro_saude'" Consulta_e_tratamento_dentario "`Consulta_e_tratamento_dentario'" Consulta_medica "`Consulta_medica'" Tratamento_ambulatorial "`Tratamento_ambulatorial'" Servicos_de_cirurgia "`Servicos_de_cirurgia'" Hospitalizacao "`Hospitalizacao'" Exames_diversos "`Exames_diversos'" Material_de_tratamento "`Material_de_tratamento'" Outras_assistencia_saude "`Outras_assistencia_saude'" Cursos_regulares "`Cursos_regulares'" Curso_superior "`Curso_superior'" Outros_cursos "`Outros_cursos'" Livros_e_revistas_tecnicas "`Livros_e_revistas_tecnicas'" Artigos_escolares "`Artigos_escolares'" Outras_educacao "`Outras_educacao'" Brinquedos_e_jogos "`Brinquedos_e_jogos'" Celular_e_acessorios "`Celular_e_acessorios'" Periodicos_livros_e_revistas "`Periodicos_livros_e_revistas'" Diversoes_e_esportes "`Diversoes_e_esportes'" Outras_recreacao_etc "`Outras_recreacao_etc'" Fumo "`Fumo'" Cabeleireiro "`Cabeleireiro'" Manicuro_e_pedicuro "`Manicuro_e_pedicuro'" Consertos_de_artigos_pessoais "`Consertos_de_artigos_pessoais'" Outras_servicos_pessoais "`Outras_servicos_pessoais'" Jogos_e_apostas "`Jogos_e_apostas'" Comunicacao "`Comunicacao'" Cerimonias_e_festas "`Cerimonias_e_festas'" Servicos_profissionais "`Servicos_profissionais'" Imoveis_de_uso_ocasional "`Imoveis_de_uso_ocasional'" Outras_despesas_diversas "`Outras_despesas_diversas'" Impostos "`Impostos'" Contribuicoes_trabalhistas "`Contribuicoes_trabalhistas'" Servicos_bancarios "`Servicos_bancarios'" Pensoes_mesadas_e_doacoes "`Pensoes_mesadas_e_doacoes'" Previdencia_privada "`Previdencia_privada'" Outras_despesas "`Outras_despesas'" Imovel_aquisicao "`Imovel_aquisicao'" Imovel_reforma "`Imovel_reforma'" Outros_investimentos "`Outros_investimentos'" Emprestimo_e_carne "`Emprestimo_e_carne'" Prestacao_de_imovel "`Prestacao_de_imovel'""'

* Rendimentos (REN)
local Empregado  "5301/5304 5331/5333 5401/5402 5445 5447"
local Empregador  "5304"
local Conta_propria  "5306"
local Rendimento_do_trabalho `"`Empregado' `Empregador' `Conta_propria'"'
local Aposentadoria_prev_publica  "5311 5429"
local Aposentadoria_prev_privada  "5312 5440 5457"
local Bolsa_de_estudo  "5313"
local Pensao_aliment_mesada_doacao  "5314"
local Transferencias_transitorias  "5335/5339 5341 5405/5407 5412/5413 5423/5424 5426/5428 5432 5436 5438 5443"
local Transferencia  `"`Aposentadoria_prev_publica' `Aposentadoria_prev_privada' `Bolsa_de_estudo' `Pensao_aliment_mesada_doacao' `Transferencias_transitorias'"'

local Aluguel_de_bens_imoveis  "5321"
local Aluguel_de_bens_moveis  "5322"
local Rendimento_de_aluguel  `"`Aluguel_de_bens_imoveis' `Aluguel_de_bens_moveis'"'
local Vendas_esporadicas  "5408/5409 5416 5444 5448/5452 5491"
local Emprestimos  "5414 5425 5431"
local Aplicacoes_de_capital  "5415 5435 5446"	
local Outros_renda  "5403/5404 5410 5430 5434 5439 5441 5453/5456 5458/5459 5492 5497 5514"
local Outros_rendimentos `"`Vendas_esporadicas' `Empréstimos' `Aplicacoes_de_capital' `Outros_renda'"'
local listaREN `" Empregado "`Empregado'" Empregador "`Empregador'" Conta_propria  "`Conta_propria'" Aposentadoria_prev_publica "`Aposentadoria_prev_publica'" Aposentadoria_prev_privada "`Aposentadoria_prev_privada'" Bolsa_de_estudo "`Bolsa_de_estudo'" Pensao_aliment_mesada_doacao "`Pensao_aliment_mesada_doacao'" Transferencias_transitorias "`Transferencias_transitorias'" Rendimento_de_aluguel "`Rendimento_de_aluguel'" Outros_rendimentos "`Outros_rendimentos'""'
local Rendimento_nao_monetario
}

foreach item in `sel'{
	if "`item'" == "Rendimento_nao_monetario" loc ren = 1
	else local codigos  `" `codigos' "``item''" "' /* Armazena o código de todos os itens selecionados.
												Por exemplo, se o item for Feijão, o código `Feijão' definido antes
												entra no local */
}

di as input "Itens selecionados:" _newline "`sel'"

tempfile pof95 p11

forvalues i = 1/`: word count `trs''{
	local tr: word `i' of `trs'
	local base: word `i' of `temps'
	
	use `base', clear
	
	if "`tr'" == "tr3" {
		rename v3037 cod_item_aux  
		rename v3098 val_def_anual 
	}
	if "`tr'" == "tr4" {
		rename v4200 cod_item_aux  
		rename v4290 val_def_anual 
	}
	if "`tr'" == "tr6" {
		rename v6050 cod_item_aux  
		rename v6110 val_def_anual 
	}
	if "`tr'" == "tr7" {
		rename v7050 cod_item_aux  
		rename v7100 val_def_anual 
	}
	if "`tr'" == "tr8" {
		rename v8050 ordem 
		rename v8060 cod_item_aux  
		rename v8095 val_def_anual 
	}
	if "`tr'" == "tr9" {
		rename v9045 ordem 
		rename v9050 cod_item_aux  
		rename v9093 val_def_anual 
	}
	if "`tr'" == "tr10" {
		rename v1005 ordem 
		rename v1006 cod_item_aux  
		rename v1071 val_def_anual 
	}
	if "`tr'" == "tr11" {
		preserve
		keep v0020 v0040 v0050 v0060 v0065 v0067 v1105 v1106 v1105 v1106 v1165
		rename v1105 ordem 
		rename v1106 cod_item_aux 
		rename v1165 val_def_anual
		save `p11', replace
		restore

		preserve
		keep v0020 v0040 v0050 v0060 v0065 v0067 v1105 v1106 v1105 v1106 v1185
		rename v1105 ordem 
		rename v1106 cod_item_aux 
		rename v1185 val_def_anual
		replace cod_item_aux = cod_item_aux + 300 
		append using `p11'
		save `p11', replace
		restore

		preserve
		keep v0020 v0040 v0050 v0060 v0065 v0067 v1105 v1106 v1105 v1106 v1194
		rename v1105 ordem 
		rename v1106 cod_item_aux 
		rename v1194 val_def_anual
		replace cod_item_aux = cod_item_aux + 400 
		append using `p11'
		save `p11', replace
		restore

		keep v0020 v0040 v0050 v0060 v0065 v0067 v1105 v1106 v1105 v1106 v1198
		rename v1105 ordem 
		rename v1106 cod_item_aux 
		rename v1198 val_def_anual
		replace cod_item_aux = cod_item_aux + 500 
		append using `p11'
	}
	if "`tr'" == "tr12" {
		rename v1205 ordem 
		rename v1206 cod_item_aux  
		rename v1235 val_def_anual 
	}
	
	cap append using `pof95'
	qui save `pof95', replace
	
}

keep v0020 v0040 v0050 v0060 v0065 v0067 ordem cod_item_aux val_def_anual

tempfile gastos
save `gastos', replace

local nomes "Despesa_com_alimentacao Alimentacao_no_dom Cereais_leguminosas_etc Arroz Feijao Outros_cereais_etc Farinhas_feculas_e_massas Macarrao Farinha_de_trigo Farinha_de_mandioca Outras_farinhas_etc Tuberculos_e_raizes Batata_inglesa Cenoura Outros_tuberculos Acucares_e_derivados Acucar_refinado Acucar_cristal Outros_acucares_etc Legumes_e_verduras Tomate Cebola Alface Outros_legumes_etc Frutas Banana Laranja Maca Outras_frutas Carnes_visceras_etc Carne_de_boi_de_primeira Carne_de_boi_de_segunda Carne_de_suino Carnes_e_peixes_ind Pescados_frescos Outros_carnes_etc Aves_e_ovos Frango Ovo_de_galinha Outros_aves_etc Leites_e_derivados Leite_de_vaca Leite_em_po Queijos Outros_leites_etc Panificados Pao_frances Biscoito Outros_panificados Oleos_e_gorduras Oleo_de_soja Azeite_de_oliva Outros_oleos_e_gorduras Bebidas_e_infusoes Cafe_moido Refrigerantes Cervejas_e_chopes Outras_bebidas_alcoolicas Outras_bebidas_etc Enlatados_e_conservas Sal_e_condimentos Massa_de_tomate Maionese Sal_refinado Outros_sal Alimentos_preparados Outros_alimentacao_no_dom Alimentacao_fora_do_dom Almoco_e_jantar Cafe_leite_chocolate Sanduiches_e_salgados Refri_e_outras_nao_alcoolicas Lanches Cervejas_e_outras_alcoolicas Outras_alimentacao_fora_do_dom Habitacao Aluguel Servicos_e_taxas Energia_eletrica Telefone_fixo Telefone_celular Gas_domestico Agua_e_esgoto Outros_servicos_etc Manutencao_do_lar Artigos_de_limpeza Mobiliarios_e_artigos_do_lar Eletrodomesticos Consertos_de_artigos_do_lar Vestuario Roupa_de_homem Roupa_de_mulher Roupa_de_crianca Calcados_e_apetrechos Joias_e_bijuterias Tecidos_e_armarinhos Transporte Urbano Gasolina_para_veiculo_proprio Alcool_para_veiculo_proprio Manutencao_de_veiculo_proprio Aquisicao_de_veiculos Viagens Outros_transporte Higiene_e_cuidados_pessoais Perfume Produtos_para_cabelo Sabonete Produtos_de_uso_pessoal Assistencia_a_saude Remedios Plano_Seguro_saude Consulta_e_tratamento_dentario Consulta_medica Tratamento_ambulatorial Servicos_de_cirurgia Hospitalizacao Exames_diversos Material_de_tratamento Outras_assistencia_saude Educacao Cursos_regulares Curso_superior Outros_cursos Livros_e_revistas_tecnicas Artigos_escolares Outras_educacao Recreacao_e_cultura Brinquedos_e_jogos Celular_e_acessorios Periodicos_livros_e_revistas Diversoes_e_esportes Outras_recreacao_etc Fumo Servicos_pessoais Cabeleireiro Manicuro_e_pedicuro Consertos_de_artigos_pessoais Outras_servicos_pessoais Despesas_diversas Jogos_e_apostas Comunicacao Cerimonias_e_festas Servicos_profissionais Imoveis_de_uso_ocasional Outras_despesas_diversas Outras_despesas_correntes Impostos Contribuicoes_trabalhistas Servicos_bancarios Pensoes_mesadas_e_doacoes Previdencia_privada Outras_despesas Aumento_do_ativo Imovel_aquisicao Imovel_reforma Outros_investimentos Diminuicao_do_passivo Emprestimo_e_carne Prestacao_de_imovel Rendimento_total Rendimento_do_trabalho Empregado Empregador Conta_propria Transferencia Aposentadoria_prev_publica Aposentadoria_prev_privada Bolsa_de_estudo Pensao_aliment_mesada_doacao Transferencias_transitorias Rendimento_de_aluguel Aluguel_de_bens_imoveis Aluguel_de_bens_moveis Outros_rendimentos Vendas_esporadicas Emprestimos Aplicacoes_de_capital Outros_renda Rendimento_nao_monetario"
local numeros "da0 da1 da101	da1011 da1012	da1013 da102 da1021 da1022 da1023 da1024 da103	da1031 da1032	da1033 da104 da1041 da1042 da1043 da105 da1051	da1052 da1053	da1054 da106 da1061 da1062 da1063 da1064 da107	da1071 da1072	da1073 da1074	da1075 da1076	da108 da1081 da1082 da1083 da109	da1091 da1092	da1093 da1094	da110 da1101	da1102 da1103 da111	da1111 da1112 da1113 da112 da1121 da1122 da1123 da1124 da1125 da1131 da114 da1141 da1142 da1143	da1144 da115 da116 da2 da21	da22 da23 da24 da25	da26 da27 dd2 dd21 dd22 dd221 dd222 dd223 dd224 dd225 dd226	dd23 dd24 dd25 dd26 dd27 dd3 dd31 dd32 dd33 dd34 dd35 dd36 dd4 dd41 dd42 dd43 dd44 dd45	dd46 dd47 dd5 dd51 dd52	dd53 dd54 dd6 dd61 dd62	dd63 dd64 dd65 dd66	dd67 dd68 dd69 dd61	dd7	dd71 dd72 dd73 dd74	dd75 dd76 dd8 dd81 dd82 dd83 dd84 dd85 dd9 dd10	dd101 dd102	dd103 dd104	dd11 dd111 dd112 dd113 dd114 dd115 dd116 dd12 dd121	dd122 dd123	dd124 dd125	dd126 dd13 dd131 dd132 dd133 dd14 dd141	dd142 re0 re1 re11 re12	re13 re2 re21 re22 re23	re24 re25 re3 re31 re32 re4	re41 re42 re43 re44"

use `gastos', clear	
			
if "`id'" == "dom" {
	loc variaveis_ID = "v0040 v0050 v0060 v0065"
}
else if "`id'" == "uc" {
	rename v0067 uc
	loc variaveis_ID = "v0040 v0050 v0060 v0065 uc"
}
else if "`id'" == "pess" {
	rename v0067 uc
	loc variaveis_ID = "v0040 v0050 v0060 v0065 uc ordem"
	loc TR_prin = "2"
	keep if v0020>=9 & v0020<=12 & ordem~=.
}

tempfile base

local iteracao = 1

di as input "Agregando as despesas"

forvalues i = 1/`: word count `sel''{
	local item: word `i' of `sel'
	local codigo: word `i' of `codigos'
	
	if "`codigo'" == "" continue
	
	preserve
	gen item = .
	foreach n of numlist `codigo'{
		replace item = 1 if cod_item_aux == `n'
	}
		
	keep if item == 1
	cap collapse (sum) val_def_anual, by(`variaveis_ID') // gera os gastos totais no `item'
	if _rc == 2000{
		restore
		continue, break
	}
	forvalues j = 1/`: word count `nomes''{
		local nome: word `j' of `nomes'
		local numero: word `j' of `numeros'
	
		if "`item'" == "`nome'" & "`numero'" != ""{
			rename val_def_anual v`numero'
			if substr("`numero'",1,1)=="d" lab var v`numero' "despesa total em `nome'"
			else lab var v`numero' "rendimento proveniente de `nome'"
			
				if `iteracao'~=1 merge 1:1 `variaveis_ID' using `base', nogen
				save `base', replace
				restore

				local iteracao = `iteracao' + 1
		}
	}
}



if "`id'" == "pess" {
	
	tempfile base_pessoas
	
	load_pof95, trs(tr2) temps(`base_pessoas') original(`original') `english' // Carregando o TR de pessoas para mergear
	
	rename v0067 uc
	rename v2130 ordem

	sum `variaveis_ID'
	
	di as input "Merge com base de pessoas"
	
	cap merge 1:1 `variaveis_ID' using `base', nogen // A base na memória é a de pes, que é mergeada com a `base' de gastos selecionados
	if _rc == 601{
	di as error "Sem observações dos itens selecionados. Muitos gastos não estão presentes nos registros de pessoas."
	exit 601
	}
	else if _rc != 0 exit _rc
	
	qui save `base', replace
}

/* Ler base de domicílios para mergear */

tempfile base_dom

load_pof95, trs(tr1) temps(`base_dom') original(`original') `english'

di as input "Merge com base de domicílios"

if "`id'" == "dom" merge 1:1 `variaveis_ID' using `base', nogen // A base na memória é a de dom, que é mergeada com a `base' de gastos selecionados
else merge 1:n v0040 v0050 v0060 v0065 using `base', nogen 

end

program pofstd_95
syntax, id(string) trs(string) temps(string) original(string) [english]

* Alimentação no domicílio (DAD)
local Arroz  "6301/6303 6333 6337"
local Feijao  "6313/6325 6331 6336"
local Outros_cereais_etc "6304/6312 6326/6330 6332 6335"
local Cereais_leguminosas_etc  `" `Arroz' `Feijao' `Outros_cereais_etc'"'
local Macarrao  "6427/6434"
local Farinha_de_trigo   "6410"
local Farinha_de_mandioca   "6414"
local Outras_farinhas_etc  "6401/6409 6411/6413 6415/6426 6435/6439 6442/6444"
local Farinhas_feculas_e_massas  `" `Macarrao' `Farinha_de_trigo' `Farinha_de_mandioca' `Outras_farinhas_etc'"'
local Batata_inglesa   "6351"
local Cenoura   "6362"
local Outros_tuberculos  "6352/6361 6363/6366"
local Tuberculos_e_raizes  `" `Batata_inglesa' `Cenoura' `Outros_tuberculos'"'
local Acucar_refinado   "6701"
local Acucar_cristal   "6702"
local Outros_acucares_etc  "6703/6765"
local Acucares_e_derivados  `" `Acucar_refinado' `Acucar_cristal' `Outros_acucares_etc'"'  
local Tomate   "6551"
local Cebola   "6557"
local Alface   "6501"
local Outros_legumes_etc  "6502/6550 6552/6556 6558/6562"
local Legumes_e_verduras  `" `Tomate' `Cebola' `Alface' `Outros_legumes_etc'"'
local Banana  "6601/6611"
local Laranja  "6612/6618"
local Maca   "6630"
local Outras_frutas  "6451 6452 6459/6464 6466/6469 6471 6619/6629 6631/6688"
local Frutas  `"`Banana' `Laranja' `Maca' `Outras_frutas'"'
local Carne_de_boi_de_primeira  "6901/6907 6914 6916"
local Carne_de_boi_de_segunda  "6908/6913 6915 6917 6926"
local Carne_de_suino  "6933/6937"
local Carnes_e_peixes_ind  "7004/7005 7014/7015 7024/7025 7034/7035 7044 7045 7054/7055 7064/7065 7074/7075 7084/7085 7094/7095 7104/7105 7114/7116 7124/7125 7134/7135 7144/7145 7154/7155 7164/7165 7184/7185 7194/7195 7204/7205 7214/7215 7224/7225 7234/7235 7244/7245 7254/7255 7264/7265 7274 7275 7284/7285 7294/7295 7304/7305 7314/7315 7324/7325 7334/7335 7344/7345 7354/7355 7364/7365 7384/7385 7394/7395 7404/7405 7414/7415 7424/7425 7434/7435 7444/7445 7454/7455 7464/7465 7474/7475 7484/7485 7494/7495 7504/7505 7534/7535 7544/7545 7554/7555 7574/7575 7584/7585 7594/7595 7604/7605 7614/7615 7624/7625 7644/7645 7654/7655 7664 7674 7684 7694 7704 7724 7734 7744 7754/7755 7764 7774/7775 7784 7794/7795 7804 7814/7815 7824 7834/7835 7844/7845 7854/7855 8004/8005 8014/8015 8024/8025 8034/8035 8044/8045 8054/8055 8064/8065 8074/8075 8084/8085 8094/8095 8104/8105 8114/8115 8124/8125 8134/8135 8144/8145 8154/8155 8164/8165 8174/8175 8184/8185 8194/8195 8204/8205 8214/8215 8224/8225 8234/8235 8244/8245 8254/8255 8264/8265 8274/8275 8284/8285 8294/8295 8304/8305 8314/8315 8324/8325 8334/8335 8344/8345 8354/8355 8364/8365 8374/8375 8384/8385 8394/8395 8404/8405 8414/8415 8424/8425 8434 8444/8445 8454/8455 8464/8465 8474/8475 8484/8485 8494/8495 8504 8514/8515"
local Pescados_frescos  "7001/7003 7011/7013 7021/7023 7031/7033 7041/7043 7051/7053 7061/7063 7071/7073 7081/7083 7091/7093 7101/7103 7111/7113 7121/7123 7131/7133 7141/7143 7149 7151/7153 7161/7163 7169 7181/7183 7191/7193 7201/7203 7211/7213 7221/7223 7231/7233 7241/7243 7251/7253 7261/7263 7271/7273 7281/7283 7291/7293 7301/7303 7311/7313 7321/7323 7331/7333 7341/7343 7351/7353 7361/7363 7381/7383 7391/7393 7401/7403 7411/7413 7419 7421/7423 7431/7433 7441/7443 7451/7453 7461/7463 7471/7473 7481/7483 7491/7493 7501/7503 7531/7533 7541/7543 7551/7553 7571/7573 7581/7583 7591/7593 7601/7603 7614/7613 7621/7623 7641/7643 7651/7653 7656/7657 7661/7662 7671/7672 7681/7682 7691/7692 7701/7702 7711 7721/7722 7731/7733 7741/7742 7751/7753 7771/7773 7781/7783 7791/7793 7801 7811/7813 7821/7822 7831/7833 7841/7843 7851/7853 8001/8003 8011/8013 8021/8023 8031/8033 8041/8043 8049 8051/8053 8061/8063 8071/8073 8081/8083 8091/8093 8101/8103 8111/8113 8121/8123 8131/8133 8141/8143 8151/8153 8161/8163 8171/8173 8181/8183 8191/8193 8201/8203 8211/8213 8221/8223 8231/8233 8241/8243 8251/8253 8261/8263 8271/8273 8281/8283 8291/8293 8301/8303 8311/8313 8321/8323 8329 8331/8333 8341/8343 8349 8351/8353 8361/8363 8371/8373 8381/8383 8391/8393 8401/8403 8411/8413 8421/8423 8431/8432 8441/8443 8451/8453 8461/8463 8471/8473 8481/8483 8491/8493 8501/8502 8511/8513"
local Outros_carnes_etc  "6918/6925 6927/6932 6938/6957 6967 6969/6986 6988"
local Carnes_visceras_etc  `"`Carne_de_boi_de_primeira' `Carne_de_boi_de_segunda' `Carne_de_suino' `Carnes_e_peixes_ind' `Pescados_frescos' `Outros_carnes_etc'"'
local Frango  "9101/9114 9136 91047/91048"
local Ovo_de_galinha   "9133"
local Outros_aves_etc  "9115/9122 9130 9134/9135 9137/9143"
local Aves_e_ovos  `" `Frango' `Ovo_de_galinha' `Outros_aves_etc'"'
local Leite_de_vaca  "9151/9152"
local Leite_em_po  "9156/9158"
local Queijos  "9167/9180 9186/9187 9196"
local Outros_leites_etc  "9153/9155 9159/9166 9182 9185 9188/9189"
local Leites_e_derivados `"`Leite_de_vaca' `Leite_em_po' `Queijos' `Outros_leites_etc'"'
local Pao_frances   "9201"
local Biscoito  "9222/9224"
local Outros_panificados  "9202/9221 9225/9245 92061 92086/92088 92090 92099/92104 92106/92107 92109"
local Panificados  `"`Pao_frances' `Biscoito' `Outros_panificados'"'
local Oleo_de_soja   "9403"
local Azeite_de_oliva   "9401"
local Outros_oleos_etc  "9402 9404/9429"
local Oleos_e_gorduras  `"`Oleo_de_soja' `Azeite_de_oliva' `Outros_oleos_etc'"'
local Cafe_moido   "9325"
local Refrigerantes  "9301/9319 9335 9339/9343 9346 9349 9350 9354/9355 9357/9358 9360"
local Cervejas_e_chopes  "9701/9702"
local Outras_bebidas_alcoolicas  "9703/9730"
local Outras_bebidas_etc  "6467 6757 6764/6765 9320/9324 9326/9334 9336/9338 9344/9345 9347/9348 9351/9353 93056 9359 9361/9365"
local Bebidas_e_infusoes  `"`Cafe_moido' `Refrigerantes' `Cervejas_e_chopes' `Outras_bebidas_alcoolicas' `Outras_bebidas_etc'"'
local Enlatados_e_conservas  "9001/9055"
local Massa_de_tomate   "6847"
local Maionese   "6843"
local Sal_refinado   "6801"
local Outros_sal  "6802/6842 6844/6846 6848/6875"
local Sal_e_condimentos  `"`Massa_de_tomate' `Maionese'  `Sal_refinado' `Outros_sal'"'
local Alimentos_preparados  "9451/9482"
local Outros_alimentacao_no_dom  "9993/9998"
local listaDAD `"Cereais_leguminosas_etc "`Cereais_leguminosas_etc'" Farinhas_feculas_e_massas "`Farinhas_feculas_e_massas'" Tuberculos_e_raizes "`Tuberculos_e_raizes'" Acucares_e_derivados "`Acucares_e_derivados'" Legumes_e_verduras "`Legumes_e_verduras'" Frutas "`Frutas'" Carnes_visceras_etc "`Carnes_visceras_etc'" Aves_e_ovos "`Aves_e_ovos'" Leites_e_derivados "`Leites_e_derivados'" Panificados "`Panificados'" Oleos_e_gorduras "`Oleos_e_gorduras'" Bebidas_e_infusoes "`Bebidas_e_infusoes'" Enlatados_e_conservas "`Enlatados_e_conservas'" Sal_e_condimentos "`Sal_e_condimentos'" Alimentos_preparados "`Alimentos_preparados'" Outros_alimentacao_no_dom "`Outros_alimentacao_no_dom'""'

* Alimentação fora do domicílio (DAF)
local Almoco_e_jantar  "2401 4844"
local Cafe_leite_chocolate  "2402 2405"
local Sanduiches_e_salgados  "2404"
local Refri_e_outras_nao_alcoolicas  "2406/2407 2413 2420/2422 2428/2429 2431/2433 2436 2439/2440"
local Lanches  "2437 24053/24054 24056/24057 41006 49026"
local Cervejas_e_outras_alcoolicas  "2409/2412"
local Outras_alimentacao_fora_do_dom  "2403 2408 2414/2419 2423/2427 2430 2434/2435 2438 24050 24058 24061 24096/24098"
local listaDAF `"Almoco_e_jantar "`Almoco_e_jantar'" Cafe_leite_chocolate "`Cafe_leite_chocolate'" Sanduiches_e_salgados "`Sanduiches_e_salgados'" Refri_e_outras_nao_alcoolicas "`Refri_e_outras_nao_alcoolicas'" Lanches "`Lanches'" Cervejas_e_outras_alcoolicas "`Cervejas_e_outras_alcoolicas'"  Outras_alimentacao_fora_do_dom "`Outras_alimentacao_fora_do_dom'""'

* Despesas diversas (DDI)
local Aluguel  "1005 1010 1016 1018"
local Energia_eletrica  "4707"
local Telefone_fixo  "0704 0713/0714"
local Telefone_celular  "0715"
local Gas_domestico  "0703 0705 0708"
local Água_e_esgoto  "0701"
local Outros_servicos_etc  "0706/0707 0709 0711/0712 0798"
local Servicos_e_taxas  `"`Energia_eletrica' `Telefone_fixo' `Telefone_celular' `Gas_domestico' `Agua_e_esgoto' `Outros_servicos_etc'"'

local Manutencao_do_lar  "0801/0864 0866/0873 0898 1901/1930 1948"
local Artigos_de_limpeza  "9501/ 9581"
local Mobiliarios_e_artigos_do_lar  "1619 1621/1630 1635/1636 1641/1642 1644/1645 1647 1662 1670 1682 1689 1701/1718 1720/1727 1729/1737 1740/1746 1760/1767 1769 1772 1774/1778 1780/1795 1797 1801/1803 1805 1850/1898 3703/3706 3710/3713 3716 3720 3723/3725 3901/3910 3912/3920 3922/3926 3928 3930/3944 3946/3955 3998 4032 4037 4050 4068 9509/9510 9512/9513 9528/9529 9535/9544 9546/9555 9559 9562 9567/9568 9572 9574 9576 9578/9581"
local Eletrodomesticos  "1501/1596 1614/1617 1631/1634 1637/1638 1648/1650 1652 1657 1660/1661 1663 1665 1669 1676 1693 1696/1697 4067"
local Consertos_de_artigos_do_lar  "0901/0903 0906/0910 0912 0915 0920/0977 0998"
local Habitacao `"`Aluguel' `Servicos_e_taxas' `Manutencao_do_lar' `Artigos_de_limpeza' `Mobiliarios_e_artigos_do_lar' `Eletrodomesticos' `Consertos_de_artigos_do_lar'"'

local Roupa_de_homem  "3401/3437 3498"
local Roupa_de_mulher  "3501/3552 3598"
local Roupa_de_crianca  "3601/3652 3698"
local Calcados_e_apetrechos  "3801/3830 3832/3838 3898"
local Joias_e_bijuterias  "4001 4601/4608 4610/4611 4698"
local Tecidos_e_armarinhos  "3701/3702 3708 3714/3715 3717/3719 3721 3725/3726 3798"
local Vestuario  `"`Roupa_de_homem' `Roupa_de_mulher' `Roupa_de_crianca' `Calcados_e_apetrechos' `Joias_e_bijuterias' `Tecidos_e_armarinhos'"'

local Urbano  "2301/2305 2310/2311 2314/2316 2320/2326 2398 4845"
local Gasolina_para_veiculo_proprio  "2307"
local Alcool_para_veiculo_proprio  "2306"
local Manutencao_de_veiculo_proprio  "4301/4308 4312 4314/4318 4320/4323 4326 4330/4332"
local Aquisicao_de_veiculos  "5012 5101/5113 5120/5124 5151"
local Viagens  "4101/4105 4107/4124 4198"
local Outros_transporte  "2308/2309 2312/2313 2317/2318 4309/4311 4313 4319 4324/4325 4327/4329 4333/4335 4398 5003 5005/5008 5010 5098"
local Transporte  `"`Urbano' `Gasolina_para_veiculo_proprio' `Alcool_para_veiculo_proprio'  `Manutencao_de_veiculo_proprio' `Aquisicao_de_veiculos' `Viagens' `Outros_transporte'"'

local Perfume  "3002"
local Produtos_para_cabelo  "9604"
local Sabonete  "9603 9614"
local Produtos_de_uso_pessoal  "3001 3003/3010 3013/3024 3098 9601/9602 9605/9609 9611/9613 9615/9616"
local Higiene_e_cuidados_pessoais  `"`Perfume' `Produtos_para_cabelo' `Sabonete' `Produtos_de_uso_pessoal'"'

local Remedios  "2901/2937 2974"
local Plano_seguro_saude  "4214 4225 4231"
local Consulta_e_tratamento_dentario  "4203/4204"
local Consulta_medica  "4201"
local Tratamento_ambulatorial  "4210 4215 4220"
local Servicos_de_cirurgia  "4205"
local Hospitalizacao  "4206"
local Exames_diversos  "4207/4209 4221 4230 4232/4233"
local Material_de_tratamento  "2951 2954/2960 2962/2967 2969/2973 2975/2978 2980/2982 4211/4212 4223 4227/4228 4234"
local Outras_assistencia_saude  "2952/2953 2961 2968 2979 2998 4202 4213 4216/4219 4222 4229 4298"
local Assistencia_a_saude  `"`Remedios' `Plano_seguro_saude' `Consulta_e_tratamento_dentario' `Consulta_medica' `Tratamento_ambulatorial' `Servicos_de_cirurgia' `Hospitalizacao' `Exames_diversos' `Material_de_tratamento' `Outras_assistencia_saude' "'

local Cursos_regulares  "4901 4931/4932"
local Curso_superior  "4933"
local Outros_cursos  "4902 4911 4915 4922/4923 4934/4941 4943/4944 4947/4950 4959"
local Livros_e_revistas_tecnicas  "4906/4908 4945"
local Artigos_escolares  "3201/3203 3209 3212/3213 3298 4919/4921 4925 4929"
local Outras_educacao  "4803 4813 4847 4903/4905 4909/4910 4912 4914 4916/4918 4924 4927/4928 4930 4942 4946 4998"
local Educacao  `"`Cursos_regulares' `Curso_superior' `Outros_cursos' `Livros_e_revistas_tecnicas' `Artigos_escolares' `Outras_educacao'"'

local Brinquedos_e_jogos  "3301 3303/3305 3314 3316 3320"
local Celular_e_acessorios  "1672 1677"
local Periodicos_livros_e_revistas  "2701/2703 3204/3205"
local Diversoes_e_esportes  "2801/2822 2825 2828/2854 2898 3302 3307/3308 3317"
local Outras_recreacao_etc  "1601 1605/1609 1611 1618 1643 1671 1678 1690 2704/2705 2798 3306 3309/3313 3315 3318/3319 3321 3398"
local Recreacao_e_cultura  `"`Brinquedos_e_jogos' `Celular_e_acessorios' `Periodicos_livros_e_revistas' `Diversoes_e_esportes' `Outras_recreacao_etc'"'

local Fumo  "2501 2503/2505 2507 2509/2518 2598 4060/4061 4071/4072"
local Cabeleireiro  "3101/3102 3148"
local Manicuro_e_pedicuro  "3103"
local Consertos_de_artigos_pessoais  "3104 3110 3113/3116 3118 3120/3124 3126/3127 3129/3131 3133 3140"
local Outras_servicos_pessoais  "3105/3109 3111/3112 3117 3119 3125 3128 3132 3135/3139 3141 3198"
local Servicos_pessoais  `"`Cabeleireiro' `Manicuro_e_pedicuro' `Consertos_de_artigos_pessoais' `Outras_servicos_pessoais'"'

local Jogos_e_apostas  "2601/2610 2612/2616 2698"
local Comunicacao  "2201/2202 2298"
local Cerimonias_e_festas  "4501/4510 4598"
local Servicos_profissionais  "4401/4418"
local Imoveis_de_uso_ocasional  "4702/4704 4706/4708 4713 4796"
local Outras_despesas_diversas  "1204 1220 1301/1304 1306/1308 1310/1312 1315/1319 1398 1640 3206/3208 3210/3211 3707 3722 4002 4005/4007 4009 4011 4022/4023 4025/4026 4029/4031 4034/4036 4038 4042/4043 4049 4069 4098 4498 9591/9594 9599"
local Despesas_diversas  `"`Jogos_e_apostas' `Comunicacao' `Cerimonias_e_festas' `Servicos_profissionais' `Imoveis_de_uso_ocasional' `Outras_despesas_diversas'"'

local Impostos  "1014 1022/1023 4705 4711/4712 4714 4838 4846 5001/5002 5004 5009 5701/5706 5801/5806"
local Contribuicoes_trabalhistas  "1951/1980 1998 4801 4818 4826 4839 5601/5606"
local Servicos_bancarios  "4809/4810 4833/4837 4848 4861"
local Pensoes_mesadas_e_doacoes  "4802 4804/4805 4821/4824 4840 4843 5011"
local Previdencia_privada  "4806 5311/5312"
local Outras_despesas  "4807/4808 4814 4817 4819 4825 4828/4832 4841 4898"
local Outras_despesas_correntes  `"`Impostos' `Contribuicoes_trabalhistas' `Servicos_bancarios' `Pensoes_mesadas_e_doacoes' `Previdencia_privada' `Outras_despesas'"'

local Imovel_aquisicao  "1201/1202 4701"
local Imovel_reforma  "0801/0873 0898"
local Outros_investimentos  "1639 1673 1689 4609 4710 4820 4842"
local Aumento_do_ativo  `"`Imovel_aquisicao' `Imovel_reforma' `Outros_investimentos'"'

local Emprestimo_e_carne  "4811/4812 4815 4827"
local Prestacao_de_imovel  "1007 1017"
local Diminuicao_do_passivo  `"`Emprestimo_e_carne' `Prestacao_de_imovel'"'

local listaDDI `"Aluguel "`Aluguel'" Servicos_e_taxas "`Servicos_e_taxas'" Manutencao_do_lar "`Manutencao_do_lar'" Artigos_de_limpeza "`Artigos_de_limpeza'" Mobiliarios_e_artigos_do_lar "`Mobiliarios_e_artigos_do_lar'" Eletrodomesticos "`Eletrodomesticos'" Consertos_de_artigos_do_lar "`Consertos_de_artigos_do_lar'" Roupa_de_homem "`Roupa_de_homem'" Roupa_de_mulher "`Roupa_de_mulher'" Roupa_de_crianca "`Roupa_de_crianca'" Calcados_e_apetrechos "`Calcados_e_apetrechos'" Joias_e_bijuterias "`Joias_e_bijuterias'" Tecidos_e_armarinhos "`Tecidos_e_armarinhos'" Urbano "`Urbano'" Gasolina_para_veiculo_proprio "`Gasolina_para_veiculo_proprio'" Alcool_para_veiculo_proprio "`Alcool_para_veiculo_proprio'"  Manutencao_de_veiculo_proprio "`Manutencao_de_veiculo_proprio'" Aquisicao_de_veiculos "`Aquisicao_de_veiculos'" Viagens "`Viagens'" Outros_transporte "`Outros_transporte'" Perfume "`Perfume'" Produtos_para_cabelo "`Produtos_para_cabelo'" Sabonete "`Sabonete'" Produtos_de_uso_pessoal "`Produtos_de_uso_pessoal'" Remedios "`Remedios'" Plano_seguro_saude "`Plano_seguro_saude'" Consulta_e_tratamento_dentario "`Consulta_e_tratamento_dentario'" Consulta_medica "`Consulta_medica'" Tratamento_ambulatorial "`Tratamento_ambulatorial'" Servicos_de_cirurgia "`Servicos_de_cirurgia'" Hospitalizacao "`Hospitalizacao'" Exames_diversos "`Exames_diversos'" Material_de_tratamento "`Material_de_tratamento'" Outras_assistencia_saude "`Outras_assistencia_saude'" Cursos_regulares "`Cursos_regulares'" Curso_superior "`Curso_superior'" Outros_cursos "`Outros_cursos'" Livros_e_revistas_tecnicas "`Livros_e_revistas_tecnicas'" Artigos_escolares "`Artigos_escolares'" Outras_educacao "`Outras_educacao'" Brinquedos_e_jogos "`Brinquedos_e_jogos'" Celular_e_acessorios "`Celular_e_acessorios'" Periodicos_livros_e_revistas "`Periodicos_livros_e_revistas'" Diversoes_e_esportes "`Diversoes_e_esportes'" Outras_recreacao_etc "`Outras_recreacao_etc'" Fumo "`Fumo'" Cabeleireiro "`Cabeleireiro'" Manicuro_e_pedicuro "`Manicuro_e_pedicuro'" Consertos_de_artigos_pessoais "`Consertos_de_artigos_pessoais'" Outras_servicos_pessoais "`Outras_servicos_pessoais'" Jogos_e_apostas "`Jogos_e_apostas'" Comunicacao "`Comunicacao'" Cerimonias_e_festas "`Cerimonias_e_festas'" Servicos_profissionais "`Servicos_profissionais'" Imoveis_de_uso_ocasional "`Imoveis_de_uso_ocasional'" Outras_despesas_diversas "`Outras_despesas_diversas'" Impostos "`Impostos'" Contribuicoes_trabalhistas "`Contribuicoes_trabalhistas'" Servicos_bancarios "`Servicos_bancarios'" Pensoes_mesadas_e_doacoes "`Pensoes_mesadas_e_doacoes'" Previdencia_privada "`Previdencia_privada'" Outras_despesas "`Outras_despesas'" Imovel_aquisicao "`Imovel_aquisicao'" Imovel_reforma "`Imovel_reforma'" Outros_investimentos "`Outros_investimentos'" Emprestimo_e_carne "`Emprestimo_e_carne'" Prestacao_de_imovel "`Prestacao_de_imovel'""'

* Rendimentos (REN)
local Empregado  "5301/5304 5331/5333 5401/5402 5445 5447"
local Empregador  "5304"
local Conta_propria  "5306"
local Aposentadoria_prev_publica  "5311 5429"
local Aposentadoria_prev_privada  "5312 5440 5457"
local Bolsa_de_estudo  "5313"
local Pensao_aliment_mesada_doacao  "5314"
local Transferencias_transitorias  "5335/5339 5341 5405/5407 5412/5413 5423/5424 5426/5428 5432 5436 5438 5443"
local Transferencia  `"`Aposentadoria_prev_publica' `Aposentadoria_prev_privada' `Bolsa_de_estudo' `Pensao_aliment_mesada_doacao' `Transferencias_transitorias'"'

local Aluguel_de_bens_imoveis  "5321"
local Aluguel_de_bens_moveis  "5322"
local Rendimento_de_aluguel  `"`Aluguel_de_bens_imoveis' `Aluguel_de_bens_moveis'"'
local Vendas_esporadicas  "5408/5409 5416 5444 5448/5452 5491"
local Empréstimos  "5414 5425 5431"
local Aplicacoes_de_capital  "5415 5435 5446"	
local Outros_renda  "5403/5404 5410 5430 5434 5439 5441 5453/5456 5458/5459 5492 5497 5514"
local Outros_rendimentos `"`Vendas_esporadicas' `Empréstimos' `Aplicacoes_de_capital' `Outros_renda'"'
local listaREN `" Empregado "`Empregado'" Empregador "`Empregador'" Conta_propria  "`Conta_propria'" Aposentadoria_prev_publica "`Aposentadoria_prev_publica'" Aposentadoria_prev_privada "`Aposentadoria_prev_privada'" Bolsa_de_estudo "`Bolsa_de_estudo'" Pensao_aliment_mesada_doacao "`Pensao_aliment_mesada_doacao'" Transferencias_transitorias "`Transferencias_transitorias'" Rendimento_de_aluguel "`Rendimento_de_aluguel'" Outros_rendimentos "`Outros_rendimentos'""'
local Rendimento_nao_monetario

tempfile pof95 p11

forvalues i = 1/`: word count `trs''{
	local tr: word `i' of `trs'
	local base: word `i' of `temps'
	
	use `base', clear
	
	if "`tr'" == "tr3" {
		rename v3037 cod_item_aux  
		rename v3098 val_def_anual 
	}
	if "`tr'" == "tr4" {
		rename v4200 cod_item_aux  
		rename v4290 val_def_anual 
	}
	if "`tr'" == "tr6" {
		rename v6050 cod_item_aux  
		rename v6110 val_def_anual 
	}
	if "`tr'" == "tr7" {
		rename v7050 cod_item_aux  
		rename v7100 val_def_anual 
	}
	if "`tr'" == "tr8" {
		rename v8050 ordem 
		rename v8060 cod_item_aux  
		rename v8095 val_def_anual 
	}
	if "`tr'" == "tr9" {
		rename v9045 ordem 
		rename v9050 cod_item_aux  
		rename v9093 val_def_anual 
	}
	if "`tr'" == "tr10" {
		rename v1005 ordem 
		rename v1006 cod_item_aux  
		rename v1071 val_def_anual 
	}
	if "`tr'" == "tr11" {
		preserve
		keep v0020 v0040 v0050 v0060 v0065 v0067 v1105 v1106 v1105 v1106 v1165
		rename v1105 ordem 
		rename v1106 cod_item_aux 
		rename v1165 val_def_anual
		save `p11', replace
		restore

		preserve
		keep v0020 v0040 v0050 v0060 v0065 v0067 v1105 v1106 v1105 v1106 v1185
		rename v1105 ordem 
		rename v1106 cod_item_aux 
		rename v1185 val_def_anual
		replace cod_item_aux = cod_item_aux + 300 
		append using `p11'
		save `p11', replace
		restore

		preserve
		keep v0020 v0040 v0050 v0060 v0065 v0067 v1105 v1106 v1105 v1106 v1194
		rename v1105 ordem 
		rename v1106 cod_item_aux 
		rename v1194 val_def_anual
		replace cod_item_aux = cod_item_aux + 400 
		append using `p11'
		save `p11', replace
		restore

		keep v0020 v0040 v0050 v0060 v0065 v0067 v1105 v1106 v1105 v1106 v1198
		rename v1105 ordem 
		rename v1106 cod_item_aux 
		rename v1198 val_def_anual
		replace cod_item_aux = cod_item_aux + 500 
		append using `p11'
	}
	if "`tr'" == "tr12" {
		rename v1205 ordem 
		rename v1206 cod_item_aux  
		rename v1235 val_def_anual 
	}
	
	cap append using `pof95'
	qui save `pof95', replace
	
}

keep v0020 v0040 v0050 v0060 v0065 v0067 ordem cod_item_aux val_def_anual

end
