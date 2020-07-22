/// @param fname
/// @param DataMesh
/// @param vertex-format-json

var base_filename = argument0;
var mesh_filename = filename_path(base_filename) + string_replace(filename_name(base_filename), filename_ext(base_filename), "");
var mesh = argument1;
var format = argument2;

if (format) {
    for (var i = 0; i < ds_list_size(mesh.submeshes); i++) {
        var sub = mesh.submeshes[| i];
        var fn = mesh_filename + "." + string_hex(i, 3) + filename_ext(base_filename);
        var formatted_buffer = buffer_create(1000, buffer_grow, 1);
        buffer_save(formatted_buffer, fn);
        buffer_delete(formatted_buffer);
    }
} else {
    for (var i = 0; i < ds_list_size(mesh.submeshes); i++) {
        var sub = mesh.submeshes[| i];
        var fn = mesh_filename + "." + string_hex(i, 3) + filename_ext(base_filename);
        buffer_save(sub.buffer, fn);
    }
}