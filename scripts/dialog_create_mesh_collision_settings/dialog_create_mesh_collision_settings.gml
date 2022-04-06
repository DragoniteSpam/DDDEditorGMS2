function dialog_create_mesh_collision_settings(root, selection) {
    root.Dispose();
    
    var dw = 640;
    var dh = 736;
    
    var c1x = 32;
    var c2x = 352;
    
    var dialog = new EmuDialog(dw, dh, "Collision Shapes");
    
    return dialog.AddContent([
        // column 1
        (new EmuList(c1x, 32, 256, 32, "Collision shapes:", 32, 10, function() {
            var selection = self.GetSelection();
            if (selection + 1) {
                var shape = self.root.mesh.collision_shapes[selection];
                
                self.GetSibling("TRANS X").SetInteractive(false);
                self.GetSibling("TRANS Y").SetInteractive(false);
                self.GetSibling("TRANS Z").SetInteractive(false);
                self.GetSibling("ROT X").SetInteractive(false);
                self.GetSibling("ROT Y").SetInteractive(false);
                self.GetSibling("ROT Z").SetInteractive(false);
                self.GetSibling("SCALE X").SetInteractive(false);
                self.GetSibling("SCALE Y").SetInteractive(false);
                self.GetSibling("SCALE Z").SetInteractive(false);
                self.GetSibling("RADIUS").SetInteractive(false);
                self.GetSibling("LENGTH").SetInteractive(false);
                switch (shape.type) {
                    case MeshCollisionShapes.BOX:
                        self.GetSibling("TRANS X"). SetInteractive(true);
                        self.GetSibling("TRANS Y"). SetInteractive(true);
                        self.GetSibling("TRANS Z"). SetInteractive(true);
                        self.GetSibling("ROT X").   SetInteractive(true);
                        self.GetSibling("ROT Y").   SetInteractive(true);
                        self.GetSibling("ROT Z").   SetInteractive(true);
                        self.GetSibling("SCALE X"). SetInteractive(true);
                        self.GetSibling("SCALE Y"). SetInteractive(true);
                        self.GetSibling("SCALE Z"). SetInteractive(true);
                        self.GetSibling("TRANS X"). SetValue(shape.position.x);
                        self.GetSibling("TRANS Y"). SetValue(shape.position.y);
                        self.GetSibling("TRANS Z"). SetValue(shape.position.z);
                        self.GetSibling("ROT X").   SetValue(shape.rotation.x);
                        self.GetSibling("ROT Y").   SetValue(shape.rotation.y);
                        self.GetSibling("ROT Z").   SetValue(shape.rotation.z);
                        self.GetSibling("SCALE X"). SetValue(shape.scale.x);
                        self.GetSibling("SCALE Y"). SetValue(shape.scale.y);
                        self.GetSibling("SCALE Z"). SetValue(shape.scale.z);
                        break;
                    case MeshCollisionShapes.CAPSULE:
                        self.GetSibling("TRANS X"). SetInteractive(true);
                        self.GetSibling("TRANS Y"). SetInteractive(true);
                        self.GetSibling("TRANS Z"). SetInteractive(true);
                        self.GetSibling("ROT X").   SetInteractive(true);
                        self.GetSibling("ROT Y").   SetInteractive(true);
                        self.GetSibling("ROT Z").   SetInteractive(true);
                        self.GetSibling("RADIUS").  SetInteractive(true);
                        self.GetSibling("LENGTH").  SetInteractive(true);
                        self.GetSibling("TRANS X"). SetValue(shape.position.x);
                        self.GetSibling("TRANS Y"). SetValue(shape.position.y);
                        self.GetSibling("TRANS Z"). SetValue(shape.position.z);
                        self.GetSibling("ROT X").   SetValue(shape.rotation.x);
                        self.GetSibling("ROT Y").   SetValue(shape.rotation.y);
                        self.GetSibling("ROT Z").   SetValue(shape.rotation.z);
                        self.GetSibling("RADIUS").  SetValue(shape.radius);
                        self.GetSibling("LENGTH").  SetValue(shape.length);
                        break;
                    case MeshCollisionShapes.SPHERE:
                        self.GetSibling("TRANS X"). SetInteractive(true);
                        self.GetSibling("TRANS Y"). SetInteractive(true);
                        self.GetSibling("TRANS Z"). SetInteractive(true);
                        self.GetSibling("RADIUS").  SetInteractive(true);
                        self.GetSibling("TRANS X"). SetValue(shape.position.x);
                        self.GetSibling("TRANS Y"). SetValue(shape.position.y);
                        self.GetSibling("TRANS Z"). SetValue(shape.position.z);
                        self.GetSibling("RADIUS").  SetValue(shape.radius);
                        break;
                    case MeshCollisionShapes.TRIMESH:
                        break;
                }
            }
        }))
            .SetList(Game.meshes[selection].collision_shapes)
            .SetEntryTypes(E_ListEntryTypes.STRUCTS)
            .SetID("LIST"),
        (new EmuButton(c1x, EMU_AUTO, 256, 24, "Add Sphere", function() {
            self.root.mesh.AddCollisionShape(MeshCollisionShapeSphere);
        }))
            .SetID("ADD SPHERE"),
        (new EmuButton(c1x, EMU_AUTO, 256, 24, "Add Box", function() {
            self.root.mesh.AddCollisionShape(MeshCollisionShapeBox);
        })).SetID("add_box"),
        (new EmuButton(c1x, EMU_AUTO, 256, 24, "Add Capsule", function() {
            self.root.mesh.AddCollisionShape(MeshCollisionShapeCapsule);
        })).SetID("add_capsule"),
        (new EmuButton(c1x, EMU_AUTO, 256, 24, "Add Trimesh (from mesh)", function() {
            //var trimesh = self.root.mesh.AddCollisionShape(MeshCollisionShapeTrimesh);
        }))
            .SetID("ADD TIRMESH"),
        (new EmuButton(c1x, EMU_AUTO, 256, 24, "Add Trimesh (from file)", function() {
            //var trimesh = self.root.mesh.AddCollisionShape(MeshCollisionShapeTrimesh);
        }))
            .SetID("ADD TRIMESH FROM FILE"),
        (new EmuButton(c1x, EMU_AUTO, 256, 24, "Delete Shape", function() {
            var selection = self.root.el_list.GetSelection();
            if (selection + 1) {
                self.root.mesh.DeleteCollisionShape(selection);
            }
        }))
            .SetID("DELETE SHAPE"),
        (new EmuInput(c1x, EMU_AUTO, 256, 24, "Shape name:", "", "name", 32, E_InputTypes.STRING, function() {
            var selection = self.root.el_list.GetSelection();
            if (selection + 1) {
                self.root.mesh.RenameCollisionShape(selection, self.value);
            }
        }))
            .SetID("SHAPE NAME"),
        // column 2
        new EmuText(c2x, 32, 256, 32, "[c_aqua]Shape controls"),
        new EmuText(c2x, EMU_AUTO, 256, 24, "Translation"),
        (new EmuInput(c2x, EMU_AUTO, 256, 24, "    x:", "", "", 6, E_InputTypes.REAL, function() {
            self.root.mesh.collision_shapes[self.root.el_list.GetSelection()].position.x = real(self.value);
        }))
            .SetRealNumberBounds(-10000, 10000)
            .SetID("TRANS X")
            .SetInteractive(false),
        (new EmuInput(c2x, EMU_AUTO, 256, 24, "    y:", "", "", 6, E_InputTypes.REAL, function() {
            self.root.mesh.collision_shapes[self.root.el_list.GetSelection()].position.y = real(self.value);
        }))
            .SetRealNumberBounds(-10000, 10000)
            .SetID("TRANS Y")
            .SetInteractive(false),
        (new EmuInput(c2x, EMU_AUTO, 256, 24, "    z:", "", "", 6, E_InputTypes.REAL, function() {
            self.root.mesh.collision_shapes[self.root.el_list.GetSelection()].position.z = real(self.value);
        }))
            .SetRealNumberBounds(-10000, 10000)
            .SetID("TRANS Z")
            .SetInteractive(false),
        new EmuText(c2x, EMU_AUTO, 256, 24, "Rotation"),
        (new EmuInput(c2x, EMU_AUTO, 256, 24, "    x:", "", "", 6, E_InputTypes.REAL, function() {
            self.root.mesh.collision_shapes[self.root.el_list.GetSelection()].rotation.x = real(self.value);
        }))
            .SetRealNumberBounds(0, 360)
            .SetID("ROT X")
            .SetInteractive(false),
        (new EmuInput(c2x, EMU_AUTO, 256, 24, "    y:", "", "", 6, E_InputTypes.REAL, function() {
            self.root.mesh.collision_shapes[self.root.el_list.GetSelection()].rotation.y = real(self.value);
        }))
            .SetRealNumberBounds(0, 360)
            .SetID("ROT Y")
            .SetInteractive(false),
        (new EmuInput(c2x, EMU_AUTO, 256, 24, "    z:", "", "", 6, E_InputTypes.REAL, function() {
            self.root.mesh.collision_shapes[self.root.el_list.GetSelection()].rotation.z = real(self.value);
        }))
            .SetRealNumberBounds(0, 360)
            .SetID("ROT Z")
            .SetInteractive(false),
        new EmuText(c2x, EMU_AUTO, 256, 24, "Scale"),
        (new EmuInput(c2x, EMU_AUTO, 256, 24, "    x:", "", "", 6, E_InputTypes.REAL, function() {
            self.root.mesh.collision_shapes[self.root.el_list.GetSelection()].scale.x = real(self.value);
        }))
            .SetRealNumberBounds(0.001, 100)
            .SetID("SCALE X")
            .SetInteractive(false),
        (new EmuInput(c2x, EMU_AUTO, 256, 24, "    y:", "", "", 6, E_InputTypes.REAL, function() {
            self.root.mesh.collision_shapes[self.root.el_list.GetSelection()].scale.y = real(self.value);
        }))
            .SetRealNumberBounds(0.001, 100)
            .SetID("SCALE Y")
            .SetInteractive(false),
        (new EmuInput(c2x, EMU_AUTO, 256, 24, "    z:", "", "", 6, E_InputTypes.REAL, function() {
            self.root.mesh.collision_shapes[self.root.el_list.GetSelection()].scale.z = real(self.value);
        }))
            .SetRealNumberBounds(0.001, 100)
            .SetID("SCALE Z")
            .SetInteractive(false),
        new EmuText(c2x, EMU_AUTO, 256, 24, "Other"),
        (new EmuInput(c2x, EMU_AUTO, 256, 24, "Radius:", "", "", 6, E_InputTypes.REAL, function() {
            self.root.mesh.collision_shapes[self.root.el_list.GetSelection()].radius = real(self.value);
        }))
            .SetRealNumberBounds(0.001, 9999)
            .SetID("RADIUS")
            .SetInteractive(false),
        (new EmuInput(c2x, EMU_AUTO, 256, 24, "Length:", "", "", 6, E_InputTypes.REAL, function() {
            self.root.mesh.collision_shapes[self.root.el_list.GetSelection()].length = real(self.value);
        }))
            .SetRealNumberBounds(0.001, 9999)
            .SetID("LENGTH")
            .SetInteractive(false),
    ]).AddDefaultCloseButton();
}