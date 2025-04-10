# Code for calculating spatial variability 
https://www.cuemath.com/data/standard-deviation/

install.packages("RStoolbox")

library(terra)
library(imageRy)
library(viridis)
library(patchwork)
library(RStoolbox)

# Teoria
# Calcolo deviazione standard --> quanto si scosta ogni dato dalla media

# 22, 23, 23, 49

m = (22 + 23 + 23 + 49) / 4
# m = 29.25
# Variabilità attorno a questa media

num = (23-29.25)^2 + (22-29.25)^2 + (23-29.25)^2 + (49-29.25)^2  # scarto quadratico
den = 4 - 1
variance = num / den # scarto quadratico medio

stdev= sqrt(variance) #sqrt è la radice quadrata, stdev è la deviazione standard

# stdev 
# Per fare più veloce: sd (c(22, 23, 23,49))

# ____________________________________

# im.list()

sent = im.import("sentinel.png")
# Bande: 
# 1 = nir
# 2 = red
# 3 = green

# Plot the image in RGB with the NIR ontop of the red component

im.plotRGB(sent, r=1, g=2, b=3) 

# Make three plots with NIR ontop of each component: r, g, b
im.multiframe(1,3)
im.plotRGB(sent, r=1, g=2, b=3) 
im.plotRGB(sent, r=2, g=1, b=3) 
im.plotRGB(sent, r=3, g=2, b=1) 

nir = sent[[1]] # Usamo solo 1 layer, del NIR

plot(nir)

# Plot the NIR band with the inferno color ramp palette

plot(nir, col=inferno(100))

# ?focal  --> si apre il manuale della funzione che stiamo chiedendo


sd3 = focal(nir, w=c(3,3), fun= sd) # w = finestra 3x3 pixel
# Deviazione standard ci fa vedere dove cambiano di più le interfacce roccia/acqua/vegetazione --> > variabilità
plot(sd3)

im.multiframe(1,2)
im.plotRGB(sent, r=1, g=2, b=3)
plot(sd3)

# Calculate standard deviaton of the NIR band with a moving window of 5x5 pixel

sd5 = (focal(nir, w=c(5,5), fun= sd))
plot(sd5) 

# Use ggplot to plot the standard deviation

im.ggplot(sd3)

# Plot the two sd maps ( 3, 5) one beside the other with ggplot

p1 = im.ggplot(sd3)
p2 = im.ggplot(sd5)
p1 + p2 

# With ggplot, plot the original set in RGB (ggRGB) toghether with theb sd with 3 and 5 pixel

p3 = ggRGB(sent, r = 1, g = 2, b = 3 )
p1 + p2 + p3





