# Data Sources Guide

## 1. us-states.csv

This file contains historical daily case and death reports for each U.S. State. The file was obtained from the ```covid-19-data``` repository published by The New York Times. As of March 22, 2022, the repository was hosted at [https://github.com/nytimes/covid-19-data]. As of the same date, the data could be downloaded by following the link [https://github.com/nytimes/covid-19-data/blob/master/us-counties.csv] and clicking the "Download" button on that page. Documentation for the data is also available in this repository, at [https://github.com/nytimes/covid-19-data/blob/master/README.md].

## 2. sc-est2019-agesex-civ.csv

This file contains the population of U.S. States broken down by single year of age and sex. It was obtained from the U.S. Census Bureau. The file is associated with a data layout guide which has been included in this repository ("data/raw_data/metadata/sc-est2019-agesex-civ.pdf").

As of March 22, 2022, the datafile and file layout information are available to download on the webpage [https://www.census.gov/data/tables/time-series/demo/popest/2010s-state-detail.html] below the subheading "Single Year of Age and Sex Population Estimates: April 1, 2010 to July 1, 2019 - CIVILIAN (SC-EST2019-AGESEX-CIV)".

## 3. us_state_vaccinations.csv

This file was obtained from the ```covid-19-data``` repository published by Our World in Data. As of March 22, 2022, the repository was hosted at [https://github.com/owid/covid-19-data]. As of the same date, the data could be downloaded by following the link [https://github.com/owid/covid-19-data/blob/master/public/data/vaccinations/us_state_vaccinations.csv] and clicking the "Download" button on that page. Documentation for the data is also available in this repository, at [https://github.com/owid/covid-19-data/blob/master/public/data/README.md].

## 4. 0-Datatable export.csv

This file contains temporal data about the relative prevalence of COVID-19 variants of concern. The data are downloaded from the CDC COVID Data Tracker. As of March 22, 2022, this data could be downloaded using a Tableau app displayed at the web address [https://covid.cdc.gov/covid-data-tracker/#variant-proportions]. To download the data, after following that link, scroll to the bottom of the **first** Tableau app on the page and click the "download" icon (a wide rectangle with an arrow emanating from the center pointing downward). Then, on the pop up display, click "Crosstab", select sheet "0-Datatable export", select format "CSV", and then click "Download".

## 5. hhs_region.csv

Map from the names of the 50 U.S. States to their associated U.S. Department of Health and Human Services (HHS) region code. The data is used to map temporal variant prevalence data, which is only provided at the regional level in ```0-Datatable export.csv```,  to State-level estimates. 

This U.S. State-HHS region correspondence data file was created by hand based on information from the HHS website [https://www.hhs.gov/about/agencies/iea/regional-offices/index.html]. The data consists of two columns, "state" and "hhs_region", which contain state names and HHS region codes, respectively.

## 6. ifr_by_age.csv 

This file was constructed manually from the estimates and confidence intervals published in Table 3 of: Levin, A.T., Hanage, W.P., Owusu-Boaitey, N. et al. Assessing the age specificity of infection fatality rates for COVID-19: systematic review, meta-analysis, and public policy implications. Eur J Epidemiol 35, 1123–1138 (2020). https://doi.org/10.1007/s10654-020-00698-1

Each row contains information on the estimated infection fatality rate for a particular age range. The column "age" contains character strings describing the age ranges, in years. "lower" and "upper" contain the lower and upper bounds of the confidence intervals, and "middle" contains the central estimate provided in Levin et al.'s table.