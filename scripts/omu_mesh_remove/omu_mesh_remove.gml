/// @param UIThing
function omu_mesh_remove(argument0) {

	var thing = argument0;

	var data = Stuff.all_meshes[| Stuff.map.selection_fill_mesh];

	if (data) {
	    instance_activate_object(data);
	    instance_destroy(data);
	}


}
