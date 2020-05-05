Report: Multi-Scale Estimation of Crop Yield
================

## Introduction

The quantification of crop production at the regional level is not only
important for local farmers but also benefits the management and carbon
cycle modeling. In this project, we are going to use Mark
micro-meteorology estimates (a maize field dataset collected at Whittier
Farms, in Sutton, MA) and Sentinel-2 1C level data to predict maize
yields.

#### Goals

  - What is the overall aim of the project and what specific Earth
    Observation problem is it trying to solve?
    
    This project is aiming to compare the predicted maize yield results
    generated from data with different spatial scales, such as ground
    level and space level, and hopefully, the comparison can help us
    understand what are the factors that are affecting the predicted
    yield.

## Data

### Part 1: Pod data

#### Daily

Here is an expample of `daily` pod data.

``` r
library(dplyr)

# read data from cvs
data_d <- read.csv(file = "Data/Pod_A000680_daily.csv")
# take a quick of the data 
sample_d <- data_d %>% select(.,time,device,Cl,NDVI,SWdw) %>% slice(88:98)
head(sample_d)
```

    ##         time  device          Cl     NDVI       SWdw
    ## 1 2018-09-04 A000680  0.06404500 0.746997 20.9043000
    ## 2 2018-09-05 A000680  0.07871550 0.748597 20.3626000
    ## 3 2018-09-06 A000680          NA       NA  6.4099200
    ## 4 2019-06-17 A000680          NA       NA  0.0069294
    ## 5 2019-06-18 A000680 -0.00313247 0.188310  3.7446000
    ## 6 2019-06-19 A000680 -0.01391240 0.180733 13.9247000

We can see that there are `NA` values in the dataset, which will do harm
to the calculation of `APRA`. Therefore, we will introduce preprocess
function to the dataset to get rid of `NA` values.

#### Hourly

Here is an expample of `hourly` pod data.

``` r
source("RScripts/functions.R")
# read data from cvs
data_h <- read.csv(file = "Data/Pod_A000680_hourly.csv")
# take a quick of the data 
sample_h <- data_h %>% select(.,time,device,PARdw,PARuw,SWdw) %>% slice(88:98)
head(sample_h)
```

    ##                  time  device     PARdw     PARuw     SWdw
    ## 1 2018-06-12 05:00:00 A000680   1.44142  -1.87959  1.07201
    ## 2 2018-06-12 06:00:00 A000680   1.40538  -1.93451  1.04521
    ## 3 2018-06-12 07:00:00 A000680   1.38936  -1.92903  1.03330
    ## 4 2018-06-12 08:00:00 A000680   1.42941  -1.94001  1.06308
    ## 5 2018-06-12 09:00:00 A000680  20.24890  -4.24792 15.05960
    ## 6 2018-06-12 10:00:00 A000680 131.14400 -25.87290 97.53470

### Part 2: Sentinel 2 processed data

The data is pulled from GoogleEarthEngine based on the location of pod
A000680, A000671, A000667.

#### 2-3 days

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

We can see there are repeated date values in the raw data, this is
because the study area is right on the overlay section of two tiles, so
we will `aggregate` the repeated records by `mean`. And we also notice
that the Sentinel 2 data is not generated daily due to the temporal
resolution.

## Methodology

  - What were the methods you developed and/or applied, and why they
    might be considered “New Methods in Earth Observation”?
    
    The calculation of predicted yield relys on a simple and useful
    paradigm Yield = APAR \* ε \* HI (Monteith (1972, 1977)), and it
    requires the combination of knowledge of crop phenology and
    multi-temporal data. The PAR in equation (2) will be replaced with
    (4), and the SWdw value is generated from field-based sensor. As for
    the NDVI in fAPAR, we have data generated from both field-based
    sensor and satellite (Sentinel 2).

  - Equations

![](../Docs/figures/Oneforall.png)

We can tell that the units are not at the same level, therefore it is
necessary to do the `unit conversion` in the later calculation.

## Workflow

#### Pod-based

1.  Read in pod dataset with `ArableClient()`

<!-- end list -->

