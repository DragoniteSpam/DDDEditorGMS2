/// @param UIInput

var input = argument0;
var selection = ui_list_selection(input.root.list);

if (selection + 1) {
    var type = Stuff.particle.types[| selection];
    type.xscale = real(input.value);
    part_type_scale(type.type, type.xscale, type.yscale);
}