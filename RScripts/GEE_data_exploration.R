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
colnames(result_Yield_sat) <- c("2018","2019")
result_Yield_sat



# Part 2: compare the results between pod data and satellite data
result_Yield
result_Yield_sat

# # Part 3: Plot the NDVI value 
# library(ggplot2)
# library(cowplot)
# 
# 
# 
# sat_pod680_2018
# sat_pod680_2019
# test_Pod680_d_2018 <- Pod_680_d  %>% filter(.,time %>% substring(.,1,4)==2018)
# test_Pod680_d_2019 <- Pod_680_d  %>% filter(.,time %>% substring(.,1,4)==2019)
# 
# 
# pod680_p1 <- ggplot()+
#   geom_line(data = sat_pod680_2018, aes(x = time %>% as.Date(), y = NDVI), color="red") +
#   geom_line(data = test_Pod680_d_2018, aes(x = time %>% as.Date(), y = NDVI), color="blue") +
#   xlab("Date (2018)") +
#   ggtitle("Pod NDVI(blue) VS Sentinel-2 NDVI(red), Pod680")
# 
# pod680_p2 <- ggplot()+
#   geom_line(data = sat_pod680_2019, aes(x = time %>% as.Date(), y = NDVI), color="red") +
#   geom_line(data = test_Pod680_d_2019, aes(x = time %>% as.Date(), y = NDVI), color="blue") +
#   xlab("Date (2019)") +
#   ggtitle("Pod NDVI(blue) VS Sentinel-2 NDVI(red), Pod680")
# 
# 
# pod680_gp <- cowplot::plot_grid(pod680_p1,pod680_p2) +
#   draw_text("Pod NDVI(blue) VS Sentinel-2 NDVI(red), Pod680", hjust = 0.5, vjust = 0.1)
# 
# 
# 
# 
# ################################################################################################
# pod671_p1 <- ggplot()+
#   geom_line(data = sat_pod671_2018, aes(x = time %>% as.Date(), y = NDVI), color="red") +
#   geom_line(data = test_Pod671_d_2018, aes(x = time %>% as.Date(), y = NDVI), color="blue") +
#   xlab("Date (2018)") +
#   ggtitle("Pod NDVI(blue) VS Sentinel-2 NDVI(red), Pod671")
# 
# pod671_p2 <- ggplot()+
#   geom_line(data = sat_pod671_2019, aes(x = time %>% as.Date(), y = NDVI), color="red") +
#   geom_line(data = test_Pod671_d_2019, aes(x = time %>% as.Date(), y = NDVI), color="blue") +
#   xlab("Date (2019)") +
#   ggtitle("Pod NDVI(blue) VS Sentinel-2 NDVI(red), Pod671")
# 
# pod671_gp <- cowplot::plot_grid(pod671_p1,pod671_p2)
# ################################################################################################
# pod667_p1 <- ggplot()+
#   geom_line(data = sat_pod667_2018, aes(x = time %>% as.Date(), y = NDVI), color="red") +
#   geom_line(data = test_Pod667_d_2018, aes(x = time %>% as.Date(), y = NDVI), color="blue") +
#   xlab("Date (2018)") +
#   ggtitle("Pod NDVI(blue) VS Sentinel-2 NDVI(red), Pod667")
# 
# pod667_p2 <- ggplot()+
#   geom_line(data = sat_pod667_2019, aes(x = time %>% as.Date(), y = NDVI), color="red") +
#   geom_line(data = test_Pod667_d_2019, aes(x = time %>% as.Date(), y = NDVI), color="blue") +
#   xlab("Date (2019)") +
#   ggtitle("Pod NDVI(blue) VS Sentinel-2 NDVI(red), Pod667")
# 
# pod667_gp <- cowplot::plot_grid(pod667_p1,pod667_p2)
# 
# # Summary plot
# cowplot::plot_grid(pod680_gp,pod671_gp,pod667_gp)
# 
# 
# 
# # Smooth curve
# pod680_smo1 <- ggplot()+
#   geom_point(data = sat_pod680_2018, aes(x = time %>% as.Date(), y = NDVI), color="red") +
#   geom_smooth(data = sat_pod680_2018, aes(x = time %>% as.Date(), y = NDVI), color="red") +
#   geom_point(data = test_Pod680_d_2018, aes(x = time %>% as.Date(), y = NDVI), color="blue") +
#   geom_smooth(data = test_Pod680_d_2018, aes(x = time %>% as.Date(), y = NDVI), color="blue") +
#   xlab("Date (2018)") +
#   ggtitle("Pod NDVI(blue) VS Sentinel-2 NDVI(red), Pod680")
# pod680_smo2 <- ggplot()+
#   geom_point(data = sat_pod680_2019, aes(x = time %>% as.Date(), y = NDVI), color="red") +
#   geom_smooth(data = sat_pod680_2019, aes(x = time %>% as.Date(), y = NDVI), color="red") +
#   geom_point(data = test_Pod680_d_2019, aes(x = time %>% as.Date(), y = NDVI), color="blue") +
#   geom_smooth(data = test_Pod680_d_2019, aes(x = time %>% as.Date(), y = NDVI), color="blue") +
#   xlab("Date (2019)") +
#   ggtitle("Pod NDVI(blue) VS Sentinel-2 NDVI(red), Pod680")
# pod680_smo <- cowplot::plot_grid(pod680_smo1,pod680_smo2)
# ##############################################################################################
# pod671_smo1 <- ggplot()+
#   geom_point(data = sat_pod671_2018, aes(x = time %>% as.Date(), y = NDVI), color="red") +
#   geom_smooth(data = sat_pod671_2018, aes(x = time %>% as.Date(), y = NDVI), color="red") +
#   geom_point(data = test_Pod671_d_2018, aes(x = time %>% as.Date(), y = NDVI), color="blue") +
#   geom_smooth(data = test_Pod671_d_2018, aes(x = time %>% as.Date(), y = NDVI), color="blue") +
#   xlab("Date (2018)") +
#   ggtitle("Pod NDVI(blue) VS Sentinel-2 NDVI(red), Pod671")
# pod671_smo2 <- ggplot()+
#   geom_point(data = sat_pod671_2019, aes(x = time %>% as.Date(), y = NDVI), color="red") +
#   geom_smooth(data = sat_pod671_2019, aes(x = time %>% as.Date(), y = NDVI), color="red") +
#   geom_point(data = test_Pod671_d_2019, aes(x = time %>% as.Date(), y = NDVI), color="blue") +
#   geom_smooth(data = test_Pod671_d_2019, aes(x = time %>% as.Date(), y = NDVI), color="blue") +
#   xlab("Date (2019)") +
#   ggtitle("Pod NDVI(blue) VS Sentinel-2 NDVI(red), Pod671")
# pod671_smo <- cowplot::plot_grid(pod671_smo1,pod671_smo2)
# ##############################################################################################
# pod667_smo1 <- ggplot()+
#   geom_point(data = sat_pod667_2018, aes(x = time %>% as.Date(), y = NDVI), color="red") +
#   geom_smooth(data = sat_pod667_2018, aes(x = time %>% as.Date(), y = NDVI), color="red") +
#   geom_point(data = test_Pod667_d_2018, aes(x = time %>% as.Date(), y = NDVI), color="blue") +
#   geom_smooth(data = test_Pod667_d_2018, aes(x = time %>% as.Date(), y = NDVI), color="blue") +
#   xlab("Date (2018)") +
#   ggtitle("Pod NDVI(blue) VS Sentinel-2 NDVI(red), Pod667")
# pod667_smo2 <- ggplot()+
#   geom_point(data = sat_pod667_2019, aes(x = time %>% as.Date(), y = NDVI), color="red") +
#   geom_smooth(data = sat_pod667_2019, aes(x = time %>% as.Date(), y = NDVI), color="red") +
#   geom_point(data = test_Pod667_d_2019, aes(x = time %>% as.Date(), y = NDVI), color="blue") +
#   geom_smooth(data = test_Pod667_d_2019, aes(x = time %>% as.Date(), y = NDVI), color="blue") +
#   xlab("Date (2019)") +
#   ggtitle("Pod NDVI(blue) VS Sentinel-2 NDVI(red), Pod667")
# pod667_smo <- cowplot::plot_grid(pod667_smo1,pod667_smo2)
# 
# 
# # Summary plot
# cowplot::plot_grid(pod680_smo,pod671_smo,pod667_smo)
# 
# temp_sat_pod680 <- sat_pod680 %>% mutate(., year = sat_pod680$time %>% substring(.,1,4))
# 
# ggplot()+
#   geom_line(data = temp_sat_pod680, aes(x = c(1:90), y = NDVI), colour=year) +
#   # geom_line(data = test_Pod680_d_2018, aes(x = time %>% as.Date(), y = NDVI), color="blue") +
#   xlab("Date") +
#   ggtitle("Pod NDVI(blue) VS Sentinel-2 NDVI(red), Pod680")
# 
# 

  


