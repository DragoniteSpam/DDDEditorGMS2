function dialog_create_preferences() {
    var dw = 640;
    var dh = 640;
    
    var dg = new EmuDialog(dw, dh, "Preferences");
    
    var columns = 2;
    var spacing = 16;
    var ew = dw / columns - spacing * 2;
    var eh = 24;
    
    var col1_x = 16;
    var col2_x = dw / 2 + 16;
    
    var vx1 = dw / 4 + 16;
    var vy1 = 0;
    var vx2 = vx1 + 80;
    var vy2 = eh;
    
    var yy = 64;
    var yy_base = yy;
    
    var element;
    
    element = new EmuInput(col1_x, EMU_AUTO, ew, eh, "Bezier precision:", Settings.config.bezier_precision, "0...16", 2, E_InputTypes.INT, function() {
        Settings.config.bezier_precision = real(self.value);
    });
    element.SetRealNumberBounds(0, 16);
    element.tooltip = "Higher-precision bezier curves look better, but take more computing power to draw. Lowering this will not fix performance issues, but it may help.";
    dg.AddContent(element);
    
    var yy_base = element.y;
    
    element = new EmuCheckbox(col1_x, EMU_AUTO, ew, eh, "Show Tooltips", Settings.config.tooltip, function() {
        Settings.config.tooltip = self.value;
    });
    element.tooltip = "These thingies.";
    dg.AddContent(element);
    
    element = new EmuInput(col1_x, EMU_AUTO, ew, eh, "NPC speed:", Settings.config.npc_animate_rate, "0...12", 2, E_InputTypes.INT, function() {
        Settings.config.npc_animate_rate = real(self.value);
    });
    element.tooltip = "The speed at which NPC (Pawn) entities will animate.";
    element.SetRealNumberBounds(0, 12);
    dg.AddContent(element);
    
    element = new EmuColorPicker(col1_x, EMU_AUTO, ew, eh, "UI Color:", Settings.config.color, function() {
        Settings.config.color = self.value;
    });
    element.tooltip = "The default color of the UI. I like green but you can make it something else if you don't like green.";
    dg.AddContent(element);
    
    element = new EmuColorPicker(col1_x, EMU_AUTO, ew, eh, "World Color:", Settings.config.color_world, function() {
        Settings.config.color_world = self.value;
    });
    element.tooltip = "The default background color of the game world. Using a skybox will (most likely) render this pointless.";
    dg.AddContent(element);
    
    dg.AddContent(new EmuText(col1_x, EMU_AUTO, ew, eh, "Camera Acceleration:"));
    
    element = new EmuProgressBar(col1_x, EMU_AUTO, ew, eh, 8, 0.5, 4, true, Settings.config.camera_fly_rate, function() {
        Settings.config.camera_fly_rate = self.value;
    });
    element.tooltip = "How fast the camera accelerates in editor modes that use it (2D and 3D).";
    dg.AddContent(element);
    
    element = new EmuCheckbox(col1_x, EMU_AUTO, ew, eh, "Alternate Middle Click", Settings.config.alternate_middle, function() {
        Settings.config.alternate_middle = self.value;
    });
    element.tooltip = "For a while my mouse was slightly broken and middle click doesn't always work, so I need an alternate method to emulate it. I finally got a new mouse, but the option is still here if you want it. This is turned off by default so that it's harder to accidentally invoke, but you may turn it on if you need it.\n\n(The alternate input is Control + Space.)";
    dg.AddContent(element);
    
    element = new EmuCheckbox(col1_x, EMU_AUTO, ew, eh, "Clear surrounded mesh autotiles?", Settings.config.remove_covered_mesh_at, function() {
        Settings.config.remove_covered_mesh_at = self.value;
    });
    element.tooltip = "Mesh autotiles that are surrounded on all sides, and are surrounded on all sides above, will be automatically deleted.";
    dg.AddContent(element);
    
    dg.AddContent(new EmuText(col1_x, EMU_AUTO, ew, eh, "Out-of-focus opacity:"));
    
    element = new EmuProgressBar(col1_x, EMU_AUTO, ew, eh, 8, 0, 1, true, Settings.config.focus_alpha, function() {
        Settings.config.focus_alpha = self.value;
        self.root.active_shade = self.value;
    });
    element.tooltip = "The opacity behind the active dialog box. Not all dialog boxes may show the opacity, although most will.";
    dg.AddContent(element);
    
    element = new EmuRadioArray(col2_x, yy_base, ew, eh, "Code File Extension:", Settings.config.code_extension, function() {
        Settings.config.code_extension = self.value;
    });
    element.tooltip = "This only really affects the text editor you want to be able to edit Lua code with. Plain text files will open with Notepad by default, but if you have another editor set such as Notepad++ you can use that instead.";
    element.AddOptions(Stuff.code_extension_map);
    dg.AddContent(element);
    
    element = new EmuRadioArray(col2_x, EMU_AUTO, ew, eh, "Text File Extension:", Settings.config.text_extension, function() {
        Settings.config.text_extension = self.value;
    });
    element.tooltip = "This only really affects the text editor you want to be able to edit Lua code with. Plain text files will open with Notepad by default, but if you have another editor set such as Notepad++ you can use that instead.";
    element.AddOptions(Stuff.text_extension_map);
    dg.AddContent(element);
    
    dg.AddContent(new EmuText(col2_x, EMU_AUTO, ew, eh, "Mesh Reflection Actions:"));
    
    element = new EmuBitfield(col2_x, EMU_AUTO, ew, eh * 8, Settings.mesh.reflect_settings, function() {
        Settings.mesh.reflect_settings = self.value;
    });
    element.SetOrientation(E_BitfieldOrientations.VERTICAL);
    element.AddOptions([
        "Mirror (X)", "Mirror (Y)", "Mirror (Z)", "Rotate (X)", "Rotate (Y)", "Rotate (Z)", "Reverse", "Colorize",
    ]);
    element.tooltip = "Automatically generating a reflection mesh may involve different operations for different games. The Mirror options will reflect the mesh across the specified axis; the Rotate options will rotate the mesh 180 degrees around the specified axis; Reverse Triangles will reverse the culling direction of each triangle; Colorize will blend the color of each vertex to another color (see below), allowing you to make objects intended to be underwater to appear bluer, etc.";
    dg.AddContent(element);
    
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
    
    element = new EmuColorPicker(col2_x, EMU_AUTO, ew, eh, "Reflection color:", Settings.mesh.reflect_color, function() {
        Settings.mesh.reflect_color = self.value;
    });
    element.SetAlphaUsed(true);
    element.tooltip = "The color for reflected meshes wo be blended with. You probably want to pick something blue-ish. The alpha channel will determine the amount of blending; a value around 0.5 should be good for most cases. Color will only be applied if the Colorize option is enabled above.";
    dg.AddContent(element);
    
    var b_width = 128;
    var b_height = 32;
    
    dg.AddContent(new EmuButton(dw / 2 - b_width / 2, dh - 32 - b_height / 2, b_width, b_height, "Done", function() {
        self.root.Dispose();
    }));
    
    return dg;
}