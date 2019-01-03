library(stats)
library(leaps)
library(car)
library(lmtest)
(house <- read.table("C:/K Drive Items/STAT 540 (REDO)/HOMEWORK_6/bostonhousing.txt", header=T))
attach(house)

#############################################
## Fit the original data
fit1 <- lm(MEDV~CRIM+ZN+INDUS+CHAS+NOX+RM+AGE+DIS+RAD+TAX+PT_RATIO+LSTAT)
summary(fit1)
anova(fit1)
fitted1 <- fit1$fitted.values
resid1 <- fit1$residuals
#############################################

#############################################
## Scatterplot matrix (original data)
par(mfrow=c(3,4))
plot(CRIM, MEDV, main="MEDV vs CRIM")
plot(ZN, MEDV, main="MEDV vs ZN")
plot(INDUS, MEDV, main="MEDV vs INDUS")
plot(CHAS, MEDV, main="MEDV vs CHAS")
plot(NOX, MEDV, main="MEDV vs NOX")
plot(AGE, MEDV, main="MEDV vs AGE")
plot(RM, MEDV, main="MEDV vs RM")
plot(DIS, MEDV, main="MEDV vs DIS")
plot(RAD, MEDV, main="MEDV vs RAD")
plot(TAX, MEDV, main="MEDV vs TAX")
plot(PT_RATIO, MEDV, main="MEDV vs PT_RATIO")
plot(LSTAT, MEDV, main="MEDV vs LSTAT")
#############################################

#############################################
## Correlation matrices (original data)
cor(data.frame(MEDV,CRIM,ZN,INDUS,CHAS,NOX,RM,AGE,DIS,RAD,TAX,PT_RATIO,LSTAT))
pairs(data.frame(MEDV,CRIM,ZN,INDUS,CHAS,NOX,RM,AGE,DIS,RAD,TAX,PT_RATIO,LSTAT))
#############################################

#############################################
## Normal probability plot (original data)
qqnorm(resid1, main="QQ-Plot (Original Data)")
qqline(resid1)
hist(resid1, main="Histogram of the Residuals (Original Data)")
#############################################

#############################################
## Resid vs Fitted (original data)
plot(fitted1, resid1, xlab="Fitted Values", ylab="Residual", main="Resid vs Fitted (Original Data)")
abline(a=0, b=0, lty=2)

par(mfrow=c(3,4))
plot(CRIM, resid1, ylab="Residual", main="Residuals vs CRIM"); abline(a=0, b=0, lty=2)
plot(ZN, resid1, ylab="Residual", main="Residuals vs ZN"); abline(a=0, b=0, lty=2)
plot(INDUS, resid1, ylab="Residual", main="Residuals vs INDUS"); abline(a=0, b=0, lty=2)
plot(CHAS, resid1, ylab="Residual", main="Residuals vs CHAS"); abline(a=0, b=0, lty=2)
plot(NOX, resid1, ylab="Residual", main="Residuals vs NOX"); abline(a=0, b=0, lty=2)
plot(RM, resid1, ylab="Residual", main="Residuals vs RM"); abline(a=0, b=0, lty=2)
plot(AGE, resid1, ylab="Residual", main="Residuals vs AGE"); abline(a=0, b=0, lty=2)
plot(DIS, resid1, ylab="Residual", main="Residuals vs DIS"); abline(a=0, b=0, lty=2)
plot(RAD, resid1, ylab="Residual", main="Residuals vs RAD"); abline(a=0, b=0, lty=2)
plot(TAX, resid1, ylab="Residual", main="Residuals vs TAX"); abline(a=0, b=0, lty=2)
plot(PT_RATIO, resid1, ylab="Residual", main="Residuals vs PT_RATIO"); abline(a=0, b=0, lty=2)
plot(LSTAT, resid1, ylab="Residual", main="Residuals vs LSTAT"); abline(a=0, b=0, lty=2)
#############################################

#############################################
## "Best" subset selection
subs<-regsubsets(y=MEDV, x=cbind(CRIM,ZN,INDUS,CHAS,NOX,RM,AGE,DIS,RAD,TAX,PT_RATIO,LSTAT),nbest=5)
#subsets(subs, statistic="rsq")

