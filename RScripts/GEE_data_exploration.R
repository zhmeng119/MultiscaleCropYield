setwd("~/multiscale_cropyield")
source("RScripts/functions.R")
source("RScripts/data_exploration.R")



# Part 1: generate Yield from satellite data
# Pod A000680
pod680 <- read.csv(file = 'Data/Pod_680_d.csv')
gee_pod680_2018 <- read.csv(file = 'Data/EO_pod_NDVI_data/pod680_2018.csv')
gee_pod680_2019 <- read.csv(file = 'Data/EO_pod_NDVI_data/pod680_2019.csv')

gee_pod680_2018 <- satdata_preprocess(gee_pod680_2018)
sat_pod680_2018 <- sat_pod_process(gee_pod680_2018, pod680)
gee_pod680_2019 <- satdata_preprocess(gee_pod680_2019)
sat_pod680_2019 <- sat_pod_process(gee_pod680_2019, pod680)

sat_pod680 <- rbind(sat_pod680_2018,sat_pod680_2019)
Yield_sat_pod680 <- Yield(sat_pod680)

# Pod A000671
pod671 <- read.csv(file = 'Data/Pod_671_d.csv')
gee_pod671_2018 <- read.csv(file = 'Data/EO_pod_NDVI_data/pod671_2018.csv')
gee_pod671_2019 <- read.csv(file = 'Data/EO_pod_NDVI_data/pod671_2019.csv')

gee_pod671_2018 <- satdata_preprocess(gee_pod671_2018)
sat_pod671_2018 <- sat_pod_process(gee_pod671_2018, pod671)
gee_pod671_2019 <- satdata_preprocess(gee_pod671_2019)
sat_pod671_2019 <- sat_pod_process(gee_pod671_2019, pod671)

sat_pod671 <- rbind(sat_pod671_2018,sat_pod671_2019)
Yield_sat_pod671 <- Yield(sat_pod671)

# Pod A000667
pod667 <- read.csv(file = 'Data/Pod_667_d.csv')
gee_pod667_2018 <- read.csv(file = 'Data/EO_pod_NDVI_data/pod667_2018.csv')
gee_pod667_2019 <- read.csv(file = 'Data/EO_pod_NDVI_data/pod667_2019.csv')

gee_pod667_2018 <- satdata_preprocess(gee_pod667_2018)
sat_pod667_2018 <- sat_pod_process(gee_pod667_2018, pod667)
gee_pod667_2019 <- satdata_preprocess(gee_pod667_2019)
sat_pod667_2019 <- sat_pod_process(gee_pod667_2019, pod667)

sat_pod667 <- rbind(sat_pod667_2018,sat_pod667_2019)
Yield_sat_pod667 <- Yield(sat_pod667)

# Combine results from pod A000680, A000671, A000667
result_Yield_sat <- rbind(Yield_sat_pod680,Yield_sat_pod671,Yield_sat_pod667)



# Part 2: compare the results from pod data and satellite data
# Shrink down the dataset to the size of satellite data based on the date
Pod_680_d$time <- Pod_680_d$time %>% as.Date()
Pod_671_d$time <- Pod_671_d$time %>% as.Date()
Pod_667_d$time <- Pod_667_d$time %>% as.Date()


test_Pod680_d_2018 <- Pod_680_d[(Pod_680_d$time %>% ymd()) %in% gee_pod680_2018$date,]
test_Pod680_d_2019 <- Pod_680_d[(Pod_680_d$time %>% ymd()) %in% gee_pod680_2019$date,]
test_Pod680_d <- rbind(test_Pod680_d_2018,test_Pod680_d_2019)
testYield_Pod680 <- Yield(test_Pod680_d)

test_Pod671_d_2018 <- Pod_671_d[(Pod_671_d$time %>% ymd()) %in% gee_pod671_2018$date,]
test_Pod671_d_2019 <- Pod_671_d[(Pod_671_d$time %>% ymd()) %in% gee_pod671_2019$date,]
test_Pod671_d <- rbind(test_Pod671_d_2018,test_Pod671_d_2019)
testYield_Pod671 <- Yield(test_Pod671_d)

test_Pod667_d_2018 <- Pod_667_d[(Pod_667_d$time %>% ymd()) %in% gee_pod667_2018$date,]
test_Pod667_d_2019 <- Pod_667_d[(Pod_667_d$time %>% ymd()) %in% gee_pod667_2019$date,]
test_Pod667_d <- rbind(test_Pod667_d_2018,test_Pod667_d_2019)
testYield_Pod667 <- Yield(test_Pod667_d)

result_testYield_pod <- rbind(testYield_Pod680,testYield_Pod671,testYield_Pod667)



result_testYield_pod
result_Yield_sat

# Part 3: Plot the NDVI value 
library(ggplot2)

test_Pod680_d
sat_pod680_2018
sat_pod680_2019
test_Pod680_d_2018
test_Pod680_d_2019


ggplot()+
  geom_line(data = sat_pod680_2018, aes(x = time %>% as.Date(), y = NDVI), color="red") +
  geom_line(data = test_Pod680_d_2018, aes(x = time %>% as.Date(), y = NDVI), color="blue") +
  xlab("Date") +
  scale_color_identity(guide = "legend")










