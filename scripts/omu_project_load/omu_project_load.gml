/// @param UIButton

var button = argument0;

var selected_project = ui_list_selection(button.root.el_list);

if (selected_project + 1) {
	var name = button.root.el_list.entries[| selected_project];
	serialize_load(PATH_PROJECTS + name + "\\auto.dddd");
	Stuff.save_name = name;
	dialog_destroy();
}