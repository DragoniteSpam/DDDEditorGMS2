/// @param UIProgressBar
function ui_particle_type_rotation_min(argument0) {

	var bar = argument0;
	var selection = ui_list_selection(bar.root.list);

	if (selection + 1) {
	    var type = Stuff.particle.types[| selection];
	    type.orientation_min = round(normalize_correct(bar.value, 0, 360));
	    part_type_orientation(type.type, type.orientation_min, type.orientation_max, type.orientation_incr, type.orientation_wiggle, type.orientation_relative);
	}


}
