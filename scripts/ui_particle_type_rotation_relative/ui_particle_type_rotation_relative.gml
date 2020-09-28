/// @param UICheckbox
function ui_particle_type_rotation_relative(argument0) {

    var checkbox = argument0;
    var selection = ui_list_selection(checkbox.root.list);

    if (selection + 1) {
        var type = Stuff.particle.types[| selection];
        type.orientation_relative = checkbox.value;
        part_type_orientation(type.type, type.orientation_min, type.orientation_max, type.orientation_incr, type.orientation_wiggle, type.orientation_relative);
    }


}