subs1 <- leaps(y=MEDV, x=cbind(CRIM,ZN,INDUS,CHAS,NOX,RM,AGE,DIS,RAD,TAX,PT_RATIO,LSTAT), method="Cp", nbest=5)
subs2 <- leaps(y=MEDV, x=cbind(CRIM,ZN,INDUS,CHAS,NOX,RM,AGE,DIS,RAD,TAX,PT_RATIO,LSTAT), method="r2", nbest=5)
subs3 <- leaps(y=MEDV, x=cbind(CRIM,ZN,INDUS,CHAS,NOX,RM,AGE,DIS,RAD,TAX,PT_RATIO,LSTAT), method="adjr2", nbest=5)

subs1$"Cp"
subs2$"r2"
subs3$"adjr2"

# Get the 5 "best" models according to Cp
best.models1 <- data.frame(subs1$which[order(subs1$Cp)[1:5],])
names(best.models1) <- names(data.frame(cbind(CRIM,ZN,INDUS,CHAS,NOX,RM,AGE,DIS,RAD,TAX,PT_RATIO,LSTAT)))
best.models1$Cp <- subs1$Cp[order(subs1$Cp)[1:5]]
best.models1

# Get the 5 "best" models according to R^2
best.models2 <- data.frame(subs2$which[order(-subs2$r2)[1:5],])
names(best.models2) <- names(data.frame(cbind(CRIM,ZN,INDUS,CHAS,NOX,RM,AGE,DIS,RAD,TAX,PT_RATIO,LSTAT)))
best.models2$r2 <- subs2$r2[order(-subs2$r2)[1:5]]
best.models2

# Get the 5 "best" models according to adjR^2
best.models3 <- data.frame(subs3$which[order(-subs3$adjr2)[1:5],])
names(best.models3) <- names(data.frame(cbind(CRIM,ZN,INDUS,CHAS,NOX,RM,AGE,DIS,RAD,TAX,PT_RATIO,LSTAT)))
best.models3$adjr2 <- subs3$adjr2[order(-subs3$adjr2)[1:5]]
best.models3
#############################################

#############################################
## stepwise selection
full <- lm(MEDV~CRIM+ZN+INDUS+CHAS+NOX+RM+AGE+DIS+RAD+TAX+PT_RATIO+LSTAT)
lower <- formula(~1)
upper <- formula(~CRIM+ZN+INDUS+CHAS+NOX+RM+AGE+DIS+RAD+TAX+PT_RATIO+LSTAT)
step(full, scope=list(lower=lower, upper=upper), direction="both")

# (backward)
step(full, scope=list(lower=lower, upper=upper), direction="backward")
# (forward)
step(lm(MEDV~1), scope=list(lower=lower, upper=upper), direction="forward")
#############################################

##########################################################################################

#############################################
## Fit the medel chosen by several criteria
fit2 <- lm(MEDV~CRIM+ZN+CHAS+NOX+RM+DIS+RAD+TAX+PT_RATIO+LSTAT)
summary(fit2)
anova(fit2)
fitted2 <- fit2$fitted.values
resid2 <- fit2$residuals
#############################################

#############################################
## Residual plots
# Resid vs Fitted
plot(fitted2, resid2, xlab="Fitted Values", ylab="Residual", main="Residual Plot vs Fitted Values")
abline(a=0, b=0, lty=2)

# Resid vs predictors
par(mfrow=c(3,4))
plot(log.CRIM, resid2, ylab="Residual", main="Residuals vs CRIM"); abline(a=0, b=0, lty=2)
plot(ZN, resid2, ylab="Residual", main="Residuals vs ZN"); abline(a=0, b=0, lty=2)
plot(CHAS, resid2, ylab="Residual", main="Residuals vs CHAS"); abline(a=0, b=0, lty=2)
plot(NOX, resid2, ylab="Residual", main="Residuals vs NOX"); abline(a=0, b=0, lty=2)
plot(log.RM, resid2, ylab="Residual", main="Residuals vs RM"); abline(a=0, b=0, lty=2)
plot(log.DIS, resid2, ylab="Residual", main="Residuals vs DIS"); abline(a=0, b=0, lty=2)
plot(RAD, resid2, ylab="Residual", main="Residuals vs RAD"); abline(a=0, b=0, lty=2)
plot(log.TAX, resid2, ylab="Residual", main="Residuals vs TAX"); abline(a=0, b=0, lty=2)
plot(PT_RATIO, resid2, ylab="Residual", main="Residuals vs PT_RATIO"); abline(a=0, b=0, lty=2)
plot(log.LSTAT, resid2, ylab="Residual", main="Residuals vs log(LSTAT)"); abline(a=0, b=0, lty=2)
#############################################

