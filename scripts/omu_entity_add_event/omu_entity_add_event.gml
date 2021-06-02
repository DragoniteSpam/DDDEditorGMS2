function omu_entity_add_event(thing) {
    var list = Stuff.map.selected_entities;
    
    if (!ds_list_empty(list)) {
        var event_list = list[| 0].object_events;
        
        if (array_length(event_list) < 10) {
            array_push(event_list, create_instantiated_event("Event Page " + string(array_length(list[| 0].object_events))));
        } else {
            // if this becomes a problem I'll increase the limit, but I doubt it's going to become a problem
            emu_dialog_notice("Not allowed to have more than ten of these at a time. Sorry!");
        }
    }
}