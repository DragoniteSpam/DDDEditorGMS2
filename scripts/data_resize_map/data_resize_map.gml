/// @param xx
/// @param yy
/// @param zz

var xx = argument0;
var yy = argument1;
var zz = argument2;

ActiveMap.xx = xx;
ActiveMap.yy = yy;
ActiveMap.zz = zz;

graphics_create_grids();

ds_grid_resize(ActiveMap.map_grid, xx, yy);
map_fill_grid(ActiveMap.map_grid, zz);

Camera.ui.element_entity_pos_x.value_upper = xx - 1;
Camera.ui.element_entity_pos_y.value_upper = yy - 1;
Camera.ui.element_entity_pos_z.value_upper = zz - 1;