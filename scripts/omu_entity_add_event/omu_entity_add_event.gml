/// @param UIThing
function omu_entity_add_event(argument0) {

    var thing = argument0;

    var list = Stuff.map.selected_entities;

    if (!ds_list_empty(list)) {
        var event_list = list[| 0].object_events;
    
        if (ds_list_size(event_list) < 10) {
            ds_list_add(event_list, create_instantiated_event("Event Page " + string(ds_list_size(list[| 0].object_events))));
        } else {
            // if this becomes a problem I'll increase the limit, but I doubt it's going to become a problem
            dialog_create_notice(noone, "Not allowed to have more than ten of these at a time. Sorry!");
        }
    }


}
