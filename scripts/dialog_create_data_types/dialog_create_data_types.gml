function dialog_create_data_types(dialog) {
    // there's a fair amount of redundant code in here, and in the associated scripts.
    // however, in this case, i've decided that a few lines of redundant code is better than
    // the spaghetti that i had before.
    var dw = 960;
    var dh = 720;
    
    var dg = dialog_create(dw, dh, "Data: Data", dialog_default, undefined, dialog);
    dg.selected_data = noone;
    dg.selected_property = noone;
    
    var columns = 3;
    var spacing = 16;
    var ew = dw / columns - spacing * 2;
    var eh = 24;
    
    var col1_x = dw * 0 / 3 + spacing;
    var col2_x = dw * 1 / 3 + spacing;
    var col3_x = dw * 2 / 3 + spacing;
    
    var vx1 = dw / (columns * 2) - 16;
    var vy1 = 0;
    var vx2 = vx1 + dw / (columns * 2) - 16;
    var vy2 = eh;
    
    var b_width = 128;
    var b_height = 32;
    
    var yy = 64;
    var yy_base = yy;
    
    var el_list = create_list(col1_x, yy, "Data Types: ", "<no data types>", ew, eh, 18, function(list) {
        var selection = ui_list_selection(list);
        if (selection + 1) {
            var listofthings = Stuff.all_data;
            if (listofthings[| selection] != list.root.selected_data) {
                list.root.selected_data = listofthings[| selection];
                list.root.selected_property = noone;
                
                ui_list_deselect(list.root.el_list_p);
                dialog_data_type_disable(list.root);
                
                list.root.el_data_name.interactive = true;
                list.root.el_add_p.interactive = true;
                list.root.el_remove_p.interactive = true;
                
                if (list.root.selected_data.type == DataTypes.DATA) {
                    list.root.el_data_localize.interactive = true;
                    list.root.el_data_localize.value = !!(list.root.selected_data.flags & DataDataFlags.NO_LOCALIZE);
                    list.root.el_data_localize_name.interactive = true;
                    list.root.el_data_localize_name.value = !!(list.root.selected_data.flags & DataDataFlags.NO_LOCALIZE_NAME);
                    list.root.el_data_localize_summary.interactive = true;
                    list.root.el_data_localize_summary.value = !!(list.root.selected_data.flags & DataDataFlags.NO_LOCALIZE_SUMMARY);
                } else {
                    list.root.el_data_localize.interactive = false;
                }
                
                ui_input_set_value(list.root.el_data_name, list.root.selected_data.name);
                
                list.root.el_list_p.index = 0;
            }
        }
    }, false, dg, Stuff.all_data);
    el_list.render = ui_render_list_data_data;
    el_list.render_colors = ui_list_color_data_type;
    el_list.onmiddleclick = uivc_list_data_alphabetize;
    el_list.entries_are = ListEntries.INSTANCES;
    
    dg.el_list_main = el_list;
    
    yy += ui_get_list_height(el_list) + spacing;
    
    var el_add = create_button(col1_x, yy, "Add Data", ew, eh, fa_center, function(button) {
        if (ds_list_size(Stuff.all_data) < 10000) {
            instance_deactivate_object(instance_create_depth(0, 0, 0, DataData));
            ui_list_deselect(button.root.el_list_main);
            button.root.selected_data = noone;
            button.root.selected_property = noone;
            dialog_data_type_disable(button.root);
        } else {
            dialog_create_notice(button.root, "Please don't try to create more than ten thousand generic data types. Bad things will happen. Why do you even want that many?", "Hey!");
        }
    }, dg);
    yy += el_add.height + spacing;
    
    var el_add_enum = create_button(col1_x, yy, "Add Enum", ew, eh, fa_center, function(button) {
        if (ds_list_size(Stuff.all_data) < 10000) {
            instance_deactivate_object(instance_create_depth(0, 0, 0, DataEnum));
            ui_list_deselect(button.root.el_list_main);
            button.root.selected_data = noone;
            button.root.selected_property = noone;
            dialog_data_type_disable(button.root);
        } else {
            dialog_create_notice(button.root, "Please don't try to create more than ten thousand generic data types. Bad things will happen.", "Hey!");
        }
    }, dg);
    yy += el_add.height + spacing;
    
    var el_remove = create_button(col1_x, yy, "Delete", ew, eh, fa_center, function(button) {
        if (button.root.selected_data) {
            instance_activate_object(button.root.selected_data);
            instance_destroy(button.root.selected_data);
            ds_list_delete(Stuff.all_data, ds_list_find_index(Stuff.all_data, button.root.selected_data));
            ui_list_deselect(button.root.el_list_main);
            ui_list_deselect(button.root.el_list_p);
            button.root.el_list_main.onvaluechange(button.root.el_list_main);
            button.root.el_list_p.onvaluechange(button.root.el_list_p);
            button.root.selected_data = noone;
            button.root.selected_property = noone;
        }
    }, dg);
    
    // COLUMN 2
    yy = yy_base;
    
    var el_data_name = create_input(col2_x, yy, "Data Name:", ew, eh, function(input) {
        input.root.selected_data.name = input.value;
    }, "", "[A-Za-z0-9_]+", validate_string_internal_name, 0, 1, VISIBLE_NAME_LENGTH, vx1, vy1, vx2, vy2, dg);
    el_data_name.interactive = false;
    dg.el_data_name = el_data_name;
    
    yy += el_data_name.height + spacing;
    
    var el_data_localize = create_checkbox(col2_x, yy, "Don't Localize", ew, eh, function(checkbox) {
        checkbox.root.selected_data.flags ^= DataDataFlags.NO_LOCALIZE;
    }, true, dg);
    el_data_localize.tooltip = "This data type will not have any of its properties localized (this overrides individual options)";
    el_data_localize.interactive = false;
    dg.el_data_localize = el_data_localize;
    
    yy += el_data_localize.height + spacing;
    
    var el_data_localize_name = create_checkbox(col2_x, yy, "Exclude Name", ew / 2, eh, function(checkbox) {
        checkbox.root.selected_data.flags ^= DataDataFlags.NO_LOCALIZE_NAME;
    }, true, dg);
    el_data_localize_name.tooltip = "This data's name will not be localized (regardless of the above setting)";
    el_data_localize_name.interactive = false;
    dg.el_data_localize_name = el_data_localize_name;
    
    var el_data_localize_summary = create_checkbox(col2_x + 160, yy, "Summary", ew / 2, eh, function(checkbox) {
        checkbox.root.selected_data.flags ^= DataDataFlags.NO_LOCALIZE_SUMMARY;
    }, true, dg);
    el_data_localize_summary.tooltip = "This data's summary will not be localized (regardless of the above setting)";
    el_data_localize_summary.interactive = false;
    dg.el_data_localize_summary = el_data_localize_summary;
    
    yy += el_data_localize_summary.height + spacing;
    
    var el_list_p = create_list(col2_x, yy, "Properties: ", "<name is implicit>", ew, eh, 12, function(list) {
        var selection = ui_list_selection(list);
        if (selection + 1) {
            var listofthings = list.root.selected_data.properties;
            if (listofthings[| selection] != list.root.selected_property) {
                list.root.selected_property = listofthings[| selection];
                dialog_data_type_disable(list.root);
                dialog_data_type_enable_by_type(list.root);
            }
        } else {
            dialog_data_type_disable(list.root);
        }
    }, false, dg, noone);
    el_list_p.render = function(list, xx, yy) {
        var otext = list.text;
        var datadata = list.root.selected_data;
        if (datadata) {
            list.text = otext + string(ds_list_size(datadata.properties));
            list.entries = datadata.properties;
        } else {
            list.entries = Stuff.empty_list;
        }
        ui_render_list(list, xx, yy);
        list.text = otext;
    };
    el_list_p.entries_are = ListEntries.INSTANCES;
    dg.el_list_p = el_list_p;
    
    yy += ui_get_list_height(el_list_p) + spacing;
    
    var el_add_p = create_button(col2_x, yy, "Add Property", ew, eh, fa_center, function(button) {
        var datadata = button.root.selected_data;
        
        if (ds_list_size(datadata.properties) < 1000) {
            var property = instance_create_depth(0, 0, 0, DataProperty);
            property.name = "Property" + string(ds_list_size(datadata.properties));
            
            ds_list_add(datadata.properties, property);
            ui_list_deselect(button.root.el_list_p);
            instance_deactivate_object(property);
            button.root.selected_property = noone;
            
            // don't do this for enums - iterate over all data instances and add an empty
            // list to each value
            if (datadata.type == DataTypes.DATA) {
                for (var i = 0; i < ds_list_size(datadata.instances); i++) {
                    var inst = datadata.instances[| i];
                    var plist = ds_list_create();
                    ds_list_add(plist, 0);
                    ds_list_add(inst.values, plist);
                }
            }
            
            dialog_data_type_disable(button.root);
            
            button.root.el_data_name.interactive = true;
            button.root.el_add_p.interactive = true;
            button.root.el_move_up.interactive = true;
            button.root.el_move_down.interactive = true;
            button.root.el_remove_p.interactive = true;
        } else {
            dialog_create_notice(button.root, "Please don't try to create more than a thousand properties on a single data type. Bad things will happen.", "Hey!");
        }
    }, dg);
    el_add_p.interactive = false;
    dg.el_add_p = el_add_p;
    
    yy += el_add_p.height + spacing;
    
    var el_move_up = create_button(col2_x, yy, "Move Up", ew, eh, fa_center, function(button) {
        var datadata = button.root.selected_data;
        var index = ui_list_selection(button.root.el_list_p);
        
        if (index > 0) {
            var t = datadata.properties[| index];
            datadata.properties[| index] = datadata.properties[| index - 1];
            datadata.properties[| index - 1] = t;
            
            if (datadata.type == DataTypes.DATA) {
                for (var i = 0; i < ds_list_size(datadata.instances); i++) {
                    var inst = datadata.instances[| i];
                    var t = inst.values[| index];
                    inst.values[| index] = inst.values[| index] - 1;
                    inst.values[| index - 1] = t;
                }
            }
            
            ui_list_deselect(button.root.el_list_p);
            ui_list_select(button.root.el_list_p, index - 1, true);
        }
    }, dg);
    el_move_up.interactive = false;
    dg.el_move_up = el_move_up;
    
    yy += el_move_up.height + spacing;
    
    var el_move_down = create_button(col2_x, yy, "Move Down", ew, eh, fa_center, function(button) {
        var datadata = button.root.selected_data;
        var index = ui_list_selection(button.root.el_list_p);
        
        if (index < ds_list_size(datadata.properties) - 1) {
            var t = datadata.properties[| index];
            datadata.properties[| index] = datadata.properties[| index + 1];
            datadata.properties[| index + 1] = t;
            
            if (datadata.type == DataTypes.DATA) {
                for (var i = 0; i < ds_list_size(datadata.instances); i++) {
                    var inst = datadata.instances[| i];
                    var t = inst.values[| index];
                    inst.values[| index] = inst.values[| index] + 1;
                    inst.values[| index + 1] = t;
                }
            }
            
            ui_list_deselect(button.root.el_list_p);
            ui_list_select(button.root.el_list_p, index + 1, true);
        }
    }, dg);
    el_move_down.interactive = false;
    dg.el_move_down = el_move_down;
    
    yy += el_move_down.height + spacing;
    
    var el_remove_p = create_button(col2_x, yy, "Delete Property", ew, eh, fa_center, function(button) {
        if (button.root.selected_property) {
            var data = button.root.selected_data;
            var index = ds_list_find_index(data.properties, button.root.selected_property);
            ds_list_delete(data.properties, index);
            
            if (data.type == DataTypes.DATA) {
                var instances = data.instances;
                for (var i = 0; i < ds_list_size(instances); i++) {
                    ds_list_destroy(instances[| i].values[| index]);
                    ds_list_delete(instances[| i].values, index);
                }
            }
            
            ui_list_deselect(button.root.el_list_p);
            button.interactive = false;
            button.root.el_move_up.interactive = false;
            button.root.el_move_down.interactive = false;
        }
    }, dg);
    el_remove_p.interactive = false;
    dg.el_remove_p = el_remove_p;
    
    // COLUMN 3
    yy = yy_base;
    
    var el_property_name = create_input(col3_x, yy, "Name:", ew, eh, function(input) {
        input.root.selected_property.name = input.value;
    }, "", "[A-Za-z0-9_]+", validate_string_internal_name, 0, 1, INTERNAL_NAME_LENGTH, vx1, vy1, vx2, vy2, dg);
    el_property_name.interactive = false;
    dg.el_property_name = el_property_name;
    
    yy += el_property_name.height + spacing;
    
    var el_property_type = create_radio_array(col3_x, yy, "Type:", ew, eh, function(radio) {
        radio.root.root.selected_property.type = radio.value;
        dialog_data_type_disable(radio.root.root);
        dialog_data_type_enable_by_type(radio.root.root);
    }, 0, dg);
    el_property_type.interactive = false;
    create_radio_array_options(el_property_type, ["Int", "Enum", "Float", "String", "Boolean", "Data", "Code"]);
    dg.el_property_type = el_property_type;
    
    yy += ui_get_radio_array_height(el_property_type) + spacing;
    
    var el_property_ext_type = create_button(col3_x, yy, "Other Data Types", ew, eh, fa_middle, function(button) {
        dialog_create_select_data_types_ext(button, button.root.selected_property.type, uivc_radio_data_type_ext);
    }, dg);
    el_property_ext_type.interactive = false;
    
    yy += el_property_ext_type.height + spacing;
    dg.el_property_ext_type = el_property_ext_type;
    
    var yy_top = yy;
    
    // anything common to all data types
    var el_property_size = create_input(col3_x, yy, "Capacity:", ew, eh, function(input) {
        input.root.selected_property.max_size = real(input.value);
    }, "1", "1...255", validate_int, 1, 255, 3, vx1, vy1, vx2, vy2, dg);
    el_property_size.interactive = false;
    dg.el_property_size = el_property_size;
    
    yy += eh + spacing;
    
    var el_property_size_can_be_zero = create_checkbox(col3_x, yy, "Capacity can be zero", ew, eh, function(checkbox) {
        checkbox.root.selected_property.size_can_be_zero = checkbox.value;
        if (!checkbox.root.selected_property.size_can_be_zero) {
            var instances = checkbox.root.selected_data.instances;
            var index = ds_list_find_index(checkbox.root.selected_data.properties, checkbox.root.selected_property);
            var n = 0;
            for (var i = 0; i < ds_list_size(instances); i++) {
                var instance = instances[| i];
                var inst_property = instance.values[| index];
                if (!ds_list_size(inst_property)) {
                    ds_list_add(inst_property, 0);
                    n++;
                }
            }
            if (n > 0) {
                dialog_create_notice(checkbox.root, string(n) + " instances of " + checkbox.root.selected_data.name + " have default values auto-assigned to their " + checkbox.root.selected_property.name + " property.");
            }
        }
    }, false, dg);
    el_property_size_can_be_zero.tooltip = "List values are optionally allowed to have their capacity be zero."
    el_property_size_can_be_zero.interactive = false;
    dg.el_property_size_can_be_zero = el_property_size_can_be_zero;
    
    yy += eh + spacing;
    
    var el_property_default_code = create_input_code(col3_x, yy, "Default:", ew, eh, vx1, vy1, vx2, vy2, "", function(input) {
        // @todo else make it red or something
        if (validate_code(input.value, input)) {
            input.root.selected_property.default_code = input.value;
        }
    }, dg);
    el_property_default_code.enabled = false;
    dg.el_property_default_code = el_property_default_code;
    var el_property_default_string = create_input(col3_x, yy, "Default:", ew, eh, function(input) {
        input.root.selected_property.default_string = input.value;
    }, "", "text", validate_string, 0, 1, 160, vx1, vy1, vx2, vy2, dg);
    el_property_default_string.enabled = false;
    dg.el_property_default_string = el_property_default_string;
    var el_property_default_real = create_input(col3_x, yy, "Default:", ew, eh, function(input) {
        input.root.selected_property.default_real = real(input.value);
    }, "0", "number", validate_double, -0x80000000, 0x7fffffff, 10, vx1, vy1, vx2, vy2, dg);
    el_property_default_real.enabled = false;
    dg.el_property_default_real = el_property_default_real;
    var el_property_default_int = create_input(col3_x, yy, "Default:", ew, eh, function(input) {
        input.root.selected_property.default_int = real(input.value);
    }, "0", "int", validate_int, -0x80000000, 0x7fffffff, 11, vx1, vy1, vx2, vy2, dg);
    el_property_default_int.enabled = false;
    dg.el_property_default_int = el_property_default_int;
    var el_property_default_bool = create_checkbox(col3_x, yy, "Default value", ew, eh, function(checkbox) {
        checkbox.root.selected_property.default_int = checkbox.value;
    }, false, dg);
    el_property_default_bool.enabled = false;
    dg.el_property_default_bool = el_property_default_bool;
    
    // data and enum - onmouseup is assigned when the radio button is clicked
    var el_property_type_guid = create_button(col3_x, yy, "Select Type...", ew, eh, fa_center, null, dg);
    el_property_type_guid.enabled = false;
    dg.el_property_type_guid = el_property_type_guid;
    
    yy += eh + spacing;
    
    var yy_base_special = yy;
    
    // int only
    var el_property_min = create_input(col3_x, yy, "Min. Value:", ew, eh, function(input) {
        input.root.selected_property.range_min = real(input.value);
    }, "0", "+" + string(0x80000000), validate_double, -0x80000000, 0x7fffffff, 10, vx1, vy1, vx2, vy2, dg);
    el_property_min.enabled = false;
    dg.el_property_min = el_property_min;
    
    // string only
    var el_property_char_limit = create_input(col3_x, yy, "Char. Limit:", ew, eh, function(input) {
        input.root.selected_property.char_limit = real(input.value);
    }, "20", "1000", validate_int, 1, 1000, 4, vx1, vy1, vx2, vy2, dg);
    el_property_char_limit.enabled = false;
    dg.el_property_char_limit = el_property_char_limit;
    
    var el_property_localize = create_checkbox(col3_x, yy + el_property_char_limit.height + spacing, "Don't Localize", ew, eh, function(checkbox) {
        checkbox.root.selected_property.flags ^= DataPropertyFlags.NO_LOCALIZE;
    }, true, dg);
    el_property_localize.enabled = false;
    dg.el_property_localize = el_property_localize;
    
    yy += eh + spacing;
    
    // int and float only
    var el_property_max = create_input(col3_x, yy, "Max. Value:", ew, eh, function(input) {
        input.root.selected_property.range_max = real(input.value);
    }, "0", "+" + string(-0x7fffffff), validate_double, -0x80000000, 0x7fffffff, 10, vx1, vy1, vx2, vy2, dg);
    el_property_max.enabled = false;
    dg.el_property_max = el_property_max;
    
    yy += eh + spacing;
    
    var el_property_scale = create_radio_array(col3_x, yy, "Scale:", ew, eh, function(radio) {
        radio.root.root.selected_property.number_scale = radio.value;
    }, 0, dg);
    create_radio_array_options(el_property_scale, ["Linear", "Quadratic", "Exponential"]);
    el_property_scale.enabled = false;
    dg.el_property_scale = el_property_scale;
    
    yy = yy_base_special;
    
    yy += eh + spacing;
    
    var el_confirm = create_button(dw / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dialog_destroy, dg, fa_center);
    
    ds_list_add(dg.contents,
        // data types
        el_list,
        el_add,
        el_add_enum,
        el_remove,
        // data type
        el_data_name,
        el_data_localize,
        el_list_p,
        el_add_p,
        el_move_up,
        el_move_down,
        el_remove_p,
        // properties
        el_property_name,
        el_data_localize_name,
        el_data_localize_summary,
        el_property_localize,
        el_property_type,
        el_property_ext_type,
        el_property_size,
        el_property_size_can_be_zero,
        el_property_type_guid,
        el_property_min,
        el_property_char_limit,
        el_property_max,
        el_property_scale,
        el_property_default_code,
        el_property_default_string,
        el_property_default_real,
        el_property_default_bool,
        el_property_default_int,
        // that's it
        el_confirm
    );
    
    return dg;
}