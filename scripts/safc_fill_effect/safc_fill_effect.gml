/// @param x
/// @param y
/// @param z
/// @param params[]

var xx = argument0;
var yy = argument1;
var zz = argument2;
var params = argument3;

var cell = map_get_grid_cell(xx, yy, zz);
    
if (!cell[@ MapCellContents.EFFECT]) {
    var effect_list = Stuff.map.ui.t_p_other_editor.el_effect_type;
    var type = effect_list.object_types[ui_list_selection(effect_list)];
    var addition = instance_create_depth(0, 0, 0, type);
    
    if (addition) {
        map_add_thing(addition, xx, yy, zz);
    }
}