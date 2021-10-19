# U.S.A. Covid-19 Data: Clean, easy-to-use data from the 50 States (Updated Weekly on Sundays)

A number of sources across the internet provide regularly-updated counts of COVID-19 cases (a.k.a positive tests) and deaths reported within each of the 50 U.S. States. However, despite the significant public interest in these data, they often contain clear systematic and/or idiosyncratic reporting errors. In addition, I personally find it cumbersome to work with the long panel-data format in which data are provided.

Here I have attempted to provide several clean, easy-to-use data files describing the COVID-19 epidemic in the United States. These include information on:
* covid-19 cases (a.k.a. positive tests)
* covid-19 attributable deaths
* persons vaccinated (first dose, as a proportion of state population)
* prevalence of the delta variant of covid-19 in each state

Each dataset is a *Jx50* array of numbers, where *J* is the number of weeks since January 27, 2020 (inclusive). Rows index over weeks and columns index over States.

To load each data file, you should use this ```R``` command, with ```XXX_XXX``` replaced by a specific file/variable name:
```
XXX_XXX <- read.csv("XXX_XXX.csv", row.names = 1, check.names = FALSE)
```
or, in Python:
```
import pandas as pd
XXX_XXX = pd.read_csv("XXX_XXX.csv", index_col=0)
```

I have aggregated all data to weekly summaries, since (1) daily data often appear to be subject to reporting cycles, and (2) the intensity of the day-of-the-week effect on reporting seems to vary across locations and over time. I have also attempted to smooth out any extreme and apparently erroneous outliers which were prevalent in case, death, and vaccination data. For completeness, each week I will also provide recently updated raw data files (also available from their original sources, cited below) and the R scripts I use to clean and restructure those data each week.

## Example of Use
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

## Data Sources
1. Cases and Deaths - NYT COVID-19 GitHub Repository
2. U.S. State Populations (total and by age) - U.S. Census Bureau
3. U.S. State Vaccinations - Our World in Data
4. COVID-19 Delta Variant Prevalence - U.S. CDC, U.S. Department of Health and Human Services

## License
Please use and distribute freely, with appropriate citation of this project as well as the original providers of the raw data.

