/// @param UIInput
function ui_particle_type_size_wiggle(argument0) {

    var input = argument0;
    var selection = ui_list_selection(input.root.list);

    if (selection + 1) {
        var type = Stuff.particle.types[selection];
        type.size_wiggle = real(input.value);
        part_type_size(type.type, type.size_min, type.size_max, type.size_incr, type.size_wiggle);
    }


}
