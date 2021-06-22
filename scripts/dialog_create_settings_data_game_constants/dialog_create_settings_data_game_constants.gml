function dialog_create_settings_data_game_constants(root) {
    var dw = 960;
    var dh = 640;
    
    var dg = dialog_create(dw, dh, "Data Settings: Game Constants", dialog_default, dialog_destroy, root);
    
    var columns = 3;
    var ew = dw / columns - 64;
    var eh = 24;
    
    var col1_x = 32;
    var col2_x = dw / columns + 32;
    var col3_x = dw * 2 / columns + 32;
    
    var vx1 = ew / 3;
    var vy1 = 0;
    var vx2 = ew;
    var vy2 = eh;
    
    var spacing = 16;
    
    var yy = 64;
    var yy_base = 64;
    
    var function_alphabetize = function(element) {
        var list = element.root.el_list;
        var selection = list.entries[ui_list_selection(list)];
        ui_list_deselect(list);
        array_sort_name(list.entries);
        for (var i = 0; i < array_length(list.entries); i++) {
            if (list.entries[i] == selection) {
                ui_list_select(list, i);
                break;
            }
        }
    };
    
    dg.function_activate = function(base_dialog, const) {
        base_dialog.el_value_code.enabled = false;
        base_dialog.el_value_string.enabled = false;
        base_dialog.el_value_real.enabled = false;
        base_dialog.el_value_int.enabled = false;
        base_dialog.el_value_bool.enabled = false;
        base_dialog.el_value_color.enabled = false;
        base_dialog.el_value_other.enabled = false;
        base_dialog.el_type_guid.enabled = false;
        base_dialog.el_value_data.enabled = false;
        base_dialog.el_event_entrypoint.enabled = false;
        base_dialog.el_event.enabled = false;
        
        switch (const.type) {
            case DataTypes.INT:
                const.value = floor(const.value);
                base_dialog.el_value_int.enabled = true;
                base_dialog.el_value_int.value = string(const.value);
                break;
            case DataTypes.FLOAT:
                // no need to cast, since anything in here will already be a valid float
                base_dialog.el_value_real.enabled = true;
                base_dialog.el_value_real.value = string(const.value);
                break;
            case DataTypes.STRING:
                base_dialog.el_value_string.enabled = true;
                base_dialog.el_value_string.value = const.value;
                break;
            case DataTypes.BOOL:
                const.value = !!const.value;
                base_dialog.el_value_bool.enabled = true;
                base_dialog.el_value_bool.value = const.value;
                break;
            case DataTypes.CODE:
                base_dialog.el_value_code.enabled = true;
                base_dialog.el_value_code.value = const.value;
                break;
            case DataTypes.ENUM:
            case DataTypes.DATA:
                var list_data = base_dialog.el_value_data;
                var list = base_dialog.el_type_guid;
                var type = guid_get(const.type_guid);
                list_data.enabled = true;
                list.enabled = true;
                ui_list_clear(list);
                ui_list_deselect(list_data);
        
                if (type && (const.type != type.type)) {
                    const.value = NULL;
                    const.type_guid = NULL;
                    type = noone;
                }
        
                for (var i = 0; i < array_length(Game.data); i++) {
                    var datadata = Game.data[i];
                    if (const.type == datadata.type) {
                        array_push(list.entries, datadata);
                    }
                }
        
                if (type) {
                    // select the type in the type list, if there is one
                    var index = array_search(list.entries, type);
                    ui_list_select(list, index, true);
                    // set the data in the data list
                    list_data.entries = (const.type == DataTypes.DATA) ? type.instances : type.properties;
            
                    var data = guid_get(const.value);
            
                    if (data) {
                        ui_list_select(list_data, array_search(list_data.entries, data), true);
                    }
                } else {
                    list_data.entries = [];
                }
        
                list_data.index = 0;
                break;
            case DataTypes.MESH:
                var list = base_dialog.el_value_other;
                list.entries = Game.meshes;
                ui_list_deselect(list);
                ui_list_select(list, array_search(list.entries, guid_get(const.value)), true);
                list.enabled = true;
                list.index = 0;
                break;
            case DataTypes.IMG_TEXTURE:
                var list = base_dialog.el_value_other;
                list.entries = Game.graphics.tilesets;
                ui_list_deselect(list);
                ui_list_select(list, array_search(list.entries, guid_get(const.value)), true);
                list.enabled = true;
                list.index = 0;
                break;
            case DataTypes.TILE:
                not_yet_implemented();
                break;
            case DataTypes.IMG_TILE_ANIMATION:
                var list = base_dialog.el_value_other;
                list.entries = Game.graphics.tile_animations;
                ui_list_deselect(list);
                ui_list_select(list, array_search(list.entries, guid_get(const.value)), true);
                list.enabled = true;
                list.index = 0;
                break;
            case DataTypes.AUDIO_BGM:
                var list = base_dialog.el_value_other;
                list.entries = Game.audio.bgm;
                ui_list_deselect(list);
                ui_list_select(list, array_search(list.entries, guid_get(const.value)), true);
                list.enabled = true;
                list.index = 0;
                break;
            case DataTypes.AUDIO_SE:
                var list = base_dialog.el_value_other;
                list.entries = Game.audio.se;
                ui_list_deselect(list);
                ui_list_select(list, array_search(list.entries, guid_get(const.value)), true);
                list.enabled = true;
                list.index = 0;
                break;
            case DataTypes.ANIMATION:
                var list = base_dialog.el_value_other;
                list.entries = Game.animations;
                ui_list_deselect(list);
                ui_list_select(list, array_search(list.entries, guid_get(const.value)), true);
                list.enabled = true;
                list.index = 0;
                break;
            case DataTypes.MAP:
                var list = base_dialog.el_value_other;
                list.entries = Game.maps;
                ui_list_deselect(list);
                ui_list_select(list, array_search(list.entries, guid_get(const.value)), true);
                list.enabled = true;
                list.index = 0;
                break;
            case DataTypes.IMG_BATTLER:
                var list = base_dialog.el_value_other;
                list.entries = Game.graphics.battlers;
                ui_list_deselect(list);
                ui_list_select(list, array_search(list.entries, guid_get(const.value)), true);
                list.enabled = true;
                list.index = 0;
                break;
            case DataTypes.IMG_OVERWORLD:
                var list = base_dialog.el_value_other;
                list.entries = Game.graphics.overworlds;
                ui_list_deselect(list);
                ui_list_select(list, array_search(list.entries, guid_get(const.value)), true);
                list.enabled = true;
                list.index = 0;
                break;
            case DataTypes.IMG_PARTICLE:
                var list = base_dialog.el_value_other;
                list.entries = Game.graphics.particles;
                ui_list_deselect(list);
                ui_list_select(list, array_search(list.entries, guid_get(const.value)), true);
                list.enabled = true;
                list.index = 0;
                break;
            case DataTypes.IMG_UI:
                var list = base_dialog.el_value_other;
                list.entries = Game.graphics.ui;
                ui_list_deselect(list);
                ui_list_select(list, array_search(list.entries, guid_get(const.value)), true);
                list.enabled = true;
                list.index = 0;
                break;
            case DataTypes.IMG_ETC:
                var list = base_dialog.el_value_other;
                list.entries = Game.graphics.etc;
                ui_list_deselect(list);
                ui_list_select(list, array_search(list.entries, guid_get(const.value)), true);
                list.enabled = true;
                list.index = 0;
                break;
            case DataTypes.COLOR:
                const.value = c_black;
                base_dialog.el_value_color.enabled = true;
                base_dialog.el_value_color.value = c_black;
                break;
            case DataTypes.EVENT:
                base_dialog.el_event.enabled = true;
                base_dialog.el_event_entrypoint.enabled = true;
                var entrypoint = guid_get(const.value);
                var event = entrypoint ? entrypoint.event : noone;
                base_dialog.el_event.text = "Event: " + (event ? event.name : "");
                base_dialog.el_event_entrypoint.text = "Entrypoint: " + (entrypoint ? entrypoint.name : "");
                break;
        }
    };
    
    var el_list = create_list(col1_x, yy, "Constants", "<no constants>", ew, eh, 16, function(list) {
        var selection = ui_list_selection(list);
        var base_dialog = list.root;
        if (selection + 1) {
            var what = Game.vars.constants[selection];
            ui_input_set_value(base_dialog.el_name, what.name);
            base_dialog.el_type.interactive = true;
            base_dialog.el_type.value = what.type;
            base_dialog.el_type_ext.interactive = true;
            base_dialog.function_activate(base_dialog, what);
        }
    }, false, dg, Game.vars.constants);
    el_list.numbered = true;
    el_list.entries_are = ListEntries.INSTANCES;
    el_list.onmiddleclick = function_alphabetize;
    dg.el_list = el_list;
    
    yy += ui_get_list_height(el_list) + spacing;
    
    var el_add = create_button(col1_x, yy, "Add Constant", ew, eh, fa_center, function(button) {
        if (array_length(Game.vars.constants) < 0xffff) {
            array_push(Game.vars.constants, new DataConstant("Constant " + string(array_length(Game.vars.constants))));
        }
    }, dg);
    dg.el_add = el_add;
    
    yy += el_add.height + spacing;
    
    var el_remove = create_button(col1_x, yy, "Delete Constant", ew, eh, fa_center, function(button) {
        var list = button.root.el_list;
        var selection = ui_list_selection(list);
        if (selection + 1) {
            Game.vars.constants[selection].Destroy();
            array_delete(Game.vars.constants, selection, 1);
        }
    }, dg);
    dg.el_remove = el_remove;
    
    yy += el_remove.height + spacing;
    
    var el_alphabetize = create_button(col1_x, yy, "Alphabetize", ew, eh, fa_center, function_alphabetize, dg);
    dg.el_remove = el_alphabetize;
    
    yy += el_alphabetize.height + spacing;
    
    yy = yy_base;
    
    var el_name = create_input(col2_x, yy, "Name:", ew, eh, function(input) {
        var selection = ui_list_selection(input.root.el_list);
        if (selection + 1) {
            Game.vars.constants[selection].name = input.value;
        }
    }, "", "16 characters", validate_string, 0, 1, VISIBLE_NAME_LENGTH, vx1, vy1, vx2, vy2, dg);
    dg.el_name = el_name;
    
    yy += el_name.height + spacing;
    
    var el_type = create_radio_array(col2_x, yy, "Type:", ew, eh, function(option) {
        var selection = ui_list_selection(option.root.root.el_list);
        if (selection + 1) {
            var what = Game.vars.constants[selection];
            what.type = option.value;
            what.value = Stuff.data_type_default_values[option.value];
            option.root.root.function_activate(option.root.root, what);
        }
    }, 0, dg);
    create_radio_array_options(el_type, [
        "Int", "Enum", "Float", "String", "Boolean", "Data", "Code", "Color", "Mesh", "Tileset", "Tile", "Autotile",
        "Audio (BGM)", "Audio (SE)", "Animation"
    ]);
    el_type.contents[DataTypes.TILE].interactive = false;
    el_type.interactive = false;
    dg.el_type = el_type;
    
    yy += ui_get_radio_array_height(el_type) + spacing;
    
    var el_type_ext = create_button(col2_x, yy, "Other Data Types", ew, eh, fa_middle, omu_global_data_select_type, dg);
    el_type_ext.interactive = false;
    dg.el_type_ext = el_type_ext;
    
    yy = yy_base;
    
    var el_value_code = create_input_code(col3_x, yy, "Value:", ew, eh, vx1, vy1, vx2, vy2, "", function(input) {
        var selection = ui_list_selection(input.root.el_list);
        if (selection + 1) {
            Game.vars.constants[selection].value = input.value;
        }
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
    var el_value_data = create_list(col3_x, yy + ui_get_list_height(el_type_guid) + spacing, "Instance:", "<no data>", ew, eh, 8, function(list) {
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