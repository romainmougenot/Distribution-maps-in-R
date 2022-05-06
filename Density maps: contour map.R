library(sf)
library(spatstat)

## Libraries for spatial data
library(sf)
library(spatstat)

## Import data
# vectorial map.
map <- sf::st_read("nne_10m_coastline.shp") 
# inventory data frame with x and y coordinates of points as columns; the two columns shoud be names as x and y respectively
inventory <- read.csv("inventory.csv", header = TRUE, ";") 

# bounding box (limits of the spatial box): contains the Nort-West and South-East corners of 
# the extent of the spatial bow. Data frame with with x min and y min as a column, and x max and y max as a second column.
bb <- read.csv("bb3.csv", header = TRUE, ";") 


## Crop map
# function from sf library which crops the map according to the x max and y max, and x min and y min, coordinates of the map's subset.
map_crop <- sf::st_crop(map, xmin = 13.31005, ymin = 43.72676, xmax = 16.21319, ymax = 45.60185) 


## Transform data into spatial data
# set bounding box as spatial.
coordinates(bb) = ~x+y 
# set inventory as spatial.
coordinates(inventory) = ~x+y 

## Create a point pattern
# create a bounding box for the point pattern.
bb = bbox(bb) 
win <- owin(xrange = c(bb[1,1], bb[1,2]), yrange = c(bb[2,1], bb[2,2])) 

# remove duplicated points to avoid cluping, and create the point pattern.
inventory <- remove.duplicates(inventory, zero = 0, remove.second = TRUE)
ppp_inventory <- spatstat.geom::ppp(inventory@coords[,1], inventory@coords[,2], window = win)

## Create and plot contour map
rw <- 0.2
sd <- 0.2
# create density template from the point pattern
dens_r5 <- density(ppp_inventory, sd, eps=rw, edge=T, at="pixels")
# plot vectorial map
plot(map_crop$geometry)
# plot contours
contour(dens_r5, add=T)

# add points if wanted
points(ppp_inventory$x, ppp_inventory$y, pch=20)
