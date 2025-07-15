library(terra) # Per la funzione rast()
library(imageRy) # Per im.plotRGB() 
library(viridis) # Per utilizzare colorRampPalette adatte a chi soffre di daltonismo (no colorazioni arcobaleno)
library(ggplot2)

# Imposto la cartella di lavoro dove sono state posizionate le immagini relative alla Marmolada - Sentinella delle Dolomiti.
# Tale codice ha l'obiettivo di quantificare la variazione della superficie del ghiacciaio della Marmolada 
# per valutarne il ritiro (presunto) in un periodo compreso tra il 2017
# e il 2024, a intervalli di 2 anni. Ricordiamo che nel 2022 c'è stato il crollo di una porzione di ghiacciaio 

setwd("/Users/matteo/Downloads/TelEsame")  # Inserisco la directory dei file
getwd()             # Per verificare la directory
list.files()        # Per Controllare che i file siano visibili


# Le immagini sono state scaricate grazie a Google Earth Engine - GEE e poi caricate su Google Drive
# Le immagini sono state catturate con Sentinel-2. Sono state scaricate le immagini relative alle bande del blu, verde, rosso e SWIR 
# (migliore per il ghiaccio, rispetto a NIR per l'acqua)


# Carico le immagini della Marmolada per ogni banda, relative agli anni 2017, 2020, 2022, 2024. Ogni banda viene assegnata ad un oggetto. 
# Anche se nel corso abbiamo usato = , preferisco assegnare con la freccia per mio ordine mentale.
# Queste vengono poi incluse in uno stack per creare una immagine che contenga tutte le bande. 
# Verrà fatto lo stesso per ogni anno.

# Layers 
# 1 = blue (B2)
# 2 = green (B3)
# 3 = red (B4)
# 4 = Short-Wave Infrared (B11)

# -----------------------------------------------------------------------------------


  # Luglio-Agosto 2017
m17_1 <- rast("m17_B2.tif")
m17_2 <- rast("m17_B3.tif")
m17_3 <- rast("m17_B4.tif")
m17_4 <- rast("m17_B11.tif")

# Prima di fare lo stack devo rendere i 4 layer uguali, perchè i primi 3 li ho scaricati insieme, 
# mentre la banda SWIR un altro giorno e avevo perso il poligono precedente su GEE. Perciò hanno estensioni leggermente differenti e non combaciano,
# una volta trovata l'estensione comune procedo con il crop per renderli uguali. 

ext_comune17 <- intersect(intersect(ext(m17_1), ext(m17_2)), intersect(ext(m17_3), ext(m17_4)))

m17_1c <- crop(m17_1, ext_comune17)
m17_2c <- crop(m17_2, ext_comune17)
m17_3c <- crop(m17_3, ext_comune17)
m17_4c <- crop(m17_4, ext_comune17)

m17 <- c(m17_1c, m17_2c, m17_3c, m17_4c)

plot(m17) #Per visualizzare le immagini delle 4 bande

# Rifare lo stesso taglio per le 3 annate rimanenti



  # Luglio-Agosto 2020
m20_1 <- rast("m20_B2.tif")
m20_2 <- rast("m20_B3.tif")
m20_3 <- rast("m20_B4.tif")
m20_4 <- rast("m20_B11.tif")

ext_comune20 <- intersect(intersect(ext(m20_1), ext(m20_2)), intersect(ext(m20_3), ext(m20_4)))

m20_1c <- crop(m20_1, ext_comune20)
m20_2c <- crop(m20_2, ext_comune20)
m20_3c <- crop(m20_3, ext_comune20)
m20_4c <- crop(m20_4, ext_comune20)

m20 <- c(m20_1c, m20_2c, m20_3c, m20_4c)

plot(m20) #Per visualizzare le immagini delle 4 bande



  # Luglio-Agosto 2022                                 
m22_1 <- rast("m22_B2.tif")
m22_2 <- rast("m22_B3.tif")
m22_3 <- rast("m22_B4.tif")
m22_4 <- rast("m22_B11.tif")

ext_comune22 <- intersect(intersect(ext(m22_1), ext(m22_2)), intersect(ext(m22_3), ext(m22_4)))

m22_1c <- crop(m22_1, ext_comune22)
m22_2c <- crop(m22_2, ext_comune22)
m22_3c <- crop(m22_3, ext_comune22)
m22_4c <- crop(m22_4, ext_comune22)

m22 <- c(m22_1c, m22_2c, m22_3c, m22_4c)

plot(m22) #Per visualizzare le immagini delle 4 bande



  # Luglio-Agosto 2024
m24_1 <- rast("m24_B2.tif")
m24_2 <- rast("m24_B3.tif")
m24_3 <- rast("m24_B4.tif")
m24_4 <- rast("m24_B11.tif")

ext_comune24 <- intersect(intersect(ext(m24_1), ext(m24_2)), intersect(ext(m24_3), ext(m24_4)))

m24_1c <- crop(m24_1, ext_comune24)
m24_2c <- crop(m24_2, ext_comune24)
m24_3c <- crop(m24_3, ext_comune24)
m24_4c <- crop(m24_4, ext_comune24)

m24 <- c(m24_1c, m24_2c, m24_3c, m24_4c)

plot(m24) #Per visualizzare le immagini delle 4 bande


