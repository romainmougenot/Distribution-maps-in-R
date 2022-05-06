## Function spatial_grid
# the function creates a spatial grid with which to divide an area of study into cells of equal size  
# the function takes two arguments:
# - cellsize: a numeric varibale which determines de size of the grid's cells
# - map: a vectorial or raster map
# the function returns a spatial frame containing a list of individual cells, which can be plotted and used for spatial analysis

spatial_grid <- function(cellsize, map) {
  g = st_make_grid(st_as_sfc(st_bbox(map) +
                               c(-cellsize/2, - cellsize/2,
                                 cellsize/2, cellsize/2)),
                   what = "polygons", cellsize = cellsize) 
  grid <- as_Spatial(g)
  return(grid)
  return(g)
}
  
## Example
grid_grid = spatial_grid(0.2,map_crop_sp)
# plot the grid
plot(grid_grid)
# add the map
plot(map_crop_sp, add = T)
