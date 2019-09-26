/// @param x
/// @param y
/// @param width
/// @param height
/// @param onvaluechange
/// @param key
/// @param value
/// @param allow-alpha?
/// @param value-x1
/// @param value-y1
/// @param value-x2
/// @param value-y2
/// @param root
/// @param [text]

// there's a bunch more positioning properties you can mess with;
// i expect them to be required less often than these though, so they can
// only be set through the dot operator
with (instance_create_depth(argument[0], argument[1], 0, UIColorPickerInput)) {
    width = argument[2];
    height = argument[3];
    
    onvaluechange = argument[4];
    key = argument[5];
    value = argument[6];
    allow_alpha = argument[7];
    
    value_x1 = argument[8];
    value_y1 = argument[9];
    value_x2 = argument[10];
    value_y2 = argument[11];
    
    root = argument[12];
    text = (argument_count > 13) ? argument[13] : text;
	
	value_text = string_hex(colour_reverse(value), 6);
	
    return id;
}