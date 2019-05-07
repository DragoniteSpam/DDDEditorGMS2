/// @description  void omu_data_add(UIThing);
/// @param UIThing

if (ds_list_size(Stuff.all_data)<1000){
    instance_deactivate_object(instantiate(DataData));
    ds_map_clear(argument0.root.el_list_main.selected_entries);
    argument0.root.selected_data=noone;
    argument0.root.selected_property=noone;
    
    argument0.root.changed=true;
    
    dialog_data_type_disable(argument0.root);
} else {
    dialog_create_notice(argument0.root, "Please don't try to create more than a thousand generic data types. Bad things will happen.", "Hey!");
}
