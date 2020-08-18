/// @param UIButton
function omu_project_remove_confirm(argument0) {

	var button = argument0;
	var project = button.root.project;

	var list = Stuff.all_projects[? "projects"];
	var name = list[| project];
	ds_list_delete(list, project);
	ui_list_deselect(button.root.root.root.el_list);

	directory_destroy(PATH_PROJECTS + name);

	var buffer = buffer_create(32, buffer_grow, 1);
	buffer_write(buffer, buffer_text, json_encode(Stuff.all_projects));
	buffer_save_ext(buffer, "projects.json", 0, buffer_tell(buffer));
	buffer_delete(buffer);

	dialog_destroy();


}
