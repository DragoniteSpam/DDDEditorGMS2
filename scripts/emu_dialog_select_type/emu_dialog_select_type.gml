function dialog_create_data_data_select(root, callback) {
    var dialog = new EmuDialog(32 + 320 + 32, 640, "Select Data...");
    dialog.root = root;
    var element_width = 320;
    var element_height = 32;
    
    return dialog.AddContent([
        (new EmuList(32, EMU_AUTO, element_width, element_height, "Types:", element_height, 16, callback))
            .SetList(array_filter(Game.data, function(element) {
                return (element.type == DataTypes.DATA);
            }))
            .SetEntryTypes(E_ListEntryTypes.STRUCTS)
            .SetID("LIST")
    ]).AddDefaultCloseButton();
}

function dialog_create_data_enum_select(root, callback) {
    var dialog = new EmuDialog(32 + 320 + 32, 640, "Select Enum...");
    dialog.root = root;
    var element_width = 320;
    var element_height = 32;
    
    return dialog.AddContent([
        (new EmuList(32, EMU_AUTO, element_width, element_height, "Types:", element_height, 16, callback))
            .SetList(array_filter(Game.data, function(element) {
                return (element.type == DataTypes.ENUM);
            }))
            .SetEntryTypes(E_ListEntryTypes.STRUCTS)
            .SetID("LIST")
    ]).AddDefaultCloseButton();
}