nyt_states <- read.csv("data/us-states.csv")
nyt_states$deaths[is.na(nyt_states$deaths)] <- 0

nyt_states$date <- ymd(nyt_states$date)
compute_weeks_since_covid_start <- function(date){ymd('2020-01-06') + ceiling(as.numeric(date - ymd('2020-01-06'))/7)*days(7)}
nyt_states$week <- compute_weeks_since_covid_start(nyt_states$date)

nyt_states$state <- tolower(nyt_states$state)

# Convert from cumulative deaths to daily deaths
for(i in 1:K){
  sel <- nyt_states$state == us_states[i]
  nyt_states$new_deaths[sel] <- c(0,diff(nyt_states$deaths[sel]))
  nyt_states$new_cases[sel] <- c(0,diff(nyt_states$cases[sel]))
}


us_covid_weekly <- aggregate(cbind(new_deaths, new_cases) ~ week + state, data = nyt_states, FUN = sum)

Tall <- 0
for(k in 1:K){
  Tall <- max(Tall,length(us_covid_weekly$new_deaths[us_covid_weekly$state == us_states[k]]))
}

weeks <- sort(unique(us_covid_weekly$week))



dmat <- matrix(0, nrow = Tall, ncol = K)
for(k in 1:K){
  unfiltered <- us_covid_weekly$new_deaths[us_covid_weekly$state == us_states[k]]
  #plot(unfiltered, col = "red", type = "l", main = us_states[k])
  J <- length(unfiltered) 
  delta <- c()
  ndj <- c()
  for(j in 1:J){
    delta[j] <- sd(diff(unfiltered))/sd(diff(unfiltered[-j]))
  }
  #print(delta)
  for(j in 1:J){
    ndj[j] <- delta[j] - mean(delta[-j])
  }
  #print(ndj)
  #plot(ndj,type = "l", main = us_states[k])
  #plot(delta)
  filtered <- unfiltered
  for(j in 1:J){
    if(abs(ndj[j]) > 0.25){
      #if(delta[j] > 20*mean(delta[-j])){
      if(j == 1){
        filtered[1] <- filtered[2]
      }else if(j == J){
        filtered[J] <- filtered[J - 1]
      }else{
        filtered[j] <- round((filtered[j+1] + filtered[j-1])/2)
      }
    }
    if(filtered[j] < 0){
      filtered[j] <- 0
    }
  }
  #lines(filtered, col = "black")
  dmat[(Tall-J +1):Tall,k] <- filtered
}
colnames(dmat) <- us_states
rownames(dmat) <- as.character.Date(weeks)
# matplot(dmat,x = weeks, type = "l")

cmat <- matrix(0, nrow = Tall, ncol = K)
for(k in 1:K){
  unfiltered <- us_covid_weekly$new_cases[us_covid_weekly$state == us_states[k]]
  #plot(unfiltered, col = "red", type = "l", main = us_states[k])
  J <- length(unfiltered) 
  delta <- c()
  ndj <- c()
  for(j in 1:J){
    delta[j] <- sd(diff(unfiltered))/sd(diff(unfiltered[-j]))
  }
  for(j in 1:J){
    ndj[j] <- delta[j] - mean(delta[-j])
  }
  #plot(ndj,type = "l", main = us_states[k])
  #plot(delta)
  filtered <- unfiltered
  for(j in 1:J){
    if(abs(ndj[j]) > 0.25){
      #if(delta[j] > 20*mean(delta[-j])){
      if(j == 1){
        filtered[1] <- filtered[2]
      }else if(j == J){
        filtered[J] <- filtered[J - 1]
      }else{
        filtered[j] <- round((filtered[j+1] + filtered[j-1])/2)
      }
    }
    if(filtered[j] < 0){
      filtered[j] <- 0
    }
  }
  #lines(filtered, col = "black")
  cmat[(Tall-J +1):Tall,k] <- filtered
}
colnames(cmat) <- us_states
rownames(cmat) <- as.character.Date(weeks)

T_1 <- apply(cmat,2,function(cvec) match(TRUE, cvec > 0))
