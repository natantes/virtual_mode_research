
install.packages("mgcv")
# setwd("/")

library(RColorBrewer)
co <- brewer.pal(9, "RdBu")

school_data <- read.csv("./Dev/econometrics_compeition/new_drop.csv")
schools_high_virtual_2021 <- subset(school_data, schoolmode >= 0.75)
high_virtual_school_codes <- schools_high_virtual_2021$schoolcode
school_data$highvirtual <- ifelse(school_data$schoolcode %in% high_virtual_school_codes, 1, 0)
school_data_2021 <- subset(school_data, year == 2021)
school_data_2019 <- subset(school_data, year == 2019)

school_high_2021 <- subset(school_data_2021, highvirtual == 1)
school_low_2021 <- subset(school_data_2021, highvirtual == 0)
school_high_2019 <- subset(school_data_2019, highvirtual == 1)
school_low_2019 <- subset(school_data_2019, highvirtual == 0)

################################
### KERNEL DENSITY ESTIMATES ###
################################

### DROPOUT ###

par(mar=c(4.5,4.5,1,2))

kd_high_2021 <- density(school_high_2021$dropout, bw="SJ", kernel="g")
kd_low_2021 <- density(school_low_2021$dropout, bw="SJ", kernel="g")
kd_high_2019 <- density(school_high_2019$dropout, bw="SJ", kernel="g")
kd_low_2019 <- density(school_low_2019$dropout, bw="SJ", kernel="g")

plot(kd_low_2019, xlim=c(-1, 60), ylim=c(0, .3), lwd=1.5, col=c(co[8]), 
     xlab="Dropout", ylab="Density", main="", lty=3)
lines(kd_high_2019, lwd=1.5, lty=3, col=c(co[2]))
legend('topright',inset=0.05,c("High Virtual","Nonhigh Virtual"),lty=c(3, 1),
       lwd = 1.5, title="Schooling Mode")

plot(kd_low_2021, xlim=c(-1, 60), ylim=c(0, .3), lwd=1.5, 
     xlab="Dropout", ylab="Density", main="", col=co[8])
lines(kd_high_2021, lwd=1.5, col=co[2])
legend('topright',inset=0.05,c("High Virtual","Nonhigh Virtual"),lty=c(3, 1),
       lwd = 1.5, title="Schooling Mode")

plot(kd_low_2021, xlim=c(-1, 46), ylim=c(0, .3), lwd=1.5, 
    xlab="Dropout", ylab="Density", main="", lty=3, col=co[8])
lines(kd_high_2021, lwd=1.5, col=co[2], lty=3)
lines(kd_low_2019, lwd=1.5, col=co[8])
lines(kd_high_2019, lwd=1.5, col=co[2])

legend('topright',inset=0.05,c("High Virtual 2019", 
                               "High Virtual 2021", 
                               "Nonhigh Virtual 2019", 
                               "Nonhigh Virtual 2021"),
       lty=c(3, 1, 3, 1), col=c(co[2], co[2], co[8], co[8]),
       lwd = 1.5, title="Schooling Mode")




school_data <- read.csv("./Dev/econometrics_compeition/new_drop.csv")
school_data <- subset(school_data, year == 2021)
school_data$high_schoolmode <- ifelse(school_data$schoolmode >= 0.75, 1, 0)

school_high <- subset(school_data, high_schoolmode == 1)
school_low <- subset(school_data, high_schoolmode == 0)

### TEACHER RETENTION ###

kd_high <- density(school_high$retention, bw="SJ", kernel="g")
kd_low <- density(school_low$retention, bw="SJ", kernel="g")

plot(kd_low, xlim=c(-1, 100), ylim=c(0, .3), lwd=1.5, 
     xlab="Percentage Teacher Retention", ylab="Density", main="")
lines(kd_high, lwd=1.5, lty=3)
legend('topright',inset=0.05,c("High Virtual","Nonhigh Virtual"),lty=c(3, 1),
       lwd = 1.5,title="Schooling Mode")


### LOW INCOME ###

kd_high <- density(school_high$lowincome, bw="SJ", kernel="g")
kd_low <- density(school_low$lowincome, bw="SJ", kernel="g")

plot(kd_low, xlim=c(-1, 100), ylim=c(0, .3), lwd=1.5, 
     xlab="Proportion of Low Income", ylab="Density", main="")
lines(kd_high, lwd=1.5, lty=3)
legend('topright',inset=0.05,c("High Virtual","Nonhigh Virtual"),lty=c(3, 1),
       lwd = 1.5,title="Schooling Mode")






#################################
### NONPARAMETRIC REGRESSIONS ###
#################################

sm.regression(school_data$schoolmode, school_data$dropout, method="cv", se=T)
sm.regression(school_data$retention, school_data$dropout, method="cv", se=T)
sm.regression(school_data$lowincome, school_data$retention, method="cv", se=T)
sm.regression(school_data$lowincome, school_data$dropout, method="cv", se=T)

h_1 <- kd_low$bw
h_0 <- kd_high$bw
h_star <- ( 2 / ((1/h_1) + (1/h_0)) )

library(sm)
sm.density.compare(school_data$dropout, group=school_data$high_schoolmode, model="equal", bw=h_star, nboot=10000)

