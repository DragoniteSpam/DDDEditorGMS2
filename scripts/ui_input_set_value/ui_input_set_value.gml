function ui_input_set_value(input, value) {
    // because keyboard_string also needs to be set
    input.value = value;
    
    if (ui_is_active(input)) {
        keyboard_string = value;
    }
}