/// @param UICheckbox

var checkbox = argument0;

var selection = ui_list_selection(checkbox.root.el_list);

var property = checkbox.root.event.types[| selection];
property[@ EventNodeCustomData.REQUIRED] = checkbox.value;

// this should work without this because of the accessor but
// just because pass by reference in game maker sucks
checkbox.root.event.types[| selection] = property;