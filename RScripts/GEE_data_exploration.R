# This script is used to process GEE data
Pod680_2018_date <- c(20180609,
  20180609,
  20180612,
  20180612,
  20180614,
  20180614,
  20180617,
  20180617,
  20180619,
  20180619,
  20180622,
  20180622,
  20180624,
  20180624,
  20180627,
  20180627,
  20180629,
  20180629,
  20180702,
  20180702,
  20180704,
  20180704,
  20180707,
  20180707,
  20180709,
  20180709,
  20180712,
  20180712,
  20180714,
  20180714,
  20180717,
  20180717,
  20180719,
  20180719,
  20180722,
  20180722,
  20180724,
  20180724,
  20180727,
  20180727,
  20180729,
  20180729,
  20180801,
  20180801,
  20180803,
  20180803,
  20180806,
  20180806,
  20180808,
  20180808,
  20180811,
  20180811,
  20180813,
  20180813,
  20180816,
  20180816,
  20180818,
  20180818,
  20180821,
  20180821,
  20180823,
  20180823,
  20180826,
  20180826,
  20180828,
  20180828,
  20180831,
  20180831,
  20180902,
  20180902)

# formatting the to date data
Pod680_2018_date <- Pod680_2018_date %>% unique()
Pod680_2018_date <- lubridate::ymd(Pod680_2018_date)

# select out the data that are available in GEE
pod_sat_680 <- Pod_680_d[(Pod_680_d$time %>% ymd()) %in% Pod680_2018_date,]






















# testing data
pod <- p_dat_680_d
pod <- data_preprocess(pod)
pod <- pod %>% select(.,time,NDVI,SWdw) %>% mutate(PAR = SWdw*0.5)

# a function to calculate Yield based on satellite data
SatYield <- function(pod,datevct,satNDVI){
  # formatting the to date data
  datevct <- datevct %>% unique()
  datevct <- lubridate::ymd(datevct)
  # select out the date that are available in satellite data
  
}








