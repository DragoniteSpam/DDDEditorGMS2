/// @param x
/// @param y
/// @param text
function draw_tooltip() {

	// Origin is at the top-center of the box

	var xx = argument[0];
	var yy = argument[1];
	var text = argument[2];

	var offset = 4;
	var x1 = xx - string_width(text) / 2 - offset;
	var y1 = yy - offset;
	var x2 = xx + string_width(text) / 2 + offset;
	var y2 = yy + string_height(text) + offset;

	draw_rectangle_colour(x1, y1, x2, y2, c_white, c_white, c_white, c_white, false);
	draw_rectangle_colour(x1, y1, x2, y2, c_black, c_black, c_black, c_black, true);

	var halign = draw_get_halign();
	var valign = draw_get_valign();
	var font = draw_get_font();

	draw_set_halign(fa_center);
	draw_set_valign(fa_top);
	draw_set_font(FDefault12);

	draw_text_colour(xx, yy, text, c_black, c_black, c_black, c_black, 1);

	draw_set_halign(halign);
	draw_set_valign(valign);
	draw_set_font(font);


}
