/// @param number
function number_max_digits(argument0) {

	var number = argument0;

	return log10(max(1, abs(number))) + 1 + ((number < 0) ? 1 : 0);


}
