/// @param UIInput
function uivc_input_graphic_set_frame_speed(argument0) {

    var input = argument0;
    var list = input.root.el_list;
    var selection = ui_list_selection(list);

    if (selection + 1) {
        var image = list.entries[| selection];
        image.aspeed = real(input.value);
        sprite_set_speed(image.picture_with_frames, image.aspeed, spritespeed_framespersecond);
    }


}
