/// @param UIButton
function ui_particle_type_gravity_direction_auto_180(argument0) {

    var button = argument0;
    var selection = ui_list_selection(button.root.list);

    if (selection + 1) {
        var type = Stuff.particle.types[| selection];
        type.gravity_direction = 180;
        part_type_gravity(type.type, type.gravity, type.gravity_direction);
        ui_particle_type_select(button.root.list);
    }


}
