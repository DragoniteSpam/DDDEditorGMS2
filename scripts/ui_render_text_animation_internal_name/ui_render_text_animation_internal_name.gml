/// @param UIText
/// @param x
/// @param y

var text = argument0;
var xx = argument1;
var yy = argument2;

var data = text.root.active_animation;
var selection = ui_list_selection(text.root.el_master);
var original_color = text.color;

if (selection >= 0) {
    var exists = internal_name_get(text.value);
    if (exists && exists != data) {
        text.color = c_red;
    }
}

ui_render_input(text, xx, yy);
text.color = original_color;