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
        
        // creating and destroying the data editor UI is probably the easiest
        // way to do this; this may need to get stuffed off into its own script
        // later
        if (self.ui) {
            instance_activate_object(self.ui);
            instance_destroy(self.ui);
        }
    
        self.ui = ui_init_game_data(self);
    
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
            var element_width = col_width - spacing * 2;
            var element_height = 32;
            
            var column = new EmuCore(0, 0, col_width, col_height);
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
                
                for (var i = 0; i < array_length(data.properties); i++) {
                    var property = data.properties[i];
                    var element = undefined;
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
                        }
                        element.key = i;
                    } else {
                    }
                }
            ]);
            
                        case DataTypes.ASSET_FLAG:     // button which leads to a dialog with a list of flags
                            element = create_button(0, yy, property.name, ew, eh, fa_center, function(button) {
                                var data = guid_get(Stuff.data.ui.active_type_guid);
                                var instance_selection = ui_list_selection(Stuff.data.ui.el_instances);
                                if (instance_selection + 1) {
                                    dialog_create_game_data_asset_flags(button, button.key);
                                }
                            }, noone);
                            element.key = i;
                            var hh = element.height;
                            break;
                        case DataTypes.ENUM:           // list
                        case DataTypes.DATA:           // list
                            var datadata = guid_get(property.type_guid);
                            if (datadata) {
                                element = create_list(0, yy, property.name, "<no options: " + datadata.name + ">", ew, eh, 8, uivc_data_set_property_list, false, noone);
                                if (datadata.type == DataTypes.DATA) {
                                    for (var j = 0; j < array_length(datadata.instances); j++) {
                                        create_list_entries(element, datadata.instances[j]);
                                    }
                                } else {
                                    for (var j = 0; j < array_length(datadata.properties); j++) {
                                        create_list_entries(element, datadata.properties[j]);
                                    }
                                }
                            } else {
                                element = create_list(0, yy, "<missing data type>", "<n/a>", ew, eh, 8, null, false, noone);
                            }
                            element.key = i;
                            element.entries_are = ListEntries.INSTANCES;
                            var hh = element.GetHeight();
                            break;
                        case DataTypes.BOOL:           // checkbox
                            element = create_checkbox(0, yy, property.name, ew, eh, uivc_data_set_property_boolean, false, noone);
                            element.key = i;
                            var hh = element.height;
                            break;
                        case DataTypes.CODE:
                            element_header = create_text(0, yy, property.name, ew, eh, fa_left, ew, noone);
                            element = create_button(0, yy, property.name, ew, eh, fa_middle, function() {
                                emu_dialog_notice("re-implement some kind of code editor some time maybe");
                            }, noone);
                            element.key = i;
                            var hh = vy2;
                            break;
                        case DataTypes.COLOR:
                            element = create_color_picker(0, yy, property.name, ew, eh, uivc_data_set_property_color, c_white, vx1n, vy1n, vx2n, vy2n, noone);
                            element.key = i;
                            var hh = element.height;
                            break;
                        case DataTypes.MESH:           // list
                            element = create_list(0, yy, property.name, "<no Meshes>", ew, eh, 8, uivc_data_set_property_built_in_data, false, noone, Game.meshes);
                            element.key = i;
                            element.entries_are = ListEntries.INSTANCES;
                            var hh = element.GetHeight();
                            break;
                        case DataTypes.MESH_AUTOTILE:   // list
                            element = create_list(0, yy, property.name, "<no Mesh Autotiles>", ew, eh, 8, uivc_data_set_property_built_in_data, false, noone, Game.mesh_autotiles);
                            element.key = i;
                            element.entries_are = ListEntries.INSTANCES;
                            var hh = element.GetHeight();
                            break;
                        case DataTypes.TILE:
                            not_yet_implemented();
                            break;
                        case DataTypes.IMG_TEXTURE:           // list
                            element = create_list(0, yy, property.name, "<no Tilesets>", ew, eh, 8, uivc_data_set_property_built_in_data, false, noone, Game.graphics.tilesets);
                            element.key = i;
                            element.entries_are = ListEntries.INSTANCES;
                            var hh = element.GetHeight();
                            break;
                        case DataTypes.IMG_BATTLER:           // list
                            element = create_list(0, yy, property.name, "<no Battler sprites>", ew, eh, 8, uivc_data_set_property_built_in_data, false, noone, Game.graphics.battlers);
                            element.key = i;
                            element.entries_are = ListEntries.INSTANCES;
                            var hh = element.GetHeight();
                            break;
                        case DataTypes.IMG_OVERWORLD:       // list
                            element = create_list(0, yy, property.name, "<no Overworld sprites>", ew, eh, 8, uivc_data_set_property_built_in_data, false, noone, Game.graphics.overworlds);
                            element.key = i;
                            element.entries_are = ListEntries.INSTANCES;
                            var hh = element.GetHeight();
                            break;
                        case DataTypes.IMG_PARTICLE:           // list
                            element = create_list(0, yy, property.name, "<no Particle sprites>", ew, eh, 8, uivc_data_set_property_built_in_data, false, noone, Game.graphics.particles);
                            element.key = i;
                            element.entries_are = ListEntries.INSTANCES;
                            var hh = element.GetHeight();
                            break;
                        case DataTypes.IMG_UI:           // list
                            element = create_list(0, yy, property.name, "<no UI images>", ew, eh, 8, uivc_data_set_property_built_in_data, false, noone, Game.graphics.ui);
                            element.key = i;
                            element.entries_are = ListEntries.INSTANCES;
                            var hh = element.GetHeight();
                            break;
                        case DataTypes.IMG_ETC:           // list
                            element = create_list(0, yy, property.name, "<no Misc images>", ew, eh, 8, uivc_data_set_property_built_in_data, false, noone, Game.graphics.etc);
                            element.key = i;
                            element.entries_are = ListEntries.INSTANCES;
                            var hh = element.GetHeight();
                            break;
                        case DataTypes.IMG_SKYBOX:       // list
                            element = create_list(0, yy, property.name, "<no Skybox images>", ew, eh, 8, uivc_data_set_property_built_in_data, false, noone, Game.graphics.skybox);
                            element.key = i;
                            element.entries_are = ListEntries.INSTANCES;
                            var hh = element.GetHeight();
                            break;
                        case DataTypes.IMG_TILE_ANIMATION:// list
                            element = create_list(0, yy, property.name, "<no Tile Animations>", ew, eh, 8, uivc_data_set_property_built_in_data, false, noone, Game.graphics.tile_animations);
                            element.key = i;
                            element.entries_are = ListEntries.INSTANCES;
                            var hh = element.GetHeight();
                            break;
                        case DataTypes.AUDIO_BGM:           // list
                            element = create_list(0, yy, property.name, "<no BGM>", ew, eh, 8, uivc_data_set_property_built_in_data, false, noone, Game.audio.bgm);
                            element.key = i;
                            element.entries_are = ListEntries.INSTANCES;
                            var hh = element.GetHeight();
                            break;
                        case DataTypes.AUDIO_SE:           // list
                            element = create_list(0, yy, property.name, "<no SE>", ew, eh, 8, uivc_data_set_property_built_in_data, false, noone, Game.audio.se);
                            element.key = i;
                            element.entries_are = ListEntries.INSTANCES;
                            var hh = element.GetHeight();
                            break;
                        case DataTypes.ANIMATION:          // list
                            element = create_list(0, yy, property.name, "<no Animations>", ew, eh, 8, uivc_data_set_property_built_in_data, false, noone, Game.animations);
                            element.key = i;
                            element.entries_are = ListEntries.INSTANCES;
                            var hh = element.GetHeight();
                            break;
                        case DataTypes.ENTITY:          // list
                            element = create_text(0, yy, property.name + " - invalid data type", ew, eh, fa_left, ew, noone);
                            var hh = element.height;
                            break;
                        case DataTypes.MAP:             // list
                            element = create_list(0, yy, property.name, "<no Maps - how?>", ew, eh, 8, uivc_data_set_property_built_in_data, false, noone, Game.maps);
                            element.key = i;
                            element.entries_are = ListEntries.INSTANCES;
                            var hh = element.GetHeight();
                            break;
                        case DataTypes.EVENT:           // list
                            element_header = create_text(0, yy, property.name, ew, eh, fa_left, ew, noone);
                            element = create_button(0, yy + vy1, "Select Event", ew, eh, fa_center, dialog_create_data_get_event, noone);
                            element.event_guid = noone;
                            element.instance = noone;
                            element.key = i;
                            var hh = vy2;
                            break;
                    }
                } else {
                    element = create_button(0, yy, property.name + " (List)", ew, eh, fa_middle, dialog_create_data_instance_property_list, noone);
                    element.key = i;
                    var hh = element.height;
                }
                
                    // this is where everything gets shifted to the next column, if needed
                    if (yy + hh > room_height - 96) {
                        var n = ds_list_size(container.contents);
                        col_data = instance_create_depth((n /* + 2 */) * cw + spacing * 4, 0, 0, UIThing);
                        if (n > 2) {
                            col_data.enabled = false;
                        }
                        ds_list_add(container.contents, col_data);
                    
                        if (element_header) {
                            var difference = element.y - element_header.y;
                            element_header.y = yy_base;
                            element.y = element_header.y + difference;
                        } else {
                            element.y = yy_base;
                        }
                    
                        yy = yy_base;
                    }
                
                    yy += hh + spacing;
                
                    if (element_header) {
                        element_header.is_aux = true;
                        ds_list_add(col_data.contents, element_header);
                        element_header = noone;
                    }
                    ds_list_add(col_data.contents, element);
                }
            
                var pages = ds_list_size(container.contents);
                Stuff.data.ui.el_pages.text = "Page 1 / " + string(max(1, pages - 2));
                Stuff.data.ui.el_previous.interactive = pages > 2;
                Stuff.data.ui.el_next.interactive = pages > 2;
            }
        }
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
    self.ui = undefined;
    self.mode_id = ModeIDs.DATA;
}
