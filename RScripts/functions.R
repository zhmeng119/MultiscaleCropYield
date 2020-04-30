# Calculate APAR & Yield
library(dplyr)
library(zoo)

# Pod data based
################################################################################################################################################################
# Part 1: data preprocessing

# A function used to clean up NDVI NA value and replace with interpolated value
data_preprocess <- function(dataset){
  # Pod_671_d dataset
  # check NA
  if("TRUE" %in% is.na(dataset$NDVI)) {
    # Get the index of NA for orginal dataset
    indexNA_raw <- which(is.na(dataset$NDVI))
    
    # get index of the end date of 2018 and start date of 2019
    enddate_2018 <- dataset %>% filter(.,time %>% substring(.,1,4)==2018) %>% count() %>% as.numeric()
    startdate_2019 <- enddate_2018+1
    
    # Interpolate NA value using library(zoo)
    # the independent variable is SWdw
    # Interpolation is seperated by year
    approxZ_2018 <- zoo::na.approx(dataset$NDVI[1:enddate_2018],na.rm = FALSE) %>% as.data.frame()
    approxZ_2019 <- zoo::na.approx(dataset$NDVI[startdate_2019:length(dataset$NDVI)],na.rm = FALSE) %>% as.data.frame()
    approxZ_whole <- rbind(approxZ_2018,approxZ_2019)
    print(which(is.na(approxZ_whole)))
    # check NA for the interpolation result, assign 0 to the NA value 
    # and change the value in dataset at the same time
    for(index in indexNA_raw){
      if(is.na(approxZ_whole[index,])== TRUE){
        print(c('The interpolated result is NA for index: ',index))
        print("this row will be removed")
        print("````````````````````````````````````````````````````")
        # dataset <- dataset[-c(index),]
        # print('replace value with 0')
        dataset$NDVI[index] <- 0
        # dataset <- dataset[!(dataset$NDVI==0),]
      } else{
        print(c('replace value with :', approxZ_whole[index,] %>% as.numeric()))
        dataset$NDVI[index] <- approxZ_whole[index,] %>% as.numeric()
      }
    }
    
    # the next step is remove record tha have 0 in NDVI
    dataset <- dataset[!(dataset$NDVI==0),]
    
    
  } else{
    # do nothing
  }
  return(dataset)
}
# # create a test dataset
# testdataset <- p_dat_680_d
# # check NA for NDVI
# which(is.na(testdataset$NDVI))
# # implement preprocess function on dataset
# testdataset <- data_preprocess(testdataset)
# # check NA for NDVI
# which(is.na(testdataset$NDVI))


# Part 2: calculate APRA

# # create testing dataset
# Pod_680_d <- p_dat_680_d
# Pod_680_d <- data_preprocess(Pod_680_d)
# # assuming PAR is 0.5 of SWdw
# Pod_680_d <- Pod_680_d %>% select(.,time,NDVI,SWdw) %>% mutate(PAR = SWdw*0.5)


# A function used to return the max and min value of NDVI from
# index 1: min
# index 2; max
getMaxMinNDVI <- function(dataset){
  # find min non-zero value in NDVI
  minNDVI <- min(dataset$NDVI[dataset$NDVI>0])
  maxNDVI <- max(dataset$NDVI)
  
  return(c(minNDVI,maxNDVI))
}
# # testing function
# Pod_680_d_2018 <- Pod_680_d %>% filter(.,time %>% substring(.,1,4)==2018)
# Pod_680_d_2019 <- Pod_680_d %>% filter(.,time %>% substring(.,1,4)==2019)
# mmNDVI_2018 <- getMaxMinNDVI(Pod_680_d_2018)
# mmNDVI_2019 <- getMaxMinNDVI(Pod_680_d_2019)


# Calculate Σ(PAR*fPAR) and return a value
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
# # testing
# sig_Pod680_2018 <- sumPARfPAR(Pod_680_d_2018)
# sig_Pod680_2019 <- sumPARfPAR(Pod_680_d_2019)
# sigsat_pod680_2018 <- sumPARfPAR(sat_pod680_2018)


