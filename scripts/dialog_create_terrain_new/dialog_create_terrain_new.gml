function dialog_create_terrain_new() {
    var dw = 400;
    var dh = 360;
    
    var columns = 1;
    var spacing = 32;
    var ew = dw / columns - spacing * 2;
    var eh = 24;
    
    var vx1 = ew / 2;
    var vy1 = 0;
    var vx2 = ew;
    var vy2 = eh;
    
    var b_width = 128;
    var b_height = 32;
    
    var yy_base = 32;
    
    var col1_x = spacing;
    
    (new EmuDialog(dw, dh, "New Terrain")).AddContent([
        (new EmuInput(
            col1_x, yy_base, ew, eh, "Width:", string(DEFAULT_TERRAIN_WIDTH), string(MIN_TERRAIN_WIDTH) + "..." + string(MAX_TERRAIN_WIDTH),
            number_max_digits(MAX_TERRAIN_WIDTH), E_InputTypes.INT, function() { }
        ))
            .SetRealNumberBounds(MIN_TERRAIN_WIDTH, MAX_TERRAIN_WIDTH)
            .SetInputBoxPosition(vx1, vy1, vx2, vy2)
            .SetTooltip("Height of the terrain")
            .SetID("WIDTH"),
        (new EmuInput(
            col1_x, EMU_AUTO, ew, eh, "Height:", string(DEFAULT_TERRAIN_HEIGHT), string(MIN_TERRAIN_HEIGHT) + "..." + string(MAX_TERRAIN_HEIGHT),
            number_max_digits(MAX_TERRAIN_HEIGHT), E_InputTypes.INT, function() { }
        ))
            .SetRealNumberBounds(MIN_TERRAIN_HEIGHT, MAX_TERRAIN_HEIGHT)
            .SetInputBoxPosition(vx1, vy1, vx2, vy2)
            .SetTooltip("Height of the terrain")
            .SetID("HEIGHT"),
        //(new EmuCheckbox(col1_x, EMU_AUTO, ew, eh, "Dual layer?", false, function() { }))
        //    .SetTooltip("Enable the secondary texture layer for the terrain")
        //    .SetID("USE_DUAL_LAYER"),
        (new EmuInput(col1_x, EMU_AUTO, ew, eh, "Heightmap Scale:", "10", "1...255", 3, E_InputTypes.INT, function() { }))
            .SetTooltip("The brightest point on the heightmap will correspond to this value (in most cases a value of 10 or 16 will be sufficient). This is only useful when importing a heightmap.")
            .SetID("SCALE"),
        (new EmuButton(dw / 2 - ew / 2, EMU_AUTO, ew, b_height, "Import Heightmap", dmu_terrain_import_heightmap))
            .SetTooltip("Import a grayscale image to use to create terrain. Darker values will be lower, and lighter values will be higher.")
            .SetID("HEIGHTMAP"),
        (new EmuCheckbox(col1_x, EMU_AUTO, ew, eh, "Generate noise?", false, function() {
            self.GetSibling("OCTAVES").SetInteractive(self.value);
            self.GetSibling("OCTAVES_LABEL").SetInteractive(self.value);
        }))
            .SetTooltip("Generate a random terrain using noise?")
            .SetID("USENOISE"),
        (new EmuText(col1_x, EMU_AUTO, ew, eh, "Octaves: 6"))
            .SetInteractive(false)
            .SetID("OCTAVES_LABEL"),
        (new EmuProgressBar(col1_x, EMU_AUTO, ew, eh, 8, 1, 10, true, 6, function() {
            self.GetSibling("OCTAVES_LABEL").text = "Octaves: " + string(self.value);
        }))
            .SetIntegersOnly(true)
            .SetInteractive(false)
            .SetTooltip("The number of octaves to be used in generation")
            .SetID("OCTAVES"),
        new EmuButton(dw * 2 / 7 - b_width / 2, dh - 32 - b_height / 2, b_width, b_height, "Create", dmu_dialog_commit_terrain_create),
        new EmuButton(dw * 5 / 7 - b_width / 2, dh - 32 - b_height / 2, b_width, b_height, "Cancel", function() { self.root.Dispose(); }),
    ]);
}