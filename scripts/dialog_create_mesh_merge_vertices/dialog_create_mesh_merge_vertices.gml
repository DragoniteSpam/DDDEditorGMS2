function dialog_create_mesh_merge_vertices(list, selection) {
    var dw = 400;
    var dh = 240;
    
    var c1x = 32;
    var c2x = 416;
    
    var dialog = new EmuDialog(dw, dh, "Render Overhead Wireframe");
    dialog.list = list;
    dialog.selection = selection;
    dialog.render = undefined;
    
    dialog.AddContent([
        new EmuInput(c1x, 32, 320, 32, "Threshold:", "0.1", "How close together vertices should be before merging", 4, E_InputTypes.REAL, emu_null)
            .SetID("THRESHOLD")
    ]).AddDefaultConfirmCancelButtons("Merge", function() {
        var selection = self.root.selection;
        var threshold = real(self.GetSibling("THRESHOLD").value);
        for (var i = 0, n = array_length(selection); i < n; i++) {
            self.root.list[selection[i]].ActionMegeVertices(threshold);
        }
        emu_dialog_close_auto();
    }, "Cancel", emu_dialog_close_auto)
}