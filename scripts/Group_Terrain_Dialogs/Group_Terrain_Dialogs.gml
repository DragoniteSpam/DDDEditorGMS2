function dialog_create_export_heightmap() {
    var dw = 400;
    var dh = 240;
    
    var dg = new EmuDialog(dw, dh, "Heightmap Settings");
    dg.AddContent([
        (new EmuInput(32, EMU_AUTO, 320, 32, "Heightmap scale:", string(Settings.terrain.heightmap_scale), "1...255", 3, E_InputTypes.INT, function() {
            Settings.terrain.heightmap_scale = string(self.value);
        }))
            .SetTooltip("The brightest point on the heightmap will correspond to this value. In most casesm a value of 10 or 16 will be sufficient.")
            .SetID("SCALE"),
        (new EmuButton(32, EMU_AUTO, 320, 32, "Save Data Buffer", function() {
            var fn = get_save_filename("Heightmap files|*.hm", "heightmap.hm");
            if (fn != "") {
                Stuff.terrain.ExportHeightmapData(fn);
            }
        }))
            .SetTooltip("Directly save the buffer of 32-bit floats that the editor uses internally.")
            .SetID("BUFFER")
    ]).AddDefaultConfirmCancelButtons("Save", function() {
        var fn = get_save_filename_image("heightmap");
        if (fn != "") {
            Stuff.terrain.ExportHeightmap(fn, real(self.GetSibling("SCALE").value));
        }
        self.root.Dispose();
    }, "Close", emu_dialog_close_auto);
}

function dialog_terrain_mutate() {
    var dialog = new EmuDialog(640, 560, "Mutate Terrain");
    dialog.AddContent([
        new EmuText(32, 32, 360, 24, "Smoothness:"),
        (new EmuProgressBar(32, EMU_AUTO, 256, 24, 8, 1, 10, true, 4, emu_null))
            .SetID("SMOOTHNESS"),
        new EmuText(32, EMU_AUTO, 360, 24, "Noise amplitude:"),
        (new EmuProgressBar(32, EMU_AUTO, 256, 24, 8, 1, 32, true, 4, emu_null))
            .SetID("NOISE_STRENGTH"),
        new EmuText(32, EMU_AUTO, 360, 24, "Texture amplitude:"),
        (new EmuProgressBar(32, EMU_AUTO, 256, 24, 8, 1, 32, true, 4, emu_null))
            .SetID("TEXTURE_STRENGTH"),
        (new EmuList(32, EMU_AUTO, 256, 32, "Generation texture:", 32, 6, function() {
            var selection = self.GetSelection();
            if (selection + 1) {
                self.GetSibling("SPRITE_PREVIEW").sprite = Stuff.terrain.mutation_sprites[selection];
            }
        })).SetEntryTypes(ListEntries.STRINGS).AddEntries([
            "Flat", "Bullseye", "Mountain", "Craters", "Dragon", "Juju"
        ]).SetID("SPRITE_LIST"),
        (new EmuButtonImage(352, 32, 256, 256, -1, 0, c_white, 1, false, emu_null))
            .SetID("SPRITE_PREVIEW")
            .SetImageAlignment(fa_left, fa_top)
            .SetCheckerboard(true),
    ]).AddDefaultCloseButton("Okay", function() {
        Stuff.terrain.Mutate(self.GetSibling("SPRITE_LIST").GetSelection(), self.GetSibling("SMOOTHNESS").value, self.GetSibling("NOISE_STRENGTH").value, self.GetSibling("TEXTURE_STRENGTH").value);
        self.root.Dispose();
    });
    dialog.active_shade = 0;
}

