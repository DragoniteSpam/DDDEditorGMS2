function dialog_create_export_heightmap(root) {
    var dw = 400;
    var dh = 320;
    
    show_message("warning! this is probably going to have problems, you should probably fix it before shipping");
    var dg = dialog_create(dw, dh, "Heightmap Settings", dialog_default, dialog_destroy, root);
    
    var columns = 1;
    var spacing = 16;
    var ew = dw / columns - spacing * 2;
    var eh = 24;
    
    var vx1 = ew / 2;
    var vy1 = 0;
    var vx2 = ew;
    var vy2 = eh;
    
    var yy = 64;
    var yy_base = yy;
    
    var el_scale = create_input(16, yy, "Heightmap scale:", ew, eh, null, "10", "1...255", validate_int, 1, 255, 3, vx1, vy1, vx2, vy2, dg);
    el_scale.tooltip = "The brightest point on the heightmap will correspond to this value (in most cases a value of 10 or 16 will be sufficient).";
    dg.el_scale = el_scale;
    
    yy += el_scale.height + spacing;
    
    var b_width = 128;
    var b_height = 32;
    var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Export", b_width, b_height, fa_center, function(button) {
        terrain_export_heightmap(button.root.filename, real(button.root.el_scale.value));
        dialog_destroy();
    }, dg);
    
    ds_list_add(dg.contents,
        el_scale,
        el_confirm
    );
    
    return dg;
}

function dialog_terrain_mutate() {
    var dialog = (new EmuDialog(640, 560, "Mutate Terrain")).AddContent([
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
            "Flat",
            "Bullseye",
        ]).SetID("SPRITE_LIST"),
        (new EmuButtonImage(352, 32, 256, 256, -1, 0, c_white, 1, false, emu_null)
        )
            .SetID("SPRITE_PREVIEW")
            .SetImageAlignment(fa_left, fa_top)
            .SetCheckerboard(true),
    ]).AddDefaultCloseButton("Okay", function() {
        Stuff.terrain.Mutate(self.GetSibling("SPRITE_LIST").GetSelection(), self.GetSibling("SMOOTHNESS").value, self.GetSibling("NOISE_STRENGTH").value, self.GetSibling("TEXTURE_STRENGTH").value);
        self.root.Dispose();
    });
    dialog.active_shade = 0;
}

function dialog_terrain_add_to_project() {
    var default_lod_levels = min(10, floor(logn(mean(Stuff.terrain.width, Stuff.terrain.height), 16)));
    var dialog = (new EmuDialog(320, 280, "Add to Project")).AddContent([
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
    ]).AddDefaultCloseButton("Add", function() {
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
        
        if (levels == 0) {
            Stuff.terrain.AddToProject("Terrain");
        } else {
            for (var i = 0; i < levels; i++) {
                Stuff.terrain.AddToProject("TerrainLOD" + string(i), power(reduction, i));
            }
        }
        self.root.Dispose();
    });
}

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

function dmu_terrain_import_heightmap(button) {
    var fn = get_open_filename_image();
    if (fn != "") {
        terrain_import_heightmap(button, fn);
        button.root.commit(button.root);
    }
}

function uivc_terrain_light_enable_by_type(list) {
    var mode = Stuff.terrain;
    var light = mode.lights[ui_list_selection(list)];
    
    list.root.el_dir_x.enabled = false;
    list.root.el_dir_y.enabled = false;
    list.root.el_dir_z.enabled = false;
    list.root.el_dir_x_name.enabled = false;
    list.root.el_dir_y_name.enabled = false;
    list.root.el_dir_z_name.enabled = false;
    list.root.el_point_x.enabled = false;
    list.root.el_point_y.enabled = false;
    list.root.el_point_z.enabled = false;
    list.root.el_point_radius.enabled = false;
    
    switch (light.type) {
        case LightTypes.DIRECTIONAL:
            list.root.el_dir_x.enabled = true;
            list.root.el_dir_y.enabled = true;
            list.root.el_dir_z.enabled = true;
            list.root.el_dir_x_name.enabled = true;
            list.root.el_dir_y_name.enabled = true;
            list.root.el_dir_z_name.enabled = true;
            break;
        case LightTypes.POINT:
            list.root.el_point_x.enabled = true;
            list.root.el_point_y.enabled = true;
            list.root.el_point_z.enabled = true;
            list.root.el_point_radius.enabled = true;
            break;
    }
}