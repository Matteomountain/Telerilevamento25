# R code for visualizing satellite data

install.packages("viridis")

library (terra)
library(imageRy)
library(viridis)

im.list()


#in tutto il corso useremo = invece della freccia di assegnazione <- perchè a noi non ce ne fotte 
b2 = im.import("sentinel.dolomites.b2.tif") #banda che riflette 

cl = colorRampPalette(c("black", "dark grey","light grey"))(100) #il 100 è la palette di colori che sfumeranno tra i 3 colori principali
#colorRampPalette serve per cambiare i colori dell'immagine

plot(b2, col=cl)

#Esercizio: scegli i tuoi colori 
# https://sites.stat.columbia.edu/tzheng/files/Rcolor.pdf

cl = colorRampPalette(c("firebrick","tan1", "gold","royalblue"))(100) #mai usare verde e rosso insieme perchè i daltonici non vedono i colori distinti
plot(b2, col=cl)

#frattali: natura si dispone nello spazio così (es fiocco di neve)
#fillotassi: disposizione foglie sul ramo a spirale secondo numero aureo (secondo serie di fibonacci) come per esempio la conchiglia del Nautilus

#bands
b3 = im.import("sentinel.dolomites.b3.tif") #banda che riflette il verde
b4 = im.import("sentinel.dolomites.b4.tif") #banda che riflette il rosso 
b8 = im.import("sentinel.dolomites.b8.tif") #banda dell'infrarosso vicino - Near infrared, 750nm- quella che useremo molto 

# Multiframe grafico con più immagini al suo interno, mi servono sapere quante righe e quante colonne - come vogliamo plottare le 4 immagini?
par(mfrow=c(1,4 )) # mfrow sono le righe e colonne, sono un vettore e vanno concatenati
b2 = im.import("sentinel.dolomites.b2.tif")
b3 = im.import("sentinel.dolomites.b3.tif")
b4 = im.import("sentinel.dolomites.b4.tif")
b8 = im.import("sentinel.dolomites.b8.tif")

#oppure possiamo fare un Plot senza importare
par(mfrow=c(1,4 ))
plot(b2)
plot(b3)
plot(b4)
plot(b8)

dev.off() #serve per cancellare i grafici su R

#funzione di Duccio per velocizzare il par
im.multiframe(1,4)
plot(b2)
plot(b3)
plot(b4)
plot(b8)

#Esercizio: plot the bands using im.multiframe() one the top of the other 
im.multiframe(4,1)
plot(b2)
plot(b3)
plot(b4)
plot(b8)

im.multiframe(2,2) #mettiamo 2,2 e viene fuori un quadrato
plot(b2)
plot(b3)
plot(b4)
plot(b8)

cl =colorRampPalette(c("black","light grey"))(100)
plot(b2, col=cl)
plot(b3, col=cl)
plot(b4, col=cl)
plot(b8, col=cl)

#Stack pacchetto di dati 

sent = c(b2, b3, b4, b8) #creiamo un pacchetto con le 4 immagini sentinel
sent #per visualizzare cosa c'è dentro

plot(sent, col=cl) #per far vedere i nomi sopra le immagini

names(sent) = c("b2-blue", "b3-green", "b4-red", "b8NIR") #cambiamo i nomi 
sent

plot(sent, col=cl)
plot(sent)

plot(sent$b8NIR) #come plottare un singolo elemento

plot(sent[[4]]) #selezioniamo l'elemento per posizione e non per nome, visto che l'abbiamo inserito in un array

#Importiamo più dati insieme, senza farlo uno per volta
sentdol = im.import("sentinel.dolomites") #mettiamo il nome comune alle 4 immagini senza specificare i singoli dati

pairs(sentdol)
plot(sentdol)

#installimo il pacchetto viridis in cima

#viridis
plot(sentdol[[4]], col=plasma(100)) #si può scegliere un tipo di colori, cercare su internet viridis package R per avere la legenda 

#Raster matrice di pixel 
# nlyr(sentdol) sono i layer --> number of layer
# ncell(sentdoll) sono i pixel di ogni layer, va moltiplicato per 4 layer che abbiamo in sentdol

# Layers 
# 1 = blue (b2)
# 2 = green (b3)
# 3 = red (b4)
# 4 = infrared (b8)

# Plot con i colori RGB, nelle parentesi mettiamo l'immagine di riferimento, e ogni colore associato 
im.plotRGB(sentdol, r=3, g=2, b=1) # Immagine a colori naturali, abbiamo associato ad ogni colore RGB il colore del layer corrispondente

# Immagine a falsi colori, inseriamo la banda 4, una delle 3 dobbiamo toglierla, togliamo la blu perchè non ci dà tanti dati, facciamo scattare le bande di una posizione
im.plotRGB(sentdol, r=4, g=3, b=2) # nella componente Red abbiamo messo l'infrarosso vicino, siccome le piante riflettono molto l'infrarosso, nell'immagine verranno colorate di rosso
# L'acqua assorbe molto infrarosso quindi la vediamo scura

# Exercise: plot the images using the NIR ontop of the green component of the RGB scheme
im.plotRGB(sentdol, r=3, g=4, b=2) 
im.plotRGB(sentdol, r=1, g=4, b=2) 

im.multiframe(1, 2)
im.plotRGB(sentdol, r=3, g=4, b=2) 
im.plotRGB(sentdol, r=1, g=4, b=2) 

# Infrarosso sul blu
im.plotRGB(sentdol, r=3, g=1, b=4) 





