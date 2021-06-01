******************************************************
*                   datazoom_social.ado                  *
******************************************************
* version 1.0

program define datazoom_social
syntax, research(str) original(str) saving(str) year(integer)

foreach pesq in `research' {
	if `pesq' == "pns" {
		datazoom_pns, original(str) saving(str) year(integer)
	}
	else continue, break
}

end
