# Experiment on Linear regression
library(dplyr)

# rawz_whole <- zoo(p_dat_680_d)
rawz_whole <- p_dat_680_d

a <- c(rawz_whole %>% filter(.,time %>% substring(.,1,4)==2018) %>% select(.,NDVI)) %>% unlist(use.names=FALSE)

b <- c(1:length(a))
relation <- lm(a~b)
temp <- data.frame(x = 90)
result <- predict(relation,temp)


# y <- p_dat_680_d$NDVI
# y <- c(p_dat_680_d %>% filter(.,time %>% substring(.,1,4)==2018) %>% select(.,NDVI) %>% unlist(use.names=FALSE))
y <- c(p_dat_680_d %>% filter(.,time %>% substring(.,1,4)==2019) %>% select(.,NDVI) %>% unlist(use.names=FALSE))

# x <- c(p_dat_680_d %>% filter(.,time %>% substring(.,1,4)==2018) %>% select(.,SWdw) %>% unlist(use.names=FALSE))
x <- c(1:length(y))
# x <-  p_dat_680_d %>% filter(.,time %>% substring(.,1,4)==2018) %>% select(SWdw)
# x <- x$SWdw
#fit first degree polynomial equation:
fit  <- lm(y~x)
#second degree
fit2 <- lm(y~poly(x,2,raw=TRUE))
#third degree
fit3 <- lm(y~poly(x,3,raw=TRUE))
#fourth degree
fit4 <- lm(y~poly(x,4,raw=TRUE))
#generate range of 50 numbers starting from 30 and ending at 160
# xx <- seq(30,160, length=50)
plot(x,y,pch=19,ylim=c(0,1))
lines(x, predict(fit, data.frame(x=x)), col="red")
lines(x, predict(fit2, data.frame(x=x)), col="green")
lines(x, predict(fit3, data.frame(x=x)), col="blue")
lines(x, predict(fit4, data.frame(x=x)), col="purple")
legend(0,1, legend = c("first degree","second degree","third degree","fourth degree"),
       col = c("red","green","blue","purple"), lty=1:2, cex=0.8)
