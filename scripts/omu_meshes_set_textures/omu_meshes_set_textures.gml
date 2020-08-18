/// @param UIButton
function omu_meshes_set_textures(argument0) {

	var button = argument0;

	if (ds_map_empty(button.root.mesh_list.selected_entries)) return;

	dialog_create_mesh_material_settings(button, button.root.mesh_list.selected_entries);


}
