function emu_dialog_confirm(root, message, action_confirm, caption_message = "Important!", confirm_message = "yeah!", cancel_message = "nope", action_cancel = function() { self.root.Dispose(); }) {
    var dw = 400;
    var dh = 240;
    var b_width = 128;
    var b_height = 32;
    
    var dialog = new EmuDialog(dw, dh, caption_message);
    
    dialog.AddContent([
        (new EmuText(32, EMU_AUTO, dw - 64, dh - 64 - b_height, message))
            .SetAlignment(fa_center, fa_middle)
    ]).AddDefaultConfirmCancelButtons(confirm_message, action_confirm, cancel_message, action_cancel);
    
    return dialog;
} 