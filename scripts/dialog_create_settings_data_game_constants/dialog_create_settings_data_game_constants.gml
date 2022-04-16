function dialog_create_settings_data_game_constants(root) {
    var dialog = new EmuDialog(32 + 320 + 32 + 320 + 32 + 320 + 32, 640, "Data Settings: Game Constants");
    var element_width = 320;
    var element_height = 32;
    
    var col1 = 32;
    var col2 = 32 + 320 + 32;
    var col3 = 32 + 320 + 32 + 320 + 32;
    
    return dialog.AddContent([
        (new EmuList(col1, EMU_AUTO, element_width, element_height, "Constants", element_height, 12, function() {
            if (self.root) self.root.Refresh(self.GetSelection());
        }))
            .SetEntryTypes(E_ListEntryTypes.STRUCTS)
            .SetList(Game.vars.constants)
            .SetCallbackMiddle(function() {
                var selection = self.GetSelectedItem();
                array_sort_name(Game.vars.constants);
                if (!selection) return;
                for (var i = 0, n = array_length(Game.vars.constants); i < n; i++) {
                    if (Game.vars.constants[i] == selection) {
                        self.Select(i);
                        break;
                    }
                }
            })
            .SetID("LIST"),
        (new EmuButton(col1, EMU_AUTO, element_width, element_height, "Add Constant", function() {
            if (array_length(Game.vars.constants) < 0xffff) {
                array_push(Game.vars.constants, new DataValue("Constant" + string(array_length(Game.vars.constants))));
            }
            self.root.Refresh();
        }))
            .SetRefresh(function(data) {
                self.SetInteractive(array_length(Game.vars.constants) < 0xffff);
            }),
        (new EmuButton(col1, EMU_AUTO, element_width, element_height, "Delete Constant", function() {
            array_delete(Game.vars.constants, self.GetSibling("LIST").GetSelection(), 1);
            self.root.Refresh();
        }))
            .SetRefresh(function(data) {
                self.SetInteractive(data != -1 && array_length(Game.vars.constants) > 0);
            }),
        (new EmuInput(col2, EMU_BASE, element_width, element_height, "Name:", "", "constant name", VISIBLE_NAME_LENGTH, E_InputTypes.LETTERSDIGITSANDUNDERSCORES, function() {
            Game.vars.constants[self.GetSibling("LIST").GetSelection()].name = self.value;
        }))
            .SetRefresh(function(data) {
                self.SetInteractive(data != -1);
                if (data == -1) return;
                self.SetValue(Game.vars.constants[data].name);
            }),
        (new EmuList(col2, EMU_AUTO, element_width, element_height, "Constants", element_height, 8, function() {
            if (!self.root) return;
            var selection = self.GetSelection();
            if (selection == -1) return;
            var data = Game.vars.constants[self.GetSibling("LIST").GetSelection()];
            var original = data.type;
            data.type = self.GetSelection();
            if (original != data.type) {
                data.value = Stuff.data_type_meta[selection].default_value;
            }
        }))
            .SetRefresh(function(data) {
                self.SetInteractive(data != -1);
                if (data == -1) return;
                self.Deselect();
                self.Select(Game.vars.constants[data].type, true);
            })
            .SetEntryTypes(E_ListEntryTypes.STRUCTS)
            .SetAllowDeselect(false)
            .SetList(Stuff.data_type_meta)
            .SetID("TYPE")
    ]).AddDefaultCloseButton();
    
    
    
    
    var el_value_code = create_button(col3_x, yy, "Value:", ew, eh, fa_middle, function() {
        emu_dialog_notice("create some new code editor sometime maybe");
    }, dg);
    el_value_code.enabled = false;
    dg.el_value_code = el_value_code;
    var el_value_string = create_input(col3_x, yy, "Value:", ew, eh, function(input) {
        var selection = ui_list_selection(input.root.el_list);
        if (selection + 1) {
            Game.vars.constants[selection].value = input.value;
        }
    }, "", "text", validate_string, 0, 1, 160, vx1, vy1, vx2, vy2, dg);
    el_value_string.enabled = false;
    dg.el_value_string = el_value_string;
    var el_value_real = create_input(col3_x, yy, "Value:", ew, eh, function(input) {
        var selection = ui_list_selection(input.root.el_list);
        if (selection + 1) {
            Game.vars.constants[selection].value = real(input.value);
        }
    }, "0", "number", validate_double, -0x80000000, 0x7fffffff, 10, vx1, vy1, vx2, vy2, dg);
    el_value_real.enabled = false;
    dg.el_value_real = el_value_real;
    var el_value_int = create_input(col3_x, yy, "Value:", ew, eh, function(input) {
        var selection = ui_list_selection(input.root.el_list);
        if (selection + 1) {
            Game.vars.constants[selection].value = real(input.value);
        }
    }, "0", "int", validate_int, -0x80000000, 0x7fffffff, 11, vx1, vy1, vx2, vy2, dg);
    el_value_int.enabled = false;
    dg.el_value_int = el_value_int;
    var el_value_bool = create_checkbox(col3_x, yy, "Value", ew, eh, function(input) {
        var selection = ui_list_selection(input.root.el_list);
        if (selection + 1) {
            Game.vars.constants[selection].value = real(input.value);
        }
    }, false, dg);
    el_value_bool.enabled = false;
    dg.el_value_bool = el_value_bool;
    var el_value_color = create_color_picker(col3_x, yy, "Color", ew, eh, function(input) {
        var selection = ui_list_selection(input.root.el_list);
        if (selection + 1) {
            Game.vars.constants[selection].value = real(input.value);
        }
    }, c_black, vx1, vy1, vx2, vy2, dg);
    el_value_color.enabled = false;
    dg.el_value_color = el_value_color;
    // this is for selecting the datadata type
    var el_type_guid = create_list(col3_x, yy, "Select a Type", "<no types>", ew, eh, 8, function(list) {
        var selection = ui_list_selection(list.root.el_list);
        if (selection + 1) {
            var datadata = list.entries[ui_list_selection(list.root.el_type_guid)];
            var what = Game.vars.constants[selection];
            what.type_guid = datadata.GUID;
            what.value = NULL;
            var type = guid_get(what.type_guid);
            var list_data = list.root.el_value_data;
            list_data.entries = (what.type == DataTypes.DATA) ? type.instances : type.properties;
            ui_list_deselect(list_data);
        }
    }, false, dg, []);
    el_type_guid.enabled = false;
    el_type_guid.entries_are = ListEntries.INSTANCES;
    dg.el_type_guid = el_type_guid;
    // this is for non-datadata data - meshes, battlers, audio, etc
    var el_value_other = create_list(col3_x, yy, "Data:", "<no data>", ew, eh, 20, function(list) {
        var selection = ui_list_selection(list.root.el_list);
        if (selection + 1) {
            Game.vars.constants[selection].value = list.entries[ui_list_selection(list)].GUID;
        }
    }, false, dg, []);
    el_value_other.enabled = false;
    el_value_other.entries_are = ListEntries.INSTANCES;
    dg.el_value_other = el_value_other;
    // this is for datadata data - it's positioned in a different place
    var el_value_data = create_list(col3_x, yy + el_type_guid.GetHeight() + spacing, "Instance:", "<no data>", ew, eh, 8, function(list) {
        var selection = ui_list_selection(list.root.el_list);
        if (selection + 1) {
            Game.vars.constants[selection].value = list.entries[ui_list_selection(list)].GUID;
        }
    }, false, dg, []);
    el_value_data.enabled = false;
    el_value_data.entries_are = ListEntries.INSTANCES;
    dg.el_value_data = el_value_data;
    // for events
    var el_event = create_button(col3_x, yy, "Event: ", ew, eh, fa_left, function(button) {
        var selection = ui_list_selection(button.root.el_list);
        var constant = Game.vars.constants[selection];
        if (constant) {
            dialog_create_constant_get_event_graph(button.root, constant);
        }
    }, dg);
    el_event.enabled = false;
    dg.el_event = el_event;
    var el_event_entrypoint = create_button(col3_x, yy + el_event.height + spacing, "Entrypoint: ", ew, eh, fa_left, function(button) {
        var selection = ui_list_selection(button.root.el_list);
        var constant = Game.vars.constants[selection];
        if (constant) {
            dialog_create_constant_get_event_entrypoint(button.root, constant);
        }
    }, dg);
    el_event_entrypoint.enabled = false;
    dg.el_event_entrypoint = el_event_entrypoint;
    
    var b_width = 128;
    var b_height = 32;
    var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);
    
    ds_list_add(dg.contents,
        el_list,
        el_name,
        el_add,
        el_remove,
        el_alphabetize,
        // common
        el_type,
        el_type_ext,
        el_type_guid,
        // values
        el_value_code,
        el_value_string,
        el_value_real,
        el_value_int,
        el_value_bool,
        el_value_color,
        el_value_other,
        el_value_data,
        el_event,
        el_event_entrypoint,
        // done
        el_confirm
    );
    
    return dg;
}