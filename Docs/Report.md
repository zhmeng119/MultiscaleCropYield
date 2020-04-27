Report: Multi-scale estimation of crop yield
================

## Intro

## Goals

## Data

Note that the `echo = FALSE` parameter was added to the code chunk to
prevent printing of the R code that generated the plot.

#### Daily

Here is an expample of `daily` pod data.

``` r
library(dplyr)

# read data from cvs
data_d <- read.csv(file = "Data/Pod_A000680_daily.csv")
# take a quick of the data 
sample_d <- data_d %>% select(.,time,device,Cl,NDVI,SWdw) %>% slice(85:95)
sample_d
#          time  device          Cl     NDVI       SWdw
# 1  2018-09-01 A000680  0.10694500 0.766762 17.9506000
# 2  2018-09-02 A000680  0.09242510 0.764612 19.3638000
# 3  2018-09-03 A000680  0.07942570 0.766486 21.1887000
# 4  2018-09-04 A000680  0.06404500 0.746997 20.9043000
# 5  2018-09-05 A000680  0.07871550 0.748597 20.3626000
# 6  2018-09-06 A000680          NA       NA  6.4099200
# 7  2019-06-17 A000680          NA       NA  0.0069294
# 8  2019-06-18 A000680 -0.00313247 0.188310  3.7446000
# 9  2019-06-19 A000680 -0.01391240 0.180733 13.9247000
# 10 2019-06-20 A000680 -0.01815440 0.192765  5.6505500
# 11 2019-06-21 A000680  0.00059674 0.181167  9.3119100
```

We can see that there are `NA` values in the dataset, which will do harm
to the calculation of `APRA`. Therefore, we will introduce preprocess
function to the dataset to get rid of `NA` values.

#### Hourly

Here is an expample of `hourly` pod data.

``` r
library(dplyr)

# read data from cvs
data_h <- read.csv(file = "Data/Pod_A000680_hourly.csv")
# take a quick of the data 
sample_h <- data_h %>% select(.,time,device,PARdw,PARuw,SWdw) %>% slice(85:95)
sample_h
#                   time  device     PARdw     PARuw      SWdw
# 1  2018-06-12 02:00:00 A000680   1.50545  -1.96747   1.11964
# 2  2018-06-12 03:00:00 A000680   1.43743  -1.79159   1.06905
# 3  2018-06-12 04:00:00 A000680   1.41738  -1.92903   1.05414
# 4  2018-06-12 05:00:00 A000680   1.44142  -1.87959   1.07201
# 5  2018-06-12 06:00:00 A000680   1.40538  -1.93451   1.04521
# 6  2018-06-12 07:00:00 A000680   1.38936  -1.92903   1.03330
# 7  2018-06-12 08:00:00 A000680   1.42941  -1.94001   1.06308
# 8  2018-06-12 09:00:00 A000680  20.24890  -4.24792  15.05960
# 9  2018-06-12 10:00:00 A000680 131.14400 -25.87290  97.53470
# 10 2018-06-12 11:00:00 A000680 361.78500 -53.11240 269.06800
# 11 2018-06-12 12:00:00 A000680 644.65000 -77.20120 479.44100
```

## Method
