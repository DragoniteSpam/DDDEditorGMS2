/// @param UIInput
function ui_particle_type_scale_y(argument0) {

	var input = argument0;
	var selection = ui_list_selection(input.root.list);

	if (selection + 1) {
	    var type = Stuff.particle.types[| selection];
	    type.yscale = real(input.value);
	    part_type_scale(type.type, type.xscale, type.yscale);
	}


}
