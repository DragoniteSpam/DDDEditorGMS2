function dialog_create_commit_variable_resize(root) {
    var dw = 400;
    var dh = 240;
    var value = real(root.value);
    
    if (value > 65535) return noone;
    var count = ds_list_size(Stuff.variables);
    if (value == count) return noone;
    
    if (value < count) {
        return dialog_create_yes_or_no(root,
            "Reduce the number of global variables? Anything beyond the new limit will be lost. (If in doubt, leave it alone. The memory footprint is pretty low and there isn't really a consequence to having too many.)",
            function(dialog) {
                var value = real(dialog.root.root.value);
                var times = ds_list_size(Stuff.variables) - value;
                repeat (times) ds_list_pop(Stuff.variables);
                
                var base_dialog = dialog.root.root.root;
                if (value <= ui_list_selection(base_dialog.el_list)) {
                    ui_list_deselect(base_dialog.el_list);
                }
                
                while (ds_list_size(base_dialog.el_list.entries) > value) {
                    ds_list_pop(base_dialog.el_list.entries);
                }
                
                ui_list_reset_view(base_dialog.el_list);
                
                dialog_destroy();
            }
        );
    }
    
    for (var i = ds_list_size(Stuff.variables); i < value; i++) {
        var name = "Variable" + string(i);
        ds_list_add(Stuff.variables, [name, 0]);
        create_list_entries(root.root.el_list, name);
    }
    
    return noone;
}