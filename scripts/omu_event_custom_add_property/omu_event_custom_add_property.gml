function omu_event_custom_add_property(thing) {
    var event = thing.root.event;
    
    array_push(event.types, new EventNodeProperty("Property" + string(array_length(event.types)), DataTypes.INT));
    
    // add the data to existing nodes
    for (var i = 0; i < array_length(Game.events.events); i++) {
        event = Game.events.events[i];
        for (var j = 0; j < array_length(event.nodes); j++) {
            if (event.nodes[j].custom_guid == thing.root.event.GUID) {
                array_push(event.nodes[j].custom_data, [0]);
            }
        }
    }
    
    // add the data to prefab nodes
    for (var i = 0; i < array_length(Game.events.prefabs); i++) {
        var prefab = Game.events.prefabs[i];
        if (prefab.custom_guid == thing.root.event.GUID) {
            array_push(event.nodes[i].custom_data, [0]);
        }
    }
}