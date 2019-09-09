/// @param xx
/// @param yy
/// @param zz

var xx = argument0;
var yy = argument1;
var zz = argument2;

var map = Stuff.active_map.contents;

map.xx = xx;
map.yy = yy;
map.zz = zz;

graphics_create_grids();

ds_grid_resize(map.map_grid, xx, yy);
map_fill_grid(map.map_grid, zz);

Camera.ui.element_entity_pos_x.value_upper = xx - 1;
Camera.ui.element_entity_pos_y.value_upper = yy - 1;
Camera.ui.element_entity_pos_z.value_upper = zz - 1;