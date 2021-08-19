function dialog_create_mesh_other_settings(root, selection) {
    var mode = Stuff.mesh_ed;
    
    var dw = 320;
    var dh = 320;
    
    var dg = dialog_create(dw, dh, "Other mesh options", dialog_default, dialog_destroy, root);
    dg.selection = selection;
    
    var columns = 1;
    var ew = dw / columns - 64;
    var eh = 24;
    
    var vx1 = ew / 2;
    var vy1 = 0;
    var vx2 = ew;
    var vy2 = eh;
    
    var c1x = 0 * dw / columns + 32;
    var spacing = 16;
    
    var yy = 64;
    var yy_base = 64;
    
    var el_center = create_button(c1x, yy, "Center model", ew, eh, fa_center, function(button) {
        var selection = button.root.selection;
        for (var index = ds_map_find_first(selection); index != undefined; index = ds_map_find_next(selection, index)) {
            Game.meshes[index].PositionAtCenter();
        }
        batch_again();
    }, dg);
    el_center.tooltip = "Set the model's origin to its average central point (on the XY plane).";
    yy += el_center.height + spacing;
    
    var b_width = 128;
    var b_height = 32;
    var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);
    
    ds_list_add(dg.contents,
        el_center,
        el_confirm
    );
    
    return dg;
}