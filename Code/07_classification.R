# R code for classifying images

install.packages("patchwork")
library(terra)
library(imageRy)
library(ggplot2)
library(patchwork)


im.list()

mato1992 = im.import("matogrosso_l5_1992219_lrg.jpg")
mato1992 = flip(mato1992)
plot(mato1992)

mato2006 = im.import("matogrosso_ast_2006209_lrg.jpg")
mato2006 = flip(mato2006)
plot(mato2006)

mato1992c = im.classify(mato1992, num_clusters=2) #viene invertito rispetto al prof, perchè parte a selezionare il primo pixel in modo casuale
# per Duccio classe 1 è la foresta, la 2 parte antropica, io ho il contrario 

mato2006c = im.classify(mato2006, num_clusters=2)

f1992 = freq(mato1992c)
f1992
tot1992 = ncell(mato1992c) #ncell somma i pixel
tot1992
prop1992 = f1992 / tot1992
prop1992
perc1992 = prop1992 * 100
perc1992

#Percentuali: 
#forest: 83%
#human: 17%

#Calcolo 2006

f2006 = freq(mato2006c)
f2006
tot2006 = ncell(mato2006c) #ncell somma i pixel
tot2006
prop2006 = f2006 / tot2006
prop2006
perc2006 = prop2006 * 100
perc2006 

# riga unica: perc2006 = freq(mato2006c) * 100 / ncell(mato2006c)
# percentuali: 
# forest: 45%
# human: 55%

# Creiamo istogrammi con le percentuali trovate:

class= c("Forest", "Human")
y1992 = c(83, 17)
y2006 = c(45, 55)
tabout = data.frame(class, y1992, y2006) # Dataframe per creare una tabella
tabout

# Dobbiamo spiegare a ggplot come creare l'istogramma

p1 = ggplot(tabout, aes(x=class, y=y1992, color= class) ) + 
  geom_bar(stat="identity", fill="white") + #per creare le barre dell'istogramma
    ylim(c(0,100))    

p2 = ggplot(tabout, aes(x=class, y=y2006, color= class) ) + 
  geom_bar(stat="identity", fill="white") + 
  ylim(c(0,100))

# Pacchetto patchwork per unire i due plot 

p1 + p2

# Dobbiamo mettere la stessa scala agli istogrammi : ylim=100

# Istogramma orizzontale 
p1 = ggplot(tabout, aes(x=class, y=y1992, color= class) ) + 
  geom_bar(stat="identity", fill="white") + #per creare le barre dell'istogramma
  ylim(c(0,100)) + 
  coord_flip()

p2 = ggplot(tabout, aes(x=class, y=y2006, color= class) ) + 
  geom_bar(stat="identity", fill="white") + 
  ylim(c(0,100)) +
  coord_flip()

p1 / p2
