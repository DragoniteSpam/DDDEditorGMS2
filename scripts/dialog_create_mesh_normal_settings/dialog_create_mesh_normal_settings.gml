function dialog_create_mesh_normal_settings(root, selection) {
    var mode = Stuff.mesh_ed;
    
    var dialog = new EmuDialog(320, 240, "Normals");
    dialog.root = root;
    dialog.selection = selection;
    
    return dialog.AddContent([
        (new EmuButton(32, EMU_AUTO, 256, 32, "Set Flat Normals", function() {
            var selection = self.root.selection;
            for (var index = ds_map_find_first(selection); index != undefined; index = ds_map_find_next(selection, index)) {
                Game.meshes[index].SetNormalsFlat();
            }
            batch_again();
        }))
            .SetTooltip("Set the normals of each vertex equal to the normals of their triangle."),
        (new EmuButton(32, EMU_AUTO, 256, 32, "Set Flat Normals", function() {
            var selection = self.root.selection;
            for (var index = ds_map_find_first(selection); index != undefined; index = ds_map_find_next(selection, index)) {
                Game.meshes[index].SetNormalsSmooth(Settings.config.normal_threshold);
            }
            batch_again();
        }))
            .SetTooltip("Weigh the normals of each vertex based on the angle of their surrounding triangles, if the angle between them is less than the specified threshold."),
        (new EmuInput(32, EMU_AUTO, 256, 32, "Threshold:", string(Settings.config.normal_threshold), "degrees", 5, E_InputTypes.REAL, function() {
            Settings.config.normal_threshold = real(self.value);
        }))
            .SetTooltip("The threshold which the angle between two triangles must be less than in order for their vertix normals to be smoothed. (A threshold of zero is the same as flat shading.)"),
    ]).AddDefaultCloseButton();
}