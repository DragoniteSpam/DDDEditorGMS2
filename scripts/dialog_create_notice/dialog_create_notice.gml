/// @param Dialog
/// @param message
/// @param [caption-message]
/// @param [confirm-message]
/// @param [width]
/// @param [height]

var message = argument[1];
var caption_message = "Important!";
var confirm_message = "sure";

var dw = 400;
var dh = 240;

switch (argument_count) {
    case 6:
        if (!is_undefined(argument[5])) {
            dh = argument[5];
        }
    case 5:
        if (!is_undefined(argument[4])) {
            dw = argument[4];
        }
    case 4:
        if (!is_undefined(argument[3])) {
            confirm_message = argument[3];
        }
    case 3:
        if (!is_undefined(argument[2])) {
            caption_message = argument[2];
        }
        break;
}

var dg = dialog_create(dw, dh, caption_message, dialog_default, dc_close_no_questions_asked, argument[0]);

var b_width = 128;
var b_height = 32;

var el_text = create_text(dw / 2, dh * 2 / 5, message, 0, 0, fa_center, dw-128, dg);
var el_ok = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, confirm_message, b_width, b_height, fa_center, dmu_close_no_questions_asked, dg);

ds_list_add(dg.contents, el_text, el_ok);

return dg;