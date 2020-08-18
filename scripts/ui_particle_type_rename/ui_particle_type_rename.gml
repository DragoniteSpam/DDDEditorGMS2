/// @param UIInput
function ui_particle_type_rename(argument0) {

	var input = argument0;
	var selection = ui_list_selection(input.root.list);

	if (selection + 1) {
	    var type = Stuff.particle.types[| selection];
	    type.name = input.value;
	}


}
