function dialog_create_select_data_types_ext(root, value, callback) {
    var dialog = new EmuDialog(32 + 256 + 256 + 256, 400, "Other data types");
    dialog.root = root;
    var element_width = 256;
    var element_height = 32;
    
    var col1 = 32;
    
    var image_purpleish = "[d#" + string(c_purple_dragon) + "]";
    
    return dialog.AddContent([
        (new EmuRadioArray(col1, EMU_AUTO, element_width, element_height, "All data types:", value, callback))
            .AddOptions([
                "Int", "Enum", "Float", "String", "Boolean", "Data", "Code", "Color",
                "[c_aqua]Mesh", image_purpleish + "Tileset", "[c_aqua]Tile", "[c_aqua]Autotile",
                "[c_lime]Audio (BGM)", "[c_lime]Audio (SE)",
                "[c_aqua]Animation", "[c_aqua]Entity (RefID)", "[c_aqua]Map", image_purpleish + "Battler sprite",
                image_purpleish + "Overworld sprite", image_purpleish + "Particle", image_purpleish + "UI image",
                image_purpleish + "Misc. image", image_purpleish + "Event", image_purpleish + "Skybox",
                "[c_aqua]Mesh Autotile", image_purpleish + "Asset Flag",
            ])
            .SetColumns(9, element_width)
    ]).AddDefaultCloseButton();
}