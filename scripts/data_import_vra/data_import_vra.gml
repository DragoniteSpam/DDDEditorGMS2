/// @param filename

var buffer = buffer_load(argument[0]);

var data = ds_map_create();
ds_map_read(data, buffer_read_string(buffer));

var version = data[? "version"];
var grid_size = ds_map_exists(data, "grid_size") ? data[? "grid_size"] : 0;

ds_map_destroy(data);

var n = buffer_read(buffer, T);

repeat (n) {
    var mesh_name = buffer_read_string(buffer);
    var mesh = data_load_vra_next(buffer, grid_size, mesh_name);
    ds_list_add(Stuff.all_meshes, mesh);
}

buffer_delete(buffer);