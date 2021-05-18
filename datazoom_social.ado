******************************************************
*                   datazoom_social.ado                  *
******************************************************
* version 1.0

program define dz_social
syntax, research(str)

/* ... */
db datazoom_`research'

end
