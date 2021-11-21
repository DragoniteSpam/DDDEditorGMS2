function dialog_create_settings_data_variables(dialog) {
    var dw = 720;
    var dh = 640;
    
    var dg = dialog_create(dw, dh, "Data Settings: Global Variables", dialog_default, dialog_destroy, dialog);
    
    var ew = dw / 2 - 64;
    var eh = 24;
    
    var vx1 = ew / 2 + 16;
    var vy1 = 0;
    var vx2 = ew;
    var vy2 = eh;
    
    var c2 = dw / 2;
    var spacing = 16;
    
    var yy = 64;
    var yy_start = 64;
    
    var n_variables = array_length(Game.vars.variables);
    var el_list = create_list(32, yy, "Global Variables (" + string(n_variables) + ")", "<no variables>", ew, eh, 16, function(list) {
        var selection = ui_list_selection(list);
        if (selection + 1) {
            var var_data = Game.vars.variables[selection];
            ui_input_set_value(list.root.el_name, var_data.name);
            list.root.el_default.value = string(var_data.value);
        }
    }, false, dg);
    for (var i = 0; i < n_variables; i++) {
        var var_data = Game.vars.variables[i];
        create_list_entries(el_list, var_data.name + ": " + string(var_data.value));
    }
    el_list.numbered = true;
    dg.el_list = el_list;
    yy += el_list.GetHeight() + spacing;
    
    var el_add = create_button(32, yy, "Add", ew, eh, fa_center, function(button) {
        
    }, dg);
    yy += el_add.height + spacing;
    
    var el_delete = create_button(32, yy, "Delete", ew, eh, fa_center, function(button) {
        
    }, dg);
    yy += el_delete.height + spacing;
    
    yy = yy_start;
    
    var el_name = create_input(c2 + 32, yy, "Variable name:", ew, eh, function(list) {
        var base_dialog = list.root;
        var selection = ui_list_selection(base_dialog.el_list);
        if (selection + 1) {
            var var_data = Game.vars.variables[selection];
            var_data.name = base_dialog.el_name.value;
            base_dialog.el_list.entries[| selection] = var_data.name + ": " + string(var_data.value);
        }
    }, "", "", validate_string, 0, 1, VISIBLE_NAME_LENGTH, vx1, vy1, vx2, vy2, dg);
    yy += el_name.height + spacing;
    dg.el_name = el_name;
    var el_default = create_input(c2 + 32, yy, "Default value", ew, eh, function(input) {
        var base_dialog = input.root;
        var selection = ui_list_selection(base_dialog.el_list);
        if (selection + 1) {
            var var_data = Game.vars.variables[selection];
            var_data.value = real(input.value);
            input.root.el_list.entries[| selection] = var_data.name + ": " + string(var_data.value);
        }
    }, 0, "number", validate_double, -BILLION, BILLION, 12, vx1, vy1, vx2, vy2, dg);
    yy += el_default.height + spacing;
    dg.el_default = el_default;
    
    var b_width = 128;
    var b_height = 32;
    var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);
    
    ds_list_add(dg.contents,
        el_list,
        el_name,
        el_default,
        el_add,
        el_delete,
        el_confirm
    );
    
    return dg;
}