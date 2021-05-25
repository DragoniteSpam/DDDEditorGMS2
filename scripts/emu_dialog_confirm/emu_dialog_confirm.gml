function emu_dialog_confirm(root, message, action_confirm, caption_message, confirm_message, cancel_message, action_cancel) {
    // if the order of these parameters seems a little weird, it's because all of
    // the required ones have to go at the beginning and the optional ones at the end
    if (caption_message == undefined) caption_message = "Important!";
    if (confirm_message == undefined) confirm_message = "yeah";
    if (cancel_message == undefined) cancel_message = "nope";
    if (action_cancel == undefined) action_cancel = function() { self.root.Dispose() };
    
    var dw = 400;
    var dh = 280;
    var b_width = 128;
    var b_height = 32;
    
    var el_text = new EmuText(dw / 2, 32, dw - 64, dh - 64 - b_height, "[fa_center]" + message);
    el_text.alignment = fa_center;
    el_text.valignment = fa_middle;
    
    var dialog = new EmuDialog(dw, dh, caption_message);
    dialog.AddContent([
        el_text,
        new EmuButton(dw / 3 - b_width / 2, dh - 32 - b_height / 2, b_width, b_height, cancel_message, action_cancel),
        new EmuButton(dw * 2 / 3 - b_width / 2, dh - 32 - b_height / 2, b_width, b_height, confirm_message, action_confirm),
    ]);
    dialog.root = root;
    return dialog;
} 