#############################################
## Correlation plot and matrix (original data)
cor(data.frame(MEDV,CRIM,ZN,CHAS,NOX,RM,DIS,RAD,TAX,PT_RATIO,LSTAT))
pairs(data.frame(MEDV,CRIM,ZN,CHAS,NOX,RM,DIS,RAD,TAX,PT_RATIO,LSTAT))
#############################################

#############################################
## BP test (original data)
resid2sq <- resid2^2
fit2a <- lm(resid2sq~CRIM+ZN+CHAS+NOX+RM+DIS+RAD+TAX+PT_RATIO+LSTAT)
ssr.st <- sum(anova(fit2a)$"Sum Sq"[1:10])
sse <- anova(fit2)$"Sum Sq"[11]
chiv <- (ssr.st/2)/(sse/length(CRIM))^2; chiv
qchisq(0.95, 10)

bptest(MEDV~CRIM+ZN+CHAS+NOX+RM+DIS+RAD+TAX+PT_RATIO+LSTAT,studentize=FALSE)
# x_{BP}^2=213.9974 > chi^2(.95,10)=18.30704 reject Ho, so variance is not constant.
#############################################

#############################################
## Normal probability plot
qqnorm(resid2)
qqline(resid2)
hist(resid2)
#Shapiro-Wilk test is based approximately also on the coefficient of correlation between the ordered 
#residuals and their expected values under normality
shapiro.test(resid2)
# p-value=2.2e-16 would reject Ho, the data is not normal
#############################################

#############################################
## Added-variable plots
av.plots(fit2, CRIM)
av.plots(fit2, ZN)
av.plots(fit2, CHAS)
av.plots(fit2, NOX)
av.plots(fit2, RM)
av.plots(fit2, DIS)
av.plots(fit2, RAD)
av.plots(fit2, TAX)
av.plots(fit2, PT_RATIO)
av.plots(fit2, LSTAT)
#############################################

#############################################
## Tentative model
# After some transformations
log.MEDV <- log(MEDV)
log.CRIM <- log(CRIM)
log.RM <- log(RM)
log.DIS <- log(DIS)
log.TAX <- log(TAX)
log.LSTAT <- log(LSTAT)
fit3 <- lm(log.MEDV~log.CRIM+ZN+CHAS+NOX+log.RM+log.DIS+RAD+log.TAX+PT_RATIO+log.LSTAT)
fitted3 <- fit3$fitted.values
resid3 <- fit3$residuals
summary(fit3)
anova(fit3)
#############################################

#############################################
## Correlation plot and matrix (tentative model)
cor(data.frame(log.MEDV,ZN,CHAS,NOX,sqrt.RM,AGE,DIS,RAD,TAX,PT_RATIO,log.LSTAT))
pairs(data.frame(log.MEDV,ZN,CHAS,NOX,sqrt.RM,AGE,DIS,RAD,TAX,PT_RATIO,log.LSTAT))
#############################################

#############################################
## BP test (tentative model)
bptest(log.MEDV~log.CRIM+ZN+CHAS+NOX+log.RM+log.DIS+RAD+log.TAX+PT_RATIO+log.LSTAT,studentize=FALSE)
#############################################

#############################################
## Residual plots (tentative model)
# Resid vs Fitted
plot(fitted3, resid3, xlab="Fitted Values", ylab="Residual", main="Resid vs Fitted (reduced and transformed Data)")
abline(a=0, b=0, lty=2)

# Resid vs predictors
par(mfrow=c(3,4))
plot(log.CRIM, resid3, ylab="Residual", main="Residuals vs CRIM"); abline(a=0, b=0, lty=2)
plot(ZN, resid3, ylab="Residual", main="Residuals vs ZN"); abline(a=0, b=0, lty=2)
plot(CHAS, resid3, ylab="Residual", main="Residuals vs CHAS"); abline(a=0, b=0, lty=2)
plot(NOX, resid3, ylab="Residual", main="Residuals vs NOX"); abline(a=0, b=0, lty=2)
plot(log.RM, resid3, ylab="Residual", main="Residuals vs RM"); abline(a=0, b=0, lty=2)
plot(log.DIS, resid3, ylab="Residual", main="Residuals vs DIS"); abline(a=0, b=0, lty=2)
plot(RAD, resid3, ylab="Residual", main="Residuals vs RAD"); abline(a=0, b=0, lty=2)
plot(log.TAX, resid3, ylab="Residual", main="Residuals vs TAX"); abline(a=0, b=0, lty=2)
plot(PT_RATIO, resid3, ylab="Residual", main="Residuals vs PT_RATIO"); abline(a=0, b=0, lty=2)
plot(log.LSTAT, resid3, ylab="Residual", main="Residuals vs log(LSTAT)"); abline(a=0, b=0, lty=2)
#############################################
#############################################

