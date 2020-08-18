/// @param Dialog
function dialog_create_manager_graphic_ui(argument0) {

	var dialog = argument0;

	var dw = 768;
	var dh = 512;

	var dg = dialog_create(dw, dh, "Data: Availalbe UI Graphics", dialog_default, dc_default, dialog);

	var columns = 3;
	var spacing = 16;
	var ew = dw / columns - spacing * 2;
	var eh = 24;

	var c2 = dw / columns;
	var c3 = dw * 2 / columns;

	var vx1 = 0;
	var vy1 = 0;
	var vx2 = ew;
	var vy2 = eh;

	var b_width = 128;
	var b_height = 32;

	var yy = 64;
	var yy_base = yy;

	var el_list = create_list(16, yy, "UI Graphics", "<no UI graphics>", ew, eh, 12, uivc_list_graphic_generic, false, dg, Stuff.all_graphic_ui);
	el_list.render_colors = ui_list_colors_image_exclude;
	el_list.entries_are = ListEntries.INSTANCES;
	el_list.numbered = true;
	dg.el_list = el_list;

	yy += ui_get_list_height(el_list) + spacing;

	var el_add = create_button(16, yy, "Add Image", ew, eh, fa_center, dmu_dialog_load_graphic_ui, dg);
	yy += el_add.height + spacing;

	var el_remove = create_button(16, yy, "Delete Image", ew, eh, fa_center, dmu_dialog_remove_graphic_ui, dg);

	yy = yy_base;

	var el_change = create_button(c2 + 16, yy, "Change Image", ew, eh, fa_center, dmu_dialog_change_graphic_general, dg);
	yy += el_change.height + spacing;

	var el_export = create_button(c2 + 16, yy, "Export Image", ew, eh, fa_center, dmu_dialog_export_graphic, dg);
	yy += el_export.height + spacing;

	var el_name_text = create_text(c2 + 16, yy, "Name:", ew, eh, fa_left, ew, dg);
	yy += el_name_text.height + spacing;

	var el_name = create_input(c2 + 16, yy, "", ew, eh, uivc_input_graphic_name, "", "", validate_string, 0, 1, VISIBLE_NAME_LENGTH, vx1, vy1, vx2, vy2, dg);
	dg.el_name = el_name;
	yy += el_name.height + spacing;
	var el_name_internal_text = create_text(c2 + 16, yy, "Internal Name:", ew, eh, fa_left, ew, dg);
	yy += el_name_internal_text.height + spacing;

	var el_name_internal = create_input(c2 + 16, yy, "", ew, eh, uivc_input_graphic_internal_name, "", "A-Za-z0-9_", validate_string_internal_name, 0, 1, INTERNAL_NAME_LENGTH, vx1, vy1, vx2, vy2, dg);
	dg.el_name_internal = el_name_internal;
	yy += el_name_internal.height + spacing;

	vx1 = ew / 2;

	// these are disabled here and they don't modify yy, but they're still added to the list
	// so that (1) they exist and can be accessed, if not do anything, and (b) will still be
	// cleaned up when the dialog is closed
	var el_frames_horizontal = create_input(c2 + 16, yy, "X frames:", ew, eh, uivc_input_graphic_set_frames_h, "1", "0...255", validate_int, 0, 255, 3, vx1, vy1, vx2, vy2, dg);
	el_frames_horizontal.enabled = false;
	dg.el_frames_horizontal = el_frames_horizontal;

	var el_frames_vertical = create_input(c2 + 16, yy, "Y frames:", ew, eh, uivc_input_graphic_set_frames_v, "1", "0...255", validate_int, 0, 255, 3, vx1, vy1, vx2, vy2, dg);
	el_frames_vertical.enabled = false;
	dg.el_frames_vertical = el_frames_vertical;

	var el_texture_exclude = create_checkbox(c2 + 16, yy, "Exclude from texture page?", ew, eh, uivc_input_graphic_texture_exclude, false, dg);
	el_texture_exclude.tooltip = "For optimization purposes the game may attempt to pack related sprites onto a single texture. In some cases you may wish for that to not happen.";
	dg.el_texture_exclude = el_texture_exclude;

	yy = yy_base;

	var el_image = create_image_button(c3 + 16, yy, "", -1, ew, ew, fa_center, dmu_dialog_show_big_picture, dg);
	el_image.draw_checker_behind = true;
	el_image.render = ui_render_image_button_graphic;
	el_image.interactive = false;
	dg.el_image = el_image;
	yy += el_image.height + spacing;

	var el_dimensions = create_text(c3 + 16, yy, "Dimensions:", ew, eh, fa_left, ew, dg);
	dg.el_dimensions = el_dimensions;
	yy += el_dimensions.height + spacing;

	var el_dim_x = create_input(c3 + 16, yy, "Width:", ew, eh, uivc_input_graphic_set_width, "", "int", validate_int, 1, 0xffff, 5, vx1, vy1, vx2, vy2, dg);
	dg.el_dim_x = el_dim_x;
	yy += el_dim_x.height + spacing;

	var el_dim_y = create_input(c3 + 16, yy, "Height:", ew, eh, uivc_input_graphic_set_height, "", "int", validate_int, 1, 0xffff, 5, vx1, vy1, vx2, vy2, dg);
	dg.el_dim_y = el_dim_y;
	yy += el_dim_y.height + spacing;

	var el_dim_set_crop = create_button(c3 + 16, yy, "Dimensions: Crop", ew, eh, fa_center, uivc_input_graphic_set_dim_crop, dg);
	yy += el_dim_set_crop.height + spacing;

	var el_dim_set_full = create_button(c3 + 16, yy, "Dimensions: Full", ew, eh, fa_center, uivc_input_graphic_set_dim_full, dg);
	yy += el_dim_set_full.height + spacing;

	dg.el_frame_speed = noone;

	var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);

	ds_list_add(dg.contents,
	    el_list,
	    el_add,
	    el_remove,
	    el_change,
	    el_export,
	    el_name_text,
	    el_name,
	    el_name_internal_text,
	    el_name_internal,
	    el_dimensions,
	    el_frames_horizontal,
	    el_frames_vertical,
	    el_texture_exclude,
	    el_image,
	    el_dim_x,
	    el_dim_y,
	    el_dim_set_crop,
	    el_dim_set_full,
	    el_confirm
	);

	return dg;


}
