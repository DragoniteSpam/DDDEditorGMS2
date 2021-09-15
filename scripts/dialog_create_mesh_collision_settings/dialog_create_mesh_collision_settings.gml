function dialog_create_mesh_collision_settings(root, selection) {
    var mode = Stuff.mesh_ed;
    
    root.Dispose();
    
    var dw = 640;
    var dh = 736;
    
    var c1x = 32;
    var c2x = 352;
    
    var dg = (new EmuDialog(dw, dh, "Collision Shapes")).AddContent([
        // column 1
        (new EmuList(c1x, 32, 256, 32, "Collision shapes:", 32, 10, function() {
            var selection = self.GetSelection();
            if (selection + 1) {
                var shape = self.root.mesh.collision_shapes[selection];
                self.root.el_trans_x.interactive = false;
                self.root.el_trans_y.interactive = false;
                self.root.el_trans_z.interactive = false;
                self.root.el_rot_x.interactive = false;
                self.root.el_rot_y.interactive = false;
                self.root.el_rot_z.interactive = false;
                self.root.el_scale_x.interactive = false;
                self.root.el_scale_y.interactive = false;
                self.root.el_scale_z.interactive = false;
                self.root.el_other_radius.interactive = false;
                self.root.el_other_length.interactive = false;
                switch (shape.type) {
                    case MeshCollisionShapes.BOX:
                        self.root.el_trans_x.interactive = true;
                        self.root.el_trans_x.SetValue(string(shape.position.x));
                        self.root.el_trans_y.interactive = true;
                        self.root.el_trans_y.SetValue(string(shape.position.y));
                        self.root.el_trans_z.interactive = true;
                        self.root.el_trans_z.SetValue(string(shape.position.z));
                        self.root.el_rot_x.interactive = true;
                        self.root.el_rot_x.SetValue(string(shape.rotation.x));
                        self.root.el_rot_y.interactive = true;
                        self.root.el_rot_y.SetValue(string(shape.rotation.y));
                        self.root.el_rot_z.interactive = true;
                        self.root.el_rot_z.SetValue(string(shape.rotation.z));
                        self.root.el_scale_x.interactive = true;
                        self.root.el_scale_x.SetValue(string(shape.scale.x));
                        self.root.el_scale_y.interactive = true;
                        self.root.el_scale_y.SetValue(string(shape.scale.y));
                        self.root.el_scale_z.interactive = true;
                        self.root.el_scale_z.SetValue(string(shape.scale.z));
                        break;
                    case MeshCollisionShapes.CAPSULE:
                        self.root.el_trans_x.interactive = true;
                        self.root.el_trans_x.SetValue(string(shape.position.x));
                        self.root.el_trans_y.interactive = true;
                        self.root.el_trans_y.SetValue(string(shape.position.y));
                        self.root.el_trans_z.interactive = true;
                        self.root.el_trans_z.SetValue(string(shape.position.z));
                        self.root.el_rot_x.interactive = true;
                        self.root.el_rot_x.SetValue(string(shape.rotation.x));
                        self.root.el_rot_y.interactive = true;
                        self.root.el_rot_y.SetValue(string(shape.rotation.y));
                        self.root.el_rot_z.interactive = true;
                        self.root.el_rot_z.SetValue(string(shape.rotation.z));
                        self.root.el_other_radius.interactive = true;
                        self.root.el_other_radius.SetValue(string(shape.radius));
                        self.root.el_other_length.interactive = true;
                        self.root.el_other_length.SetValue(string(shape.length));
                        break;
                    case MeshCollisionShapes.SPHERE:
                        self.root.el_trans_x.interactive = true;
                        self.root.el_trans_x.SetValue(string(shape.position.x));
                        self.root.el_trans_y.interactive = true;
                        self.root.el_trans_y.SetValue(string(shape.position.y));
                        self.root.el_trans_z.interactive = true;
                        self.root.el_trans_z.SetValue(string(shape.position.z));
                        self.root.el_other_radius.interactive = true;
                        self.root.el_other_radius.SetValue(string(shape.radius));
                        break;
                    case MeshCollisionShapes.TRIMESH:
                        break;
                }
            }
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
            self.root.mesh.collision_shapes[self.root.el_list.GetSelection()].position.x = real(self.value);
        })).SetRealNumberBounds(-10000, 10000).SetRootVariableName("trans_x").SetInteractive(false),
        (new EmuInput(c2x, EMU_AUTO, 256, 24, "    y:", "", "", 6, E_InputTypes.REAL, function() {
            self.root.mesh.collision_shapes[self.root.el_list.GetSelection()].position.y = real(self.value);
        })).SetRealNumberBounds(-10000, 10000).SetRootVariableName("trans_y").SetInteractive(false),
        (new EmuInput(c2x, EMU_AUTO, 256, 24, "    z:", "", "", 6, E_InputTypes.REAL, function() {
            self.root.mesh.collision_shapes[self.root.el_list.GetSelection()].position.z = real(self.value);
        })).SetRealNumberBounds(-10000, 10000).SetRootVariableName("trans_z").SetInteractive(false),
        new EmuText(c2x, EMU_AUTO, 256, 24, "Rotation"),
        (new EmuInput(c2x, EMU_AUTO, 256, 24, "    x:", "", "", 6, E_InputTypes.REAL, function() {
            self.root.mesh.collision_shapes[self.root.el_list.GetSelection()].rotation.x = real(self.value);
        })).SetRealNumberBounds(0, 360).SetRootVariableName("rot_x").SetInteractive(false),
        (new EmuInput(c2x, EMU_AUTO, 256, 24, "    y:", "", "", 6, E_InputTypes.REAL, function() {
            self.root.mesh.collision_shapes[self.root.el_list.GetSelection()].rotation.y = real(self.value);
        })).SetRealNumberBounds(0, 360).SetRootVariableName("rot_y").SetInteractive(false),
        (new EmuInput(c2x, EMU_AUTO, 256, 24, "    z:", "", "", 6, E_InputTypes.REAL, function() {
            self.root.mesh.collision_shapes[self.root.el_list.GetSelection()].rotation.z = real(self.value);
        })).SetRealNumberBounds(0, 360).SetRootVariableName("rot_z").SetInteractive(false),
        new EmuText(c2x, EMU_AUTO, 256, 24, "Scale"),
        (new EmuInput(c2x, EMU_AUTO, 256, 24, "    x:", "", "", 6, E_InputTypes.REAL, function() {
            self.root.mesh.collision_shapes[self.root.el_list.GetSelection()].scale.x = real(self.value);
        })).SetRealNumberBounds(0.001, 100).SetRootVariableName("scale_x").SetInteractive(false),
        (new EmuInput(c2x, EMU_AUTO, 256, 24, "    y:", "", "", 6, E_InputTypes.REAL, function() {
            self.root.mesh.collision_shapes[self.root.el_list.GetSelection()].scale.y = real(self.value);
        })).SetRealNumberBounds(0.001, 100).SetRootVariableName("scale_y").SetInteractive(false),
        (new EmuInput(c2x, EMU_AUTO, 256, 24, "    z:", "", "", 6, E_InputTypes.REAL, function() {
            self.root.mesh.collision_shapes[self.root.el_list.GetSelection()].scale.z = real(self.value);
        })).SetRealNumberBounds(0.001, 100).SetRootVariableName("scale_z").SetInteractive(false),
        new EmuText(c2x, EMU_AUTO, 256, 24, "Other"),
        (new EmuInput(c2x, EMU_AUTO, 256, 24, "Radius:", "", "", 6, E_InputTypes.REAL, function() {
            self.root.mesh.collision_shapes[self.root.el_list.GetSelection()].radius = real(self.value);
        })).SetRealNumberBounds(0.001, 9999).SetRootVariableName("other_radius").SetInteractive(false),
        (new EmuInput(c2x, EMU_AUTO, 256, 24, "Length:", "", "", 6, E_InputTypes.REAL, function() {
            self.root.mesh.collision_shapes[self.root.el_list.GetSelection()].length = real(self.value);
        })).SetRealNumberBounds(0.001, 9999).SetRootVariableName("other_length").SetInteractive(false),
        
        new EmuButton(dw / 2 - 160 / 2, dh - 48, 160, 32, "Done", function() {
            self.root.Dispose();
        }),
    ]);
    
    dg.active_shade = 0;
    dg.mesh = Game.meshes[selection];
    
    return dg;
}