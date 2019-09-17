/// @param root
/// @param message
/// @param confirm-action
/// @param [caption-message]
/// @param [confirm-message]
/// @param [cancel-message]
/// @param [cancel-action]
// if the order of these parameters seems a little weird, it's because all of
// the required ones have to go at the beginning and the optional ones at the end

var message = argument[1];
var action_confirm = argument[2];

var caption_message = (argument_count > 3) ? argument[3] : "Important!";
var confirm_message = (argument_count > 4) ? argument[4] : "yep";
var cancel_message = (argument_count > 5) ? argument[5] : "nope";
var action_cancel = (argument_count > 6) ? argument[6] : dmu_dialog_cancel;

var dw = 400;
var dh = 280;

var dg = dialog_create(dw, dh, caption_message, dialog_default, action_cancel, argument[0]);

var b_width = 128;
var b_height = 32;

var el_text = create_text(dw / 2, dh * 2 / 5, message, 0, 0, fa_center, dw - 96, dg);
var el_cancel = create_button(dw / 3 - b_width / 2, dh - 32 - b_height / 2, cancel_message, b_width, b_height, fa_center, action_cancel, dg);
var el_confirm = create_button(dw * 2 / 3 - b_width / 2, dh - 32 - b_height / 2, confirm_message, b_width, b_height, fa_center, action_confirm, dg);

ds_list_add(dg.contents, el_text, el_cancel, el_confirm);

return dg;