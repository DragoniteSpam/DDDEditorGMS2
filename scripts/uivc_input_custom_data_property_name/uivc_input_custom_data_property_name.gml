/// @param UIThing

var selection = ui_list_selection(argument0.root.el_list);
var property = argument0.root.event.types[| selection];
property[@ EventNodeCustomData.NAME] = argument0.value;
argument0.root.changed = true;
    
// this should work without this because of the accessor but
// just because pass by reference in game maker sucks
argument0.root.event.types[| selection] = property;