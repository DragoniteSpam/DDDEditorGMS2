/// @param UIBitFieldOption
/// @param x
/// @param y
function ui_render_bitfield_option_picture(argument0, argument1, argument2) {

	var bitfield = argument0;
	var xx = argument1;
	var yy = argument2;

	// default button and interactivity
	ui_render_bitfield_option(bitfield, xx, yy);

	var x1 = bitfield.x + xx;
	var y1 = bitfield.y + yy;
	var x2 = x1 + bitfield.width;
	var y2 = y1 + bitfield.height;

	draw_sprite(bitfield.sprite_index, bitfield.image_index, mean(x1, x2), mean(y1, y2));


}
