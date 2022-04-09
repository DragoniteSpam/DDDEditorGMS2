function EditorModeData() : EditorModeBase() constructor {
    self.GetActiveType = function() {
        var selection = self.ui.SearchID("LIST").GetSelection();
        if (selection == -1) return undefined;
        return Game.data[selection];
    };
    
    self.GetActiveInstance = function() {
        var type = self.GetActiveType();
        if (!type) return undefined;
        var selection = self.ui.SearchID("LIST").GetSelection();
        if (selection == -1) return undefined;
        return type.instances[selection];
    };
    
    self.SetMode = function() {
        editor_set_mode(self, ModeIDs.DATA);
        
        if (array_length(Game.data) > 0) {
            //ui_list_select(self.ui.el_master, 0);
        }
    
        //ui_init_game_data_activate();
        
        self.ui.Refresh();
    };
    
    self.Activate = function(data) {
        var container = Stuff.data.ui.SearchID("PROPERTIES");
        container.destroyContent();
        
        if (data.type == DataTypes.DATA) {
            var columns = 5;
            var spacing = 16;
            
            var col_width = (room_width / columns);
            var col_height = room_height - 32;
            var col_index = 0;
            var element_width = col_width - spacing * 2;
            var element_height = 32;
            
            var column = new EmuCore(col_width * col_index++, 0, col_width, col_height);
            container.AddContent(column);
            
            column.AddContent([
                (new EmuInput(spacing, EMU_BASE, element_width, element_height, "Name:", "", "Instance name", VISIBLE_NAME_LENGTH, E_InputTypes.STRING, function() {
                    Stuff.data.GetActiveInstance().name = self.value;
                }))
                    .SetID("NAME"),
                (new EmuInput(spacing, EMU_AUTO, element_width, element_height, "Internal name:", "", "Instance internal name", INTERNAL_NAME_LENGTH, E_InputTypes.LETTERSDIGITS, function() {
                    if (!internal_name_get(self.value)) {
                        internal_name_set(Stuff.data.GetActiveInstance(), self.value);
                    }
                }))
                    .SetID("NAME"),
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
                            element = new EmuInput(spacing, EMU_AUTO, element_width, element_height, property.name, "", help, char_limit, type, function() {
                                    
                            });
                            break;
                        case DataTypes.ASSET_FLAG:      // button which leads to a dialog with a list of flags
                            element = new EmuButton(spacing, EMU_AUTO, element_width, element_height, property.name, function() {
                                // needs to be Emu'd
                                dialog_create_game_data_asset_flags(button, button.key);
                            });
                            break;
                        case DataTypes.ENUM:            // list
                        case DataTypes.DATA:            // list
                            var datadata = guid_get(property.type_guid);
                            if (datadata) {
                                // callback used to be uivc_data_set_property_list
                                element = (new EmuList(spacing, EMU_AUTO, element_width, element_height, property.name, element_height, 8, function() {
                                }))
                                    .SetEntryTypes(E_ListEntryTypes.STRUCTS)
                                    .SetVacantText("<no values for " + datadata.name + ">");
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
                            element = new EmuCheckbox(spacing, EMU_AUTO, element_width, element_height, property.name, false, function() {
                                // formerly uivc_data_set_property_boolean
                            });
                            break;
                        case DataTypes.CODE:        // checkbox
                            element = new EmuButton(spacing, EMU_AUTO, element_width, element_height, property.name, function() {
                                emu_dialog_notice("re-implement some kind of code editor some time if you really want this to be a thing");
                            });
                            break;
                        case DataTypes.COLOR:       // checkbox
                            element = new EmuColorPicker(spacing, EMU_AUTO, element_width, element_height, property.name, c_white, function() {
                                // formerly uivc_data_set_property_color
                            });
                            break;
                        case DataTypes.EVENT:      // list
                            element_header = new EmuText(spacing, EMU_AUTO, element_width, element_height, property.name);
                            element = new EmuButton(spacing, EMU_AUTO, element_width, element_height, "Select Event...", function() {
                                // formerly dialog_create_data_get_event
                            });
                            break;
                        case DataTypes.TILE:
                        case DataTypes.ENTITY:
                            element = new EmuText(spacing, EMU_AUTO, element_width, element_height, "Not implemented/not available");
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
                                // formerly uivc_data_set_property_built_in_data
                            }))
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
                
                if (element.y + element.height > column.height) {
                    column.RemoveContent(element);
                    if (element_header) column.RemoveContent(element);
                    
                    var column = new EmuCore(col_width * col_index++, 0, col_width, col_height);
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
