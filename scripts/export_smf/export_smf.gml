/// @param fname
/// @param DataMesh
function export_smf(argument0, argument1) {

    var base_filename = argument0;
    var mesh_filename = filename_path(base_filename) + string_replace(filename_name(base_filename), filename_ext(base_filename), "");
    var mesh = argument1;

    for (var i = 0; i < ds_list_size(mesh.submeshes); i++) {
        var number_ext = (ds_list_size(mesh.submeshes) == 1) ? "" : ("!" + string_hex(i, 3));
        var sub = mesh.submeshes[| i];
        var fn = mesh_filename + number_ext + filename_ext(base_filename);
        buffer_save(sub.buffer, fn);
    }


}
