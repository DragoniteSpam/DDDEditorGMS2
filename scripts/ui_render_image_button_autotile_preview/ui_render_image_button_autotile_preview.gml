/// @param UIImageButton
/// @param x
/// @param y

argument0.image = noone;
var index = ui_list_selection(argument0.root.el_list);

if (index) {
    if (index > 0) {
        // the first entry in the list is a special value for "none"
        var data = Stuff.all_graphic_autotiles[index - 1];
        if (is_array(data)) {
            argument0.image = data[AvailableAutotileProperties.PICTURE];
        }
    }
}

ui_render_image_button(argument0, argument1, argument2);