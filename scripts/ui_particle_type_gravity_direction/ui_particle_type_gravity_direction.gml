/// @param UIProgressBar
function ui_particle_type_gravity_direction(argument0) {

	var bar = argument0;
	var selection = ui_list_selection(bar.root.list);

	if (selection + 1) {
	    var type = Stuff.particle.types[| selection];
	    type.gravity_direction = round(normalize_correct(bar.value, 0, 360));
	    part_type_gravity(type.type, type.gravity, type.gravity_direction);
	}


}
