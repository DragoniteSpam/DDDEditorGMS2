function dialog_create_yes_or_no(root, message, action_confirm, caption_message, confirm_message, cancel_message, action_cancel) {
    // if the order of these parameters seems a little weird, it's because all of
    // the required ones have to go at the beginning and the optional ones at the end
    if (caption_message == undefined) caption_message = "Important!";
    if (confirm_message == undefined) confirm_message = "yeah";
    if (cancel_message == undefined) cancel_message = "nope";
    if (action_cancel == undefined) action_cancel = function() { root.Close() };
    
    var dw = 400;
    var dh = 280;
    var b_width = 128;
    var b_height = 32;
    
    var text = new EmuText(0, 0, dw, dh, message);
    text.alignment = fa_center;
    text.valignment = fa_middle;
    
    return new EmuDialog(dw, dh, caption_message).AddContent([
        text,
        new EmuButton(dw / 3 - b_width / 2, dh - 32 - b_height / 2, b_width, b_height, cancel_message, action_cancel),
        new EmuButton(dw * 2 / 3 - b_width / 2, dh - 32 - b_height / 2, b_width, b_height, confirm_message, action_confirm),
    ]);
} 