/// @param UIColorPicker

var picker = argument0;
var selection = ui_list_selection(picker.root.list);

if (selection + 1) {
    var type = Stuff.particle.types[| selection];
    type.color_3 = picker.value & 0x00ffffff;
    type.alpha_3 = (picker.value >> 24) & 0xff;
}