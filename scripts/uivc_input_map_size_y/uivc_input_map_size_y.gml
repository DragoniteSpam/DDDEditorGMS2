function uivc_input_map_size_y(input) {
    var selection = ui_list_selection(input.root.el_map_list);
    
    if (selection + 1) {
        var map = Game.maps[selection];
        var clear = true;
        var yy = real(input.value);
        for (var i = 0; i < ds_list_size(map.contents.all_entities); i++) {
            clear = clear && (map.contents.all_entities[| i].yy < yy);
        }
        
        if (clear) {
            map.SetSize(map.xx, yy, map.zz);
        } else {
            var dialog = emu_dialog_confirm(input, "If you do this, entities will be deleted and you will not be able to get them back. Is this okay?", function() {
                self.root.map.SetSize(self.root.xx, self.root.yy, self.root.zz);
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