/// @param x
/// @param y
/// @param z
/// @param params[]

var xx = argument0;
var yy = argument1;
var zz = argument2;
var params = argument3;

var effect_list = Stuff.map.ui.t_p_other_editor.el_effect_type;
var type = effect_list.object_types[ui_list_selection(effect_list)];
var addition = instance_create_depth(0, 0, 0, type);
addition.light_x = (xx + 0.5) * TILE_WIDTH;
addition.light_y = (yy + 0.5) * TILE_HEIGHT;
addition.light_z = (zz + 0.5) * TILE_DEPTH;
map_add_thing(addition, 0, 0, 0);