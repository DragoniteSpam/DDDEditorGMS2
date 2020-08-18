/// @param x
/// @param y
/// @param width
/// @param height
/// @param render
/// @param control
/// @param base-color
/// @param root
function create_render_surface(argument0, argument1, argument2, argument3, argument4, argument5, argument6, argument7) {

	with (instance_create_depth(argument0, argument1, 0, UIRenderSurface)) {
	    width = argument2;
	    height = argument3;
    
	    script_render = argument4;
	    script_control = argument5;
	    var base_color = argument6;
	    root = argument7;
    
	    surface_resize(surface, width, height);
	    surface_set_target(surface);
	    draw_clear(base_color);
	    surface_reset_target();
    
	    return id;
	}


}
