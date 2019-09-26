/// @param UIList
/// @param x
/// @param y

var list = argument0;
var xx = argument1;
var yy = argument2;

var oldentries = list.entries;
list.entries = Stuff.all_event_triggers;
list.colorize = false;

ui_render_list(list, xx, yy);

// no memory leak, although the list isn't used
list.entries = oldentries;