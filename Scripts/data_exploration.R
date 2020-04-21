library(aRable)

# Read hourly & daily data data from server

# A000680
p_dat_680_d <- ArableClient(device = "A000680", measure = "daily",
                         start = "2017-06-01", end = "2019-09-06",
                         email = "lestes@clarku.edu",
                         password = "rollinghills88",  # replace this w/ actual p
                         tenant = "clark")
p_dat_680_h <- ArableClient(device = "A000680", measure = "hourly",
                                start = "2017-06-01", end = "2019-09-06",
                                email = "lestes@clarku.edu",
                                password = "rollinghills88",  # replace this w/ actual p
                                tenant = "clark")

# A000671
p_dat_671_d <- ArableClient(device = "A000671", measure = "daily",
                                 start = "2017-06-01", end = "2019-09-06",
                                 email = "lestes@clarku.edu",
                                 password = "rollinghills88",  # replace this w/ actual p
                                 tenant = "clark")
p_dat_671_h <- ArableClient(device = "A000671", measure = "hourly",
                            start = "2017-06-01", end = "2019-09-06",
                            email = "lestes@clarku.edu",
                            password = "rollinghills88",  # replace this w/ actual p
                            tenant = "clark")

# A000667
p_dat_667_d <- ArableClient(device = "A000667", measure = "daily",
                                 start = "2017-06-01", end = "2019-09-06",
                                 email = "lestes@clarku.edu",
                                 password = "rollinghills88",  # replace this w/ actual p
                                 tenant = "clark")
p_dat_667_h <- ArableClient(device = "A000667", measure = "hourly",
                            start = "2017-06-01", end = "2019-09-06",
                            email = "lestes@clarku.edu",
                            password = "rollinghills88",  # replace this w/ actual p
                            tenant = "clark")

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


# Testing
# Calculate APAR  
library(dplyr)
library(zoo)

# Part 1: data preprocessing

# A function used to clean up NDVI NA value and replace with interpolated value
data_preprocess <- function(dataset){
  # check NA
  if("TRUE" %in% is.na(dataset$NDVI)) {
    # Get the index of NA for orginal dataset
    indexNA_raw <- which(is.na(dataset$NDVI))
    
    # get index of the end date of 2018 and start date of 2019
    enddate_2018 <- dataset %>% filter(.,time %>% substring(.,1,4)==2018) %>% count() %>% as.numeric()
    startdate_2019 <- days2018+1
    
    # Interpolate NA value using library(zoo)
    # the independent variable is SWdw
    # Interpolation is seperated by year
    tempZ_Whole <- zoo(dataset)
    approxZ_2018 <- na.approx(tempZ_Whole$NDVI[1:enddate_2018],tempZ_Whole$SWdw[1:enddate_2018],na.rm = FALSE)
    approxZ_2019 <- na.approx(tempZ_Whole$NDVI[startdate_2019:length(dataset$NDVI)],tempZ_Whole$SWdw[startdate_2019:length(dataset$SWdw)],na.rm = FALSE)
    approxZ_whole <- rbind(approxZ_2018,approxZ_2019)
    # check NA for the interpolation result, assign 0 to the NA value 
    # and change the value in dataset at the same time
    for(index in indexNA_raw){
      if(is.na(approxZ_whole[index])== TRUE){
        print('replace value with 0')
        dataset$NDVI[index] <- 0
      } else{
        print(c('replace value with :', approxZ_whole[index] %>% as.numeric()))
        dataset$NDVI[index] <- approxZ_whole[index] %>% as.numeric()
      }
    }
    
    
  } else{
    # do nothing
  }
  return(dataset)
}

# create a test dataset
testdataset <- p_dat_680_d
# check NA for NDVI
which(is.na(testdataset$NDVI))
# implement preprocess function on dataset
testdataset <- data_preprocess(testdataset)
# check NA for NDVI
which(is.na(testdataset$NDVI))


# Part 2: calculate APRA

# create testing dataset
Pod_680_d <- p_dat_680_d
Pod_680_d <- data_preprocess(Pod_680_d)
# assuming PAR is 0.5 of SWdw
Pod_680_d <- Pod_680_d %>% select(.,time,NDVI,SWdw) %>% mutate(PAR = SWdw*0.5)


# A function used to return the max and min value of NDVI from
# index 1: min
# index 2; max
getMaxMinNDVI <- function(dataset){
  # find min non-zero value in NDVI
  minNDVI <- min(dataset$NDVI[dataset$NDVI>0])
  maxNDVI <- max(dataset$NDVI)

  return(c(minNDVI,maxNDVI))
}
# testing function
Pod_680_d_2018 <- Pod_680_d %>% filter(.,time %>% substring(.,1,4)==2018)
Pod_680_d_2019 <- Pod_680_d %>% filter(.,time %>% substring(.,1,4)==2019)
mmNDVI_2018 <- getMaxMinNDVI(Pod_680_d_2018)
mmNDVI_2019 <- getMaxMinNDVI(Pod_680_d_2019)


# calculate Σ(PAR*fPAR) and return a value
sumPARfPAR <- function(dataset){
  temp_sum <- 0
  for(day in 1:length(dataset$time)){
    # print(day)
    PAR <- dataset$PAR[day]
    # calculate fPAR
    mmNDVI <- getMaxMinNDVI(dataset)
    fPAR <- 1-((mmNDVI[2]-dataset$NDVI[day])/(mmNDVI[2]-mmNDVI[1]))^0.625
    temp_sum <- temp_sum + PAR*fPAR
    # print(temp_sum)
  }
  return(temp_sum)
}
# testing
sig_Pod680_2018 <- sumPARfPAR(Pod_680_d_2018)
sig_Pod680_2019 <- sumPARfPAR(Pod_680_d_2019)


# calculate APRA and return a vector that contains APRA for 2018 & 2019
# index 1: 2018 APAR
# index 2; 2019 APAR
APAR <- function(dataset){
  
  dataset_2018 <- dataset %>% filter(.,time %>% substring(.,1,4)==2018)
  dataset_2019 <- dataset %>% filter(.,time %>% substring(.,1,4)==2019)
  
  sum_2018 <- sumPARfPAR(dataset_2018)
  sum_2019 <- sumPARfPAR(dataset_2019)
  
  APAR_2018 <- sum_2018*length(dataset_2018$time)
  APAR_2019 <- sum_2019*length(dataset_2019$time)
  
  return(c(APAR_2018,APAR_2019))
}
# testing
APAR_Pod680 <- APAR(Pod_680_d)















