/// @param UIInput
function omu_mesh_submesh_rename(argument0) {

	var input = argument0;
	var list = input.root.el_list;
	var selection = ui_list_selection(list);

	if (selection + 1) {
	    list.root.mesh.submeshes[| selection].name = input.value;
	}


}
