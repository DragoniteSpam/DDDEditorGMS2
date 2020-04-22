/// @param UIThing

var thing = argument0;
var selection = ui_list_selection(thing.root.el_event_list);

if (selection + 1) {
    dialog_create_event_node_rename(Stuff.all_events[| selection]);
}