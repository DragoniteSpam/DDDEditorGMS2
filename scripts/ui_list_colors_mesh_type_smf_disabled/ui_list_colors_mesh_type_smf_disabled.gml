/// @param UIList
/// @param index
function ui_list_colors_mesh_type_smf_disabled(argument0, argument1) {

	var list = argument0;
	var index = argument1;
	var mesh = Stuff.all_meshes[| index];

	return (mesh.type == MeshTypes.SMF) ? c_red : c_black;


}
