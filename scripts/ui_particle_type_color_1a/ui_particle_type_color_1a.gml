/// @param UIColorPicker
function ui_particle_type_color_1a(argument0) {

    var picker = argument0;
    var selection = ui_list_selection(picker.root.list);

    if (selection + 1) {
        var type = Stuff.particle.types[selection];
        type.color_1a = picker.value;
        type.alpha_1 = picker.alpha;
        editor_particle_type_set_color(type);
    }


}
