/// @param UIThing

var fn = get_open_filename("Image files (*.png)|*.png", "");

if (file_exists(fn)) {
    graphics_add_generic(fn, PREFIX_GRAPHIC_PARTICLE, button.root.el_list.entries);
}