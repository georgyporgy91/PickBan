#' counterpick function
#' @name counterpick
#' @param dat data
#' @param friendly vector of friendly champions
#' @param opponent vector of enemy champions
#' @param numPicks number of picks- default 1
#' @return the champion on friendly team with highest win rate
#' @export

load(file="data/dat.RData")


counterpick <- function(input, data= dat, numPicks = 1){

  newdata <- data.frame(input, stringsAsFactors = F)
  friendly <- newdata$friendly
  opponent <- newdata$opponent

  n_opp <- length(opponent)
  n_fri <- length(friendly)
  gameid_opp <- c()
  dat_rel <- dat

  #Filter data set by including 1)opponent champions 2)ally champions 3) ensure that opponent champions are on the same team, and are opposite of ally champions
  for (i in 1:n_opp){
    gameid_opp <- dat_rel %>% filter(champion==opponent[i]) %>% select(gameid) %>% unique() %>% unlist()
    dat_rel <- dat_rel %>% filter(gameid %in% gameid_opp)

    temp1 <- dat_rel %>% filter(champion==opponent[1]) %>% select(teamid)
    temp2 <- dat_rel %>% filter(champion==opponent[i]) %>% select(teamid)
    dat_rel <- dat_rel %>% filter(gameid %in% gameid_opp[temp1==temp2])
  }

  if (n_fri!=0){ #bypass this check if it's first time purple side picking
    for (i in 1:n_fri){
      gameid_opp <- dat_rel %>% filter(champion==friendly[i]) %>% select(gameid) %>% unique() %>% unlist()
      dat_rel <- dat_rel %>% filter(gameid %in% gameid_opp)

      temp1<- dat_rel %>% filter(champion==opponent[1]) %>% select(teamid)
      temp2<- dat_rel %>% filter(champion==friendly[i]) %>% select(teamid)
      dat_rel <- dat_rel %>% filter(gameid %in% gameid_opp[temp1!=temp2])
    }
  }

  #Filter out only ally champions
  temp3 <- dat_rel %>% filter(champion==opponent[1]) %>% select(teamid)
  temp3 <- 3-temp3
  #browser()
  target <- rep(unlist(temp3), each=10)
  dat_rel <- dat_rel %>% filter(teamid == target)

  #filter out already picked champions
  dat_rel <- dat_rel %>% filter(!champion %in% friendly)
  dat_rel <- dat_rel %>% filter(!champion %in% opponent)


  # #find highest win rate against opponent champions
  # counter <- highestWinProb(dat_rel, 1) #changing this parameter to "numPicks" alters the algorithm to pick the highest 2 win rates simultaneously. Could lead to 2 of same role.
  # friendly <- c(friendly, counter)
  # print(friendly)
  # return(friendly)

  #find highest win rate against opponent champions
  counter <- highestWinProb(dat_rel, 1)
  return(counter)
}
