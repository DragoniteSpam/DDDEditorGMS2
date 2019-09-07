/// @param UIThing

var thing = argument0;

var data = guid_get(thing.root.active_type_guid);
var selection = ui_list_selection(thing.root.el_instances);
ui_list_deselect(thing.root.el_instances);

if (data && selection) {
    // this list is never alphabetized so we don't have to account for that
    var instance = data.instances[| selection];
    instance_activate_object(instance);
    instance_destroy(instance);
    
    ds_list_delete(data.instances, selection);
    
    ui_init_game_data_refresh();
}