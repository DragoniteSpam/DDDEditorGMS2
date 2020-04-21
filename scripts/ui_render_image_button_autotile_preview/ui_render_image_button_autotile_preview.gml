/// @param UIImageButton
/// @param x
/// @param y

var button = argument0;
var xx = argument1;
var yy = argument2;

button.image = noone;
var index = ui_list_selection(button.root.el_list);

if (index + 1) {
    button.image = Stuff.all_graphic_tile_animations[| index].picture;
}

ui_render_image_button(button, xx, yy);