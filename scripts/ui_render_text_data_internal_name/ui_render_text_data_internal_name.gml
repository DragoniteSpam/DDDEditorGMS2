/// @param UIText
/// @param x
/// @param y

var data = guid_get(Camera.ui_game_data.active_type_guid);
var selection = ui_list_selection(Camera.ui_game_data.el_instances);
var original_color = argument0.color;

if (selection >= 0) {
    var exists = internal_name_get(argument0.value);
    if (exists != data.instances[| selection]) {
        if (exists != noone) {
            argument0.color = c_red;
        }
    }
}

ui_render_input(argument0, argument1, argument2);
argument0.color = original_color;