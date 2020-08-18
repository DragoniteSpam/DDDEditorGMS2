/// @param value
/// @param round-to
function ceil_ext(argument0, argument1) {

	var value = argument0;
	var to = argument1;

	return ceil(value / to) * to;


}
