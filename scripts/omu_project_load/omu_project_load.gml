/// @param UIButton

var button = argument0;

var selected_project = ui_list_selection(button.root.el_list);

if (selected_project + 1) {
    var name = button.root.el_list.entries[| selected_project];
    if (serialize_load_base(PATH_PROJECTS + name + "\\auto.dddd", name)) {
        dialog_destroy();
    } // else the files could not be loaded
}