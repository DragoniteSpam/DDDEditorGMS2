function emu_dialog_zone_template(zone, title) {
    var map = Stuff.map.active_map;
    
    var element_width = 320;
    var element_height = 32;
    
    var col1 = 32;
    var col2 = 384;
    
    var dialog = new EmuDialog(32 + 320 + 32 + 320 + 32, 640, title);
    dialog.zone = zone;
    
    return dialog.AddContent([
        (new EmuInput(col1, EMU_BASE, element_width, element_height, "Name:", zone.name, "The name of the zone", VISIBLE_NAME_LENGTH, E_InputTypes.STRING, function() {
            self.root.zone.name = self.value;
            Stuff.map.ui.SearchID("ZONE DATA").Refresh();
        }))
            .SetTooltip("A name; this is for identification (and possibly debugging) purposes and has no influence on gameplay"),
        (new EmuText(col1, EMU_AUTO, element_width, element_height, "[c_aqua]Physicality:")),
        (new EmuInput(col1, EMU_AUTO, element_width / 2, element_height, "x1:", zone.x1, "0..." + string(map.xx - 1), 4, E_InputTypes.INT, function() {
            self.root.x1 = real(self.value);
        }))
            .SetRealNumberBounds(0, map.xx - 1)
            .SetTooltip("The starting X coordinate of the zone."),
        (new EmuInput(col1 + element_width / 2, EMU_INLINE, element_width / 2, element_height, "x2:", zone.x2, "0..." + string(map.xx - 1), 4, E_InputTypes.INT, function() {
            self.root.x2 = real(self.value);
        }))
            .SetRealNumberBounds(0, map.xx - 1)
            .SetTooltip("The ending X coordinate of the zone."),
        (new EmuInput(col1, EMU_AUTO, element_width / 2, element_height, "y1:", zone.y1, "0..." + string(map.yy - 1), 4, E_InputTypes.INT, function() {
            self.root.y1 = real(self.value);
        }))
            .SetRealNumberBounds(0, map.yy - 1)
            .SetTooltip("The starting Y coordinate of the zone."),
        (new EmuInput(col1 + element_width / 2, EMU_INLINE, element_width / 2, element_height, "y2:", zone.y2, "0..." + string(map.yy - 1), 4, E_InputTypes.INT, function() {
            self.root.y2 = real(self.value);
        }))
            .SetRealNumberBounds(0, map.yy - 1)
            .SetTooltip("The ending Y coordinate of the zone."),
        (new EmuInput(col1, EMU_AUTO, element_width / 2, element_height, "z1:", zone.z1, "0..." + string(map.zz - 1), 4, E_InputTypes.INT, function() {
            self.root.z1 = real(self.value);
        }))
            .SetRealNumberBounds(0, map.zz - 1)
            .SetTooltip("The starting Z coordinate of the zone."),
        (new EmuInput(col1 + element_width / 2, EMU_INLINE, element_width / 2, element_height, "z2:", zone.z2, "0..." + string(map.zz - 1), 4, E_InputTypes.INT, function() {
            self.root.z2 = real(self.value);
        }))
            .SetRealNumberBounds(0, map.zz - 1)
            .SetTooltip("The ending Z coordinate of the zone."),
        (new EmuInput(col1, EMU_AUTO, element_width, element_height, "Priority:", zone.zone_priority, "1...1000", 4, E_InputTypes.INT, function() {
            self.root.zone_priority = real(self.value);
        }))
            .SetRealNumberBounds(1, 1000)
            .SetTooltip("If multiple zones overlap, the one with the highest priority will be the one that is acted upon."),
    ]);
}