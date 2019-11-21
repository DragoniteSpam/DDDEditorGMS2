/// @param x
/// @param y
/// @param text
/// @param width
/// @param height
/// @param onvaluechange
/// @param value
/// @param help-text
/// @param value-conversion
/// @param lower-bound
/// @param upper-bound
/// @param character-limit
/// @param vx1
/// @param vy1
/// @param vx2
/// @param vy2
/// @param root

with (instance_create_depth(argument[0], argument[1], 0, UIInput)) {
    text = argument[2];
    width = argument[3];
    height = argument[4];
    
    onvaluechange = argument[5];
    value = string(argument[6]);
    value_default = string(argument[7]);
    validation = argument[8];
    
    switch (validation) {
        case validate_code: value_conversion = ui_value_string; break;
        case validate_double: value_conversion = ui_value_real; break;
        case validate_hex: value_conversion = ui_value_string; break;
        case validate_int: value_conversion = ui_value_real; break;
        case validate_int_create_map_size: value_conversion = ui_value_real; break;
        case validate_int_map_size_x: value_conversion = ui_value_real; break;
        case validate_int_map_size_y: value_conversion = ui_value_real; break;
        case validate_int_map_size_z: value_conversion = ui_value_real; break;
        case validate_string: value_conversion = ui_value_string; break;
        case validate_string_event_name: value_conversion = ui_value_string; break;
        case validate_string_internal_name: value_conversion = ui_value_string; break;
    }
    
    value_lower = argument[9];
    value_upper = argument[10];
    value_limit = argument[11];
    
    value_x1 = argument[12];
    value_y1 = argument[13];
    value_x2 = argument[14];
    value_y2 = argument[15];
    
    root = argument[16];
    
    switch (validation) {
        case validate_double: case validate_int: real_value = true; break;
        default: real_value = false; break;
    }
    
    return id;
}
