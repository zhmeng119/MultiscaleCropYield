# Experiment on Linear regression
rawz_whole <- zoo(p_dat_680_d)

a <- rawz_whole$NDVI %>% filter(.,time %>% substring(.,1,4)==2018) %>% as.numeric()
b <- c(1:length(p_dat_680_d$NDVI))
relation <- lm(a~b)
temp <- data.frame(x = 90)
result <- predict(relation,temp)


# y <- p_dat_680_d$NDVI
y <- p_dat_680_d %>% filter(.,time %>% substring(.,1,4)==2019)
y <- y$NDVI
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