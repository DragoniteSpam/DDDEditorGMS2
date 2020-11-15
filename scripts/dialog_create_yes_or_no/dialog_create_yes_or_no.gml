function dialog_create_yes_or_no(root, message, action_confirm, caption_message, confirm_message, cancel_message, action_cancel) {
    // if the order of these parameters seems a little weird, it's because all of
    // the required ones have to go at the beginning and the optional ones at the end
    if (caption_message == undefined) caption_message = "Important!";
    if (confirm_message == undefined) confirm_message = "yeah";
    if (cancel_message == undefined) cancel_message = "nope";
    if (action_cancel == undefined) action_cancel = dmu_dialog_cancel;
    
    var dw = 400;
    var dh = 280;
    var b_width = 128;
    var b_height = 32;
    var dg = dialog_create(dw, dh, caption_message, dialog_default, action_cancel, root);
    
    var el_text = create_text(dw / 2, 32 + (dh - 32 - b_height) / 2, message, 0, 0, fa_center, dw - 96, dg);
    var el_cancel = create_button(dw / 3 - b_width / 2, dh - 32 - b_height / 2, cancel_message, b_width, b_height, fa_center, action_cancel, dg);
    var el_confirm = create_button(dw * 2 / 3 - b_width / 2, dh - 32 - b_height / 2, confirm_message, b_width, b_height, fa_center, action_confirm, dg);
    
    ds_list_add(dg.contents, el_text, el_cancel, el_confirm);
    
    return dg;
} 