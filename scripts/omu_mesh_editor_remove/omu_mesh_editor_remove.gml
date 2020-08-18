/// @param UIButton
function omu_mesh_editor_remove(argument0) {

	var button = argument0;
	var list = button.root.mesh_list;
	var selection = list.selected_entries;

	// because mesh deleting is spaghetti
	var to_delete = ds_list_create();

	for (var index = ds_map_find_first(selection); index != undefined; index = ds_map_find_next(selection, index)) {
	    ds_list_add(to_delete, Stuff.all_meshes[| index]);
	}

	for (var i = 0; i < ds_list_size(to_delete); i++) {
	    instance_activate_object(to_delete[| i]);
	    instance_destroy(to_delete[| i]);
	}

	ds_list_destroy(to_delete);
	ui_list_deselect(list);
	batch_again();


}
