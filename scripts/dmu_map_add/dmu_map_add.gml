/// @param UIButton

var button = argument0;

// automatically pushed onto the list
var map = instance_create_depth(0, 0, 0, DataMapContainer);

map.xx = real(button.root.el_x.value);
map.yy = real(button.root.el_y.value);
map.zz = real(button.root.el_z.value);
map.on_grid = button.root.el_grid.value;

script_execute(button.root.commit, button.root);