/// @param UIButton
function dmu_dialog_load_graphic_ui(argument0) {

    var button = argument0;
    var fn = get_open_filename_image();

    if (file_exists(fn)) {
        graphics_add_generic(fn, PREFIX_GRAPHIC_UI, button.root.el_list.entries);
    }


}
