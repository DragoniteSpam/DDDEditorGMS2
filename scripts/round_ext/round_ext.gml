/// @param value
/// @param round-to
function round_ext(argument0, argument1) {

	var value = argument0;
	var to = argument1;

	return round(value / to) * to;


}
