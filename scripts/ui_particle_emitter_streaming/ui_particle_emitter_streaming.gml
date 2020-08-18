/// @param UICheckbox
function ui_particle_emitter_streaming(argument0) {

	var checkbox = argument0;
	var selection = ui_list_selection(checkbox.root.list);

	if (selection + 1) {
	    var emitter = Stuff.particle.emitters[| selection];
	    emitter.streaming = checkbox.value;
	    if (emitter.type) {
	        editor_particle_emitter_set_region(emitter);
	        editor_particle_emitter_set_emission(emitter);
	    }
	}


}
