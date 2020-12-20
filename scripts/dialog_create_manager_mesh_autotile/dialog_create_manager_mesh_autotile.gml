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

    var c1x = dw / columns * 0 + spacing;
    var c2x = dw / columns * 1 + spacing;
    var c3x = dw / columns * 2 + spacing;
    var yy = 64;
    var yy_base = yy;
    
    var vx1 = 0;
    var vy1 = eh;
    var vx2 = ew;
    var vy2 = eh * 2;
    
    dg.Select = method(dg, function(index) {
        if (index + 1) {
            var autotile = Stuff.all_mesh_autotiles[| index];
            ui_input_set_value(el_name, autotile.name);
            ui_input_set_value(el_name_internal, autotile.internal_name);
            el_name_internal.color = c_black;
            el_name_internal.emphasis = false;
        }
    });
    
    var el_list = create_list(c1x, yy, "All Mesh Autotiles", "<no mesh autotiles>", ew, eh, 16, function(list) {
        list.root.Select(ui_list_selection(list));
    }, false, dg, Stuff.all_mesh_autotiles);
    el_list.onmiddleclick = function(list) {
        ds_list_sort_name(Stuff.all_mesh_autotiles);
    };
    el_list.entries_are = ListEntries.INSTANCES;
    dg.el_list = el_list;
    
    yy += ui_get_list_height(el_list) + spacing;
    
    var el_add = create_button(c1x, yy, "Add Mesh Autotile", ew, eh, fa_center, function(button) {
        var autotile = new DataMeshAutotile("MeshAutotile" + string(ds_list_size(Stuff.all_mesh_autotiles)));
        ds_list_add(Stuff.all_mesh_autotiles, autotile);
    }, dg);
    dg.el_add = el_add;
    
    yy += el_add.height + spacing;
    
    var el_remove = create_button(c1x, yy, "Remove Mesh Autotile", ew, eh, fa_center, function(button) {
        var selection = ui_list_selection(button.root.el_list);
        if (selection + 1) {
            Stuff.all_mesh_autotiles[| selection].Destroy();
            ds_list_delete(Stuff.all_mesh_autotiles, selection);
            ui_list_deselect(button.root.el_list);
        }
    }, dg);
    dg.el_remove = el_remove;
    
    yy += el_remove.height + spacing;
    
    yy = yy_base;
    
    var el_name = create_input(c2x, yy, "Name:", ew, eh, function(input) {
        var selection = ui_list_selection(input.root.el_list);
        if (selection + 1) {
            Stuff.all_mesh_autotiles[| selection].name = input.value;
        }
    }, "", "name", validate_string, 0, 1, VISIBLE_NAME_LENGTH, vx1, vy1, vx2, vy2, dg);
    dg.el_name = el_name;
    
    yy += el_name.height * 2 + spacing;
    
    var el_name_internal = create_input(c2x, yy, "Internal Name:", ew, eh, function(input) {
        var selection = ui_list_selection(input.root.el_list);
        if (selection + 1) {
            var already = internal_name_get(input.value);
            if (!already || already == Stuff.all_mesh_autotiles[| selection]) {
                internal_name_remove(Stuff.all_mesh_autotiles[| selection].internal_name);
                internal_name_set(Stuff.all_mesh_autotiles[| selection], input.value);
                input.color = c_black;
            } else {
                input.color = c_red;
            }
        }
    }, "", "internal name", validate_string_internal_name, 0, 1, INTERNAL_NAME_LENGTH, vx1, vy1, vx2, vy2, dg);
    dg.el_name_internal = el_name_internal;
    
    yy += el_name_internal.height * 2 + spacing;
    
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
        el_name,
        el_name_internal,
        el_import_series,
        el_clear,
        el_confirm
    );

    return dg;


}
