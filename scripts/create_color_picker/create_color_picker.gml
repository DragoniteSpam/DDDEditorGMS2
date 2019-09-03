/// @param x
/// @param y
/// @param text
/// @param width
/// @param height
/// @param onvaluechange
/// @param key
/// @param value
/// @param value-x1
/// @param value-y1
/// @param value-x2
/// @param value-y2
/// @param root

with (instance_create_depth(argument[0], argument[1], 0, UIColorPicker)) {
    text = argument[2];
    width = argument[3];
    height = argument[4];
    
    onvaluechange = argument[5];
    key = argument[6];
    value = argument[7];
    
    value_x1 = argument[8];
    value_y1 = argument[9];
    value_x2 = argument[10];
    value_y2 = argument[11];
    
    root = argument[12];
	
    return id;
}
