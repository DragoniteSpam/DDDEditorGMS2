/// @param UIImageButton
/// @param x
/// @param y

var button = argument0;
var xx = argument1;
var yy = argument2;

button.image = noone;
var index = ui_list_selection(button.root.el_list);

if (index + 1) {
    if (index) {
        // the first entry in the list is a special value for "none"
        var data = Stuff.all_graphic_autotiles[| index - 1];
        if (is_array(data)) {
            button.image = data[AvailableAutotileProperties.PICTURE];
        }
    }
}

ui_render_image_button(button, xx, yy);