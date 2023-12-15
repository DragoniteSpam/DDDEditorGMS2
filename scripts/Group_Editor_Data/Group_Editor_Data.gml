function EditorModeData() : EditorModeBase() constructor {
    self.last_active_type = undefined;
    self.last_active_instance = undefined;
    
    self.GetActiveType = function() {
        var selection = self.ui.SearchID("LIST").GetSelection();
        if (selection == -1) return undefined;
        return Game.data[selection];
    };
    
    self.GetActiveInstance = function() {
        var type = self.GetActiveType();
        if (!type) return undefined;
        var selection = self.ui.SearchID("INSTANCES").GetSelection();
        if (selection == -1) return undefined;
        return type.instances[selection];
    };
    
    self.SetMode = function() {
        editor_set_mode(self, ModeIDs.DATA);
        self.ui.Refresh();
    };
    
    self.Activate = function(data) {
        var container = self.ui.SearchID("PROPERTIES");
        container.ClearContent();
        
        if (data.type == DataTypes.DATA) {
            var columns = 5;
            var spacing = 16;
            
            var col_width = (room_width / columns);
            var col_height = room_height - 32 - (DEBUG ? 64 : 0);
            var col_index = 0;
            var element_width = col_width - spacing * 2;
            var element_height = 32;
            
            var column = new EmuCore(col_width * col_index++, 0, col_width, col_height);
            container.AddContent(column);
            
            column.AddContent([
                (new EmuInput(spacing, EMU_BASE, element_width, element_height, "Name:", "", "Instance name", VISIBLE_NAME_LENGTH, E_InputTypes.STRING, function() {
                    Stuff.data.GetActiveInstance().name = self.value;
                }))
                    .SetInteractive(false)
                    .SetRefresh(function() {
                        var inst = Stuff.data.GetActiveInstance();
                        self.SetInteractive(!!inst);
                        if (!inst) return;
                        self.SetValue(inst.name);
                    })
                    .SetID("NAME"),
                (new EmuInput(spacing, EMU_AUTO, element_width, element_height, "Internal name:", "", "Instance internal name", INTERNAL_NAME_LENGTH, E_InputTypes.LETTERSDIGITS, function() {
                    if (!internal_name_get(self.value)) {
                        internal_name_set(Stuff.data.GetActiveInstance(), self.value);
                    }
                }))
                    .SetInteractive(false)
                    .SetRefresh(function() {
                        var inst = Stuff.data.GetActiveInstance();
                        self.SetInteractive(!!inst);
                        if (!inst) return;
                        self.SetValue(inst.internal_name);
                    })
                    .SetID("INTERNAL NAME"),
                (new EmuButton(spacing, EMU_AUTO, element_width, element_height, "Flags", function() {
                }))
                    .SetInteractive(false)
                    .SetRefresh(function() {
                        self.SetInteractive(!!Stuff.data.GetActiveInstance());
                    })
                    .SetID("FLAGS"),
            ]);
                
            for (var i = 0; i < array_length(data.properties); i++) {
                var property = data.properties[i];
                var element = undefined;
                var element_header = undefined;
                if (property.max_size == 1) {
                    switch (property.type) {
                        case DataTypes.INT:             // input
                        case DataTypes.FLOAT:
                        case DataTypes.STRING:
                            // assume the type is string because that's the most general
                            var char_limit = property.char_limit;
                            var type = E_InputTypes.STRING;
                            var help = string(property.char_limit) + " characters";
                            if (property.type == DataTypes.INT) {
                                char_limit = max(number_max_digits(property.range_min), number_max_digits(property.range_max));
                                if (property.range_min < 0 || property.range_max < 0) {
                                    char_limit++;
                                }
                                type = E_InputTypes.INT;
                                help = string(property.range_min) + " - " + string(property.range_max);
                            } else if (property.type == DataTypes.INT) {
                                char_limit = 10;
                                type = E_InputTypes.STRING;
                                help = string(property.range_min) + " - " + string(property.range_max);
                            }
                            element = (new EmuInput(spacing, EMU_AUTO, element_width, element_height, property.name, "", help, char_limit, type, function() {
                                var inst = Stuff.data.GetActiveInstance()
                                if (!inst) return;
                                inst.values[self.key][0] = self.CastInput(self.value);
                            }))
                                .SetInteractive(false)
                                .SetRefresh(function() {
                                    var inst = Stuff.data.GetActiveInstance();
                                    self.SetInteractive(!!inst);
                                    if (!inst) return;
                                    self.SetValue(inst.values[self.key][0]);
                                });
                            break;
                        case DataTypes.ASSET_FLAG:      // button which leads to a dialog with a list of flags
                            element = (new EmuButton(spacing, EMU_AUTO, element_width, element_height, property.name, function() {
                                var dialog = new EmuDialog(32 + 320 + 32 + 320 + 32, 640, "Asset Flags");
                                dialog.index = self.key;
    
                                var element_width = 320;
                                var element_height = 32;
    
                                var col1 = 32;
                                var col2 = 32 + 320 + 32;
    
                                var instance = Stuff.data.GetActiveInstance();
                                dialog.instance = instance;
    
                                dialog.AddContent([
                                    (new EmuText(col1, EMU_BASE, element_width, element_height, "Numerical value: 0x0000000000000000"))
                                        .SetRefresh(function() {
                                            self.value = "Numerical value: " + string(ptr(self.GetSibling("FIELD").value));
                                        })
                                        .SetID("LABEL")
                                    (emu_bitfield_flags(col1, EMU_AUTO, element_width, element_height, instance.values[self.key][0], function() {
                                        self.root.instance.values[self.root.index][0] = self.value;
                                        self.root.Refresh();
                                    }, "Asset flags can be toggled on or off. Shaded cells are on, while unshaded cells are off."))
                                        .SetID("FIELD")
                                ]).AddDefaultCloseButton();
                            }))
                                .SetInteractive(false)
                                .SetRefresh(function() {
                                    var inst = Stuff.data.GetActiveInstance();
                                    self.SetInteractive(!!inst);
                                    if (!inst) return;
                                    self.SetValue(inst.values[self.key][0]);
                                });
                            break;
                        case DataTypes.ENUM:            // list
                        case DataTypes.DATA:            // list
                            var datadata = guid_get(property.type_guid);
                            if (datadata) {
                                element = (new EmuList(spacing, EMU_AUTO, element_width, element_height, property.name, element_height, 8, function() {
                                    if (!self.root) return;
                                    var item = self.GetSelectedItem();
                                    var inst = Stuff.data.GetActiveInstance();
                                    if (!inst || !item) return;
                                    inst.values[self.key][0] = item.GUID;
                                }))
                                    .SetInteractive(false)
                                    .SetRefresh(function() {
                                        self.Deselect();
                                        if (!self.root) return;
                                        var inst = Stuff.data.GetActiveInstance();
                                        self.SetInteractive(!!inst);
                                        if (!inst) return;
                                        var list = (self.datadata.type == DataTypes.DATA) ? self.datadata.instances : self.datadata.properties;
                                        self.Select(array_search_guid(list, inst.values[self.key][0]), true);
                                    })
                                    .SetListColors(emu_color_data_instances)
                                    .SetEntryTypes(E_ListEntryTypes.STRUCTS)
                                    .SetVacantText("<no values for " + datadata.name + ">");
                                element.datadata = datadata;
                                if (datadata.type == DataTypes.DATA) {
                                    element.SetList(datadata.instances);
                                } else if (datadata.type == DataTypes.ENUM) {
                                    element.SetList(datadata.properties);
                                }
                            } else {
                                element = (new EmuList(spacing, EMU_AUTO, element_width, element_height, property.name, element_height, 8, emu_null))
                                    .SetVacantText("<missing data type>");
                            }
                            break;
                        case DataTypes.BOOL:        // checkbox
                            element = (new EmuCheckbox(spacing, EMU_AUTO, element_width, element_height, property.name, false, function() {
                                var inst = Stuff.data.GetActiveInstance()
                                if (!inst) return;
                                inst.values[self.key][0] = self.value;
                            }))
                                .SetInteractive(false)
                                .SetRefresh(function() {
                                    var inst = Stuff.data.GetActiveInstance();
                                    self.SetInteractive(!!inst);
                                    if (!inst) return;
                                    self.SetValue(inst.values[self.key][0]);
                                });
                            break;
                        case DataTypes.CODE:        // checkbox
                            element = (new EmuButton(spacing, EMU_AUTO, element_width, element_height, property.name, function() {
                                emu_dialog_notice("re-implement some kind of code editor some time if you really want this to be a thing");
                            }))
                                .SetInteractive(false)
                                .SetRefresh(function() {
                                    var inst = Stuff.data.GetActiveInstance();
                                    self.SetInteractive(!!inst);
                                    if (!inst) return;
                                    self.SetValue(inst.values[self.key][0]);
                                });
                            break;
                        case DataTypes.COLOR:       // checkbox
                            element = (new EmuColorPicker(spacing, EMU_AUTO, element_width, element_height, property.name, c_white, function() {
                                var inst = Stuff.data.GetActiveInstance()
                                if (!inst) return;
                                inst.values[self.key][0] = self.value;
                            }))
                                .SetInteractive(false)
                                .SetRefresh(function() {
                                    var inst = Stuff.data.GetActiveInstance();
                                    self.SetInteractive(!!inst);
                                    if (!inst) return;
                                    self.SetValue(inst.values[self.key][0]);
                                });
                            break;
                        case DataTypes.EVENT:      // list
                            element_header = new EmuText(spacing, EMU_AUTO, element_width, element_height, property.name);
                            element = (new EmuButton(spacing, EMU_AUTO, element_width, element_height, "Select Event...", function() {
                                // formerly dialog_create_data_get_event
                            }))
                                .SetInteractive(false)
                                .SetRefresh(function() {
                                    var inst = Stuff.data.GetActiveInstance();
                                    self.SetInteractive(!!inst);
                                    if (!inst) return;
                                    // logic
                                });
                            break;
                        case DataTypes.TILE:
                        case DataTypes.ENTITY:
                            element = new EmuText(spacing, EMU_AUTO, element_width, element_height, "Not implemented and/or available");
                            break;
                        default:
                            var vacant_text, list;
                            switch (property.type) {
                                case DataTypes.MESH: vacant_text = "meshes"; list = Game.meshes; break;
                                case DataTypes.MESH_AUTOTILE: vacant_text = "mesh autotiles"; list = Game.mesh_autotile; break;
                                case DataTypes.IMG_BATTLER: vacant_text = "battler graphics"; list = Game.graphics.battlers; break;
                                case DataTypes.IMG_ETC: vacant_text = "misc graphics"; list = Game.graphics.etc; break;
                                case DataTypes.IMG_OVERWORLD: vacant_text = "overworld graphics"; list = Game.graphics.overworlds; break;
                                case DataTypes.IMG_PARTICLE: vacant_text = "particle graphics"; list = Game.graphics.particles; break;
                                case DataTypes.IMG_SKYBOX: vacant_text = "skybox graphics"; list = Game.graphics.skybox; break;
                                case DataTypes.IMG_TEXTURE: vacant_text = "texture/tileset graphics"; list = Game.graphics.tilesets; break;
                                case DataTypes.IMG_TILE_ANIMATION: vacant_text = "tile animations"; list = Game.graphics.tile_animations; break;
                                case DataTypes.IMG_UI: vacant_text = "UI graphics"; list = Game.graphics.ui; break;
                                case DataTypes.AUDIO_BGM: vacant_text = "background music"; list = Game.audio.bgm; break;
                                case DataTypes.AUDIO_SE: vacant_text = "sound effects"; list = Game.audio.se; break;
                                case DataTypes.ANIMATION: vacant_text = "animations"; list = Game.animations; break;
                                case DataTypes.MAP: vacant_text = "maps"; list = Game.maps; break;
                            }
                            element = (new EmuList(spacing, EMU_AUTO, element_width, element_height, property.name, element_height, 8, function() {
                                if (!self.root) return;
                                var item = self.GetSelectedItem();
                                var inst = Stuff.data.GetActiveInstance();
                                if (!inst || !item) return;
                                inst.values[self.key][0] = item.GUID;
                            }))
                                .SetInteractive(false)
                                .SetRefresh(function() {
                                    self.Deselect();
                                    if (!self.root) return;
                                    var inst = Stuff.data.GetActiveInstance();
                                    self.SetInteractive(!!inst);
                                    if (!inst) return;
                                    self.Select(array_search_guid(self.entries, inst.values[self.key][0]), true);
                                })
                                .SetEntryTypes(E_ListEntryTypes.STRUCTS)
                                .SetList(list)
                                .SetVacantText("<no " + vacant_text + ">");
                            break;
                    }
                    element.key = i;
                } else {
                    element = new EmuButton(spacing, EMU_AUTO, element_width, element_height, property.name + "...", emu_null);
                    element.key = i;
                }
                
                if (element_header) column.AddContent([element_header]);
                column.AddContent([element]);
                
                if (element.y + element.GetHeight() > column.height) {
                    column.RemoveContent(element);
                    if (element_header) column.RemoveContent(element_header);
                    
                    column = new EmuCore(col_width * col_index++, 0, col_width, col_height);
                    container.AddContent(column);
                    
                    if (element_header) {
                        element_header.y = EMU_BASE;
                        column.AddContent([element_header]);
                    }
                    element.y = EMU_AUTO;
                    column.AddContent([element]);
                }
            }
            
            
            if (col_index > 3) {
                container.GetSibling("PREVIOUS").SetInteractive(true);
                container.GetSibling("PAGENUM").SetInteractive(true);
                container.GetSibling("PAGENUM").text = "Page 1/" + string(col_index - 3);
                container.GetSibling("NEXT").SetInteractive(true);
            } else {
                container.GetSibling("PREVIOUS").SetInteractive(false);
                container.GetSibling("PAGENUM").SetInteractive(false);
                container.GetSibling("PAGENUM").text = "Page 1/1";
                container.GetSibling("NEXT").SetInteractive(false);
            }
        }
        
        self.ui.Refresh();
        
        return container;
    };
    
    self.Render = function() {
        draw_clear(EMU_COLOR_BACK);
        Stuff.base_camera.SetProjectionGUI();
        self.ui.Render();
        editor_gui_post();
    };

    self.Save = function() {
        
    };
    
    self.active_type_guid = NULL;
    self.ui = ui_init_game_data(self);
    self.mode_id = ModeIDs.DATA;
}
