function dialog_create_manager_mesh_autotile(root) {
    var map = Stuff.map.active_map;
    var map_contents = map.contents;

    var dw = 960;
    var dh = 640;

    var dg = dialog_create(dw, dh, "Data: Mesh Autotiles", undefined, undefined, root);

    var columns = 3;
    var spacing = 16;
    var ew = dw / columns - spacing * 2;
    var eh = 24;

    var b_width = 128;
    var b_height = 32;

    var xx = 16;
    var yy = 64;
    var xx_base = xx;
    var yy_base = yy;
    var mbw = 64 - spacing;
    var mbh = eh;
    
    var el_list = create_list(xx, yy, "All Mesh Autotiles", "<no mesh autotiles>", ew, eh, 16, function(list) {
        
    }, false, dg, Stuff.all_mesh_autotiles);
    dg.el_list = el_list;
    
    yy += ui_get_list_height(el_list) + spacing;
    
    var el_add = create_button(xx, yy, "Add Mesh Autotile", ew, eh, fa_center, function(button) {
        
    }, dg);
    dg.el_add = el_add;
    
    yy += el_add.height + spacing;
    
    var el_remove = create_button(xx, yy, "Remove Mesh Autotile", ew, eh, fa_center, function(button) {
        
    }, dg);
    dg.el_remove = el_remove;
    
    yy += el_remove.height + spacing;
    
/*
    dg.buttons = array_create(array_length(map_contents.mesh_autotiles_top));
    dg.icons = array_create(array_length(map_contents.mesh_autotiles_top));
    array_clear(dg.buttons, noone);

    for (var i = 0; i < array_length(map_contents.mesh_autotiles_top); i++) {
        var button = create_button(xx, yy, string(i), mbw, mbh, fa_center, dmu_dialog_load_mesh_autotile, dg);
        button.tooltip = "Import a mesh for top mesh autotile #" + string(i) + ". It should take the shape of the icon below, with green representing the outer part and brown representing the inner part.";
        button.color = map_contents.mesh_autotiles_top[i] ? c_black : c_gray;
        button.key = i;
        button.file_dropper_action = uifd_load_mesh_autotile;
        ds_list_add(dg.contents, button);
        dg.buttons[i] = button;
    
        var icon = create_image_button(xx + spacing / 2, yy + button.height + spacing, "b", spr_autotile_blueprint, 32, 32, fa_center, null, dg);
        icon.index = i;
        icon.outline = false;
        icon.interactive = false;
    
        xx = xx + mbw + spacing;
    
        if (i % columns == columns - 1) {
            xx = xx_start;
            yy += mbh + icon.height + spacing * 2;
        }
    
        ds_list_add(dg.contents, icon);
        dg.icon[i] = icon;
    }
*/
    var el_import_series = create_button(dw / 4 - b_width / 2, dh - 32 - b_height / 2, "Import Batch", b_width, b_height, fa_center, dmu_dialog_mesh_autotile_import_batch, dg);
    el_import_series.tooltip = "Import autotile meshes in batch. If you want to load an entire series at once you should probably choose this option, because selecting them one-by-one would be very slow.";
    var el_clear = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Clear All", b_width, b_height, fa_center, dmu_dialog_mesh_autotile_remove_all, dg);
    el_clear.tooltip = "Deletes all imported mesh autotiles. Entities which use them will continue to exist, but will be invisible."
    
    var el_confirm = create_button(dw * 3 / 4 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);

    ds_list_add(dg.contents,
        el_list,
        el_add,
        el_remove,
        el_import_series,
        el_clear,
        el_confirm
    );

    return dg;


}
