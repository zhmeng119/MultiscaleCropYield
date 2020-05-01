# Part 1: read data from server
library(aRable)

# Read hourly & daily data data from server

# A000680
p_dat_680_d <- ArableClient(device = "A000680", measure = "daily",
                         start = "2017-06-01", end = "2019-09-06",
                         email = "lestes@clarku.edu",
                         password = "rollinghills88",  # replace this w/ actual p
                         tenant = "clark")
# p_dat_680_h <- ArableClient(device = "A000680", measure = "hourly",
#                                 start = "2017-06-01", end = "2019-09-06",
#                                 email = "lestes@clarku.edu",
#                                 password = "rollinghills88",  # replace this w/ actual p
#                                 tenant = "clark")

# A000671
p_dat_671_d <- ArableClient(device = "A000671", measure = "daily",
                                 start = "2017-06-01", end = "2019-09-06",
                                 email = "lestes@clarku.edu",
                                 password = "rollinghills88",  # replace this w/ actual p
                                 tenant = "clark")
# p_dat_671_h <- ArableClient(device = "A000671", measure = "hourly",
#                             start = "2017-06-01", end = "2019-09-06",
#                             email = "lestes@clarku.edu",
#                             password = "rollinghills88",  # replace this w/ actual p
#                             tenant = "clark")

# A000667
p_dat_667_d <- ArableClient(device = "A000667", measure = "daily",
                                 start = "2017-06-01", end = "2019-09-06",
                                 email = "lestes@clarku.edu",
                                 password = "rollinghills88",  # replace this w/ actual p
                                 tenant = "clark")
# p_dat_667_h <- ArableClient(device = "A000667", measure = "hourly",
#                             start = "2017-06-01", end = "2019-09-06",
#                             email = "lestes@clarku.edu",
#                             password = "rollinghills88",  # replace this w/ actual p
#                             tenant = "clark")

# Export data
# library(openxlsx)
# dataset_list <- list("p_dat_680_d" = p_dat_680_d,
#                      "p_dat_680_h" = p_dat_680_h,
#                      "p_dat_671_d" = p_dat_671_d,
#                      "p_dat_671_h" = p_dat_671_h,
#                      "p_dat_667_d" = p_dat_667_d,
#                      "p_dat_667_h" = p_dat_667_h)
# write.xlsx(dataset_list, file = "pod_data.xlsx")

# write.csv(p_dat_680_d, file = "Data/Pod_A000680_daily.csv")
# write.csv(p_dat_680_h, file = "Data/Pod_A000680_hourly.csv")
# write.csv(p_dat_671_d, file = "Data/Pod_A000671_daily.csv")
# write.csv(p_dat_671_h, file = "Data/Pod_A000671_hourly.csv")
# write.csv(p_dat_667_d, file = "Data/Pod_A000667_daily.csv")
# write.csv(p_dat_667_h, file = "Data/Pod_A000667_hourly.csv")

# setwd("~/multiscale_cropyield")
source("RScripts/functions.R")


# Part 2: calculate APAR and Yield for pod A000680, A000671, A000667
Pod_680_d <- p_dat_680_d
Pod_680_d <- data_preprocess(Pod_680_d)
Pod_680_d <- Pod_680_d %>% select(.,time,NDVI,SWdw) %>% mutate(PAR = SWdw*0.5)
APAR_Pod680 <- APAR(Pod_680_d)
Yield_Pod680 <- Yield(Pod_680_d)

Pod_671_d <- p_dat_671_d
Pod_671_d <- data_preprocess(Pod_671_d)
Pod_671_d <- Pod_671_d %>% select(.,time,NDVI,SWdw) %>% mutate(PAR = SWdw*0.5)
APAR_Pod671 <- APAR(Pod_671_d)
Yield_Pod671 <- Yield(Pod_671_d)

Pod_667_d <- p_dat_667_d
Pod_667_d <- data_preprocess(Pod_667_d)
Pod_667_d <- Pod_667_d %>% select(.,time,NDVI,SWdw) %>% mutate(PAR = SWdw*0.5)
APAR_Pod667 <- APAR(Pod_667_d)
Yield_Pod667 <- Yield(Pod_667_d)

result_APAR <- rbind(APAR_Pod680,APAR_Pod671,APAR_Pod667)
colnames(result_APAR) <- c("2018","2019")
# MJ/ha
result_APAR
result_Yield <- rbind(Yield_Pod680,Yield_Pod671,Yield_Pod667)
colnames(result_Yield) <- c("2018","2019")
# Kg/ha
result_Yield


# Part 3: processed-pod data export
# write.csv(Pod_680_d, file = "Data/Pod_680_d.csv")
# write.csv(Pod_671_d, file = "Data/Pod_671_d.csv")
# write.csv(Pod_667_d, file = "Data/Pod_667_d.csv")







