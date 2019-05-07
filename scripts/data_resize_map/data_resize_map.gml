/// @description  void data_resize_map(xx, yy, zz);
/// @param xx
/// @param  yy
/// @param  zz

ActiveMap.xx=argument0;
ActiveMap.yy=argument1;
ActiveMap.zz=argument2;

graphics_create_grid();

ds_grid_resize(ActiveMap.map_grid, argument0, argument1);
map_fill_grid(ActiveMap.map_grid, argument2);

Camera.ui.element_entity_pos_x.value_upper=argument0-1;
Camera.ui.element_entity_pos_y.value_upper=argument1-1;
Camera.ui.element_entity_pos_z.value_upper=argument2-1;
