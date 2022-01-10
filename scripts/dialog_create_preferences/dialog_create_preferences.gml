function dialog_create_preferences() {
    var c1x = 32;
    var c2x = 392;
    var ew = 292;
    var eh = 32;
    
    var dialog = new EmuDialog(720, 560, "Preferences");
    
    dialog.AddContent([
        (new EmuInput(c1x, EMU_AUTO, ew, eh, "Bezier precision:", Settings.config.bezier_precision, "0...16", 2, E_InputTypes.INT, function() {
            Settings.config.bezier_precision = real(self.value);
        }))
            .SetRealNumberBounds(0, 16)
            .SetTooltip("Higher-precision bezier curves look better, but take more computing power to draw. Lowering this will not fix performance issues, but it may help."),
       (new EmuCheckbox(c1x, EMU_AUTO, ew, eh, "Show Tooltips", Settings.config.tooltip, function() {
            Settings.config.tooltip = self.value;
        }))
            .SetTooltip("These thingies."),
        (new EmuInput(c1x, EMU_AUTO, ew, eh, "NPC speed:", Settings.config.npc_animate_rate, "0...12", 2, E_InputTypes.INT, function() {
            Settings.config.npc_animate_rate = real(self.value);
        }))
            .SetTooltip("The speed at which NPC (Pawn) entities will animate."),
        (new EmuColorPicker(c1x, EMU_AUTO, ew, eh, "UI Color:", Settings.config.color, function() {
            Settings.config.color = self.value;
        }))
            .SetTooltip("The default color of the UI. I like green but you can make it something else if you don't like green."),
        (new EmuColorPicker(c1x, EMU_AUTO, ew, eh, "World Color:", Settings.config.color_world, function() {
            Settings.config.color_world = self.value;
        }))
            .SetTooltip("The default background color of the game world. Using a skybox will (most likely) render this pointless."),
        new EmuText(c1x, EMU_AUTO, ew, eh, "Camera Acceleration:"),
        (new EmuProgressBar(c1x, EMU_AUTO, ew, eh, 8, 0.5, 4, true, Settings.config.camera_fly_rate, function() {
            Settings.config.camera_fly_rate = self.value;
        }))
            .SetTooltip("How fast the camera accelerates in editor modes that use it (2D and 3D)."),
        (new EmuCheckbox(c1x, EMU_AUTO, ew, eh, "Alternate Middle Click", Settings.config.alternate_middle, function() {
            Settings.config.alternate_middle = self.value;
        }))
            .SetTooltip("For a while my mouse was slightly broken and middle click doesn't always work, so I need an alternate method to emulate it. I finally got a new mouse, but the option is still here if you want it. This is turned off by default so that it's harder to accidentally invoke, but you may turn it on if you need it.\n\n(The alternate input is Control + Space.)"),
        (new EmuCheckbox(c1x, EMU_AUTO, ew, eh, "Clear surrounded mesh autotiles?", Settings.config.remove_covered_mesh_at, function() {
            Settings.config.remove_covered_mesh_at = self.value;
        }))
            .SetTooltip("Mesh autotiles that are surrounded on all sides, and are surrounded on all sides above, will be automatically deleted."),
        new EmuText(c1x, EMU_AUTO, ew, eh, "Out-of-focus opacity:"),
        (new EmuProgressBar(c1x, EMU_AUTO, ew, eh, 8, 0, 1, true, Settings.config.focus_alpha, function() {
            Settings.config.focus_alpha = self.value;
            self.root.active_shade = self.value;
        }))
            .SetTooltip("The opacity behind the active dialog box. Not all dialog boxes may show the opacity, although most will."),
        new EmuText(c2x, EMU_BASE, ew, eh, "Mesh Reflection Actions:"),
        (new EmuBitfield(c2x, EMU_AUTO, ew, eh * 8, Settings.mesh.reflect_settings, function() {
            Settings.mesh.reflect_settings = self.value;
        }))
            .SetOrientation(E_BitfieldOrientations.VERTICAL)
            .AddOptions([
                "Mirror (X)", "Mirror (Y)", "Mirror (Z)", "Rotate (X)", "Rotate (Y)", "Rotate (Z)", "Reverse", "Colorize",
            ])
            .SetTooltip("Automatically generating a reflection mesh may involve different operations for different games. The Mirror options will reflect the mesh across the specified axis; the Rotate options will rotate the mesh 180 degrees around the specified axis; Reverse Triangles will reverse the culling direction of each triangle; Colorize will blend the color of each vertex to another color (see below), allowing you to make objects intended to be underwater to appear bluer, etc."),
            (new EmuColorPicker(c2x, EMU_AUTO, ew, eh, "Reflection color:", Settings.mesh.reflect_color, function() {
                Settings.mesh.reflect_color = self.value;
            }))
                .SetAlphaUsed(true)
                .SetTooltip("The color for reflected meshes wo be blended with. You probably want to pick something blue-ish. The alpha channel will determine the amount of blending; a value around 0.5 should be good for most cases. Color will only be applied if the Colorize option is enabled above.")
    ]).AddDefaultCloseButton("Done");
    
    enum MeshReflectionSettings {
        MIRROR_X            = 0x0001,
        MIRROR_Y            = 0x0002,
        MIRROR_Z            = 0x0004,
        ROTATE_X            = 0x0008,
        ROTATE_Y            = 0x0010,
        ROTATE_Z            = 0x0020,
        REVERSE             = 0x0040,
        COLORIZE            = 0x0080,
    }
    
    return dialog;
}