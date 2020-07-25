/// @param UIButton

var button = argument0;
var list = button.root.mesh_list;
var selection = list.selected_entries;
var format_index = ui_list_selection(button.root.format_list);
var format = (format_index + 1) ? Stuff.mesh_ed.formats[| format_index] : undefined;

var export_count = ds_map_size(selection);

if (export_count == 0) return;

if (export_count == 1) {
    var index = ui_list_selection(list);
    var mesh = Stuff.all_meshes[| index];
    switch (mesh.type) {
        case MeshTypes.RAW:
            var fn = get_save_filename_mesh(mesh.name);
            if (fn == "") return;
            switch (filename_ext(fn)) {
                case ".obj": export_obj(fn, mesh, false); break;
                case ".d3d": case ".gmmod": export_d3d(fn, mesh); break;
                case ".vbuff": export_vb(fn, mesh, format); break;
            }
            return;
        case MeshTypes.SMF:
            var fn = get_save_filename_mesh(mesh.name, "SMF files|*.smf");
            if (fn == "") return;
            export_smf(fn, mesh);
            return;
    }
}

var folder = get_save_filename_mesh("save everything here", "");
if (folder == "") return;
folder = filename_path(folder);

for (var index = ds_map_find_first(selection); index != undefined; index = ds_map_find_next(selection, index)) {
    var mesh = Stuff.all_meshes[| index];
    switch (mesh.type) {
        case MeshTypes.RAW:
            switch (Stuff.mesh_ed.export_type) {
                case 0: export_d3d(folder + mesh.name + ".d3d", mesh); break;
                case 1: export_obj(folder + mesh.name + ".obj", mesh, false); break;
                case 2: export_vb(folder + mesh.name + ".vbuff", mesh, format); break;
            }
            break;
        case MeshTypes.SMF:
            export_smf(folder + mesh.name + ".smf", mesh);
            break;
    }
}