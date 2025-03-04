# R code for visualizing satellite data

library (terra)
library(imageRy)


im.list()


#in tutto il corso useremo = invece della freccia di assegnazione <- perchè a noi non ce ne fotte 
b2 = im.import("sentinel.dolomites.b2.tif")

cl = colorRampPalette(c("black", "dark grey","light grey"))(100) #il 100 è la palette di colori che sfumeranno tra i 3 colori principali
#colorRampPalette serve per cambiare i colori dell'immagine

plot(b2, col=cl)

#Esercizio: scegli i tuoi colori 
# https://sites.stat.columbia.edu/tzheng/files/Rcolor.pdf

cl = colorRampPalette(c("firebrick","tan1", "gold","royalblue"))(100) #mai usare verde e rosso insieme perchè i daltonici non vedono i colori distinti
plot(b2, col=cl)
