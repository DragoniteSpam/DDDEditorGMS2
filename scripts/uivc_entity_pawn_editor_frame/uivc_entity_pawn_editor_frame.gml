/// @param UIThing
function uivc_entity_pawn_editor_frame(argument0) {

	var thing = argument0;

	// this assumes that every selected entity is already an instance of Pawn
	var list = Stuff.map.selected_entities;

	var conversion = real(thing.value);
	for (var i = 0; i < ds_list_size(list); i++) {
	    list[| i].frame = conversion;
	}


}
