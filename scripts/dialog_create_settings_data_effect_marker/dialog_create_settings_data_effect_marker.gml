function dialog_create_settings_data_effect_marker(dialog) {
    var dw = 320;
    var dh = 680;
    
    var dg = dialog_create(dw, dh, "Data Settings: Effect Markers", dialog_default, dialog_destroy, dialog);
    
    var ew = dw - 64;
    var eh = 24;
    
    var vx1 = ew / 3;
    var vy1 = 0;
    var vx2 = ew;
    var vy2 = eh;
    
    var spacing = 16;
    
    var yy = 64;
    var yy_start = 64;
    
    var el_list = create_list(32, yy, "Effect Markers", "", ew, eh, 16, function(list) {
        var selection = ui_list_selection(list);
        ui_input_set_value(list.root.el_name, Game.vars.effect_markers[selection]);
    }, false, dg, Game.vars.effect_markers);
    el_list.tooltip = "You can use this to denote effects that you want to represent ambient things in the world, such as fish that swim around in water or birds that fly overhead.";
    el_list.numbered = true;
    el_list.allow_deselect = false;
    if (array_length(Game.vars.effect_markers) > 0) {
        ui_list_select(el_list, 0);
    }
    dg.el_list = el_list;
    
    yy += el_list.GetHeight() + spacing;
    
    var el_add = create_button(32, yy, "Add", ew, eh, fa_middle, function(button) {
        var selection = ui_list_selection(button.root.el_list);
        array_insert(Game.vars.effect_markers, selection + 1, "Effect Marker " + string(array_length(Game.vars.effect_markers)));
        ui_list_deselect(button.root.el_list);
        ui_list_select(button.root.el_list, selection + 1);
    }, dg);
    yy += el_add.height + spacing;
    
    var el_remove = create_button(32, yy, "Remove", ew, eh, fa_middle, function(button) {
        var selection = ui_list_selection(button.root.el_list);
        if (selection > -1) {
            array_delete(Game.vars.effect_markers, selection, 1);
            if (array_length(Game.vars.effect_markers) > selection) {
                ui_list_select(button.root.el_list, selection);
            } else {
                ui_list_deselect(button.root.el_list);
            }
        }
    }, dg);
    yy += el_remove.height + spacing;
    
    var el_name = create_input(32, yy, "Name:", ew, eh, function(input) {
        var selection = ui_list_selection(input.root.el_list);
        if (selection + 1) {
            Game.vars.effect_markers[@ selection] = input.value;
        }
    }, "", "16 characters", validate_string, 0, 1, VISIBLE_NAME_LENGTH, vx1, vy1, vx2, vy2, dg);
    if (array_length(Game.vars.effect_markers) > 0) {
        ui_input_set_value(el_name, Game.vars.effect_markers[0]);
    }
    yy += el_name.height + spacing;
    dg.el_name = el_name;
    
    yy += el_name.height + spacing;
    
    var b_width = 128;
    var b_height = 32;
    var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);
    
    ds_list_add(dg.contents,
        el_list,
        el_add,
        el_remove,
        el_name,
        el_confirm
    );
    
    return dg;
}