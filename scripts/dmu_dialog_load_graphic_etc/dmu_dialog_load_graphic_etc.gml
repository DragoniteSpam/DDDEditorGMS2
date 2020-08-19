/// @param UIButton
function dmu_dialog_load_graphic_etc(argument0) {

    var button = argument0;
    var fn = get_open_filename_image();

    if (file_exists(fn)) {
        graphics_add_generic(fn, PREFIX_GRAPHIC_ETC, button.root.el_list.entries);
    }


}
