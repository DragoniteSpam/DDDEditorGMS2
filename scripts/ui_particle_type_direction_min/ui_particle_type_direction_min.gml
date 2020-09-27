function ui_particle_type_direction_min(bar) {
    var selection = ui_list_selection(bar.root.list);
    
    if (selection + 1) {
        var type = Stuff.particle.types[| selection];
        type.direction_min = round(bar.value * 360);
        part_type_direction(type.type, type.direction_min, type.direction_max, type.direction_incr, type.direction_wiggle);
    }
}