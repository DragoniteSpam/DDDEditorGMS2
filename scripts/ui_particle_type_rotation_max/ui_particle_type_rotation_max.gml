function ui_particle_type_rotation_max(bar) {
    var selection = ui_list_selection(bar.root.list);
    
    if (selection + 1) {
        var type = Stuff.particle.types[| selection];
        type.orientation_max = round(normalize(bar.value, 0, 360));
        part_type_orientation(type.type, type.orientation_min, type.orientation_max, type.orientation_incr, type.orientation_wiggle, type.orientation_relative);
    }
}