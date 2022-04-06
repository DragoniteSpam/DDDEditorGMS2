function dialog_create_mesh_other_settings(selection) {
    var dialog = new EmuDialog(320, 400, "Other mesh options");
    dialog.selection = selection;
    
    return dialog.AddContent([
        (new EmuButton(32, EMU_AUTO, 256, 32, "Normals", function() {
            dialog_create_mesh_normal_settings(self.root.selection);
        }))
            .SetTooltip("Adjust the vertex normals of the selected meshes."),
        (new EmuButton(32, EMU_AUTO, 256, 32, "Collision shapes", function() {
            if (array_length(self.root.selection) != 1) return;
            dialog_create_mesh_collision_settings(Game.meshes[self.root.selection[0]]);
        }))
            .SetTooltip("Collision shape data to go with this mesh.")
            .SetInteractive(array_length(selection) == 1),
        (new EmuButton(32, EMU_AUTO, 256, 32, "Center", function() {
            var selection = self.root.selection;
            for (var i = 0, n = array_length(selection); i < n; i++) {
                Game.meshes[selection[i]].PositionAtCenter();
            }
            batch_again();
        }))
            .SetTooltip("Set the model's origin to its average central point (on the XY plane)."),
        (new EmuButton(32, EMU_AUTO, 256, 32, "Invert Transparency", function() {
            var selection = self.root.selection;
            for (var i = 0, n = array_length(selection); i < n; i++) {
                Game.meshes[selection[i]].ActionInvertAlpha();
            }
            batch_again();
        }))
            .SetTooltip("Because literally nothing is standard with the OBJ file format, sometimes the \"Tr\" material attribute is \"transparency,\" and sometimes it's \"opacity\" (1 - transparency). Click here to toggle between them."),
        (new EmuButton(32, EMU_AUTO, 256, 32, "Reset Transparency", function() {
            var selection = self.root.selection;
            for (var i = 0, n = array_length(selection); i < n; i++) {
                Game.meshes[selection[i]].ActionResetAlpha();
            }
            batch_again();
        }))
            .SetTooltip("Set the alpha of every vertex to 1."),
        (new EmuButton(32, EMU_AUTO, 256, 32, "Reset Vertex Color", function() {
            var selection = self.root.selection;
            for (var i = 0, n = array_length(selection); i < n; i++) {
                Game.meshes[selection[i]].ActionResetColour();
            }
            batch_again();
        }))
            .SetTooltip("Set the blending color of every vertex to white."),
        (new EmuButton(32, EMU_AUTO, 256, 32, "Generate Reflections", function() {
            var selection = self.root.selection;
            for (var i = 0, n = array_length(selection); i < n; i++) {
                Game.meshes[real(selection[i])].GenerateReflections();
            }
            batch_again();
        }))
            .SetTooltip("Auto-generate reflections for all selected meshes and their submeshes."),
    ]).AddDefaultCloseButton();
}