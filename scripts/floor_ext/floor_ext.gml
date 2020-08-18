/// @param value
/// @param round-to
function floor_ext(argument0, argument1) {

	var value = argument0;
	var to = argument1;

	return floor(value / to) * to;


}
