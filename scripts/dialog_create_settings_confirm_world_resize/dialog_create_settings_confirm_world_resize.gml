/// @param Dialog

var dialog = argument0;

var dw = 400;
var dh = 240;

var dg = dialog_create(dw, dh, "Hey, listen!", dialog_default, dc_settings_map, dialog);

var ew = (dw - 64) / 2;
var eh = 24;

var vx1 = ew / 2;
var vy1 = 0;
var vx2 = vx1 + 80;
var vy2 = vy1 + eh;

var b_width = 128;
var b_height = 32;

var el_text = create_text(dw / 2, dh * 2 / 5, "Entities which lie outside the new room boundary will be deleted. Would you still like to commit these changes?", 0, 0, fa_center, dw - 128, dg);
var el_no = create_button(dw / 3 - b_width / 2, dh - 32 - b_height / 2, "Nope", b_width, b_height, fa_center, dmu_dialog_cancel, dg);
var el_yes = create_button(dw * 2 / 3 - b_width / 2, dh - 32 - b_height / 2, "Yes", b_width, b_height, fa_center, dmu_dialog_settings_confirm_world_resize, dg);

ds_list_add(dg.contents, el_text, el_no, el_yes);

ds_map_copy(dg.data, argument0.data);

keyboard_string = "";

return dg;