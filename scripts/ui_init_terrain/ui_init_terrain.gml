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
                (new EmuCheckbox(col1x, EMU_AUTO, col_width, 32, "Orthographic?", mode.orthographic, function() {
                    Stuff.terrain.orthographic = self.value;
                }))
                    .SetTooltip("View the world through an overhead camera."),
                (new EmuCheckbox(col1x, EMU_AUTO, col_width, 32, "Draw water?", mode.view_water, function() {
                    Stuff.terrain.view_water = self.value;
                }))
                    .SetTooltip("Toggles the the water layer under the terrain."),
                (new EmuCheckbox(col1x, EMU_AUTO, col_width, 32, "Draw wireframe?", mode.view_grid, function() {
                    Stuff.terrain.view_grid = self.value;
                }))
                    .SetTooltip("Toggles the the wireframe grid on the terrain."),
                (new EmuCheckbox(col1x, EMU_AUTO, col_width, 32, "Draw axes?", mode.view_axes, function() {
                    Stuff.terrain.view_axes = self.value;
                }))
                    .SetTooltip("Toggles the the coordinate system axes."),
                (new EmuCheckbox(col1x, EMU_AUTO, col_width, 32, "Draw cursor?", mode.view_axes, function() {
                    Stuff.terrain.view_cursor = self.value;
                }))
                    .SetTooltip("Toggles the the cursor on the terrain."),
                (new EmuCheckbox(col1x, EMU_AUTO, col_width, 32, "Draw normals?", mode.view_axes, function() {
                    Stuff.terrain.view_normals = self.value;
                }))
                    .SetTooltip("Not going to lie, I find world-space normals to be weirdly pretty."),
                new EmuText(col1x, EMU_AUTO, col_width, 32, "Water level:"),
                (new EmuProgressBar(col1x, EMU_AUTO, col_width, 32, 8, -1, 1, true, mode.water_level, function() {
                    Stuff.terrain.water_level = self.value;
                }))
                    .SetTooltip("If water is drawn, this will determine the water level."),
                #endregion
                new EmuText(col1x, EMU_AUTO, col_width, 32, "[c_blue]Editor Settings"),
                #region
                (new EmuRadioArray(col1x, EMU_AUTO, col_width, 32, "Brush shape:", mode.style, function() {
                    Stuff.terrain.style = self.value;
                }))
                    .AddOptions(["Block", "Circle"])
                    .SetTooltip("In case you want to use a different shape to edit terrain."),
                (new EmuText(col1x, EMU_AUTO, col_width, 32, "Brush radius: " + string(mode.radius)))
                    .SetID("BRUSH_RADIUS_LABEL"),
                (new EmuProgressBar(col1x, EMU_AUTO, col_width, 32, 8, mode.brush_min, mode.brush_max, true, mode.radius, function() {
                    Stuff.terrain.radius = self.value;
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
                    Stuff.terrain.Flatten();
                }),
                (new EmuRadioArray(col1x, EMU_AUTO, col_width, 32, "Deformation mode:", mode.submode, function() {
                    Stuff.terrain.submode = self.value;
                }))
                    .AddOptions(["Mound", "Average", "Flat Average", "Zero"])
                    .SetTooltip("The method which you would like to use to mold the terrain."),
                (new EmuText(col1x, EMU_AUTO, col_width, 32, "Deformation rate: " + string_format(mode.rate, 1, 3)))
                    .SetID("DEFORMATION_RATE_LABEL"),
                (new EmuProgressBar(col1x, EMU_AUTO, col_width, 32, 8, mode.rate_min, mode.rate_max, true, mode.rate, function() {
                    Stuff.terrain.rate = self.value;
                    self.GetSibling("DEFORMATION_RATE_LABEL").text = "Deformation rate: " + string_format(self.value, 1, 3);
                }))
                    .SetTooltip("A smaller rate will give you more precision, and a larger rate will make the deformation more dramatic."),
                (new EmuButton(col1x, EMU_AUTO, col_width, 32, "Mutate", function() {
                    dialog_terrain_mutate();
                }))
                    .SetID("Add or subtract a random amount to the terrain. You can select a sprite to use as a mutation template, sort of like a heightmap."),
            ]).SetOnClick(function() {
                Stuff.terrain.mode = TerrainModes.Z;
            }),
            (new EmuTab("Texture")).AddContent([
                new EmuRenderSurface(col1x, EMU_AUTO, col_width * 2, col_width * 2, function() {
                    self.drawCheckerbox(0, 0, self.width, self.height);
                    draw_sprite(Stuff.terrain.texture_image, 0, 0, 0);
                    for (var i = 16; i < self.width; i += 16) {
                        draw_line_colour(i, 0, i, self.height, c_dkgray, c_dkgray);
                        draw_line_colour(0, i, self.width, i, c_dkgray, c_dkgray);
                    }
                    var tx = min(Stuff.terrain.tile_brush_x, Stuff.terrain.tile_brush_x + Stuff.terrain.tile_brush_w);
                    var ty = min(Stuff.terrain.tile_brush_y, Stuff.terrain.tile_brush_y + Stuff.terrain.tile_brush_h);
                    draw_sprite_stretched(spr_terrain_texture_selection, 0, tx, ty, abs(Stuff.terrain.tile_brush_w), abs(Stuff.terrain.tile_brush_h));
                    draw_rectangle_colour(1, 1, self.width - 2, self.height - 2, c_black, c_black, c_black, c_black, true);
                }, function(mx, my) {
                    mx -= view_get_xport(view_current);
                    my -= view_get_yport(view_current);
                    
                    if (!(is_clamped(mx, -16, self.width + 16) && is_clamped(my, -16, self.height + 16))) return;
                    
                    var tx1 = 16 * (mx div 16);
                    var ty1 = 16 * (my div 16);
                    var tx2 = 16 * ceil(mx / 16);
                    var ty2 = 16 * ceil(my / 16);
                    if (mouse_check_button_pressed(mb_left)) {
                        Stuff.terrain.tile_brush_x = tx1;
                        Stuff.terrain.tile_brush_y = ty1;
                        Stuff.terrain.tile_brush_w = 0;
                        Stuff.terrain.tile_brush_h = 0;
                    } else if (mouse_check_button(mb_left)) {
                        Stuff.terrain.tile_brush_w = tx2 - Stuff.terrain.tile_brush_x;
                        Stuff.terrain.tile_brush_h = ty2 - Stuff.terrain.tile_brush_y;
                    }
                }, null, null),
                new EmuButton(col1x, EMU_AUTO, col_width, 32, "Clear texture", function() {
                    var color_code = Stuff.terrain.GetTextureColorCode();
                    Stuff.terrain.texture.Clear(color_code & 0x00ffffff, (color_code >> 24) / 0xff);
                }),
            ]).SetOnClick(function() {
                Stuff.terrain.mode = TerrainModes.TEXTURE;
            }),
            (new EmuTab("Painting")).AddContent([
                (new EmuText(col1x, EMU_AUTO, col_width, 32, "Paint strength: " + string(mode.paint_strength)))
                    .SetID("PAINT_STENGTH_LABEL"),
                (new EmuProgressBar(col1x, EMU_AUTO, col_width, 32, 8, mode.paint_strength_min, mode.paint_strength_max, true, mode.paint_strength, function() {
                    Stuff.terrain.paint_strength = self.value;
                    self.GetSibling("PAINT_STENGTH_LABEL").text = "Paint strength: " + string(self.value);
                }))
                    .SetTooltip("A lower strength value will cause the color to blend with the existing color, and a greater one will cause it to replace the existing color."),
                (new EmuColorPicker(col1x, EMU_AUTO, col_width, 32, "Color:", mode.paint_color, function() {
                    Stuff.terrain.paint_color = self.value;
                }))
                    .SetTooltip("I really hope you enjoy this color picker because it was probably my favorite UI element to work on."),
                new EmuButton(col1x, EMU_AUTO, col_width, 32, "Clear color", function() {
                    Stuff.terrain.color.Clear(Stuff.terrain.paint_color);
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
                Stuff.terrain.mode = TerrainModes.COLOR;
            }),
        ])
    ]);
    
    return container;
}