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
            .SetID("USE_NOISE"),
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
        new EmuButton(dw * 2 / 7 - b_width / 2, dh - 32 - b_height / 2, b_width, b_height, "Create", function() {
            var terrain = Stuff.terrain;
            
            var width = real(self.GetSibling("WIDTH").value);
            var height = real(self.GetSibling("HEIGHT").value);
            //var dual = self.GetSibling("USE_DUAL_LAYER").value;
            
            terrain.width = width;
            terrain.ui.t_general.element_width.text = "Width: " + string(width);
            terrain.height = height;
            terrain.ui.t_general.element_height.text = "Height: " + string(height);
            
            buffer_delete(terrain.height_data);
            buffer_delete(terrain.terrain_buffer_data);
            vertex_delete_buffer(terrain.terrain_buffer);
            
            terrain.color.Reset(width, height);
            
            if (self.GetSibling("USE_NOISE").value) {
                var ww = power(2, ceil(log2(width)));
                var hh = power(2, ceil(log2(height)));
                terrain.height_data = macaw_generate_dll(ww, hh, self.GetSibling("OCTAVES").value, real(self.GetSibling("SCALE").value)).noise;
            } else {
                terrain.height_data = buffer_create(buffer_sizeof(buffer_f32) * width * height, buffer_fixed, 1);
            }
            
            terrain.terrain_buffer = vertex_create_buffer();
            vertex_begin(terrain.terrain_buffer, terrain.vertex_format);
            
            for (var i = 0; i < width - 1; i++) {
                for (var j = 0; j < height - 1; j++) {
                    var z00 = buffer_peek(terrain.height_data, (((i + 0) * height) + (j + 0)) * 4, buffer_f32);
                    var z01 = buffer_peek(terrain.height_data, (((i + 0) * height) + (j + 1)) * 4, buffer_f32);
                    var z10 = buffer_peek(terrain.height_data, (((i + 1) * height) + (j + 0)) * 4, buffer_f32);
                    var z11 = buffer_peek(terrain.height_data, (((i + 1) * height) + (j + 1)) * 4, buffer_f32);
                    terrain_create_square(terrain.terrain_buffer, i, j, z00, z10, z11, z01);
                }
            }
            
            vertex_end(terrain.terrain_buffer);
            terrain.terrain_buffer_data = buffer_create_from_vertex_buffer(terrain.terrain_buffer, buffer_fixed, 1);
            vertex_freeze(terrain.terrain_buffer);
            
            self.root.Dispose();
        }),
        new EmuButton(dw * 5 / 7 - b_width / 2, dh - 32 - b_height / 2, b_width, b_height, "Cancel", function() { self.root.Dispose(); }),
    ]);
}