/// @param UIButton

var button = argument0;

var fn = get_open_filename_ddd();
if (file_exists(fn)) {
    if (serialize_load_base_old(fn, filename_name(filename_change_ext(fn, "")))) {
        dialog_destroy();
    } else if (serialize_load_base(fn, filename_name(filename_change_ext(fn, "")))) {
        dialog_destroy();
    } // else the files could not be loaded
    // un-register the mouse
    Controller.mouse_left = false;
    Controller.press_left = false;
    Controller.release_left = false;
    Controller.double_left = false;
    Controller.time_left = -1;
    Controller.last_time_left = -1;
    Controller.ignore_next = true;
}