``` r
library(aRable)
p_dat_680_d <- ArableClient(device = "A000680", measure = "daily",
                         start = "2017-06-01", end = "2019-09-06",
                         email = "lestes@clarku.edu",
                         password = "rollinghills88",  # replace this w/ actual p
                         tenant = "clark")
```

    ## 
    ## getting daily 2017-06-01 to 2019-09-06 
    ## status:  200 
    ## 
    ## collected 171 rows from 2018-06-09 to 2019-09-05

2.  Feed the pod dataset to data preprocessing function
    (`data_preprocess()`)

<!-- end list -->

  - Split the pod dataset by **year**(`pod_2018` & `pod_2019`);
  - Linearly Interpolate NDVI for `pod_2018` and `pod_2019` data;
  - Check if `pod_2018` and `pod_2019` still contain NA NDVI value;
      - 1)  Yes: Remove the corresponding row from the dataset
    
      - 2)  No: Skip to the last step
  - Combine `pod_2018` and `pod_2019` and output the dataset.

<!-- end list -->

``` r
Pod_680_d <- p_dat_680_d
which(is.na(Pod_680_d$NDVI))
```

    ## [1] 90 91

``` r
Pod_680_d <- data_preprocess(Pod_680_d)
```

    ## [1] "The interpolated result is NA for index: "
    ## [2] "90"                                       
    ## [1] "this row will be removed"
    ## [1] "````````````````````````````````````````````````````"
    ## [1] "The interpolated result is NA for index: "
    ## [2] "91"                                       
    ## [1] "this row will be removed"
    ## [1] "````````````````````````````````````````````````````"

``` r
which(is.na(Pod_680_d$NDVI))
```

    ## integer(0)

3.  Select column time, NDVI, SWdw from the preprocessed pod dataset,
    and create a new column called PAR and PAR =0.5\*SWdw.

<!-- end list -->

``` r
Pod_680_d <- Pod_680_d %>% select(.,time,NDVI,SWdw) %>% mutate(PAR = SWdw*0.5)
head(Pod_680_d)
```

    ##         time     NDVI     SWdw       PAR
    ## 1 2018-06-09 0.158659 25.89700 12.948500
    ## 2 2018-06-10 0.160513 18.20630  9.103150
    ## 3 2018-06-11 0.163853 23.56120 11.780600
    ## 4 2018-06-12 0.162300 29.63530 14.817650
    ## 5 2018-06-13 0.182344  9.70175  4.850875
    ## 6 2018-06-14 0.180022 24.04730 12.023650

4.  Feed the result from *Step 3* to function `Yield()` to calculate
    predicted yield. The first value in the result is the predicted
    yield for 2018, and the sencond value is for 2019.

<!-- end list -->

``` r
Yield_Pod680 <- Yield(Pod_680_d)
Yield_Pod680
```

    ## [1] 9512.559 7677.303

#### Sentinel2-based

