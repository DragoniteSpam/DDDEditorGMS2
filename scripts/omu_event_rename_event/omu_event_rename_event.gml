/// @param UIThing

var thing = argument0;
var selection = ui_list_selection(thing.root.el_event_list);

if (selection + 1) {
    var event = Stuff.all_events[| selection];
    var new_name = get_string("New name for " + event.name + "?", event.name);
    if (string_length(new_name) > 0) {
        event.name = new_name;
    }
}