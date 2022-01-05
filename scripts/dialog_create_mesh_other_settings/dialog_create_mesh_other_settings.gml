function dialog_create_mesh_other_settings(root, selection) {
    var dialog = new EmuDialog(320, 400, "Other mesh options");
    dialog.root = root;
    dialog.selection = selection;
    
    return dialog.AddContent([
        (new EmuButton(32, EMU_AUTO, 256, 32, "Normals", function() {
            if (ds_map_empty(self.root.selection)) return;
            dialog_create_mesh_normal_settings(self, self.root.selection);
        }))
            .SetTooltip("Adjust the vertex normals of the selected meshes."),
        (new EmuButton(32, EMU_AUTO, 256, 32, "Center", function() {
            var selection = self.root.selection;
            for (var index = ds_map_find_first(selection); index != undefined; index = ds_map_find_next(selection, index)) {
                Game.meshes[index].PositionAtCenter();
            }
            batch_again();
        }))
            .SetTooltip("Set the model's origin to its average central point (on the XY plane)."),
        (new EmuButton(32, EMU_AUTO, 256, 32, "Collision shapes", function() {
            dialog_create_mesh_collision_settings(self.root, ds_map_find_first(self.root.selection));
        }))
            .SetTooltip("Collision shape data to go with this mesh.")
            .SetInteractive(ds_map_size(selection) == 1),
        (new EmuButton(32, EMU_AUTO, 256, 32, "Invert Transparency", function() {
            var selection = self.root.selection;
            for (var index = ds_map_find_first(selection); index != undefined; index = ds_map_find_next(selection, index)) {
                mesh_all_invert_alpha(Game.meshes[index]);
            }
            batch_again();
        }))
            .SetTooltip("Because literally nothing is standard with the OBJ file format, sometimes the \"Tr\" material attribute is \"transparency,\" and sometimes it's \"opacity\" (1 - transparency). Click here to toggle between them."),
        (new EmuButton(32, EMU_AUTO, 256, 32, "Reset Transparency", function() {
            var selection = self.root.selection;
            for (var index = ds_map_find_first(selection); index != undefined; index = ds_map_find_next(selection, index)) {
                mesh_all_reset_alpha(Game.meshes[index]);
            }
            batch_again();
        }))
            .SetTooltip("Set the alpha of every vertex to 1."),
        (new EmuButton(32, EMU_AUTO, 256, 32, "Reset Vertex Color", function() {
            var selection = self.root.selection;
            for (var index = ds_map_find_first(selection); index != undefined; index = ds_map_find_next(selection, index)) {
                var mesh = Game.meshes[index];
                mesh_all_reset_color(mesh);
            }
            batch_again();
        }))
            .SetTooltip("Set the blending color of every vertex to white."),
        (new EmuButton(32, EMU_AUTO, 256, 32, "Generate Reflections", function() {
            var selection = self.root.selection;
            for (var index = ds_map_find_first(selection); index != undefined; index = ds_map_find_next(selection, index)) {
                Game.meshes[index].GenerateReflections();
            }
            batch_again();
        }))
            .SetTooltip("Auto-generate reflections for all selected meshes and their submeshes."),
    ]).AddDefaultCloseButton();
}