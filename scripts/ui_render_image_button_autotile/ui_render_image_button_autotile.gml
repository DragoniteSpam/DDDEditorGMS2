/// @param UIImageButton
/// @param x
/// @param y

var button = argument0;
var xx = argument1;
var yy = argument2;

button.image = noone;
var data = guid_get(get_active_tileset().autotiles[Stuff.map.selection_fill_autotile]);

if (data) {
    button.image = data.picture;
}

ui_render_image_button(button, xx, yy);