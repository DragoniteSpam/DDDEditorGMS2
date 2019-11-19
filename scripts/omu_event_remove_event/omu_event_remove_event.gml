/// @param UIButton

var button = argument0;
var index = ui_list_selection(button.root.el_event_list);

if (index + 1 && ds_list_size(Stuff.all_events) > index) {
    if (ds_list_size(Stuff.all_events) == 1) {
        dialog_create_notice(noone, "Can't delete the only event!");
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
    dialog_create_notice(noone, "select an event first!");
}