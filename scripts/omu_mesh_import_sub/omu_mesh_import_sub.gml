/// @param UIButton

var button = argument0;
var adjust = !keyboard_check(vk_control);
var fn = get_open_filename_mesh();
var mesh_data = button.root.mesh;

// @todo try catch
if (file_exists(fn)) {
    switch (filename_ext(fn)) {
        case ".obj": import_obj(fn, undefined, adjust, mesh_data); break;
        case ".d3d": case ".gmmod": import_d3d(fn, undefined, adjust, false, mesh_data); break;
        case ".vrax": import_vrax(fn, false, mesh_data); break;
        case ".smf": import_smf(fn, mesh_data); break;
    }
    
    var list = button.root.el_list;
    ui_list_clear(list);
    for (var i = 0; i < ds_list_size(mesh_data.buffers); i++) {
        create_list_entries(list, "[" + string(i) + "]");
    }
}