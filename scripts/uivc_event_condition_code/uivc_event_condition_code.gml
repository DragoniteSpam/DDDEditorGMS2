/// @param UIInputCode
function uivc_event_condition_code(argument0) {

    var input = argument0;

    if (validate_code(input.value)) {
        input.root.page.condition_code = input.value;
    }


}
