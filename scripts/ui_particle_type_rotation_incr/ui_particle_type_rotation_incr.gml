/// @param UIInput
function ui_particle_type_rotation_incr(argument0) {

	var input = argument0;
	var selection = ui_list_selection(input.root.list);

	if (selection + 1) {
	    var type = Stuff.particle.types[| selection];
	    type.orientation_incr = real(input.value);
	    part_type_orientation(type.type, type.orientation_min, type.orientation_max, type.orientation_incr, type.orientation_wiggle, type.orientation_relative);
	}


}
