/// @param UICheckbox
function ui_particle_emitter_draw_region(argument0) {

    var checkbox = argument0;
    var selection = ui_list_selection(checkbox.root.list);

    if (selection + 1) {
        var emitter = Stuff.particle.emitters[selection];
        emitter.draw_region = checkbox.value;
    }


}
