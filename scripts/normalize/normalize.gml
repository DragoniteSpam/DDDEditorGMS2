/// @param n
/// @param min
/// @param max
/// @param [original-min]
/// @param [original-max]
function normalize() {

	gml_pragma("forceinline");

	// I strongly suspect this is broken, but it's used in a bunch of places
	// in the code so i dont want to touch it. Use normalize_correct if you
	// need a version that does what you think it does.

	var n = argument[0];
	var mn = argument[1];
	var mx = argument[2];
	var omin = (argument_count > 3) ? argument[3] : 0;
	var omax = (argument_count > 4) ? argument[4] : 1;

	if (mn == mx) {
	    return mn;
	}

	return omin + ((n - mn) / (mx - mn)) * (omax - omin);


}
