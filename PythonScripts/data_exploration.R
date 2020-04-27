library(aRable)

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
library(openxlsx)
dataset_list <- list("p_dat_680_d" = p_dat_680_d,
                     "p_dat_680_h" = p_dat_680_h,
                     "p_dat_671_d" = p_dat_671_d,
                     "p_dat_671_h" = p_dat_671_h,
                     "p_dat_667_d" = p_dat_667_d,
                     "p_dat_667_h" = p_dat_667_h)
write.xlsx(dataset_list, file = "pod_data.xlsx")