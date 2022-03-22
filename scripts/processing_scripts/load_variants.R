variants <- read.csv("data/cdc_variants.csv")
variants <- variants[variants$Variant == "B.1.617.2",]
compute_weeks_since_covid_start <- function(date){ymd('2020-01-06') + ceiling(as.numeric(mdy(date) - ymd('2020-01-06'))/7)*days(7)}
variants$week <- compute_weeks_since_covid_start(variants$date)
variants$Usa.Or.Hhsregion <- as.numeric(variants$Usa.Or.Hhsregion)
variants <- variants[!is.na(variants$Usa.Or.Hhsregion),]

hhs_map <- read.csv("data/hhs_regions.csv")
hhs_map$state <- tolower(hhs_map$state)


varmat <- matrix(0,nrow = Tall, ncol = K)
rownames(varmat) <- as.character(weeks)
colnames(varmat) <- us_states
for(j in 1:Tall){
  if(weeks[j] < min(variants$week)){
    varmat[j,] <- rep(0,K)
  }else if(weeks[j] > max(variants$week)){
    varmat[j,] <- rep(1,K)
  }else{
    for(k in 1:K){
      region_no <- hhs_map$hhs_region[hhs_map$state == us_states[k]]
      varmat[j,k] <- variants$share[variants$week == weeks[j] &
                                      variants$Usa.Or.Hhsregion == region_no]
    } 
  }
}
