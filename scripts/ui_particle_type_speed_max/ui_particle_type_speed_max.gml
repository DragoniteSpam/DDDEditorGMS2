/// @param UIInput
function ui_particle_type_speed_max(argument0) {

	var input = argument0;
	var selection = ui_list_selection(input.root.list);

	if (selection + 1) {
	    var type = Stuff.particle.types[| selection];
	    type.speed_max = real(input.value);
	    part_type_speed(type.type, type.speed_min, type.speed_max, type.speed_incr, type.speed_wiggle);
	}


}
