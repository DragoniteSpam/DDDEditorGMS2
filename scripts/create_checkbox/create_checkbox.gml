/// @param x
/// @param y
/// @param text
/// @param width
/// @param height
/// @param onvaluechange
/// @param key
/// @param default
/// @param root

with (instance_create_depth(argument[0], argument[1], 0, UICheckbox)) {
    text = argument[2];
    width = argument[3];
    height = argument[4];
    
    onvaluechange = argument[5];
    key = argument[6];
    value = argument[7];
    
    root = argument[8];
    
    return id;
}