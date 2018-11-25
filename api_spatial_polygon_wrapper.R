```{r}
library(httr)
# get request
wards<- GET('https://opendata.bristol.gov.uk//api/records/1.0/search/?dataset=wards&rows=34')
# get contents
wards <- content(wards)
# get length of wards
len <- length(wards$records)
# extract coordinate info   
w1 <- wards$records[[1]]$fields$geo_shape$coordinates
# rename columns
w2 <- lapply(w1[[1]],function(x) {names(x) <- c('lat','lng')
return(x)
})
# convert to dataframe
w3 <- data.frame(matrix(unlist(w2), nrow=length(w2), byrow=T))
# reshuffle columns
w3 <- w3[c(2,1)]
# rename columns
names(w3) <- c('lat','lng')
# get coordinates
coords <- coordinates(w3)
# make spatial with coordinates and projection
x <- SpatialPointsDataFrame(coords=coords, data=w3,proj4string = CRS('+init=epsg:4326'))
# join spatial points to polygons
poly <- SpatialPolygons( list(  Polygons(list(Polygon(coords)), 1)))
poly
```
