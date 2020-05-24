/// @param UIList

var list = argument0;
var selection = ui_list_selection(list);

if (selection + 1) {
    var type = list.root.type;
    type.update_type = Stuff.particle.types[| selection];
    part_type_step(type.type, type.update_rate * Stuff.dt, type.update_type.type);
}