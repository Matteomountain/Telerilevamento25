# Code to calculate spectral indici

library(imageRy)
library(terra)
library(viridis)

im.list()
mato1992 = im.import("matogrosso_l5_1992219_lrg.jpg")
mato1992 = flip(mato1992) #per raddrizzare l'immagine
im.plotRGB(mato1992, r = 1, g = 2, b = 3)

# 1 = NIR
# 2 = red
# 3 = green

im.plotRGB(mato1992, r = 2, g = 1, b = 3) # Banda NIR sul verde per vedere la vegetazione
im.plotRGB(mato1992, r = 2, g = 3, b = 1) # Banda NIR sul blu per vedere il suolo nudo (giallo)

# Importare immagine del 2006
mato2006 = im.import("matogrosso_ast_2006209_lrg.jpg")
mato2006 = flip(mato2006)
plot(mato2006)

im.multiframe(1, 2)
im.plotRGB(mato1992, r = 2, g = 3, b = 1, title = "Mato Grosso 1992")
im.plotRGB(mato2006, r = 2, g = 3, b = 1, title = "Mato Grosso 2006")

# Radiometric resolution
plot(mato1992[[1]], col = inferno(100))
plot(mato2006[[1]], col = inferno(100))

# Concetto di BITS: 1 bit 0,1 - 2 bit 00,01,10,11 --> è esponenzile 2^3 . L'immagine che va a 255 pixel sono immagini a 8bit (2^8)
# Non uso la riflettanza originale perchè i pixel usano numeri decimali tutti diversi, con i 255 bit ho solo numeri interi
# Possiamo creare un indice different vegetation index - DVI - stato di salute di una pianta

# Tree:         NIR=255, red=0, DVI= NIR-red= 255-0=255 la pianta assorbe tutto il rosso 
# Stressed tree:NIR=100, red=20 DVI= NIR-red= 100-20=80 

#Calculating DVI

im.multiframe(1, 2)
plot (mato1992)
plot (mato2006)

#1 = NIR
#2 = Red 

dvi1992= mato1992[[1]] - mato1992[[2]]  # NIR - red
plot (dvi1992)

#Range DVI 
# Max: NIR - red = 255 - 0 = 255
# Min: NIR - red = 0 - 255 = - 255

plot (dvi1992, col= magma(100))

# Calcolo DVI 2006 
dvi2006= mato2006[[1]] - mato2006[[2]] 
plot(dvi2006, col=mako(100))

im.multiframe (1,2) #Mettiamo le due immagini vicino 
plot (dvi1992, col= mako(100))
plot(dvi2006, col=mako(100))

# Different radiometric resolutions -> per esempio immagine a 4 e 8 bit
# DVI 8 bit: range (0-255)
# Max: NIR - red = 255 - 0 = 255
# Min: NIR - red = 0 - 255 = - 255

# DVI 4 bit: range (0-15)
# Max: NIR - red = 15 - 0 = 15
# Min: NIR - red = 0 - 15 = - 15
# Non possiamo pargonare due immagini a bit diversi, c'è un altro indice NDVI --> standardizzazione

# NDVI 8 bit: range (0-255)
# Max: (NIR - red) / (Nir + red) = (255 - 0) / (255 + 0) = 1
# Min: (NIR - red) / (Nir + red) = (0 - 255) / (0 + 255) =-1

# NDVI 4 bit: range (0-255)
# Max: (NIR - red) / (Nir + red) = (15 + 0) / (15 + 0) = 1
# Min: (NIR - red) / (Nir + red) = (0 - 15) / (0 + 15) =-1


ndvi1992 = (mato1992[[1]] - mato1992[[2]]) / (mato1992[[1]] + mato1992[[2]])
plot(ndvi1992)

ndvi2006 = (mato2006[[1]] - mato2006[[2]]) / (mato2006[[1]] + mato2006[[2]])
plot(ndvi2006)


# Funzione di imageRy per DVI
dvi1992auto = im.dvi(mato1992, 1, 2)
plot (dvi1992auto)

dvi2006auto = im.dvi(mato2006, 1, 2)
plot (dvi2006auto)

#Stessa cosa per NDVI
ndvi1992auto = im.ndvi(mato1992, 1, 2)
plot (ndvi1992auto)

ndvi2006auto = im.ndvi(mato2006, 1, 2)
plot (ndvi2006auto)

im.multiframe(1,2) # per far vedere che sono la stessa immagine, una calcolata con la formula, una usando la funzione
plot(ndvi1992)
plot (ndvi1992auto)

