/// @param UIText
/// @param x
/// @param y

var text = argument0;
var xx = argument1;
var yy = argument2;

var data = guid_get(Stuff.data.ui.active_type_guid);
var selection = ui_list_selection(Stuff.data.ui.el_instances);
var original_color = text.color;

if (selection + 1) {
    var exists = internal_name_get(text.value);
    if (exists && exists != data.instances[| selection]) {
        text.color = c_red;
    }
}

ui_render_input(text, xx, yy);
text.color = original_color;