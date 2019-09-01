/// @param UIText
/// @param x
/// @param y

var text = argument0;
var xx = argument1;
var yy = argument2;

var data = Stuff.all_meshes[| Camera.selection_fill_mesh];

if (data) {
    text.text = data.xmax;
}

ui_render_text(text, xx, yy);