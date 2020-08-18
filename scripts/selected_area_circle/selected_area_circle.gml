/// @param SelectionCircle
function selected_area_circle(argument0) {
	// volume can be zero if it's just a flat plane, but area can't

	var selection = argument0;

	return selection.radius * selection.radius * pi;


}
