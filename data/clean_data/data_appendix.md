# Data Appendix

## state_populations.csv

Data for a two column data frame. One column, "state", contains state names. The other, "population", contains populations.

```R
read.csv("data/clean_data/state_populations.csv")
```

## covid_cases.csv

Obtained by cleaning and aggregating the NYT COVID-19 data to weeks. 

```R
read.csv("data/clean_data/covid_cases.csv", row.names = 1)
```

## covid_deaths.csv

Obtained by cleaning and aggregating the NYT COVID-19 data to weeks. 

```R
read.csv("data/clean_data/covid_deaths.csv", row.names = 1)
```

## covid_vaccinations.csv

Obtained by cleaning and aggregating the OWID vaccination data to weeks. 

```R
read.csv("data/clean_data/covid_vaccinations.csv", row.names = 1)
```

## delta_prevalence.csv

Delta prevalence estimates for each U.S. State. Obtained by broadcasting regional estimates from the U.S. Department of Health and Human Services "data/raw_data/0-Datatable export.xlsx" to the States within each region.

```R
read.csv("data/clean_data/delta_prevalence.csv", row.names = 1)
```

## infection_fatality_rate_estimates.csv

Lower, middle, and upper bound estimates of the infection fatality rate for each U.S. State. The estimates are computed based on the demographic composition information in "data/raw_data/sc-est2019-agesex-civ.csv" and age-based infection fatality rate estimates in "data/raw_data/ifr_by_age.csv "

```R
read.csv("data/clean_data/infection_fatality_rate_estimates.csv", row.names = 1)
```

