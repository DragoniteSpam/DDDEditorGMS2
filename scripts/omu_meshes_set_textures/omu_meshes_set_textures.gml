/// @param UIButton

var button = argument0;

if (ds_map_empty(button.root.mesh_list.selected_entries)) return;

dialog_create_mesh_material_settings(button, button.root.mesh_list.selected_entries);