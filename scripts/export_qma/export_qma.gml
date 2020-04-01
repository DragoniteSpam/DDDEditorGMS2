/// @param fname

var fn = argument0;

var buffer = buffer_create(1024, buffer_grow, 1);

var data = ds_map_create();
data[? "version"] = 1;

buffer_write(buffer, buffer_string, json_encode(data));
ds_map_destroy(data);

var n_meshes = ds_list_size(Stuff.all_meshes);
var addr_count = buffer_tell(buffer);
buffer_write(buffer, buffer_u32, 0);

var count = 0;

var json = ds_map_create();

for (var i = 0; i < n_meshes; i++) {
    var mesh = Stuff.all_meshes[| i];
    for (var j = 0; j < ds_list_size(mesh.submeshes); j++) {
        var submesh = mesh.submeshes[| j];
        ds_map_clear(json);
        json[? "name"] = submesh.name;
        json[? "size"] = buffer_get_size(submesh.buffer);
        buffer_write(buffer, buffer_string, json_encode(json));
        buffer_write_buffer(buffer, submesh.buffer);
        
        count++;
    }
}

ds_map_destroy(json);

buffer_poke(buffer, addr_count, buffer_u32, count);

buffer_save_ext(buffer, fn, 0, buffer_tell(buffer));
buffer_delete(buffer);