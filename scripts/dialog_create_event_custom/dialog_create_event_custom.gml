function dialog_create_event_custom(dialog) {
    var dw = 960;
    var dh = 560;
    
    var dg = dialog_create(dw, dh, "Custom Event Node Properties", dialog_note_changes, dialog_destroy, dialog);
    dg.x = dg.x - 32;
    
    // later on this will be a clone; elements on the dialog should check this instead of the permenant one,
    // and it should be deleted when the dialog is closed
    dg.event = Game.events.custom[ui_list_selection(dialog.root.el_list_custom)];
    
    var columns = 3;
    var spacing = 16;
    var ew = dw / columns - spacing * 2;
    var eh = 24;
    
    var col1_x = spacing;
    var col2_x = dw / columns + spacing;
    var col3_x = dw * 2 / columns + spacing;
    
    var vx1 = ew / 2 - 16;
    var vy1 = 0;
    var vx2 = ew;
    var vy2 = eh;
    
    var b_width = 128;
    var b_height = 32;
    
    var n_slots = 10;
    
    var yy = 64;
    
    var el_name = create_input(col1_x, yy, "Name:", ew, eh, function(input) {
        input.root.event.name = input.value;
        input.root.changed = true;
    }, dg.event.name, "[A-Za-z0-9_]+", validate_string_internal_name, 0, 1, INTERNAL_NAME_LENGTH, vx1, vy1, vx2, vy2, dg);
    yy += el_name.height + spacing;
    
    var yy_base = yy;
    
    var el_list = create_list(col1_x, yy, "Properties Types: ", "<no properties>", ew, eh, n_slots, uivc_list_event_custom_property, false, dg, dg.event.types);
    el_list.colorize = false;
    el_list.numbered = true;
    el_list.entries_are = ListEntries.INSTANCES;
    dg.el_list = el_list;
    
    yy += el_list.GetHeight() + spacing;
    
    var el_add = create_button(col1_x, yy, "Add Property", ew, eh, fa_center, omu_event_custom_add_property, dg);
    yy += el_add.height + spacing;
    
    var el_remove = create_button(col1_x, yy, "Delete Property", ew, eh, fa_center, omu_event_custom_remove_property, dg);
    
    // COLUMN 2
    yy = yy_base;
    
    var el_property_name = create_input(col2_x, yy, "Name:", ew, eh, function(input) {
        var selection = ui_list_selection(input.root.el_list);
        if (selection + 1) {
            input.root.event.types[selection].name = input.value;
        }
    }, "", "Value name", validate_string, 0, 1, VISIBLE_NAME_LENGTH, vx1, vy1, vx2, vy2, dg);
    el_property_name.interactive = false;
    dg.el_property_name = el_property_name;
    
    yy += el_property_name.height + spacing;
    
    var el_property_type = create_radio_array(col2_x, yy, "Type:", ew, eh, uivc_custom_data_property_type, 0, dg);
    create_radio_array_options(el_property_type, ["Int", "Enum", "Float", "String", "Boolean", "Data", "Code"]);
    el_property_type.interactive = false;
    dg.el_property_type = el_property_type;
    
    yy += el_property_type.GetHeight() + spacing;
    
    var el_property_ext_type = create_button(col2_x, yy, "Other Data Types", ew, eh, fa_middle, function(button) {
        // if you can click on the button to spawn this dialog, selection is guaranteed to have a value
        var selection = ui_list_selection(button.root.el_list);
        if (selection + 1) {
            var property = button.root.event.types[selection];
            dialog_create_select_data_types_ext(button.root, property.type, function() {
                var offset = 0;
                var value = self.value + offset;
                var base_dialog = self.root.root.root.root;
                // selection is guaranteed to have a value at this point
                var selection = ui_list_selection(base_dialog.el_list);
                base_dialog.event.types[selection].type = value;
                uivc_list_event_custom_property(base_dialog.el_list);
            });
        }
    }, dg);
    el_property_ext_type.interactive = false;
    dg.el_property_ext_type = el_property_ext_type;
    
    yy += el_property_ext_type.height + spacing;
    
    // selector is set when the radio button is messed with
    var el_property_type_guid = create_button(col2_x, yy, "Select Data Type", ew, eh, fa_center, null, dg);
    el_property_type_guid.interactive = false;
    dg.el_property_type_guid = el_property_type_guid;
    
    yy += el_property_type_guid.height + spacing;
    
    // COLUMN 3
    yy = yy_base;
    
    var el_outbound = create_list(col3_x, yy, "Outbound Nodes (max 10):", "what?", ew, eh, 10, function(list) {
        var selection = ui_list_selection(list);
        ui_input_set_value(list.root.el_outbound_name, list.root.event.outbound[selection]);
    }, false, dg, dg.event.outbound);
    ui_list_select(el_outbound, 0);
    el_outbound.render = function(list, x, y) {
        var oentries = list.entries;
        list.entries = ds_list_create();
        ds_list_clear(list.entry_colors);
        
        if (oentries[0] == "") {
            ds_list_add(list.entries, "<default>");
            ds_list_add(list.entry_colors, c_blue);
        } else {
            ds_list_add(list.entries, oentries[0]);
            ds_list_add(list.entry_colors, c_black);
        }
        
        for (var i = 1; i < array_length(oentries); i++) {
            ds_list_add(list.entries, oentries[i]);
            ds_list_add(list.entry_colors, c_black);
        }
        
        ui_render_list(list, x, y);
        
        ds_list_destroy(list.entries);
        list.entries = oentries;
    };
    dg.el_outbound = el_outbound;
    yy += el_outbound.GetHeight() + spacing;
    var el_outbound_name = create_input(col3_x, yy, "Name:", ew, eh, function(input) {
        var selection = ui_list_selection(input.root.el_outbound);
        input.root.event.outbound[@ selection] = input.value;
    }, dg.event.outbound[0], "Name", validate_string, 0, 1, VISIBLE_NAME_LENGTH, vx1, vy1, vx2, vy2, dg);
    dg.el_outbound_name = el_outbound_name;
    yy += el_outbound_name.height + spacing;
    var el_outbound_add = create_button(col3_x, yy, "Add", ew, eh, fa_center, function(button) {
        var event = button.root.event;
        array_push(event.outbound, "Outbound" + string(array_length(event.outbound)));
        button.root.el_outbound_add.interactive = array_length(event.outbound) < 10;
        button.root.el_outbound_remove.interactive = true;
    }, dg);
    dg.el_outbound_add = el_outbound_add;
    yy += el_outbound_add.height + spacing;
    var el_outbound_remove = create_button(col3_x, yy, "Delete", ew, eh, fa_center, omu_event_custom_remove_outbound, dg);
    el_outbound_remove.interactive = array_length(dg.event.outbound) > 1;
    dg.el_outbound_remove = el_outbound_remove;
    yy += el_outbound_remove.height + spacing;
    
    var el_confirm = create_button(dw / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg, fa_center);
    
    ds_list_add(dg.contents,
        el_name,
        el_list,
        el_add,
        el_remove,
        el_property_name,
        el_property_type,
        el_property_ext_type,
        el_property_type_guid,
        el_outbound,
        el_outbound_name,
        el_outbound_add,
        el_outbound_remove,
        el_confirm
    );
    
    return dg;
}