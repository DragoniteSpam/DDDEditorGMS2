/// @param UIInput
function uivc_event_attain_name(argument0) {

    var input = argument0;

    if (string_length(input.value) > 0) {
        input.root.event.name = input.value;
    }


}
