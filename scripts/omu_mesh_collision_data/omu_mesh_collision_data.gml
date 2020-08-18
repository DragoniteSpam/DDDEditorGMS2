/// @param UIButton
function omu_mesh_collision_data(argument0) {

	var button = argument0;

	var data = Stuff.all_meshes[| Stuff.map.selection_fill_mesh];

	if (data) {
	    dialog_create_mesh_collision_data(noone, data);
	}


}
