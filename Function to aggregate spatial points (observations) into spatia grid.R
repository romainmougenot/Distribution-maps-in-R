# The function is a modification of a similar function (aggr_fea_voro) from the "moin" library (MOdelling INteraction: https://gitlab.com/CRC1266-A2/moin)
# and is adapted to spatial grids. It aggregates georeferenced observations into spatial units (cells). 

## Import libraries
library(spatstat)
library(maptools)
library(sp)

## Function aggr_fea_voro_cell
# The function takes three arguments in entry: 
# - grid: a spatial frame with georeferenced cells
# - win: a spatial frame setting the limits of the spatial frame
# - features: a data frame with x and y coordinates of observations as columns, and the observation's type as a column (type_col)
# - type_col: the last column of the features data frame, indicating the types of observations
# Returns a data frame with 


aggr_fea_voro_cell <- function (grid, win, features, type_col) 
{
  err <- stats::rnorm(length(features[, 1]), mean = 0, sd = 1e-04)
  features[, 1] <- features[, 1] + err
  ppp_nd <- maptools::as.ppp.SpatialPoints(grid)
  ppp_fea <- ppp_fea <- spatstat.geom::as.ppp(features[, c(1, 2)], W = win)
  voronoi <- spatstat.geom::dirichlet(ppp_nd)
  ppp_assign <- spatstat.geom::cut.ppp(ppp_fea, voronoi)
  df_aggr_fea <- cbind(features[type_col], nodes = as.numeric(ppp_assign[["marks"]]))
  return(df_aggr_fea)
}
