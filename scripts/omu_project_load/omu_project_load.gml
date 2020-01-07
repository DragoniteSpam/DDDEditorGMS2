/// @param UIButton

var button = argument0;

var selected_project = ui_list_selection(button.root.el_list);

if (selected_project + 1) {
    var name = button.root.el_list.entries[| selected_project];
    var path_new = PATH_PROJECTS + name + "\\" + name + ".dddd";
    var path_old = PATH_PROJECTS + name + "\\auto.dddd", name;
    if (file_exists(path_old)) {
        if (serialize_load_base_old(path_old, name)) {
            dialog_destroy();
        } // else the files could not be loaded
    } else {
        if (serialize_load_base(path_new, name)) {
            dialog_destroy();
        } // else the files could not be loaded
    }
}