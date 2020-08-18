/// @param RadioArray
/// @param x
/// @param y
function ui_render_radio_array(argument0, argument1, argument2) {

	var array = argument0;
	var xx = argument1;
	var yy = argument2;

	var x1 = array.x + xx;
	var y1 = array.y + yy;
	var x2 = x1 + array.width;
	var y2 = y1 + array.height * (1 + ds_list_size(array.contents));

	var tx = ui_get_text_x(array, x1, x2);
	var ty = ui_get_text_y(array, y1, y1 + array.height);

	if (array.outline) {
	    draw_rectangle_colour(x1, y1, x2, y2, c_black, c_black, c_black, c_black, true);
	}

	draw_set_halign(array.alignment);
	draw_set_valign(array.valignment);
	draw_set_color(array.color);
	draw_text(tx, ty, string(array.text));

	for (var i = 0; i < ds_list_size(array.contents); i++) {
	    var thing = array.contents[| i];
	    // these are all part of the same UIThing so there's no point in turning them off
	    script_execute(thing.render, thing, x1, y1);
	}

	ui_handle_dropped_files(array);


}
