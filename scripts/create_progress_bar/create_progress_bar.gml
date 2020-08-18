/// @param x
/// @param y
/// @param width
/// @param height
/// @param onvaluechange
/// @param thickness
/// @param value
/// @param root
function create_progress_bar() {

	with (instance_create_depth(argument[0], argument[1], 0, UIProgressBar)) {
	    width = argument[2];
	    height = argument[3];
	    onvaluechange = argument[4];
	    thickness = argument[5];
	    value = argument[6];
    
	    root = argument[7];
    
	    return id;
	}


}
