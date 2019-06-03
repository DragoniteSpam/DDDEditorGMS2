/// @description void ui_render_list_event(UIList, x, y);
/// @param UIList
/// @param x
/// @param y

var oldentries=argument0.entries;
argument0.entries=Stuff.all_events;
argument0.colorize=false;

ui_render_list(argument0, argument1, argument2);

// no memory leak, although the list isn't used
argument0.entries=oldentries;
