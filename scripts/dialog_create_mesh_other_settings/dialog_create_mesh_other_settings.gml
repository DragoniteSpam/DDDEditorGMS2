function dialog_create_mesh_other_settings(list, selection) {
    var ew = 256;
    var eh = 32;
    var spacing = 32;
    var c1 = spacing;
    var c2 = c1 + ew + spacing;
    
    var dialog = new EmuDialog(c2 + ew + spacing, 400, "Other mesh options");
    dialog.active_shade = 0;
    dialog.list = list;
    dialog.selection = selection;
    
    dialog.AddContent([
        (new EmuButton(c1, EMU_BASE, ew, eh, "Normals", function() {
            dialog_create_mesh_normal_settings(self.root.list, self.root.selection);
        }))
            .SetTooltip("Adjust the vertex normals of the selected meshes."),
        (new EmuButton(c1, EMU_AUTO, ew, eh, "Invert Transparency", function() {
            var selection = self.root.selection;
            for (var i = 0, n = array_length(selection); i < n; i++) {
                self.root.list[selection[i]].ActionInvertAlpha();
            }
            batch_again();
        }))
            .SetTooltip("Because literally nothing is standard with the OBJ file format, sometimes the \"Tr\" material attribute is \"transparency,\" and sometimes it's \"opacity\" (1 - transparency). Click here to toggle between them."),
        (new EmuButton(c1, EMU_AUTO, ew, eh, "Reset Transparency", function() {
            var selection = self.root.selection;
            for (var i = 0, n = array_length(selection); i < n; i++) {
                self.root.list[selection[i]].ActionResetAlpha();
            }
            batch_again();
        }))
            .SetTooltip("Set the alpha of every vertex to 1."),
        (new EmuButton(c1, EMU_AUTO, ew, eh, "Reset Vertex Color", function() {
            var selection = self.root.selection;
            for (var i = 0, n = array_length(selection); i < n; i++) {
                self.root.list[selection[i]].ActionResetColour();
            }
            batch_again();
        }))
            .SetTooltip("Set the blending color of every vertex to white."),
        (new EmuButton(c1, EMU_AUTO, ew, eh, "Bake Material Color", function() {
            var selection = self.root.selection;
            for (var i = 0, n = array_length(selection); i < n; i++) {
                self.root.list[selection[i]].ActionBakeDiffuseMaterialColor();
            }
            batch_again();
        }))
            .SetTooltip("Blend the material diffuse color of every submesh into the vertex color."),
        (new EmuButton(c1, EMU_AUTO, ew, eh, "Reset Material Color", function() {
            var selection = self.root.selection;
            for (var i = 0, n = array_length(selection); i < n; i++) {
                self.root.list[selection[i]].ActionResetDiffuseMaterialColour();
            }
            batch_again();
        }))
            .SetTooltip("Set the diffuse color of every submesh's material to white."),
        
        
        
        
        
        (new EmuButton(c2, EMU_BASE, ew, eh, "Center", function() {
            var selection = self.root.selection;
            for (var i = 0, n = array_length(selection); i < n; i++) {
                self.root.list[selection[i]].PositionAtCenter();
            }
            batch_again();
        }))
            .SetTooltip("Set the model's origin to its average central point (on the XY plane)."),
        (new EmuButton(c2, EMU_AUTO, ew, eh, "Snap to Floor", function() {
            var selection = self.root.selection;
            for (var i = 0, n = array_length(selection); i < n; i++) {
                self.root.list[selection[i]].ActionFloor();
            }
            batch_again();
        }))
            .SetTooltip("Set the bottom of the mesh's physical bounds to the z = 0 plane."),
        (new EmuButton(c2, EMU_AUTO, ew, eh, "Reverse Faces", function() {
            var selection = self.root.selection;
            for (var i = 0, n = array_length(selection); i < n; i++) {
                self.root.list[selection[i]].ActionReverseFaces();
            }
        }))
            .SetTooltip("Collision shape data to go with this mesh."),
        (new EmuButton(c2, EMU_AUTO, ew, eh, "Collision shapes", function() {
            if (array_length(self.root.selection) != 1) return;
            dialog_create_mesh_collision_settings(self.root.list[self.root.selection[0]]);
        }))
            .SetTooltip("Collision shape data to go with this mesh.")
            .SetInteractive(array_length(selection) == 1),
        (new EmuButton(c2, EMU_AUTO, ew, eh, "Render overhead wireframe", function() {
            if (array_length(self.root.selection) != 1) return;
            dialog_create_mesh_render_overhead_wireframe(self.root.list[self.root.selection[0]]);
        }))
            .SetTooltip("Render an overhead wireframe of this mesh.")
            .SetInteractive(array_length(selection) == 1),
    ]);
    
    if (IS_DEFAULT_MODE) {
        dialog.AddContent([
            (new EmuButton(c2, EMU_AUTO, ew, eh, "Generate Reflections", function() {
                var selection = self.root.selection;
                for (var i = 0, n = array_length(selection); i < n; i++) {
                    self.root.list[real(selection[i])].GenerateReflections();
                }
                batch_again();
            }))
                .SetTooltip("Auto-generate reflections for all selected meshes and their submeshes."),
        ]);
    }
    
    return dialog.AddDefaultCloseButton();
}