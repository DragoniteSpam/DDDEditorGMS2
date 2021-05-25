function uivc_input_map_size_x(input) {
    var selection = ui_list_selection(input.root.el_map_list);
    
    if (selection + 1) {
        var map = Stuff.all_maps[| selection];
        var clear = true;
        var xx = real(input.value);
        for (var i = 0; i < ds_list_size(map.contents.all_entities); i++) {
            clear = clear && (map.contents.all_entities[| i].xx < xx);
        }
        
        if (clear) {
            data_resize_map(map, xx, map.yy, map.zz);
        } else {
            var dialog = emu_dialog_confirm(input, "If you do this, entities will be deleted and you will not be able to get them back. Is this okay?", function(dialog) {
                    data_resize_map(dialog.root.map, dialog.root.xx, dialog.root.yy, dialog.root.zz);
                    dialog_destroy();
            }, undefined, undefined, undefined, function(button) {
                var map = button.root.map;
                var base_ui = button.root.root.root;
                ui_input_set_value(base_ui.el_dim_x, string(map.xx));
                ui_input_set_value(base_ui.el_dim_y, string(map.yy));
                ui_input_set_value(base_ui.el_dim_z, string(map.zz));
                dialog_destroy();
            });
            dialog.map = map;
            dialog.xx = xx;
            dialog.yy = map.yy;
            dialog.zz = map.zz;
        }
    }
}