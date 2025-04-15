# R code for Principal Component Analysis

library(imageRy)
library(terra)

im.list()


sent = im.import("sentinel.png")
sent = flip(sent)
plot(sent)


# Togliamo la banda gialla che non ci serve --> stack delle prime 3 bande 

sent = c(sent[[1]], sent[[2]],sent[[3]])
plot(sent)

# BAND 1 = NIR
# BAND 2 = red
# BAND 3 = green

sentpca = im.pca(sent, n_samples= 100000) 

tot = 77 + 53 + 6 # lunghezze dei nuovi assi sommate
# tot 

# 77 : tot = x : 100

77 * 100 / tot # per trovare la percentuale del 

sdpc1 = focal(sentpca[[1]], w=c(3,3), fun="sd") 
plot(sdpc1) 

pairs(sent) # per vedere relazione tra due variabili