# Calculate APRA and return a vector that contains APRA for 2018 & 2019
# index 1: 2018 APAR
# index 2; 2019 APAR
APAR <- function(dataset){
  
  # unit conversion index
  # kg/ha
  unitCon <- 864*0.001
  
  dataset_2018 <- dataset %>% filter(.,time %>% substring(.,1,4)==2018)
  dataset_2019 <- dataset %>% filter(.,time %>% substring(.,1,4)==2019)
  
  sum_2018 <- sumPARfPAR(dataset_2018)
  sum_2019 <- sumPARfPAR(dataset_2019)
  
  APAR_2018 <- sum_2018*length(dataset_2018$time)*unitCon
  APAR_2019 <- sum_2019*length(dataset_2019$time)*unitCon
  
  return(c(APAR_2018,APAR_2019))
}
# # testinga
# APAR_Pod680 <- APAR(Pod_680_d)


# Calculate APRA and return a vector that contains APRA for 2018 & 2019
# index 1: 2018 APAR
# index 2; 2019 APAR
Yield <- function(dataset){
  
  # unit conversion index
  # kg/ha
  unitCon <- 864*0.001
  
  # 4.2 is provided by the dsat tutorial
  LUE <- 4.2
  
  # 
  HI <- 0.4
  
  dataset_2018 <- dataset %>% filter(.,time %>% substring(.,1,4)==2018)
  dataset_2019 <- dataset %>% filter(.,time %>% substring(.,1,4)==2019)
  
  sum_2018 <- sumPARfPAR(dataset_2018)
  sum_2019 <- sumPARfPAR(dataset_2019)
  
  Yield_2018 <- sum_2018*length(dataset_2018$time)*unitCon*LUE*HI
  Yield_2019 <- sum_2019*length(dataset_2019$time)*unitCon*LUE*HI
  
  return(c(Yield_2018,Yield_2019))
}

###############################################################################################################################################################


# satellite data based
###############################################################################################################################################################
# A function to preprocess downloaded NDVI data based on Sentinel-2 for pod A000680, A000671, A000667
satdata_preprocess <- function(sat_data){
  ## select date and NDVI value from the list
  sat_data <- sat_data %>% select(.,date ,NDVI)
  sat_data$date <- sat_data$date %>% as.Date()
  
  ## calculate the mean of NDVI for repeated dates
  sat_data <- aggregate(NDVI~date,sat_data,mean)
  sat_data <- sat_data %>% as.data.frame()
  
  return(sat_data)
}

# A function to replace NDVI in pod data with satellite data, and return a new dataset
sat_pod_process <- function(sat_data, pod_d){
  ## select out data that are available in sat_data from pod_d 
  pod_d <- pod_d[(pod_d$time %>% ymd()) %in% sat_data$date,]
  pod_d$time <- pod_d$time %>% as.Date()
  pod_d <- pod_d %>% as.data.frame()
  
  # drop unnecessary cols
  pod_d <- subset(pod_d, select=-c(X,NDVI))
  
  sat_pod <- merge(pod_d,sat_data,by.x = "time",by.y = "date")
  
  return(sat_pod)
}

# # Testing
# # try to read date from CSV files
# pod680 <- read.csv(file = 'Data/Pod_680_d.csv')
# gee_pod680_2018 <- read.csv(file = 'Data/EO_pod_NDVI_data/pod680_2018.csv')
# 
# ## do some cleaning work on the gee data
# gee_pod680_2018 <- gee_pod680_2018 %>% select(.,date ,NDVI)
# gee_pod680_2018$date <- gee_pod680_2018$date %>% as.Date()
# 
# ## get the mean of repeated dates
# gee_pod680_2018 <- aggregate(NDVI~date,gee_pod680_2018,mean)
# gee_pod680_2018 <- gee_pod680_2018 %>% as.data.frame()
# 
# ## select out the data that are available in GEE
# pod680 <- pod680[(pod680$time %>% ymd()) %in% gee_pod680_2018$date,]
# pod680$time <- pod680$time %>% as.Date()
# pod680 <- pod680 %>% as.data.frame()
# pod680 <- subset(pod680, select=-c(X,NDVI))
# 
# sat_pod680_2018 <- merge(pod680,gee_pod680_2018,by.x = "time",by.y = "date")
###############################################################################################################################################################
