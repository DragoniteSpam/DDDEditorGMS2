/// @param UIInput
function uivc_input_data_default_code(argument0) {

    var input = argument0;

    // @todo else make it red or something
    if (validate_code(input.value, input)) {
        input.root.selected_property.default_code = input.value;
    }


}
