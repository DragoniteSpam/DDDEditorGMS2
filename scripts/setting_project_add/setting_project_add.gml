/// @param name

var project_name = argument0;
if (ds_list_find_index(Stuff.all_projects[? "projects"], project_name) == -1) {
	ds_list_add(Stuff.all_projects[? "projects"], project_name);
}
	
var buffer = buffer_create(32, buffer_grow, 1);
buffer_write(buffer, buffer_text, json_encode(Stuff.all_projects));
buffer_save_ext(buffer, "projects.json", 0, buffer_tell(buffer));
buffer_delete(buffer);