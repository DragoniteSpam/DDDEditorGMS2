/// @description void omu_event_remove_event(UIThing);
/// @param UIThing

var index=ui_list_selection(argument0.root.el_event_list);

if (index==noone) {
    show_message("select an event first!");
} else if (ds_list_size(Stuff.all_events)==1) {
    show_message("Can't delete the only event!");
} else {
    event=Stuff.all_events[| index];
    
    if (show_question("Delete "+event.name+"?")) {
        instance_activate_object(event);
        instance_destroy(event);
        ds_list_delete(Stuff.all_events, index);
        if (event==Stuff.active_event) {
            Stuff.active_event=Stuff.all_events[| 0];
        }
    }
}
