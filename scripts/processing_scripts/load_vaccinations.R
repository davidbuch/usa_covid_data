vaccines <- read.csv("data/raw_data/us_state_vaccinations.csv")
vaccines$people_vaccinated[is.na(vaccines$people_vaccinated)] <- 0

vaccines$date <- ymd(vaccines$date)
compute_weeks_since_covid_start <- function(date){ymd('2020-01-06') + ceiling(as.numeric(date - ymd('2020-01-06'))/7)*days(7)}
vaccines$week <- compute_weeks_since_covid_start(vaccines$date)

vaccines$state <- tolower(vaccines$location)
vaccines$state[vaccines$state == "new york state"] <- "new york"
# Convert from cumulative vaccines to new vaccines
for(i in 1:length(us_states)){
  sel <- vaccines$state == us_states[i]
  vaccines$newly_vaccinated[sel] <- c(0,diff(vaccines$people_vaccinated[sel]))
}


us_vaccinations_weekly <- aggregate(newly_vaccinated ~ week + state, data = vaccines, FUN = sum)

us_vaccinations_weekly <- us_vaccinations_weekly[us_vaccinations_weekly$week <= max(us_covid_weekly$week),]

vmat <- matrix(0, nrow = Tall, ncol = K)
for(k in 1:K){
  unfiltered <- us_vaccinations_weekly$newly_vaccinated[us_vaccinations_weekly$state == us_states[k]]
  unfiltered[1:2] <- mean(unfiltered[1:2])
  
  did <- c(0,diff(unfiltered))
  if(max(abs(did)) > 5*median(abs(did))){
    J <- length(did)
    z <- rep(T, J)
    llh <- function(z){
      return(sum(z)*log(.95) + sum(!z)*log(.05) + sum(dnorm(did[z]/(5*median(abs(did))), log = TRUE)) + sum(dnorm(did[!z]/max(abs(did)), 1, log = TRUE)))
    }
    for(s in 1:100){
      for(j in 1:length(z)){
        zprop <- z
        zprop[j] <- !z[j]
        accprob <- exp(llh(zprop) - llh(z))
        if(runif(1) < accprob) z <- zprop
      }
    }
    
    filtered <- approx(x = which(z), y = unfiltered[z], xout = 1:J, rule = 2)$y
  }else{
    filtered <- unfiltered
  }
  
  filtered[filtered < 0] <- 0
  vmat[(Tall-J +1):Tall,k] <- filtered/N[k]
}
colnames(vmat) <- us_states
rownames(vmat) <- as.character.Date(weeks)

write.csv(vmat, "data/clean_data/covid_vaccinations.csv")
