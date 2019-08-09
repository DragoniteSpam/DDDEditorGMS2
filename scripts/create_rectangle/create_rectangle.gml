/// @param x
/// @param y
/// @param width
/// @param height
/// @param [color]
/// @param [outline]

with (instance_create_depth(argument[0], argument[1], 0, UIRectangle)) {
    x1 = argument[0];
    y1 = argument[1];
    x2 = x1 + argument[2];
    y2 = y1 + argument[3];
    color = (argument_count > 4) ? argument[4] : color;
    outline = (argument_count > 5) ? argument[5] : outline;
    
    return id;
}