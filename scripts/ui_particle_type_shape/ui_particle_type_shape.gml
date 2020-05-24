/// @param UIList

var list = argument0;
var shape_selection = ui_list_selection(list);
var selection = ui_list_selection(list.root.list);

if (selection + 1 && shape_selection + 1) {
    var type = Stuff.particle.types[| selection];
    type.shape = shape_selection;
    part_type_shape(type.type, type.type_shapes[type.shape]);
}