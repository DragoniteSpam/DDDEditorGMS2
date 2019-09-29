/// @param Dialog

var dw = 640;
var dh = 480;

var dg = dialog_create(dw, dh, "Data: Tileset", dialog_default, dc_close_no_questions_asked, argument0);

var ew = (dw - 64) / 2;
var eh = 24;

var vx1 = dw / 4 + 16;
var vy1 = 0;
var vx2 = vx1 + 80;
var vy2 = ew;

var b_width = 128;
var b_height = 32;

var yy = 64;

el_notes = create_text(16, yy, "I'll put something in here later probably", ew, eh, fa_left, dw - 32, dg);

el_confirm = create_button(dw * 3 / 4 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);

ds_list_add(dg.contents, el_notes, el_confirm);

return dg;