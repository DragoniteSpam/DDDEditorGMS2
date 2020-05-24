/// @param UICheckbox

var checkbox = argument0;
var selection = ui_list_selection(checkbox.root.list);

if (selection + 1) {
    var type = Stuff.particle.types[| selection];
    type.base_color_2_enabled = checkbox.value;
}