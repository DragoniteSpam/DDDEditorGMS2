/// @param name
/// @param home-row
/// @param root
function create_tab() {

	with (instance_create_depth(0, 0, 0, UITab)) {
	    text = argument[0];
	    home_row = argument[1];
    
	    root = argument[2];
    
	    return id;
	}


}
