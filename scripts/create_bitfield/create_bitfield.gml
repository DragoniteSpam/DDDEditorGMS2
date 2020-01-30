/// @param x
/// @param y
/// @param text
/// @param width
/// @param height
/// @param default
/// @param root

with (instance_create_depth(argument[0], argument[1], 0, UIBitField)) {
    text = argument[2];
    width = argument[3];
    height = argument[4];
    value = argument[5];
    root = argument[6];
    
    return id;
}