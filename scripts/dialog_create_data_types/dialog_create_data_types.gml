function dialog_create_data_types() {
    var dialog = new EmuDialog(32 + 320 + 32 + 320 + 32 + 320 + 32, 640, "Data Types");
    var element_width = 320;
    var element_height = 32;
    
    var col1 = 32;
    var col2 = 32 + 320 + 32;
    var col3 = 32 + 320 + 32 + 320 + 32;
    
    return dialog.AddContent([
        #region column 1
        (new EmuList(col1, EMU_BASE, element_width, element_height, "Data types: " + string(array_length(Game.data)), element_height, 12, function() {
            if (!self.root) return;
            self.root.Refresh();
        }))
            .SetCallbackMiddle(function() {
                var selection = self.GetSelectedItem();
                
                // alphabetize the data types with enums at the top
                var list_data = [];
                var list_enums = [];
                for (var i = 0; i < array_length(Game.data); i++) {
                    var data = Game.data[i];
                    if (data.type == DataTypes.ENUM) {
                        array_push(list_enums, data);
                    } else {
                        array_push(list_data, data);
                    }
                }
                
                // Normally you'd just use the list sort funciton on the source lists since they
                // don't modify them, but in this case we want the enums to always go at the top
                var list_enums_sorted = array_sort_name(list_enums);
                var list_data_sorted = array_sort_name(list_data);
                
                for (var i = 0, n = array_length(list_enums_sorted); i < n; i++) {
                    Game.data[i] = list_enums_sorted[i];
                }
                var enums_count = array_length(list_enums_sorted);
                for (var i = 0, n = array_length(list_data_sorted); i < n; i++) {
                    Game.data[i + enums_count] = list_data_sorted[i];
                }
                
                self.Deselect();
                self.Select(array_search(Game.data, selection), true);
            })
            .SetListColors(function(index) {
                return (self.At(index).type == DataTypes.ENUM) ? c_aqua : c_white;
            })
            .SetEntryTypes(E_ListEntryTypes.STRUCTS)
            .SetList(Game.data)
            .SetID("LIST"),
        (new EmuButton(col1, EMU_AUTO, element_width, element_height, "Add Data", function() {
            array_push(Game.data, new DataClass("DataType" + string(array_length(Game.data))));
        })),
        (new EmuButton(col1, EMU_AUTO, element_width, element_height, "Add Enum", function() {
            var type = new DataClass("Enum" + string(array_length(Game.data)));
            type.type = DataTypes.ENUM;
            array_push(Game.data, type);
        })),
        (new EmuButton(col1, EMU_AUTO, element_width, element_height, "Delete", function() {
            var list = self.GetSibling("LIST");
            var selection = list.GetSelectedItem();
            if (selection) {
                selection.Destroy();
                self.root.Refresh();
            }
        })),
        #endregion
        #region column 2
        (new EmuInput(col2, EMU_BASE, element_width, element_height, "Name:", "", "data name", VISIBLE_NAME_LENGTH, E_InputTypes.STRING, function() {
            self.GetSibling("LIST").GetSelectedItem().name = self.value;
        }))
            .SetInteractive(false)
            .SetRefresh(function() {
                var selection = self.GetSibling("LIST").GetSelectedItem();
                self.SetInteractive(!!selection);
                if (!!selection) {
                    self.SetValue(selection.name);
                }
            }),
        (new EmuCheckbox(col2, EMU_AUTO, element_width, element_height, "Don't Localize", false, function() {
            var item = self.GetSibling("LIST").GetSelectedItem();
            item.flags &= ~DataDataFlags.NO_LOCALIZE;
            item.flags |= DataDataFlags.NO_LOCALIZE * self.value;
        }))
            .SetInteractive(false)
            .SetRefresh(function() {
                var selection = self.GetSibling("LIST").GetSelectedItem();
                self.SetInteractive(!!selection);
                if (!!selection) {
                    self.SetValue((selection.flags & DataDataFlags.NO_LOCALIZE) > 0);
                }
            })
            .SetTooltip("This data type will not have any of its properties localized (this overrides individual options)"),
        (new EmuCheckbox(col2, EMU_AUTO, element_width, element_height, "    Exclude Name", false, function() {
            var item = self.GetSibling("LIST").GetSelectedItem();
            item.flags &= ~DataDataFlags.NO_LOCALIZE_NAME;
            item.flags |= DataDataFlags.NO_LOCALIZE_NAME * self.value;
        }))
            .SetInteractive(false)
            .SetRefresh(function() {
                var selection = self.GetSibling("LIST").GetSelectedItem();
                self.SetInteractive(!!selection);
                if (!!selection) {
                    self.SetValue((selection.flags & DataDataFlags.NO_LOCALIZE_NAME) > 0);
                }
            })
            .SetTooltip("This data's name will not be localized (regardless of the above setting)"),
        (new EmuCheckbox(col2, EMU_AUTO, element_width, element_height, "    Exclude Summary", false, function() {
            var item = self.GetSibling("LIST").GetSelectedItem();
            item.flags &= ~DataDataFlags.NO_LOCALIZE_SUMMARY;
            item.flags |= DataDataFlags.NO_LOCALIZE_SUMMARY * self.value;
        }))
            .SetInteractive(false)
            .SetRefresh(function() {
                var selection = self.GetSibling("LIST").GetSelectedItem();
                self.SetInteractive(!!selection);
                if (!!selection) {
                    self.SetValue((selection.flags & DataDataFlags.NO_LOCALIZE_SUMMARY) > 0);
                }
            })
            .SetTooltip("This data's name will not be localized (regardless of the above setting)"),
        #endregion
    ]).AddDefaultCloseButton();
    
    
    
    
    
    
    var el_list_p = create_list(col2_x, yy, "Properties: ", "<name is implicit>", ew, eh, 12, function(list) {
        var selection = ui_list_selection(list);
        if (selection + 1) {
            var listofthings = list.root.selected_data.properties;
            if (listofthings[selection] != list.root.selected_property) {
                list.root.selected_property = listofthings[selection];
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
            list.text = otext + string(array_length(datadata.properties));
            list.entries = datadata.properties;
        } else {
            list.entries = [];
        }
        ui_render_list(list, xx, yy);
        list.text = otext;
    };
    el_list_p.entries_are = ListEntries.INSTANCES;
    dg.el_list_p = el_list_p;
    
    yy += el_list_p.GetHeight() + spacing;
    
    var el_add_p = create_button(col2_x, yy, "Add Property", ew, eh, fa_center, function(button) {
        var datadata = button.root.selected_data;
        
        datadata.AddProperty(new DataProperty("Property" + string(array_length(datadata.properties)), datadata));
        
        ui_list_deselect(button.root.el_list_p);
        
        button.root.selected_property = noone;
        
        dialog_data_type_disable(button.root);
        
        button.root.el_data_name.interactive = true;
        button.root.el_add_p.interactive = true;
        button.root.el_move_up.interactive = true;
        button.root.el_move_down.interactive = true;
        button.root.el_remove_p.interactive = true;
    }, dg);
    el_add_p.interactive = false;
    dg.el_add_p = el_add_p;
    
    yy += el_add_p.height + spacing;
    
    var el_move_up = create_button(col2_x, yy, "Move Up", ew, eh, fa_center, function(button) {
        var datadata = button.root.selected_data;
        var index = ui_list_selection(button.root.el_list_p);
        
        if (index > 0) {
            var t = datadata.properties[index];
            datadata.properties[@ index] = datadata.properties[index - 1];
            datadata.properties[@ index - 1] = t;
            
            if (datadata.type == DataTypes.DATA) {
                for (var i = 0; i < array_length(datadata.instances); i++) {
                    var inst = datadata.instances[i];
                    t = inst.values[index];
                    inst.values[@ index] = inst.values[index] - 1;
                    inst.values[@ index - 1] = t;
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
        
        if (index < array_length(datadata.properties) - 1) {
            var t = datadata.properties[index];
            datadata.properties[@ index] = datadata.properties[index + 1];
            datadata.properties[@ index + 1] = t;
            
            if (datadata.type == DataTypes.DATA) {
                for (var i = 0; i < array_length(datadata.instances); i++) {
                    var inst = datadata.instances[i];
                    t = inst.values[index];
                    inst.values[@ index] = inst.values[index] + 1;
                    inst.values[@ index + 1] = t;
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
            button.root.selected_property.Destroy();
            
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
    
    yy += el_property_type.GetHeight() + spacing;
    
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
            var index = array_search(checkbox.root.selected_data.properties, checkbox.root.selected_property);
            var n = 0;
            for (var i = 0; i < array_length(instances); i++) {
                var instance = instances[i];
                var inst_property = instance.values[index];
                if (array_length(inst_property) == 0) {
                    array_push(inst_property, 0);
                    n++;
                }
            }
            if (n > 0) {
                emu_dialog_notice(string(n) + " instances of " + checkbox.root.selected_data.name + " have default values auto-assigned to their " + checkbox.root.selected_property.name + " property.");
            }
        }
    }, false, dg);
    el_property_size_can_be_zero.tooltip = "List values are optionally allowed to have their capacity be zero.";
    el_property_size_can_be_zero.interactive = false;
    dg.el_property_size_can_be_zero = el_property_size_can_be_zero;
    
    yy += eh + spacing;
    
    var el_property_default_code = create_button(col3_x, yy, "Default:", ew, eh, fa_middle, function(input) {
        emu_dialog_notice("create some new code editor sometime maybe");
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
}