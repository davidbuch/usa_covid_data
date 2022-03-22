us_pops <- read_xlsx("data/census_populations.xlsx", range = "A10:M60", col_names = FALSE)
us_pops <- us_pops[,c(1,13)] # only need statename and 2019 population columns
names(us_pops) <- c("state", "population")
us_pops$state <- gsub("\\.","",us_pops$state)
us_pops$state <- tolower(us_pops$state)
us_pops <- us_pops[us_pops$state != "district of columbia",]

N <- us_pops$population
us_states <- us_pops$state
K <- length(us_states) # 50
