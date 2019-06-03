/// @description void ui_render_image_button_autotile(UIImageButton, x, y);
/// @param UIImageButton
/// @param x
/// @param y

argument0.image=noone;
var index=get_active_tileset().autotiles[Camera.selection_fill_autotile];

if (index!=noone) {
    var data=Stuff.available_autotiles[index];
    if (is_array(data)) {
        argument0.image=data[AvailableAutotileProperties.PICTURE];
    }
}

ui_render_image_button(argument0, argument1, argument2);
