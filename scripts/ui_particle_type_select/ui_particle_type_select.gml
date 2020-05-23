/// @param UIList

var list = argument0;
var selection = ui_list_selection(list);

if (selection + 1) {
    var type = Stuff.particle.types[| selection];
    ui_input_set_value(list.root.name, type.name);
}