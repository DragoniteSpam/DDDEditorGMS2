/// @param string
/// @param UIInput
function validate_string_event_name() {

	var str = argument[0];
	var input = (argument_count > 1) ? argument[1] : noone;

	if (!string_length(str)) {
	    return false;
	}

	if (!regex("[A-Za-z0-9_\+\$]+", str)) {
	    return false;
	}

	if (input) {
	    var node = input.root.node;
	    if (node.event.name_map[? str] && node.event.name_map[? str] != node) {
	        return false;
	    }
	}

	return true;


}
