# U.S.A. Covid-19 Data: Clean, easy-to-use data from the 50 States

## Project Description

A number of sources across the internet provide regularly-updated counts of COVID-19 cases (a.k.a positive tests) and deaths reported within each of the 50 U.S. States. However, despite the significant public interest in these data, they often contain clear systematic and/or idiosyncratic reporting errors.

Here I have attempted to provide several clean, easy-to-use data files describing the COVID-19 epidemic in the United States. These include information on:
* covid-19 cases (a.k.a. positive tests)
* covid-19 attributable deaths
* persons vaccinated (first dose, as a proportion of State population)
* prevalence of the delta variant of covid-19 in each State
* estimated infection fatality rate (and confidence band) for each State, determined based on demographic composition of each state by age [not a temporal dataset]

Each temporal dataset is a *Jx50* array of numbers, where *J* is the number of weeks since January 27, 2020 (inclusive). Rows index over weeks and columns index over States. For users who prefer the tidy data formatting convention, the columns must be stacked using standard reshaping functions available in Python's ``pandas`` package or R's ```tidyverse``` package.

I have aggregated all data to weekly summaries, since (1) daily data often appear to be subject to reporting cycles, and (2) the intensity of the day-of-the-week effect on reporting seems to vary across locations and over time. I have also attempted to smooth out any extreme and apparently erroneous outliers which were prevalent in case, death, and vaccination data. To make these adjustments transparent and reproducible, this repository loosely conforms with the TIER Protocol 4.0 (https://www.projecttier.org/tier-protocol/protocol-4-0/). Specifically, this means I adopt a specific file structure and include all raw data and processing scripts in designated folders. If you have any questions about the data, its provenance, or the processing scripts, please don't hesitate to reach out to me on github.

## Using the Cleaned and Formatted Data

To load each data file, you should use this ```R``` command, with ```XXX_XXX``` replaced by a specific file/variable name:

```
XXX_XXX <- read.csv("XXX_XXX.csv", row.names = 1, check.names = FALSE)
```
or, in ```Python```:
```
import pandas as pd
XXX_XXX = pd.read_csv("XXX_XXX.csv", index_col=0)
```

### Example of Use

In ```R```:
```
covid_deaths <- read.csv("covid_deaths.csv", row.names = 1, check.names = FALSE)

# To appropriately label months on the x-axis when plotting
library(lubridate)
weekly <- ymd(rownames(covid_deaths))
yii <- year(min(weekly))
mii <- month(min(weekly))
monthly <- c()
while(yii < year(max(weekly)) || mii <= month(max(weekly))){
  monthly <- c(monthly, paste0(yii,"-",mii,"-01"))
  mii <- mii + 1
  if(mii > 12){
    yii <- yii + 1
    mii <- 1
  }
}
monthly <- ymd(monthly)

matplot(weekly, covid_deaths, type = "l", xaxt = 'n', xlab = "time")
axis(1, monthly, format(monthly, "%b %y"), cex.axis = .7)
```

In ```Python```:
```
import pandas as pd
import seaborn as sns
covid_deaths = pd.read_csv("covid_deaths.csv", index_col=0)
covid_deaths.plot(legend = None)
```

## Raw Data Sources

See "data/raw_data/metadata/data_sources_guide.md" for complete information.

## Clean Data Files

See "data/clean_data/data_appendix.md" for complete information.

## Reproducing the Cleaned Data

### 1. Software and platform

The data was originally downloaded and the cleaning and processing scripts were run on a 2014 Macbook Air, using MacOS Catalina version 10.15.6.

The processing scripts are written in the R statistical programming language, and were run on R version 4.0.5.

The scripts make use of certain R add-on packages, available in the CRAN repository:

* lubridate
* readxl

### 2. Map of documentation

usa_covid_data:

* README.md [you are here]
* Data/
  * RawData/
    * Raw Data Files [may include simulated data, or data you've collected]
    * Metadata/
      * data_sources_guide.md
        * For existing data: bib citation, instructions to obtain, note on the avialability of a code book
        * For generated data: note on construction, availability of codebook
      * Codebook1
      * Codebook2
      * ...
  * CleanData/
    * Clean Data Files
    * Data Appendix
      * This is a very cool idea, combination of a codebook and basic EDA. See https://www.projecttier.org/tier-protocol/protocol-4-0/root/data/analysisdata/data-appendixfile/
* Scripts/
  * ProcessingScripts/
  * The Master Script

### 3. Instructions for reproducing the cleaned data

Once the R program and all necessary add-on pacakges are installed, run "scripts/master_script.R" with an R interpreter. This will call data cleaning R scripts inside the "scripts/processing_scripts/" directory, which load data from the "data/raw_data/" directory and then save the cleaned data in "data/clean_data/".

## License

Please use and distribute freely, with appropriate citation of this project as well as the original sources of the raw data.

