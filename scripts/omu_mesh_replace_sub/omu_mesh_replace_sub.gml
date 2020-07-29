/// @param UIButton

var button = argument0;
var list = button.root.el_list;
var selection = ui_list_selection(list);
var fn = get_open_filename_mesh();
var mesh_data = button.root.mesh;

if (selection + 1) {
    // @todo try catch
    if (file_exists(fn)) {
        switch (filename_ext(fn)) {
            case ".obj": import_obj(fn, undefined, mesh_data, selection); break;
            case ".d3d": case ".gmmod": import_d3d(fn, undefined, false, mesh_data, selection); break;
            case ".smf": import_smf(fn, mesh_data, selection); break;
        }
    }
}

batch_again();