library(phenopix)
library(zoo)
data(bartlett2009.filtered)
bart <- ts(bartlett2009.filtered)
## fit without uncertainty estimation
fitted.kl1 <- KlostermanFit(bart, which='light',
                            uncert = T)




#fitted.kl2 <- KlostermanFit(bart, which='heavy')
## check fitting
plot(bart)
lines(fitted.kl1$fit$predicted, col='red')
#lines(fitted.kl2$fit$predicted, col='blue')
legend('topleft',col=c('red', 'blue'), lty=1,
       legend=c('light', 'heavy'), bty='n')



data(bartlett2009.filtered)
## fit without uncertainty estimation
fitted.elmore <- ElmoreFit(bart)
lines(fitted.elmore$fit$predicted, col='blue')


test <- PhenoExtract(fitted.kl1)
test2 <- PhenoExtract(fitted.kl1,
                      method = 'klosterman')
