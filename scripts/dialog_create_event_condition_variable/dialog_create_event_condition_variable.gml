function dialog_create_event_condition_variable(node, index) {
    // going to just put all of the available properties in here, i think, because that
    // should make some things a bit easier
    
    var dw = 640;
    var dh = 560;
    
    var dg = dialog_create(dw, dh, "Condition: Global Variable", dialog_default, dialog_destroy, node);
    dg.node = node;
    dg.index = index;
    
    // data[| 0] is already known
    var list_index = node.custom_data[1];
    var list_comparison = node.custom_data[2];
    var list_value = node.custom_data[3];
    // data[| 4] not used
    
    var columns = 2;
    var spacing = 16;
    var ew = dw / columns - spacing * 2;
    var eh = 24;
    
    var c2 = dw / columns;
    
    var vx1 = dw / 4 + 16;
    var vy1 = 0;
    var vx2 = vx1 + (ew - vx1);
    var vy2 = eh;
    
    var yy = 64;
    
    var el_list = create_list(16, yy, "Variables", "<no variables>", ew, eh, 14, uivc_list_event_condition_index, false, dg);
    for (var i = 0; i < array_length(Game.vars.variables); i++) {
        create_list_entries(el_list, Game.vars.variables[i].name);
    }
    if (list_index[0] > -1) {
        ui_list_select(el_list, list_index[index]);
    }
    dg.el_list = el_list;
    
    // reset yy, except there's no point, since it's already at the top
    
    var el_comparison = create_radio_array(c2 + 16, yy, "Comparison", ew, eh, uivc_check_event_condition_comparison, list_comparison[index], dg);
    create_radio_array_options(el_comparison, ["Less (<)", "Less or Equal (<=)", "Equal (==)", "Greater or Equal (>=)", "Greater (>)", "Not Equal (!=)"]);
    
    yy += el_comparison.GetHeight() + spacing;
    
    var el_value = create_input(c2 + 16, yy, "Value", ew, eh, uivc_check_event_condition_value, string(list_value[index]), "float", validate_double, -0x80000000, 0x7fffffff, 11, vx1, vy1, vx2, vy2, dg);
    dg.el_value = el_value;
    
    var b_width = 128;
    var b_height = 32;
    var el_close = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);
    
    ds_list_add(dg.contents, el_list, el_comparison, el_value, el_close);
    
    return dg;
}