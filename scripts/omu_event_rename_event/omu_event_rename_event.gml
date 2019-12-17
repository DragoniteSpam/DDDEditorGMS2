/// @param UIThing

var thing = argument0;
var event = Stuff.all_events;
var node = event[| ui_list_selection(thing.root.el_event_list)];

if (!Stuff.event.canvas_active_node) {
    var new_name = get_string("New name for " + node.name + "? (Letters, digits, underscore and $ only, please.)", node.name);
    event_rename(event, node, new_name);
}