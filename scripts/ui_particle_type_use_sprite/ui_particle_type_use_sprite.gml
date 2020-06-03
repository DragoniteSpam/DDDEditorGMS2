/// @param UICheckbox

var checkbox = argument0;
var selection = ui_list_selection(checkbox.root.list);

if (selection + 1) {
    var type = Stuff.particle.types[| selection];
    type.sprite_custom = checkbox.value;
    if (checkbox.value) {
        
    } else {
        //part_type_shape(type.type, type.type_shapes[type.shape]);
    }
}