#############################################
## Check normality (tentative model)
qqnorm(resid3, main="QQ-Plot (reduced and transformed Data)")
qqline(resid3)
hist(resid3, main="Histogram of the Residuals (reduced and transformed Data)")
shapiro.test(resid3)
#############################################

#############################################
## multicolinearity (tentative model)
library(HH)
vif(fit3)
#############################################

#############################################
## Influential points (tentative model)
influential <- influence.measures(fit3)
which(apply(influential$is.inf, 1, any))
influential
summary(influential)
lm.influence(fit3)

lev <- lm.influence(fit3)
hat <- lev$hat
x.outliers <- which(abs(hat) > 22/506)
x.outliers

df.betas <- dfbetas(fit3)
df.betas.outliers <- which(abs(df.betas[,1]) > 2/sqrt(506)) 
df.betas.outliers
#############################################































































#############################################
## Residual plots

# Resid vs Fitted
plot(fitted3, resid3, xlab="Fitted Values", ylab="Residual", main="Residual Plot vs Fitted Values")
abline(a=0, b=0, lty=2)

# Resid vs predictors
par(mfrow=c(3,4))
plot(CRIM, resid3, ylab="Residual", main="Residuals vs CRIM"); abline(a=0, b=0, lty=2)
plot(ZN, resid3, ylab="Residual", main="Residuals vs ZN"); abline(a=0, b=0, lty=2)
plot(CHAS, resid3, ylab="Residual", main="Residuals vs CHAS"); abline(a=0, b=0, lty=2)
plot(NOX, resid3, ylab="Residual", main="Residuals vs NOX"); abline(a=0, b=0, lty=2)
plot(RM, resid3, ylab="Residual", main="Residuals vs RM"); abline(a=0, b=0, lty=2)
plot(DIS, resid3, ylab="Residual", main="Residuals vs DIS"); abline(a=0, b=0, lty=2)
plot(RAD, resid3, ylab="Residual", main="Residuals vs RAD"); abline(a=0, b=0, lty=2)
plot(TAX, resid3, ylab="Residual", main="Residuals vs TAX"); abline(a=0, b=0, lty=2)
plot(PT_RATIO, resid3, ylab="Residual", main="Residuals vs PT_RATIO"); abline(a=0, b=0, lty=2)
plot(LSTAT, resid3, ylab="Residual", main="Residuals vs log(LSTAT)"); abline(a=0, b=0, lty=2)
#############################################

log.MEDV
ZN
CHAS
NOX
RM
AGE
DIS
RAD
TAX
PT_RATIO
log.LSTAT


log.MEDV.s <- (log.MEDV-mean(log.MEDV))/sd(log.MEDV)
MEDV.s <- (MEDV-mean(MEDV))/sd(MEDV)
MEDV.s <- (sqrt(MEDV)-mean(sqrt(MEDV)))/sd(sqrt(MEDV))
ZN.s <- (ZN-mean(ZN))/sd(ZN)
CHAS.s <- (CHAS-mean(CHAS))/sd(CHAS)
NOX.s <- (NOX-mean(NOX))/sd(NOX)
RM.s <- (sqrt.RM-mean(sqrt.RM))/sd(sqrt.RM)
AGE.s <- (AGE-mean(AGE))/sd(AGE)
DIS.s <- (DIS-mean(DIS))/sd(DIS)
RAD.s <- (RAD-mean(RAD))/sd(RAD)
TAX.s <- (TAX-mean(TAX))/sd(TAX)
PT_RATIO.s <- (PT_RATIO-mean(PT_RATIO))/sd(PT_RATIO)
log.LSTAT.s <- (log.LSTAT-mean(log.LSTAT))/sd(log.LSTAT)

fit4 <- lm(log.MEDV.s~ZN.s+CHAS.s+NOX.s+RM.s+AGE.s+DIS.s+RAD.s+TAX.s+PT_RATIO.s+log.LSTAT.s)
fitted4 <- fit4$fitted.values
resid4 <- fit4$residuals

bptest(log.MEDV.s~ZN.s+CHAS.s+NOX.s+RM.s+AGE.s+DIS.s+RAD.s+TAX.s+PT_RATIO.s+log.LSTAT.s,studentize=FALSE)
shapiro.test(resid4)

