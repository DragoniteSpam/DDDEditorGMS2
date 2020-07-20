/// @param UIButton

var button = argument0;
var selection = button.root.selection;
var type = button.root.el_type.value;

var folder = get_save_filename("", "save everything here");
if (folder == "") return;

folder = filename_path(folder);
for (var index = ds_map_find_first(selection); index != undefined; index = ds_map_find_next(selection, index)) {
    var mesh = Stuff.all_meshes[| index];
    switch (type) {
        case 0: export_d3d(folder + mesh.name + ".d3d", mesh); break;
        case 1: export_obj(folder + mesh.name + ".obj", mesh); wtf(mesh.name); break;
        case 2: 
    }
}

dialog_destroy();