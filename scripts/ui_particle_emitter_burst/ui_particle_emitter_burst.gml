/// @param UIButton
function ui_particle_emitter_burst(argument0) {

	var button = argument0;
	var selection = ui_list_selection(button.root.list);

	if (selection + 1) {
	    var emitter = Stuff.particle.emitters[| selection];
	    if (emitter.type) {
	        editor_particle_emitter_set_region(emitter);
	        part_emitter_burst(Stuff.particle.system, emitter.emitter, emitter.type.type, emitter.rate * Stuff.dt);
	    }
	}


}
