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
            .SetTooltip("The color of the fog; you will usually want this to be white or off-white, but sometimes it may be preferred to be some other color"),
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
    dialog.generation_choices = [];
    var element_width = 320;
    var element_height = 32;
    
    var col1 = 32;
    var col2 = 32 + 320 + 32;
    var col3 = 32 + 320 + 32 + 320 + 32;
    
    return dialog.AddContent([
        (new EmuTabGroup(col1, EMU_BASE, 32 + 320 + 32 + 320 + 32 + 320 + 32, dialog.height - 80, 1, element_height)).AddTabs(0, [
            new EmuTab("General").AddContent([
                new EmuText(col1, EMU_BASE, element_width, element_height, "[c_aqua]Base Properties"),
                (new EmuList(col1, EMU_AUTO, element_width, element_height, "Terrain:", element_height, 10, function() {
                    if (!self.root) return;
                    var selection = self.GetSelectedItem();
                    self.root.map.terrain.id = selection ? selection.GUID : NULL;
                }))
                    .SetList(Game.mesh_terrain)
                    .Select(array_search(Game.mesh_terrain, guid_get(map.terrain.id)))
                    .SetEntryTypes(E_ListEntryTypes.STRUCTS)
                    .SetTooltip("The terrain model associated with this map."),
                (new EmuInput(col1, EMU_AUTO, element_width, element_height, "Scale:", string(map.terrain.scale), "The terrain scale", 2, E_InputTypes.INT, function() {
                    self.root.map.terrain.scale = real(self.value);
                })),
            ]),
            (new EmuTab("Generation of Noise")).AddContent([
                new EmuText(col1, EMU_BASE, element_width, element_height, "[c_aqua]Perlin Noise"),
                (new EmuButton(col1, EMU_AUTO, element_width, element_height, "Generate Texture", function() {
                    var terrain = guid_get(self.root.map.terrain.id) ? guid_get(self.root.map.terrain.id).terrain_data : undefined;
                    if (!terrain) return;
            
                    var smoothness = self.GetSibling("GEN SMOOTHNESS").value;
                    var sprite_r_source = macaw_generate_dll(terrain.w, terrain.h, smoothness, 255);
                    var sprite_g_source = macaw_generate_dll(terrain.w, terrain.h, smoothness, 255);
                    var sprite_b_source = macaw_generate_dll(terrain.w, terrain.h, smoothness, 255);
                    var sprite_r = sprite_r_source.ToSpriteDLL();
                    var sprite_g = sprite_g_source.ToSpriteDLL();
                    var sprite_b = sprite_b_source.ToSpriteDLL();
                    sprite_r_source.Destroy();
                    sprite_g_source.Destroy();
                    sprite_b_source.Destroy();
            
                    var display = self.GetSibling("IMAGE");
                    if (sprite_exists(display.sprite)) {
                        sprite_delete(display.sprite);
                    }
            
                    display.sprite = sprite_combine_grayscale_channels(sprite_r, sprite_g, sprite_b);
                    sprite_delete(sprite_r);
                    sprite_delete(sprite_g);
                    sprite_delete(sprite_b);
            
                    sprite_set_offset(display.sprite, sprite_get_width(display.sprite) / 2, sprite_get_height(display.sprite) / 2);
                })),
                new EmuText(col1, EMU_AUTO, element_width / 2, element_height, "Smoothness:"),
                (new EmuProgressBar(col1 + element_width / 2, EMU_INLINE, element_width / 2, element_height, 8, 1, 12, true, 6, emu_null))
                    .SetIntegersOnly(true)
                    .SetID("GEN SMOOTHNESS"),
                (new EmuButtonImage(col1, EMU_AUTO, element_width, element_width, -1, 0, c_white, 1, true, function() {
            
                }))
                    .SetAlignment(fa_center, fa_middle)
                    .SetInteractive(false)
                    .SetDisabledColor(function() { return c_white; })
                    .SetID("IMAGE"),
            ]),
            (new EmuTab("Generation of Content")).AddContent([
                new EmuText(col1, EMU_BASE, element_width, element_height, "[c_aqua]Spawned Objects"),
                (new EmuList(col1, EMU_AUTO, element_width, element_height, "Meshes:", element_height, 16, function() {
                    if (!self.root) return;
            
                }))
                    .SetList(Game.meshes)
                    .SetMultiSelect(true)
                    .SetAllowDeselect(false)
                    .SetEntryTypes(E_ListEntryTypes.STRUCTS)
                    .SetID("MESHES"),
                (new EmuList(col2, EMU_BASE, element_width, element_height, "Generation Choices:", element_height, 8, function() {
                    if (!self.root) return;
            
                }))
                    .SetList(dialog.generation_choices)
                    .SetEntryTypes(E_ListEntryTypes.STRUCTS)
                    .SetID("CHOICES"),
                (new EmuButton(col2, EMU_AUTO, element_width, element_height, "Add Choice", function() {
                    static generation_choice = function(mesh) constructor {
                        self.mesh = mesh;
                        self.name = mesh.name;
                        self.odds = 100;
                    };
            
                    array_push(self.root.generation_choices, new generation_choice(self.GetSibling("MESHES").GetSelectedItem()));
                }))
                    .SetInteractive(false),
                (new EmuButton(col2, EMU_AUTO, element_width, element_height, "Delete Choice", function() {
            
                }))
                    .SetInteractive(false)
                    .SetRefresh(function() {
                    }),
                new EmuText(col3, EMU_BASE, element_width, element_height, "[c_aqua]Weights"),
                (new EmuInput(col3, EMU_AUTO, element_width, element_height, "Elevation:", "100", "Relative spawn odds", 4, E_InputTypes.INT, function() {
            
                }))
                    .SetInteractive(false)
                    .SetRefresh(function() {
                    }),
                (new EmuInput(col3, EMU_AUTO, element_width, element_height, "Temperature:", "100", "Relative spawn odds", 4, E_InputTypes.INT, function() {
            
                }))
                    .SetInteractive(false)
                    .SetRefresh(function() {
                    }),
                (new EmuInput(col3, EMU_AUTO, element_width, element_height, "Precipitation:", "100", "Relative spawn odds", 4, E_InputTypes.INT, function() {
            
                }))
                    .SetInteractive(false)
                    .SetRefresh(function() {
                    }),
                (new EmuInput(col3, EMU_AUTO, element_width, element_height, "Other:", "100", "Relative spawn odds", 4, E_InputTypes.INT, function() {
            
                }))
                    .SetInteractive(false)
                    .SetRefresh(function() {
                    }),
            ]),
        ])
    ]).AddDefaultCloseButton();
}