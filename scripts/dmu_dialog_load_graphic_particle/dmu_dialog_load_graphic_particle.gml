/// @param UIButton

var button = argument0;
var fn = get_open_filename_image();

if (file_exists(fn)) {
    var image = graphics_add_generic(fn, PREFIX_GRAPHIC_PARTICLE, button.root.el_list.entries);
    image.picture_with_frames = sprite_duplicate(image.picture);
}