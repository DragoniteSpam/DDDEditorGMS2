/// @param UIThing
function omu_event_custom_add_property(argument0) {

    var thing = argument0;
    var event = thing.root.event;

    if (ds_list_size(event.types) < 255) {
        var data = ["Property" + string(ds_list_size(event.types)), DataTypes.INT, 0, 1, false, 0, null, null];
        ds_list_add(event.types, data);
    
        // add the data to existing nodes
        for (var i = 0; i < ds_list_size(Stuff.all_events); i++) {
            var event = Stuff.all_events[| i];
            for (var j = 0; j < ds_list_size(event.nodes); j++) {
                if (event.nodes[| j].custom_guid == thing.root.event.GUID) {
                    var data = ds_list_create();
                    ds_list_add(data, 0);
                    ds_list_add(event.nodes[| j].custom_data, data);
                }
            }
        }
    
        // add the data to prefab nodes
        for (var i = 0; i < ds_list_size(Stuff.all_event_prefabs); i++) {
            var prefab = Stuff.all_event_prefabs[| i];
            if (prefab.custom_guid == thing.root.event.GUID) {
                var data = ds_list_create();
                ds_list_add(data, 0);
                ds_list_add(event.nodes[| j].custom_data, data);
            }
        }
    } else {
        dialog_create_notice(thing.root, "Please don't try to create more properties for a custom event type than can fit in an unsigned byte. Bad things will happen. Why do you even want that many?", "Hey!");
    }


}
