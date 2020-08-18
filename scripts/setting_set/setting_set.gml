/// @param object
/// @param name
/// @param value
function setting_set(argument0, argument1, argument2) {

	var object = argument0;
	var name = argument1;
	var value = argument2;

	var domain = Stuff.settings[? object];

	if (domain) {
	    domain[? name] = value;
	} else {
	    show_error("Setting object not found: " + object, false);
	}


}
