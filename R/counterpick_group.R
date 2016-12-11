#' counterpick_group function, except that when filtering games, instead of specific champions, now it's a group of champions. The purpose is to increase sample size.
#' @name counterpick_group
#' @param data, vector of friendly champions, vector of enemy champions, and number of picks- default 1
#' @return the champion on friendly team with highest win rate
#' @export


load(file="data/dat.RData")

counterpick_group <- function(dat, friendly, opponent, numPicks = 1){
  n_opp <- length(opponent)
  n_fri <- length(friendly)
  gameid_opp <- c()
  dat_rel <- dat
  dat_rel$gameid_teamid <- paste(dat_rel$gameid,dat_rel$teamid,sep="_")


  #Filter data set by including 1)opponent champions 2)ally champions 3) ensure that opponent champions are on the same team, and are opposite of ally champions
  enemy_games <- dat_rel %>% filter(champion %in% group(opponent[1]))
  enemy_games$gameid_teamid <- paste(enemy_games$gameid, enemy_games$teamid,sep="_")
  dat_rel_id <- dat_rel %>% filter(gameid_teamid %in% enemy_games$gameid_teamid) %>% select(gameid) %>% unique() %>% unlist()

  for (i in 1:n_opp){
    if(i==1){
      enemy_games_prev <- dat_rel %>% filter(champion %in% group(opponent[1]))
    }

    enemy_games <- dat_rel %>% filter(champion %in% group(opponent[i]))
    valid_gameid_teamid <- intersect(enemy_games$gameid_teamid, enemy_games_prev$gameid_teamid)
    enemy_games_prev <- enemy_games

    dat_rel_id <- dat_rel %>% filter(gameid_teamid %in% valid_gameid_teamid) %>% select(gameid) %>% unique() %>% unlist()
    dat_rel <- dat_rel %>% filter(gameid %in% dat_rel_id)
  } # a list of games with all opponent champions

  splt <- strsplit(enemy_games_prev$gameid_teamid, "_")
  fr_teamid <- 3 - lapply(splt, '[', 2) %>% as.numeric
  fr_gameid_teamid <- paste(lapply(splt, '[', 1), fr_teamid, sep="_")

  if (n_fri!=0){ #bypass this check if it's first time purple side picking
    for (i in 1:n_fri){
      if(i==1){
        friendly_games_prev <- dat_rel %>% filter(champion %in% group(friendly[1]))
      }

      friendly_games <- dat_rel %>% filter(champion %in% group(friendly[i])) #choose opponent teams

      # choose the intersection of teams that are on opponent's, previous friendly champions, and current champion
      # This identifies current champions that are not on opponent, and is on the same as previous champions
      valid_gameid_teamid <- intersect(intersect(friendly_games$gameid_teamid, fr_gameid_teamid), friendly_games_prev$gameid_teamid)
      friendly_games_prev <- friendly_games

      dat_rel_id <- dat_rel %>% filter(gameid_teamid %in% valid_gameid_teamid) %>% select(gameid) %>% unique() %>% unlist()
      dat_rel <- dat_rel %>% filter(gameid %in% dat_rel_id)
    }
  } else valid_gameid_teamid <- fr_gameid_teamid

  #Filter out only ally champions
  #Double check this --------------------
  #Question: how to filter out data so that only the friendly team is considered for the final highestWinprob calculation

  dat_rel <- dat_rel %>% filter(gameid_teamid %in% valid_gameid_teamid)
  #------------

  #filter out already picked champions
  # dat_rel <- dat_rel %>% filter(!champion %in% unlist(sapply(friendly, group)))
  # dat_rel <- dat_rel %>% filter(!champion %in% unlist(sapply(opponent, group)))
  dat_rel <- dat_rel %>% filter(!champion %in% unlist(friendly))
  dat_rel <- dat_rel %>% filter(!champion %in% unlist(opponent))

  #find highest win rate against opponent champions
  counter <- highestWinProb(dat_rel, 1) #changing this parameter to "numPicks" alters the algorithm to pick the highest 2 win rates simultaneously. Could lead to 2 of same role.
  friendly <- c(friendly, counter)
  print(friendly)
  return(friendly)
}
