/// @param xx
/// @param yy
/// @param zz

var xx = argument0;
var yy = argument1;
var zz = argument2;

var grid = ds_grid_create(xx, yy);
map_fill_tag_grid(grid, zz);

return grid;