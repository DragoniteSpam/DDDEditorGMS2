function dialog_create_map_advanced() {
    var map = Stuff.map.active_map;
    
    var dialog = new EmuDialog(32 + 320 + 32 + 320 + 32 + 320 + 32, 736, "Advanced Map Settings");
    dialog.map = map;
    dialog.original_water_level = map.water_level;
    var element_width = 320;
    var element_height = 32;
    var indent = 32;
    
    var col1 = 32;
    var col2 = 32 + 320 + 32;
    var col3 = 32 + 320 + 32 + 320 + 32;
    
    return dialog.AddContent([
        new EmuText(col1, EMU_BASE, element_width, element_height, "[c_aqua]Atmosphere"),
        #region fog
        (new EmuCheckbox(col1, EMU_AUTO, element_width, element_height, "Fog enabled?", map.fog_enabled, function() {
            self.root.map.fog_enabled = self.value;
            self.GetSibling("FOG START").SetInteractive(self.value);
            self.GetSibling("FOG END").SetInteractive(self.value);
        }))
            .SetTooltip("Whether or not vertex fog should be enabled in the map."),
        (new EmuInput(col1 + indent, EMU_AUTO, element_width - indent, element_height, "Fog start:", map.fog_start, "fog start", 6, E_InputTypes.REAL, function() {
            self.root.map.fog_start = real(self.value);
        }))
            .SetRealNumberBounds(1, 0xffff)
            .SetInteractive(map.fog_enabled)
            .SetID("FOG START")
            .SetTooltip("The distance from the camera at which fog begins to become visible; this should be in world space units, not tiles (I recomment assuming 32 units = 1 tile)."),
        (new EmuInput(col1 + indent, EMU_AUTO, element_width - indent, element_height, "Fog end:", map.fog_end, "fog end", 6, E_InputTypes.REAL, function() {
            self.root.map.fog_end = real(self.value);
        }))
            .SetRealNumberBounds(1, 0xffff)
            .SetInteractive(map.fog_enabled)
            .SetID("FOG END")
            .SetTooltip("The distance from the camera at which fog completely obscures objects behind it; this should be in world space units, not tiles (I recomment assuming 32 units = 1 tile)."),
        (new EmuColorPicker(col1 + indent, EMU_AUTO, element_width - indent, element_height, "Fog color:", map.fog_colour, function() {
            self.root.map.fog_colour = self.value;
        }))
            .SetTooltip("The color of the fog; you will usually want this to be white or off-white, but sometimes it may be preferred to be some misc color"),
        #endregion
        #region lighting
        (new EmuCheckbox(col1, EMU_AUTO, element_width, element_height, "Lighting enabled?", map.light_enabled, function() {
            self.root.map.light_enabled = self.value;
            self.GetSibling("LIGHT PLAYER").SetInteractive(self.value);
            self.GetSibling("LIGHT DEFAULTS").SetInteractive(self.value);
        }))
            .SetTooltip("Whether or not vertex lighting should be enabled in the map"),
        (new EmuColorPicker(col1 + indent, EMU_AUTO, element_width - indent, element_height, "Ambient color:", map.light_ambient_colour, function() {
            self.root.map.light_ambient_colour = self.value;
        }))
            .SetTooltip("The color of unlit regions of the map; most of the time, this should be black"),
        (new EmuCheckbox(col1 + indent, EMU_AUTO, element_width - indent, element_height, "Player light enabled?", map.light_player_enabled, function() {
            self.root.map.light_player_enabled = self.value;
        }))
            .SetID("LIGHT PLAYER")
            .SetTooltip("Whether or not there should be a point light around the player on this map"),
        (new EmuButton(col1, EMU_AUTO, element_width, element_height, "Default Lights", function() {
            // this is otherwise identical to MapZone's edit script, but that's
            // already inserted into a generic zone edit script form and i
            // can't (read: won't) generalize it
            var dialog = new EmuDialog(32 + 320 + 32 + 320 + 32, 640, "Default Lights");
            var element_width = 320;
            var element_height = 32;
            
            var col1 = 32;
            var col2 = 32 + 320 + 32;
            
            return dialog.AddContent([
                (new EmuList(col1, EMU_BASE, element_width, element_height, "All lights:", element_height, 16, function() {
                    if (!self.root) return;
                
                    var selection = self.GetSelection();
                    var active_lights = self.GetSibling("LIST");
                    var active_selection = active_lights.GetSelection();
                
                    if (active_selection != -1 && selection != -1) {
                        Stuff.map.active_map.lights[active_selection] = self.At(selection).REFID;
                    }
                }))
                    .SetEntryTypes(E_ListEntryTypes.STRUCTS)
                    .SetList(ds_list_filter(Stuff.map.active_map.contents.all_entities, function(element) {
                        return ((element.etype_flags & ETypeFlags.ENTITY_EFFECT) >= ETypeFlags.ENTITY_EFFECT);
                    }))
                    .SetListColors(function(index) {
                        var effect = self.At(index);
                        return effect.com_light ? effect.com_light.label_colour : EMU_COLOR_INPUT_WARN;
                    })
                    .SetRefresh(function() {
                        var active_list = self.GetSibling("LIST");
                        var active_selection = active_list.GetSelection();
                        if (active_selection != -1 && self.GetSelection() != -1) {
                            Stuff.map.active_map.lights[active_selection] = self.GetSelectedItem().REFID;
                        }
                    })
                    .SetTooltip("Directional lights will be shown in green. Point lights will be shown in blue. I recommend giving, at the very least, all of your Light entities unique names. Deselecting this list will clear the active light index.")
                    .SetID("ALL LIGHTS"),
                (new EmuList(col2, EMU_BASE, element_width, element_height, "Active lights:", element_height, 14, function() {
                    if (!self.root) return;
                
                    var selection = self.GetSelection();
                    var all_lights = self.GetSibling("ALL LIGHTS");
                    all_lights.Deselect();
                    if (selection != -1) {
                        all_lights.Select(array_search(all_lights.entries, self.GetSelectedItem()));
                    }
                    self.root.Refresh();
                }))
                    .SetListColors(function(index) {
                        var effect = refid_get(self.At(index));
                        return (effect && effect.com_light) ? effect.com_light.label_colour : EMU_COLOR_INPUT_WARN;
                    })
                    .SetEntryTypes(E_ListEntryTypes.OTHER, function(index) {
                        var entity = refid_get(self.At(index));
                        return entity ? entity.name : "<none>";
                    })
                    .SetVacantText("no active lights")
                    .SetTooltip("Effects with no light component (eg if the light component has been removed) will be shown in red. One light will be reserved for the player at all times.")
                    .SetList(Stuff.map.active_map.lights)
                    .SetID("LIST"),
                (new EmuButton(col2, EMU_AUTO, element_width, element_height, "Clear", function() {
                    if (self.GetSibling("LIST").GetSelection() == -1) return;
                    Stuff.map.active_map.lights[self.GetSibling("LIST").GetSelection()] = NULL;
                    self.GetSibling("ALL LIGHTS").Deselect();
                }))
                    .SetID("CLEAR")
            
            ]).AddDefaultCloseButton();
        }))
            .SetID("LIGHT DEFAULTS")
            .SetTooltip("Choose which lights will be turned on by default in this map. Up to eight lights may be active at one time."),
        #endregion
        (new EmuCheckbox(col1, EMU_AUTO, element_width, element_height, "Indoor map?", map.indoors, function() {
            self.root.map.indoors = self.value;
        }))
            .SetTooltip("Whether or not the map is supposed to be indoors (or underground); this will have effects such as determining whether or not the atmosphere is to be drawn, or whether or not weather should be processed."),
        (new EmuCheckbox(col1, EMU_AUTO, element_width, element_height, "Water enabled?", map.draw_water, function() {
            self.root.map.draw_water = self.value;
            self.GetSibling("WATER REFLECTIONS").SetInteractive(self.value);
            self.GetSibling("WATER LEVEL").SetInteractive(self.value);
        }))
            .SetTooltip("Whether or not water should be rendered."),
        (new EmuCheckbox(col1 + indent, EMU_AUTO, element_width - indent, element_height, "Reflections enabled?", map.reflections_enabled, function() {
            self.root.map.reflections_enabled = self.value;
        }))
            .SetInteractive(map.draw_water)
            .SetID("WATER REFLECTIONS")
            .SetTooltip("Whether or not reflections will be shown; most of the time this should be turned off if you have the water level turned off, and it should probably be turned off if the map is marked as indoors, but you may choose otherwise."),
        (new EmuInput(col1 + indent, EMU_AUTO, element_width - indent, element_height, "Water level:", map.water_level * TILE_DEPTH, "how high the water is", 5, E_InputTypes.REAL, function() {
            self.root.map.water_level = real(self.value) / TILE_DEPTH;
        }))
            .SetInteractive(map.draw_water)
            .SetRealNumberBounds(0, (map.zz - 1) * TILE_DEPTH)
            .SetID("WATER LEVEL")
            .SetTooltip("The level of the water, in world space units."),
        new EmuText(col2, EMU_BASE, element_width, element_height, "[c_aqua]World"),
        (new EmuList(col2, EMU_AUTO, element_width, element_height, "Skybox:", element_height, 8, function() {
            if (!self.root) return;
            var selection = self.GetSelectedItem();
            self.root.map.skybox = selection ? selection.GUID : NULL;
        }))
            .SetList(Game.graphics.skybox)
            .Select(array_search(Game.graphics.tilesets, guid_get(map.skybox)))
            .SetEntryTypes(E_ListEntryTypes.STRUCTS)
            .SetTooltip("The skybox to be used by the map. Deselect to clear."),
        (new EmuList(col2, EMU_AUTO, element_width, element_height, "Water texture:", element_height, 8, function() {
            if (!self.root) return;
            var selection = self.GetSelectedItem();
            self.root.map.water_texture = selection ? selection.GUID : NULL;
        }))
            .SetList(Game.graphics.tilesets)
            .Select(array_search(Game.graphics.tilesets, guid_get(map.water_texture)))
            .SetEntryTypes(E_ListEntryTypes.STRUCTS)
            .SetTooltip("The water texture to be used by the map. Deselect to clear."),
        (new EmuInput(col3, EMU_BASE, element_width, element_height, "Chunk size:", map.chunk_size, "in cells", 5, E_InputTypes.INT, function() {
            self.root.map.chunk_size = real(self.value);
        }))
            .SetTooltip("The size of the chunks maps are broken up into for optimization purposes."),
        (new EmuCheckbox(col3, EMU_AUTO, element_width, element_height, "Can fast travel to?", map.fast_travel_to, function() {
            self.root.map.fast_travel_to = self.value;
        }))
            .SetTooltip("Should you be able to teleport into this map?"),
        (new EmuCheckbox(col3, EMU_AUTO, element_width, element_height, "Can fast travel from?", map.fast_travel_from, function() {
            self.root.map.fast_travel_from = self.value;
        }))
            .SetTooltip("Should you be able to teleport away from this map?"),
        (new EmuCheckbox(col3, EMU_AUTO, element_width, element_height, "Grid aligned?", map.on_grid, function() {
            self.root.map.on_grid = self.value;
        }))
            .SetInteractive(false)
            .SetTooltip("This setting is currently unavailable; in the future I may enable off-grid editing."),
        new EmuText(col3, EMU_AUTO, element_width, element_height, "[c_aqua]Update Ticker"),
        (new EmuInput(col3, EMU_AUTO, element_width, element_height, "Base rate:", map.base_encounter_rate, "0 to turn off", 5, E_InputTypes.REAL, function() {
            self.root.map.base_encounter_rate = string(self.value);
        }))
            .SetInteractive(false)
            .SetRealNumberBounds(0, 1000000)
            .SetTooltip("The base number of steps between random encounters; if movement is set to be off-grid, this can be approximated in tiles."),
        (new EmuInput(col3, EMU_AUTO, element_width, element_height, "Deviation:", map.base_encounter_rate, "standard deviation", 5, E_InputTypes.REAL, function() {
            self.root.map.base_encounter_rate = string(self.value);
        }))
            .SetInteractive(false)
            .SetRealNumberBounds(0, 1000000)
            .SetTooltip("The deviation in steps between random encounters; if movement is set to be off-grid, this can be approximated in tiles"),
    ]).AddDefaultCloseButton("Done", function() {
        if (self.root.map == Stuff.map.active_map && self.root.map != self.root.original_water_level) {
            batch_again();
        }
        emu_dialog_close_auto();
    });
}

