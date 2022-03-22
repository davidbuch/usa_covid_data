
# Downloaded from U.S. Census
# https://www.census.gov/data/tables/time-series/demo/popest/2010s-state-detail.html
pops <- read.csv("data/population_proportions_detailed.csv")
pops <- pops[pops$SEX == 0,]
pops$NAME <- tolower(pops$NAME)
pops <- pops[!(pops$NAME %in% c("district of columbia", "united states")),]
# aggregate populations 0-34, 35-44, 45-54, 55-64, 65-74, 75-84, 85+
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
# IFR by age obtained from Table 3 in:
# Levin, A.T., Hanage, W.P., Owusu-Boaitey, N. et al. 
# Assessing the age specificity of infection fatality rates for COVID-19: systematic review, meta-analysis, and public policy implications. 
# Eur J Epidemiol 35, 1123–1138 (2020). https://doi.org/10.1007/s10654-020-00698-1
ifr_byage <- matrix(c(0.003, 0.004, 0.005,
               0.058, 0.068, 0.078,
               0.20, 0.23, 0.26,
               0.66, 0.75, 0.87,
               2.1, 2.5, 3.0, 
               6.9, 8.5, 10.4, 
               21.8, 28.3, 36.6)/100, 
               ncol = 3, byrow = TRUE)
ifr_bystate <- state_demographics %*% ifr_byage
colnames(ifr_bystate) <- c("lower", "middle", "upper")
#sorti <- order(ifr_bystate[,2], decreasing = TRUE)
#topbottom <- c(1:5,46:50)
# pdf("figures/us_analysis/ifr_spread.pdf",width = 4, height = 4)
# DescTools::PlotDot(ifr_bystate[sorti[topbottom],2], 
#                    labels = tools::toTitleCase(rownames(ifr_bystate[sorti[topbottom],])),
#                    args.errbars = list(from = ifr_bystate[sorti[topbottom],1], to = ifr_bystate[sorti[topbottom],3]),
#                    xlim = c(0,0.025),
#                    main = "Top/Bottom 5 IFR in USA")
# dev.off()

