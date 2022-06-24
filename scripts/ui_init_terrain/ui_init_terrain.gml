function ui_init_terrain(mode) {
    var hud_start_x = 1080;
    var hud_start_y = 0;
    var hud_width = room_width - hud_start_x;
    var hud_height = room_height;
    var col1x = 32;
    var col2x = 272;
    var col_width = 216;
    
    var container = new EmuCore(0, 0, hud_width, hud_height);
    
    container.AddContent([
        (new EmuRenderSurface(0, 0, CW, CH, function(mx, my) {
            Stuff.terrain.DrawTerrain();
        }, function(mx, my) {
            if (mx < 0 || my < 0 || mx >= self.width || my >= self.height) return;
            if (Settings.terrain.orthographic) {
                Stuff.terrain.camera.UpdateOrtho();
            } else {
                Stuff.terrain.camera.Update();
            }
        }, function() {
            // create
        }, function() {
            // destroy
        }))
            .SetID("TERRAIN VIEWPORT"),
        (new EmuTabGroup(hud_start_x, EMU_BASE, hud_width, hud_height - 32, 1, 32)).AddTabs(0, [
            (new EmuTab("General")).AddContent([
                new EmuText(col1x, EMU_AUTO, col_width, 32, "[c_aqua]General Settings"),
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
                    var dialog = new EmuDialog(640, 600, "Terrain viewer settings");
                    dialog.root = self;
                    dialog.active_shade = 0;
                    dialog.x = 920;
                    dialog.y = 120;
                    
                    var col1x = 32;
                    var col2x = 336;
                    var col_width = 288;
                    
                    return dialog.AddContent([
                        #region column 1
                        (new EmuCheckbox(col1x, EMU_AUTO, col_width, 32, "Draw water?", Settings.terrain.view_water, function() {
                            Settings.terrain.view_water = self.value;
                        }))
                            .SetTooltip("Toggles the the water layer under the terrain."),
                        new EmuText(col1x, EMU_AUTO, col_width, 32, "Water level:"),
                        (new EmuProgressBar(col1x, EMU_AUTO, col_width, 32, 12, -1, 1, true, Settings.terrain.water_level, function() {
                            Settings.terrain.water_level = self.value;
                        })),
                        new EmuText(col1x, EMU_AUTO, col_width, 32, "Wireframe alpha:"),
                        (new EmuProgressBar(col1x, EMU_AUTO, col_width, 32, 12, 0, 1, true, Settings.terrain.wireframe_alpha, function() {
                            Settings.terrain.wireframe_alpha = self.value;
                        }))
                            .SetTooltip("Fade out the wireframes a bit if you think they're too disracting."),
                        new EmuText(col1x, EMU_AUTO, col_width, 32, "Cursor alpha:"),
                        (new EmuProgressBar(col1x, EMU_AUTO, col_width, 32, 12, 0, 1, true, Settings.terrain.cursor_alpha, function() {
                            Settings.terrain.cursor_alpha = self.value;
                        }))
                            .SetTooltip("Fade out the terrain cursor a bit if you think it's too disracting."),
                        (new EmuCheckbox(col1x, EMU_AUTO, col_width, 32, "Draw axes?", Settings.terrain.view_axes, function() {
                            Settings.terrain.view_axes = self.value;
                        }))
                            .SetTooltip("Toggles the the coordinate system axes."),
                        (new EmuCheckbox(col1x, EMU_AUTO, col_width, 32, "Draw skybox?", Settings.terrain.view_skybox, function() {
                            Settings.terrain.view_skybox = self.value;
                        }))
                            .SetTooltip("Toggles the the skybox. In the future I might add the ability to import your own."),
                        new EmuText(col1x, EMU_AUTO, col_width, 32, "View distance:"),
                        (new EmuProgressBar(col1x, EMU_AUTO, col_width, 32, 12, Settings.terrain.view_distance_perspective_min, Settings.terrain.view_distance_perspective_max, true, Settings.terrain.view_distance, function() {
                            Settings.terrain.view_distance = self.value;
                        }))
                            .SetTooltip("The distance at which the terrain will switch to a lower level of detail. This can have a dramatic impact on performance."),
                        #endregion
                        #region column 2
                        (new EmuRadioArray(col2x, EMU_BASE, 256, 32, "View data:", Settings.terrain.view_data, function() {
                            Settings.terrain.view_data = self.value;
                        }))
                            .AddOptions(["Diffuse", "Position", "Normal", "Heightmap", "Barycentric"])
                            .SetTooltip("Not going to lie, I find world-space normals to be weirdly pretty."),
                        new EmuText(col2x, EMU_AUTO, col_width, 32, "[c_aqua]Fog settings"),
                        (new EmuCheckbox(col2x, EMU_AUTO, col_width, 32, "Draw fog?", Settings.terrain.fog_enabled, function() {
                            Settings.terrain.fog_enabled = self.value;
                        }))
                            .SetTooltip("Whether or not to draw fog over the terrain at great distances."),
                        (new EmuInput(col2x, EMU_AUTO, col_width, 32, "Fog start:", string(Settings.terrain.fog_start), "0...32000", 5, E_InputTypes.REAL, function() {
                            Settings.terrain.fog_start = real(self.value);
                        }))
                            .SetRealNumberBounds(0, 32000)
                            .SetTooltip("Distance at which the pixel fog begins."),
                        (new EmuInput(col2x, EMU_AUTO, col_width, 32, "Fog end:", string(Settings.terrain.fog_end), "0...32000", 5, E_InputTypes.REAL, function() {
                            Settings.terrain.fog_end = real(self.value);
                        }))
                            .SetRealNumberBounds(0, 32000)
                            .SetTooltip("Distance at which the pixel fog ends."),
                        (new EmuColorPicker(col2x, EMU_AUTO, col_width, 32, "Fog color:", Settings.terrain.fog_color, function() {
                            Settings.terrain.fog_color = self.value;
                        }))
                            .SetTooltip("The color of the pixel fog."),
                        (new EmuButton(col2x, EMU_AUTO, col_width, 32, "[c_aqua]Reset", function() {
                            Settings.terrain.view_water = TERRAIN_DEF_VIEW_WATER;
                            Settings.terrain.view_water_min_alpha = TERRAIN_DEF_WATER_MIN_ALPHA;
                            Settings.terrain.view_water_max_alpha = TERRAIN_DEF_WATER_MAX_ALPHA;
                            Settings.terrain.water_level = TERRAIN_DEF_WATER_LEVEL;
                            Settings.terrain.view_distance = TERRAIN_DEF_VIEW_DISTANCE;
                            Settings.terrain.wireframe_alpha = TERRAIN_DEF_WIREFRAME_ALPHA;
                            Settings.terrain.cursor_alpha = TERRAIN_DEF_CURSOR_ALPHA;
                            Settings.terrain.view_skybox = TERRAIN_DEF_VIEW_SKYBOX;
                            Settings.terrain.view_axes = TERRAIN_DEF_VIEW_AXES;
                            Settings.terrain.view_data = TERRAIN_DEF_VIEW_DATA;
                            Settings.terrain.orthographic = TERRAIN_DEF_ORTHOGRAPHIC;
                            Settings.terrain.light_enabled = TERRAIN_DEF_LIGHT_ENABLED;
                            Settings.terrain.fog_enabled = TERRAIN_DEF_FOG_ENABLED;
                            Settings.terrain.fog_color = TERRAIN_DEF_FOG_COLOR;
                            Settings.terrain.fog_start = TERRAIN_DEF_FOG_START;
                            Settings.terrain.fog_end = TERRAIN_DEF_FOG_END;
                            var xx = self.root.x;
                            var yy = self.root.y;
                            // i'm not even sorry
                            self.root.Close();
                            var dialog = self.root.root.callback();
                            dialog.contents_interactive = true;
                            dialog.x = xx;
                            dialog.y = yy;
                        }))
                        #endregion
                    ]).AddDefaultCloseButton();
                }))
                    .SetTooltip("A few settings for how the terrain is drawn."),
                new EmuButton(col1x, EMU_AUTO, col_width, 32, "Brushes...", function() {
                    dialog_create_terrain_brush_manager();
                }),
                new EmuInput(col1x, EMU_AUTO, col_width, 32, "RNG seed:", "", "", 100, E_InputTypes.STRING, function() {
                    macaw_set_seed(self.value);
                }),
                (new EmuText(col1x, EMU_AUTO, col_width * 2, 512, "[c_aqua]Stats[]"))
                    .SetTextUpdate(function() {
                        static area_baseball_diamond = 0.00075 * MILLION;
                        static area_vatican_city = 0.44 * MILLION;
                        static area_barringer_crater = 1.09 * MILLION;
                        static area_central_park = 3.41 * MILLION;
                        static area_dublin_airport = 10.84 * MILLION;
                        static area_skyrim = 39 * MILLION;
                        
                        static cpu_info = dragosys_processor_info();
                        static cpu_cores = string(dragosys_processor_count());
                        static cpu_architecture = dragosys_processor_architecture();
                        static memory_total = string_comma(dragosys_memory_total() div 0x100000);
                        static info = os_get_info();
                        
                        var area = Stuff.terrain.width * Stuff.terrain.height;
                        
                        var output = "[c_aqua]Stats[]\n" +
                            "Chunks:\n" +
                            "    Full: " + string(Stuff.terrain.stats.chunks.full) + "\n" +
                            "    Reduced: " + string(Stuff.terrain.stats.chunks.lod) + "\n" +
                            "Triangles rendered:\n" +
                            "    " + string_comma(Stuff.terrain.stats.triangles) + "\n" +
                            "Terrain area: " + (area < MILLION ? (string_comma(area) + " m²") : (string(area / MILLION) + " km²")) + "\n" +
                            "    " + string(area / area_baseball_diamond) + "x baseball diamond (750 m²)\n" +
                            "    " + string(area / area_vatican_city) + "x Vatican City (0.44 km²)\n" +
                            "    " + string(area / area_barringer_crater) + "x Barringer Crater (1.09 km²)\n" +
                            "    " + string(area / area_central_park) + "x Central Park in New York City (3.41 km²)\n" +
                            "    " + string(area / area_dublin_airport) + "x Dublin International Airport (10.84 km²)\n" +
                            "    " + string(area / area_skyrim) + "x Skyrim (39 km²)\n\n" +
                            "[c_aqua]System info[]\n" +
                            "CPU model: " + cpu_info + "\n" +
                            "    Logical cores: " + cpu_cores + "\n" +
                            "    Architecture: " + cpu_architecture + "\n" +
                            "Available memory: " + memory_total + " MB\n" +
                            "GPU: " + info[? "video_adapter_description"]
                        ;
                        
                        return output;
                    })
                        .SetAlignment(fa_left, fa_top),
                #region i/o stuff
                new EmuText(col2x, EMU_BASE, col_width, 32, "[c_aqua]Saving and Loading"),
                new EmuButton(col2x, EMU_AUTO, col_width, 32, "New Terrain", function() {
                    momu_terrain_new();
                }),
                new EmuButton(col2x, EMU_AUTO, col_width, 32, "Save Terrain", function() {
                    momu_terrain_save();
                }),
                new EmuButton(col2x, EMU_AUTO, col_width, 32, "Load Terrain", function() {
                    momu_terrain_load();
                }),
                new EmuButton(col2x, EMU_AUTO, col_width, 32, "Export Terrain", function() {
                    momu_terrain_export();
                }),
                new EmuButton(col2x, EMU_AUTO, col_width, 32, "Export Heightmap", function() {
                    momu_terrain_heightmap();
                }),
                #endregion
            ]),
            (new EmuTab("Lighting")).AddContent([
                (new EmuRenderSurface(col1x, EMU_AUTO, col_width, 32, function() {
                    draw_clear(EMU_COLOR_BACK);
                    draw_sprite_stretched(Stuff.terrain.gradient_images[Settings.terrain.gradient_image], 0, 0, 0, self.width, self.height);
                    draw_rectangle_colour(1, 1, self.width - 2, self.height - 2, c_black, c_black, c_black, c_black, true);
                }, emu_null, emu_null, emu_null)),
                (new EmuRadioArray(col1x, EMU_AUTO, col_width, 32, "Shading gradient:", Settings.terrain.gradient_image, function() {
                    Settings.terrain.gradient_image = self.value;
                }))
                    .AddOptions(["Smooth", "Four color", "Eight color"])
                    .SetTooltip("The shading gradient. Useful for toon shading."),
                (new EmuText(col1x, EMU_AUTO, col_width, 32, "Primary light angle: " + string(floor(Settings.terrain.light_primary_angle)) + "°"))
                    .SetID("PRIMARY_LIGHT_ANGLE"),
                new EmuProgressBar(col1x, EMU_AUTO, col_width, 32, 12, 0, 360, true, Settings.terrain.light_primary_angle, function() {
                    Settings.terrain.light_primary_angle = self.value;
                    self.GetSibling("PRIMARY_LIGHT_ANGLE").text = "Primary light angle: " + string(floor(self.value)) + "°";
                }),
                (new EmuText(col1x, EMU_AUTO, col_width, 32, "Primary strength: " + string(floor(Settings.terrain.light_primary_strength * 100)) + "%"))
                    .SetID("PRIMARY_LIGHT_STR"),
                new EmuProgressBar(col1x, EMU_AUTO, col_width, 32, 12, 0, 1, true, Settings.terrain.light_primary_strength, function() {
                    Settings.terrain.light_primary_strength = self.value;
                    self.GetSibling("PRIMARY_LIGHT_STR").text = "Primary strength: " + string(floor(self.value * 100)) + "%";
                }),
                (new EmuText(col1x, EMU_AUTO, col_width, 32, "Secondary light angle: " + string(floor(Settings.terrain.light_secondary_angle)) + "°"))
                    .SetID("SECONDARY_LIGHT_ANGLE"),
                new EmuProgressBar(col1x, EMU_AUTO, col_width, 32, 12, 0, 360, true, Settings.terrain.light_secondary_angle, function() {
                    Settings.terrain.light_secondary_angle = self.value;
                    self.GetSibling("SECONDARY_LIGHT_ANGLE").text = "Secondary light angle: " + string(floor(self.value)) + "°";
                }),
                (new EmuText(col1x, EMU_AUTO, col_width, 32, "Secondary strength: " + string(floor(Settings.terrain.light_secondary_strength * 100)) + "%"))
                    .SetID("SECONDARY_LIGHT_STR"),
                new EmuProgressBar(col1x, EMU_AUTO, col_width, 32, 12, 0, 1, true, Settings.terrain.light_secondary_strength, function() {
                    Settings.terrain.light_secondary_strength = self.value;
                    self.GetSibling("SECONDARY_LIGHT_STR").text = "Secondary strength: " + string(floor(self.value)) + "%";
                }),
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
                    .AddOptions(["Raise/Lower", "Average", "Zero"])
                    .SetTooltip("The method which you would like to use to mold the terrain."),
                new EmuText(col1x, EMU_AUTO, col_width, 32, "Deformation rate:"),
                (new EmuProgressBar(col1x, EMU_AUTO, col_width, 32, 12, Settings.terrain.rate_min, Settings.terrain.rate_max, true, Settings.terrain.rate, function() {
                    Settings.terrain.rate = self.value;
                }))
                    .SetTooltip("A smaller rate will give you more precision, and a larger rate will make the deformation more dramatic."),
                (new EmuButton(col1x, EMU_AUTO, col_width, 32, "Mutate", function() {
                    dialog_terrain_mutate();
                }))
                    .SetTooltip("Add or subtract a random amount to the terrain. You can select a sprite to use as a mutation template, sort of like a heightmap."),
                (new EmuInput(col1x, EMU_AUTO, col_width, 32, "Scale:", string(Settings.terrain.global_scale), "Global scale", 4, E_InputTypes.REAL, function() {
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
                new EmuText(col1x, EMU_AUTO, col_width, 32, "Brush radius:"),
                (new EmuProgressBar(col1x, EMU_AUTO, col_width, 32, 12, Settings.terrain.brush_min, Settings.terrain.brush_max, true, Settings.terrain.radius, function() {
                    Settings.terrain.radius = self.value;
                }))
                    .SetTooltip("A larger brush will allow you to edit more terrain at once, and a smaller one will give you more precision."),
                (new EmuList(col2x, EMU_BASE, col_width, 32, "Brush:", 32, 15, function() {
                    var selection = self.GetSelection();
                    if (selection + 1) {
                        Settings.terrain.brush_index = selection;
                        if (self.GetSibling("BRUSH_PREVIEW")) {
                            self.GetSibling("BRUSH_PREVIEW").sprite = Stuff.terrain.brush_sprites[selection].sprite;
                        }
                    }
                }))
                    .SetEntryTypes(E_ListEntryTypes.STRUCTS)
                    .SetList(Stuff.terrain.brush_sprites)
                    .Select(Settings.terrain.brush_index)
                    .SetID("SPRITE_LIST"),
                new EmuButton(col2x, EMU_AUTO, col_width, 32, "Brushes...", function() {
                    dialog_create_terrain_brush_manager();
                }),
                (new EmuButtonImage(col2x, EMU_AUTO, col_width, col_width, Stuff.terrain.brush_sprites[Settings.terrain.brush_index].sprite, TERRAIN_GEN_SPRITE_INDEX_BRUSH, c_white, 1, true, emu_null))
                    .SetID("BRUSH_PREVIEW")
                    .SetImageAlignment(fa_left, fa_top)
                    .SetAllowShrink(true)
                    .SetInteractive(false)
                    .SetDisabledColor(function() { return c_white; })
                    .SetCheckerboard(true),
            ]).SetOnClick(function() {
                Settings.terrain.mode = TerrainModes.Z;
            }),
            (new EmuTab("Texture")).AddContent([
                new EmuButton(col1x, EMU_AUTO, 144, 32, "Export Texture", function() {
                    var filename = get_save_filename_image("texture.png");
                    if (filename != "") {
                        sprite_save(Stuff.terrain.texture_image, 0, filename);
                    }
                }),
                new EmuButton(col1x + 144 + 16, EMU_INLINE, 144, 32, "Import Texture", function() {
                    var filename = get_open_filename_image();
                    if (file_exists(filename)) {
                        var old_sprite = Stuff.terrain.texture_image;
                        Stuff.terrain.texture_image = sprite_add(filename, 0, false, false, 0, 0);
                        if (sprite_exists(Stuff.terrain.texture_image)) {
                            sprite_delete(old_sprite);
                            sprite_save(Stuff.terrain.texture_image, 0, FILE_TERRAIN_TEXTURE);
                            Settings.terrain.tile_brush_x = 0;
                            Settings.terrain.tile_brush_y = 0;
                            Settings.terrain.tile_brush_size = 32;
                            var color_code = Stuff.terrain.GetTextureColorCode();
                            Stuff.terrain.texture.Clear(color_code & 0x00ffffff, (color_code >> 24) / 0xff);
                            self.GetSibling("TEXTURE_RESOLUTION").SetValue(string(Settings.terrain.tile_brush_size));
                            self.GetSibling("TEXTURE_PICKER").offset_x = 0;
                            self.GetSibling("TEXTURE_PICKER").offset_y = 0;
                        } else {
                            Stuff.terrain.texture_image = old_sprite;
                        }
                    }
                }),
                new EmuButton(col1x + 288 + 32, EMU_INLINE, 144, 32, "Set default texture", function() {
                    emu_dialog_confirm(self, "Would you like to reset the terrain texture? This will reset the texture of the entire terrain!", function() {
                        sprite_delete(Stuff.terrain.texture_image);
                        Stuff.terrain.texture_image = sprite_add(PATH_GRAPHICS + DEFAULT_TILESET, 0, false, false, 0, 0);
                        Settings.terrain.tile_brush_x = 0;
                        Settings.terrain.tile_brush_y = 0;
                        Settings.terrain.tile_brush_size = 32;
                        var color_code = Stuff.terrain.GetTextureColorCode();
                        Stuff.terrain.texture.Clear(color_code & 0x00ffffff, (color_code >> 24) / 0xff);
                        self.root.root.GetSibling("TEXTURE_RESOLUTION").SetValue(string(Settings.terrain.tile_brush_size));
                        self.root.root.GetSibling("TEXTURE_PICKER").offset_x = 0;
                        self.root.root.GetSibling("TEXTURE_PICKER").offset_y = 0;
                        if (file_exists(FILE_TERRAIN_TEXTURE)) {
                            file_delete(FILE_TERRAIN_TEXTURE);
                        }
                        self.root.Dispose();
                    });
                }),
                (new EmuRenderSurface(col1x, EMU_AUTO, col_width * 2, col_width * 2 - 48, function(mx, my) {
                    self.drawCheckerbox(0, 0, self.width, self.height);
                    draw_sprite(Stuff.terrain.texture_image, 0, self.offset_x, self.offset_y);
                    
                    var bs = Settings.terrain.tile_brush_size;
                    draw_set_alpha(min(bs / 8, 1));
                    for (var i = self.offset_x % bs; i < self.width; i += bs) {
                        draw_line_colour(i, 0, i, self.height, c_dkgray, c_dkgray);
                    }
                    for (var i = self.offset_y % bs; i < self.height; i += bs) {
                        draw_line_colour(0, i, self.width, i, c_dkgray, c_dkgray);
                    }
                    draw_set_alpha(1);
                    
                    var tx = Settings.terrain.tile_brush_x + self.offset_x;
                    var ty = Settings.terrain.tile_brush_y + self.offset_y;
                    draw_sprite_stretched(spr_terrain_texture_selection, 0, tx, ty, Settings.terrain.tile_brush_size, Settings.terrain.tile_brush_size);
                    draw_rectangle_colour(1, 1, self.width - 2, self.height - 2, c_black, c_black, c_black, c_black, true);
                    
                    if (mouse_check_button(mb_middle)) {
                        draw_sprite(spr_scroll, 0, mx, my);
                    }
                }, function(mx, my) {
                    if (!ds_list_empty(EmuOverlay._contents)) return;
                    if (!(is_clamped(mx, -16, self.width + 16) && is_clamped(my, -16, self.height + 16))) return;
                    
                    var bs = Settings.terrain.tile_brush_size;
                    var tx = bs * ((mx - self.offset_x) div bs);
                    var ty = bs * ((my - self.offset_y) div bs);
                    tx = clamp(tx, 0, sprite_get_width(Stuff.terrain.texture_image) - bs);
                    ty = clamp(ty, 0, sprite_get_height(Stuff.terrain.texture_image) - bs);
                    if (mouse_check_button(mb_left)) {
                        Settings.terrain.tile_brush_x = tx;
                        Settings.terrain.tile_brush_y = ty;
                    }
                    if (mouse_check_button_pressed(mb_middle)) {
                        self.mx = mx;
                        self.my = my;
                    } else if (mouse_check_button(mb_middle)) {
                        self.offset_x = clamp(self.offset_x + (mx - self.mx), min(0, self.width - sprite_get_width(Stuff.terrain.texture_image)), 0);
                        self.offset_y = clamp(self.offset_y + (my - self.my), min(0, self.height - sprite_get_height(Stuff.terrain.texture_image)), 0);
                        self.mx = mx;
                        self.my = my;
                    }
                }, function() {
                    self.mx = -1;
                    self.my = -1;
                    self.offset_x = 0;
                    self.offset_y = 0;
                }, null))
                    .SetID("TEXTURE_PICKER"),
                (new EmuButton(col1x, EMU_AUTO, col_width, 32, "Clear Texture to Selection", function() {
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
                    .SetTooltip("Default is 16 px tile resolution. 32 and 64 are also common.")
                    .SetID("TEXTURE_RESOLUTION"),
                new EmuText(col1x, EMU_AUTO, col_width, 32, "Brush radius:"),
                (new EmuProgressBar(col1x, EMU_AUTO, col_width, 32, 12, Settings.terrain.tile_brush_min, Settings.terrain.tile_brush_max, true, Settings.terrain.tile_brush_radius, function() {
                    Settings.terrain.tile_brush_radius = self.value;
                }))
                    .SetTooltip("A larger brush will allow you to edit more terrain at once, and a smaller one will give you more precision."),
                (new EmuList(col2x, col_width * 2 + 32, col_width, 32, "Brush:", 32, 8, function() {
                    var selection = self.GetSelection();
                    if (selection + 1) {
                        Settings.terrain.tile_brush_index = selection;
                        Stuff.terrain.texture.SetBrush(Stuff.terrain.brush_sprites[selection].sprite, TERRAIN_GEN_SPRITE_INDEX_TEXTURE);
                    }
                }))
                    .SetEntryTypes(E_ListEntryTypes.STRUCTS)
                    .SetList(Stuff.terrain.brush_sprites)
                    .Select(Settings.terrain.tile_brush_index)
                    .SetID("SPRITE_LIST"),
                new EmuButton(col2x, EMU_AUTO, col_width, 32, "Brushes...", function() {
                    dialog_create_terrain_brush_manager();
                }),
            ]).SetOnClick(function() {
                Settings.terrain.mode = TerrainModes.TEXTURE;
            }),
            (new EmuTab("Painting")).AddContent([
                new EmuText(col1x, EMU_AUTO, col_width, 32, "Paint strength:"),
                (new EmuProgressBar(col1x, EMU_AUTO, col_width, 32, 12, Settings.terrain.paint_strength_min, Settings.terrain.paint_strength_max, true, Settings.terrain.paint_strength, function() {
                    Settings.terrain.paint_strength = self.value;
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
                new EmuText(col1x, EMU_AUTO, col_width, 32, "Brush radius:"),
                (new EmuProgressBar(col1x, EMU_AUTO, col_width, 32, 12, Settings.terrain.paint_brush_min, Settings.terrain.paint_brush_max, true, Settings.terrain.paint_brush_radius, function() {
                    Settings.terrain.paint_brush_radius = self.value;
                }))
                    .SetTooltip("A larger brush will allow you to edit more terrain at once, and a smaller one will give you more precision."),
                new EmuButton(col1x, EMU_AUTO, col_width, 32, "Export canvas", function() {
                    var filename = get_save_filename_image("canvas.png");
                    if (filename != "") {
                        var alphaish_sprite = Stuff.terrain.color.GetSprite();
                        var actual_sprite = spriteops_set_alpha(alphaish_sprite, 0, 1);
                        sprite_save(actual_sprite, 0, filename);
                        sprite_delete(alphaish_sprite);
                        sprite_delete(actual_sprite);
                    }
                }),
                new EmuButton(col1x, EMU_AUTO, col_width, 32, "Import canvas", function() {
                    var filename = get_open_filename_image();
                    var canvas = Stuff.terrain.color;
                    
                    if (filename != "") {
                        // loading the canvas is a bit more involved because you
                        // need to make sure it's the right size
                        try {
                            var sprite = sprite_add(filename, 0, false, false, 0, 0);
                            
                            var surface = sprite_to_surface(sprite, 0);
                            var actual_surface = surface_create(canvas.width, canvas.height);
                            surface_set_target(actual_surface);
                            draw_clear_alpha(c_white, 1);
                            surface_reset_target();
                            surface_copy(actual_surface, 0, 0, surface);
                            var alphaish_sprite = sprite_from_surface(actual_surface);
                            var actual_sprite = spriteops_set_alpha(alphaish_sprite, 0, 1);
                            canvas.SetSprite(actual_sprite);
                            
                            sprite_delete(sprite);
                            sprite_delete(actual_sprite);
                            sprite_delete(alphaish_sprite);
                            surface_free(surface);
                            surface_free(actual_surface);
                        } catch (e) {
                            canvas.Reset();
                        }
                    }
                }),
                (new EmuList(col2x, EMU_BASE, col_width, 32, "Paintbrush:", 32, 15, function() {
                    var selection = self.GetSelection();
                    if (selection + 1) {
                        Settings.terrain.paint_brush_index = selection;
                        Stuff.terrain.color.SetBrush(Stuff.terrain.brush_sprites[selection].sprite, TERRAIN_GEN_SPRITE_INDEX_TEXTURE);
                        if (self.GetSibling("BRUSH_PREVIEW")) {
                            self.GetSibling("BRUSH_PREVIEW").sprite = Stuff.terrain.brush_sprites[selection].sprite;
                        }
                    }
                }))
                    .SetList(Stuff.terrain.brush_sprites)
                    .SetEntryTypes(E_ListEntryTypes.STRUCTS)
                    .Select(Settings.terrain.paint_brush_index),
                new EmuButton(col2x, EMU_AUTO, col_width, 32, "Brushes...", function() {
                    dialog_create_terrain_brush_manager();
                }),
                (new EmuButtonImage(col2x, EMU_AUTO, col_width, col_width, Stuff.terrain.brush_sprites[Settings.terrain.brush_index].sprite, TERRAIN_GEN_SPRITE_INDEX_BRUSH, c_white, 1, true, emu_null))
                    .SetID("BRUSH_PREVIEW")
                    .SetImageAlignment(fa_left, fa_top)
                    .SetAllowShrink(true)
                    .SetInteractive(false)
                    .SetDisabledColor(function() { return c_white; })
                    .SetCheckerboard(true),
            ]).SetOnClick(function() {
                Settings.terrain.mode = TerrainModes.COLOR;
            }),
        ])
    ]);
    
    return container;
}