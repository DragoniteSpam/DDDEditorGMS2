/// @param UICheckbox
function ui_particle_type_color_1b_enabled(argument0) {

    var checkbox = argument0;
    var selection = ui_list_selection(checkbox.root.list);

    if (selection + 1) {
        var type = Stuff.particle.types[| selection];
        type.color_1b_enabled = checkbox.value;
        editor_particle_type_set_color(type);
    }


}
