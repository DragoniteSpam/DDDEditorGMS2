/// @param x
/// @param y
/// @param text
/// @param width
/// @param height
/// @param onvaluechange
/// @param key
/// @param value
/// @param help-text
/// @param validation
/// @param value-conversion
/// @param lower-bound
/// @param upper-bound
/// @param character-limit
/// @param value-x1
/// @param value-y1
/// @param value-x2
/// @param value-y2
/// @param root
/// @param [help]

with (instance_create_depth(argument[0], argument[1], 0, UIInput)) {
    text = argument[2];
    width = argument[3];
    height = argument[4];
    
    onvaluechange = argument[5];
    key = argument[6];
    value = string(argument[7]);
    value_default = string(argument[8]);
    validation = argument[9];
    value_conversion = argument[10];
    
    value_lower = argument[11];
    value_upper = argument[12];
    value_limit = argument[13];
    
    value_x1 = argument[14];
    value_y1 = argument[15];
    value_x2 = argument[16];
    value_y2 = argument[17];
    
    root = argument[18];
    help = (argument_count > 19) ? argument[19] : help;
    
    switch (validation) {
        case validate_double:
        case validate_int: real_value = true; break;
        default: real_value = false; break;
    }
    
    return id;
}
