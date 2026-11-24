function dialog_create_mesh_collision_settings(mesh) {
    var dw = 640;
    var dh = 736;
    
    var c1x = 32;
    var c2x = 352;
    
    var dialog = new EmuDialog(dw, dh, "Collision Shapes");
    dialog.flags = DialogFlags.IS_MESH_COLLISION_SHAPES;
    dialog.mesh = mesh;
    dialog.active_shade = 0;
    
    var gizmo_collision = new GizmoSystem();
    gizmo_collision.dialog = dialog;
    gizmo_collision.scale_scale = 1 / 16;
    gizmo_collision.alpha = 0.75;
    
    // reset this when the dialog is closed
    Stuff.mesh.gizmo_active = gizmo_collision;
    
    with (gizmo_collision) {
        self.DoAllTheStuff = function(mx, my, mouse_pos, mouse_dir, width, height) {
            // when the collision shapes dialog is closed, reset
            var top = EmuOverlay.GetTop();
            if (!top || (top.flags & DialogFlags.IS_MESH_COLLISION_SHAPES == 0)) {
                Stuff.mesh.gizmo_active = Stuff.mesh.gizmo_default;
                return;
            }
            
            static identity_matrix = matrix_build_identity();
            
            self.selected_item = top.GetChild("LIST").GetSelectedItem();
            
            if (!self.selected_item) return;
            
            // All object types will have a position
            var cb_translate = function(x, y, z) {
                self.selected_item.position.x += x;
                self.selected_item.position.y += y;
                self.selected_item.position.z += z;
                self.dialog.GetChild("TRANS X").value = string(self.selected_item.position.x);
                self.dialog.GetChild("TRANS Y").value = string(self.selected_item.position.y);
                self.dialog.GetChild("TRANS Z").value = string(self.selected_item.position.z);
            };
            
            // Not all object types will have a rotation
            var cb_rotate = function(x, y, z) {
                switch (self.selected_item.type) {
                    case MeshCollisionShapes.BOX: {
                        self.selected_item.rotation.x += x;
                        self.selected_item.rotation.y += y;
                        self.selected_item.rotation.z += z;
                        self.dialog.GetChild("ROT X").value = string(self.selected_item.rotation.x);
                        self.dialog.GetChild("ROT Y").value = string(self.selected_item.rotation.y);
                        self.dialog.GetChild("ROT Z").value = string(self.selected_item.rotation.z);
                    } break;
                }
            };
            
            // Not all object types handle scale the same way
            var cb_scale = function(x, y, z) {
                switch (self.selected_item.type) {
                    case MeshCollisionShapes.BOX: {
                        self.selected_item.scale.x += x;
                        self.selected_item.scale.y += y;
                        self.selected_item.scale.z += z;
                        self.dialog.GetChild("SCALE X").value = string(self.selected_item.scale.x);
                        self.dialog.GetChild("SCALE Y").value = string(self.selected_item.scale.y);
                        self.dialog.GetChild("SCALE Z").value = string(self.selected_item.scale.z);
                    } break;
                    case MeshCollisionShapes.CAPSULE: {
                        self.selected_item.radius += x;
                        self.selected_item.radius += y;
                        self.selected_item.length += z;
                        self.dialog.GetChild("RADIUS").value = string(self.selected_item.radius);
                        self.dialog.GetChild("LENGTH").value = string(self.selected_item.length);
                    } break;
                    // spheres have some silly 2x scaling because diameter
                    case MeshCollisionShapes.SPHERE: {
                        self.selected_item.diameter += x * 2;
                        self.selected_item.diameter += y * 2;
                        self.selected_item.diameter += z * 2;
                        self.dialog.GetChild("RADIUS").value = string(self.selected_item.diameter / 2);
                    } break;
                }
            };
            
            matrix_set(matrix_world, identity_matrix);
            self.SetPosition(self.selected_item.position);
            self.SetSnapping(Settings.mesh.gizmo_snap_translate, Settings.mesh.gizmo_snap_rotate, Settings.mesh.gizmo_snap_scale);
            // feather ignore once GM1019
            self.Update(mx, my, mouse_pos, mouse_dir, width, height, cb_translate, cb_rotate, cb_scale);
            self.Render();
        }
    }
    
    return dialog.AddContent([
        // column 1
        (new EmuList(c1x, 32, 256, 32, "Collision shapes:", 32, 8, function() {
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
            self.GetSibling("FROM BOUNDS").SetInteractive(false);
            
            var selection = self.GetSelection();
            if (selection + 1) {
                var shape = self.root.mesh.collision_shapes[selection];
                
                // we should be doing this with the refresh method but this is older code and it works just as well
                self.GetSibling("NAME").SetValue(shape.name);
                
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
                        self.GetSibling("FROM BOUNDS").SetInteractive(true);
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
                        self.GetSibling("FROM BOUNDS").SetInteractive(false);
                        break;
                    case MeshCollisionShapes.SPHERE:
                        self.GetSibling("TRANS X"). SetInteractive(true);
                        self.GetSibling("TRANS Y"). SetInteractive(true);
                        self.GetSibling("TRANS Z"). SetInteractive(true);
                        self.GetSibling("RADIUS").  SetInteractive(true);
                        self.GetSibling("TRANS X"). SetValue(shape.position.x);
                        self.GetSibling("TRANS Y"). SetValue(shape.position.y);
                        self.GetSibling("TRANS Z"). SetValue(shape.position.z);
                        self.GetSibling("RADIUS").  SetValue(shape.diameter / 2);
                        self.GetSibling("FROM BOUNDS").SetInteractive(true);
                        break;
                    case MeshCollisionShapes.TRIMESH:
                        self.GetSibling("FROM BOUNDS").SetInteractive(false);
                        break;
                }
            }
        }))
            .SetList(mesh.collision_shapes)
            .SetEntryTypes(E_ListEntryTypes.STRUCTS)
            .SetID("LIST"),
        (new EmuButton(c1x, EMU_AUTO, 256, 32, "Add Sphere", function() {
            self.root.mesh.AddCollisionShape(MeshCollisionShapeSphere);
        }))
            .SetID("ADD SPHERE"),
        (new EmuButton(c1x, EMU_AUTO, 256, 32, "Add Box", function() {
            self.root.mesh.AddCollisionShape(MeshCollisionShapeBox);
        })).SetID("add_box"),
        (new EmuButton(c1x, EMU_AUTO, 256, 32, "Add Capsule", function() {
            self.root.mesh.AddCollisionShape(MeshCollisionShapeCapsule);
        })).SetID("add_capsule"),
        /*(new EmuButton(c1x, EMU_AUTO, 256, 32, "Add Trimesh (from mesh)", function() {
            //var trimesh = self.root.mesh.AddCollisionShape(MeshCollisionShapeTrimesh);
        }))
            .SetID("ADD TIRMESH"),
        (new EmuButton(c1x, EMU_AUTO, 256, 32, "Add Trimesh (from file)", function() {
            //var trimesh = self.root.mesh.AddCollisionShape(MeshCollisionShapeTrimesh);
        }))
            .SetID("ADD TRIMESH FROM FILE"),*/
        (new EmuButton(c1x, EMU_AUTO, 256, 32, "Duplicate", function() {
            var selection = self.GetSibling("LIST").GetSelectedItem();
            if (selection != undefined) {
                array_push(self.root.mesh.collision_shapes, variable_clone(selection));
            }
        }))
            .SetUpdate(function() {
                self.SetInteractive(!!self.GetSibling("LIST").GetSelectedItem());
                if (keyboard_check(vk_control) && keyboard_check_pressed(ord("D"))) {
                    self.callback();
                    self.GetSibling("LIST").ClearSelection();
                    self.GetSibling("LIST").Select(array_length(self.root.mesh.collision_shapes) - 1);
                }
            })
            .SetID("DUPLICATE"),
        (new EmuButton(c1x, EMU_AUTO, 256, 32, "Delete Shape", function() {
            var selection = self.GetSibling("LIST").GetSelection();
            if (selection + 1) {
                self.root.mesh.DeleteCollisionShape(selection);
            }
        }))
            .SetID("DELETE SHAPE"),
        // TODO right now i assume you'll just pack all of the data into the name, which isnt really ideal; later it would be really nice to have some kind of metadata options for these
        (new EmuInput(c1x, EMU_AUTO, 256, 32, "Shape name:", "", "name", 1000, E_InputTypes.STRING, function() {
            var selection = self.GetSibling("LIST").GetSelection();
            if (selection + 1) {
                self.root.mesh.RenameCollisionShape(selection, self.value);
            }
        }))
            .SetID("NAME"),
        // column 2
        new EmuButton(c2x, 32, 256, 32, "From Bounding Box", function() {
            var mesh = self.root.mesh;
            var bounds = mesh.physical_bounds;
            var shape = mesh.collision_shapes[self.GetSibling("LIST").GetSelection()];
            
            switch (shape.type) {
                case MeshCollisionShapes.BOX:
                    shape.position.x = mean(bounds.x1, bounds.x2);
                    shape.position.y = mean(bounds.y1, bounds.y2);
                    shape.position.z = mean(bounds.z1, bounds.z2);
                    shape.scale.x = abs(bounds.x2 - bounds.x1);
                    shape.scale.y = abs(bounds.y2 - bounds.y1);
                    shape.scale.z = abs(bounds.z2 - bounds.z1);
                    break;
                case MeshCollisionShapes.SPHERE:
                    shape.position.x = mean(bounds.x1, bounds.x2);
                    shape.position.y = mean(bounds.y1, bounds.y2);
                    shape.position.z = mean(bounds.z1, bounds.z2);
                    // the sphere is going to circumscribe the bounding box -
                    // not sure if simply touching the inside of one axis
                    // would be preferable, though
                    var diagonal = point_distance_3d(bounds.x1, bounds.y1, bounds.z1, bounds.x2, bounds.y2, bounds.z2);
                    shape.diameter = diagonal / 2;
                    break;
            }
            self.GetSibling("LIST").callback();
        })
            .SetID("FROM BOUNDS")
            .SetInteractive(false),
        new EmuText(c2x, EMU_AUTO, 256, 24, "Translation"),
        (new EmuInput(c2x, EMU_AUTO, 256, 24, "    x:", "", "", 6, E_InputTypes.REAL, function() {
            self.root.mesh.collision_shapes[self.GetSibling("LIST").GetSelection()].position.x = real(self.value);
        }))
            .SetNext("TRANS Y")
            .SetPrevious("TRANS Z")
            .SetRealNumberBounds(-9999, 9999)
            .SetID("TRANS X")
            .SetInteractive(false),
        (new EmuInput(c2x, EMU_AUTO, 256, 24, "    y:", "", "", 6, E_InputTypes.REAL, function() {
            self.root.mesh.collision_shapes[self.GetSibling("LIST").GetSelection()].position.y = real(self.value);
        }))
            .SetNext("TRANS Z")
            .SetPrevious("TRANS X")
            .SetRealNumberBounds(-9999, 9999)
            .SetID("TRANS Y")
            .SetInteractive(false),
        (new EmuInput(c2x, EMU_AUTO, 256, 24, "    z:", "", "", 6, E_InputTypes.REAL, function() {
            self.root.mesh.collision_shapes[self.GetSibling("LIST").GetSelection()].position.z = real(self.value);
        }))
            .SetNext("TRANS X")
            .SetPrevious("TRANS Y")
            .SetRealNumberBounds(-9999, 9999)
            .SetID("TRANS Z")
            .SetInteractive(false),
        new EmuText(c2x, EMU_AUTO, 256, 24, "Rotation"),
        (new EmuInput(c2x, EMU_AUTO, 256, 24, "    x:", "", "", 6, E_InputTypes.REAL, function() {
            self.root.mesh.collision_shapes[self.GetSibling("LIST").GetSelection()].rotation.x = real(self.value);
        }))
            .SetNext("ROT Y")
            .SetPrevious("ROT Z")
            .SetRealNumberBounds(0, 360)
            .SetID("ROT X")
            .SetInteractive(false),
        (new EmuInput(c2x, EMU_AUTO, 256, 24, "    y:", "", "", 6, E_InputTypes.REAL, function() {
            self.root.mesh.collision_shapes[self.GetSibling("LIST").GetSelection()].rotation.y = real(self.value);
        }))
            .SetNext("ROT Z")
            .SetPrevious("ROT X")
            .SetRealNumberBounds(0, 360)
            .SetID("ROT Y")
            .SetInteractive(false),
        (new EmuInput(c2x, EMU_AUTO, 256, 24, "    z:", "", "", 6, E_InputTypes.REAL, function() {
            self.root.mesh.collision_shapes[self.GetSibling("LIST").GetSelection()].rotation.z = real(self.value);
        }))
            .SetNext("ROT X")
            .SetPrevious("ROT Y")
            .SetRealNumberBounds(0, 360)
            .SetID("ROT Z")
            .SetInteractive(false),
        new EmuText(c2x, EMU_AUTO, 256, 24, "Scale"),
        (new EmuInput(c2x, EMU_AUTO, 256, 24, "    x:", "", "", 6, E_InputTypes.REAL, function() {
            self.root.mesh.collision_shapes[self.GetSibling("LIST").GetSelection()].scale.x = real(self.value);
        }))
            .SetNext("SCALE Y")
            .SetPrevious("SCALE Z")
            .SetRealNumberBounds(0.001, 9999)
            .SetID("SCALE X")
            .SetInteractive(false),
        (new EmuInput(c2x, EMU_AUTO, 256, 24, "    y:", "", "", 6, E_InputTypes.REAL, function() {
            self.root.mesh.collision_shapes[self.GetSibling("LIST").GetSelection()].scale.y = real(self.value);
        }))
            .SetNext("SCALE Z")
            .SetPrevious("SCALE X")
            .SetRealNumberBounds(0.001, 9999)
            .SetID("SCALE Y")
            .SetInteractive(false),
        (new EmuInput(c2x, EMU_AUTO, 256, 24, "    z:", "", "", 6, E_InputTypes.REAL, function() {
            self.root.mesh.collision_shapes[self.GetSibling("LIST").GetSelection()].scale.z = real(self.value);
        }))
            .SetNext("SCALE X")
            .SetPrevious("SCALE Y")
            .SetRealNumberBounds(0.001, 9999)
            .SetID("SCALE Z")
            .SetInteractive(false),
        new EmuText(c2x, EMU_AUTO, 256, 24, "Other"),
        (new EmuInput(c2x, EMU_AUTO, 256, 24, "    Radius:", "", "", 6, E_InputTypes.REAL, function() {
            var shape = self.root.mesh.collision_shapes[self.GetSibling("LIST").GetSelection()];
            switch (shape.type) {
                case MeshCollisionShapes.SPHERE: {
                    shape.diameter = real(self.value) * 2;
                } break;
                case MeshCollisionShapes.CAPSULE: {
                    shape.radius = real(self.value);
                } break;
            }
        }))
            .SetRealNumberBounds(0.001, 9999)
            .SetID("RADIUS")
            .SetInteractive(false),
        (new EmuInput(c2x, EMU_AUTO, 256, 24, "    Length:", "", "", 6, E_InputTypes.REAL, function() {
            self.root.mesh.collision_shapes[self.GetSibling("LIST").GetSelection()].length = real(self.value);
        }))
            .SetRealNumberBounds(0.001, 9999)
            .SetID("LENGTH")
            .SetInteractive(false),
    ]).AddDefaultCloseButton();
}