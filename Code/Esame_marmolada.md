# 🏔️ Marmolada - Sentinella delle Dolomiti 🏔️

## Sorde Matteo - 15 Luglio 2025


## Analisi della variazione della copertura del ghiacciaio della Marmolada dal 2017 al 2024 

Tale studio utilizza le immagini satellitari relative alla Marmolada - Sentinella delle Dolomiti.
Il codice ha l'obiettivo di quantificare la variazione della superficie del ghiacciaio della Marmolada 
per valutarne il ritiro (presunto) in un periodo compreso tra il 2017 e il 2024, a intervalli di 2 anni. 
Ricordiamo che nel 2022 c'è stato il crollo di una porzione di ghiacciaio. 

---

## Dati 
- Fonte: [Google Earth Engine (GEE)](https://developers.google.com/earth-engine/datasets/catalog/COPERNICUS_S2_SR_HARMONIZED?hl=it) 
- Satellite: Sentinel-2
- Periodi osservati:
  - **2017**: luglio–agosto 
  - **2020**: luglio–agosto
  - **2022**: luglio–agosto
  - **2024**: luglio–agosto
- Risoluzione: 10 m
- Bande usate: `[1]`B2 (Blu),`[2]` B3 (Verde),`[3]` B4 (Rosso), `[4]`B11 (SWIR) (migliore per il ghiaccio, rispetto a NIR per l'acqua).

## Pacchetti R utilizzati


```r
library(imageRy) 
library(terra)
library(viridis)
library(ggplot2)

```

### Impostazione della working directory e importazione delle immagini scaricate da Google Earth Engine

Imposto la cartella di lavoro dove sono state posizionate le immagini relative alla Marmolada, carico le immagini della Marmolada per ogni banda, 
relative agli anni 2017, 2020, 2022, 2024. Ogni banda viene assegnata ad un oggetto. 
Anche se nel corso abbiamo usato = , preferisco assegnare con la freccia per mio ordine mentale.
Queste vengono poi incluse in uno stack per creare una immagine che contenga tutte le bande e verrà fatto lo stesso per ogni anno.

**Layers** 
- 1 = blue (B2)
- 2 = green (B3)
- 3 = red (B4)
- 4 = Short-Wave Infrared (B11)

<details>
<summary>Inserimento directory (cliccare qui)</summary>

```r
setwd("/Users/matteo/Downloads/TelEsame")   Inserisco la directory dei file
getwd()              Per verificare la directory
list.files()         Per Controllare che i file siano visibili

```
</details>

**Importiamo le immagini di Luglio 2017**

<details>
<summary>Importazione immagini (cliccare qui)</summary>

```r
  # Luglio-Agosto 2017
m17_1 <- rast("m17_B2.tif")
m17_2 <- rast("m17_B3.tif")
m17_3 <- rast("m17_B4.tif")
m17_4 <- rast("m17_B11.tif")

```
</details>

>[!IMPORTANT]
>Prima di fare lo stack devo rendere i 4 layer uguali, perchè i primi 3 li ho scaricati insieme, 
>mentre la banda SWIR un altro giorno e avevo perso il poligono precedente su GEE. Perciò hanno estensioni leggermente differenti e non combaciano,
>una volta trovata l'estensione comune procedo con il crop per renderli uguali. 

<details>
<summary>Ritaglio (cliccare qui)</summary>

```r
ext_comune17 <- intersect(intersect(ext(m17_1), ext(m17_2)), intersect(ext(m17_3), ext(m17_4)))

m17_1c <- crop(m17_1, ext_comune17)
m17_2c <- crop(m17_2, ext_comune17)
m17_3c <- crop(m17_3, ext_comune17)
m17_4c <- crop(m17_4, ext_comune17)

m17 <- c(m17_1c, m17_2c, m17_3c, m17_4c)

plot(m17) Per visualizzare le immagini delle 4 bande

```
</details>

Ripeto questo procedimento per le altre 3 annate rimanenti.
Una volta creati gli stack imposto una visualizzazione delle immagini utilizzando la funzione par(), 
creando una griglia di 4 righe e 2 colonne. Il primo plot mostra le immagini in TrueColor ovvero lo spettro RGB. 
Il secondo plot viene impostato con la banda dello SWIR in prima posizione così da evidenziare al meglio
la differenza tra vegetazione/rocce e neve/ghiaccio.

<details>
<summary>RGB (cliccare qui)</summary>

```r
par(mfrow=c(4,2))
im.plotRGB(m17, 3,2,1)
im.plotRGB(m20, 3,2,1)
im.plotRGB(m22, 3,2,1)
im.plotRGB(m24, 3,2,1)
```
</details>

Per visualizzare meglio il ghiaccio è possibile convertire l'immagine RGB con il falso colore evidenziando in azzurro le parti di ghiaccio. 
Questo passaggio è fondamentale per vedere le parti di ghiacciaio perso dal 2017 al 2024 nella Marmolada.
Nello spettro elettromagnetico la banda dell' infrarosso  (non visibile all'occhio umano) viene assorbita e riflessa dal ghiaccio in maniera chiara
perciò è utile per vedere la copertura del ghiacciaio.  

>[!TIP]
>**Per il falso colore metto la banda SWIR sul rosso**

<details>
<summary>Falso colore (cliccare qui)</summary>

```r
par(mfrow=c(4,2))
im.plotRGB(m17, 4,3,2)
im.plotRGB(m20, 4,3,2)
im.plotRGB(m22, 4,3,2)
im.plotRGB(m24, 4,3,2)
```
</details>

Le immagini vegono così visualizzate:  

**Marmolada RGB**
<p align="center">
 <img width="750" alt="Marm RGB" src="https://github.com/Matteomountain/Telerilevamento25/blob/main/Pics/marmRGB.png" /> 
</p>

**Marmolada a falsi colori**
<p align="center">
<img width="750" alt="Marm falso colore" src="https://github.com/Matteomountain/Telerilevamento25/blob/main/Pics/marmSWIR.png" /> 
</p>


## Calcolo L’NDWI per il ghiaccio (chiamato NDSI – Normalized Difference Snow Index) 
Un indice spettrale pensato per identificare ghiaccio e neve in immagini satellitari o da drone.

$$
NDSI = \frac{GREEN-SWIR}{GREEN + SWIR}
$$

>[!NOTE]
> B3 qui è la banda del verde così come impostata su Sentinel-2. B11 è per lo SWIR. 

Si sfruttano queste due bande per poter mettere in risalto il ghiaccio. 

Esempio con il 2017

<details>
<summary>NDSI 2017 (cliccare qui)</summary>

```r
diff17 = m17[[2]] - m17[[4]] # differenza tra GREEN e SWIR
somm17 = m17[[2]] + m17[[4]] # somma tra GREEN e SWIR
# Uso le parentesi quadre [] per selezionare i layer che mi interessano dello stack
ndsi17 = diff17 / somm17

plot(ndsi17)
```
</details>

Ripeto lo stesso procedimento con i restanti 3 anni e creo una visualizzazione delle immagini elaborate attraverso l'indice NDSI, 
suddividendoli per anni. La colorazione scelta è viridis perché la porzione di acqua verrà evidenziata in giallo, il resto del territorio apparirà in una scala di blu. 
Sfrutto sempre la stessa impostazione data da un par() con 2 righe e 2 colonne così da avere le immagini tutte ordinate. 

<details>
<summary>Plot NDSI (cliccare qui)</summary>

```r
par(mfrow=c(4,2))
plot(ndsi17, col=viridis (100)) # 2017 
plot(ndsi20, col=viridis (100)) # 2020
plot(ndsi22, col=viridis (100)) # 2022
plot(ndsi24, col=viridis (100)) # 2024
```
</details>

Per visualizzare meglio la differenza e creare un multiframe che sia adatto anche alle persone affette da daltonismo possiamo utilizzare una palette specifica del pacchetto
[Viridis](https://cran.r-project.org/web/packages/viridis/vignettes/intro-to-viridis.html)  

**L'output sarà il seguente:**

<p align="center">
<img width="650" alt="Marm falso colore" src="https://github.com/Matteomountain/Telerilevamento25/blob/main/Pics/NDSI.png" >
</p>

## Classificazione
In seguito al calcolo dell'NDSI dell'area è possibile fare una clasificazione binaria dei pixel in R per distinguere prima di tutto la differenza tra ghiaccio, roccia e vegetazione,
e in seguito vedere è cambiato il numero dei pixel nell'immagine simboleggiando la perdita o l'aumento del ghiacciaio in seguito ai cambiamenti climatici.  

Grazie al pacchetto `imagery` in R è possibile analizzare i dati raster e fare una classificazione dei pixel in 3 parti. 
In questo caso si può fare una classificazione in tre classi tra bosco, roccia e ghiaccio partendo dalle NDSI.  

>[!TIP]
>Confrontiamo le NDSI con la funzione `im.classify`

<details>
<summary>Classificazione (cliccare qui)</summary>

```r
marm17 <- im.classify(ndsi17, num_clusters=3)
# Divisione in 3 tipi di terreno: ghiaccio, roccia e vegetazione
```
</details>

Una volta creata la classificazione posso plottare l'immagine relativa ai 3 tipi di terreno:  

<p align="center">
<img width="650" alt="Marmolada classificazione" src="https://github.com/Matteomountain/Telerilevamento25/blob/main/Pics/class17.png" >
</p>

Effettuo la classificazione su le altre annate. 
Ora che abbiamo la classificazione in tre classi sulle immagini possiamo calcolare i pixel e ricavare la percentuale di ghiaccio per ogni anno.  

## Calcolo percentuali  

Calcolo le percentuali di copertura per ogni classe per l'anno 2017, 2020, 2022 e 2024
Questa funzione fornisce un data frame con colonne value (1 o 2) e count (numero di pixel)

Calolo percentuale 2017:  
<details>
<summary>Percentuali 2017 (cliccare qui)</summary>

```r
cell17 <- ncell(marm17)
freq17 <- freq(marm17)
prop17 = freq17/ cell17
perc17 = prop17 * 100
perc17
```
</details>

I dati che ne escono sono i seguenti:  
```r
          layer      value     count
1 0.0003030597 0.0003030597 38.170974
2 0.0003030597 0.0006061194  4.865926
3 0.0003030597 0.0009091791 56.963099
```
Eseguo lo stesso calcolo per i restanti anni e mi segno le percentuali di ghiaccio per creare una tabella:  

**Creazione dei campi che verranno utilizzati per il dataframe**
```r
ice <- c(4.87, 9.38, 9.28, 6.54) # percentuali del ghiaccio

# Creazione del dataframe

tab <- data.frame(ice)
tab
# Visualizzo il dataframe in una versione tabellare

View(tab) 

# Calcolo la differenza tra il 2022 e il 2024 che sono gli ultimi anni
diffghiacc = 9.58 - 6.54
diffghiacc
#3.04 è la percentuale di ghiaccio perso negli ultimi 2 anni
```
---

Calcoliamo l'estensione in ettari utilizzando la superfice in metri quadrati grazie alla risoluzione dell'immagine Sentinel :  

Calcolo la differenza tra il 2022 e il 2024 che sono gli ultimi anni

```r
diffghiacc = 9.58 - 6.54
diffghiacc
```

> [!CAUTION]
> 3.04% è la percentuale di ghiaccio perso negli ultimi 2 anni

Calcoliamo l'estensione in ettari utilizzando la superfice in metri quadrati grazie alla risoluzione dell'immagine Sentinel :

```r
m22  # per vedere le dimensioni dell'immagine
(328*1006)*10
# 10m è la risoluzione di Sentinel-2
```

**Risultato in metri quadrati = 3299680**  

Tra il 2019 e il 2019 abbiamo perso il 3.04% di 3299680 quindi:

```r
3299680*0.0304
```

**Risultato:**  100310.3 m^2 persi, in ettari 10.03 ha

>[!WARNING]
>Dal 2022 al 2024 il ghiacciaio della Marmolada si è ritirato di 10 ettari

## Conclusioni

L’analisi condotta sul ritiro del ghiacciaio della Marmolada mette in evidenza una regressione significativa, in linea con il rapido riscaldamento delle temperature medie alpine. Il ghiacciaio si sta sciogliendo sempre più rapidamente a causa del riscaldamento globale, che negli ultimi decenni ha provocato una marcata perdita di massa glaciale in tutto l’arco alpino. È importante notare che l’immagine relativa all’anno 2022 presenta alcune incertezze dovute alla parziale copertura nuvolosa, che potrebbe aver influenzato la precisione nella delimitazione della fronte glaciale. Questo potrebbe aver causato una lieve sovrastima o sottostima dell’estensione residua, ma non altera la tendenza complessiva.

Le proiezioni per i prossimi decenni indicano che, in assenza di un’inversione nelle attuali tendenze climatiche, il ghiacciaio della Marmolada potrebbe ridursi drasticamente fino a scomparire quasi del tutto entro la fine del secolo. I dati confermano dunque l’urgenza di azioni concrete per limitare gli effetti del cambiamento climatico e preservare ciò che resta dei ghiacciai alpini, fondamentali indicatori dello stato di salute del nostro ambiente.

---

# GRAZIE PER L'ATTENZIONE! 🏔🧗‍♂


