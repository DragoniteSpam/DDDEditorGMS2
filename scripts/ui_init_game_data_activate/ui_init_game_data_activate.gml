function ui_init_game_data_activate() {
    var container = Stuff.data.ui.el_dynamic;
    var selection = ui_list_selection(Stuff.data.ui.el_master);

    if (selection + 1) {
        Stuff.data.ui.active_type_guid = Game.data[selection].GUID;

        var data = guid_get(Stuff.data.ui.active_type_guid);
        
        Stuff.data.ui.el_inst_add.interactive = false;
        Stuff.data.ui.el_inst_duplicate.interactive = false;
        Stuff.data.ui.el_inst_remove.interactive = false;
        Stuff.data.ui.el_inst_move_up.interactive = false;
        Stuff.data.ui.el_inst_move_down.interactive = false;

        ui_list_deselect(Stuff.data.ui.el_instances);

        // i'm really hoping UI elements are destroyed correctly now
        ds_list_clear_instances(container.contents);

        if (data) {
            // this caused some sort of null pointer exception somehow, and I haven't been able to replicate
            // it. wrapping it in this "if" should take care of it, though.
            Stuff.data.ui.el_inst_add.interactive = (data.type == DataTypes.DATA);
            Stuff.data.ui.el_inst_duplicate.interactive = (data.type == DataTypes.DATA);
            Stuff.data.ui.el_inst_remove.interactive = (data.type == DataTypes.DATA);
            Stuff.data.ui.el_inst_move_up.interactive = (data.type == DataTypes.DATA);
            Stuff.data.ui.el_inst_move_down.interactive = (data.type == DataTypes.DATA);
        
            if (data.type == DataTypes.DATA) {
                var columns = 5;
                var spacing = 16;
            
                var cw =(room_width - columns * 32) / columns;
                var ew = cw - spacing * 2;
                var eh = 24;
            
                // most input boxes
                var vx1 = 0;
                var vy1 = eh * 1.5;
                var vx2 = ew;
                var vy2 = vy1 + eh;
            
                // number values and colors
                var vx1n = ew * 2 / 3;
                var vy1n = 0;
                var vx2n = ew;
                var vy2n = vy1n + eh;
            
                var b_width = 128;
                var b_height = 32;
            
                var yy = 32;
                var yy_base = yy;
            
                var col_yy = yy;
                var col_data = instance_create_depth(/*2 * cw + */spacing, 0, 0, UIThing);
                ds_list_add(container.contents, col_data);
            
                var element_header = noone;
                var element = create_input(0, yy, "Name:", ew, eh * 2, uivc_data_set_name, "", "Instance name", validate_string, 0, 1, VISIBLE_NAME_LENGTH, vx1, vy1, vx2, vy2, noone);
                element.valignment = fa_top;
                yy += element.height + spacing;
            
                ds_list_add(col_data.contents, element);
                Stuff.data.ui.el_inst_name = element;
            
                element = create_input(0, yy, "Internal Name:", ew, eh * 2, uivc_data_set_internal_name, "", "Internal name", validate_string_internal_name, 0, 1, INTERNAL_NAME_LENGTH, vx1, vy1, vx2, vy2, noone);
                element.valignment = fa_top;
                element.render = function(text, x, y) {
                    var data = guid_get(Stuff.data.ui.active_type_guid);
                    var selection = ui_list_selection(Stuff.data.ui.el_instances);
                    var original_color = text.color;
                    if (selection + 1) {
                        var exists = internal_name_get(text.value);
                        if (exists && exists != data.instances[selection]) text.color = c_red;
                    }
                    ui_render_input(text, x, y);
                    text.color = original_color;
                };
                yy += element.height + spacing + eh / 2;
                Stuff.data.ui.el_inst_internal_name = element;
                ds_list_add(col_data.contents, element);
            
                for (var i = 0; i < array_length(data.properties); i++) {
                    var property = data.properties[i];
                    if (property.max_size == 1) {
                        switch (property.type) {
                            case DataTypes.INT:            // input
                                var char_limit = max(number_max_digits(property.range_min), number_max_digits(property.range_max));
                                if (property.range_min < 0 || property.range_max < 0) {
                                    char_limit++;
                                }
                                element = create_input(0, yy, property.name, ew, eh, uivc_data_set_property_input, property.default_int, string(property.range_min) + " - " + string(property.range_max), validate_int,
                                    property.range_min, property.range_max, char_limit, vx1n, vy1n, vx2n, vy2n, noone);
                                element.key = i;
                                var hh = element.height;
                                break;
                            case DataTypes.FLOAT:          // input
                                element = create_input(0, yy, property.name, ew, eh, uivc_data_set_property_input, property.default_real, string(property.range_min) + " - " + string(property.range_max), validate_double,
                                    property.range_min, property.range_max, 10 /* hard-coded, please do not touch */, vx1n, vy1n, vx2n, vy2n, noone);
                                element.key = i;
                                var hh = element.height;
                                break;
                            case DataTypes.STRING:         // input
                                element = create_input(0, yy, property.name, ew, eh * 2, uivc_data_set_property_input, "", "string", validate_string,
                                    0, 1, property.char_limit, vx1, vy1, vx2, vy2, noone);
                                element.valignment = fa_top;
                                element.key = i;
                                var hh = element.height + eh / 2;
                                break;
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
                                // the vx, vy coordinates are already located below the actual element, so the actual
                                // element should be in the same for it to appear correctly (it's weird, i know)
                                element = create_input_code(0, yy, "", ew, eh, 0, vy1, vx2, vy2, property.default_code, uivc_data_set_property_code, noone, i);
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
    }


}
