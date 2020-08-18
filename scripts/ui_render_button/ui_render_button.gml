/// @param UIButton
/// @param x
/// @param y
function ui_render_button(argument0, argument1, argument2) {

	var button = argument0;
	var xx = argument1;
	var yy = argument2;

	var x1 = button.x + xx;
	var y1 = button.y + yy;
	var x2 = x1 + button.width;
	var y2 = y1 + button.height;

	var tx = ui_get_text_x(button, x1, x2);
	var ty = ui_get_text_y(button, y1, y2);

	ui_render_button_general(
	    x1, y1, x2, y2, tx, ty, button.text, button.alignment, button.valignment, button.color,
	    button.interactive && dialog_is_active(button.root), button.onmouseup, button
	);

	ui_handle_dropped_files(button);


}
