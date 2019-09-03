/// @param x
/// @param y
/// @param text
/// @param width
/// @param height
/// @param onvaluechange
/// @param default
/// @param root

with (instance_create_depth(argument[0], argument[1], 0, UIRadioArray)) {
    text = argument[2];
    width = argument[3];
    height = argument[4];
    
    onvaluechange = argument[5];
    value = argument[6];
    
    root = argument[7];
    
    return id;
}