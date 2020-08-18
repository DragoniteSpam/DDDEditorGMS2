/// @param value
/// @param render
/// @param onvaluechange
/// @param text
/// @param sprite
/// @param image-index
/// @param half-width
/// @param half-height
/// @param [xx]
/// @param [yy]
/// @param [color-active]
/// @param [color-inactive]
function create_bitfield_option_data() {

	var value = argument[0];
	var render = argument[1];
	var onvaluechange = argument[2];
	var text = argument[3];
	var sprite = argument[4];
	var index = argument[5];
	var width = argument[6];
	var height = argument[7];
	var xx = (argument_count > 8) ? argument[8] : 0;
	var yy = (argument_count > 9) ? argument[9] : 0;
	var color_active = (argument_count > 10) ? argument[10] : c_ui_active_bitfield;
	var color_inactive = (argument_count > 11) ? argument[11] : c_white;

	// @gml update lightweight objects
	return [value, render, onvaluechange, text, sprite, index, width, height, xx, yy, color_active, color_inactive];


}
