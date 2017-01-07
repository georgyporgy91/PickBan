rm(list=ls())

library(dplyr)
library(data.table)
library(jsonlite)

## read data as dat with columns champion, gameid, teamid, win/lose, pickid (optional)
raw_dat <- read.csv("~/Desktop/PickBan/inst/model/RequestData_pre_ranked.csv")
dat <- with(raw_dat, data.frame(gameid=matchId, champion, teamid= side, result = winner))
dat$teamid <- replace(dat$teamid, dat$teamid==100, 1)
dat$teamid <- replace(dat$teamid, dat$teamid==200, 2)
dat$result <- replace(dat$result, dat$result==TRUE, "w")
dat$result <- replace(dat$result, dat$result==FALSE, "l")

championMapping <- read.csv("~/Desktop/PickBan/inst/model/championMapping.csv", row.names = 1)
dat$champion <- left_join(dat, championMapping[,1:2], by= "champion")$"championNames"

champion_roles_df <- read.csv("~/Desktop/PickBan/inst/model/champion_roles_df.csv")
champion_roles_df$roles_combined <- with(champion_roles_df, paste0(role1, "_",role2))

championMapping <- left_join(championMapping, champion_roles_df, by="championNames") #join roles to champion table


highestWinProb <- function(dat, n){
  # pivot <- dcast(dat, champion~result, length) #dcast doesn't work when all wins or all losses
  loss <- sapply(unique(dat$champion), function(x) sum(dat$result[which(dat$champion==x)]=="l"))
  win <- sapply(unique(dat$champion), function(x) sum(dat$result[which(dat$champion==x)]=="w"))

  pivot <- data.frame(win, loss)
  win_rate <- data.frame(champion = as.character(unique(dat$champion)),
                         pwin = apply(pivot, 1, function(x) x[1]/(sum(x))),
                         numGames = apply(pivot, 1, sum),
                         stringsAsFactors = FALSE)

  win_rate_sorted <- win_rate[ order(win_rate$pwin, decreasing = 1), ]

  threshold <- sum(win_rate_sorted$numGames)/length(win_rate_sorted$champion) #expected # of games per champion, if randomly selected
  #threshold <- 0
  win_rate_clean <- win_rate_sorted[win_rate_sorted$numGames >=threshold,]
  return(win_rate_clean)
  # print(win_rate_clean)
  # highestWinRatePick <- win_rate_clean$champion[1:n]
  # highestWinRatePick_rate <- win_rate_clean$pwin[1:n]
  # return(highestWinRatePick)
}

firstRoundPick <- function(dat){
  firstPick <- highestWinProb(dat, 1)
  #print(firstPick)
  return(firstPick)
}


highestWinProb_group <- function(dat, n){
  dat <- data.table(dat)
  dat$champion <- as.character(dat$champion)
  dat <- merge(dat, championMapping[,c("championNames","roles_combined")], by.x = "champion", by.y = "championNames", all.x = TRUE)

  # SELECT pwin and count, BY champion, WHERE count > (total number of games / number of champions), ORDER BY pwin desc order
  win_rate_clean <- dat[ , list(pwin= sum(result=="w")/.N ,.N), champion][N> (sum(N)/length(N)),][order(-pwin)]
  #win_rate_clean <- dat[ , list(pwin= sum(result=="w")/.N ,.N), roles_combined][N> (sum(N)/length(N)),][order(-pwin)]
  return(win_rate_clean)
  # highestWinRatePick <- win_rate_clean$champion[1:n]
  # return(highestWinRatePick)
}


## Assume that groups are available for each champion
group <- function(champ){
  selected_group <- championMapping$roles_combined[which(championMapping$championNames == champ)]
  selected_group_champions <- championMapping$championNames[which(championMapping$roles_combined == selected_group)]
  return(as.character(selected_group_champions))
}

save.image(file="data/dat.RData")
