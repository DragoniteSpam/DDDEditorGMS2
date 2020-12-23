function dialog_create_entity_mesh_autotile_properties(root) {
    var list = Stuff.map.selected_entities;
    var mesh = list[| 0];
    
    var dw = 320;
    var dh = 400;
    
    var dg = dialog_create(dw, dh, "Mesh Autotile properties", dialog_default, dc_close_no_questions_asked, root);
    dg.mesh = mesh;
    
    var spacing = 16;
    var columns = 1;
    var spacing = 16;
    var ew = dw / columns - spacing * 2;
    var eh = 24;
    
    var col1_x = spacing;
    
    var vx1 = dw / (columns * 2) - 32;
    var vy1 = 0;
    var vx2 = vx1 + dw / (columns * 2);
    var vy2 = eh;
    
    var yy = 64;
    var yy_base = yy;
    
    var el_slope = create_checkbox(col1_x, yy, "Slope", ew, eh, function(checkbox) {
        var mesh = checkbox.root.mesh;
        mesh.terrain_type = checkbox.value ? MeshAutotileLayers.SLOPE : MeshAutotileLayers.BASE;
        selection_update_autotiles();
    }, false, dg);
    el_slope.tooltip = "Is the selected autotile(s) a slope?";
    
    yy += el_slope.height + spacing;
    
    var el_type = create_list(col1_x, yy, "Mesh Autotile type", "<no mesh autotiles types>", ew, eh, 8, function(list) {
        var mesh = list.root.mesh;
        var selection = ui_list_selection(list);
        mesh.autotile_id = list.entries[| selection];
    }, false, dg, Stuff.all_mesh_autotiles);
    el_type.allow_deselect = false;
    el_type.entries_are = ListEntries.INSTANCES;
    
    var b_width = 128;
    var b_height = 32;
    var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);
    
    ds_list_add(dg.contents,
        el_slope,
        el_type,
        el_confirm,
    );
    
    return dg;
}