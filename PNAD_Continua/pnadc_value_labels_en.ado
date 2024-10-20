program define pnadc_value_labels_en
capture {
label define label_Capital 11 "Municipality of Porto Velho (RO)" 12 "Municipality of Rio Branco (AC)" 13 "Municipality of Manaus (AM)" 14 "Municipality of Boa Vista (RR)" 15 "Municipality of Belém (PA)" 16 "Municipality of Macapá (AP)" 17 "Municipality of Palmas (TO)" 21 "Municipality of São Luís (MA)" 22 "Municipality of Teresina (PI)" 23 "Municipality of Fortaleza (CE)" 24 "Municipality of Natal (RN)" 25 "Municipality of João Pessoa (PB)" 26 "Municipality of Recife (PE)" 27 "Municipality of Maceió (AL)" 28 "Municipality of Aracaju (SE)" 29 "Municipality of Salvador (BA)" 31 "Municipality of Belo Horizonte (MG)" 32 "Municipality of Vitória (ES)" 33 "Municipality of Rio de Janeiro (RJ)" 35 "Municipality of São Paulo (SP)" 41 "Municipality of Curitiba (PR)" 42 "Municipality of Florianópolis (SC)" 43 "Municipality of Porto Alegre (RS)" 50 "Municipality of Campo Grande (MS)" 51 "Municipality of Cuiabá (MT)" 52 "Municipality of Goiânia (GO)" 53 "Municipality of Brasília (DF)" 
label define label_RM_RIDE 13 "Metropolitan Region of Manaus (AM)" 15 "Metropolitan Region of Belém (PA)" 16 "Metropolitan Region of Macapá (AP)" 21 "Metropolitan Region of Greater São Luís (MA)" 22 "Integrated Administrative Region for the Development of Greater Teresina (PI)" 23 "Metropolitan Region of Fortaleza (CE)" 24 "Metropolitan Region of Natal (RN)" 25 "Metropolitan Region of João Pessoa (PB)" 26 "Metropolitan Region of Recife (PE)" 27 "Metropolitan Region of Maceió (AL)" 28 "Aracaju Metropolitan Region (SE)" 29 "Metropolitan Region of Salvador (BA)" 31 "Belo Horizonte Metropolitan Region (MG)" 32 "Metropolitan Region of Greater Vitória (ES)" 33 "Metropolitan Region of Rio de Janeiro (RJ)" 35 "Metropolitan Region of São Paulo (SP)" 41 "Metropolitan Region of Curitiba (PR)" 42 "Metropolitan Region of Florianópolis (SC)" 43 "Metropolitan Region of Porto Alegre (RS)" 51 "Cuiabá River Valley Metropolitan Region (MT)" 52 "Metropolitan Region of Goiânia (GO)" 
label define label_UF 11 "Rondônia" 12 "Acre" 13 "Amazonas" 14 "Roraima" 15 "Pará" 16 "Amapá" 17 "Tocantins" 21 "Maranhão" 22 "Piauí" 23 "Ceará" 24 "Rio Grande do Norte" 25 "Paraíba" 26 "Pernambuco" 27 "Alagoas" 28 "Sergipe" 29 "Bahia" 31 "Minas Gerais" 32 "Espírito Santo" 33 "Rio de Janeiro" 35 "São Paulo" 41 "Paraná" 42 "Santa Catarina" 43 "Rio Grande do Sul" 50 "Mato Grosso do Sul" 51 "Mato Grosso" 52 "Goiás" 53 "Distrito Federal" 
label define label_V1022 1 "Urban" 2 "Rural" 
label define label_V1023 1 "Capital" 2 "Rest of the RM (Metropolitan Region, excluding the capital)" 3 "Rest of RIDE (Integrated Economic Development Region, excluding the capital)" 4 "Rest of UF (Federation Unit, excluding the metropolitan region and RIDE)" 
label define label_V2005 1 "Person responsible for the household" 2 "Spouse or partner of a different sex" 3 "Spouse or same-sex partner" 4 "Child of guardian and spouse" 5 "Child of guardian only" 6 "Stepchild" 7 "Son-in-law or daughter-in-law" 8 "Father, mother, stepfather or stepmother" 9 "Father-in-law" 10 "Grandson" 11 "Great-grandchild" 12 "Brother or sister" 13 "Grandfather or grandmother" 14 "Another relative" 15 "Household member - Non-relative who does not share expenses" 16 "Cohabitant - Non-relative who shares expenses" 17 "Pensioner" 18 "Domestic worker" 19 "Relative of the domestic worker" 
label define label_V2007 1 "Man" 2 "Woman" 
label define label_V2008 99 "Not informed" 
label define label_V20081 99 "Not informed" 
label define label_V20082 9999 "Not informed" 
label define label_V2010 1 "White" 2 "Black" 3 "Yellow" 4 "Brown" 5 "Indigenous" 9 "Ignored" 
label define label_V3001 1 "Yes" 2 "No" 
label define label_V3002 1 "Yes" 2 "No" 
label define label_V3002A 1 "Private network" 2 "Public network" 
label define label_V3003 1 "Pre-school (nursery and kindergarten)" 2 "Literacy for young people and adults" 3 "Regular elementary school" 4 "Youth and adult education (EJA) or elementary school supplementary education" 5 "Regular high school" 6 "Youth and adult education (EJA) or high school supplementary education" 7 "Higher education - undergraduate" 8 "Master's Degree" 9 "Doctorate" 
label define label_V3003A 1 "Crèche (only available in the annual education questionnaire)" 2 "Pre-school" 3 "Literacy for young people and adults" 4 "Regular elementary school" 5 "Youth and adult education (EJA) in elementary school" 6 "Regular high school" 7 "Youth and adult education (EJA) in high school" 8 "Higher education - undergraduate" 9 "Higher level specialization" 10 "Master's Degree" 11 "Doctorate" 
label define label_V3004 1 "8 years" 2 "9 years" 
label define label_V3005 1 "Yes" 2 "No" 
label define label_V3005A 1 "Semester periods" 2 "Years" 3 "Another way" 
label define label_V3006 1 "First" 2 "Monday" 3 "Third" 4 "Wednesday" 5 "Thursday" 6 "Friday" 7 "Seventh" 8 "Eighth" 9 "Ninth" 10 "Tenth" 11 "Eleventh" 12 "Twelfth" 13 "Course not classified into grades or years" 
label define label_V3006A 1 "Early years (first segment)" 2 "Final years (second segment)" 
label define label_V3007 1 "Yes" 2 "No" 
label define label_V3008 1 "Yes" 2 "No" 
label define label_V3009 1 "Literacy class - CA" 2 "Literacy for young people and adults" 3 "Old primary (elementary)" 4 "Former gymnasium (middle school)" 5 "Regular elementary or junior high school" 6 "Youth and adult education (EJA) or elementary school supplementary education" 7 "Ancient scientific, classical, etc. (middle 2nd cycle)" 8 "Regular high school or secondary school" 9 "Youth and adult education (EJA) or high school supplementary education" 10 "Higher education - undergraduate" 11 "Master's Degree" 12 "Doctorate" 
label define label_V3009A 1 "Crèche (only available in the annual education questionnaire)" 2 "Pre-school" 3 "Literacy class - CA" 4 "Literacy for young people and adults" 5 "Old primary (elementary)" 6 "Former gymnasium (middle school)" 7 "Regular elementary or junior high school" 8 "Youth and adult education (EJA) or primary school supplementary education" 9 "Ancient scientific, classical, etc. (middle 2nd cycle)" 10 "Regular high school or secondary school" 11 "Youth and adult education (EJA) or high school supplementary education" 12 "Higher education - undergraduate" 13 "Higher level specialization" 14 "Master's Degree" 15 "Doctorate" 
label define label_V3010 1 "8 years" 2 "9 years" 
label define label_V3011 1 "Yes" 2 "No" 
label define label_V3011A 1 "Semester periods" 2 "Years" 3 "Another way" 
label define label_V3012 1 "He concluded" 2 "Not concluded" 3 "Course not classified into grades or years" 
label define label_V3013 1 "First" 2 "Monday" 3 "Third" 4 "Wednesday" 5 "Thursday" 6 "Friday" 7 "Seventh" 8 "Eighth" 9 "Ninth" 10 "Tenth" 11 "Eleventh" 12 "Twelfth" 
label define label_V3013A 1 "Early years (first segment)" 2 "Final years (second segment)" 
label define label_V3013B 1 "Yes" 2 "No" 
label define label_V3014 1 "Yes" 2 "No" 
label define label_V4001 1 "Yes" 2 "No" 
label define label_V4002 1 "Yes" 2 "No" 
label define label_V4003 1 "Yes" 2 "No" 
label define label_V4004 1 "Yes" 2 "No" 
label define label_V4005 1 "Yes" 2 "No" 
label define label_V4006 1 "Vacations, time off or variable working hours" 2 "Maternity leave" 3 "Paid leave due to own illness or accident" 4 "Another type of paid leave (study, paternity, marriage, premium leave, etc.)" 5 "Leave from own business/company due to pregnancy, illness, accident, etc., without being paid by a social security institution" 6 "Occasional factors (weather, stoppage of transport services, etc.)" 7 "Strike or stoppage" 8 "Another reason" 
label define label_V4006A 1 "Vacations, time off or variable working hours" 2 "Maternity or paternity leave" 3 "Paid leave due to own health or accident" 4 "Another type of paid leave (study, marriage, premium leave, etc.)" 5 "Leave from own business/company due to pregnancy, illness, accident, etc., without being paid by a social security institution" 6 "Occasional factors (weather, stoppage of transport services, etc.)" 7 "Another reason" 
label define label_V4007 1 "Yes" 2 "No" 
label define label_V4008 1 "Less than 1 month" 2 "From 1 month to less than 1 year" 3 "From 1 year to less than 2 years" 4 "2 years or more" 
label define label_V4009 1 "One" 2 "Two" 3 "Three or more" 
label define label_V4012 1 "Domestic workers" 2 "Military personnel from the army, navy, air force, military police or military fire department" 3 "Private sector employee" 4 "Public sector employee (including mixed-capital companies)" 5 "Employer" 6 "Own account" 7 "Unpaid family worker" 
label define label_V40121 1 "Helping your own account or employer" 2 "Helping employees" 3 "Helping domestic workers" 
label define label_V40132 1 "Agriculture, livestock farming, forestry, fishing or aquaculture" 2 "Other activity, including activities in support of agriculture, livestock, forestry, logging, fishing or aquaculture." 
label define label_V40132A 1 "Agriculture, animal husbandry, forestry, fishing or aquaculture and support activities for agriculture, animal husbandry, forestry, fishing or aquaculture." 2 "Another activity" 
label define label_V4014 1 "Federal" 2 "State" 3 "Municipal" 
label define label_V4015 1 "Yes" 2 "No" 
label define label_V40151 1 "1 to 5 unpaid workers" 2 "6 to 10 unpaid workers" 3 "11 or more unpaid workers" 
label define label_V4016 1 "1 to 5 employees" 2 "6 to 10 employees" 3 "11 to 50 employees" 4 "51 or more employees" 
label define label_V4017 1 "Yes" 2 "No" 
label define label_V40171 1 "1 to 5 partners" 2 "6 or more members" 
label define label_V4018 1 "1 to 5 people" 2 "6 to 10 people" 3 "11 to 50 people" 4 "51 or more people" 
label define label_V4019 1 "Yes" 2 "No" 
label define label_V4020 1 "In a store, office, shed, etc." 2 "On a farm, ranch, farmhouse, etc." 3 "There was no establishment to operate" 
label define label_V4021 1 "Yes" 2 "No" 
label define label_V4022 1 "In another business/company's establishment" 2 "At a location designated by the employer, client or customer" 3 "At the home of an employer, boss, partner or customer" 4 "At home, in an exclusive place for carrying out the activity" 5 "At home, without an exclusive place to carry out the activity" 6 "In a motor vehicle (cab, bus, truck, car, boat, etc.)" 7 "On a public road or area (street, river, mangrove swamp, public forest, square, beach, etc.)" 8 "Elsewhere, please specify" 
label define label_V4024 1 "Yes" 2 "No" 
label define label_V4025 1 "Yes" 2 "No" 
label define label_V4026 1 "Yes" 2 "No" 
label define label_V4027 1 "Yes" 2 "No" 
label define label_V4028 1 "Yes" 2 "No" 
label define label_V4029 1 "Yes" 2 "No" 
label define label_V4032 1 "Yes" 2 "No" 
label define label_V4033 1 "Indicates whether the question has been answered" 
label define label_V40331 1 "In cash" 
label define label_V403311 1 "1 to [0.5SM]" 2 "[0.5SM]+1 to [1SM]" 3 "[1SM]+1 to [2SM]" 4 "[2SM]+1 to [3SM]" 5 "[3SM]+1 to [5SM]" 6 "[5SM]+1 to [10SM]" 7 "[10SM]+1 to [20SM]" 8 "[20SM]+1 or more" 
label define label_V40332 2 "In products or goods" 
label define label_V403321 1 "1 to [0.5SM]" 2 "[0.5SM]+1 to [1SM]" 3 "[1SM]+1 to [2SM]" 4 "[2SM]+1 to [3SM]" 5 "[3SM]+1 to [5SM]" 6 "[5SM]+1 to [10SM]" 7 "[10SM]+1 to [20SM]" 8 "[20SM]+1 or more" 
label define label_V40333 3 "In benefits" 
label define label_V403331 1 "Person receiving benefits only, except apprenticeship" 2 "Apprentice or trainee receiving apprenticeship and other benefits" 3 "Apprentice or trainee receiving only apprenticeship pay" 
label define label_V4034 1 "Indicates whether the question has been answered" 
label define label_V40341 1 "In cash" 
label define label_V403411 0 "0" 1 "1 to [0.5SM]" 2 "[0.5SM]+1 to [1SM]" 3 "[1SM]+1 to [2SM]" 4 "[2SM]+1 to [3SM]" 5 "[3SM]+1 to [5SM]" 6 "[5SM]+1 to [10SM]" 7 "[10SM]+1 to [20SM]" 8 "[20SM]+1 or more" 
label define label_V40342 2 "In products or goods" 
label define label_V403421 0 "0" 1 "1 to [0.5SM]" 2 "[0.5SM]+1 to [1SM]" 3 "[1SM]+1 to [2SM]" 4 "[2SM]+1 to [3SM]" 5 "[3SM]+1 to [5SM]" 6 "[5SM]+1 to [10SM]" 7 "[10SM]+1 to [20SM]" 8 "[20SM]+1 or more" 
label define label_V4040 1 "Less than 1 month" 2 "From 1 month to less than 1 year" 3 "From 1 year to less than 2 years" 4 "2 years or more" 
label define label_V4043 1 "Domestic workers" 2 "Military of the army, navy, air force, military police or military fire department" 3 "Private sector employee" 4 "Public sector employee (including mixed-capital companies)" 5 "Employer" 6 "Own account" 7 "Unpaid worker helping a household member or relative" 
label define label_V40431 1 "Helping your own account or employer" 2 "Helping employees" 3 "Helping domestic workers" 
label define label_V4045 1 "Federal" 2 "State" 3 "Municipal" 
label define label_V4046 1 "Yes" 2 "No" 
label define label_V4047 1 "Yes" 2 "No" 
label define label_V4048 1 "Yes" 2 "No" 
label define label_V4049 1 "Yes" 2 "No" 
label define label_V4050 1 "Indicates whether the question has been answered" 
label define label_V40501 1 "In cash" 
label define label_V405011 1 "1 to [0.5SM]" 2 "[0.5SM]+1 to [1SM]" 3 "[1SM]+1 to [2SM]" 4 "[2SM]+1 to [3SM]" 5 "[3SM]+1 to [5SM]" 6 "[5SM]+1 to [10SM]" 7 "[10SM]+1 to [20SM]" 8 "[20SM]+1 or more" 
label define label_V40502 2 "In products or goods" 
label define label_V405021 1 "1 to [0.5SM]" 2 "[0.5SM]+1 to [1SM]" 3 "[1SM]+1 to [2SM]" 4 "[2SM]+1 to [3SM]" 5 "[3SM]+1 to [5SM]" 6 "[5SM]+1 to [10SM]" 7 "[10SM]+1 to [20SM]" 8 "[20SM]+1 or more" 
label define label_V40503 3 "In benefits" 
label define label_V405031 1 "Person receiving benefits only, except apprenticeship" 2 "Apprentice or trainee receiving apprenticeship and other benefits" 3 "Apprentice or trainee receiving only apprenticeship pay" 
label define label_V4051 1 "Indicates whether the question has been answered" 
label define label_V40511 1 "In cash" 
label define label_V405111 0 "0" 1 "1 to [0.5SM]" 2 "[0.5SM]+1 to [1SM]" 3 "[1SM]+1 to [2SM]" 4 "[2SM]+1 to [3SM]" 5 "[3SM]+1 to [5SM]" 6 "[5SM]+1 to [10SM]" 7 "[10SM]+1 to [20SM]" 8 "[20SM]+1 or more" 
label define label_V40512 2 "Products or goods" 
label define label_V405121 0 "0" 1 "1 to [0.5SM]" 2 "[0.5SM]+1 to [1SM]" 3 "[1SM]+1 to [2SM]" 4 "[2SM]+1 to [3SM]" 5 "[3SM]+1 to [5SM]" 6 "[5SM]+1 to [10SM]" 7 "[10SM]+1 to [20SM]" 8 "[20SM]+1 or more" 
label define label_V4057 1 "Yes" 2 "No" 
label define label_V4058 1 "Indicates whether the question has been answered" 
label define label_V40581 1 "In cash" 
label define label_V405811 1 "1 to [0.5SM]" 2 "[0.5SM]+1 to [1SM]" 3 "[1SM]+1 to [2SM]" 4 "[2SM]+1 to [3SM]" 5 "[3SM]+1 to [5SM]" 6 "[5SM]+1 to [10SM]" 7 "[10SM]+1 to [20SM]" 8 "[20SM]+1 or more" 
label define label_V40582 2 "In products or goods" 
label define label_V405821 1 "1 to [0.5SM]" 2 "[0.5SM]+1 to [1SM]" 3 "[1SM]+1 to [2SM]" 4 "[2SM]+1 to [3SM]" 5 "[3SM]+1 to [5SM]" 6 "[5SM]+1 to [10SM]" 7 "[10SM]+1 to [20SM]" 8 "[20SM]+1 or more" 
label define label_V40583 3 "In benefits" 
label define label_V405831 1 "Person receiving benefits only, except apprenticeship" 2 "Apprentice or trainee receiving apprenticeship and other benefits" 3 "Apprentice or trainee receiving only apprenticeship pay" 
label define label_V40584 4 "Unpaid" 
label define label_V4059 1 "Indicates whether the question has been answered" 
label define label_V40591 1 "In cash" 
label define label_V405911 0 "0" 1 "1 to [0.5SM]" 2 "[0.5SM]+1 to [1SM]" 3 "[1SM]+1 to [2SM]" 4 "[2SM]+1 to [3SM]" 5 "[3SM]+1 to [5SM]" 6 "[5SM]+1 to [10SM]" 7 "[10SM]+1 to [20SM]" 8 "[20SM]+1 or more" 
label define label_V40592 2 "In products or goods" 
label define label_V405921 0 "0" 1 "1 to [0.5SM]" 2 "[0.5SM]+1 to [1SM]" 3 "[1SM]+1 to [2SM]" 4 "[2SM]+1 to [3SM]" 5 "[3SM]+1 to [5SM]" 6 "[5SM]+1 to [10SM]" 7 "[10SM]+1 to [20SM]" 8 "[20SM]+1 or more" 
label define label_V4063 1 "Yes" 2 "No" 
label define label_V4063A 1 "Yes" 2 "No" 
label define label_V4064 1 "Yes" 2 "No" 
label define label_V4064A 1 "Yes" 2 "No" 
label define label_V4071 1 "Yes" 2 "No" 
label define label_V4072 1 "Came into direct contact with employer (at factory, farm, market, store or other workplace)" 2 "Took part in or entered a competition" 3 "Consulted a private agency or union" 4 "Consulted a municipal or state agency or the National Employment System (SINE)" 5 "Posted or answered ad" 6 "Consulted a relative, friend or colleague" 7 "He sought financial help to start his own business" 8 "Looking for premises, equipment or machinery to start their own business" 9 "Applied for registration or a license to start their own business" 10 "He took another step" 11 "No effective action taken" 
label define label_V4072A 1 "Contacted the employer (in person, by phone, by email or through the company portal, including sending a CV)" 2 "Placed or answered a job advertisement in a newspaper or magazine" 3 "Consulted or registered with a private employment agency or trade union" 4 "Consulted or registered with a municipal or state employment agency or the National Employment System (SINE)" 5 "Took part in or entered a competition" 6 "Consulted a relative, friend or colleague" 7 "Have you taken steps to start your own business (financial resources, premises, equipment, legalization, etc.)?" 8 "Have you taken any other action?" 9 "No effective action taken" 
label define label_V4073 1 "Yes" 2 "No" 
label define label_V4074 1 "Got a job offer to start after the reference week" 2 "Waiting for an answer on the measures taken to get a job" 3 "Gave up looking because they couldn't find a job" 4 "You think you won't find work because you're too young or too old" 5 "Had to look after child(ren), other dependents or household chores" 6 "Study" 7 "Physical or mental incapacity or permanent illness" 8 "Another reason" 
label define label_V4074A 1 "Got a job offer to start after the reference week" 2 "I was waiting for an answer on the measures I had taken to get a job" 3 "I couldn't find suitable work" 4 "No professional experience or qualifications" 5 "I couldn't get a job because I was considered too young or too old" 6 "There was no work in the area" 7 "Had to take care of household chores, child(ren) or other relative(s)" 8 "I was studying (any kind of course or on my own)" 9 "Health problems or pregnancy" 10 "Other reason, please specify" 
label define label_V4075A 1 "Less than 1 month" 2 "From 1 month to less than 1 year" 3 "1 year or more" 
label define label_V4076 1 "Less than 1 month" 2 "From 1 month to less than 1 year" 3 "From 1 year to less than 2 years" 4 "2 years or more" 
label define label_V4077 1 "Yes" 2 "No" 
label define label_V4078 1 "Had to look after child(ren), other dependents or household chores" 2 "Study" 3 "Physical or mental incapacity or permanent illness" 4 "Retired or elderly to work" 5 "Too young to work" 6 "I didn't want to work" 7 "Another reason" 
label define label_V4078A 1 "Had to take care of household chores, child(ren) or other relative(s)" 2 "I was studying (in a course of any kind or on my own)" 3 "Health problems or pregnancy" 4 "Being too young or too old to work" 5 "For not wanting to work" 6 "Other reason, please specify:" 
label define label_V4082 1 "Yes" 2 "No" 
label define label_VD2002 1 "Responsible person" 2 "Spouse or partner" 3 "Child" 4 "Stepchild" 5 "Son-in-law or daughter-in-law" 6 "Father, mother, stepfather or stepmother" 7 "Father-in-law" 8 "Grandson" 9 "Great-grandchild" 10 "Brother or sister" 11 "Grandfather or grandmother" 12 "Another relative" 13 "Aggregate" 14 "Cohabitant" 15 "Pensioner" 16 "Domestic worker" 17 "Relative of the domestic worker" 
label define label_VD2004 1 "Unipersonal" 2 "Nuclear" 3 "Extended" 4 "Compound" 
label define label_VD2006 1 "0 to 4 years" 2 "5 to 9 years" 3 "10 to 13 years" 4 "14 to 19 years old" 5 "20 to 24 years old" 6 "25 to 29 years old" 7 "30 to 34 years old" 8 "35 to 39 years old" 9 "40 to 44 years old" 10 "45 to 49 years old" 11 "50 to 54 years old" 12 "55 to 59 years old" 13 "60 to 64 years old" 14 "65 to 69 years" 15 "70 to 74 years" 16 "75 to 79 years" 17 "80 years and over" 
label define label_VD3004 1 "No education and less than 1 year of study" 2 "Elementary school incomplete or equivalent" 3 "Complete primary school or equivalent" 4 "Incomplete high school or equivalent" 5 "High school diploma or equivalent" 6 "Incomplete university degree or equivalent" 7 "Complete university degree" 
label define label_VD3005 0 "No education and less than 1 year of study" 1 "1 year of study" 2 "2 years of study" 3 "3 years of study" 4 "4 years of study" 5 "5 years of study" 6 "6 years of study" 7 "7 years of study" 8 "8 years of study" 9 "9 years of study" 10 "10 years of study" 11 "11 years of study" 12 "12 years of study" 13 "13 years of study" 14 "14 years of study" 15 "15 years of study" 16 "16 years or more of schooling" 
label define label_VD3006 1 "No education and less than 1 year of study" 2 "1 to 4 years of study" 3 "5 to 8 years of study" 4 "9 to 11 years of schooling" 5 "12 to 15 years of study" 6 "16 years or more of schooling" 
label define label_VD4001 1 "People in the workforce" 2 "People outside the workforce" 
label define label_VD4002 1 "Busy people" 2 "Unoccupied people" 
label define label_VD4003 1 "People outside the workforce and in the potential workforce" 2 "People outside the workforce and outside the potential workforce" 
label define label_VD4004 1 "Underemployed people" 
label define label_VD4004A 1 "Underemployed people" 
label define label_VD4005 1 "Discouraged people" 
label define label_VD4007 1 "Employee (including domestic worker)" 2 "Employer" 3 "Own account" 4 "Auxiliary family worker" 
label define label_VD4008 1 "Employed in the private sector" 2 "Domestic workers" 3 "Public sector employees (including civil servants and military personnel)" 4 "Employer" 5 "Self-accounting" 6 "Auxiliary family worker" 
label define label_VD4009 1 "Employed in the private sector with a formal contract" 2 "Employed in the private sector without a formal employment contract" 3 "Registered domestic workers" 4 "Domestic workers without a work permit" 5 "Employed in the public sector with a formal contract" 6 "Employees in the public sector without a formal employment contract" 7 "Military and civil servants" 8 "Employer" 9 "Self-accounting" 10 "Auxiliary family worker" 
label define label_VD4010 1 "Agriculture, livestock, forestry, fisheries and aquaculture" 2 "General industry" 3 "Construction" 4 "Trade, repair of motor vehicles and motorcycles" 5 "Transportation, storage and mail" 6 "Accommodation and food" 7 "Information, communication and financial, real estate, professional and administrative activities" 8 "Public administration, defense and social security" 9 "Education, human health and social services" 10 "Other Services" 11 "Domestic services" 12 "Poorly defined activities" 
label define label_VD4011 1 "Directors and managers" 2 "Science professionals and intellectuals" 3 "Technicians and mid-level professionals" 4 "Administrative support workers" 5 "Service workers, shop and market vendors" 6 "Skilled agricultural, forestry, hunting and fishing workers" 7 "Skilled workers, laborers and craftsmen in construction, the mechanical arts and other trades" 8 "Plant and machine operators and assemblers" 9 "Elementary occupations" 10 "Members of the armed forces, police and military firefighters" 11 "Ill-defined occupations" 
label define label_VD4012 1 "Taxpayer" 2 "Non-taxpayer" 
label define label_VD4013 1 "Up to 14 hours" 2 "15 to 39 hours" 3 "40 to 44 hours" 4 "45 to 48 hours" 5 "49 hours or more" 
label define label_VD4014 1 "Up to 14 hours" 2 "15 to 39 hours" 3 "40 to 44 hours" 4 "45 to 48 hours" 5 "49 hours or more" 
label define label_VD4015 1 "Remuneration in cash, products or goods for the main job" 2 "Pay in benefits or no pay in main job" 
label define label_VD4018 1 "Remuneration in cash, products or goods in at least one of the jobs" 2 "Remuneration in benefits or without remuneration in all jobs" 
label define label_VD4023 1 "Had to take care of household chores, child(ren) or other dependent(s)" 2 "I was studying" 3 "Physical or mental incapacity or permanent illness" 4 "Being too young or too old to work" 5 "For not wanting to work" 6 "For another reason" 
label define label_VD4030 1 "Had to take care of household chores, child(ren) or other relative(s)" 2 "I was studying" 3 "Health problems or pregnancy" 4 "Being too young or too old to work" 5 "For not wanting to work" 6 "For another reason" 
label define label_VD4036 1 "Up to 14 hours" 2 "15 to 39 hours" 3 "40 to 44 hours" 4 "45 to 48 hours" 5 "49 hours or more" 
label define label_VD4037 1 "Up to 14 hours" 2 "15 to 39 hours" 3 "40 to 44 hours" 4 "45 to 48 hours" 5 "49 hours or more" 
}
cap label values UF label_UF
cap label values Capital label_Capital
cap label values RM_RIDE label_RM_RIDE
cap label values V1022 label_V1022
cap label values V1023 label_V1023
cap label values V2005 label_V2005
cap label values V2007 label_V2007
cap label values V2008 label_V2008
cap label values V20081 label_V20081
cap label values V20082 label_V20082
cap label values V2010 label_V2010
cap label values V3001 label_V3001
cap label values V3002 label_V3002
cap label values V3002A label_V3002A
cap label values V3003 label_V3003
cap label values V3003A label_V3003A
cap label values V3004 label_V3004
cap label values V3005 label_V3005
cap label values V3005A label_V3005A
cap label values V3006 label_V3006
cap label values V3006A label_V3006A
cap label values V3007 label_V3007
cap label values V3008 label_V3008
cap label values V3009 label_V3009
cap label values V3009A label_V3009A
cap label values V3010 label_V3010
cap label values V3011 label_V3011
cap label values V3011A label_V3011A
cap label values V3012 label_V3012
cap label values V3013 label_V3013
cap label values V3013A label_V3013A
cap label values V3013B label_V3013B
cap label values V3014 label_V3014
cap label values V4001 label_V4001
cap label values V4002 label_V4002
cap label values V4003 label_V4003
cap label values V4004 label_V4004
cap label values V4005 label_V4005
cap label values V4006 label_V4006
cap label values V4006A label_V4006A
cap label values V4007 label_V4007
cap label values V4008 label_V4008
cap label values V4009 label_V4009
cap label values V4012 label_V4012
cap label values V40121 label_V40121
cap label values V40132 label_V40132
cap label values V40132A label_V40132A
cap label values V4014 label_V4014
cap label values V4015 label_V4015
cap label values V40151 label_V40151
cap label values V4016 label_V4016
cap label values V4017 label_V4017
cap label values V40171 label_V40171
cap label values V4018 label_V4018
cap label values V4019 label_V4019
cap label values V4020 label_V4020
cap label values V4021 label_V4021
cap label values V4022 label_V4022
cap label values V4024 label_V4024
cap label values V4025 label_V4025
cap label values V4026 label_V4026
cap label values V4027 label_V4027
cap label values V4028 label_V4028
cap label values V4029 label_V4029
cap label values V4032 label_V4032
cap label values V4033 label_V4033
cap label values V40331 label_V40331
cap label values V403311 label_V403311
cap label values V40332 label_V40332
cap label values V403321 label_V403321
cap label values V40333 label_V40333
cap label values V403331 label_V403331
cap label values V4034 label_V4034
cap label values V40341 label_V40341
cap label values V403411 label_V403411
cap label values V40342 label_V40342
cap label values V403421 label_V403421
cap label values V4040 label_V4040
cap label values V4043 label_V4043
cap label values V40431 label_V40431
cap label values V4045 label_V4045
cap label values V4046 label_V4046
cap label values V4047 label_V4047
cap label values V4048 label_V4048
cap label values V4049 label_V4049
cap label values V4050 label_V4050
cap label values V40501 label_V40501
cap label values V405011 label_V405011
cap label values V40502 label_V40502
cap label values V405021 label_V405021
cap label values V40503 label_V40503
cap label values V405031 label_V405031
cap label values V4051 label_V4051
cap label values V40511 label_V40511
cap label values V405111 label_V405111
cap label values V40512 label_V40512
cap label values V405121 label_V405121
cap label values V4057 label_V4057
cap label values V4058 label_V4058
cap label values V40581 label_V40581
cap label values V405811 label_V405811
cap label values V40582 label_V40582
cap label values V405821 label_V405821
cap label values V40583 label_V40583
cap label values V405831 label_V405831
cap label values V40584 label_V40584
cap label values V4059 label_V4059
cap label values V40591 label_V40591
cap label values V405911 label_V405911
cap label values V40592 label_V40592
cap label values V405921 label_V405921
cap label values V4063 label_V4063
cap label values V4063A label_V4063A
cap label values V4064 label_V4064
cap label values V4064A label_V4064A
cap label values V4071 label_V4071
cap label values V4072 label_V4072
cap label values V4072A label_V4072A
cap label values V4073 label_V4073
cap label values V4074 label_V4074
cap label values V4074A label_V4074A
cap label values V4075A label_V4075A
cap label values V4076 label_V4076
cap label values V4077 label_V4077
cap label values V4078 label_V4078
cap label values V4078A label_V4078A
cap label values V4082 label_V4082
cap label values VD2002 label_VD2002
cap label values VD2004 label_VD2004
cap label values VD2006 label_VD2006
cap label values VD3004 label_VD3004
cap label values VD3005 label_VD3005
cap label values VD3006 label_VD3006
cap label values VD4001 label_VD4001
cap label values VD4002 label_VD4002
cap label values VD4003 label_VD4003
cap label values VD4004 label_VD4004
cap label values VD4004A label_VD4004A
cap label values VD4005 label_VD4005
cap label values VD4007 label_VD4007
cap label values VD4008 label_VD4008
cap label values VD4009 label_VD4009
cap label values VD4010 label_VD4010
cap label values VD4011 label_VD4011
cap label values VD4012 label_VD4012
cap label values VD4013 label_VD4013
cap label values VD4014 label_VD4014
cap label values VD4015 label_VD4015
cap label values VD4018 label_VD4018
cap label values VD4023 label_VD4023
cap label values VD4030 label_VD4030
cap label values VD4036 label_VD4036
cap label values VD4037 label_VD4037
end
