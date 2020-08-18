/// @param event
function dialog_create_event_rename(argument0) {

	var event = argument0;

	var dw = 400;
	var dh = 200;

	var dg = dialog_create(dw, dh, "Rename Event", dialog_default, undefined, noone);
	dg.event = event;

	var columns = 1;
	var spacing = 16;
	var ew = dw / columns - spacing * 2;
	var eh = 24;

	var col1_x = dw * 0 / 3 + spacing;

	var vx1 = ew / 2;
	var vy1 = 0;
	var vx2 = ew;
	var vy2 = eh;

	var b_width = 128;
	var b_height = 32;

	var yy = 64;
	var yy_base = yy;

	var el_input = create_input(col1_x, yy, "Name:", ew, eh, uivc_event_attain_name, event.name, "", validate_string, 0, 1, VISIBLE_NAME_LENGTH, vx1, vy1, vx2, vy2, dg);
	yy += el_input.height;

	var el_confirm = create_button(dw / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dc_default, dg, fa_center);

	ds_list_add(dg.contents,
	    el_input,
	    el_confirm,
	);

	return dg;


}
