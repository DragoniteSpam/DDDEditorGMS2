/// @param text
/// @param width
/// @param height
/// @param root
/// @param [invisible?]

with (instance_create_depth(0, 0, 0, MenuMenu)) {
    text = argument[0];
    width = argument[1];
    height = argument[2];
    root = argument[3];
    invisible = (argument_count > 4) ? argument[4] : invisible;
    
    return id;
}