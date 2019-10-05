/// @param UIButton

var button = argument0;

var selected_project = ui_list_selection(button.root.el_list);

if (selected_project + 1) {
	serialize_load(PATH_PROJECTS + button.root.el_list.entries[| selected_project] + "\\auto.dddd");
	dialog_destroy();
}