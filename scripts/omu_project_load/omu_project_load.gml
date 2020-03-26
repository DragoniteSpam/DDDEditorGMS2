/// @param UIButton

var button = argument0;

var selected_project = ui_list_selection(button.root.el_list);

if (selected_project + 1) {
    var name = button.root.el_list.entries[| selected_project];
    var path_new = PATH_PROJECTS + name + "\\" + name + ".dddd";
    if (serialize_load_base(path_new, name)) {
        dialog_destroy();
    } // else the files could not be loaded
    // un-register the mouse
    Controller.mouse_left = false;
    Controller.press_left = false;
    Controller.release_left = false;
    Controller.double_left = false;
    Controller.time_left = -1;
    Controller.last_time_left = -1;
    Controller.ignore_next = 1;
}