function ui_init_terrain(mode) {
    var hud_width = camera_get_view_width(view_get_camera(view_hud));
    var hud_height = window_get_height();
    var col1x = 32;
    var col2x = 272;
    var col_width = 216;
    
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
                (new EmuCheckbox(col1x, EMU_AUTO, col_width, 32, "Orthographic view?", Settings.terrain.orthographic, function() {
                    Settings.terrain.orthographic = self.value;
                }))
                    .SetTooltip("View the world through an overhead camera."),
                (new EmuButton(col1x, EMU_AUTO, col_width, 32, "Viewer Settings", function() {
                    var dialog = new EmuDialog(640, 540, "Terrain viewer settings");
                    dialog.active_shade = 0;
                    dialog.x = 920;
                    dialog.y = 120;
                    
                    var col1x = 32;
                    var col2x = 336;
                    var col_width = 288;
                    
                    dialog.AddContent([
                        #region column 1
                        new EmuText(col1x, EMU_AUTO, col_width, 32, "[c_blue]Viewer settings"),
                        (new EmuCheckbox(col1x, EMU_AUTO, col_width, 32, "Draw water?", Settings.terrain.view_water, function() {
                            Settings.terrain.view_water = self.value;
                        }))
                            .SetTooltip("Toggles the the water layer under the terrain."),
                        new EmuText(col1x, EMU_AUTO, col_width, 32, "Water level:"),
                        (new EmuProgressBar(col1x, EMU_AUTO, col_width, 32, 8, -1, 1, true, Settings.terrain.water_level, function() {
                            Settings.terrain.water_level = self.value;
                        }))
                            .SetTooltip("If water is drawn, this will determine the water level."),
                        (new EmuCheckbox(col1x, EMU_AUTO, col_width, 32, "Draw wireframe?", Settings.terrain.view_wireframe, function() {
                            Settings.terrain.view_wireframe = self.value;
                        }))
                            .SetTooltip("Toggles the the wireframe grid on the terrain."),
                        new EmuText(col1x, EMU_AUTO, col_width, 32, "Wireframe alpha:"),
                        (new EmuProgressBar(col1x, EMU_AUTO, col_width, 32, 8, 0, 1, true, Settings.terrain.wireframe_alpha, function() {
                            Settings.terrain.wireframe_alpha = self.value;
                        }))
                            .SetTooltip("Fade out the wireframes a bit if you think they're took disracting but you still want them around."),
                        (new EmuCheckbox(col1x, EMU_AUTO, col_width, 32, "Draw axes?", Settings.terrain.view_axes, function() {
                            Settings.terrain.view_axes = self.value;
                        }))
                            .SetTooltip("Toggles the the coordinate system axes."),
                        (new EmuCheckbox(col1x, EMU_AUTO, col_width, 32, "Draw cursor?", Settings.terrain.view_cursor, function() {
                            Settings.terrain.view_cursor = self.value;
                        }))
                            .SetTooltip("Toggles the the cursor on the terrain."),
                        (new EmuCheckbox(col1x, EMU_AUTO, col_width, 32, "Draw skybox?", Settings.terrain.view_skybox, function() {
                            Settings.terrain.view_skybox = self.value;
                        }))
                            .SetTooltip("Toggles the the skybox. In the future I might add the ability to import your own."),
                        #endregion
                        #region column 2
                        new EmuText(col2x, EMU_BASE, col_width, 32, ""),        // just here to take up space
                        (new EmuRadioArray(col2x, EMU_AUTO, 256, 32, "View data:", Settings.terrain.view_data, function() {
                            Settings.terrain.view_data = self.value;
                        }))
                            .AddOptions(["Diffuse", "Position", "Normal", "Depth", "Barycentric"])
                            .SetTooltip("Not going to lie, I find world-space normals to be weirdly pretty."),
                        #endregion
                    ]).AddDefaultCloseButton();
                }))
                    .SetTooltip("A few settings for how the terrain is drawn."),
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
                    var dialog = emu_dialog_confirm(undefined, "Would you like to reset the terrain's height?", function() {
                        debug_timer_start();
                        Stuff.terrain.Flatten();
                        self.root.Dispose();
                        Stuff.AddStatusMessage("Resetting terrain height took " + debug_timer_finish());
                    });
                    dialog.x = 920;
                    dialog.y = 120;
                }),
                (new EmuRadioArray(col1x, EMU_AUTO, col_width, 32, "Deformation mode:", Settings.terrain.submode, function() {
                    Settings.terrain.submode = self.value;
                }))
                    .AddOptions(["Mound", "Average", "Zero"])
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
                    .SetTooltip("Add or subtract a random amount to the terrain. You can select a sprite to use as a mutation template, sort of like a heightmap."),
                (new EmuInput(col1x, EMU_AUTO, col_width, 32, "Scale:", "1", "Global scale", 4, E_InputTypes.REAL, function() {
                    Settings.terrain.global_scale = real(self.value);
                }))
                    .SetID("SCALE_INPUT")
                    .SetTooltip("Scale every vertex up or down."),
                (new EmuButton(col1x, EMU_AUTO, col_width, 32, "Apply global scale", function() {
                    var dialog = emu_dialog_confirm(self, "Apply the global scale?", function() {
                        debug_timer_start();
                        Stuff.terrain.ApplyScale(Settings.terrain.global_scale);
                        Settings.terrain.global_scale = 1;
                        self.root.root.GetSibling("SCALE_INPUT").SetValue("1");
                        self.root.Dispose();
                        Stuff.AddStatusMessage("Scaling thet terrain took " + debug_timer_finish());
                    });
                    dialog.x = 920;
                    dialog.y = 120;
                })),
                (new EmuText(col1x, EMU_AUTO, col_width, 32, "Brush radius: " + string(Settings.terrain.radius)))
                    .SetID("BRUSH_RADIUS_LABEL"),
                (new EmuProgressBar(col1x, EMU_AUTO, col_width, 32, 8, Settings.terrain.brush_min, Settings.terrain.brush_max, true, Settings.terrain.radius, function() {
                    Settings.terrain.radius = self.value;
                    self.GetSibling("BRUSH_RADIUS_LABEL").text = "Brush radius: " + string(self.value);
                }))
                    .SetTooltip("A larger brush will allow you to edit more terrain at once, and a smaller one will give you more precision."),
                (new EmuList(col2x, EMU_BASE, col_width, 32, "Brush:", 32, 10, function() {
                    var selection = self.GetSelection();
                    if (selection + 1) {
                        Settings.terrain.brush_index = selection;
                    }
                }))
                    .SetEntryTypes(E_ListEntryTypes.STRUCTS)
                    .SetList(Stuff.terrain.gen_sprites)
                    .Select(Settings.terrain.brush_index)
                    .SetID("SPRITE_LIST"),
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
                    tx = clamp(tx, 0, sprite_get_width(Stuff.terrain.texture_image) - bs);
                    ty = clamp(ty, 0, sprite_get_height(Stuff.terrain.texture_image) - bs);
                    if (mouse_check_button(mb_left)) {
                        Settings.terrain.tile_brush_x = tx;
                        Settings.terrain.tile_brush_y = ty;
                    }
                }, null, null),
                (new EmuButton(col1x, EMU_AUTO, col_width, 32, "Clear texture", function() {
                    var dialog = emu_dialog_confirm(undefined, "Would you like to clear the entire terrain to this texture tile?", function() {
                        var color_code = Stuff.terrain.GetTextureColorCode();
                        Stuff.terrain.texture.Clear(color_code & 0x00ffffff, (color_code >> 24) / 0xff);
                        self.root.Dispose();
                    });
                    dialog.x = 920;
                    dialog.y = 120;
                }))
                    .SetID("CLEAR_TEXTURE_BUTTON"),
                (new EmuInput(col1x, EMU_AUTO, col_width, 32, "Tile size:", Settings.terrain.tile_brush_size, string(Settings.terrain.tile_brush_size_min) + "..." + string(Settings.terrain.tile_brush_size_max), 3, E_InputTypes.INT, function() {
                    Settings.terrain.tile_brush_size = real(self.value);
                }))
                    .SetRealNumberBounds(Settings.terrain.tile_brush_size_min, Settings.terrain.tile_brush_size_max)
                    .SetTooltip("Default is 16 px tile resolution. 32 and 64 are also common."),
                (new EmuText(col1x, EMU_AUTO, col_width, 32, "Brush radius: " + string(Settings.terrain.tile_brush_radius)))
                    .SetID("BRUSH_RADIUS_LABEL"),
                (new EmuProgressBar(col1x, EMU_AUTO, col_width, 32, 8, Settings.terrain.tile_brush_min, Settings.terrain.tile_brush_max, true, Settings.terrain.tile_brush_radius, function() {
                    Settings.terrain.tile_brush_radius = self.value;
                    self.GetSibling("BRUSH_RADIUS_LABEL").text = "Brush radius: " + string(self.value);
                }))
                    .SetTooltip("A larger brush will allow you to edit more terrain at once, and a smaller one will give you more precision."),
                (new EmuList(col2x, col_width * 2 + 32, col_width, 32, "Brush:", 32, 8, function() {
                    var selection = self.GetSelection();
                    if (selection + 1) {
                        Settings.terrain.tile_brush_index = selection;
                        Stuff.terrain.texture.SetBrush(Stuff.terrain.gen_sprites[selection].sprite, TERRAIN_GEN_SPRITE_INDEX_TEXTURE);
                    }
                }))
                    .SetEntryTypes(E_ListEntryTypes.STRUCTS)
                    .SetList(Stuff.terrain.gen_sprites)
                    .Select(Settings.terrain.tile_brush_index)
                    .SetID("SPRITE_LIST"),
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
                    var dialog = emu_dialog_confirm(undefined, "Would you like to clear the entire terrain to this color?", function() {
                        Stuff.terrain.color.Clear(Settings.terrain.paint_color);
                        self.root.Dispose();
                    });
                    dialog.x = 920;
                    dialog.y = 120;
                }),
                (new EmuText(col1x, EMU_AUTO, col_width, 32, "Brush radius: " + string(Settings.terrain.paint_brush_radius)))
                    .SetID("BRUSH_RADIUS_LABEL"),
                (new EmuProgressBar(col1x, EMU_AUTO, col_width, 32, 8, Settings.terrain.paint_brush_min, Settings.terrain.paint_brush_max, true, Settings.terrain.paint_brush_radius, function() {
                    Settings.terrain.paint_brush_radius = self.value;
                    self.GetSibling("BRUSH_RADIUS_LABEL").text = "Brush radius: " + string(self.value);
                }))
                    .SetTooltip("A larger brush will allow you to edit more terrain at once, and a smaller one will give you more precision."),
                (new EmuList(col2x + 16, EMU_BASE, col_width, 32, "Paintbrush:", 32, 12, function() {
                    var selection = self.GetSelection();
                    Settings.terrain.paint_brush_index = selection;
                    Stuff.terrain.color.SetBrush(spr_terrain_default_brushes, selection);
                }))
                    .AddEntries([
                        "Pixel", "Disc", "Square", "Line", "Star", "Circle",
                        "Ring", "Sphere", "Flare", "Spark", "Explosion",
                        "Cloud", "Smoke", "Snow"
                    ])
                    .Select(Settings.terrain.paint_brush_index),
            ]).SetOnClick(function() {
                Settings.terrain.mode = TerrainModes.COLOR;
            }),
        ])
    ]);
    
    return container;
}