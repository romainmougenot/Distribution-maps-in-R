## Libraries for spatial data
library(sf)
library(spatstat)

## Import data
# vectorial map
map <- sf::st_read("nne_10m_coastline.shp") 
# inventory data frame with x and y coordinates of points as columns; the two columns shoud be named as x and y respectively
inventory <- read.csv("inventory.csv", header = TRUE, ";") 

# bounding box (limits of the spatial box): contains the Nort-West and South-East corners of 
# the extent of the spatial box: data frame with with x min and y min as a column, and x max and y max as a second column
bb <- read.csv("bb3.csv", header = TRUE, ";") 

## Crop map
# function from sf library which crops the map according to the x max and y max, and x min and y min, coordinates of the map's subset
map_crop <- sf::st_crop(map, xmin = 13.31005, ymin = 43.72676, xmax = 16.21319, ymax = 45.60185) 

## Transform data into spatial data
# set bounding box as spatial.
coordinates(bb) = ~x+y 
# Set inventory as spatial.
coordinates(inventory) = ~x+y 

## Create a point pattern
# create a bounding box for the point pattern
bb = bbox(bb) 
win <- owin(xrange = c(bb[1,1], bb[1,2]), yrange = c(bb[2,1], bb[2,2])) 

# remove duplicated points to avoid cluping
inventory <- remove.duplicates(inventory, zero = 0, remove.second = TRUE)
# create the point pattern
ppp_inventory <- spatstat.geom::ppp(inventory@coords[,1], inventory@coords[,2], window = win)

# create heat map by converting the point pattern into a density frame
plot(density(ppp_inventory, bw.diggle), yaxt = "n", main = NULL,
     box = F,
     col = gray.colors(5, start = 1, end = 0.4)) # set color palette
# add the vectorial map
plot(map_crop$geometry, add = T)
