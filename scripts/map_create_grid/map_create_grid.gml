/// @description  ds_grid map_create_grid(xx, yy, zz);
/// @param xx
/// @param  yy
/// @param  zz

var grid=ds_grid_create(argument0, argument1);
ds_grid_clear(grid, noone);

map_fill_grid(grid, argument2);

return grid;
