/// @param original
/// @param value
function colour_replace_green(argument0, argument1) {

	var original = argument0;
	var value = argument1;

	return (value << 8) | (original & 0xff00ff);


}
