/// @param UIList

var list = argument0;
var selection = ui_list_selection(list);
var type = list.root.type;

if (selection + 1) {
    type.update_type = Stuff.particle.types[| selection];
    part_type_step(type.type, type.update_rate * Stuff.dt, type.update_type.type);
} else {
    type.update_type = noone;
    part_type_step(type.type, 0, -1);
}