function dialog_create_map_terrain() {
    var map = Stuff.map.active_map;
    
    var dialog = new EmuDialog(32 + 32 + 320 + 32 + 320 + 32 + 320 + 32 + 32, 768, "Map Terrain Settings");
    dialog.map = map;
    
    var element_width = 320;
    var element_height = 32;
    
    var col1 = 32;
    var col2 = 32 + 320 + 32;
    var col3 = 32 + 320 + 32 + 320 + 32;
    
    var gen_data = Game.nosave.map_terrain_gen;
    var gen_element_width = 320;
    var gen_element_height = 32;
    var gen_col1 = 32;
    var gen_col2 = 32 + 320 + 32;
    var gen_col3 = 32 + 320 + 32 + 320 + 32;
    
    dialog.AddContent([
        (new EmuTabGroup(col1, EMU_BASE, 32 + 320 + 32 + 320 + 32 + 320 + 32, dialog.height - 80, 1, element_height)).AddTabs(0, [
            new EmuTab("General").AddContent([
                new EmuText(col1, EMU_BASE, element_width, element_height, "[c_aqua]Base Properties"),
                (new EmuList(col1, EMU_AUTO, element_width, element_height, "Terrain:", element_height, 10, function() {
                    if (!self.root) return;
                    var selection = self.GetSelectedItem();
                    Stuff.map.active_map.terrain.id = selection ? selection.GUID : NULL;
                    self.root.root.root.Refresh();
                }))
                    .SetList(Game.mesh_terrain)
                    .Select(array_search(Game.mesh_terrain, guid_get(map.terrain.id)))
                    .SetEntryTypes(E_ListEntryTypes.STRUCTS)
                    .SetTooltip("The terrain model associated with this map."),
                (new EmuInput(col1, EMU_AUTO, element_width, element_height, "Scale:", string(map.terrain.scale), "The terrain scale", 2, E_InputTypes.INT, function() {
                    Stuff.map.active_map.terrain.scale = real(self.value);
                    self.root.Refresh();
                })),
                (new EmuText(col1, EMU_AUTO, element_width, element_height, "Dimensions:"))
                    .SetRefresh(function() {
                        var map_terrain = Stuff.map.active_map.terrain;
                        var terrain = guid_get(map_terrain.id);
                        if (terrain) {
                            self.text = "Dimensions: " + string(terrain.terrain_data.w * map_terrain.scale) + " x " + string(terrain.terrain_data.h * map_terrain.scale);
                        } else {
                            self.text = "Dimensions: N/A";
                        }
                    }),
                (new EmuText(col1, EMU_AUTO, element_width, element_height, "Vertical range:"))
                    .SetRefresh(function() {
                        var map_terrain = Stuff.map.active_map.terrain;
                        var terrain = guid_get(map_terrain.id);
                        if (terrain) {
                            self.text = "Vertical range: " + string(terrain.terrain_data.min_height * map_terrain.scale) + " to " + string(terrain.terrain_data.max_height * map_terrain.scale);
                        } else {
                            self.text = "Vertical range: N/A";
                        }
                    }),
            ]),
            (new EmuTab("Generation of Noise")).AddContent([
                #region Images
                (new EmuButton(gen_col1, EMU_AUTO, gen_element_width / 2, gen_element_height, "Generate", function() {
                    var terrain_mesh = guid_get(Stuff.map.active_map.terrain.id);
                    if (!terrain_mesh) return;
                    var terrain =  terrain_mesh.terrain_data;
                    var gen_data = Game.nosave.map_terrain_gen;
                    
                    var sprite_source = macaw_generate_dll(terrain.w, terrain.h, Game.nosave.map_terrain_gen.smoothness_r, 255);
                    if (gen_data.tex_r != -1) sprite_delete(gen_data.tex_r);
                    gen_data.tex_r = sprite_source.ToSpriteDLL();
                    sprite_source.Destroy();
                }))
                    .SetID("R"),
                (new EmuButton(gen_col1 + gen_element_width / 2, EMU_INLINE, gen_element_width / 2, gen_element_height, "Load...", function() {
                    var terrain_mesh = guid_get(Stuff.map.active_map.terrain.id);
                    if (!terrain_mesh) return;
                    var terrain =  terrain_mesh.terrain_data;
                    var gen_data = Game.nosave.map_terrain_gen;
                    
                    try {
                        var sprite = sprite_add(get_open_filename_image(), 1, false, false, 0, 0);
                        if (gen_data.tex_r != -1) sprite_delete(gen_data.tex_r);
                        gen_data.tex_r = sprite;
                    } catch (e) {
                        // guess you cant load that sprite
                    }
                })),
                (new EmuRenderSurface(gen_col1, EMU_AUTO, gen_data.tex_size, gen_data.tex_size, function() {
                    var gen_data = Game.nosave.map_terrain_gen;
                    if (gen_data.tex_r != -1) {
                        shader_set(shd_utility_banding);
                        banding_enable(Game.nosave.map_terrain_gen.bands_r);
                        draw_sprite_stretched_ext(gen_data.tex_r, 0, 0, 0, self.width, self.height, c_red, 1);
                        banding_disable();
                        shader_reset();
                        scribble("[FDefaultOutline]" + string(sprite_get_width(gen_data.tex_r)) + " x " + string(sprite_get_height(gen_data.tex_r))).draw(10, 28);
                    }
                    scribble("[FDefaultOutline]Temperature (red)").draw(10, 10);
                }, emu_null)),
                (new EmuButton(gen_col1, EMU_AUTO, gen_element_width / 2, gen_element_height, "Generate", function() {
                    var terrain_mesh = guid_get(Stuff.map.active_map.terrain.id);
                    if (!terrain_mesh) return;
                    var terrain =  terrain_mesh.terrain_data;
                    var gen_data = Game.nosave.map_terrain_gen;
                    
                    var sprite_source = macaw_generate_dll(terrain.w, terrain.h, Game.nosave.map_terrain_gen.smoothness_g, 255);
                    if (gen_data.tex_g != -1) sprite_delete(gen_data.tex_g);
                    gen_data.tex_g = sprite_source.ToSpriteDLL();
                    sprite_source.Destroy();
                }))
                    .SetID("G"),
                (new EmuButton(gen_col1 + gen_element_width / 2, EMU_INLINE, gen_element_width / 2, gen_element_height, "Load...", function() {
                    var terrain_mesh = guid_get(Stuff.map.active_map.terrain.id);
                    if (!terrain_mesh) return;
                    var terrain =  terrain_mesh.terrain_data;
                    var gen_data = Game.nosave.map_terrain_gen;
                    
                    try {
                        var sprite = sprite_add(get_open_filename_image(), 1, false, false, 0, 0);
                        if (gen_data.tex_g != -1) sprite_delete(gen_data.tex_g);
                        gen_data.tex_g = sprite;
                    } catch (e) {
                        // guess you cant load that sprite
                    }
                })),
                (new EmuRenderSurface(gen_col1, EMU_AUTO, gen_data.tex_size, gen_data.tex_size, function() {
                    var gen_data = Game.nosave.map_terrain_gen;
                    if (gen_data.tex_g != -1) {
                        shader_set(shd_utility_banding);
                        banding_enable(Game.nosave.map_terrain_gen.bands_g);
                        draw_sprite_stretched_ext(gen_data.tex_g, 0, 0, 0, self.width, self.height, c_lime, 1);
                        banding_disable();
                        shader_reset();
                        scribble("[FDefaultOutline]" + string(sprite_get_width(gen_data.tex_g)) + " x " + string(sprite_get_height(gen_data.tex_g))).draw(10, 28);
                    }
                    scribble("[FDefaultOutline]Precipitation (green)").draw(10, 10);
                }, emu_null)),
                (new EmuButton(gen_col2, EMU_BASE, gen_element_width / 2, gen_element_height, "Generate", function() {
                    var terrain_mesh = guid_get(Stuff.map.active_map.terrain.id);
                    if (!terrain_mesh) return;
                    var terrain =  terrain_mesh.terrain_data;
                    var gen_data = Game.nosave.map_terrain_gen;
                    
                    var sprite_source = macaw_generate_dll(terrain.w, terrain.h, Game.nosave.map_terrain_gen.smoothness_b, 255);
                    if (gen_data.tex_b != -1) sprite_delete(gen_data.tex_b);
                    gen_data.tex_b = sprite_source.ToSpriteDLL();
                    sprite_source.Destroy();
                }))
                    .SetID("B"),
                (new EmuButton(gen_col2 + gen_element_width / 2, EMU_INLINE, gen_element_width / 2, gen_element_height, "Load...", function() {
                    var terrain_mesh = guid_get(Stuff.map.active_map.terrain.id);
                    if (!terrain_mesh) return;
                    var terrain =  terrain_mesh.terrain_data;
                    var gen_data = Game.nosave.map_terrain_gen;
                    
                    try {
                        var sprite = sprite_add(get_open_filename_image(), 1, false, false, 0, 0);
                        if (gen_data.tex_b != -1) sprite_delete(gen_data.tex_b);
                        gen_data.tex_b = sprite;
                    } catch (e) {
                        // guess you cant load that sprite
                    }
                })),
                (new EmuRenderSurface(gen_col2, EMU_AUTO, gen_data.tex_size, gen_data.tex_size, function() {
                    var gen_data = Game.nosave.map_terrain_gen;
                    if (gen_data.tex_b != -1) {
                        shader_set(shd_utility_banding);
                        banding_enable(Game.nosave.map_terrain_gen.bands_b);
                        draw_sprite_stretched_ext(gen_data.tex_b, 0, 0, 0, self.width, self.height, c_blue, 1);
                        banding_disable();
                        shader_reset();
                        scribble("[FDefaultOutline]" + string(sprite_get_width(gen_data.tex_b)) + " x " + string(sprite_get_height(gen_data.tex_b))).draw(10, 28);
                    }
                    scribble("[FDefaultOutline]Other (blue)").draw(10, 10);
                }, emu_null)),
                (new EmuButton(gen_col2, EMU_AUTO, gen_element_width, gen_element_height, "Generate All", function() {
                    self.GetSibling("R").callback();
                    self.GetSibling("G").callback();
                    self.GetSibling("B").callback();
                })),
                (new EmuRenderSurface(gen_col2, EMU_AUTO, gen_data.tex_size, gen_data.tex_size, function() {
                    var gen_data = Game.nosave.map_terrain_gen;
                    draw_sprite_combine_channels(
                        gen_data.tex_r, gen_data.tex_g, gen_data.tex_b, self.width, self.height,
                        Game.nosave.map_terrain_gen.bands_r, Game.nosave.map_terrain_gen.bands_g, Game.nosave.map_terrain_gen.bands_b
                    );
                }, emu_null)),
                #endregion
                new EmuText(gen_col3, EMU_BASE, gen_element_width, gen_element_height, "[c_aqua]Smoothness"),
                new EmuText(gen_col3, EMU_AUTO, gen_element_width / 2, gen_element_height, "Temperature:"),
                (new EmuProgressBar(gen_col3 + gen_element_width / 2, EMU_INLINE, gen_element_width / 2, gen_element_height, 8, 4, 10, true, 8, function() {
                    Game.nosave.map_terrain_gen.smoothness_r = self.value;
                }))
                    .SetIntegersOnly(true),
                (new EmuInput(gen_col3, EMU_AUTO, gen_element_width, gen_element_height, "Bands:", "255", "", 3, E_InputTypes.INT, function() {
                    Game.nosave.map_terrain_gen.bands_r = self.value;
                }))
                    .SetRealNumberBounds(2, 255)
                    .SetID("BANDS R"),
                new EmuButton(gen_col3 + 0 * gen_element_width / 3, EMU_AUTO, gen_element_width / 3, gen_element_height, "4", function() {
                    self.GetSibling("BANDS R").SetValue("4");
                    Game.nosave.map_terrain_gen.bands_r = 4;
                }),
                new EmuButton(gen_col3 + 1 * gen_element_width / 3, EMU_INLINE, gen_element_width / 3, gen_element_height, "8", function() {
                    self.GetSibling("BANDS R").SetValue("8");
                    Game.nosave.map_terrain_gen.bands_r = 8;
                }),
                new EmuButton(gen_col3 + 2 * gen_element_width / 3, EMU_INLINE, gen_element_width / 3, gen_element_height, "All", function() {
                    self.GetSibling("BANDS R").SetValue("255");
                    Game.nosave.map_terrain_gen.bands_r = 255;
                }),
                new EmuText(gen_col3, EMU_AUTO, gen_element_width / 2, gen_element_height, "Precipitation:"),
                (new EmuProgressBar(gen_col3 + gen_element_width / 2, EMU_INLINE, gen_element_width / 2, gen_element_height, 8, 4, 10, true, 8, function() {
                    Game.nosave.map_terrain_gen.smoothness_g = self.value;
                }))
                    .SetIntegersOnly(true),
                (new EmuInput(gen_col3, EMU_AUTO, gen_element_width, gen_element_height, "Bands:", "255", "", 3, E_InputTypes.INT, function() {
                    Game.nosave.map_terrain_gen.bands_g = self.value;
                }))
                    .SetRealNumberBounds(2, 255)
                    .SetID("BANDS G"),
                new EmuButton(gen_col3 + 0 * gen_element_width / 3, EMU_AUTO, gen_element_width / 3, gen_element_height, "4", function() {
                    self.GetSibling("BANDS G").SetValue("4");
                    Game.nosave.map_terrain_gen.bands_g = 4;
                }),
                new EmuButton(gen_col3 + 1 * gen_element_width / 3, EMU_INLINE, gen_element_width / 3, gen_element_height, "8", function() {
                    self.GetSibling("BANDS G").SetValue("8");
                    Game.nosave.map_terrain_gen.bands_g = 8;
                }),
                new EmuButton(gen_col3 + 2 * gen_element_width / 3, EMU_INLINE, gen_element_width / 3, gen_element_height, "All", function() {
                    self.GetSibling("BANDS G").SetValue("255");
                    Game.nosave.map_terrain_gen.bands_g = 255;
                }),
                new EmuText(gen_col3, EMU_AUTO, gen_element_width / 2, gen_element_height, "Other:"),
                (new EmuProgressBar(gen_col3 + gen_element_width / 2, EMU_INLINE, gen_element_width / 2, gen_element_height, 8, 4, 10, true, 8, function() {
                    Game.nosave.map_terrain_gen.smoothness_b = self.value;
                }))
                    .SetIntegersOnly(true),
                (new EmuInput(gen_col3, EMU_AUTO, gen_element_width, gen_element_height, "Bands:", "255", "", 3, E_InputTypes.INT, function() {
                    Game.nosave.map_terrain_gen.bands_b = self.value;
                }))
                    .SetRealNumberBounds(2, 255)
                    .SetID("BANDS B"),
                new EmuButton(gen_col3 + 0 * gen_element_width / 3, EMU_AUTO, gen_element_width / 3, gen_element_height, "4", function() {
                    self.GetSibling("BANDS B").SetValue("4");
                    Game.nosave.map_terrain_gen.bands_b = 4;
                }),
                new EmuButton(gen_col3 + 1 * gen_element_width / 3, EMU_INLINE, gen_element_width / 3, gen_element_height, "8", function() {
                    self.GetSibling("BANDS B").SetValue("8");
                    Game.nosave.map_terrain_gen.bands_b = 8;
                }),
                new EmuButton(gen_col3 + 2 * gen_element_width / 3, EMU_INLINE, gen_element_width / 3, gen_element_height, "All", function() {
                    self.GetSibling("BANDS B").SetValue("255");
                    Game.nosave.map_terrain_gen.bands_b = 255;
                }),
            ]),
            (new EmuTab("Generation of Content")).AddContent([
                new EmuText(col1, EMU_BASE, element_width, element_height, "[c_aqua]Spawned Objects"),
                (new EmuList(col1, EMU_AUTO, element_width, element_height, "Meshes:", element_height, 16, function() {
                    if (!self.root) return;
                    
                    var choice = self.GetSibling("CHOICES").GetSelectedItem();
                    var mesh = self.GetSelectedItem();
                    
                    if (choice && mesh) {
                        choice.mesh = mesh.GUID;
                        choice.name = mesh.name;
                    }
                }))
                    .SetRefresh(function() {
                        var choice = self.GetSibling("CHOICES").GetSelectedItem();
                        if (choice) {
                            self.Deselect();
                            self.Select(array_search(Game.meshes, guid_get(choice.mesh)));
                        }
                    })
                    .SetList(Game.meshes)
                    .SetMultiSelect(true)
                    .SetAllowDeselect(false)
                    .SetEntryTypes(E_ListEntryTypes.STRUCTS)
                    .SetID("MESHES"),
                (new EmuList(col2, EMU_BASE, element_width, element_height, "Generation Choices:", element_height, 8, function() {
                    if (!self.root) return;
                    self.root.Refresh();
                }))
                    .SetList(Game.nosave.map_terrain_gen.choices)
                    .SetEntryTypes(E_ListEntryTypes.STRUCTS)
                    .SetID("CHOICES"),
                (new EmuButton(col2, EMU_AUTO, element_width, element_height, "Add Choice", function() {
                    static generation_choice = function(mesh) constructor {
                        self.mesh = mesh ? mesh.GUID : NULL;
                        self.name = mesh ? mesh.name : "(mesh N/A)";
                        self.weight = 100;
                        
                        // if you wanted to, you COULD weigh each mesh based on
                        // the attributes of the chosen position, but that would
                        // be a lot of extra work, and also very slow
                        self.temperature = { enabled: -1, cluster: 0.5, falloff: 0.25 };
                        self.precipitation = { enabled: -1, cluster: 0.5, falloff: 0.25 };
                        self.misc = { enabled: -1, cluster: 0.5, falloff: 0.25 };
                        self.elevation = { enabled: -1, cluster: 128, falloff: 80 };
                        
                        self.spawn = {
                            textures: [],
                            offset: {
                                min_x: 0, min_y: 0, min_z: 0,
                                max_x: 0, max_y: 0, max_z: 0,
                            },
                            rotation: {
                                min_x: 0, min_y: 0, min_z: 0,
                                max_x: 0, max_y: 0, max_z: 0,
                            },
                            scale: {
                                min_scale: 1, max_scale: 1
                            },
                        };
                    };
                    
                    array_push(Game.nosave.map_terrain_gen.choices, new generation_choice(self.GetSibling("MESHES").GetSelectedItem()));
                    
                    if (!self.GetSibling("CHOICES").GetSelectedItem()) {
                        self.GetSibling("CHOICES").Select(array_length(Game.nosave.map_terrain_gen.choices) - 1);
                    }
                    
                    self.root.Refresh();
                })),
                (new EmuButton(col2, EMU_AUTO, element_width, element_height, "Delete Choice", function() {
                    var list = self.GetSibling("CHOICES");
                    var index = list.GetSelection();
                    array_delete(Game.nosave.map_terrain_gen.choices, index, 1);
                    if (index == array_length(Game.nosave.map_terrain_gen.choices)) {
                        list.Deselect();
                    }
                    self.root.Refresh();
                }))
                    .SetInteractive(false)
                    .SetRefresh(function() {
                        self.SetInteractive(!!self.GetSibling("CHOICES").GetSelectedItem());
                    }),
                new EmuText(col2, EMU_AUTO, gen_element_width, gen_element_height, "[c_aqua]Generation"),
                (new EmuInput(col2, EMU_AUTO, gen_element_width / 2, gen_element_height, "Density:", "4", "Density", 4, E_InputTypes.INT, emu_null))
                    .SetRealNumberBounds(1, 9999)
                    .SetID("GEN DENSITY"),
                (new EmuInput(col2 + gen_element_width / 2, EMU_INLINE, gen_element_width / 3, gen_element_height, "  /", "400", "Area", 4, E_InputTypes.INT, emu_null))
                    .SetRealNumberBounds(1, 9999)
                    .SetID("GEN AREA"),
                new EmuText(col2 + gen_element_width * 5 / 6, EMU_INLINE, gen_element_width / 6, gen_element_height, "m²"),
                (new EmuButton(col2, EMU_AUTO, gen_element_width, gen_element_height, "Generate", function() {
                    var map = Stuff.map.active_map;
                    var terrain = guid_get(map.terrain.id).terrain_data;
                    var density = real(self.GetSibling("GEN DENSITY").value) / real(self.GetSibling("GEN AREA").value);
                    var area = terrain.w * terrain.h * power(map.terrain.scale, 2) / (TILE_WIDTH * TILE_HEIGHT);
                    
                    map_generate_contents(density * area, Game.nosave.map_terrain_gen.choices);
                }))
                    .SetInteractive(false)
                    .SetRefresh(function() {
                        self.SetInteractive(!!guid_get(Stuff.map.active_map.terrain.id));
                        if (!guid_get(Stuff.map.active_map.terrain.id)) return;
                        
                        // at least one of the choices needs to have a valid mesh
                        self.SetInteractive(false);
                        var choices = Game.nosave.map_terrain_gen.choices;
                        for (var i = 0, n = array_length(choices); i < n; i++) {
                            if (guid_get(choices[i].mesh)) {
                                self.SetInteractive(true);
                                return;
                            }
                        }
                    }),
                new EmuText(col3, EMU_BASE, element_width, element_height, "[c_aqua]Weighted Odds"),
                (new EmuInput(col3, EMU_AUTO, element_width, element_height, "Spawn weight:", "100", "Relative spawn odds", 4, E_InputTypes.INT, function() {
                    var choice = self.GetSibling("CHOICES").GetSelectedItem();
                    choice.weight = string(self.value);
                }))
                    .SetRealNumberBounds(1, 10000)
                    .SetInteractive(false)
                    .SetRefresh(function() {
                        var choice = self.GetSibling("CHOICES").GetSelectedItem();
                        self.SetInteractive(!!choice);
                        if (!choice) return;
                        self.SetValue(choice.weight);
                    }),
                new EmuText(col3, EMU_AUTO, element_width, element_height, "[c_aqua]Spawn Clustering"),
                (new EmuCheckbox(col3, EMU_AUTO, element_width / 6, element_height, "", false, function() {
                    var choice = self.GetSibling("CHOICES").GetSelectedItem();
                    choice.temperature.enabled = self.value;
                    self.root.Refresh();
                }))
                    .SetRefresh(function() {
                        var choice = self.GetSibling("CHOICES").GetSelectedItem();
                        self.SetInteractive(!!choice);
                        if (!choice) return;
                        self.SetValue(choice.temperature.enabled);
                    })
                    .SetInteractive(false),
                (new EmuInput(col3 + element_width / 6, EMU_INLINE, element_width * 5 / 6, element_height, "Temperature:", "0.5", "0...1", 4, E_InputTypes.REAL, function() {
                    var choice = self.GetSibling("CHOICES").GetSelectedItem();
                    choice.temperature.cluster = string(self.value);
                }))
                    .SetInteractive(false)
                    .SetRefresh(function() {
                        var choice = self.GetSibling("CHOICES").GetSelectedItem();
                        self.SetInteractive(!!choice && choice.temperature.enabled);
                        if (!choice) return;
                        self.SetValue(choice.temperature.cluster);
                    })
                    .SetID("CLUSTER TEMPERATURE"),
                (new EmuInput(col3 + element_width / 6, EMU_AUTO, element_width * 5 / 6, element_height, "Falloff:", "0.25", "0.01...1.0", 3, E_InputTypes.REAL, function() {
                    var choice = self.GetSibling("CHOICES").GetSelectedItem();
                    choice.temperature.falloff = string(self.value);
                }))
                    .SetRealNumberBounds(0.01, 1)
                    .SetInteractive(false)
                    .SetRefresh(function() {
                        var choice = self.GetSibling("CHOICES").GetSelectedItem();
                        self.SetInteractive(!!choice && choice.temperature.enabled);
                        if (!choice) return;
                        self.SetValue(choice.temperature.falloff);
                    })
                    .SetID("CLUSTER TEMPERATURE FALLOFF"),
                (new EmuCheckbox(col3, EMU_AUTO, element_width / 6, element_height, "", false, function() {
                    var choice = self.GetSibling("CHOICES").GetSelectedItem();
                    choice.precipitation.enabled = self.value;
                    self.root.Refresh();
                }))
                    .SetRefresh(function() {
                        var choice = self.GetSibling("CHOICES").GetSelectedItem();
                        self.SetInteractive(!!choice);
                        if (!choice) return;
                        self.SetValue(choice.precipitation.enabled);
                    })
                    .SetInteractive(false),
                (new EmuInput(col3 + element_width / 6, EMU_INLINE, element_width * 5 / 6, element_height, "Precipitation:", "0.5", "0...1", 4, E_InputTypes.REAL, function() {
                    var choice = self.GetSibling("CHOICES").GetSelectedItem();
                    choice.precipitation.cluster = string(self.value);
                }))
                    .SetInteractive(false)
                    .SetRefresh(function() {
                        var choice = self.GetSibling("CHOICES").GetSelectedItem();
                        self.SetInteractive(!!choice && choice.precipitation.enabled);
                        if (!choice) return;
                        self.SetValue(choice.precipitation.cluster);
                    })
                    .SetID("CLUSTER PRECIPITATION"),
                (new EmuInput(col3 + element_width / 6, EMU_AUTO, element_width * 5 / 6, element_height, "Falloff:", "0.25", "0.01...1.0", 3, E_InputTypes.REAL, function() {
                    var choice = self.GetSibling("CHOICES").GetSelectedItem();
                    choice.precipitation.falloff = string(self.value);
                }))
                    .SetRealNumberBounds(0.01, 1)
                    .SetInteractive(false)
                    .SetRefresh(function() {
                        var choice = self.GetSibling("CHOICES").GetSelectedItem();
                        self.SetInteractive(!!choice && choice.precipitation.enabled);
                        if (!choice) return;
                        self.SetValue(choice.precipitation.falloff);
                    })
                    .SetID("CLUSTER PRECIPITATION FALLOFF"),
                (new EmuCheckbox(col3, EMU_AUTO, element_width / 6, element_height, "", false, function() {
                    var choice = self.GetSibling("CHOICES").GetSelectedItem();
                    choice.misc.enabled = self.value;
                    self.root.Refresh();
                }))
                    .SetRefresh(function() {
                        var choice = self.GetSibling("CHOICES").GetSelectedItem();
                        self.SetInteractive(!!choice);
                        if (!choice) return;
                        self.SetValue(choice.misc.enabled);
                    })
                    .SetInteractive(false),
                (new EmuInput(col3 + element_width / 6, EMU_INLINE, element_width * 5 / 6, element_height, "Misc:", "0.5", "0...1", 4, E_InputTypes.REAL, function() {
                    var choice = self.GetSibling("CHOICES").GetSelectedItem();
                    choice.misc.cluster = string(self.value);
                }))
                    .SetInteractive(false)
                    .SetRefresh(function() {
                        var choice = self.GetSibling("CHOICES").GetSelectedItem();
                        self.SetInteractive(!!choice && choice.misc.enabled);
                        if (!choice) return;
                        self.SetValue(choice.misc.cluster);
                    })
                    .SetID("CLUSTER OTHER"),
                (new EmuInput(col3 + element_width / 6, EMU_AUTO, element_width * 5 / 6, element_height, "Falloff:", "0.25", "0.01...1.0", 3, E_InputTypes.REAL, function() {
                    var choice = self.GetSibling("CHOICES").GetSelectedItem();
                    choice.misc.falloff = string(self.value);
                }))
                    .SetRealNumberBounds(0.01, 1)
                    .SetInteractive(false)
                    .SetRefresh(function() {
                        var choice = self.GetSibling("CHOICES").GetSelectedItem();
                        self.SetInteractive(!!choice && choice.misc.enabled);
                        if (!choice) return;
                        self.SetValue(choice.misc.falloff);
                    })
                    .SetID("CLUSTER MISC FALLOFF"),
                (new EmuCheckbox(col3, EMU_AUTO, element_width / 6, element_height, "", false, function() {
                    var choice = self.GetSibling("CHOICES").GetSelectedItem();
                    choice.elevation.enabled = self.value;
                    if (!self.value) self.GetSibling("CLUSTER ELEVATION").SetValue("0.5");
                    self.root.Refresh();
                }))
                    .SetRefresh(function() {
                        var choice = self.GetSibling("CHOICES").GetSelectedItem();
                        self.SetInteractive(!!choice);
                        if (!choice) return;
                        self.SetValue(choice.elevation.enabled);
                    })
                    .SetInteractive(false),
                (new EmuInput(col3 + element_width / 6, EMU_INLINE, element_width * 5 / 6, element_height, "Elevation:", "0.5", "0...9999", 4, E_InputTypes.REAL, function() {
                    var choice = self.GetSibling("CHOICES").GetSelectedItem();
                    choice.elevation.cluster = string(self.value);
                }))
                    .SetRealNumberBounds(0, 9999)
                    .SetInteractive(false)
                    .SetRefresh(function() {
                        var choice = self.GetSibling("CHOICES").GetSelectedItem();
                        self.SetInteractive(!!choice && choice.elevation.enabled);
                        if (!choice) return;
                        self.SetValue(choice.elevation.cluster);
                    })
                    .SetID("CLUSTER ELEVATION"),
                (new EmuInput(col3 + element_width / 6, EMU_AUTO, element_width * 5 / 6, element_height, "Falloff:", "80", "1...999", 3, E_InputTypes.REAL, function() {
                    var choice = self.GetSibling("CHOICES").GetSelectedItem();
                    choice.elevation.falloff = string(self.value);
                }))
                    .SetRealNumberBounds(0, 999)
                    .SetInteractive(false)
                    .SetRefresh(function() {
                        var choice = self.GetSibling("CHOICES").GetSelectedItem();
                        self.SetInteractive(!!choice && choice.elevation.enabled);
                        if (!choice) return;
                        self.SetValue(choice.elevation.falloff);
                    })
                    .SetID("CLUSTER ELEVATION FALLOFF"),
                (new EmuButton(gen_col3, EMU_AUTO, gen_element_width, gen_element_height, "Advanced Settings", function() {
                    var dialog = new EmuDialog(32 + 320 + 32 + 320 + 32, 640, "Advanced settings");
                    var choice = self.GetSibling("CHOICES").GetSelectedItem();
                    dialog.choice = choice;
                    
                    var element_width = 320;
                    var element_height = 32;
                    
                    var col1 = 32;
                    var col2 = 32 + 320 + 32;
                    
                    return dialog.AddContent([
                        new EmuText(col1, EMU_AUTO, element_width, element_height, "[c_aqua]Parameters"),
                        (new EmuInput(col1, EMU_AUTO, element_width * 2 / 3, element_height, "Position:", choice.spawn.offset.min_x, "cells", 3, E_InputTypes.REAL, function() {
                            self.root.choice.spawn.offset.min_x = real(self.value);
                        }))
                            .SetRealNumberBounds(-6, 6)
                            .SetNext("OFF MAX X")
                            .SetPrevious("OFF MAX Z")
                            .SetID("OFF MIN X"),
                        (new EmuInput(col1 + element_width * 2 / 3, EMU_INLINE, element_width / 3, element_height, "", choice.spawn.offset.max_x, "cells", 3, E_InputTypes.REAL, function() {
                            self.root.choice.spawn.offset.max_x = real(self.value);
                        }))
                            .SetInputBoxPosition(0, 0)
                            .SetRealNumberBounds(-6, 6)
                            .SetNext("OFF MIN Y")
                            .SetPrevious("OFF MIN X")
                            .SetID("OFF MAX X"),
                        (new EmuInput(col1, EMU_AUTO, element_width * 2 / 3, element_height, "Y:", choice.spawn.offset.min_y, "cells", 3, E_InputTypes.REAL, function() {
                            self.root.choice.spawn.offset.min_y = real(self.value);
                        }))
                            .SetRealNumberBounds(-6, 6)
                            .SetNext("OFF MAX Y")
                            .SetPrevious("OFF MAX X")
                            .SetID("OFF MIN Y"),
                        (new EmuInput(col1 + element_width * 2 / 3, EMU_INLINE, element_width / 3, element_height, "", choice.spawn.offset.max_y, "cells", 3, E_InputTypes.REAL, function() {
                            self.root.choice.spawn.offset.max_y = real(self.value);
                        }))
                            .SetInputBoxPosition(0, 0)
                            .SetRealNumberBounds(-6, 6)
                            .SetNext("OFF MIN Z")
                            .SetPrevious("OFF MIN Y")
                            .SetID("OFF MAX Y"),
                        (new EmuInput(col1, EMU_AUTO, element_width * 2 / 3, element_height, "Z:", choice.spawn.offset.min_z, "cells", 3, E_InputTypes.REAL, function() {
                            self.root.choice.spawn.offset.min_z = real(self.value);
                        }))
                            .SetRealNumberBounds(-6, 6)
                            .SetNext("OFF MAX Z")
                            .SetPrevious("OFF MAX Y")
                            .SetID("OFF MIN Z"),
                        (new EmuInput(col1 + element_width * 2 / 3, EMU_INLINE, element_width / 3, element_height, "", choice.spawn.offset.max_z, "cells", 3, E_InputTypes.REAL, function() {
                            self.root.choice.spawn.offset.max_z = real(self.value);
                        }))
                            .SetInputBoxPosition(0, 0)
                            .SetRealNumberBounds(-6, 6)
                            .SetNext("OFF MIN X")
                            .SetPrevious("OFF MIN Z")
                            .SetID("OFF MAX Z"),
                        (new EmuList(col1, EMU_AUTO, element_width, element_height, "Available Textures:", element_height, 8, function() {
                            if (!self.root) return;
                            var selection = self.GetSibling("TEXTURES").GetSelection();
                            if (selection != -1 && self.GetSelection() != -1) {
                                self.root.choice.spawn.textures[selection] = self.GetSelectedItem().GUID;
                            }
                        }))
                            .SetRefresh(function() {
                                var selection = self.GetSibling("TEXTURES").GetSelectedItem();
                                if (selection != undefined) {
                                    self.Deselect();
                                    self.Select(array_search(Game.graphics.tilesets, guid_get(selection)));
                                }
                            })
                            .SetEntryTypes(E_ListEntryTypes.STRUCTS)
                            .SetList(Game.graphics.tilesets)
                            .SetID("AVAILABLE TEXTURES"),
                        (new EmuList(col2, EMU_BASE, element_width, element_height, "Selected Textures:", element_height, 12, function() {
                            if (!self.root) return;
                            self.root.Refresh();
                        }))
                            .SetList(choice.spawn.textures)
                            .SetEntryTypes(E_ListEntryTypes.OTHER, function(index) {
                                return guid_get(self.At(index)) ? guid_get(self.At(index)).name : "(none)";
                            })
                            .SetID("TEXTURES"),
                        (new EmuButton(col2, EMU_AUTO, element_width, element_height, "Add", function() {
                            var selection = self.GetSibling("AVAILABLE TEXTURES").GetSelectedItem();
                            array_push(self.root.choice.spawn.textures, selection ? selection.GUID : NULL);
                            if (!self.GetSibling("TEXTURES").GetSelectedItem()) {
                                self.GetSibling("TEXTURES").Select(array_length(self.root.choice.spawn.textures) - 1, true);
                            }
                        })),
                        (new EmuButton(col2, EMU_AUTO, element_width, element_height, "Delete", function() {
                            var selection = self.GetSibling("TEXTURES").GetSelectedItem();
                            array_delete(self.root.choice.spawn.textures, selection, 1);
                            if (selection >= array_length(self.root.choice.spawn.textures)) {
                                self.GetSibling("TEXTURES").Deselect();
                            }
                            self.root.Refresh();
                        }))
                            .SetInteractive(false)
                            .SetRefresh(function() {
                                self.SetInteractive(self.GetSibling("TEXTURES").GetSelection() != -1);
                            }),
                    ]).AddDefaultCloseButton();
                }))
                    .SetInteractive(false)
                    .SetRefresh(function() {
                        self.SetInteractive(!!self.GetSibling("CHOICES").GetSelectedItem());
                    })
                    .SetID("CHOICE ADVANCED"),
            ]),
        ])
    ]).AddDefaultCloseButton();
    
    dialog.Refresh();
    
    return dialog;
}