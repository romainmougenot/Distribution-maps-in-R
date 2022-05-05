library(sf)
#library(ggspatial)
library(spatstat)
#library(tidyverse)
#library(tmap)
#library(ggmap)


# import data
map <- sf::st_read("ne_10m_coastline/ne_10m_coastline.shp") # vectorial map
inventory <- read.csv("amber_inventory_p1.csv", header = TRUE, ";") # inventory data frame with x and y coordinates of points as columns
bb <- read.csv("bb3.csv", header = TRUE, ";") # bounding bow: data frame with x min and x max as first row, and y min and y max as second row

map_crop <- sf::st_crop(map, xmin = 13.31005, ymin = 43.72676, xmax = 16.21319, ymax = 45.60185) # function from sf

coordinates(bb) = ~x+y
coordinates(inventory) = ~x+y
bb = bbox(bb)

win <- owin(xrange = c(bb[1,1], bb[1,2]), yrange = c(bb[2,1], bb[2,2]))
inventory <- remove.duplicates(inventory, zero = 0, remove.second = TRUE)
ppp_inventory <- spatstat.geom::ppp(inventory@coords[,1], inventory@coords[,2], window = win)


plot(density(ppp_inventory, bw.diggle), yaxt = "n", main = NULL,
     box = F,
     col = gray.colors(5, start = 1, end = 0.4))
plot(map_crop$geometry, add = T)
