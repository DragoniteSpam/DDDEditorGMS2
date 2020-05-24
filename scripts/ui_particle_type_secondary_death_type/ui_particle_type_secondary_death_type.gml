/// @param UIList

var list = argument0;
var selection = ui_list_selection(list);
var type = list.root.type;

if (selection + 1) {
    type.death_type = Stuff.particle.types[| selection];
    part_type_death(type.type, type.death_rate, type.death_type.type);
} else {
    type.death_type = noone;
    part_type_death(type.type, 0, -1);
}