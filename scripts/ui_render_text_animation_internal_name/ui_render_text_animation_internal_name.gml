/// @param UIText
/// @param x
/// @param y

// data types stored in different places need different internal name render scripts

var text = argument0;
var xx = argument1;
var yy = argument2;

var data = text.root.root.root.active_animation;
var selection = ui_list_selection(text.root.root.root.el_master);
var original_color = text.color;

if (selection >= 0) {
    var exists = internal_name_get(text.value);
    if (exists && exists != data) {
        text.color = c_red;
    }
}

ui_render_input(text, xx, yy);
text.color = original_color;