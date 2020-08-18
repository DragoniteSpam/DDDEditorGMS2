/// @param original
/// @param value
function colour_replace_blue(argument0, argument1) {

	var original = argument0;
	var value = argument1;

	return (value << 16) | (original & 0x00ffff);


}
