/// @param UIList
/// @param x
/// @param y

var list = argument0;
var xx = argument1;
var yy = argument2;

var list = Stuff.map.selected_entities;
var oldentries = list.entries;

if (ds_list_size(list) == 1) {
    list.entries = list[| 0].object_events;
} // else please don't add anything to the list

ui_render_list(list, xx, yy);

list.entries = oldentries;