function ui_particle_type_gravity_direction_auto_0(button) {
    var selection = ui_list_selection(button.root.list);
    
    if (selection + 1) {
        var type = Stuff.particle.types[selection];
        type.gravity_direction = 0;
        part_type_gravity(type.type, type.gravity, type.gravity_direction);
        ui_particle_type_select(button.root.list);
    }
}