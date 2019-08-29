/// @param filename
// this must be run inside of object Stuff. if you call it anywhere else
// in the code, use with (Stuff), otherwise bad things will happen.

vra_name = filename_name(argument0);

var buffer = buffer_load(argument[0]);

var conflicts_output = file_text_open_write("conflicts.txt");
var conflicts_identified = false;

var data = ds_map_create();
ds_map_read(data, buffer_read_string(buffer));

var version = data[? "version"];
var grid_size = ds_map_exists(data, "grid_size") ? data[? "grid_size"] : 0;

ds_map_destroy(data);

var n = buffer_read(buffer, T);

repeat(n) {
    var model_name = buffer_read_string(buffer);
    var stuff = data_load_vra_next(buffer, grid_size);
    this script should now work with a DataMesh object instead of just an array of values - EVERYTHING
    else has not been touched yet
}

buffer_delete(buffer);

// update ui mesh list

var n = ds_list_size(all_mesh_names);
var ui_list = Camera.ui.element_mesh_list;
ui_list_clear(ui_list);
ui_list.text = "Available meshes: " + string(n);
for (var i = 0; i < n; i++) {
    create_list_entries(ui_list, all_mesh_names[| i], c_black);
}

file_text_close(conflicts_output);

if (conflicts_identified) {
    create_notification(vra_name + " contained naming conflicts. Go to Data > View Mesh Conflicts to see the list.");
}