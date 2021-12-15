function emu_dialog_notice(message, dw = 420, dh = 240) {
    var b_width = 128;
    var b_height = 32;
    
    var el_text = new EmuText(32, 32, dw - 64, dh - 64 - b_height, message);
    el_text.alignment = fa_center;
    el_text.valignment = fa_middle;
    
    var el_button = new EmuButton(dw / 2 - b_width / 2, dh - 32 - b_height / 2, b_width, b_height, "okay", function() {
        self.root.Dispose();
    });
    var dg = (new EmuDialog(dw, dh, "Hey, listen!")).AddContent([el_text, el_button]);
    dg.el_text = el_text;
    dg.el_button = el_button;
    
    return dg;
}