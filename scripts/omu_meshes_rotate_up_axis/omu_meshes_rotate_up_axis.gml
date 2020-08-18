/// @param UIButton
function omu_meshes_rotate_up_axis(argument0) {

	var button = argument0;
	var list = button.root.mesh_list;
	var selection = list.selected_entries;

	for (var index = ds_map_find_first(selection); index != undefined; index = ds_map_find_next(selection, index)) {
	    var mesh = Stuff.all_meshes[| index];
	    mesh_rotate_all_up_axis(mesh);
	}

	batch_again();


}
