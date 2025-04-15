# Code to build own function
# Funzione somma, x e y sono gli argomenti che l'utente sceglierà

somma <- function(x,y) {
z = x + y 
return(z)
}

# Esercizio: crea la funzione differenza

diff <- function(x,y) {
z = x - y 
return(z)
}


# Funzione che costruisca il multiframe senza scrivere tutto il codice

mf <- function(nrow,ncol) {
par(mfrow=c(nrow,ncol))
  
}

# Funzione positivo per vedere se un numero è positivo o negativo

positivo <- function(x) {
  if(x>0) {
  print("è un numero positivo, asino")
  }
  else if (x<0) {
  print("è un numero negativo ovviamente")
  }
  else if (x==0) {
  print("Lo zero vale zero") 
  }  
}
