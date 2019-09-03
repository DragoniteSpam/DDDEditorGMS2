/// @param x
/// @param y
/// @param width
/// @param height
/// @param onvaluechange
/// @param onvaluechangebackwards
/// @param root

with (instance_create_depth(argument[0], argument[1], 0, UITileSelector)) {
    width = argument[2];
    height = argument[3];
    
    onvaluechange = argument[4];
    onvaluechangebackwards = argument[5];
    root = argument[6];
    
    return id;
}