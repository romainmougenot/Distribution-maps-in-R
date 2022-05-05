## Libraries for spatial data
library(sf)
library(spatstat)

## Import data
# Vectorial map.
map <- sf::st_read("ne_10m_coastline/ne_10m_coastline.shp") 
# Inventory data frame with x and y coordinates of points as columns; the two columns shoud be names as x and y respectively
inventory <- read.csv("amber_inventory_p1.csv", header = TRUE, ";") 

# Bounding box (limits of the spatial box): contains the Nort-West and South-East corners of 
# the extent of the spatial bow. Data frame with with x min and y min as a column, and x max and y max as a second column.
bb <- read.csv("bb3.csv", header = TRUE, ";") 


## Crop map
# Function from sf library which crops the map according to the x max and y max, and x min and y min, coordinates of the map's subset.
map_crop <- sf::st_crop(map, xmin = 13.31005, ymin = 43.72676, xmax = 16.21319, ymax = 45.60185) 


## Transform data into spatial data
# Set bounding box as spatial.
coordinates(bb) = ~x+y 
# Set inventory as spatial.
coordinates(inventory) = ~x+y 

## Create a point pattern
# Create a bounding box for the point pattern.
bb = bbox(bb) 
win <- owin(xrange = c(bb[1,1], bb[1,2]), yrange = c(bb[2,1], bb[2,2])) 

# Remove duplicated points to avoid cluping, and create the point pattern.
inventory <- remove.duplicates(inventory, zero = 0, remove.second = TRUE)
ppp_inventory <- spatstat.geom::ppp(inventory@coords[,1], inventory@coords[,2], window = win)

# Create heat map by converting the point pattern into a density frame, and add the vectorial map.
plot(density(ppp_inventory, bw.diggle), yaxt = "n", main = NULL,
     box = F,
     col = gray.colors(5, start = 1, end = 0.4))
plot(map_crop$geometry, add = T)
