/// @param UIButton

var button = argument0;
var selection = ui_list_selection(button.root.el_list_main);

if (selection + 1) {
    var event = Stuff.event.active;
    var prefab = Stuff.all_event_prefabs[| selection];
    
    var instantiated = event_create_node(event, prefab.type, undefined, undefined, prefab.custom_guid);
    // when the node is named normally the $number is appended before the event is added to the
    // list; in this case it's already in the list and you're renaming it, so the number you want
    // is length minus one
    event_rename(event, instantiated, prefab.name + "$" + string(ds_list_size(Stuff.event.active) - 1));
    instantiated.prefab_guid = prefab.GUID;
    ds_list_copy(instantiated.data, prefab.data);
    
    for (var i = 0; i < ds_list_size(instantiated.custom_data); i++) {
        ds_list_destroy(instantiated.custom_data[| i]);
    }
    
    ds_list_clear(instantiated.custom_data);
    
    for (var i = 0; i < ds_list_size(prefab.custom_data); i++) {
        ds_list_add(instantiated.custom_data, ds_list_clone(prefab.custom_data[| i]));
    }
}

dialog_destroy();