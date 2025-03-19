# Reporting multitemporal analysis in R

First of all, we should import an image by:
```r
im.list() # Make a list
gr = im.import("greenland") # To import an image
```

Then, we might calculate the difference of values of two images
```r
grdif = gr[[4]] - gr[[1]]
```
This will create




