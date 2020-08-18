/// @param n
/// @param min
/// @param max
/// @param [original-min]
/// @param [original-max]
function normalize() {
	gml_pragma("forceinline");
	var n = argument[0];
	var mn = argument[1];
	var mx = argument[2];
	var omin = (argument_count > 3) ? argument[3] : 0;
	var omax = (argument_count > 4) ? argument[4] : 1;
	if (mn == mx && mn == n) return mn;
	return omin + ((n - mn) / (mx - mn)) * (omax - omin);
}