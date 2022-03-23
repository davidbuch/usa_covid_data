pops <- read.csv("data/raw_data/sc-est2019-agesex-civ.csv")

# get counts aggregated across sex (code 0) and age (code 999)
pops <- pops[pops$SEX == 0,] 
pops <- pops[pops$AGE == 999,]
pops$NAME <- tolower(pops$NAME)

# drop D.C. and U.S. totals
pops <- pops[!(pops$NAME %in% c("district of columbia", "united states")),]

# At this point we should only have 50 rows left
# corresponding to the 50 States in alphabetical order
if(nrow(pops) != 50 || sort(unique(pops$NAME)) != pops$NAME){
  stop("Raw U.S. Census data format seems to have changed.")
}

# Create variables to be used in subsequent processing
us_states <- pops$NAME
K <- length(us_states)
N <- pops$POPEST2019_CIV
names(N) <- us_states

# Create "pretty" data.frame to save
state_populations <- data.frame(state = us_states, population = N)

write.csv(state_populations, file = "data/clean_data/state_populations.csv", row.names = FALSE)
