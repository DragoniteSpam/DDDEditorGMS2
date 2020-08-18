/// @param x1
/// @param y1
/// @param x2
/// @param y2
/// @param adjust?
function mouse_within_rectangle_determine() {

	var x1 = argument[0];
	var y1 = argument[1];
	var x2 = argument[2];
	var y2 = argument[3];
	var adjust = argument[4];

	return adjust ? mouse_within_rectangle_adjusted(x1, y1, x2, y2) : mouse_within_rectangle_view(x1, y1, x2, y2);


}
