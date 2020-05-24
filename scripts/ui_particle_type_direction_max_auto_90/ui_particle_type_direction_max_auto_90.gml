/// @param UIButton

var button = argument0;
var selection = ui_list_selection(button.root.list);

if (selection + 1) {
    var type = Stuff.particle.types[| selection];
    type.direction_max = 90;
    part_type_direction(type.type, type.direction_min, type.direction_max, type.direction_incr, type.direction_wiggle);
    ui_particle_type_select(button.root.list);
}