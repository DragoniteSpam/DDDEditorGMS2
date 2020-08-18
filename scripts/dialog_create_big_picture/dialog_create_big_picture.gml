/// @param root
/// @param picture
function dialog_create_big_picture() {
	// if the order of these parameters seems a little weird, it's because all of
	// the required ones have to go at the beginning and the optional ones at the end

	var picture = argument[1];

	var xpadding = 64;
	var ypadding = 128;
	var dw = clamp(sprite_get_width(picture), 192, 960) + xpadding;
	var dh = clamp(sprite_get_height(picture), 192, 960) + ypadding;

	var dg = dialog_create(dw, dh, "Picture", dialog_default, dc_default, argument[0]);

	var b_width = 128;
	var b_height = 32;

	var el_picture = create_image_button(xpadding / 2, ypadding / 2, "", picture, dw - xpadding, dh - ypadding, fa_center, null, dg);
	el_picture.draw_checker_behind = true;
	el_picture.interactive = false;
	var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Okay", b_width, b_height, fa_center, dmu_dialog_commit, dg);

	ds_list_add(dg.contents, el_picture, el_confirm);

	return dg;


}
