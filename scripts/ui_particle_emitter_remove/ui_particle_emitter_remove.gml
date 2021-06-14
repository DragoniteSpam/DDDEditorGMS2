/// @param UIButton
function ui_particle_emitter_remove(argument0) {

    var button = argument0;
    var selection = ui_list_selection(button.root.list);

    if (selection + 1) {
        Stuff.particle.emitters[selection].Destroy();
        array_delete(Stuff.particle.emitters, selection, 1);
        ui_list_deselect(button.root.list);
    }


}
