/// @param UIList
/// @param x
/// @param y

// You can't just pass a single list for the entries because it'll change depending on the
// current active map, but it also doesn't need the very complicated plate of spaghetti 
// that i had before

var list = argument0;
var xx = argument1;
var yy = argument2;

list.entries = Stuff.active_map.contents.all_entities;

ui_render_list(list, xx, yy);