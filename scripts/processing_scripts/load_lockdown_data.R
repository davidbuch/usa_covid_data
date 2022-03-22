lockdown <- readxl::read_xlsx("data/lockdown_data.xlsx", sheet = "lockdown", col_types = c("text", "date", "date"))
masks <- readxl::read_xlsx("data/lockdown_data.xlsx", sheet = "mask", col_types = c("text", "date", "date"))

conv_to_ind_matrix <- function(policy_data,weeks,states){
  J <- length(weeks)
  K <- length(states)
  ind_mat <- matrix(NA,nrow = J, ncol = K)
  
  Kp <- nrow(policy_data)
  for(kp in 1:Kp){
    state <- policy_data[kp,]$state
    start_week <- policy_data[kp,]$start_week
    end_week <- policy_data[kp,]$end_week
    local_ind <- rep(0,J)
    if(!is.na(start_week)){
      js <- match(start_week,weeks)
      if(is.na(end_week)){
        je <- J # policy is still in place
      }else{
        je <- match(end_week,weeks)
      }
      local_ind[js:je] <- 1
    }
    ind_mat[,match(state,states)] <- local_ind
  }
  rownames(ind_mat) <- as.character.Date(weeks)
  colnames(ind_mat) <- states
  return(ind_mat)
}
compute_weeks_since_covid_start <- function(date){ymd('2020-01-06') + ceiling(as.numeric(ymd(date) - ymd('2020-01-06'))/7)*days(7)}

lockdown$start_week <- compute_weeks_since_covid_start(lockdown$start_date)
lockdown$end_week <- compute_weeks_since_covid_start(lockdown$end_date)
lockdown$state <- tolower(lockdown$state)
lockdown <- conv_to_ind_matrix(lockdown,weeks,us_states)

masks$start_week <- compute_weeks_since_covid_start(masks$start_date)
masks$end_week <- compute_weeks_since_covid_start(masks$end_date)
masks$state <- tolower(masks$state)
masks <- conv_to_ind_matrix(masks,weeks,us_states)


