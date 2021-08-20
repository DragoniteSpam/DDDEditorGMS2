function dialog_create_terrain_new(dialog) {
    var dw = 400;
    var dh = 320;
    
    var dg = new EmuDialog(dw, dh, "New Terrain");
    
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
    
    var el_width = new EmuInput(
        col1_x, yy_base, ew, eh, "Width:", string(DEFAULT_TERRAIN_WIDTH), string(MIN_TERRAIN_WIDTH) + "..." + string(MAX_TERRAIN_WIDTH),
        number_max_digits(MAX_TERRAIN_WIDTH), E_InputTypes.INT, function() { }
    );
    el_width.SetRealNumberBounds(MIN_TERRAIN_WIDTH, MAX_TERRAIN_WIDTH);
    el_width.SetInputBoxPosition(vx1, vy1, vx2, vy2);
    el_width.tooltip = "Height of the terrain";
    dg.el_width = el_width;
    dg.AddContent([el_width]);
    
    var el_height = new EmuInput(
        col1_x, EMU_AUTO, ew, eh, "Height:", string(DEFAULT_TERRAIN_HEIGHT), string(MIN_TERRAIN_HEIGHT) + "..." + string(MAX_TERRAIN_HEIGHT),
        number_max_digits(MAX_TERRAIN_HEIGHT), E_InputTypes.INT, function() { }
    );
    el_height.SetRealNumberBounds(MIN_TERRAIN_HEIGHT, MAX_TERRAIN_HEIGHT);
    el_height.SetInputBoxPosition(vx1, vy1, vx2, vy2);
    el_height.tooltip = "Height of the terrain";
    dg.el_height = el_height;
    dg.AddContent([el_height]);
    
    var el_dual_layer = new EmuCheckbox(col1_x, EMU_AUTO, ew, eh, "Dual layer?", false, function() { });
    el_dual_layer.tooltip = "Enable the secondary texture layer for the terrain";
    el_dual_layer.enabled = false;
    dg.el_dual_layer = el_dual_layer;
    //dg.AddContent([el_dual_layer]);
    
    var el_scale = new EmuInput(col1_x, EMU_AUTO, ew, eh, "Heightmap Scale:", "10", "1...255", 3, E_InputTypes.INT, function() { });
    el_scale.tooltip = "The brightest point on the heightmap will correspond to this value (in most cases a value of 10 or 16 will be sufficient). This is only useful when importing a heightmap.";
    dg.el_scale = el_scale;
    dg.AddContent([el_scale]);
    
    var el_import_heightmap = new EmuButton(dw / 2 - ew / 2, EMU_AUTO, ew, b_height, "Import Heightmap", dmu_terrain_import_heightmap);
    el_import_heightmap.tooltip = "Import a grayscale image to use to create terrain. Darker values will be lower, and lighter values will be higher.";
    dg.AddContent([el_import_heightmap]);
    
    var el_noise = new EmuCheckbox(col1_x, EMU_AUTO, ew, eh, "Generate noise?", false, function() {
        // this just needs to contain a true/false
    });
    dg.el_noise = el_noise;
    el_noise.tooltip = "Generate a random terrain using Perlin noise?";
    dg.AddContent([el_noise]);
    
    var el_confirm = new EmuButton(dw * 2 / 7 - b_width / 2, dh - 32 - b_height / 2, b_width, b_height, "Create", dmu_dialog_commit_terrain_create);
    dg.AddContent([el_confirm]);
    var el_never_mind = new EmuButton(dw * 5 / 7 - b_width / 2, dh - 32 - b_height / 2, b_width, b_height, "Cancel", dmu_dialog_commit);
    dg.AddContent([el_never_mind]);
    
    return dg;
}