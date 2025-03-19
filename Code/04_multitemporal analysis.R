# R code for multitemporal analysis

library(terra)
library(imageRy)
library(viridis)

im.list() # Per vedere i dati --> oggi usiamo EN.png

# Immagini sentinel per monitorare ossido di azoto (NO2) durante il lockdown --> Copernicus ESA

EN_01 = im.import("EN_01.png")
EN_01 = flip(EN_01)
plot(EN_01)


EN_13 = im.import("EN_13.png")
EN_13 = flip(EN_13)
plot(EN_13)

im.multiframe(1,2)
plot(EN_01)
plot(EN_13)

ENdif = EN_01[[1]] - EN_13[[1]] # Sottraiamo le due immagini per vedere la differenza, sottraiamo il primo layer di 3
plot(ENdif, col=plasma(100))

# ________________________________

# Greenland ice melt

gr = im.import("greenland") # importiamo 4 immagini con lo stesso nome

grdif = gr[[1]] - gr[[4]] # sottraiamo il layer del 2000 con il 2015 per vedere la differenza di T°
plot(grdif) 

grdif = gr[[4]] - gr[[1]] #2015 - 2000 --> Parti gialle dove è aumentata la T dal 2000 al 2015. Parti scure dove è diminuita
plot(grdif, col=magma(100))

# _____________________________

setwd("~/Downloads/") # Abbiamo scelto il percorso per salvare un file
getwd() # Per vedere dove si salverà

pdf("output.pdf") # Funzione per creare un nuovo file PDF, e tra virgolette il nome del file
plot(grdif) # Poi plottiamo l'immagine che vogliamo creare il PDF
dev.off() # Per chiudere la funzione

jpeg("output.jpeg") # Funzione per creare un nuovo file jpeg, e tra virgolette il nome del file
plot(grdif) # Poi plottiamo l'immagine che vogliamo creare il jpeg
dev.off() # Per chiudere la funzione












