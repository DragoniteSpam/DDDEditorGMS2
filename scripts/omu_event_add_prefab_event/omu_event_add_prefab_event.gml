/// @param UIButton

var button = argument0;
var selection = ui_list_selection(button.root.el_list_main);

if (selection + 1) {
    var prefab = Stuff.all_event_prefabs[| selection];
    
    var instantiated = event_create_node(Stuff.event.active, prefab.type, undefined, undefined, prefab.custom_guid);
    instantiated.prefab_guid = prefab.GUID;
    instantiated.name = prefab.name;
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