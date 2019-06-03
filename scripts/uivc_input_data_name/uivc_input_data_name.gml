/// @description uivc_input_data_name(UIThing);
/// @param UIThing

if (script_execute(argument0.validation, argument0.value)) {
    argument0.root.selected_data.name=argument0.value;
    
    argument0.root.changed=true;
}
