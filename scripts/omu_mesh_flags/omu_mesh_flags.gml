/// @param UIButton

var button = argument0;

var data = Stuff.all_meshes[| Stuff.map.selection_fill_mesh];

if (data) {
    dialog_create_asset_flags(noone, data.name, data.flags, uivc_mesh_set_flags, data);
}