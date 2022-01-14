function ui_init_terrain(mode) {
    var hud_width = camera_get_view_width(view_get_camera(view_hud));
    var hud_height = window_get_height();
    var col1x = 32;
    var col2x = 256;
    var col_width = 224;
    
    var container = new EmuCore(0, 0, hud_width, hud_height);
    
    container.AddContent([
        (new EmuTabGroup(0, 32, hud_width, hud_height - 32, 1, 32)).AddTabs(0, [
            (new EmuTab("General")).AddContent([
                new EmuText(col1x, EMU_AUTO, col_width, 32, "[c_blue]General Settings"),
                (new EmuText(col1x, EMU_AUTO, col_width, 32, "Width"))
                    .SetTextUpdate(function() { return "Width: " + string(Stuff.terrain.width); })
                    .SetID("LABEL_WIDTH"),
                (new EmuText(col1x, EMU_AUTO, col_width, 32, "Height:"))
                    .SetTextUpdate(function() { return "Height: " + string(Stuff.terrain.height); })
                    .SetID("LABEL_HEIGHT"),
                (new EmuCheckbox(col1x, EMU_AUTO, col_width, 32, "Orthographic?", Settings.terrain.orthographic, function() {
                    Settings.terrain.orthographic = self.value;
                }))
                    .SetTooltip("View the world through an overhead camera."),
                (new EmuCheckbox(col1x, EMU_AUTO, col_width, 32, "Draw water?", Settings.terrain.view_water, function() {
                    Settings.terrain.view_water = self.value;
                }))
                    .SetTooltip("Toggles the the water layer under the terrain."),
                (new EmuCheckbox(col1x, EMU_AUTO, col_width, 32, "Draw wireframe?", Settings.terrain.view_grid, function() {
                    Settings.terrain.view_grid = self.value;
                }))
                    .SetTooltip("Toggles the the wireframe grid on the terrain."),
                (new EmuCheckbox(col1x, EMU_AUTO, col_width, 32, "Draw axes?", Settings.terrain.view_axes, function() {
                    Settings.terrain.view_axes = self.value;
                }))
                    .SetTooltip("Toggles the the coordinate system axes."),
                (new EmuCheckbox(col1x, EMU_AUTO, col_width, 32, "Draw cursor?", Settings.terrain.view_axes, function() {
                    Settings.terrain.view_cursor = self.value;
                }))
                    .SetTooltip("Toggles the the cursor on the terrain."),
                (new EmuCheckbox(col1x, EMU_AUTO, col_width, 32, "Draw normals?", Settings.terrain.view_normals, function() {
                    Settings.terrain.view_normals = self.value;
                }))
                    .SetTooltip("Not going to lie, I find world-space normals to be weirdly pretty."),
                new EmuText(col1x, EMU_AUTO, col_width, 32, "Water level:"),
                (new EmuProgressBar(col1x, EMU_AUTO, col_width, 32, 8, -1, 1, true, Settings.terrain.water_level, function() {
                    Settings.terrain.water_level = self.value;
                }))
                    .SetTooltip("If water is drawn, this will determine the water level."),
                #endregion
                new EmuText(col1x, EMU_AUTO, col_width, 32, "[c_blue]Editor Settings"),
                #region
                (new EmuRadioArray(col1x, EMU_AUTO, col_width, 32, "Brush shape:", Settings.terrain.style, function() {
                    Settings.terrain.style = self.value;
                }))
                    .AddOptions(["Block", "Circle"])
                    .SetTooltip("In case you want to use a different shape to edit terrain."),
                (new EmuText(col1x, EMU_AUTO, col_width, 32, "Brush radius: " + string(Settings.terrain.radius)))
                    .SetID("BRUSH_RADIUS_LABEL"),
                (new EmuProgressBar(col1x, EMU_AUTO, col_width, 32, 8, Settings.terrain.brush_min, Settings.terrain.brush_max, true, Settings.terrain.radius, function() {
                    Settings.terrain.radius = self.value;
                    self.GetSibling("BRUSH_RADIUS_LABEL").text = "Brush radius: " + string(self.value);
                }))
                    .SetTooltip("A larger brush will allow you to edit more terrain at once, and a smaller one will give you more precision."),
                #endregion
                #region
                new EmuText(col2x, EMU_BASE, col_width, 32, "[c_blue]Saving and Loading"),
                new EmuButton(col2x, EMU_AUTO, col_width, 32, "New Terrain", function() {
                    dialog_create_terrain_new();
                }),
                new EmuButton(col2x, EMU_AUTO, col_width, 32, "Save Terrain", function() {
                    terrain_save();
                }),
                new EmuButton(col2x, EMU_AUTO, col_width, 32, "Load Terrain", function() {
                    terrain_load();
                }),
                new EmuButton(col2x, EMU_AUTO, col_width, 32, "Export Terrain", function() {
                    dialog_terrain_export();
                }),
                new EmuButton(col2x, EMU_AUTO, col_width, 32, "Export Heightmap", function() {
                    dialog_create_export_heightmap();
                }),
            ]),
            (new EmuTab("Lighting")).AddContent([
                new EmuText(col1x, EMU_AUTO, col_width, 32, "I'll re-implement this later (hopefully soon)"),
            ]),
            (new EmuTab("Deform")).AddContent([
                new EmuButton(col1x, EMU_AUTO, col_width, 32, "Reset Height", function() {
                    emu_dialog_confirm(undefined, "Would you like to reset the terrain's height?", function() {
                        Stuff.terrain.Flatten();
                        self.root.Dispose();
                    });
                }),
                (new EmuRadioArray(col1x, EMU_AUTO, col_width, 32, "Deformation mode:", Settings.terrain.submode, function() {
                    Settings.terrain.submode = self.value;
                }))
                    .AddOptions(["Mound", "Average", "Flat Average", "Zero"])
                    .SetTooltip("The method which you would like to use to mold the terrain."),
                (new EmuText(col1x, EMU_AUTO, col_width, 32, "Deformation rate: " + string_format(Settings.terrain.rate, 1, 3)))
                    .SetID("DEFORMATION_RATE_LABEL"),
                (new EmuProgressBar(col1x, EMU_AUTO, col_width, 32, 8, Settings.terrain.rate_min, Settings.terrain.rate_max, true, Settings.terrain.rate, function() {
                    Settings.terrain.rate = self.value;
                    self.GetSibling("DEFORMATION_RATE_LABEL").text = "Deformation rate: " + string_format(self.value, 1, 3);
                }))
                    .SetTooltip("A smaller rate will give you more precision, and a larger rate will make the deformation more dramatic."),
                (new EmuButton(col1x, EMU_AUTO, col_width, 32, "Mutate", function() {
                    dialog_terrain_mutate();
                }))
                    .SetID("Add or subtract a random amount to the terrain. You can select a sprite to use as a mutation template, sort of like a heightmap."),
            ]).SetOnClick(function() {
                Settings.terrain.mode = TerrainModes.Z;
            }),
            (new EmuTab("Texture")).AddContent([
                new EmuRenderSurface(col1x, EMU_AUTO, col_width * 2, col_width * 2, function() {
                    self.drawCheckerbox(0, 0, self.width, self.height);
                    draw_sprite(Stuff.terrain.texture_image, 0, 0, 0);
                    
                    var bs = Settings.terrain.tile_brush_size;
                    draw_set_alpha(min(bs / 8, 1));
                    for (var i = bs; i < self.width; i += bs) {
                        draw_line_colour(i, 0, i, self.height, c_dkgray, c_dkgray);
                        draw_line_colour(0, i, self.width, i, c_dkgray, c_dkgray);
                    }
                    draw_set_alpha(1);
                    
                    var tx = Settings.terrain.tile_brush_x;
                    var ty = Settings.terrain.tile_brush_y;
                    draw_sprite_stretched(spr_terrain_texture_selection, 0, tx, ty, Settings.terrain.tile_brush_size, Settings.terrain.tile_brush_size);
                    draw_rectangle_colour(1, 1, self.width - 2, self.height - 2, c_black, c_black, c_black, c_black, true);
                }, function(mx, my) {
                    mx -= view_get_xport(view_current);
                    my -= view_get_yport(view_current);
                    
                    if (!(is_clamped(mx, -16, self.width + 16) && is_clamped(my, -16, self.height + 16))) return;
                    
                    var bs = Settings.terrain.tile_brush_size;
                    var tx = bs * (mx div bs);
                    var ty = bs * (my div bs);
                    if (mouse_check_button(mb_left)) {
                        Settings.terrain.tile_brush_x = tx;
                        Settings.terrain.tile_brush_y = ty;
                    }
                }, null, null),
                new EmuButton(col1x, EMU_AUTO, col_width, 32, "Clear texture", function() {
                    emu_dialog_confirm(undefined, "Would you like to clear the entire terrain to this texture tile?", function() {
                        var color_code = Stuff.terrain.GetTextureColorCode();
                        Stuff.terrain.texture.Clear(color_code & 0x00ffffff, (color_code >> 24) / 0xff);
                        self.root.Dispose();
                    });
                }),
                (new EmuInput(col1x, EMU_AUTO, col_width, 32, "Tile size:", Settings.terrain.tile_brush_size, string(Settings.terrain.tile_brush_size_min) + "..." + string(Settings.terrain.tile_brush_size_max), 3, E_InputTypes.INT, function() {
                    Settings.terrain.tile_brush_size = real(self.value);
                }))
                    .SetRealNumberBounds(Settings.terrain.tile_brush_size_min, Settings.terrain.tile_brush_size_max)
                    .SetTooltip("Default is 16 px tile resolution. 32 and 64 are also common."),
            ]).SetOnClick(function() {
                Settings.terrain.mode = TerrainModes.TEXTURE;
            }),
            (new EmuTab("Painting")).AddContent([
                (new EmuText(col1x, EMU_AUTO, col_width, 32, "Paint strength: " + string(Settings.terrain.paint_strength)))
                    .SetID("PAINT_STENGTH_LABEL"),
                (new EmuProgressBar(col1x, EMU_AUTO, col_width, 32, 8, Settings.terrain.paint_strength_min, Settings.terrain.paint_strength_max, true, Settings.terrain.paint_strength, function() {
                    Settings.terrain.paint_strength = self.value;
                    self.GetSibling("PAINT_STENGTH_LABEL").text = "Paint strength: " + string(self.value);
                }))
                    .SetTooltip("A lower strength value will cause the color to blend with the existing color, and a greater one will cause it to replace the existing color."),
                (new EmuColorPicker(col1x, EMU_AUTO, col_width, 32, "Color:", Settings.terrain.paint_color, function() {
                    Settings.terrain.paint_color = self.value;
                }))
                    .SetTooltip("I really hope you enjoy this color picker because it was probably my favorite UI element to work on."),
                new EmuButton(col1x, EMU_AUTO, col_width, 32, "Clear color", function() {
                    emu_dialog_confirm(undefined, "Would you like to clear the entire terrain to this color?", function() {
                        Stuff.terrain.color.Clear(Settings.terrain.paint_color);
                        self.root.Dispose();
                    });
                }),
                (new EmuList(col2x + 16, EMU_BASE, col_width, 32, "Paintbrush:", 32, 12, function() {
                    Stuff.terrain.color.SetBrush(spr_terrain_default_brushes, self.GetSelection());
                }))
                    .AddEntries([
                        "Pixel", "Disc", "Square", "Line", "Star", "Circle",
                        "Ring", "Sphere", "Flare", "Spark", "Explosion",
                        "Cloud", "Smoke", "Snow"
                    ])
                    .Select(mode.color.brush_index),
            ]).SetOnClick(function() {
                Settings.terrain.mode = TerrainModes.COLOR;
            }),
        ])
    ]);
    
    return container;
}