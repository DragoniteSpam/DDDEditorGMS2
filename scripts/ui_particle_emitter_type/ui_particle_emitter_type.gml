/// @param UIList
function ui_particle_emitter_type(argument0) {

    var list = argument0;
    var selected_type = ui_list_selection(list);
    var selection = ui_list_selection(list.root.list);

    if (selection + 1) {
        var emitter = Stuff.particle.emitters[| selection];
        editor_particle_emitter_set_region(emitter);
        if (selected_type + 1) {
            emitter.type = Stuff.particle.types[selected_type];
            editor_particle_emitter_set_emission(emitter);
        } else {
            emitter.type = noone;
            part_emitter_stream(Stuff.particle.system, emitter.emitter, -1, 0);
        }
    }


}
