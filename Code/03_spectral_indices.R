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



