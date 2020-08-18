/// @param original
/// @param value
function colour_replace_red(argument0, argument1) {

	var original = argument0;
	var value = argument1;

	return value | (original & 0xffff00);


}
