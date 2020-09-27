function ui_particle_type_direction_min_auto_360(button) {
    var selection = ui_list_selection(button.root.list);
    
    if (selection + 1) {
        var type = Stuff.particle.types[| selection];
        type.direction_min = 360;
        part_type_direction(type.type, type.direction_min, type.direction_max, type.direction_incr, type.direction_wiggle);
        ui_particle_type_select(button.root.list);
    }
}