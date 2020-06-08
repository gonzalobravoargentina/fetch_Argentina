#Script for calculate wind fetch using package fetchR

#fetchR is not longer available in CRAN, so you must install using github
#library(devtools)
#devtools::install_github("blasee/fetchR")


#info https://github.com/blasee/fetchR
library(fetchR)

#You can use several ways to import a SpatialPolygon into R and be able to calculate feth. here we show two ways
# 1- Import shapefile via rgdal
# 2- Import a KML file 


# 1- Import shapefile
# Read in the Polygon ESRI shapefile ARG_adm0 (https://data.amerigeoss.org/id/dataset/argentina-administrative-level-0-boundaries)
library(rgdal)
Arg_polygon_latlon = rgdal::readOGR("ARG_adm0")
is(Arg_polygon_latlon, "SpatialPolygons")#should be TRUE

#In order to get a precise estimation of linear distance in a polygon. Map projections should be choosed acording to the site where the points are. For atlantic patagonia coast the  POSGAR 07/Argentina 3 EPSG:5345 should work ok 
Arg_polygon_proj = spTransform(Arg_polygon_latlon, CRS("+init=epsg:5345"))


#Set the lat and long for the points where fetch will be calculated 
fetch.df = data.frame(
  lon = c(-65.975478, -65.808279),
  lat = c(-45.073078,  -45.059559),
  name = c("P1", "P2"))


fetch_locations = SpatialPoints(fetch.df[, 1:2], 
                           CRS(proj4string(Arg_polygon_latlon)))

## Same Projection for polygon and points 
fetch_locations_proj = spTransform(fetch_locations, CRS("+init=epsg:5345"))

#calculate fetch using 200 km distance and 9 directions
fetch = fetch(polygon_layer = Arg_polygon_proj,
                      site_layer = fetch_locations_proj,
                      max_dist = 200,
                      n_directions = 9,
                      site_names = fetch.df$name)
fetch

# Transform back to the original lat/lon coordinates
fetch_latlon = spTransform(fetch, CRS(proj4string(Arg_polygon_latlon)))


#plot all the points in a map
plot(fetch_latlon,axes = TRUE, cex.axis=0.7,col="grey")
plot(Arg_polygon_latlon, add = TRUE, col = "lightgrey")

#plot only one point
plot(fetch_latlon[[2]],axes = TRUE, cex.axis=0.7,col="grey")
plot(Arg_polygon_latlon, add = TRUE, col = "lightgrey", border = NA)


#Save fetch calculation to Kml that can be open on google earth 
kml(fetch_latlon,file.name="Arg_fetch.kml" ,colour = "white",overwrite=T)



# 2- Import a KML file for a smaller area (eg Golfo Nuevo) 
#mapa golfo nuevo
library(maptools)
tkml <- getKMLcoordinates(kmlfile="GolfoNuevo.kml", ignoreAltitude=T)
names <- c("lon", "lat")
points<- data.frame(tkml)
colnames(points) <- names
points$group <- 1

# Create a list for one polygon
golfonuevo.list = split(points[, c("lon", "lat")],points$group)
library(sp) 
golfonuevo.Poly = lapply(golfonuevo.list, Polygon)
golgonuevo.Polys = list(Polygons(golfonuevo.Poly, ID = "Golfo Nuevo"))

# Include CRS information to make it a SpatialPolygons object
golfonuevo.sp = SpatialPolygons(golgonuevo.Polys,proj4string = CRS("+init=epsg:4326"))


is(golfonuevo.sp, "SpatialPolygons")#should be TRUE
plot(golfonuevo.sp)

# Create the points layer
sites.df = data.frame(lon = c(-64.982325, -64.280488),lat = c(-42.779524, -42.590560),site = c("PtoMadryn","PtoPiramides"))
  
            
# Create the SpatialPoints object              
sites.sp = SpatialPoints(sites.df[, 1:2], CRS("+init=epsg:4326"))

#projection for polygon 
golfonuevo.proj = spTransform(golfonuevo.sp, CRS("+init=epsg:22173"))

plot(golfonuevo.proj)
#calculate fetch
fetch = fetch(golfonuevo.proj, sites.sp, site_names = sites.df$site,max_dist = 100)
summary(fetch)

# Transform the fetch vectors back to the original CRS
fetch_latlon = spTransform(fetch, proj4string(golfonuevo.sp))
# Return the raw data in the original, lat/lon coordinates
fetch_latlon.df = as(fetch_latlon, "data.frame")
# Plot the wind fetch vectors ------------------------------------

#plot 
plot(fetch_latlon,axes = TRUE, cex.axis=0.7)
plot(golfonuevo.sp, add = TRUE, col = "lightgrey")