function dialog_create_terrain_new() {
    var dw = 640;
    var dh = 360;
    
    var columns = 2;
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
    var col2_x = spacing + dw / 2;
    
    var dialog = new EmuDialog(dw, dh, "New Terrain");
    dialog.AddContent([
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
        (new EmuButton(col1_x + 0 * ew / 4, EMU_AUTO, ew / 4, b_height, "64", function() {
            self.GetSibling("WIDTH").SetValue("64");
            self.GetSibling("HEIGHT").SetValue("64");
        }))
            .SetTooltip("Preset 64x64 map size"),
        (new EmuButton(col1_x + 1 * ew / 4, EMU_INLINE, ew / 4, b_height, "128", function() {
            self.GetSibling("WIDTH").SetValue("128");
            self.GetSibling("HEIGHT").SetValue("128");
        }))
            .SetTooltip("Preset 128x128 map size"),
        (new EmuButton(col1_x + 2 * ew / 4, EMU_INLINE, ew / 4, b_height, "256", function() {
            self.GetSibling("WIDTH").SetValue("256");
            self.GetSibling("HEIGHT").SetValue("256");
        }))
            .SetTooltip("Preset 256x256 map size"),
        (new EmuButton(col1_x + 3 * ew / 4, EMU_INLINE, ew / 4, b_height, "512", function() {
            self.GetSibling("WIDTH").SetValue("512");
            self.GetSibling("HEIGHT").SetValue("512");
        }))
            .SetTooltip("Preset 512x512 map size"),
        (new EmuCheckbox(col1_x, EMU_AUTO, ew, eh, "Generate noise?", false, function() {
            self.GetSibling("OCTAVES").SetInteractive(self.value);
            self.GetSibling("OCTAVES_LABEL").SetInteractive(self.value);
        }))
            .SetTooltip("Generate a random terrain using noise?")
            .SetID("USE_NOISE"),
        (new EmuInput(col1_x, EMU_AUTO, ew, eh, "Scale:", string(Settings.terrain.heightmap_scale), "1...255", 3, E_InputTypes.INT, function() { }))
            .SetTooltip("The brightest point on the heightmap will correspond to this value (in most cases a value of 10 or 16 will be sufficient). This is only useful when importing a heightmap.")
            .SetID("SCALE"),
        (new EmuText(col1_x, EMU_AUTO, ew, eh, "Smoothness: 6"))
            .SetInteractive(false)
            .SetID("OCTAVES_LABEL"),
        (new EmuProgressBar(col1_x, EMU_AUTO, ew, eh, 8, 1, 10, true, 6, function() {
            self.GetSibling("OCTAVES_LABEL").text = "Smoothness: " + string(self.value);
        }))
            .SetIntegersOnly(true)
            .SetInteractive(false)
            .SetTooltip("The number of octaves to be used in generation")
            .SetID("OCTAVES"),
        (new EmuButton(col2_x, 32, ew, b_height, "Import Heightmap", function() {
            var fn = get_open_filename_image();
            if (fn != "") {
                var image = sprite_add(fn, 0, false, false, 0, 0);
                var terrain = Stuff.terrain;
                var scale = real(self.GetSibling("SCALE").value);
                
                terrain.width = sprite_get_width(image);
                terrain.height = sprite_get_height(image);
                
                var buffer = sprite_to_buffer(image, 0);
                
                buffer_delete(terrain.height_data);
                buffer_delete(terrain.terrain_buffer_data);
                vertex_delete_buffer(terrain.terrain_buffer);
                
                terrain.color.Reset(terrain.width, terrain.height);
                terrain.height_data = terrainops_from_heightmap(buffer, scale);
                terrain.terrain_buffer_data = terrainops_generate(terrain.height_data, terrain.width, terrain.height);
                terrain.terrain_buffer = vertex_create_buffer_from_buffer(terrain.terrain_buffer_data, terrain.vertex_format);
                
                buffer_delete(buffer);
                sprite_delete(image);
                self.root.Dispose();
            }
        }))
            .SetTooltip("Import a grayscale image to use to create terrain. Darker values will be lower, and lighter values will be higher.")
            .SetID("HEIGHTMAP"),
    ]).AddDefaultConfirmCancelButtons("Create", function() {
        var terrain = Stuff.terrain;
        
        var width = real(self.GetSibling("WIDTH").value);
        var height = real(self.GetSibling("HEIGHT").value);
        
        terrain.width = width;
        terrain.height = height;
        
        buffer_delete(terrain.height_data);
        buffer_delete(terrain.terrain_buffer_data);
        vertex_delete_buffer(terrain.terrain_buffer);
        
        terrain.color.Reset(width, height);
        
        if (self.GetSibling("USE_NOISE").value) {
            var ww = power(2, ceil(log2(width)));
            var hh = power(2, ceil(log2(height)));
            terrain.height_data = macaw_generate_dll(ww, hh, self.GetSibling("OCTAVES").value, real(self.GetSibling("SCALE").value)).noise;
        } else {
            terrain.height_data = terrain.GenerateHeightData();
        }
        
        terrain.terrain_buffer_data = terrainops_generate(terrain.height_data, width, height);
        terrain.terrain_buffer = vertex_create_buffer_from_buffer(terrain.terrain_buffer_data, terrain.vertex_format);
        vertex_freeze(terrain.terrain_buffer);
        
        self.root.Dispose();
    }, "Cancel", emu_dialog_close_auto);
}

