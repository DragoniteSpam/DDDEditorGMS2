function dialog_create_settings_map() {
    var map = Stuff.map.active_map;
    
    var dialog = new EmuDialog(32 + 320 + 32 + 320 + 32 + 320 + 32, 672, "Advanced Map Settings");
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
            .SetInteractive(map.fog_end)
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
            .SetEntryTypes(E_ListEntryTypes.STRUCTS)
            .SetTooltip("The skybox to be used by the map. Deselect to clear."),
        (new EmuInput(col2, EMU_AUTO, element_width, element_height, "Chunk size:", map.chunk_size, "in cells", 5, E_InputTypes.INT, function() {
            self.root.map.chunk_size = string(self.value);
        }))
            .SetTooltip("The size of the chunks maps are broken up into for optimization purposes."),
        new EmuText(col3, EMU_BASE, element_width, element_height, "[c_aqua]Navigation"),
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