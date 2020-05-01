Report: Multi-scale estimation of crop yield
================

## Intro

## Goals

## Data

### Part 1: Pod data

#### Daily

Here is an expample of `daily` pod data.

``` r
library(dplyr)

# read data from cvs
data_d <- read.csv(file = "Data/Pod_A000680_daily.csv")
# take a quick of the data 
sample_d <- data_d %>% select(.,time,device,Cl,NDVI,SWdw) %>% slice(85:95)
head(sample_d)
```

    ##         time  device        Cl     NDVI     SWdw
    ## 1 2018-09-01 A000680 0.1069450 0.766762 17.95060
    ## 2 2018-09-02 A000680 0.0924251 0.764612 19.36380
    ## 3 2018-09-03 A000680 0.0794257 0.766486 21.18870
    ## 4 2018-09-04 A000680 0.0640450 0.746997 20.90430
    ## 5 2018-09-05 A000680 0.0787155 0.748597 20.36260
    ## 6 2018-09-06 A000680        NA       NA  6.40992

We can see that there are `NA` values in the dataset, which will do harm
to the calculation of `APRA`. Therefore, we will introduce preprocess
function to the dataset to get rid of `NA` values.

#### Hourly

Here is an expample of `hourly` pod data.

``` r
# read data from cvs
data_h <- read.csv(file = "Data/Pod_A000680_hourly.csv")
# take a quick of the data 
sample_h <- data_h %>% select(.,time,device,PARdw,PARuw,SWdw) %>% slice(85:95)
head(sample_h)
```

    ##                  time  device   PARdw    PARuw    SWdw
    ## 1 2018-06-12 02:00:00 A000680 1.50545 -1.96747 1.11964
    ## 2 2018-06-12 03:00:00 A000680 1.43743 -1.79159 1.06905
    ## 3 2018-06-12 04:00:00 A000680 1.41738 -1.92903 1.05414
    ## 4 2018-06-12 05:00:00 A000680 1.44142 -1.87959 1.07201
    ## 5 2018-06-12 06:00:00 A000680 1.40538 -1.93451 1.04521
    ## 6 2018-06-12 07:00:00 A000680 1.38936 -1.92903 1.03330

### Part 2: Sentinel 2 processed data

The data is pulled from GoogleEarthEngine based on the location of pod
A000680, A000671, A000667.

#### Daily

``` r
gee_pod680_2018 <- read.csv(file = 'Data/EO_pod_NDVI_data/pod680_2018.csv')
gee_pod680_2019 <- read.csv(file = 'Data/EO_pod_NDVI_data/pod680_2019.csv')

head(gee_pod680_2018 %>% select(.,date, NDVI))
```

    ##                  date      NDVI
    ## 1 2018-06-09T15:38:11 0.3356557
    ## 2 2018-06-09T15:38:11 0.3338829
    ## 3 2018-06-12T15:49:19 0.2206600
    ## 4 2018-06-12T15:49:19 0.2272069
    ## 5 2018-06-14T15:39:24 0.2712531
    ## 6 2018-06-14T15:39:24 0.2631074

``` r
head(gee_pod680_2019 %>% select(.,date, NDVI))
```

    ##                  date      NDVI
    ## 1 2019-06-19T15:41:36 0.1354669
    ## 2 2019-06-19T15:41:36 0.1458582
    ## 3 2019-06-22T15:51:33 0.3057989
    ## 4 2019-06-22T15:51:33 0.3141667
    ## 5 2019-06-24T15:41:41 0.2158766
    ## 6 2019-06-24T15:41:41 0.2182857

We can see there are repeated date values in the raw data, so we will
`aggregate` the repeated values by `mean`. And we also notice that the
Sentinel 2 data is not generated daily due to the temporal resolution.

## Method

## Result

### Yield prediction based on pod data (ε = 4.2, HI = 0.7)

``` r
# Results of APAR
                2018     2019
APAR_Pod680 43540.34 31586.62
APAR_Pod671 44077.92 33530.94
APAR_Pod667 45864.11 32117.12

# Results of Yield 
                 2018     2019
Yield_Pod680 128008.6 92864.66
Yield_Pod671 129589.1 98580.96
Yield_Pod667 134840.5 94424.33
```

### Results of comparison between pod data and Sentinel 2 - 1C data

There are 35 records in 2018, and 31 in 2019. Therefore, the `Yield`
value will be smaller than the pod based data.

``` r
# Pod
                     2018     2019
testYield_Pod680 19738.87 12957.23
testYield_Pod671 19480.00 13256.72
testYield_Pod667 19928.53 13297.09

# Sentinel 2 -1C
                     2018      2019
Yield_sat_pod680 14814.60 10293.292
Yield_sat_pod671 14367.76 10871.309
Yield_sat_pod667 14954.93  9827.617
```

## Summary

## Acknowledgements

  - Lobell, D. B., Asner, G. P., Ortiz-Monasterio, J. I., & Benning, T.
    L. (2003). Remote sensing of regional crop production in the Yaqui
    Valley, Mexico: estimates and uncertainties. Agriculture, Ecosystems
    & Environment, 94(2), 205-220.
