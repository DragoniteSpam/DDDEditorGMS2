/// @description  Dialog dialog_create_yes_or_no(root Dialog, message, confirm action, [caption message], [confirm message], [cancel action], [cancel message]);
/// @param root Dialog
/// @param  message
/// @param  confirm action
/// @param  [caption message]
/// @param  [confirm message]
/// @param  [cancel action]
/// @param  [cancel message]
// if the order of these parameters seems a little weird, it's because all of
// the required ones have to go at the beginning and the optional ones at the end

var message=argument[1];
var caption_message="Important!";
var confirm_message="yep";
var cancel_message="nope";

var action_confirm=argument[2];
var action_cancel=dmu_dialog_cancel;

switch (argument_count){
    case 7:
        cancel_message=argument[6];
    case 6:
        action_cancel=argument[5];
    case 5:
        confirm_message=argument[4];
    case 4:
        caption_message=argument[3];
        break;
}

var dw=400;
var dh=240;

var dg=dialog_create(dw, dh, caption_message, dialog_default, action_cancel, argument[0]);

var b_width=128;
var b_height=32;

var el_text=create_text(dw/2, dh*2/5, message, 0, 0, fa_center, dw-96, dg);
var el_cancel=create_button(dw/3-b_width/2, dh-32-b_height/2, cancel_message, b_width, b_height, fa_center, action_cancel, dg);
var el_confirm=create_button(dw*2/3-b_width/2, dh-32-b_height/2, confirm_message, b_width, b_height, fa_center, action_confirm, dg);

ds_list_add(dg.contents, el_text, el_cancel, el_confirm);

return dg;
