/// @param UIButton

var button = argument0;
var list = button.root.mesh_list;
var selection = list.selected_entries;
var format_index = ui_list_selection(button.root.format_list);
var format = (format_index + 1) ? Stuff.mesh_ed.formats[| format_index] : undefined;

var export_count = ds_map_size(selection);
if (export_count == 0) return;

if (export_count == 1) {
    var mesh = Stuff.all_meshes[| ds_map_find_first(selection)];
    var fn = get_save_filename_mesh(mesh.name);
} else {
    var fn = get_save_filename_mesh("save everything here");
}

if (fn == "") return;
var folder = filename_path(fn);

for (var index = ds_map_find_first(selection); index != undefined; index = ds_map_find_next(selection, index)) {
    var mesh = Stuff.all_meshes[| index];
    var name = ((export_count == 1) ? fn : (folder + mesh.name)) + filename_ext(fn);
    switch (mesh.type) {
        case MeshTypes.RAW:
            switch (filename_ext(fn)) {
                case ".obj": export_obj(name, mesh, false); break;
                case ".d3d": case ".gmmod": export_d3d(name, mesh); break;
                case ".vbuff": export_vb(name, mesh, format); break;
            }
            break;
        case MeshTypes.SMF:
            export_smf(name, mesh);
            break;
    }
}