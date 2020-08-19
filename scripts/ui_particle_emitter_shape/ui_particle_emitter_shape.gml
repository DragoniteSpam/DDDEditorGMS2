/// @param UIRadioArray
function ui_particle_emitter_shape(argument0) {

    var radio = argument0;
    var selection = ui_list_selection(radio.root.root.list);

    if (selection + 1) {
        var emitter = Stuff.particle.emitters[| selection];
        emitter.region_shape = radio.value;
        var shape = emitter.emitter_shapes[emitter.region_shape];
        var distribution = emitter.emitter_distributions[emitter.region_distribution];
        part_emitter_region(Stuff.particle.system, emitter.emitter, emitter.region_x1, emitter.region_x2, emitter.region_y1, emitter.region_y2, shape, distribution);
        editor_particle_emitter_create_region(emitter);
    }


}
