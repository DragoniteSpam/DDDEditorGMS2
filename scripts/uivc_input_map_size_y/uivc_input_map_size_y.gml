function uivc_input_map_size_y(input) {
    var selection = ui_list_selection(input.root.el_map_list);
    
    if (selection + 1) {
        var map = Stuff.all_maps[| selection];
        var clear = true;
        var yy = real(input.value);
        for (var i = 0; i < ds_list_size(map.contents.all_entities); i++) {
            clear = clear && (map.contents.all_entities[| i].yy < yy);
        }
        
        if (clear) {
            data_resize_map(map, map.xx, yy, map.zz);
        } else {
            var dialog = dialog_create_yes_or_no(input, "If you do this, entities will be deleted and you will not be able to get them back. Is this okay?", function() {
                data_resize_map(self.root.map, self.root.xx, self.root.yy, self.root.zz);
                self.root.Dispose();
            }, undefined, undefined, undefined, function() {
                var map = self.root.map;
                var base_ui = self.root.root.root;
                ui_input_set_value(base_ui.el_dim_x, string(map.xx));
                ui_input_set_value(base_ui.el_dim_y, string(map.yy));
                ui_input_set_value(base_ui.el_dim_z, string(map.zz));
                self.root.Dispose();
            });
            dialog.map = map;
            dialog.xx = map.xx;
            dialog.yy = yy;
            dialog.zz = map.zz;
        }
    }
}