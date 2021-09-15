function dialog_create_mesh_collision_settings(root, selection) {
    var mode = Stuff.mesh_ed;
    
    var dw = 1440;
    var dh = 720;
    
    var c1x = 32;
    var c2x = 352;
    var c3x = 672;
    
    var dg = (new EmuDialog(dw, dh, "Collision Shapes")).AddContent([
        // column 1
        (new EmuList(c1x, 32, 256, 32, "Collision shapes:", 32, 10, function() {
            
        })).SetList(Game.meshes[selection].collision_shapes).SetEntryTypes(E_ListEntryTypes.STRUCTS).SetRootVariableName("list"),
        (new EmuButton(c1x, EMU_AUTO, 256, 24, "Add Sphere", function() {
            self.root.mesh.AddCollisionShape(MeshCollisionShapeSphere);
        })).SetRootVariableName("add_sphere"),
        (new EmuButton(c1x, EMU_AUTO, 256, 24, "Add Box", function() {
            self.root.mesh.AddCollisionShape(MeshCollisionShapeBox);
        })).SetRootVariableName("add_box"),
        (new EmuButton(c1x, EMU_AUTO, 256, 24, "Add Capsule", function() {
            self.root.mesh.AddCollisionShape(MeshCollisionShapeCapsule);
        })).SetRootVariableName("add_capsule"),
        (new EmuButton(c1x, EMU_AUTO, 256, 24, "Add Trimesh (from mesh)", function() {
            //var trimesh = self.root.mesh.AddCollisionShape(MeshCollisionShapeTrimesh);
        })).SetRootVariableName("add_trimesh"),
        (new EmuButton(c1x, EMU_AUTO, 256, 24, "Add Trimesh (from file)", function() {
            //var trimesh = self.root.mesh.AddCollisionShape(MeshCollisionShapeTrimesh);
        })).SetRootVariableName("add_trimesh_from_file"),
        (new EmuButton(c1x, EMU_AUTO, 256, 24, "Delete Shape", function() {
            var selection = self.root._contents[| 0].GetSelection();
            if (selection + 1) {
                self.root.mesh.DeleteCollisionShape(selection);
            }
        })).SetRootVariableName("delete_shape"),
        (new EmuInput(c1x, EMU_AUTO, 256, 24, "Shape name:", "", "name", 32, E_InputTypes.STRING, function() {
            var selection = self.root._contents[| 0].GetSelection();
            if (selection + 1) {
                self.root.mesh.RenameCollisionShape(selection, self.value);
            }
        })).SetRootVariableName("shape_name"),
        // column 2
        new EmuText(c2x, 32, 256, 32, "[c_blue]Shape controls"),
        new EmuText(c2x, EMU_AUTO, 256, 24, "Translation"),
        (new EmuInput(c2x, EMU_AUTO, 256, 24, "    x:", "", "", 6, E_InputTypes.REAL, function() {
            
        })).SetRealNumberBounds(-10000, 10000).SetRootVariableName("trans_x"),
        (new EmuInput(c2x, EMU_AUTO, 256, 24, "    y:", "", "", 6, E_InputTypes.REAL, function() {
            
        })).SetRealNumberBounds(-10000, 10000).SetRootVariableName("trans_y"),
        (new EmuInput(c2x, EMU_AUTO, 256, 24, "    z:", "", "", 6, E_InputTypes.REAL, function() {
            
        })).SetRealNumberBounds(-10000, 10000).SetRootVariableName("trans_z"),
        new EmuText(c2x, EMU_AUTO, 256, 24, "Rotation"),
        (new EmuInput(c2x, EMU_AUTO, 256, 24, "    x:", "", "", 6, E_InputTypes.REAL, function() {
            
        })).SetRealNumberBounds(0, 360).SetRootVariableName("rot_x"),
        (new EmuInput(c2x, EMU_AUTO, 256, 24, "    y:", "", "", 6, E_InputTypes.REAL, function() {
            
        })).SetRealNumberBounds(0, 360).SetRootVariableName("rot_y"),
        (new EmuInput(c2x, EMU_AUTO, 256, 24, "    z:", "", "", 6, E_InputTypes.REAL, function() {
            
        })).SetRealNumberBounds(0, 360).SetRootVariableName("rot_z"),
        new EmuText(c2x, EMU_AUTO, 256, 24, "Scale"),
        (new EmuInput(c2x, EMU_AUTO, 256, 24, "    x:", "", "", 6, E_InputTypes.REAL, function() {
            
        })).SetRealNumberBounds(0.001, 100).SetRootVariableName("scale_x"),
        (new EmuInput(c2x, EMU_AUTO, 256, 24, "    y:", "", "", 6, E_InputTypes.REAL, function() {
            
        })).SetRealNumberBounds(0.001, 100).SetRootVariableName("scale_y"),
        (new EmuInput(c2x, EMU_AUTO, 256, 24, "    z:", "", "", 6, E_InputTypes.REAL, function() {
            
        })).SetRealNumberBounds(0.001, 100).SetRootVariableName("scale_z"),
        new EmuText(c2x, EMU_AUTO, 256, 24, "Other"),
        (new EmuInput(c2x, EMU_AUTO, 256, 24, "Radius:", "", "", 6, E_InputTypes.REAL, function() {
            
        })).SetRealNumberBounds(0.001, 9999).SetRootVariableName("other_radius"),
        (new EmuInput(c2x, EMU_AUTO, 256, 24, "Length:", "", "", 6, E_InputTypes.REAL, function() {
            
        })).SetRealNumberBounds(0.001, 9999).SetRootVariableName("other_length"),
        // column 3
        (new EmuRenderSurface(c3x, 32, 720, 480, function(mx, my) {
            draw_clear(c_black);
        }, function(mx, my) {
            
        }, function() { }, function() { })).SetRootVariableName("render_surface"),
        new EmuText(c3x, EMU_AUTO, 256, 32, "[c_blue]Viewport Settings"),
        
        new EmuButton(dw / 2 - 160 / 2, dh - 48, 160, 32, "Done", function() {
            self.root.Dispose();
        }),
    ]);
    
    dg.mesh = Game.meshes[selection];
    
    return dg;
}