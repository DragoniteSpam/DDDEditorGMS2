/// @param UIButton

var button = argument0;

var fn = get_open_filename_ddd();
if (file_exists(fn)) {
    serialize_load(fn, filename_name(filename_change_ext(fn, "")), true);
}

dialog_destroy();