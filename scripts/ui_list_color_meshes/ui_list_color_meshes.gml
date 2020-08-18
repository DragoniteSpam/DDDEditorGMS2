/// @param UIList
/// @param index
function ui_list_color_meshes(argument0, argument1) {

	var list = argument0;
	var index = argument1;

	var mesh = list.entries[| index];

	switch (mesh.type) {
	    case MeshTypes.RAW: return c_black;
	    case MeshTypes.SMF: return c_blue;
	}


}
