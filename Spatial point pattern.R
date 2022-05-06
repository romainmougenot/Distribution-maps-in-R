## Libraries for spatial data
library(sf)
library(spatstat)

## Import data
# inventory data frame with x and y coordinates of points as columns; the two columns shoud be named as x and y respectively
inventory <- read.csv("inventory.csv", header = TRUE, ";") 

# bounding box (limits of the spatial box): contains the Nort-West and South-East corners of 
# the extent of the spatial box: data frame with with x min and y min as a column, and x max and y max as a second column.
bb <- read.csv("bb3.csv", header = TRUE, ";") 

## Transform data into spatial data
# set bounding box as spatial.
coordinates(bb) = ~x+y 
# set inventory as spatial.
coordinates(inventory) = ~x+y 

## Create a point pattern
# create a bounding box for the point pattern.
bb = bbox(bb) 
win <- owin(xrange = c(bb[1,1], bb[1,2]), yrange = c(bb[2,1], bb[2,2])) 

# remove duplicated points to avoid cluping.
inventory <- remove.duplicates(inventory, zero = 0, remove.second = TRUE)
# create spatial point pattern with spatstat.geom::ppp() function, indicate the x and y coordinates, as well as the bounding box (win)
ppp_inventory <- spatstat.geom::ppp(inventory@coords[,1], inventory@coords[,2], window = win)

## Plot
plot(ppp_inventory)

