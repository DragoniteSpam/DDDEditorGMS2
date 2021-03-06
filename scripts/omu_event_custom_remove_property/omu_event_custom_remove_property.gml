/// @param UIThing
function omu_event_custom_remove_property(argument0) {

    var thing = argument0;
    var selection = ui_list_selection(thing.root.el_list);

    ds_list_delete(thing.root.event.types, selection);
    ui_list_clear(thing.root.el_list);

    // delete the data from existing nodes
    for (var i = 0; i < ds_list_size(Stuff.all_events); i++) {
        var event = Stuff.all_events[| i];
        for (var j = 0; j < ds_list_size(event.nodes); j++) {
            if (event.nodes[| j].custom_guid == thing.root.event.GUID) {
                ds_list_destroy(event.nodes[| j].custom_data[| selection]);
                ds_list_delete(event.nodes[| j].custom_data, selection);
            }
        }
    }

    // delete the data from prefab nodes
    for (var i = 0; i < ds_list_size(Stuff.all_event_prefabs); i++) {
        var prefab = Stuff.all_event_prefabs[| i];
        if (prefab.custom_guid == thing.root.event.GUID) {
            ds_list_destroy(prefab.custom_data[| selection]);
            ds_list_delete(prefab.custom_data, selection);
        }
    }


}
