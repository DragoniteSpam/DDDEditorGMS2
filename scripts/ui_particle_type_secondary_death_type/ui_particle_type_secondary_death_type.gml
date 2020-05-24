/// @param UIList

var list = argument0;
var selection = ui_list_selection(list);

if (selection + 1) {
    var type = list.root.type;
    type.death_type = Stuff.particle.types[| selection];
    part_type_death(type.type, type.death_rate, type.death_type.type);
}