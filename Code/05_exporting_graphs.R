# _____________________________ Exporting data

setwd("~/Downloads/") # Abbiamo scelto il percorso per salvare un file
getwd() # Per vedere dove si salverà

pdf("output.pdf") # Funzione per creare un nuovo file PDF, e tra virgolette il nome del file
plot(grdif) # Poi plottiamo l'immagine che vogliamo creare il PDF
dev.off() # Per chiudere la funzione

jpeg("output.jpeg") # Funzione per creare un nuovo file jpeg, e tra virgolette il nome del file
plot(grdif) # Poi plottiamo l'immagine che vogliamo creare il jpeg
dev.off() # Per chiudere la funzione