function dialog_terrain_export() {
    var default_lod_levels = min(10, ceil(power(mean(Stuff.terrain.width, Stuff.terrain.height), 0.25)));
    
    var ew = 256;
    
    var dialog = new EmuDialog(960, 540, "Export Terrain");
    dialog.AddContent([
        #region column 1
        new EmuText(32, EMU_AUTO, 256, 32, "[c_blue]General export settings"),
        (new EmuText(32, EMU_AUTO, 256, 32, "Max LOD levels: " + (default_lod_levels > 0 ? string(default_lod_levels) : "none")))
            .SetID("LABEL"),
        (new EmuProgressBar(32, EMU_AUTO, 256, 32, 8, 0, 10, true, default_lod_levels, function() {
            self.GetSibling("LABEL").text = "Max LOD levels: " + (self.value > 0 ? string(self.value) : "none");
        }))
            .SetIntegersOnly(true)
            .SetID("LEVELS"),
        (new EmuText(32, EMU_AUTO, 256, 32, "LOD reduction factor: 2"))
            .SetID("LABEL_REDUCTION"),
        (new EmuProgressBar(32, EMU_AUTO, 256, 32, 8, 1.5, 4, true, default_lod_levels, function() {
            self.GetSibling("LABEL_REDUCTION").text = "LOD reduction factor: " + string(self.value);
        }))
            .SetValue(2)
            .SetIntegersOnly(false)
            .SetID("REDUCTION"),
        (new EmuButton(32 + 0 * ew / 4, EMU_AUTO, ew / 4, 32, "1.5x", function() {
            self.GetSibling("LABEL_REDUCTION").text = "LOD reduction factor: 1.5";
            self.GetSibling("REDUCTION").SetValue(1.5);
        }))
            .SetTooltip("Preset 1.5x LOD reduction."),
        (new EmuButton(32 + 1 * ew / 4, EMU_INLINE, ew / 4, 32, "2.0x", function() {
            self.GetSibling("LABEL_REDUCTION").text = "LOD reduction factor: 2";
            self.GetSibling("REDUCTION").SetValue(2);
        }))
            .SetTooltip("Preset 2.0x LOD reduction."),
        (new EmuButton(32 + 2 * ew / 4, EMU_INLINE, ew / 4, 32, "3.0x", function() {
            self.GetSibling("LABEL_REDUCTION").text = "LOD reduction factor: 3";
            self.GetSibling("REDUCTION").SetValue(3);
        }))
            .SetTooltip("Preset 3.0x LOD reduction."),
        (new EmuButton(32 + 3 * ew / 4, EMU_INLINE, ew / 4, 32, "4.0x", function() {
            self.GetSibling("LABEL_REDUCTION").text = "LOD reduction factor: 4";
            self.GetSibling("REDUCTION").SetValue(4);
        }))
            .SetTooltip("Preset 4.0x LOD reduction."),
        (new EmuCheckbox(32, EMU_AUTO, 256, 32, "Smooth normals?", Settings.terrain.export_smooth, function() {
            Settings.terrain.export_smooth = self.value;
        }))
            .SetTooltip("Smooth the normals of the terrain before saving it. [c_red]Warning! This can be very slow on large terrains."),
        (new EmuInput(32, EMU_AUTO, 256, 32, "Threshold:", string(Settings.terrain.export_smooth_threshold), "0...90 degrees", 4, E_InputTypes.REAL, function() {
            Settings.terrain.export_smooth_threshold = real(self.value);
        }))
            .SetTooltip("The angle tolerance of smoothed normals. A higher value means more smoothing. I recommend somethingn between 45 and 75."),
        (new EmuCheckbox(32, EMU_AUTO, 256, 32, "Export all faces?", Settings.terrain.export_all, function() {
            Settings.terrain.export_all = self.value;
        }))
            .SetTooltip("You can choose to remove triangles where all three vertices are below z = 0."),
        (new EmuCheckbox(32, EMU_AUTO, 256, 32, "Centered?", Settings.terrain.export_centered, function() {
            Settings.terrain.export_centered = self.value;
        }))
            .SetTooltip("Align the terrain around the center of the world origin instead of sticking it in the corner."),
        #endregion
        #region column 2
        (new EmuInput(352, 64, 256, 32, "Export scale:", string(Settings.terrain.save_scale), "0.01...100", 4, E_InputTypes.REAL, function() {
            Settings.terrain.save_scale = real(self.value);
        })),
        (new EmuText(352, EMU_AUTO, 256, 32, "Chunk size: " + ((Settings.terrain.export_chunk_size > 0) ? string(Settings.terrain.export_chunk_size) : "(disabled)")))
            .SetID("LABEL_CHUNKS"),
        (new EmuProgressBar(352, EMU_AUTO, 256, 32, 8, 0, 10, true, Settings.terrain.export_chunk_size, function() {
            self.GetSibling("LABEL_CHUNKS").text = "Chunk size: " + ((self.value > 0) ? string(self.value) : "(disabled)");
            Settings.terrain.export_chunk_size = self.value;
        }))
            .SetValueRange(0, 256)
            .SetIntegersOnly(true)
            .SetID("CHUNKS"),
        (new EmuButton(352 + 0 * ew / 4, EMU_AUTO, ew / 4, 32, "N/A", function() {
            self.GetSibling("LABEL_CHUNKS").text = "Chunk size: (disabled)";
            self.GetSibling("CHUNKS").SetValue(0);
            Settings.terrain.export_chunk_size = 0;
        }))
            .SetTooltip("Disable chunking"),
        (new EmuButton(352 + 1 * ew / 4, EMU_INLINE, ew / 4, 32, "32", function() {
            self.GetSibling("LABEL_CHUNKS").text = "Chunk size: 32";
            self.GetSibling("CHUNKS").SetValue(32);
            Settings.terrain.export_chunk_size = 32;
        }))
            .SetTooltip("Preset chunk size of 32"),
        (new EmuButton(352 + 2 * ew / 4, EMU_INLINE, ew / 4, 32, "64", function() {
            self.GetSibling("LABEL_CHUNKS").text = "Chunk size: 64";
            self.GetSibling("CHUNKS").SetValue(64);
            Settings.terrain.export_chunk_size = 64;
        }))
            .SetTooltip("Preset chunk size of 64"),
        (new EmuButton(352 + 3 * ew / 4, EMU_INLINE, ew / 4, 32, "128", function() {
            self.GetSibling("LABEL_CHUNKS").text = "Chunk size: 128";
            self.GetSibling("CHUNKS").SetValue(128);
            Settings.terrain.export_chunk_size = 128;
        }))
            .SetTooltip("Preset chunk size of 128"),
        #endregion
        #region column 3
        (new EmuButton(672, 16, 256, 32, "Add to Project", function() {
            var min_side_length = 10;
            var max_dimension = max(Stuff.terrain.width, Stuff.terrain.height);
            // if it's not immediately clear what this does - the reduction value
            // is the base of the exponent that models how the resolution of the
            // terrain is reduced every LOD iteration; a value of 2 means that the
            // resolution will be halved for every iteration (1/2^n: 1/1, 1/2, 1/4)
            // while a value of 3 will mean that the resolution will be one third
            // every iteration (1/3^n: 1/1, 1/3, 1*9, etc)
            var reduction = self.GetSibling("REDUCTION").value;
            var levels = floor(clamp(self.GetSibling("LEVELS").value, 0, logn(reduction, max_dimension / min_side_length)));
            var chunk_size = self.GetSibling("CHUNKS").value;
            
            Stuff.terrain.color.SaveState();
            
            if (levels == 0) {
                Stuff.terrain.AddToProject("Terrain", 1, false, false, chunk_size);
            } else {
                for (var i = 0; i < levels; i++) {
                    Stuff.terrain.AddToProject("TerrainLOD" + string(i), power(reduction, i), false, false, chunk_size);
                }
            }
        }))
            .SetInteractive(!TERRAIN_MODE),
        new EmuText(672, EMU_AUTO, 256, 32, "[c_blue]OBJ export settings"),
        (new EmuCheckbox(672, EMU_AUTO, 256, 32, "Use Y-up?", Settings.terrain.export_swap_zup, function() {
            Settings.terrain.export_swap_zup = self.value;
        })),
        (new EmuCheckbox(672, EMU_AUTO, 256, 32, "Flip vertical texture coordinate?", Settings.terrain.export_swap_uvs, function() {
            Settings.terrain.export_swap_uvs = self.value;
        })),
        new EmuText(672, EMU_AUTO, 256, 32, "[c_blue]Vertex buffer export settings"),
        (new EmuButton(672, EMU_AUTO, 256, 32, "Vertex format", function() {
            emu_dialog_vertex_format(Settings.terrain.output_vertex_format, function(value) { Settings.terrain.output_vertex_format = value; });
        })),
        #endregion
    ]).AddDefaultConfirmCancelButtons("Save", function() {
        var min_side_length = 10;
        var max_dimension = max(Stuff.terrain.width, Stuff.terrain.height);
        var reduction = self.GetSibling("REDUCTION").value;
        var levels = floor(clamp(self.GetSibling("LEVELS").value, 0, logn(reduction, max_dimension / min_side_length)));
        var chunk_size = self.GetSibling("CHUNKS").value;
        
        Stuff.terrain.color.SaveState();
        
        var filename = get_save_filename_mesh("Terrain");
        if (filename != "") {
            if (levels == 0) {
                switch (filename_ext(filename)) {
                    case ".d3d": case ".gmmod": Stuff.terrain.ExportD3D(filename, chunk_size); break;
                    case ".obj": Stuff.terrain.ExportOBJ(filename, chunk_size); break;
                    case ".vbuff": Stuff.terrain.ExportVbuff(filename, chunk_size); break;
                }
            } else {
                for (var i = 0; i < levels; i++) {
                    var lod_filename = filename_change_ext(filename, "") + ".LOD" + string(i) + filename_ext(filename);
                    var lod_density = power(reduction, i);
                    switch (filename_ext(filename)) {
                        case ".d3d": case ".gmmod": Stuff.terrain.ExportD3D(lod_filename, lod_density, chunk_size); break;
                        case ".obj": Stuff.terrain.ExportOBJ(lod_filename, lod_density, chunk_size); break;
                        case ".vbuff": Stuff.terrain.ExportVbuff(lod_filename, lod_density, chunk_size); break;
                    }
                }
            }
        }
    }, "Done", emu_dialog_close_auto);
}