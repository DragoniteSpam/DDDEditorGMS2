/// @param UIInput
function uivc_entity_mesh_animation_speed(argument0) {

	var input = argument0;

	// this assumes that every selected entity is already an instance of Mesh
	var list = Stuff.map.selected_entities;

	for (var i = 0; i < ds_list_size(list); i++) {
	    list[| i].animation_speed = real(input.value);
	}


}
