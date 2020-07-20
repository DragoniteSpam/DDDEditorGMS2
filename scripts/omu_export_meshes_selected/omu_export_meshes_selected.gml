/// @param UIButton

var button = argument0;
var list = button.root.mesh_list;
var selection = list.selected_entries;

if (ds_map_size(selection) == 0) {
    return;
}

if (ds_map_size(selection) == 1) {
    var index = ui_list_selection(list);
    var mesh = Stuff.all_meshes[| index];
    var fn = get_save_filename_mesh(mesh.name);
    if (fn == "") return;
    
    switch (filename_ext(fn)) {
        case ".obj": export_obj(fn, mesh); break;
        case ".d3d": case ".gmmod": export_d3d(fn, mesh); break;
    }
    return;
}

var folder = get_save_filename("", "save everything here");
if (folder == "") return;

folder = filename_path(folder);
for (var index = ds_map_find_first(selection); index != undefined; index = ds_map_find_next(selection, index)) {
    var mesh = Stuff.all_meshes[| index];
    export_d3d(folder + mesh.name + ".d3d", mesh);
}