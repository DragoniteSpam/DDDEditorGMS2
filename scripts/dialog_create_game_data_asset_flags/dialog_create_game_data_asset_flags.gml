function dialog_create_game_data_asset_flags(index) {
    var dialog = new EmuDialog(32 + 320 + 32 + 320 + 32, 640, "Asset Flags");
    dialog.index = index;
    
    var element_width = 320;
    var element_height = 32;
    
    var col1 = 32;
    var col2 = 32 + 320 + 32;
    
    var instance = Stuff.data.GetActiveInstance();
    dialog.instance = instance;
    
    return dialog.AddContent([
        (new EmuText(col1, EMU_BASE, element_width, element_height, "Numerical value: 0x0000000000000000"))
            .SetRefresh(function() {
                self.value = "Numerical value: " + string(ptr(self.GetSibling("FIELD").value));
            })
            .SetID("LABEL")
        (emu_bitfield_flags(col1, EMU_AUTO, element_width, element_height, instance.values[index], function() {
            self.root.instance.values[self.root.index] = self.value;
            self.root.Refresh();
        }, "Asset flags can be toggled on or off. Shaded cells are on, while unshaded cells are off."))
            .SetID("FIELD")
    ]).AddDefaultCloseButton();
}