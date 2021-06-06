function dialog_create_map_generic_data(root) {
    var map = Stuff.map.active_map;
    
    var dw = 640;
    var dh = 640;
    
    var dg = dialog_create(dw, dh, "Generic Data", dialog_default, dialog_destroy, root);
    
    var columns = 2;
    var spacing = 16;
    var ew = dw / columns - spacing * 2;
    var eh = 24;
    
    var col1_x = 0 * dw / columns + 16;
    var col2_x = 1 * dw / columns + 16;
    
    var vx1 = ew / 2;
    var vy1 = 0;
    var vx2 = ew;
    var vy2 = eh;
    
    var yy = 64;
    var slots = 16;
    
    var el_list = create_list(col1_x, yy, "Generic Data: " + map.name, "<No data>", ew, eh, slots, function(list) {
        var selection = ui_list_selection(list);
        if (selection + 1) {
            dialog_map_data_type_disable(list.root);
            dialog_map_data_enable_by_type(list.root);
        }
    }, false, dg, map.generic_data);
    el_list.entries_are = ListEntries.INSTANCES;
    dg.el_list = el_list;
    yy += ui_get_list_height(el_list) + spacing;
    
    var el_data_add = create_button(col1_x, yy, "Add Data", ew, eh, fa_center, function(button) {
        var map = Stuff.map.active_map;
        if (array_length(map.generic_data) < 0xff) {
            array_push(map.generic_data, new DataValue("GenericData" + string(array_length(map.generic_data))));
        } else {
            emu_dialog_notice("Please don't try to create more than " + string(0xff) + " data types. If you need a lot of generic data grouped together you may want to create a type to represent instantiated enemies instead.");
        }
    }, dg);
    yy += el_data_add.height + spacing;
    
    var el_data_remove = create_button(col1_x, yy, "Delete Data", ew, eh, fa_center, function(button) {
        var base_dialog = button.root;
        var map = Stuff.map.active_map;
        var selection = ui_list_selection(base_dialog.el_list);
        
        if (array_length(map.generic_data) > 0) {
            if (is_clamped(selection, 0, array_length(map.generic_data) - 1)) {
                array_delete(map.generic_data, selection, 1);
            }
            
            // enable by type whatever is currently selected; if the last entry in the
            // list has been deleted, then disable all of the needed buttons
            var last = array_length(map.generic_data) - 1;
            dialog_map_data_type_disable(base_dialog);
    
            if (array_length(map.generic_data) == 0) {
                ui_list_deselect(base_dialog.el_list);
            } else {
                if (!is_clamped(selection, 0, last)) {
                    ui_list_deselect(base_dialog.el_list);
                    base_dialog.el_list.selected_entries[? last] = true;
                }
                dialog_map_data_enable_by_type(base_dialog);
            }
        }
    }, dg);
    yy += el_data_remove.height + spacing;
    
    yy = 64;
    
    var el_name = create_input(col2_x, yy, "Name:", ew, eh, function(input) {
        var selection = ui_list_selection(input.root.el_list);
        Stuff.map.active_map.generic_data[selection].name = input.value;
    }, "", "[A-Za-z0-9_]+", validate_string_internal_name, 0, 1, INTERNAL_NAME_LENGTH, vx1, vy1, vx2, vy2, dg);
    el_name.interactive = false;
    dg.el_name = el_name;
    yy += el_name.height + spacing;
    
    var el_data_type = create_radio_array(col2_x, yy, "Type:", ew, eh, function(radio) {
        var base_dialog = radio.root.root;
        var selection = ui_list_selection(base_dialog.el_list);
        Stuff.map.active_map.generic_data[selection].type = radio.value;
        dialog_map_data_type_disable(base_dialog);
        dialog_map_data_enable_by_type(base_dialog);
    }, 0, dg);
    create_radio_array_options(el_data_type, ["Int", "Enum", "Float", "String", "Boolean", "Data", "Code" /* this is only the first couple of types, the rest are hidden behind a button */]);
    el_data_type.interactive = false;
    dg.el_data_type = el_data_type;
    yy += ui_get_radio_array_height(el_data_type) + spacing;
    
    var el_data_ext_type = create_button(col2_x, yy, "Other Data Types", ew, eh, fa_middle, function(button) {
        var dialog = dialog_create_select_data_types_ext(button, Stuff.map.active_map.generic_data[ui_list_selection(button.root.el_list)].type, function(radio) {
            var base_dialog = radio.root.root.root.root; /* why me? */
            var selection = ui_list_selection(base_dialog.el_list);
            var offset = 0;
            var value = radio.value + offset;
            
            Stuff.map.active_map.generic_data[selection].type = value;
            base_dialog.el_data_type.value = value;
            dialog_map_data_type_disable(base_dialog);
            dialog_map_data_enable_by_type(base_dialog);
        });
    }, dg);
    el_data_ext_type.interactive = false;
    dg.el_data_ext_type = el_data_ext_type;
    yy += el_data_ext_type.height + spacing;
    
    var el_data_property_entity = create_list(col2_x, yy, "Entities", "<none>", ew, eh, 8, function(list) {
        var selection = ui_list_selection(list);
        var generic_index = ui_list_selection(list.root.el_list);
        if (selection + 1) {
            Stuff.map.active_map.generic_data[generic_index].value_data = list.entries[| selection].REFID;
        }
    }, false, dg, map.contents.all_entities);
    el_data_property_entity.interactive = false;
    el_data_property_entity.enabled = false;
    el_data_property_entity.entries_are = ListEntries.INSTANCES;
    dg.el_data_property_entity = el_data_property_entity;
    
    var el_data_property_code = create_input_code(col2_x, yy, "Code:", ew, eh, vx1, vy1, vx2, vy2, "", function(code) {
        var selection = ui_list_selection(code.root.el_list);
        Stuff.map.active_map.generic_data[selection].value_code = code.value;
    }, dg);
    el_data_property_code.interactive = false;
    el_data_property_code.enabled = false;
    dg.el_data_property_code = el_data_property_code;
    
    var el_data_property_string = create_input(col2_x, yy, "Value:", ew, eh, function(input) {
        var selection = ui_list_selection(input.root.el_list);
        Stuff.map.active_map.generic_data[selection].value_int = input.value;
    }, "", "text", validate_string, 0, 1, 160, vx1, vy1, vx2, vy2, dg);
    el_data_property_string.is_code = false;
    el_data_property_string.interactive = false;
    el_data_property_string.enabled = false;
    dg.el_data_property_string = el_data_property_string;
    
    var el_data_property_real = create_input(col2_x, yy, "Value:", ew, eh, function(input) {
        var selection = ui_list_selection(input.root.el_list);
        Stuff.map.active_map.generic_data[selection].value_int = real(input.value);
    }, "0", "number", validate_double, -0x80000000, 0x7fffffff, 10, vx1, vy1, vx2, vy2, dg);
    el_data_property_real.interactive = false;
    el_data_property_real.enabled = false;
    dg.el_data_property_real = el_data_property_real;
    
    var el_data_property_int = create_input(col2_x, yy, "Value:", ew, eh, function(input) {
        var selection = ui_list_selection(input.root.el_list);
        Stuff.map.active_map.generic_data[selection].value_int = real(input.value);
    }, "0", "int", validate_int, -0x80000000, 0x7fffffff, 11, vx1, vy1, vx2, vy2, dg);
    el_data_property_int.interactive = false;
    el_data_property_int.enabled = false;
    dg.el_data_property_int = el_data_property_int;
    
    var el_data_property_bool = create_checkbox(col2_x, yy, "Value", ew, eh, function(checkbox) {
        var selection = ui_list_selection(checkbox.root.el_list);
        Stuff.map.active_map.generic_data[selection].value_bool = checkbox.value;
    }, false, dg);
    el_data_property_bool.interactive = false;
    el_data_property_bool.enabled = false;
    dg.el_data_property_bool = el_data_property_bool;
    
    var el_data_property_color = create_color_picker(col2_x, yy, "Color:", ew, eh, function(picker) {
        var selection = ui_list_selection(picker.root.el_list);
        Stuff.map.active_map.generic_data[selection].value_color = picker.value;
    }, c_black, vx1, vy1, vx2, vy2, dg);
    el_data_property_color.interactive = false;
    el_data_property_color.enabled = false;
    dg.el_data_property_color = el_data_property_color;
    
    // for built-in data types the Select button won't appear, so the list can be slightly bigger
    // and moved up on space; everything else is basically the same
    var el_data_builtin_list = create_list(col2_x, yy, "Data", "<none>", ew, eh, 8, function(list) {
        var map = Stuff.map.active_map;
        var selection = ui_list_selection(list);
        var generic_index = ui_list_selection(list.root.el_list);
        if (selection + 1) {
            map.generic_data[generic_index].value_data = list.entries[| selection].GUID;
        }
    }, false, dg, noone);
    el_data_builtin_list.interactive = false;
    el_data_builtin_list.enabled = false;
    el_data_builtin_list.entries_are = ListEntries.INSTANCES;
    dg.el_data_builtin_list = el_data_builtin_list;
    
    //should probably take inspiration from dialog_create_data_types
    var el_data_type_guid = create_button(col2_x, yy, "Select", ew, eh, fa_center, null, dg);
    el_data_type_guid.interactive = false;
    el_data_type_guid.enabled = false;
    dg.el_data_type_guid = el_data_type_guid;
    yy += el_data_type_guid.height + spacing;
    
    var el_data_list = create_list(col2_x, yy, "Data", "<none>", ew, eh, 6, function(list) {
        var map = Stuff.map.active_map;
        var selection = ui_list_selection(list);
        var generic_index = ui_list_selection(list.root.el_list);
        if (selection + 1) {
            map.generic_data[generic_index].value_data = list.entries[selection].GUID;
        }
    }, false, dg, []);
    el_data_list.interactive = false;
    el_data_list.enabled = false;
    el_data_list.entries_are = ListEntries.INSTANCES;
    dg.el_data_list = el_data_list;
    yy += ui_get_list_height(el_data_list) + spacing;
    
    var yy_base = yy;
    
    var b_width = 128;
    var b_height = 32;
    var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);
    
    ds_list_add(dg.contents,
        el_list,
        el_data_add,
        el_data_remove,
        el_name,
        el_data_type,
        el_data_ext_type,
        el_data_type_guid,
        el_data_list,
        el_data_builtin_list,
        el_data_property_code,
        el_data_property_string,
        el_data_property_real,
        el_data_property_int,
        el_data_property_bool,
        el_data_property_color,
        el_data_property_entity,
        el_confirm
    );
    
    return dg;
}