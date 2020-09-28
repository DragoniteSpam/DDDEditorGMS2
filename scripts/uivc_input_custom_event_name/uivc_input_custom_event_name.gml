/// @param UIInput
function uivc_input_custom_event_name(argument0) {

    var input = argument0;

    input.root.event.name = input.value;
    input.root.changed = true;


}
