# Load population data and create state_populations.csv
source("scripts/processing_scripts/load_state_populations.R")
# Load COVID-19 case and death data and create 
# - covid_cases.csv
# - covid_deaths.csv
source("scripts/processing_scripts/load_nyt_data.R")

# vaccination data (first dose)
source("scripts/processing_scripts/load_vaccinations.R")

# prevalence of delta variant
source("scripts/processing_scripts/load_variants.R")

# Compute and save U.S. State-level estimates for the IFR
source("scripts/processing_scripts/load_ifr.R")

