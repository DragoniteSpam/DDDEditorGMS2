/// @param x
/// @param y
/// @param text
/// @param width
/// @param height
/// @param halignment
/// @param wrap-width
/// @param root
/// @param [help]

with (instance_create_depth(argument[0], argument[1], 0, UIText)) {
    text = argument[2];
    width = argument[3];
    height = argument[4];

    alignment = argument[5];
    wrap_width = argument[6];
    root = argument[7];
    
    help = (argument_count > 8) ? argument[8] : help;
    
    return id;
}