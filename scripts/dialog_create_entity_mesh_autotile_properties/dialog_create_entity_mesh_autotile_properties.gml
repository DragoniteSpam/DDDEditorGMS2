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
    
    //var el_slope = create_checkbox
    var el_slope = create_radio_array(col1_x, yy, "Slope Direction", ew, eh, function(radio) {
        var mesh = radio.root.root.mesh;
        var start_slope = mesh.slope;
        mesh.slope = global.at_mask_values[radio.value];
        if (start_slope != mesh.slope) {
            selection_update_autotiles();
        }
    }, global.at_mask_lookup[? mesh.slope], dg);
    create_radio_array_options(el_slope, ["None", "Northwest", "North", "Northeast", "West", "East", "Southwest", "South", "East"]);
    el_slope.tooltip = "I realize this is ambiguous. Pick the direction of the top of the slope (i.e. if the bottom is on the West side and the top is on the East side, pick East). I'll probably change this to have it auto-calculate later because there's literally no reason to ever pick a direction other than the face of the mesh autotile.";
    yy += el_slope.height + spacing;
    
    var b_width = 128;
    var b_height = 32;
    var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);
    
    ds_list_add(dg.contents,
        el_slope,
        el_confirm
    );
    
    return dg;
}