# First R coding from scratch

2 + 3

anna <- 2 + 3 #assign an operation to an object
chiara <- 4 + 6

anna + chiara

filippo  <- c(0.2, 0.4, 0.6, 0.8, 0.9)        #array, dobbiamo concatenare con funzione c, il vettore è formato da n argomenti

luca     <- c(100, 80, 60, 50, 10)

plot(luca, filippo) 
plot(luca, filippo, pch=19, col="blue", cex=2)
plot(luca, filippo, pch=19, col="blue", cex=2, xlab="rubbish", ylab="biomass")  #pch è la forma del punto, col è il colore, cex è la sovradimensione del punto, xlab e ylab è l'etichetta degli assi

# possiamo inserire pacchetti di R su GitHub, installiamo da CRAN
#CRAN
install.packages("terra") #installiamo il pacchetto

library(terra) #richiamiamo il pacchetto

install.packages("devtools")
library(devtools)

install_github("ducciorocchini/imageRy")
library(imageRy)



