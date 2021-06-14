/// @param UIButton
function omu_event_add_prefab_event(argument0) {

    var button = argument0;
    var selection = ui_list_selection(button.root.el_list_main);

    if (selection + 1) {
        var event = Stuff.event.active;
        var prefab = Game.events.prefabs[selection];
    
        var instantiated = event_create_node(event, prefab.type, undefined, undefined, prefab.custom_guid);
        // when the node is named normally the $number is appended before the event is added to the
        // list; in this case it's already in the list and you're renaming it, so the number you want
        // is length minus one
        event_rename_node(event, instantiated, prefab.name + "$" + string(array_length(Stuff.event.active.nodes) - 1));
        instantiated.prefab_guid = prefab.GUID;
        instantiated.data = array_clone(prefab.data);
        
        instantiated.custom_data = [];
    
        for (var i = 0; i < array_length(prefab.custom_data); i++) {
            array_push(instantiated.custom_data, array_clone(prefab.custom_data[i]));
        }
    }

    dialog_destroy();


}
