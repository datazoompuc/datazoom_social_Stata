# datazoom.pnadcontinua

datazoom.pnadcontinua is an R package that facilitates access to official data regarding the Continuous PNAD. The package provides functions that download and pre-process selected datasets. 

## Installation
The package can be installed using `devtools`:

```
if(!require(devtools)) install.packages("devtools")
devtools::install_github("datazoompuc/PNAD_Continua/r-package")
```

## Panel of Individuals

The Continuous PNAD is a panel survey, in which each household is interviewed for five consecutive quarters. Despite correctly identifying the same household in all five interviews, the Pnad Continuous does not assign the same identification number to each member of the household at every interview. 
In case the user wishes to work with an individuals panel,
it is necessary to construct a variable to identify each individual throughout different surveys.
For this reason we use algorithms suggested by Ribas and Soares (2008).
The authors elaborated a basic system identification and an advanced one. They differ by the number of 
variables used to identify individuals in different surveys.
The idea is to verify inconsistencies in the set of variables. Either way the program may take a resonable 
amount of time to perform the identification process, depending on the computational
capacity.


## Usage

```
library(datazoom.pnadcontinua)
```
Use ```load_pnadc``` to load and clean microdata from a specified directory.

To download data, set ```sources``` as a list of vectors
of time periods
```

dates <- list(c(1, 2012), c(2, 2012))

microdata <- load_pnadc(panel = 'no', lang = 'english',
                        sources = dates,
                        download_directory = './Desktop')
```

To load the data from a folder:
```
microdata <- load_pnadc(panel = 'advanced', lang = 'english',
                        sources = './Desktop/folder_name')
```

To load an individual .txt file corresponding to a given period of the survey:

```
 microdata <- load_pnadc(panel = 'basic', sources = './PNADC_012020.txt')
```
To build a panel with data already loaded to R, use ```pnadc_panel```. Let ```data1``` and ```data2``` be two dataframes with deidentified PNAD-C data:

```
panel <- pnadc_panel(data1, data2, basic = TRUE, lang = 'english')
```

## Credits
DataZoom is developed by a team at Pontifícia Universidade Católica do Rio de Janeiro (PUC-Rio), Department of Economics. Our official website is at: http://www.econ.puc-rio.br/datazoom/index.html.
