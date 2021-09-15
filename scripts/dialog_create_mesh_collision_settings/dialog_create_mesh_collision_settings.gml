function dialog_create_mesh_collision_settings(root, selection) {
    var mode = Stuff.mesh_ed;
    
    var dw = 1440;
    var dh = 720;
    
    var c1x = 32;
    var c2x = 352;
    var c3x = 672;
    
    return (new EmuDialog(dw, dh, "Collision Shapes")).AddContent([
        // column 1
        new EmuList(c1x, 32, 256, 32, "Collision shapes:", 32, 10, function() {
            
        }),
        new EmuButton(c1x, EMU_AUTO, 256, 24, "Add Sphere", function() {
            
        }),
        new EmuButton(c1x, EMU_AUTO, 256, 24, "Add AABB", function() {
            
        }),
        new EmuButton(c1x, EMU_AUTO, 256, 24, "Add Capsule", function() {
            
        }),
        new EmuButton(c1x, EMU_AUTO, 256, 24, "Add Trimesh (from mesh)", function() {
            
        }),
        new EmuButton(c1x, EMU_AUTO, 256, 24, "Add Trimesh (from file)", function() {
            
        }),
        new EmuButton(c1x, EMU_AUTO, 256, 24, "Delete Shape", function() {
            
        }),
        new EmuInput(c1x, EMU_AUTO, 256, 24, "Shape name:", "", "name", 32, E_InputTypes.STRING, function() {
            
        }),
        // column 2
        new EmuText(c2x, 32, 256, 32, "[c_blue]Shape controls"),
        new EmuText(c2x, EMU_AUTO, 256, 24, "Translation"),
        (new EmuInput(c2x, EMU_AUTO, 256, 24, "    x:", "", "", 6, E_InputTypes.REAL, function() {
            
        })).SetRealNumberBounds(-10000, 10000),
        (new EmuInput(c2x, EMU_AUTO, 256, 24, "    y:", "", "", 6, E_InputTypes.REAL, function() {
            
        })).SetRealNumberBounds(-10000, 10000),
        (new EmuInput(c2x, EMU_AUTO, 256, 24, "    z:", "", "", 6, E_InputTypes.REAL, function() {
            
        })).SetRealNumberBounds(-10000, 10000),
        new EmuText(c2x, EMU_AUTO, 256, 24, "Rotation"),
        (new EmuInput(c2x, EMU_AUTO, 256, 24, "    x:", "", "", 6, E_InputTypes.REAL, function() {
            
        })).SetRealNumberBounds(0, 360),
        (new EmuInput(c2x, EMU_AUTO, 256, 24, "    y:", "", "", 6, E_InputTypes.REAL, function() {
            
        })).SetRealNumberBounds(0, 360),
        (new EmuInput(c2x, EMU_AUTO, 256, 24, "    z:", "", "", 6, E_InputTypes.REAL, function() {
            
        })).SetRealNumberBounds(0, 360),
        new EmuText(c2x, EMU_AUTO, 256, 24, "Scale"),
        (new EmuInput(c2x, EMU_AUTO, 256, 24, "    x:", "", "", 6, E_InputTypes.REAL, function() {
            
        })).SetRealNumberBounds(0.001, 100),
        (new EmuInput(c2x, EMU_AUTO, 256, 24, "    y:", "", "", 6, E_InputTypes.REAL, function() {
            
        })).SetRealNumberBounds(0.001, 100),
        (new EmuInput(c2x, EMU_AUTO, 256, 24, "    z:", "", "", 6, E_InputTypes.REAL, function() {
            
        })).SetRealNumberBounds(0.001, 100),
        new EmuText(c2x, EMU_AUTO, 256, 24, "Other"),
        (new EmuInput(c2x, EMU_AUTO, 256, 24, "Radius:", "", "", 6, E_InputTypes.REAL, function() {
            
        })).SetRealNumberBounds(0.001, 9999),
        (new EmuInput(c2x, EMU_AUTO, 256, 24, "Length:", "", "", 6, E_InputTypes.REAL, function() {
            
        })).SetRealNumberBounds(0.001, 9999),
        // column 3
        new EmuRenderSurface(c3x, 32, 720, 480, function(mx, my) {
            draw_clear(c_black);
        }, function(mx, my) {
            
        }, function() { }, function() { }),
        new EmuText(c3x, EMU_AUTO, 256, 32, "[c_blue]Viewport Settings"),
        
        new EmuButton(dw / 2 - 160 / 2, dh - 48, 160, 32, "Done", function() {
            self.root.Dispose();
        }),
    ]);
}