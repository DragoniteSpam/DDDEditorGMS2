/// @param UIButton

var button = argument0;
var fn = get_open_filename_image();

if (file_exists(fn)) {
    var data = graphics_add_generic(fn, PREFIX_GRAPHIC_OVERWORLD, button.root.el_list.entries);
    data.hframes = 4;
    data.vframes = 4;
}