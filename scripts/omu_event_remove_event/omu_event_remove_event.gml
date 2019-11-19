/// @param UIButton

var button = argument0;
var index = ui_list_selection(button.root.el_event_list);

if (index + 1) {
    if (ds_list_size(Stuff.all_events) == 1) {
        show_message("Can't delete the only event!");
    } else {
        var event = Stuff.all_events[| index];
        
        if (show_question("Delete " + event.name + "?")) {
            instance_activate_object(event);
            instance_destroy(event);
            ds_list_delete(Stuff.all_events, index);
            if (event == Stuff.event.active) {
                Stuff.event.active = Stuff.all_events[| 0];
            }
        }
    }
} else {
    show_message("select an event first!");
}