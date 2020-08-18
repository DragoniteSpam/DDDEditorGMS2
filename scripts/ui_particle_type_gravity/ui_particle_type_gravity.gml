/// @param UIInput
function ui_particle_type_gravity(argument0) {

	var input = argument0;
	var selection = ui_list_selection(input.root.list);

	if (selection + 1) {
	    var type = Stuff.particle.types[| selection];
	    type.gravity = real(input.value);
	    part_type_gravity(type.type, type.gravity, type.gravity_direction);
	}


}