## Check normality
qqnorm(resid4)
qqline(resid4)
hist(resid4)
























#############################################
## Residual plots
# Resid vs Fitted
plot(fitted2, resid2, xlab="Fitted Values", ylab="Residual", main="Residual Plot vs Fitted Values")
abline(a=0, b=0, lty="dashed")

# Resid vs predictors
plot(CRIM, resid2, ylab="Residual", main="CRIM Plot vs Fitted Values")
abline(a=0, b=0, lty="dashed")

plot(ZN, resid2, ylab="Residual", main="ZN Plot vs Fitted Values")
abline(a=0, b=0, lty="dashed")

plot(CHAS, resid2, ylab="Residual", main="CHAS Plot vs Fitted Values")
abline(a=0, b=0, lty="dashed")

plot(NOX, resid2, ylab="Residual", main="NOX Plot vs Fitted Values")
abline(a=0, b=0, lty="dashed")

plot(RM, resid2, ylab="Residual", main="RM Plot vs Fitted Values")
abline(a=0, b=0, lty="dashed")

plot(DIS, resid2, ylab="Residual", main="DIS Plot vs Fitted Values")
abline(a=0, b=0, lty="dashed")

plot(RAD, resid2, ylab="Residual", main="RAD Plot vs Fitted Values")
abline(a=0, b=0, lty="dashed")

plot(TAX, resid2, ylab="Residual", main="TAX Plot vs Fitted Values")
abline(a=0, b=0, lty="dashed")

plot(PT_RATIO, resid2, ylab="Residual", main="PT_RATIO Plot vs Fitted Values")
abline(a=0, b=0, lty="dashed")

plot(LSTAT, resid2, ylab="Residual", main="LSTAT Plot vs Fitted Values")
abline(a=0, b=0, lty="dashed")
#############################################




#############################################
#############################################
#############################################
CRIM
ZN
CHAS
NOX
RM
DIS
RAD
TAX
PT_RATIO
LSTAT

log.CRIM = log(CRIM)
log.ZN = log(ZN)

log.NOX = log(NOX)
log.RM = log(RM)
log.DIS = log(DIS)
log.RAD = log(RAD)
log.TAX = log(TAX)
log.PT_RATIO = log(PT_RATIO)
log.LSTAT = log(LSTAT)

r.tax <-1/TAX

fit3 <- lm(MEDV~log.CRIM+ZN+CHAS+NOX+log.RM+log.DIS+RAD+TAX+PT_RATIO+log.LSTAT)
fit3 <- lm(MEDV~CRIM+ZN+CHAS+NOX+RM+DIS+RAD+TAX+PT_RATIO+LSTAT)



CRIM
LSTAT
library(sm)
sm.density(rstudent(fit3), model="normal")



bc<-lm(MEDV~CRIM+ZN+CHAS+NOX+RM+DIS+RAD+TAX+PT_RATIO+LSTAT, +box.cox.var(MEDV))

# Added-variable plots
av.plots(fit3, CRIM)
av.plots(fit3, ZN)
av.plots(fit3, CHAS)
av.plots(fit3, NOX)
av.plots(fit3, RM)
av.plots(fit3, DIS)
av.plots(fit3, RAD)
av.plots(fit3, TAX)
av.plots(fit3, PT_RATIO)
av.plots(fit3, LSTAT)
anova(fit2)


fit3 <- lm(MEDV~CRIM+ZN+CHAS+NOX+RM+DIS+RAD+TAX+PT_RATIO+LSTAT)
fit3 <- lm(MEDV~TAX+RM+RAD)
av.plots(fit3, RAD)
anova(fit3)


fit3 <- lm(MEDV~RM+TAX+CHAS+NOX+RAD)
av.plots(fit3, RAD)
anova(fit3)
##########
##########
fit3 <- lm(MEDV~RM+RAD)
anova(fit3)

fit3 <- lm(MEDV~TAX+RAD)
anova(fit3)

fit3 <- lm(MEDV~CHAS+RAD)
anova(fit3)

fit3 <- lm(MEDV~CHAS+NOX+RAD)
anova(fit3)

fit3 <- lm(MEDV~RM+TAX+CHAS+NOX+RAD)
anova(fit3)

fit3 <- lm(MEDV~RM+TAX+CHAS+NOX+RAD)
anova(fit3)

library(car)
av.plots(fit2)