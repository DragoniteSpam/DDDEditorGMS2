/// @param UIThing

var datadata = argument0.root.selected_data;

if (ds_list_size(datadata.properties) < 1000) {
    var property = instance_create_depth(0, 0, 0, DataProperty);
    property.name = "Property" + string(ds_list_size(datadata.properties));
    ds_list_add(datadata.properties, property);
    ds_map_clear(argument0.root.el_list_p.selected_entries);
    instance_deactivate_object(property);
    argument0.root.selected_property = noone;
    
    argument0.root.changed = true;
    
    dialog_data_type_disable(argument0.root);
    
    argument0.root.el_data_name.interactive = true;
    argument0.root.el_add_p.interactive = true;
    argument0.root.el_remove_p.interactive = true;
} else {
    dialog_create_notice(argument0.root, "Please don't try to create more than a thousand properties on a single data type. Bad things will happen.", "Hey!");
}