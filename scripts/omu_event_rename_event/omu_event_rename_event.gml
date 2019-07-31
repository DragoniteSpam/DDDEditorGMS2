/// @param UIThing

var thing = argument0;

var event = Stuff.all_events[| ui_list_selection(thing.root.el_event_list)];
var new_name = get_string("New name for " + event.name + "? (Letters, digits, underscore and $ only, please.)", event.name);

if (validate_string_event_name(new_name)) {
    event.name = new_name;
}