/// @param UIInput
function ui_particle_emitter_rate(argument0) {

    var input = argument0;
    var selection = ui_list_selection(input.root.list);

    if (selection + 1) {
        var emitter = Stuff.particle.emitters[| selection];
        emitter.rate = real(input.value);
        if (emitter.type) {
            editor_particle_emitter_set_emission(emitter);
        }
    }


}
