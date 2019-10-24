/// @param UIImageButton
/// @param x
/// @param y

var button = argument0;
var xx = argument1;
var yy = argument2;

button.image = noone;
var index = get_active_tileset().autotiles[Camera.selection_fill_autotile];

if (index) {
    var data = Stuff.all_graphic_autotiles[| index];
    if (is_array(data)) {
        button.image = data[AvailableAutotileProperties.PICTURE];
    }
}

ui_render_image_button(button, xx, yy);