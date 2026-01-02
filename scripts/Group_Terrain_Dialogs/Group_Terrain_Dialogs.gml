function dialog_create_export_heightmap() {
    var dw = 360;
    var dh = 200;
    
    var dialog = new EmuDialog(dw, dh, "Heightmap Settings");
    dialog.x = 920;
    dialog.y = 120;
    dialog.contents_interactive = true;
    
    dialog.AddContent([
        (new EmuButton(32, EMU_AUTO, 280, 32, "Save Heightmap Image", function() {
            var fn = get_save_filename_image("Heightmap");
            if (fn != "") {
                debug_timer_start();
                Stuff.terrain.ExportHeightmap(fn);
                Stuff.AddStatusMessage("Exporting terrain heightmap took " + debug_timer_finish());
            }
        }))
            .SetTooltip("Save a grayscale image where the brightness of pixels corresponds to the height of the terrain.")
            .SetID("BUFFER"),
        (new EmuButton(32, EMU_AUTO, 280, 32, "Save Data Buffer", function() {
            var fn = get_save_filename("Heightmap files|*.hm", "heightmap.hm");
            if (fn != "") {
                debug_timer_start();
                Stuff.terrain.ExportHeightmapData(fn);
                Stuff.AddStatusMessage("Exporting terrain heightmap buffer took " + debug_timer_finish());
            }
        }))
            .SetTooltip("Directly save the buffer of 32-bit floats that the editor uses internally.")
            .SetID("BUFFER")
    ]).AddDefaultCloseButton();
}

function dialog_create_export_normal_map() {
    var dw = 360;
    var dh = 200;
    
    var dialog = new EmuDialog(dw, dh, "Normal Map Settings");
    dialog.x = 920;
    dialog.y = 120;
    dialog.contents_interactive = true;
    
    dialog.AddContent([
        new EmuText(32, EMU_AUTO, 280, 32, "Size: 1024")
            .SetID("RES LABEL"),
        new EmuProgressBar(32, EMU_AUTO, 280, 32, 8, 0, 4096, true, 4, function() {
            var size = self.value == 0 ? "Auto" : string(power(2, self.value + 6));
            self.GetSibling("RES LABEL").text = $"Size: {size}";
        })
            .SetValueRange(0, 7)
            .SetIntegersOnly(true)
            .SetID("RESOLUTION"),
        (new EmuButton(32, EMU_AUTO, 280, 32, "Save Normal Map Image", function() {
            var fn = get_save_filename_image("normal.png");
            if (fn != "") {
                var size = self.GetSibling("RESOLUTION").value;
                var w = power(2, size + 6);
                var h = w;
                if (size == 0) {
                    w = Stuff.terrain.width;
                    h = Stuff.terrain.height;
                }
                debug_timer_start();
                Stuff.terrain.ExportNormalMap(fn, w, h);
                Stuff.AddStatusMessage("Exporting terrain normal map took " + debug_timer_finish());
            }
        }))
            .SetTooltip("Save a normal map of the entire terrain.")
    ]).AddDefaultCloseButton();
}

