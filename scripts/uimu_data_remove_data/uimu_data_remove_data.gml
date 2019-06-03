/// @description uimu_data_remove_data(UIThing);
/// @param UIThing

var data=guid_get(argument0.root.active_type_guid);
var selection=ui_list_selection(argument0.root.el_instances);

if (data!=noone&&selection!=noone) {
    // this list is never alphabetized so we don't have to account for that
    var instance=data.instances[| selection];
    instance_activate_object(instance);
    instance_destroy(instance);
    
    ds_list_delete(data.instances, selection);
    
    argument0.root.el_instances.index=max(--argument0.root.el_instances.index, 0);
    
    ui_list_deselect(argument0.root.el_instances);
    
    ui_init_game_data_refresh();
}
