function dialog_create_commit_variable_resize(root) {
    var dw = 400;
    var dh = 240;
    var value = real(root.value);
    
    if (value > 65535) return noone;
    var count = array_length(Stuff.variables);
    if (value == count) return noone;
    
    if (value < count) {
        return emu_dialog_confirm(root,
            "Reduce the number of global variables? Anything beyond the new limit will be lost. (If in doubt, leave it alone. The memory footprint is pretty low and there isn't really a consequence to having too many.)",
            function() {
                var value = real(self.root.root.value);
                var times = array_length(Stuff.variables) - value;
                repeat (times) array_pop(Stuff.variables);
                
                var base_dialog = self.root.root.root;
                if (value <= ui_list_selection(base_dialog.el_list)) {
                    ui_list_deselect(base_dialog.el_list);
                }
                
                while (ds_list_size(base_dialog.el_list.entries) > value) {
                    ds_list_pop(base_dialog.el_list.entries);
                }
                
                ui_list_reset_view(base_dialog.el_list);
                
                self.root.Dispose();
            }
        );
    }
    
    for (var i = array_length(Stuff.variables); i < value; i++) {
        var name = "Variable" + string(i);
        array_push(Stuff.variables, { name: name, value: 0 });
        create_list_entries(root.root.el_list, name);
    }
    
    return noone;
}