function dialog_terrain_mutate() {
    var dialog = new EmuDialog(640, 560, "Mutate Terrain");
    dialog.x = 920;
    dialog.y = 120;
    dialog.active_shade = 0;
    dialog.contents_interactive = true;
    
    dialog.AddContent([
        new EmuText(32, 32, 360, 24, "Smoothness:"),
        (new EmuProgressBar(32, EMU_AUTO, 256, 24, 12, 1, 10, true, 6, emu_null))
            .SetID("SMOOTHNESS"),
        new EmuText(32, EMU_AUTO, 360, 24, "Noise amplitude:"),
        (new EmuProgressBar(32, EMU_AUTO, 256, 24, 12, 0, 1, true, 0.25, emu_null))
            .SetID("NOISE_STRENGTH"),
        new EmuText(32, EMU_AUTO, 360, 24, "Texture amplitude:"),
        (new EmuProgressBar(32, EMU_AUTO, 256, 24, 12, 0, 1, true, 0.25, emu_null))
            .SetID("TEXTURE_STRENGTH"),
        (new EmuList(32, EMU_AUTO, 256, 32, "Generation texture:", 32, 6, function() {
            var selection = self.GetSelection();
            if (selection + 1) {
                self.GetSibling("SPRITE_PREVIEW").sprite = Stuff.terrain.gen_sprites[selection].sprite;
            }
        }))
            .SetEntryTypes(E_ListEntryTypes.STRUCTS)
            .SetList(Stuff.terrain.gen_sprites)
            .SetID("SPRITE_LIST"),
        (new EmuButtonImage(352, 32, 256, 256, -1, 0, c_white, 1, true, emu_null))
            .SetID("SPRITE_PREVIEW")
            .SetImageAlignment(fa_left, fa_top)
            .SetCheckerboard(true)
            .SetInteractive(false)
            .SetDisabledColor(function() { return c_white; }),
    ]).AddDefaultConfirmCancelButtons("Mutate", function() {
        debug_timer_start();
        
        var amplitude = Stuff.terrain.GetGenerationAmplitude(1);
        Stuff.terrain.Mutate(self.GetSibling("SPRITE_LIST").GetSelection(), self.GetSibling("SMOOTHNESS").value, self.GetSibling("NOISE_STRENGTH").value * amplitude, self.GetSibling("TEXTURE_STRENGTH").value * amplitude);
        self.root.Dispose();
        
        Stuff.AddStatusMessage("Mutating terrain took " + debug_timer_finish());
    }, "Close", function() {
        self.root.Dispose();
    });
}

