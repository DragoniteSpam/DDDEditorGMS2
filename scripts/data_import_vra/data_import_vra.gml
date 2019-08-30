/// @param filename

var buffer = buffer_load(argument[0]);

var data = ds_map_create();
ds_map_read(data, buffer_read_string(buffer));

var version = data[? "version"];
var grid_size = ds_map_exists(data, "grid_size") ? data[? "grid_size"] : 0;

ds_map_destroy(data);

var n = buffer_read(buffer, T);
var ui_list = Camera.ui.element_mesh_list;

repeat(n) {
    var mesh_name = buffer_read_string(buffer);
    var mesh = data_load_vra_next(buffer, grid_size, mesh_name);
	create_list_entries(ui_list, mesh, c_black);
}

ui_list.text = "Available meshes: " + string(ds_list_size(ui_list.entries));

buffer_delete(buffer);