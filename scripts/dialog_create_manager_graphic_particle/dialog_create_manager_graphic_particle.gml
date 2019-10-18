/// @param Dialog

var dialog = argument0;

var dw = 768;
var dh = 480;

var dg = dialog_create(dw, dh, "Data: Availalbe Particle Graphics", dialog_default, dc_default, dialog);

var columns = 3;
var ew = (dw - 64) / columns;
var eh = 24;

var c2 = dw / columns;
var c3 = dw * 2 / columns;

var vx1 = 0;
var vy1 = 0;
var vx2 = ew;
var vy2 = vy1 + eh;

var b_width = 128;
var b_height = 32;

var yy = 64;
var yy_base = yy;
var spacing = 16;

var el_list = create_list(16, yy, "Particle Graphics", "<no particle graphics>", ew, eh, 12, uivc_list_graphic_generic, false, dg, Stuff.all_graphic_particles);
el_list.entries_are = ListEntries.INSTANCES;
el_list.numbered = true;
dg.el_list = el_list;

var el_add = create_button(c2 + 16, yy, "Add Particle", ew, eh, fa_center, dmu_dialog_load_graphic_particle, dg);
yy = yy + el_add.height + spacing;
var el_remove = create_button(c2 + 16, yy, "Remove Particle", ew, eh, fa_center, dmu_dialog_remove_graphic_general, dg);
yy = yy + el_remove.height + spacing;
var el_change = create_button(c2 + 16, yy, "Change Particle", ew, eh, fa_center, dmu_dialog_change_graphic_general, dg);
yy = yy + el_change.height + spacing;

var el_name_text = create_text(c2 + 16, yy, "Name:", ew, eh, fa_left, ew, dg);
yy = yy + el_name_text.height + spacing;
var el_name = create_input(c2 + 16, yy, "", ew, eh, uivc_input_graphic_name, "", "", "", validate_string, ui_value_string, 0, 1, VISIBLE_NAME_LENGTH, vx1, vy1, vx2, vy2, dg);
dg.el_name = el_name;
yy = yy + el_name.height + spacing;
var el_name_internal_text = create_text(c2 + 16, yy, "Internal Name:", ew, eh, fa_left, ew, dg);
yy = yy + el_name_internal_text.height + spacing;
var el_name_internal = create_input(c2 + 16, yy, "", ew, eh, uivc_input_graphic_internal_name, "", "", "A-Za-z0-9_", validate_string_internal_name, ui_value_string, 0, 1, INTERNAL_NAME_LENGTH, vx1, vy1, vx2, vy2, dg);
dg.el_name_internal = el_name_internal;
yy = yy + el_name_internal.height + spacing;

vx1 = ew / 2;

var el_frames_horizontal = create_input(c2 + 16, yy, "X frames:", ew, eh, uivc_input_graphic_set_frames_h, "", "1", "0...255", validate_int, ui_value_real, 0, 255, 3, vx1, vy1, vx2, vy2, dg);
dg.el_frames_horizontal = el_frames_horizontal;
yy = yy + el_name_internal.height + spacing;
var el_frames_vertical = create_input(c2 + 16, yy, "Y frames:", ew, eh, uivc_input_graphic_set_frames_v, "", "1", "0...255", validate_int, ui_value_real, 0, 255, 3, vx1, vy1, vx2, vy2, dg);
dg.el_frames_vertical = el_frames_vertical;
yy = yy + el_frames_vertical.height + spacing;

yy = yy_base;

var el_image = create_image_button(c3 + 16, yy, "image", -1, ew, ew, fa_center, dmu_dialog_show_big_picture, dg);
el_image.interactive = false;
dg.el_image = el_image;
yy = yy + el_image.height + spacing;

var el_dimensions = create_text(c3 + 16, yy, "Dimensions:", ew, eh, fa_left, ew, dg);
dg.el_dimensions = el_dimensions;
yy = yy + el_dimensions.height + spacing;

var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);

ds_list_add(dg.contents, el_list,
    el_add, el_remove, el_change,
    el_name_text, el_name, el_name_internal_text, el_name_internal,
    el_confirm);

return dg;