function dialog_create_terrain_new() {
    var dw = 640;
    var dh = 360;
    
    var columns = 2;
    var spacing = 32;
    var ew = dw / columns - spacing * 2;
    var eh = 32;
    
    var col1_x = spacing;
    var col2_x = spacing + dw / 2;
    
    var dialog = new EmuDialog(dw, dh, "New Terrain");
    dialog.x = 920;
    dialog.y = 120;
    dialog.active_shade = 0;
    dialog.contents_interactive = true;
    
    dialog.AddContent([
        (new EmuInput(
            col1_x, EMU_BASE, ew, eh, "Width:", string(DEFAULT_TERRAIN_WIDTH), string(MIN_TERRAIN_WIDTH) + "..." + string(MAX_TERRAIN_WIDTH),
            number_max_digits(MAX_TERRAIN_WIDTH), E_InputTypes.INT, function() { }
        ))
            .SetRealNumberBounds(MIN_TERRAIN_WIDTH, MAX_TERRAIN_WIDTH)
            .SetTooltip("Height of the terrain")
            .SetID("WIDTH"),
        (new EmuInput(
            col1_x, EMU_AUTO, ew, eh, "Height:", string(DEFAULT_TERRAIN_HEIGHT), string(MIN_TERRAIN_HEIGHT) + "..." + string(MAX_TERRAIN_HEIGHT),
            number_max_digits(MAX_TERRAIN_HEIGHT), E_InputTypes.INT, function() { }
        ))
            .SetRealNumberBounds(MIN_TERRAIN_HEIGHT, MAX_TERRAIN_HEIGHT)
            .SetTooltip("Height of the terrain")
            .SetID("HEIGHT"),
        (new EmuButton(col1_x + 0 * ew / 5, EMU_AUTO, ew / 5, eh, "64", function() {
            self.GetSibling("WIDTH").SetValue("64");
            self.GetSibling("HEIGHT").SetValue("64");
        }))
            .SetTooltip("Preset 64x64 map size"),
        (new EmuButton(col1_x + 1 * ew / 5, EMU_INLINE, ew / 5, eh, "128", function() {
            self.GetSibling("WIDTH").SetValue("128");
            self.GetSibling("HEIGHT").SetValue("128");
        }))
            .SetTooltip("Preset 128x128 map size"),
        (new EmuButton(col1_x + 2 * ew / 5, EMU_INLINE, ew / 5, eh, "256", function() {
            self.GetSibling("WIDTH").SetValue("256");
            self.GetSibling("HEIGHT").SetValue("256");
        }))
            .SetTooltip("Preset 256x256 map size"),
        (new EmuButton(col1_x + 3 * ew / 5, EMU_INLINE, ew / 5, eh, "512", function() {
            self.GetSibling("WIDTH").SetValue("512");
            self.GetSibling("HEIGHT").SetValue("512");
        }))
            .SetTooltip("Preset 512x512 map size"),
        (new EmuButton(col1_x + 4 * ew / 5, EMU_INLINE, ew / 5, eh, "1024", function() {
            self.GetSibling("WIDTH").SetValue("1024");
            self.GetSibling("HEIGHT").SetValue("1024");
        }))
            .SetTooltip("Preset 1024x1024 map size"),
        (new EmuButton(col1_x, EMU_AUTO, ew, eh, "Import Heightmap", function() {
            var fn = get_open_filename_image();
            if (fn != "") {
                debug_timer_start();
                var image = sprite_add(fn, 0, false, false, 0, 0);
                var terrain = Stuff.terrain;
                
                terrain.width = sprite_get_width(image);
                terrain.height = sprite_get_height(image);
                
                var buffer = sprite_to_buffer(image, 0);
                
                buffer_delete(terrain.height_data);
                buffer_delete(terrain.terrain_buffer_data);
                buffer_delete(terrain.terrain_lod_data);
                
                terrain.color.Reset(terrain.width * Settings.terrain.color_scale, terrain.height * Settings.terrain.color_scale);
                terrain.texture.Reset(terrain.width, terrain.height);
                
                var heightmap_amplitude = terrain.GetGenerationAmplitude(self.GetSibling("HEIGHTMAP_SCALE").value);
                terrain.height_data = terrainops_from_heightmap(buffer, heightmap_amplitude, terrain.width, terrain.height);
                terrainops_set_active_data(buffer_get_address(terrain.height_data), terrain.width, terrain.height);
                terrain.terrain_buffer_data = terrainops_generate_internal(terrain.height_data, terrain.width, terrain.height);
                terrainops_set_active_vertex_data(buffer_get_address(terrain.terrain_buffer_data));
                terrain.terrain_lod_data = terrainops_generate_lod_internal(terrain.height_data, terrain.width, terrain.height);
                terrainops_set_lod_vertex_data(buffer_get_address(terrain.terrain_lod_data));
                terrain.RegenerateAllTerrainBuffers();
                
                if (self.GetSibling("USE_NOISE").value) {
                    var noise_amplitude = terrain.GetGenerationAmplitude(self.GetSibling("SCALE").value);
                    terrain.Mutate(0, self.GetSibling("OCTAVES").value, noise_amplitude, 0);
                }
                
                buffer_delete(buffer);
                sprite_delete(image);
                self.root.Dispose();
                
                Stuff.AddStatusMessage("Terrain generation took " + debug_timer_finish());
            }
        }))
            .SetTooltip("Import a grayscale image to use to create terrain. Darker values will be lower, and lighter values will be higher.")
            .SetID("HEIGHTMAP"),
        new EmuText(col1_x, EMU_AUTO, ew, eh, "Scale:"),
        (new EmuProgressBar(col1_x, EMU_AUTO, ew, eh, 12, 0, 1, true, Settings.terrain.heightmap_scale, function() {
            Settings.terrain.heightmap_scale = self.value;
        }))
            .SetIntegersOnly(false)
            .SetTooltip("The scale of the heightmap. Maximum height is proportional to the dimensions of the heightmap.")
            .SetID("HEIGHTMAP_SCALE"),
        (new EmuCheckbox(col2_x, EMU_BASE, ew, eh, "Generate noise?", false, function() {
            // not saved
        }))
            .SetTooltip("Generate a random terrain using noise?")
            .SetID("USE_NOISE"),
        new EmuText(col2_x, EMU_AUTO, ew, eh, "Scale:"),
        (new EmuProgressBar(col2_x, EMU_AUTO, ew, eh, 12, 0, 1, true, Settings.terrain.gen_noise_scale, function() {
            Settings.terrain.gen_noise_scale = self.value;
        }))
            .SetIntegersOnly(false)
            .SetTooltip("The scale of the terrain. Maximum height is proportional to the dimensions of the terrain.")
            .SetID("SCALE"),
        (new EmuText(col2_x, EMU_AUTO, ew, eh, "Smoothness:"))
            .SetInteractive(false),
        (new EmuProgressBar(col2_x, EMU_AUTO, ew, eh, 12, 1, 10, true, Settings.terrain.gen_noise_smoothness, function() {
            Settings.terrain.gen_noise_smoothness = self.value;
        }))
            .SetIntegersOnly(true)
            .SetTooltip("The number of octaves to be used in generation.")
            .SetID("OCTAVES"),
    ]).AddDefaultConfirmCancelButtons("Create", function() {
        debug_timer_start();
        var terrain = Stuff.terrain;
        
        var width = real(self.GetSibling("WIDTH").value);
        var height = real(self.GetSibling("HEIGHT").value);
        
        terrain.width = width;
        terrain.height = height;
        
        buffer_delete(terrain.height_data);
        buffer_delete(terrain.terrain_buffer_data);
        buffer_delete(terrain.terrain_lod_data);
        
        terrain.color.Reset(terrain.width * Settings.terrain.color_scale, terrain.height * Settings.terrain.color_scale);
        terrain.texture.Reset(width, height);
        
        terrain.height_data = terrain.GenerateHeightData();
        terrainops_set_active_data(buffer_get_address(terrain.height_data), terrain.width, terrain.height);
        terrain.terrain_buffer_data = terrainops_generate_internal(terrain.height_data, width, height);
        terrainops_set_active_vertex_data(buffer_get_address(terrain.terrain_buffer_data));
        terrain.terrain_lod_data = terrainops_generate_lod_internal(terrain.height_data, terrain.width, terrain.height);
        terrainops_set_lod_vertex_data(buffer_get_address(terrain.terrain_lod_data));
        terrain.RegenerateAllTerrainBuffers();
        
        if (self.GetSibling("USE_NOISE").value) {
            terrain.Mutate(0, self.GetSibling("OCTAVES").value, terrain.GetGenerationAmplitude(self.GetSibling("SCALE").value), 0);
        }
        
        self.root.Dispose();
        
        Stuff.AddStatusMessage("Terrain generation took " + debug_timer_finish());
    }, "Cancel", emu_dialog_close_auto);
}

