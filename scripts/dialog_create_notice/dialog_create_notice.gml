/// @param Dialog
/// @param message
/// @param [caption-message]
/// @param [confirm-message]
/// @param [width]
/// @param [height]

var message = argument[1];
var caption_message = (argument_count > 2 && argument[2] != undefined) ? argument[2] : "Important!";
var confirm_message = (argument_count > 3 && argument[3] != undefined) ? argument[3] : "sure";
var dw = (argument_count > 4 && argument[4] != undefined) ? argument[4] : 400;
var dh = (argument_count > 5 && argument[5] != undefined) ? argument[5] : 240;

var dg = dialog_create(dw, dh, caption_message, dialog_default, dc_close_no_questions_asked, argument[0]);

var b_width = 128;
var b_height = 32;

var el_text = create_text(dw / 2, dh * 2 / 5, message, 0, 0, fa_center, dw-128, dg);
var el_ok = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, confirm_message, b_width, b_height, fa_center, dmu_close_no_questions_asked, dg);

ds_list_add(dg.contents, el_text, el_ok);

return dg;