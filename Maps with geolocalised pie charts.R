## Libraries for spatial data
library(sf)
library(spatstat)

## Import data
# vectorial map.
map <- sf::st_read("nne_10m_coastline.shp") 
# inventory data frame with x and y coordinates of points as columns; the two columns shoud be named as x and y respectively.
# there should also be a columns with observation quantities for each spatial point
inventory <- read.csv("grave_p1.csv", header = TRUE, ";") 

# bounding box (limits of the spatial box): contains the Nort-West and South-East corners of 
# the extent of the spatial box: data frame with with x min and y min as a column, and x max and y max as a second column
bb <- read.csv("bb3.csv", header = TRUE, ";") 

## Crop map
# function from sf library which crops the map according to the x max and y max, and x min and y min, coordinates of the map's subset
map_crop <- sf::st_crop(map, xmin = 13.31005, ymin = 43.72676, xmax = 16.21319, ymax = 45.60185) 


## Transform data into spatial data
# set bounding box as spatial
coordinates(bb) = ~x+y 
# set inventory as spatial.
coordinates(inventory) = ~x+y 

## Create a point pattern
# create a bounding box for the point pattern
bb = bbox(bb) 
win <- owin(xrange = c(bb[1,1], bb[1,2]), yrange = c(bb[2,1], bb[2,2])) 

## Create point pattern
# create spatial point pattern with spatstat.geom::ppp() function, indicate the x and y coordinates, as well as the bounding box (win)
# also set the observation quantities column as marks, the sizes of pies will be indexed on it.
ppp_inventory <- ppp(inventory$x, inventory$y, window = win, marks = inventory$grave)

## Plotting
# set pies' sizes according to the quantities of observations
pointsize <- c(3, 15, 30) 
# plot map
plot(map_crop$geometry)
# add spatial point pattern
points(ppp_pie$x, ppp_pie$y,
     pch = 21, col = "black", bg = gray(0.8, alpha = 0.5),
     cex = sqrt(ppp_pie$marks)) # set size according to the quantities of observations
# set georeferenced legend
text(ppp_pie$x, ppp_pie$y, ppp_pie$marks, cex = 0.8, pos = 4, offset = .7)
legend(x = 16, y = 45, legend = pointsize,
       pt.cex = (sqrt(pointsize)/2),
       pch = 21,
       col = "black", title = expression(bold("Graves")), cex = 0.7, xjust = 0.5) 