function dialog_terrain_export() {
    var default_lod_levels = min(10, ceil(power(mean(Stuff.terrain.width, Stuff.terrain.height), 0.25)));
    var is_large_terrain = (Stuff.terrain.width > 1000 || Stuff.terrain.height > 1000);
    
    var ew = 256;
    
    var dialog = new EmuDialog(960, 540, "Export Terrain");
    dialog.x = 400;
    dialog.y = 120;
    dialog.active_shade = 0;
    dialog.contents_interactive = true;
    
    dialog.AddContent([
        #region column 1
        new EmuText(32, EMU_AUTO, 256, 32, "[c_aqua]General export settings"),
        (new EmuText(32, EMU_AUTO, 256, 32, "Max LOD levels: " + (Settings.terrain.export_lod_levels > 0 ? string(Settings.terrain.export_lod_levels) : "none")))
            .SetID("LABEL"),
        (new EmuProgressBar(32, EMU_AUTO, 256, 32, 12, 0, 10, true, Settings.terrain.export_lod_levels, function() {
            self.GetSibling("LABEL").text = "Max LOD levels: " + (self.value > 0 ? string(self.value) : "none");
            Settings.terrain.export_lod_levels = self.value;
        }))
            .SetIntegersOnly(true)
            .SetID("LEVELS"),
        (new EmuText(32, EMU_AUTO, 256, 32, "LOD reduction factor: " + string(Settings.terrain.export_lod_reduction)))
            .SetID("LABEL_REDUCTION"),
        (new EmuProgressBar(32, EMU_AUTO, 256, 32, 12, 1.5, 25, true, Settings.terrain.export_lod_reduction, function() {
            self.GetSibling("LABEL_REDUCTION").text = "LOD reduction factor: " + string(self.value) + "x";
            Settings.terrain.export_lod_reduction = self.value;
        }))
            .SetIntegersOnly(false)
            .SetID("REDUCTION"),
        (new EmuButton(32 + 0 * ew / 4, EMU_AUTO, ew / 4, 32, "3x", function() {
            self.GetSibling("LABEL_REDUCTION").text = "LOD reduction factor: 3x";
            self.GetSibling("REDUCTION").value(3);
            Settings.terrain.export_lod_reduction = 3;
        }))
            .SetTooltip("Preset 3x LOD reduction."),
        (new EmuButton(32 + 1 * ew / 4, EMU_INLINE, ew / 4, 32, "4x", function() {
            self.GetSibling("LABEL_REDUCTION").text = "LOD reduction factor: 4x";
            self.GetSibling("REDUCTION").SetValue(4);
            Settings.terrain.export_lod_reduction = 4;
        }))
            .SetTooltip("Preset 4x LOD reduction."),
        (new EmuButton(32 + 2 * ew / 4, EMU_INLINE, ew / 4, 32, "9x", function() {
            self.GetSibling("LABEL_REDUCTION").text = "LOD reduction factor: 9x";
            self.GetSibling("REDUCTION").SetValue(9);
            Settings.terrain.export_lod_reduction = 9;
        }))
            .SetTooltip("Preset 9x LOD reduction."),
        (new EmuButton(32 + 3 * ew / 4, EMU_INLINE, ew / 4, 32, "16x", function() {
            self.GetSibling("LABEL_REDUCTION").text = "LOD reduction factor: 16";
            self.GetSibling("REDUCTION").SetValue(16);
            Settings.terrain.export_lod_reduction = 16;
        }))
            .SetTooltip("Preset 16x LOD reduction."),
        (new EmuCheckbox(32, EMU_AUTO, 256, 32, "Smooth normals?", Settings.terrain.export_smooth, function() {
            Settings.terrain.export_smooth = self.value;
        }))
            .SetTooltip("Smooth the normals of the terrain before saving it. [c_red]Warning! This can be very slow on large terrains."),
        (new EmuInput(32, EMU_AUTO, 256, 32, "Threshold:", string(Settings.terrain.export_smooth_threshold), "0...90 degrees", 4, E_InputTypes.REAL, function() {
            Settings.terrain.export_smooth_threshold = real(self.value);
        }))
            .SetInteractive(false)
            .SetTooltip("The angle tolerance of smoothed normals. A higher value means more smoothing. I recommend somethingn between 45 and 75."),
        (new EmuCheckbox(32, EMU_AUTO, 256, 32, "Export underwater faces?", Settings.terrain.export_all, function() {
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
        (new EmuProgressBar(352, EMU_AUTO, 256, 32, 12, 0, 10, true, Settings.terrain.export_chunk_size, function() {
            self.GetSibling("LABEL_CHUNKS").text = "Chunk size: " + ((self.value > 0) ? string(self.value) : "(disabled)");
            Settings.terrain.export_chunk_size = self.value;
        }))
            .SetValueRange(is_large_terrain ? 32 : 0, 1024)
            .SetIntegersOnly(true)
            .SetID("CHUNKS"),
        (new EmuButton(352 + 0 * ew / 5, EMU_AUTO, ew / 5, 32, "N/A", function() {
            self.GetSibling("LABEL_CHUNKS").text = "Chunk size: (disabled)";
            self.GetSibling("CHUNKS").SetValue(0);
            Settings.terrain.export_chunk_size = 0;
        }))
            .SetInteractive(!is_large_terrain)
            .SetTooltip("Disable chunking"),
        (new EmuButton(352 + 1 * ew / 5, EMU_INLINE, ew / 5, 32, "64", function() {
            self.GetSibling("LABEL_CHUNKS").text = "Chunk size: 64";
            self.GetSibling("CHUNKS").SetValue(64);
            Settings.terrain.export_chunk_size = 64;
        }))
            .SetTooltip("Preset chunk size of 64"),
        (new EmuButton(352 + 2 * ew / 5, EMU_INLINE, ew / 5, 32, "128", function() {
            self.GetSibling("LABEL_CHUNKS").text = "Chunk size: 128";
            self.GetSibling("CHUNKS").SetValue(128);
            Settings.terrain.export_chunk_size = 128;
        }))
            .SetTooltip("Preset chunk size of 128"),
        (new EmuButton(352 + 3 * ew / 5, EMU_INLINE, ew / 5, 32, "256", function() {
            self.GetSibling("LABEL_CHUNKS").text = "Chunk size: 256";
            self.GetSibling("CHUNKS").SetValue(256);
            Settings.terrain.export_chunk_size = 256;
        }))
            .SetTooltip("Preset chunk size of 256"),
        (new EmuButton(352 + 4 * ew / 5, EMU_INLINE, ew / 5, 32, "1024", function() {
            self.GetSibling("LABEL_CHUNKS").text = "Chunk size: 1024";
            self.GetSibling("CHUNKS").SetValue(1024);
            Settings.terrain.export_chunk_size = 1024;
        }))
            .SetTooltip("Preset chunk size of 1024"),
        new EmuText(352, EMU_AUTO, 256, 48, "[c_aqua]Each chunk and each LOD level will be saved as separate files."),
        new EmuText(352, EMU_AUTO, 256, 48, is_large_terrain ? "[c_aqua]Terrains larger than 1k² must be chunked." : ""),
        #endregion
        #region column 3
        (new EmuButton(672, 16, 256, 32, "Add to Project", function() {
            debug_timer_start();
            var min_side_length = 10;
            var max_dimension = max(Stuff.terrain.width, Stuff.terrain.height);
            // if it's not immediately clear what this does - the reduction value
            // is the base of the exponent that models how the resolution of the
            // terrain is reduced every LOD iteration; a value of 2 means that the
            // resolution will be halved for every iteration (1/2^n: 1/1, 1/2, 1/4)
            // while a value of 3 will mean that the resolution will be one third
            // every iteration (1/3^n: 1/1, 1/3, 1*9, etc)
            var reduction = sqrt(self.GetSibling("REDUCTION").value);
            var levels = floor(clamp(self.GetSibling("LEVELS").value, 0, logn(reduction, max_dimension / min_side_length)));
            var chunk_size = self.GetSibling("CHUNKS").value;
            
            Stuff.terrain.color.SaveState();
            
            if (levels == 0) {
                Stuff.terrain.AddToProject("Terrain", 1, chunk_size);
            } else {
                for (var i = 0; i < levels; i++) {
                    Stuff.terrain.AddToProject("TerrainLOD" + string(i), power(reduction, i), chunk_size);
                }
            }
            
            Stuff.AddStatusMessage("Adding terrain to the project took " + debug_timer_finish());
        }))
            .SetInteractive(!TERRAIN_MODE),
        new EmuText(672, EMU_AUTO, 256, 32, "[c_aqua]OBJ export settings"),
        (new EmuCheckbox(672, EMU_AUTO, 256, 32, "Use Y-up?", Settings.terrain.export_swap_zup, function() {
            Settings.terrain.export_swap_zup = self.value;
        })),
        (new EmuCheckbox(672, EMU_AUTO, 256, 32, "    Swap handedness?", Settings.terrain.export_swap_handedness, function() {
            Settings.terrain.export_swap_handedness = self.value;
        })),
        (new EmuCheckbox(672, EMU_AUTO, 256, 32, "Flip vertical texture coordinate?", Settings.terrain.export_swap_uvs, function() {
            Settings.terrain.export_swap_uvs = self.value;
        })),
        new EmuText(672, EMU_AUTO, 256, 32, "[c_aqua]Vertex buffer export settings"),
        (new EmuButton(672, EMU_AUTO, 256, 32, "Vertex format", function() {
            emu_dialog_vertex_format(Settings.terrain.output_vertex_format, function(value) { Settings.terrain.output_vertex_format = value; });
        })),
        #endregion
    ]).AddDefaultConfirmCancelButtons("Save", function() {
        var min_side_length = 10;
        var max_dimension = max(Stuff.terrain.width, Stuff.terrain.height);
        var reduction = sqrt(self.GetSibling("REDUCTION").value);
        var levels = floor(clamp(self.GetSibling("LEVELS").value, 0, logn(reduction, max_dimension / min_side_length)));
        var chunk_size = self.GetSibling("CHUNKS").value;
        
        Stuff.terrain.color.SaveState();
        
        var filename = get_save_filename_mesh("Terrain");
        if (filename != "") {
            debug_timer_start();
            
            if (levels == 0) {
                switch (filename_ext(filename)) {
                    case ".d3d": case ".gmmod": Stuff.terrain.ExportD3D(filename, 1, chunk_size); break;
                    case ".obj": Stuff.terrain.ExportOBJ(filename, 1, chunk_size); break;
                    case ".vbuff": Stuff.terrain.ExportVbuff(filename, 1, chunk_size); break;
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
            
            Stuff.AddStatusMessage("Exporting terrain as " + filename_ext(filename) + " took " + debug_timer_finish());
        }
    }, "Done", emu_dialog_close_auto);
}

function dialog_create_terrain_brush_manager() {
    var dw = 640;
    var dh = 540;
    
    var columns = 2;
    var spacing = 32;
    var ew = dw / columns - spacing * 2;
    var eh = 32;
    
    var col1x = spacing;
    var col2x = spacing + dw / 2;
    
    var dialog = new EmuDialog(dw, dh, "Terrain brushes");
    dialog.x = 920;
    dialog.y = 120;
    dialog.active_shade = 0;
    dialog.contents_interactive = true;
    
    dialog.AddContent([
        #region column 1
        (new EmuList(col1x, EMU_BASE, ew, eh, "Brushes:", eh, 10, function() {
            if (!self.GetSibling("NAME")) return;
            var selection = self.GetSelection();
            if (selection + 1) {
                var data = Stuff.terrain.brush_sprites[selection];
                self.GetSibling("NAME").SetInteractive(!data.builtin);
                self.GetSibling("LOAD").SetInteractive(!data.builtin);
                self.GetSibling("DELETE").SetInteractive(!data.builtin);
                self.GetSibling("DEF_NOTICE").text = data.builtin ? "Default brushes cannot be edited." : "";
                
                self.GetSibling("NAME").SetValue(data.name);
                self.GetSibling("PREVIEW").sprite = data.sprite;
                if (sprite_exists(data.sprite)) {
                    self.GetSibling("DIMENSIONS").text = "Dimensions: " + string(sprite_get_width(data.sprite)) + " x " + string(sprite_get_height(data.sprite));
                } else {
                    self.GetSibling("DIMENSIONS").text = "Dimensions:";
                }
            } else {
                self.GetSibling("NAME").SetInteractive(false);
                self.GetSibling("LOAD").SetInteractive(false);
                self.GetSibling("DELETE").SetInteractive(false);
            }
        }))
            .SetEntryTypes(E_ListEntryTypes.STRUCTS)
            .SetList(Stuff.terrain.brush_sprites)
            .SetID("BRUSH_LIST"),
        new EmuButton(col1x, EMU_AUTO, ew, eh, "Add", function() {
            var selection = self.GetSibling("BRUSH_LIST").GetSelection();
            if (selection == -1) selection = array_length(Stuff.terrain.brush_sprites);
            var data = {
                sprite: -1,
                name: "Brush" + string(array_length(Stuff.terrain.brush_sprites)),
                builtin: false,
            };
            array_insert(Stuff.terrain.brush_sprites, selection, data);
            self.GetSibling("BRUSH_LIST").Deselect();
            // this activates the Load button
            self.GetSibling("BRUSH_LIST").Select(selection);
            data.name = self.GetSibling("LOAD").callback();
            // yes, again - this updates the display
            self.GetSibling("BRUSH_LIST").Select(selection);
            // i like to think this is somewhat clever
            array_push(Stuff.terrain.gen_sprites, data);
        }),
        (new EmuButton(col1x, EMU_AUTO, ew, eh, "Delete", function() {
            var selection = self.GetSibling("BRUSH_LIST").GetSelection();
            if (selection == -1) return;
            var data = Stuff.terrain.brush_sprites[selection];
            if (data.builtin) return;
            if (sprite_exists(data.sprite)) sprite_delete(data.sprite);
            array_delete(Stuff.terrain.brush_sprites, selection, 1);
            self.GetSibling("BRUSH_LIST").Deselect();
            // also delete the brush from the generation sprites list
            for (var i = 0, n = array_length(Stuff.terrain.gen_sprites); i < n; i++) {
                if (Stuff.terrain.gen_sprites[i].sprite == data.sprite) {
                    array_delete(Stuff.terrain.gen_sprites, i, 1);
                    break;
                }
            }
        }))
            .SetID("DELETE"),
        #endregion
        #region column 2
        (new EmuInput(col2x, EMU_BASE, ew, eh, "Name:", "", "Brush name", 32, E_InputTypes.STRING, function() {
            var selection = self.GetSibling("BRUSH_LIST").GetSelection();
            if (selection == -1 || Stuff.terrain.brush_sprites[selection].builtin) return;
            Stuff.terrain.brush_sprites[selection].name = self.value;
        }))
            .SetInteractive(false)
            .SetID("NAME"),
        (new EmuText(col2x, EMU_AUTO, ew, eh, "Dimensions:"))
            .SetID("DIMENSIONS"),
        (new EmuButton(col2x, EMU_AUTO, ew, eh, "Load", function() {
            var selection = self.GetSibling("BRUSH_LIST").GetSelection();
            if (selection == -1 || Stuff.terrain.brush_sprites[selection].builtin) return;
            var filename = get_open_filename_image();
            
            if (!file_exists(filename)) return Stuff.terrain.brush_sprites[selection].name;
            
            var spr_raw = -1;
            var assembly_surface = -1;
            
            try {
                spr_raw = sprite_add(filename, 0, false, false, 0, 0);
                var w = min(512, sprite_get_width(spr_raw));
                var h = min(512, sprite_get_height(spr_raw));
                
                assembly_surface = surface_create(w * 3, h);
                surface_set_target(assembly_surface);
                draw_clear_alpha(c_black, 0);
                draw_rectangle_colour(0, 0, w, h, 0x8c8c8c, 0x8c8c8c, 0x8c8c8c, 0x8c8c8c, false);
                draw_rectangle_colour(w, 0, w * 2 - 1/*gamemaker why are you like this*/, h, c_black, c_black, c_black, c_black, false);
                gpu_set_blendmode(bm_add);
                draw_sprite_stretched(spr_raw, 0, 0, 0, w, h);
                draw_sprite_stretched(spr_raw, 0, w, 0, w, h);
                draw_sprite_stretched(spr_raw, 0, w * 2, 0, w, h);
                gpu_set_blendmode(bm_normal);
                surface_reset_target();
                
                surface_save(assembly_surface, PATH_TEMP + "brush.png");
                
                Stuff.terrain.brush_sprites[selection].sprite = sprite_add(PATH_TEMP + "brush.png", 3, false, false, 0, 0);
            } catch (e) {
                Stuff.AddStatusMessage("Could not load the file! " + e.message);
            } finally {
                if (spr_raw != -1) sprite_delete(spr_raw);
                if (assembly_surface != -1) surface_free(assembly_surface);
            }
            
            self.GetSibling("BRUSH_LIST").Select(selection);
            
            return string_copy(filename_change_ext(filename_name(filename), ""), 1, 32);
        }))
            .SetID("LOAD"),
        (new EmuButtonImage(col2x, EMU_AUTO, ew, ew, -1, TERRAIN_GEN_SPRITE_INDEX_BRUSH, c_white, 1, true, emu_null))
            .SetID("PREVIEW")
            .SetImageAlignment(fa_left, fa_top)
            .SetAllowShrink(true)
            .SetCheckerboard(true)
            .SetInteractive(false)
            .SetDisabledColor(function() { return c_white; }),
        (new EmuText(col2x, EMU_AUTO, ew, eh, ""))
            .SetID("DEF_NOTICE"),
        #endregion
    ]).AddDefaultCloseButton("Done");
}