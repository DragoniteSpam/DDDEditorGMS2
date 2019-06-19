/// @param x
/// @param y
/// @param width
/// @param height
/// @param thickness
/// @param progress
/// @param root
/// @param [help]

with (instance_create_depth(argument[0], argument[1], 0, UIProgressBar)) {
    width = argument[2];
    height = argument[3];
    thickness = argument[4];
    progress = argument[5];
    
    root = argument[6];
    
    switch (argument_count) {
        case 8:
            help = argument[7];
            break;
    }
    
    return id;
}