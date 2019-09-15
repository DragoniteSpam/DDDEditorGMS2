/// @param x
/// @param y
/// @param width
/// @param height
/// @param render
/// @param control
/// @param root

with (instance_create_depth(argument[0], argument[1], 0, UIRenderSurface)) {
    width = argument[2];
    height = argument[3];
	
	surface_resize(surface, width, height);
	
	script_render = argument[4];
	script_control = argument[5];
    root = argument[6];
    
    return id;
}