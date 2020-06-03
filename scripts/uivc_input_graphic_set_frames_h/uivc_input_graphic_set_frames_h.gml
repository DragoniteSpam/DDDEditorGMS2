/// @param UIInput

var input = argument0;
var list = input.root.el_list;
var selection = ui_list_selection(list);

if (selection + 1) {
    var image = list.entries[| selection];
    image.hframes = real(input.value);
    sprite_delete(image.picture_with_frames);
    var temp_name = PATH_TEMP + "particle_strip" + string(image.hframes) + ".png";
    sprite_save(image.picture, 0, temp_name);
    image.picture_with_frames = sprite_add(temp_name, image.hframes, false, false, 0, 0);
    sprite_set_speed(image.picture_with_frames, image.aspeed, spritespeed_framespersecond);
}