# Imposto una visualizzazione delle immagini utilizzando la funzione par(), 
# creando una griglia di 4 righe e 2 colonne. Il primo plot mostra le immagini in TrueColor ovvero lo spettro RGB. 
# Il secondo plot viene impostato con la banda dello SWIR in prima posizione così da evidenziare al meglio
# la differenza tra vegetazione/rocce e neve/ghiaccio.

par(mfrow=c(4,2))
im.plotRGB(m17, 3,2,1)
im.plotRGB(m20, 3,2,1)
im.plotRGB(m22, 3,2,1)
im.plotRGB(m24, 3,2,1)

dev.off()


par(mfrow=c(4,2))
im.plotRGB(m17, 4,3,2)
im.plotRGB(m20, 4,3,2)
im.plotRGB(m22, 4,3,2)
im.plotRGB(m24, 4,3,2)

dev.off()


#-----------------------------------------------------------

# calcolo L’NDWI per il ghiaccio (talvolta chiamato NDSI – Normalized Difference Snow Index) 
# un indice spettrale pensato per identificare ghiaccio e neve in immagini satellitari o da drone.
# NDSI=(B3-B11)/(B3+B11)  
# B3 qui è la banda del verde così come impostata su Sentinel-2. B11 è per il SWIR. 
# Si sfruttano queste due bande per poter mettere in risalto il ghiaccio. 

# 2017
diff17 = m17[[2]] - m17[[4]] # differenza tra GREEN e SWIR
somm17 = m17[[2]] + m17[[4]] # somma tra GREEN e SWIR
# Uso le parentesi quadre [] per selezionare i layer che mi interessano dello stack
ndsi17 = diff17 / somm17

plot(ndsi17)


# 2020
diff20 = m20[[2]] - m20[[4]] # differenza tra GREEN e SWIR 
somm20 = m20[[2]] + m20[[4]] # somma tra GREEN e SWIR
ndsi20 = diff20 / somm20

plot(ndsi20)


# 2022
diff22 = m22[[2]] - m22[[4]] # differenza tra GREEN e SWIR 
somm22 = m22[[2]] + m22[[4]] # somma tra GREEN e SWIR
ndsi22 = diff22 / somm22

plot(ndsi22)


# 2024
diff24 = m24[[2]] - m24[[4]] # differenza tra GREEN e SWIR 
somm24 = m24[[2]] + m24[[4]] # somma tra GREEN e SWIR
ndsi24 = diff24 / somm24

plot(ndsi24)



# Visualizzazione delle immagini elaborate attraverso l'indice NDSI, 
# suddividendoli per anni
# La colorazione scelta è viridis perché la porzione di acqua verrà evidenziata in giallo, 
# il resto del territorio apparirà in una scala di blu. 
# Sfrutto sempre la stessa impostazione data da un par() con 2 righe e 2 colonne così da avere 
# le immagini tutte ordinate

par(mfrow=c(4,2))
plot(ndsi17, col=viridis (100)) # 2017 
plot(ndsi20, col=viridis (100)) # 2020
plot(ndsi22, col=viridis (100)) # 2022
plot(ndsi24, col=viridis (100)) # 2024

dev.off()


# Creazione del par per la visualizzazione delle classificazioni 
# utilizzando come base il risultato del NDSI.

par(mfrow=c(2,2))

marm17 <- im.classify(ndsi17, num_clusters=3)
# Divisione in 3 tipi di terreno: ghiaccio, roccia e vegetazione
# Calcolo le percentuali di copertura per ogni classe per l'anno 2017

cell17 <- ncell(marm17)
freq17 <- freq(marm17)
prop17 = freq17/ cell17
perc17 = prop17 * 100
perc17


marm20 <- im.classify(ndsi20, num_clusters=3) 

# Calcolo le percentuali di copertura per l'anno 2020

cell20 <- ncell(marm20)
freq20 <- freq(marm20)
prop20 = freq20/ cell20
perc20 = prop20 * 100
perc20


marm22 <- im.classify(ndsi22, num_clusters=3) 

# Calcolo le percentuali di copertura per l'anno 2022

cell22<- ncell(marm22)
freq22 <- freq(marm22)
prop22 = freq22/ cell22
perc22 = prop22 * 100
perc22


marm24 <- im.classify(ndsi24, num_clusters=3) 

# Calcolo le percentuali di copertura per l'anno 2024

cell24<- ncell(marm24)
freq24 <- freq(marm24)
prop24 = freq24/ cell24
perc24 = prop24 * 100
perc24

# creazione dei campi che verranno utilizzati per il dataframe 

ice <- c(4.87, 9.38, 9.28, 6.54) # percentuali del ghiaccio


# Creazione del dataframe

tab <- data.frame(ice)
tab

# Visualizzo il dataframe in una versione tabellare

View(tab) 

# Calcolo la differenza tra il 2022 e il 2024 che sono gli ultimi anni
diffghiacc = 9.58 - 6.54
diffghiacc #3.04 è la percentuale di ghiaccio perso negli ultimi 2 anni

#Calcoliamo l'estensione in ettari utilizzando la superfice in metri quadrati grazie alla risoluzione dell'immagine Sentinel :
m22 # per vedere le dimensioni

(328*1006)*10 # 10m è la risoluzione di Sentinel-2

# Risultato in metri quadrati = 3299680
# tra il 2019 e il 2019 abbiamo perso il 3.04 di 3299680
# quindi 

3299680*0.0304

# risultato :  100310.3 m^2 in ettari 10.03 ha
# Dal 2022 al 2024 il ghiacciaio della Marmolada si è ritirato di 10 ettari
