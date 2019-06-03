/// @description list data_load_vra_names_only(filename);
/// @param filename

var buffer=buffer_load(argument[0]);
var names=ds_map_create();

var data=ds_map_create();
ds_map_read(data, buffer_read_string(buffer));

var version=data[? "version"];
if (ds_map_exists(data, "grid_size")) {
    var grid_size=data[? "grid_size"];
} else {
    var grid_size=0;
}

ds_map_destroy(data);

var n=buffer_read(buffer, T);

repeat(n) {
    ds_map_add(names, buffer_read_string(buffer), true);
    data_load_vra_skip(buffer, grid_size);
}

buffer_delete(buffer);

return names;
