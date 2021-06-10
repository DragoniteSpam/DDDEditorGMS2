function omu_event_custom_add_property(thing) {
    var event = thing.root.event;
    
    if (ds_list_size(event.types) < 255) {
        var data = ["Property" + string(ds_list_size(event.types)), DataTypes.INT, 0, 1, false, 0, null, null];
        ds_list_add(event.types, data);
        
        // add the data to existing nodes
        for (var i = 0; i < ds_list_size(Game.evenst); i++) {
            event = Game.evenst[| i];
            for (var j = 0; j < ds_list_size(event.nodes); j++) {
                if (event.nodes[| j].custom_guid == thing.root.event.GUID) {
                    array_push(event.nodes[| j].custom_data, [0]);
                }
            }
        }
        
        // add the data to prefab nodes
        for (var i = 0; i < ds_list_size(Stuff.all_event_prefabs); i++) {
            var prefab = Stuff.all_event_prefabs[| i];
            if (prefab.custom_guid == thing.root.event.GUID) {
                array_push(event.nodes[| i].custom_data, [0]);
            }
        }
    } else {
        emu_dialog_notice("Please don't try to create more properties for a custom event type than can fit in an unsigned byte. Bad things will happen. Why do you even want that many?");
    }
}