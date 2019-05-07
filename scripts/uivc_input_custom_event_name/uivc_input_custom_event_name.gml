/// @description  uivc_input_custom_event_name(UIThing);
/// @param UIThing

if (script_execute(argument0.validation, argument0.value)){
    argument0.root.event.name=argument0.value;
    
    argument0.root.changed=true;
}
