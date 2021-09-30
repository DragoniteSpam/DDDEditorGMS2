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
    
    var el_normals = create_button(c1x, yy, "Normals", ew, eh, fa_center, function(button) {
        if (ds_map_empty(button.root.selection)) return;
        dialog_create_mesh_normal_settings(button, button.root.selection);
    }, dg);
    el_normals.tooltip = "Adjust the vertex normals of the selected meshes.";
    yy += el_normals.height + spacing;
    
    var el_center = create_button(c1x, yy, "Center model", ew, eh, fa_center, function(button) {
        var selection = button.root.selection;
        for (var index = ds_map_find_first(selection); index != undefined; index = ds_map_find_next(selection, index)) {
            Game.meshes[index].PositionAtCenter();
        }
        batch_again();
    }, dg);
    el_center.tooltip = "Set the model's origin to its average central point (on the XY plane).";
    yy += el_center.height + spacing;
    
    var el_collision = create_button(c1x, yy, "Collision shapes", ew, eh, fa_center, function(button) {
        dialog_create_mesh_collision_settings(button.root, ds_map_find_first(button.root.selection));
    }, dg);
    el_collision.tooltip = "Collision shape data to go with this mesh.";
    el_collision.interactive = (ds_map_size(selection) == 1);
    yy += el_collision.height + spacing;
    
    var el_transparency_invert = create_button(c1x, yy, "Invert Transparency", ew, eh, fa_center, function(button) {
        var selection = button.root.selection;
        for (var index = ds_map_find_first(selection); index != undefined; index = ds_map_find_next(selection, index)) {
            var mesh = Game.meshes[index];
            mesh_all_invert_alpha(mesh);
        }
        batch_again();
    }, dg);
    el_transparency_invert.tooltip = "Because literally nothing is standard with the OBJ file format, sometimes the \"Tr\" material attribute is \"transparency,\" and sometimes it's \"opacity\" (1 - transparency). Click here to toggle between them.";
    yy += el_transparency_invert.height + spacing;
    
    var b_width = 128;
    var b_height = 32;
    var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);
    
    ds_list_add(dg.contents,
        el_center,
        el_collision,
        el_normals,
        el_transparency_invert,
        el_confirm
    );
    
    return dg;
}