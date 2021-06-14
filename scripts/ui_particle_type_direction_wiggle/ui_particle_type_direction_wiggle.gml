/// @param UIInput
function ui_particle_type_direction_wiggle(argument0) {

    var input = argument0;
    var selection = ui_list_selection(input.root.list);

    if (selection + 1) {
        var type = Stuff.particle.types[selection];
        type.direction_wiggle = real(input.value);
        part_type_direction(type.type, type.direction_min, type.direction_max, type.direction_incr, type.direction_wiggle);
    }


}
