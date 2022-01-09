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
                #region
                (new EmuText(col1x, EMU_AUTO, col_width, 32, "Width"))
                    .SetTextUpdate(function() { return "Width: " + string(Stuff.terrain.width + 1); })
                    .SetID("LABEL_WIDTH"),
                (new EmuText(col1x, EMU_AUTO, col_width, 32, "Height:"))
                    .SetTextUpdate(function() { return "Height: " + string(Stuff.terrain.height + 1); })
                    .SetID("LABEL_HEIGHT"),
                (new EmuCheckbox(col1x, EMU_AUTO, col_width, 32, "Orthographic?", mode.orthographic, function() {
                    Stuff.terrain.orthographic = self.value;
                }))
                    .SetInteractive(false)                                          // for now
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
                #endregion
            ]),
            (new EmuTab("Lighting")).AddContent([
                #region
                new EmuText(col1x, EMU_AUTO, col_width, 32, "I'll re-implement this later (hopefully soon)"),
                #endregion
            ]),
            (new EmuTab("Deform")).AddContent([
                #region
                new EmuButton(col1x, EMU_AUTO, col_width, 32, "Set Mode: Deform", function() {
                    Stuff.terrain.mode = TerrainModes.Z;
                }),
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
                #endregion
            ]),
            (new EmuTab("Texture")).AddContent([
                #region
                new EmuButton(col1x, EMU_AUTO, col_width, 32, "Set Mode: Texture", function() {
                    Stuff.terrain.mode = TerrainModes.COLOR;
                }),
                new EmuText(col1x, EMU_AUTO, col_width, 32, "I'll re-implement this later (hopefully soon)"),
                #endregion
            ]),
            (new EmuTab("Painting")).AddContent([
                #region
                new EmuButton(col1x, EMU_AUTO, col_width, 32, "Set Mode: Paint", function() {
                    Stuff.terrain.mode = TerrainModes.COLOR;
                }),
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
                    Stuff.terrain.color.brush_index = self.GetSelection();
                }))
                    .AddEntries([
                        "Pixel", "Disc", "Square", "Line", "Star", "Circle",
                        "Ring", "Sphere", "Flare", "Spark", "Explosion",
                        "Cloud", "Smoke", "Snow"
                    ])
                    .Select(mode.color.brush_index),
                #endregion
            ]),
        ])
    ]);
    
    return container;
    
    with (instance_create_depth(0, 0, 0, UIMain)) {
        #region tab: lights
        yy = legal_y + spacing;
        
        element = create_checkbox(legal_x + spacing, yy, "Light enabled?", col_width, element_height, function(checkbox) {
            Stuff.terrain.terrain_light_enabled = checkbox.value;
        }, mode.terrain_light_enabled, t_lighting);
        ds_list_add(t_lighting.contents, element);
        yy += element.height + spacing;
        
        element = create_color_picker(legal_x + spacing, yy, "Ambient:", col_width, element_height, function(picker) {
            Stuff.terrain.terrain_light_ambient = picker.value;
        }, mode.terrain_light_ambient, vx1, vy1, vx2, vy2, t_lighting);
        ds_list_add(t_lighting.contents, element);
        yy += element.height + spacing;
        
        element = create_list(legal_x + spacing, yy, "Terrain Lights", "", col_width, element_height, MAX_TERRAIN_LIGHTS, function(list) {
            var mode = Stuff.terrain;
            var tab = mode.ui.t_lighting;
            
            var light = mode.lights[ui_list_selection(list)];
            tab.el_light_type.value = light.type;
            tab.el_light_color.value = light.color;
            
            switch (light.type) {
                case LightTypes.DIRECTIONAL:
                    tab.el_dir_x.value = normalize(light.x, 0, 1, -0.5, 0.5);
                    tab.el_dir_y.value = normalize(light.y, 0, 1, -0.5, 0.5);
                    tab.el_dir_z.value = normalize(light.z, 0, 1, -0.5, 0.5);
                    break;
                case LightTypes.POINT:
                    ui_input_set_value(tab.el_point_x, light.x);
                    ui_input_set_value(tab.el_point_y, light.y);
                    ui_input_set_value(tab.el_point_z, light.z);
                    ui_input_set_value(tab.el_point_radius, light.radius);
                    break;
            }
            
            uivc_terrain_light_enable_by_type(list);
        }, false, t_lighting, mode.lights);
        element.allow_deselect = false;
        element.entries_are = ListEntries.SCRIPT;
        element.render_colors = function(list, index) {
            var light = list.entries[index];
            return (light.type == LightTypes.SPOT || light.type == LightTypes.NONE) ? c_gray : c_black;
        };
        element.evaluate_text = function(list, index) {
            var light = list.entries[index];
            switch (light.type) {
                case LightTypes.NONE:
                    return "<disabled light>";
                case LightTypes.POINT:
                    return "Point @ " + string(light.x) + "," + string(light.y) + "," + string(light.z) + " r: " + string(light.radius);
                case LightTypes.DIRECTIONAL:
                    return "Directional @ " + string(light.x) + "," + string(light.y) + "," + string(light.z);
                case LightTypes.SPOT:
                    return "Spot @ " + string(light.x) + "," + string(light.y) + "," + string(light.z) + " r: " + string(light.radius);
            }
            return "*";
        };
        ui_list_select(element, 0);
        ds_list_add(t_lighting.contents, element);
        t_lighting.el_light_list = element;
        yy += element.GetHeight() + spacing;
        
        element = create_checkbox(legal_x + spacing, yy, "Fog enabled?", col_width, element_height, function(checkbox) {
            Stuff.terrain.terrain_fog_enabled = checkbox.value;
        }, mode.terrain_fog_enabled, t_lighting);
        ds_list_add(t_lighting.contents, element);
        yy += element.height + spacing;
        
        element = create_color_picker(legal_x + spacing, yy, "Fog color:", col_width, element_height, function(picker) {
            Stuff.terrain.terrain_fog_color = picker.value;
        }, mode.terrain_fog_color, vx1, vy1, vx2, vy2, t_lighting);
        ds_list_add(t_lighting.contents, element);
        yy += element.height + spacing;
        
        element = create_input(legal_x + spacing, yy, "Start:", col_width, element_height, function(input) {
            Stuff.terrain.terrain_fog_start = real(input.value);
        }, mode.terrain_fog_start, "number", validate_double, -100000, 100000, 8, vx1, vy1, vx2, vy2, t_lighting);
        ds_list_add(t_lighting.contents, element);
        yy += element.height + spacing;
        
        element = create_input(legal_x + spacing, yy, "End:", col_width, element_height, function(input) {
            Stuff.terrain.terrain_fog_end = real(input.value);
        }, mode.terrain_fog_end, "number", validate_double, -100000, 100000, 8, vx1, vy1, vx2, vy2, t_lighting);
        ds_list_add(t_lighting.contents, element);
        yy += element.height + spacing;
        
        yy = legal_y + spacing;
        
        element = create_text(col2_x, yy, "Light Properties", col_width, element_height, fa_left, col_width, t_lighting);
        ds_list_add(t_lighting.contents, element);
        yy += element.height + spacing;
        
        element = create_radio_array(col2_x, yy, "Type", col_width, element_height, function(radio) {
            Stuff.terrain.lights[ui_list_selection(radio.root.root.el_light_list)].type = radio.value;
            uivc_terrain_light_enable_by_type(radio.root.root.el_light_list);
        }, 0, t_lighting);
        create_radio_array_options(element, ["None", "Direction", "Point", "Spot"]);
        element.contents[| 2].enabled = false;
        ds_list_add(t_lighting.contents, element);
        t_lighting.el_light_type = element;
        yy += element.GetHeight() + spacing;
        
        element = create_color_picker(col2_x, yy, "Color:", col_width, element_height, function(picker) {
            Stuff.terrain.lights[ui_list_selection(picker.root.el_light_list)].color = picker.value;
        }, c_white, vx1, vy1, vx2, vy2, t_lighting);
        ds_list_add(t_lighting.contents, element);
        t_lighting.el_light_color = element;
        yy += element.height + spacing;
        
        // directional light
        var yy_base = yy;
        
        element = create_text(col2_x, yy, "X component:", col_width, element_height, fa_left, col_width, t_lighting);
        element.enabled = false;
        ds_list_add(t_lighting.contents, element);
        t_lighting.el_dir_x_name = element;
        yy += element.height + spacing;
        
        element = create_progress_bar(col2_x, yy, col_width, element_height, function(bar) {
            var light = Stuff.terrain.lights[ui_list_selection(bar.root.el_light_list)];
            light.x = bar.value * 2 - 1;
            if (light.x == 0 && light.y == 0 && light.z == 0) {
                light.z = -1;
            }
        }, 4, 0.5, t_lighting);
        element.enabled = false;
        ds_list_add(t_lighting.contents, element);
        t_lighting.el_dir_x = element;
        yy += element.height + spacing;
        
        element = create_text(col2_x, yy, "Y component:", col_width, element_height, fa_left, col_width, t_lighting);
        element.enabled = false;
        ds_list_add(t_lighting.contents, element);
        t_lighting.el_dir_y_name = element;
        yy += element.height + spacing;
        
        element = create_progress_bar(col2_x, yy, col_width, element_height, function(bar) {
            var light = Stuff.terrain.lights[ui_list_selection(bar.root.el_light_list)];
            light.y = bar.value * 2 - 1;
            if (light.x == 0 && light.y == 0 && light.z == 0) {
                light.z = -1;
            }
        }, 4, 0.5, t_lighting);
        element.enabled = false;
        ds_list_add(t_lighting.contents, element);
        t_lighting.el_dir_y = element;
        yy += element.height + spacing;
        
        element = create_text(col2_x, yy, "Z component:", col_width, element_height, fa_left, col_width, t_lighting);
        element.enabled = false;
        ds_list_add(t_lighting.contents, element);
        t_lighting.el_dir_z_name = element;
        yy += element.height + spacing;
        
        element = create_progress_bar(col2_x, yy, col_width, element_height, function(bar) {
            var light = Stuff.terrain.lights[ui_list_selection(bar.root.el_light_list)];
            light.z = bar.value * 2 - 1;
        
            if (light.x == 0 && light.y == 0 && light.z == 0) {
                light.z = -1;
            }
        }, 4, 0.5, t_lighting);
        element.enabled = false;
        ds_list_add(t_lighting.contents, element);
        t_lighting.el_dir_z = element;
        yy += element.height + spacing;
        
        // point light
        yy = yy_base;
        
        element = create_input(col2_x, yy, "X:", col_width, element_height, function(input) {
            Stuff.terrain.lights[ui_list_selection(input.root.el_light_list)].x = real(input.value);
        }, 0, "number", validate_double, -1000, 100000, 8, vx1, vy1, vx2, vy2, t_lighting);
        element.enabled = false;
        ds_list_add(t_lighting.contents, element);
        t_lighting.el_point_x = element;
        yy += element.height + spacing;
        
        element = create_input(col2_x, yy, "Y:", col_width, element_height, function(input) {
            Stuff.terrain.lights[ui_list_selection(input.root.el_light_list)].y = real(input.value);
        }, 0, "number", validate_double, -1000, 100000, 8, vx1, vy1, vx2, vy2, t_lighting);
        element.enabled = false;
        ds_list_add(t_lighting.contents, element);
        t_lighting.el_point_y = element;
        yy += element.height + spacing;
        
        element = create_input(col2_x, yy, "Z:", col_width, element_height, function(input) {
            Stuff.terrain.lights[ui_list_selection(input.root.el_light_list)].z = real(input.value);
        }, 0, "number", validate_double, -1000, 100000, 8, vx1, vy1, vx2, vy2, t_lighting);
        element.enabled = false;
        ds_list_add(t_lighting.contents, element);
        t_lighting.el_point_z = element;
        yy += element.height + spacing;
        
        element = create_input(col2_x, yy, "Radius:", col_width, element_height, function(input) {
            Stuff.terrain.lights[ui_list_selection(input.root.el_light_list)].radius = real(input.value);
        }, 0, "number", validate_double, 0, 100000, 8, vx1, vy1, vx2, vy2, t_lighting);
        element.enabled = false;
        ds_list_add(t_lighting.contents, element);
        t_lighting.el_point_radius = element;
        yy += element.height + spacing;
        #endregion
        
        #region tab: texture
        yy = legal_y + spacing;
        
        element = create_button(legal_x + spacing, yy, "Set Mode: Texture", col_width, element_height, fa_center, function(button) {
            button.root.root.t_general.element_mode.value = TerrainModes.TEXTURE;
            Stuff.terrain.mode = TerrainModes.TEXTURE;
        }, t_general);
        ds_list_add(t_texture.contents, element);
        
        yy += element.height + spacing;
        
        element = create_button(legal_x + spacing, yy, "Save Texture", col_width, element_height, fa_center, function(button) {
            var terrain = Stuff.terrain;
            var fn = get_save_filename_image(terrain.texture_name);
            if (fn != "") {
                sprite_save(terrain.texture, 0, fn);
            }
        }, t_texture);
        ds_list_add(t_texture.contents, element);
        
        element = create_button(col2_x, yy, "Change Texture", col_width, element_height, fa_center, function(button) {
            var terrain = Stuff.terrain;
            var fn = get_open_filename_image();
            
            if (fn != "") {
                var sprite = sprite_add(fn, 0, false, false, 0, 0);
                if (sprite) {
                    sprite_delete(terrain.texture);
                    terrain.texture = sprite;
                    button.root.element_tile_selector.tileset = sprite;
                    terrain.texture_name = filename_name(fn);
                    button.root.element_texture_name.text = terrain.texture_name + " (" + string(terrain_texture_size) + " x " + string(terrain_texture_size) + ")";
                }
            }
        }, t_texture);
        ds_list_add(t_texture.contents, element);
        
        yy += element.height + spacing;
        
        element = create_text(legal_x + spacing, yy, mode.texture_name + " (" + string(terrain_texture_size) + " x " + string(terrain_texture_size) + ")", legal_width, element_height, fa_left, legal_width, t_texture);
        t_texture.element_texture_name = element;
        ds_list_add(t_texture.contents, element);
        
        yy += element.height + spacing;
        
        element = create_tile_selector(legal_x + spacing, yy, legal_width - spacing * 2, legal_width - spacing * 2, function(selector, x, y) {
            var terrain = Stuff.terrain;
            selector.tile_x = x;
            selector.tile_y = y;
            terrain.tile_brush_x = x * terrain_tile_size;
            terrain.tile_brush_y = y * terrain_tile_size;
        }, null, t_texture);
        element.tile_x = mode.tile_brush_x;
        element.tile_y = mode.tile_brush_y;
        element.tileset = mode.texture;
        t_texture.element_tile_selector = element;
        ds_list_add(t_texture.contents, element);
        
        yy += element.height + spacing;
        
        var yy_aftergrid = yy;
        
        element = create_button(legal_x + spacing, yy, "Clear Texture", col_width, element_height, fa_center, function(button) {
            Stuff.terrain.ClearTexture(Stuff.terrain.tile_brush_x, Stuff.terrain.tile_brush_y);
        }, t_general);
        ds_list_add(t_texture.contents, element);
        
        yy += element.height + spacing;
        #endregion
        
        return id;
    }
}