1.  [Pull the Sentinel2 data from
    GEE](https://code.earthengine.google.com/80d92e7cbbed5a2e12935bb96e503534)

<!-- end list -->

  - Create imagecollection and filter the date to (‘2018-06-09’,
    ‘2018-09-05’) and (‘2019-06-18’, ‘2019-09-05’);
  - Calculate NDVI and add the NDVI band to each image for
    imagecollections
  - Extract NDVI values from imagecollections based on the location of
    pods, and export it as `CSV` file.

Here is a picture of the location of pods.
![](../Docs/figures/Location_pods.png)

2.  Read in Sentinel2 dataset and pod dataset. The pod data is already
    preprocessed.

<!-- end list -->

``` r
gee_pod680_2018 <- read.csv(file = 'Data/EO_pod_NDVI_data/pod680_2018.csv')
gee_pod680_2019 <- read.csv(file = 'Data/EO_pod_NDVI_data/pod680_2019.csv')
pod680 <- read.csv(file = 'Data/Pod_680_d.csv')

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
head(pod680)
```

    ##   X       time     NDVI     SWdw       PAR
    ## 1 1 2018-06-09 0.158659 25.89700 12.948500
    ## 2 2 2018-06-10 0.160513 18.20630  9.103150
    ## 3 3 2018-06-11 0.163853 23.56120 11.780600
    ## 4 4 2018-06-12 0.162300 29.63530 14.817650
    ## 5 5 2018-06-13 0.182344  9.70175  4.850875
    ## 6 6 2018-06-14 0.180022 24.04730 12.023650

3.  Feed Sentinel2 dataset and to data preprocessing function
    (`satdata_preprocess()`) to preprocess the Sentinel2 data first.

<!-- end list -->

  - Select `date` and `NDVI` column from Sentinel2 dataset
  - **Aggregate** the repeated records by average
  - Output a tidy dataset

<!-- end list -->

``` r
gee_pod680_2018 <- satdata_preprocess(gee_pod680_2018)
gee_pod680_2019 <- satdata_preprocess(gee_pod680_2019)

head(gee_pod680_2018)
```

    ##         date  NDVI_Sen
    ## 1 2018-06-09 0.3347693
    ## 2 2018-06-12 0.2239335
    ## 3 2018-06-14 0.2671802
    ## 4 2018-06-17 0.1940535
    ## 5 2018-06-19 0.2591424
    ## 6 2018-06-22 0.3250314

4.  Feed the preprocessed Sentinel2 dataset and pod dataset to function
    `sat_pod_process()`. This is a further step on processing Sentinel2
    dataset based on pod data.

<!-- end list -->

  - Create a copy of pod dataset as `data_temp`
  - Pick out the appropriate data from pod dataset (`pod_d`) based on
    the date of Sentinel2 dataset(`sat_data`);
  - Merge pod dataset (`pod_d`) and Sentinel2 dataset(`sat_data`) as
    `sat_pod`;
  - Drop the NDVI value from Sentinel2 dataset(`sat_data`) in `sat_pod`
    if it is less than **80%** of the NDVI value from pod dataset
    (`pod_d`);
  - Join `sat_pod` to the copy of original pod dataset (`data_temp`);
  - Linearly Interpolate the missing NDVI value from `sat_pod` in
    `data_temp`;
  - Output a tidy dataset with column time, NDVI, SWdw and PAR.

<!-- end list -->

``` r
sat_pod680_2018 <- sat_pod_process(gee_pod680_2018, pod680)
```

    ## [1] "Fixed"

``` r
sat_pod680_2019 <- sat_pod_process(gee_pod680_2019, pod680)
```

    ## [1] "Fixed"

``` r
head(sat_pod680_2018)
```

    ##         time     SWdw       PAR      NDVI
    ## 1 2018-06-09 25.89700 12.948500 0.3347693
    ## 2 2018-06-10 18.20630  9.103150 0.2978240
    ## 3 2018-06-11 23.56120 11.780600 0.2608788
    ## 4 2018-06-12 29.63530 14.817650 0.2239335
    ## 5 2018-06-13  9.70175  4.850875 0.2455568
    ## 6 2018-06-14 24.04730 12.023650 0.2671802

5.  Combine the processed data from the same pod, and put them into
    function `Yield()`. The first value in the result is the predicted
    yield for 2018, and the sencond value is for 2019.

<!-- end list -->

``` r
sat_pod680 <- rbind(sat_pod680_2018,sat_pod680_2019)
Yield_sat_pod680 <- Yield(sat_pod680)
Yield_sat_pod680
```

    ## [1] 9386.693 6697.567

## Result

``` r
source("RScripts/data_exploration.R")
source("RScripts/GEE_data_exploration.R")
```

### Comparison of predicted yield between pod data and Sentinel 2 - 1C data

  - ε = 4.2 g/MJ, HI = 0.4

<!-- end list -->

``` r
# Pod-based
result_Yield
```

    ##                  2018     2019
    ## Yield_Pod680 9512.559 7677.303
    ## Yield_Pod671 9630.007 8049.265
    ## Yield_Pod667 9908.912 7806.244

``` r
# Sentinel2-based
result_Yield_sat
```

    ##                      2018     2019
    ## Yield_sat_pod680 9386.693 6697.567
    ## Yield_sat_pod671 9279.991 7043.356
    ## Yield_sat_pod667 9413.024 7028.102

``` r
temp1 <- (result_Yield[,1]-result_Yield_sat[,1])/result_Yield[,1]
temp2 <- (result_Yield[,2]-result_Yield_sat[,2])/result_Yield[,2]

# Percent of difference
temp3 <- cbind(temp1,temp2)
colnames(temp3) <- c("2018","2019")
temp3
```

    ##                    2018       2019
    ## Yield_Pod680 0.01323157 0.12761469
    ## Yield_Pod671 0.03634643 0.12496909
    ## Yield_Pod667 0.05004458 0.09968209

We notice that the predicted yield in 2019 on the Sentinel2-based result
is averagely 11% less than the pod-based result. However based how poor
the data quality of Sentinel2 dataset, this is an acceptable result.
Thus, using Sentinel data to calculate predicted yield is feasible.

## Summary

  - Was the project aim was realized? Was an Earth Observation limit
    pushed back?
    
    Yes. In this project, NDVI is the key factor that affects the result
    of predicted yield. We think the method of using ground level data
    and space level data to calculate predicted yield is useful. Once we
    have high quality satellite image (daily, atmospheric corrected), it
    is easier to monitor the crop yield for large area farms. What’s
    more, the ground-level data also plays a role as a baseline, helping
    us better quality control space-level data than relying on a cloud
    mask or quality flags.

  - What bottlenecks or roadblocks were hit ?
    
      - We are using level 1C data which is top of atmosphere data, so
        atmospheric impacts will do harm to the NDVI values.
        Additionally, the Sentinel 2 dataset is not daily generated due
        to the temporal resolution. Therefore, these two issues lead to
        insufficient data and atmospherically corrupted data. We also
        apply a threshold to get rid of those unreasonable data,
        however, the threshold value is based on the percent that the
        sentinel NDVI is less than the pod NDVI in the same day. Though
        it sounds a little bit un-rigorous, it is good to have pod data
        as a baseline. Last but not least, thanks to the insufficient
        data situation, the interpolated dataset becomes less reliable.
    
      - The method applied on interpolation could also impact the
        result.

  - What are potential improvements, and any next steps you plan to
    take?
    
      - We should run more statistic analysis to find a proper threshold
        for filtering unreasonable data in Sentinel2 dataset.
      - Try different methods on the calculation of APAR.
      - Other high spatial-temporal resolution data such as drone data
        or planet data can be apply on the calculation.

## Teamwork

  - Zhenhua Meng (Rscipts, Report, slides)

  - Jiena He (PythonScripts, Report, slides)

## References

  - Monteith, J. L. (1972). Solar radiation and productivity in tropical
    ecosystems. Journal of applied ecology, 9(3), 747-766.

  - Monteith, J. L. (1977). Climate and the efficiency of crop
    production in Britain. Philosophical Transactions of the Royal
    Society of London. B, Biological Sciences, 281(980), 277-294.

  - Lobell, D. B., Asner, G. P., Ortiz-Monasterio, J. I., & Benning, T.
    L. (2003). Remote sensing of regional crop production in the Yaqui
    Valley, Mexico: estimates and uncertainties. Agriculture, Ecosystems
    & Environment, 94(2), 205-220.

  - “Carbon Balance CERES 2010.Ppsx.” Dropbox.
    <https://www.dropbox.com/s/v8ony8cgyh29erv/Carbon%20Balance%20CERES%202010.ppsx?dl=0>
    (May 2, 2020).

  - Agroimpacts/Geog287387. 2020. Agricultural Impacts Research Group.
    HTML. <https://github.com/agroimpacts/geog287387> (May 2, 2020).

  - Agroimpacts/Geog287387. 2020. Agricultural Impacts Research Group.
    HTML. <https://github.com/agroimpacts/geog287387> (May 2, 2020).

  - Arable Data Dictionary
    <https://www.arable.com/wp-content/uploads/2020/01/AR_Data_Dictionary_2020-01.pdf>
    (May 2, 2020).
