/// @param UIButton

var button = argument0;

var fn = get_open_filename_ddd();
if (file_exists(fn)) {
    if (serialize_load_base(fn, filename_name(filename_change_ext(fn, "")))) {
        dialog_destroy();
    } // else the files could not be loaded
}