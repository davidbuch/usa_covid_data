pops <- read.csv("data/raw_data/sc-est2019-agesex-civ.csv")

pops <- pops[pops$SEX == 0,]
pops$NAME <- tolower(pops$NAME)
pops <- pops[!(pops$NAME %in% c("district of columbia", "united states")),]

# aggregate populations 0-34, 35-44, 45-54, 55-64, 65-74, 75-84, 85+ to match the intervals in ifr_by_age.csv
# note that in the census data, 85+ individuals are all recorded as exactly 85.
agegroups <- matrix(c(0,34,35,44,45,54,55,64,65,74,75,84,85,85), ncol = 2, byrow = TRUE)
popsstates <- unique(pops$NAME)
statepop_mat <- matrix(nrow = length(popsstates), ncol = nrow(agegroups))
rownames(statepop_mat) <- popsstates
for(i in 1:length(popsstates)){
  selstate <- pops[pops$NAME == popsstates[i], c("AGE", "POPEST2019_CIV")]
  statepop_binned <- vector(length = nrow(agegroups))
  for(j in 1:nrow(agegroups)){
    statepop_binned[j] <- sum(selstate$POPEST2019_CIV[agegroups[j,1] <= selstate$AGE & agegroups[j,2] >= selstate$AGE])
  }
  statepop_mat[i,] <- statepop_binned
}
statepop_mat
state_demographics <- statepop_mat / rowSums(statepop_mat)

ifr_by_age <- as.matrix(read.csv("data/raw_data/ifr_by_age.csv", row.names = 1))
ifr_by_state <- state_demographics %*% ifr_by_age
colnames(ifr_by_state) <- c("lower", "middle", "upper")

write.csv(ifr_by_state, "data/clean_data/infection_fatality_rate_estimates.csv", row.names = TRUE)
