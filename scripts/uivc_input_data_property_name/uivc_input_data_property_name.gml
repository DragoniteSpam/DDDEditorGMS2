/// @description uivc_input_data_property_name(UIThing);
/// @param UIThing

if (script_execute(argument0.validation, argument0.value)) {
    argument0.root.selected_property.name=argument0.value;
    
    argument0.root.changed=true;
}
