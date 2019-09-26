/// @param UIInput

var input = argument0;

var selection = ui_list_selection(input.root.el_list);
var property = input.root.event.types[| selection];
property[@ EventNodeCustomData.NAME] = input.value;
input.root.changed = true;
    
// this should work without this because of the accessor but
// just because pass by reference in game maker sucks
input.root.event.types[| selection] = property;