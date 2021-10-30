function emu_dialog_confirm(root, message, action_confirm, caption_message = "Important!", confirm_message = "yeah!", cancel_message = "nope", action_cancel = function() { self.root.Dispose(); }) {
    var dw = 400;
    var dh = 280;
    var b_width = 128;
    var b_height = 32;
    
    var dialog = new EmuDialog(dw, dh, caption_message);
    
    var el_text = new EmuText(32, 32, dw - 64, dh - 64 - b_height, message);
    el_text.alignment = fa_center;
    el_text.valignment = fa_middle;
    dialog.el_text = el_text;
    
    var el_cancel = new EmuButton(dw / 3 - b_width / 2, dh - 32 - b_height / 2, b_width, b_height, cancel_message, action_cancel);
    dialog.el_cancel = el_cancel;
    
    var el_confirm = new EmuButton(dw * 2 / 3 - b_width / 2, dh - 32 - b_height / 2, b_width, b_height, confirm_message, action_confirm);
    dialog.el_confirm = el_confirm;
    
    dialog.AddContent([el_text, el_cancel, el_confirm]);
    dialog.root = root;
    
    return dialog;
} 