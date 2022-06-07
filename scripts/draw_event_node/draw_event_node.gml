function draw_event_node(node) {
    // color is set to black, font to FDefault, alignment to left/middle
    // if you change any of these in this script, you need to change them
    // back when youre done
    var x1 = node.x;
    var y1 = node.y;
    var x2 = x1;
    var y2 = y1;
    
    var entry_height = 4 * 16 + 32;
    var entry_offset = 16;
    var eh = 32;
    var tolerance = 4;
    var entry_yy = y1 + EVENT_NODE_CONTACT_HEIGHT;
    var rh = 0;
    var bezier_y = 0;
    
    var entrypoint_height = 64;
    var ext_node_padding = 12;
    
    var custom = noone;
    
    switch (node.type) {
        case EventNodeTypes.ENTRYPOINT:
            #region entrypoint
            x2 = x1 + EVENT_NODE_CONTACT_WIDTH;
            y2 = y1 + entrypoint_height;
            
            if (node_on_screen(view_current, x1, y1, x2, y2)) {
                var c = colour_mute(c_ev_init);
                draw_event_drag_handle(node, x1 + ext_node_padding, y1 - ext_node_padding, x2 - ext_node_padding, y1 + ext_node_padding, c);
                draw_roundrect_colour(x2 - ext_node_padding, y1 + ext_node_padding, x2 + ext_node_padding, y2 - ext_node_padding, c, c, false);
                draw_roundrect(x2 - ext_node_padding, y1 + ext_node_padding, x2 + ext_node_padding, y2 - ext_node_padding, true);
                draw_roundrect_colour(x1, y1, x2, y2, c_ev_init, c_ev_init, false);
                draw_roundrect(x1, y1, x2, y2, true);
                draw_event_node_title(node, c);
                
                draw_event_node_delete(x2, y1, node);
            }
            break;
            #endregion
        case EventNodeTypes.COMMENT:
            #region comment
            // cut down version of Text
            x2 = x1 + EVENT_NODE_CONTACT_WIDTH;
            y2 = y1 + max(24 + 32 + array_length(node.data) * entry_height + entry_offset, array_length(node.outbound) * EVENT_NODE_CONTACT_HEIGHT * 2 / 3);
            
            if (node_on_screen(view_current, x1, y1, x2, y2)) {
                var c = colour_mute(c_ev_comment);
                draw_event_drag_handle(node, x1 + ext_node_padding, y1 - ext_node_padding, x2 - ext_node_padding, y1 + ext_node_padding, c);
                draw_roundrect_colour(x1, y1, x2, y2, c_ev_comment, c_ev_comment, false);
                draw_roundrect(x1, y1, x2, y2, true);
                draw_event_node_title(node, c);
                
                draw_line(x1 + 16, entry_yy, x2 - 16, entry_yy);
                if (mouse_within_rectangle(x1 + tolerance, entry_yy + tolerance, x2 - tolerance, entry_yy + entry_height - tolerance)) {
                    draw_rectangle_colour(x1 + tolerance, entry_yy + tolerance, x2 - tolerance, entry_yy + entry_height - tolerance, c, c, c, c, false);
                    if (!dialog_exists()) {
                        if (Controller.release_left && !Stuff.event.canvas_active_node) {
                            dialog_create_event_node_input_string(node.data, 0, "Comment text?", node.data[0]);
                        }
                    }
                }
                
                draw_text_ext(x1 + 16, mean(entry_yy, entry_yy + entry_height), string(node.data[0]), -1, EVENT_NODE_CONTACT_WIDTH - 16);
            }
            
            draw_event_node_delete(x2, y1, node);
            break;
            #endregion
        case EventNodeTypes.TEXT:
        case EventNodeTypes.SHOW_SCROLLING_TEXT:
            #region text
            x2 = x1 + EVENT_NODE_CONTACT_WIDTH;
            // the above will be very painful for nodes with many data entries because loops so just assume
            // each entry won't have more than four lines
            y2 = y1 + max(24 + 32 + array_length(node.data) * entry_height + entry_offset, array_length(node.outbound) * EVENT_NODE_CONTACT_HEIGHT * 2 / 3);
            
            if (node_on_screen(view_current, x1, y1, x2, y2)) {
                var c = colour_mute(c_ev_basic);
                draw_event_drag_handle(node, x1 + ext_node_padding, y1 - ext_node_padding, x2 - ext_node_padding, y1 + ext_node_padding, c);
                draw_roundrect_colour(x2 - ext_node_padding, y1 + ext_node_padding, x2 + ext_node_padding, y2 - ext_node_padding, c, c, false);
                draw_roundrect(x2 - ext_node_padding, y1 + ext_node_padding, x2 + ext_node_padding, y2 - ext_node_padding, true);
                draw_roundrect_colour(x1, y1, x2, y2, c_ev_basic, c_ev_basic, false);
                draw_roundrect(x1, y1, x2, y2, true);
                // this is the inbound node, which we don't really care about other than displaying
                // it so that the user knows which nodes can be attached to other nodes
                draw_sprite(spr_event_outbound, 2, x1, y1 + 16);
                draw_event_node_title(node, c);
                draw_event_node_custom_info(x2 - 24, y1, node);
                draw_event_node_prefabinate(x2 - 48, y1, node);
                
                for (var i = 0; i < array_length(node.data); i++) {
                    draw_line(x1 + 16, entry_yy, x2 - 16, entry_yy);
                    if (mouse_within_rectangle(x1 + tolerance, entry_yy + tolerance, x2 - tolerance, entry_yy + entry_height - tolerance)) {
                        draw_rectangle_colour(x1 + tolerance, entry_yy + tolerance, x2 - tolerance, entry_yy + entry_height - tolerance, c, c, c, c, false);
                        if (!dialog_exists()) {
                            if (Controller.release_left && !Stuff.event.canvas_active_node) {
                                dialog_create_event_node_input_string(node.data, i, "Node data?", node.data[i]);
                            }
                        }
                    }
                    
                    draw_text_ext(x1 + 16, mean(entry_yy, entry_yy + entry_height), string(node.data[i]), -1, EVENT_NODE_CONTACT_WIDTH - 16);
                    var yy_center = mean(entry_yy, entry_yy + entry_height);
                    if (i > 0) {
                        // this works out nicely because the outbound node is going to be in the same place at index 0,
                        // and the delete icon is going to be everywhere except index 0
                        draw_event_node_text_remove(x2, yy_center, node, i);
                        draw_event_node_text_move(x2, yy_center - 24, node, i, -1, 0);
                    }
                    if (i < array_length(node.data) - 1) {
                        draw_event_node_text_move(x2, yy_center + 24, node, i, 1, 2);
                    }
                    
                    entry_yy = entry_yy + entry_height;
                }
                
                draw_event_node_delete(x2, y1, node);
                
                if (array_length(node.outbound) < 250) {
                    draw_event_node_text_add(mean(x1, x2), y2, node);
                }
            }
            break;
            #endregion
        case EventNodeTypes.CONDITIONAL:
            #region if-else if-else
            var size = array_length(node.custom_data[0]);
            rh = ((node.ui_things[0].GetHeight() div eh) * eh) + 16;
            eh = 32;
            x2 = x1 + EVENT_NODE_CONTACT_WIDTH;
            y2 = y1 + max(24 + 64 + (eh + rh + 1) * size + entry_offset, array_length(node.outbound) * EVENT_NODE_CONTACT_HEIGHT * 2 / 3);
            
            if (node_on_screen(view_current, x1, y1, x2, y2)) {
                var ncolor = c_ev_basic;
                var c = colour_mute(ncolor);
                draw_event_drag_handle(node, x1 + ext_node_padding, y1 - ext_node_padding, x2 - ext_node_padding, y1 + ext_node_padding, c);
                draw_roundrect_colour(x2 - ext_node_padding, y1 + ext_node_padding, x2 + ext_node_padding, y2 - ext_node_padding, c, c, false);
                draw_roundrect(x2 - ext_node_padding, y1 + ext_node_padding, x2 + ext_node_padding, y2 - ext_node_padding, true);
                draw_roundrect_colour(x1, y1, x2, y2, ncolor, ncolor, false);
                draw_roundrect(x1, y1, x2, y2, true);
                draw_sprite(spr_event_outbound, 2, x1, y1 + 16);
                draw_event_node_title(node, c);
                draw_event_node_custom_info(x2 - 24, y1, node);
                draw_event_node_prefabinate(x2 - 48, y1, node);
                draw_event_node_delete(x2, y1, node);
                
                for (var i = 0; i < size + 1; i++) {
                    draw_line(x1 + 16, entry_yy, x2 - 16, entry_yy);
                    
                    if (i == size) {
                        draw_text_ext(x1 + 16, mean(entry_yy, entry_yy + eh), "If all else fails, go here", -1, EVENT_NODE_CONTACT_WIDTH - 16);
                        break;
                    }
                    
                    var list_type = node.custom_data[0];
                    var list_index = node.custom_data[1];
                    var list_comparison = node.custom_data[2];
                    var list_value = node.custom_data[3];
                    var list_code = node.custom_data[4];
                    
                    // not sure why the value of the radio array is getting reset somewhere that i can't find,
                    // but you need to do this if you want it to not be changed
                    var radio = node.ui_things[i];
                    radio.value = list_type[i];
                    if (is_struct(radio)) {
                        radio.Render(x1, y1); 
                    } else {
                        radio.render(radio, x1, y1); 
                    }
                    
                    // this should be in an onvaluechange script but that's a huge hassle for something really minor
                    list_type[@ i] = radio.value;
                    
                    if (!dialog_exists()) {
                        if (mouse_within_rectangle(x1 + tolerance, entry_yy + tolerance + rh, x2 - tolerance, entry_yy + eh + rh - tolerance)) {
                            draw_rectangle_colour(x1 + tolerance, entry_yy + tolerance + rh, x2 - tolerance, entry_yy - tolerance + rh + eh, c, c, c, c, false);
                            if (Controller.release_left) {
                                switch (list_type[i]) {
                                    case ConditionBasicTypes.SWITCH: dialog_create_event_condition_switch(node, i); break;
                                    case ConditionBasicTypes.VARIABLE: dialog_create_event_condition_variable(node, i); break;
                                    case ConditionBasicTypes.SELF_SWITCH: dialog_create_condition_switch_self_data(node, i); break;
                                    case ConditionBasicTypes.SELF_VARIABLE: dialog_create_condition_variable_self_data(node, i); break;
                                    case ConditionBasicTypes.SCRIPT:
                                        emu_dialog_notice("The \"open\" command is temporarily unavailable. I might bring it back some other time if it's really needed. Sorry!");
                                        break;
                                }
                            }
                        }
                    }
                    
                    #region what gets drawn in the Data spot
                    var str;
                    switch (list_type[i]) {
                        case ConditionBasicTypes.SWITCH:
                            var index = list_index[i];
                            if (index > -1) {
                                var switch_data = Game.vars.switches[index];
                                str = "Switch " + switch_data.name + " is " + (list_value[i] ? "On" : "Off");
                            } else {
                                str = "Switch data not set";
                            }
                            break;
                        case ConditionBasicTypes.VARIABLE:
                            var index = list_index[i];
                            if (index > -1) {
                                var variable_data = Game.vars.variables[index];
                                str = "Variable " + variable_data.name + " " + Stuff.comparison_text[list_comparison[i]] + " " + string(list_value[i]);
                            } else {
                                str = "Variable data not set";
                            }
                            break;
                        case ConditionBasicTypes.SELF_SWITCH:
                            var index = list_index[i];
                            if (index > -1) {
                                str = "Self switch " + chr(ord("A") + index) + " is " + (list_value[i] ? "On" : "Off");
                            } else {
                                str = "Self switch data not set";
                            }
                            break;
                        case ConditionBasicTypes.SELF_VARIABLE:
                            var index = list_index[i];
                            if (index > -1) {
                                str = "Self variable " + chr(ord("A") + index) + " " + Stuff.comparison_text[list_comparison[i]] + " " + string(list_value[i]);
                            } else {
                                str = "Self variable data not set";
                            }
                            break;
                        case ConditionBasicTypes.SCRIPT:
                            str = "Code: " + string_comma(string_length(list_code[i])) + " bytes";
                            draw_rectangle_colour(x1 + tolerance, entry_yy + tolerance + rh, x2 - tolerance, entry_yy - tolerance + rh + eh, c, c, c, c, false);
                            break;
                    }
                    
                    draw_text_ext(x1 + 16, mean(entry_yy, entry_yy + eh) + rh, str, -1, EVENT_NODE_CONTACT_WIDTH - 16);
                    #endregion
                    
                    if (i > 0) {
                        draw_event_node_condition_remove(x2, entry_yy + 32, node, i);
                    }
                    
                    entry_yy = entry_yy + rh + eh;
                }
                
                var n = array_length(node.outbound);
                
                if (n < 250) {
                    draw_event_node_condition_add(mean(x1, x2), y2, node);
                }
            }
            break;
            #endregion
        case EventNodeTypes.SHOW_CHOICES:
            #region list of choices
            var size = array_length(node.data);
            eh = 64;
            x2 = x1 + EVENT_NODE_CONTACT_WIDTH;
            y2 = y1 + max(24 + 32 + eh * (size + 1) + entry_offset, array_length(node.outbound) * EVENT_NODE_CONTACT_HEIGHT * 2 / 3);
            
            if (node_on_screen(view_current, x1, y1, x2, y2)) {
                var ncolor = c_ev_basic;
                var c = colour_mute(ncolor);
                draw_event_drag_handle(node, x1 + ext_node_padding, y1 - ext_node_padding, x2 - ext_node_padding, y1 + ext_node_padding, c);
                draw_roundrect_colour(x2 - ext_node_padding, y1 + ext_node_padding, x2 + ext_node_padding, y2 - ext_node_padding, c, c, false);
                draw_roundrect(x2 - ext_node_padding, y1 + ext_node_padding, x2 + ext_node_padding, y2 - ext_node_padding, true);
                draw_roundrect_colour(x1, y1, x2, y2, ncolor, ncolor, false);
                draw_roundrect(x1, y1, x2, y2, true);
                draw_sprite(spr_event_outbound, 2, x1, y1 + 16);
                draw_event_node_title(node, c);
                draw_event_node_custom_info(x2 - 24, y1, node);
                draw_event_node_prefabinate(x2 - 48, y1, node);
                draw_event_node_delete(x2, y1, node);
                
                for (var i = 0; i < size + 1; i++) {
                    draw_line(x1 + 16, entry_yy, x2 - 16, entry_yy);
                    
                    if (i == size) {
                        draw_text_ext(x1 + 16, mean(entry_yy, entry_yy + eh), "Default (cancel button, etc)?", -1, EVENT_NODE_CONTACT_WIDTH - 16);
                        break;
                    }
                    
                    var text = node.data[i];
                    
                    if (mouse_within_rectangle(x1 + tolerance, entry_yy + tolerance, x2 - tolerance, entry_yy + eh - tolerance)) {
                        draw_rectangle_colour(x1 + tolerance, entry_yy + tolerance, x2 - tolerance, entry_yy + eh - tolerance, c, c, c, c, false);
                        if (!dialog_exists()) {
                            if (Controller.release_left && !Stuff.event.canvas_active_node) {
                                dialog_create_event_node_input_string(node.data, i, "Option text?", node.data[i]);
                            }
                        }
                    }
                    
                    draw_text_ext(x1 + 16, mean(entry_yy, entry_yy + eh), node.data[i], -1, EVENT_NODE_CONTACT_WIDTH - 16);
                    
                    if (i > 0) {
                        draw_event_node_choice_remove(x2, entry_yy + 16, node, i);
                    }
                    
                    entry_yy = entry_yy + eh;
                }
                
                var n = array_length(node.outbound);
                
                if (n < 16) {
                    draw_event_node_choice_add(mean(x1, x2), y2, node);
                }
            }
            break;
            #endregion
        case EventNodeTypes.CUSTOM:
        default:
            #region everything else
            custom = guid_get(node.custom_guid);
            x2 = x1 + EVENT_NODE_CONTACT_WIDTH;
            y2 = y1 + max(24 + 32 + entry_offset, array_length(node.outbound) * EVENT_NODE_CONTACT_HEIGHT * 2 / 3);
            var ncolor = (node.type == EventNodeTypes.CUSTOM) ? c_ev_custom : c_ev_basic;
            
            for (var i = 0; i < array_length(custom.types); i++) {
                switch (custom.types[i].type) {
                    case DataTypes.INT:
                    case DataTypes.FLOAT:
                    case DataTypes.BOOL:
                    case DataTypes.ENUM:
                    case DataTypes.DATA:
                    case DataTypes.AUDIO_BGM:
                    case DataTypes.AUDIO_SE:
                    case DataTypes.ANIMATION:
                    case DataTypes.CODE:
                    case DataTypes.COLOR:
                    case DataTypes.MESH:
                    case DataTypes.MESH_AUTOTILE:
                    case DataTypes.TILE:
                    case DataTypes.IMG_TEXTURE:
                    case DataTypes.IMG_BATTLER:
                    case DataTypes.IMG_OVERWORLD:
                    case DataTypes.IMG_PARTICLE:
                    case DataTypes.IMG_UI:
                    case DataTypes.IMG_ETC:
                    case DataTypes.IMG_SKYBOX:
                    case DataTypes.IMG_TILE_ANIMATION:
                    case DataTypes.ENTITY:
                    case DataTypes.MAP:
                    case DataTypes.EVENT:
                    case DataTypes.ASSET_FLAG:
                        y2 = y2 + 64;
                        break;
                    case DataTypes.STRING:
                        y2 = y2 + ((array_length(node.custom_data[i]) == 1) ? entry_height + 24 : 32);
                        break;
                }
            }
            
            if (node_on_screen(view_current, x1, y1, x2, y2)) {
                var c = colour_mute(ncolor);
                draw_event_drag_handle(node, x1 + ext_node_padding, y1 - ext_node_padding, x2 - ext_node_padding, y1 + ext_node_padding, c);
                draw_roundrect_colour(x2 - ext_node_padding, y1 + ext_node_padding, x2 + ext_node_padding, y2 - ext_node_padding, c, c, false);
                draw_roundrect(x2 - ext_node_padding, y1 + ext_node_padding, x2 + ext_node_padding, y2 - ext_node_padding, true);
                draw_roundrect_colour(x1, y1, x2, y2, ncolor, ncolor, false);
                draw_roundrect(x1, y1, x2, y2, true);
                draw_sprite(spr_event_outbound, 2, x1, y1 + 16);
                draw_event_node_title(node, c);
                draw_event_node_custom_info(x2 - 24, y1, node);
                draw_event_node_prefabinate(x2 - 48, y1, node);
                draw_event_node_delete(x2, y1, node);
                
                entry_yy = y1 + EVENT_NODE_CONTACT_HEIGHT;
                
                for (var i = 0; i < array_length(custom.types); i++) {
                    var custom_data_list = node.custom_data[i];
                    var type = custom.types[i];
                    
                    switch (type.type) {
                        case DataTypes.INT:
                        case DataTypes.FLOAT:
                        case DataTypes.BOOL:
                        case DataTypes.ENUM:
                        case DataTypes.DATA:
                        case DataTypes.AUDIO_BGM:
                        case DataTypes.AUDIO_SE:
                        case DataTypes.ANIMATION:
                        case DataTypes.CODE:
                        case DataTypes.ASSET_FLAG:
                        case DataTypes.COLOR:
                        case DataTypes.MESH:
                        case DataTypes.MESH_AUTOTILE:
                        case DataTypes.TILE:
                        case DataTypes.IMG_TEXTURE:
                        case DataTypes.IMG_BATTLER:
                        case DataTypes.IMG_OVERWORLD:
                        case DataTypes.IMG_PARTICLE:
                        case DataTypes.IMG_UI:
                        case DataTypes.IMG_ETC:
                        case DataTypes.IMG_SKYBOX:
                        case DataTypes.IMG_TILE_ANIMATION:
                        case DataTypes.ENTITY:
                        case DataTypes.MAP:
                        case DataTypes.EVENT:
                            eh = 64;
                            break;
                        case DataTypes.STRING:
                            eh = (array_length(custom_data_list) == 1) ? entry_height + 24 : 32;
                            break;
                    }
                    
                    draw_line(x1 + 16, entry_yy, x2 - 16, entry_yy);
                    if (!dialog_exists()) {
                        if (mouse_within_rectangle(x1 + tolerance, entry_yy + tolerance, x2 - tolerance, entry_yy + eh - tolerance)) {
                            draw_rectangle_colour(x1 + tolerance, entry_yy + tolerance, x2 - tolerance, entry_yy + eh - tolerance, c, c, c, c, false);
                            if (Controller.release_left && !Stuff.event.canvas_active_node) {
                                var attainment = type.data_attainment;
                                if (attainment == null) {
                                    switch (type.type) {
                                        case DataTypes.INT:
                                            dialog_create_event_node_input_real(custom_data_list, 0, type.name + "?", custom_data_list[0], validate_int, -0x1000000, 0xffffff);
                                            break;
                                        case DataTypes.FLOAT:
                                            dialog_create_event_node_input_real(custom_data_list, 0, type.name + "?", custom_data_list[0], validate_double, -0x1000000, 0xffffff);
                                            break;
                                        case DataTypes.STRING:
                                            dialog_create_event_node_input_string(custom_data_list, 0, type.name + "?", custom_data_list[0]);
                                            break;
                                        case DataTypes.BOOL:
                                            custom_data_list[@ 0] = !custom_data_list[0];
                                            break;
                                        case DataTypes.ENUM:
                                        case DataTypes.DATA:
                                            if (guid_get(type.type_guid)) {
                                                dialog_create_event_node_custom_data(noone, node, i, 0);
                                            }
                                            break;
                                        case DataTypes.AUDIO_BGM:
                                            dialog_create_event_node_audio_bgm(noone, node, i, 0);
                                            break;
                                        case DataTypes.AUDIO_SE:
                                            dialog_create_event_node_audio_se(noone, node, i, 0);
                                            break;
                                        case DataTypes.ANIMATION:
                                            dialog_create_event_node_animation(noone, node, i, 0);
                                            break;
                                        case DataTypes.CODE:
                                            emu_dialog_notice("The \"open\" command is temporarily unavailable. I might bring it back some other time if it's really needed. Sorry!");
                                            break;
                                        case DataTypes.COLOR:
                                            var picker = dialog_create_color_picker_options(node, custom_data_list[0], function(picker) {
                                                picker.root.node.custom_data[@ picker.root.index][@ 0] = picker.value;
                                            });
                                            picker.node = node;
                                            picker.index = i;
                                            break;
                                        case DataTypes.MESH:
                                            dialog_create_event_node_meshes(noone, node, i, 0);
                                            break;
                                        case DataTypes.MESH_AUTOTILE:
                                            not_yet_implemented();
                                            break;
                                        case DataTypes.IMG_TEXTURE:
                                            dialog_create_event_node_img_tileset(noone, node, i, 0);
                                            break;
                                        case DataTypes.IMG_BATTLER:
                                            dialog_create_event_node_img_battlers(noone, node, i, 0);
                                            break;
                                        case DataTypes.IMG_OVERWORLD:
                                            dialog_create_event_node_img_overworlds(noone, node, i, 0);
                                            break;
                                        case DataTypes.IMG_PARTICLE:
                                            dialog_create_event_node_img_particles(noone, node, i, 0);
                                            break;
                                        case DataTypes.IMG_UI:
                                            dialog_create_event_node_img_ui(noone, node, i, 0);
                                            break;
                                        case DataTypes.IMG_ETC:
                                            dialog_create_event_node_img_etc(noone, node, i, 0);
                                            break;
                                        case DataTypes.IMG_SKYBOX:
                                            dialog_create_event_node_img_skybox(noone, node, i, 0);
                                            break;
                                        case DataTypes.IMG_TILE_ANIMATION:
                                            show_error("you can do this now, you know", true);
                                            break;
                                        case DataTypes.TILE:
                                            not_yet_implemented();
                                            break;
                                        case DataTypes.EVENT:
                                            dialog_create_event_get_event(noone, node, i, 0);
                                            break;
                                        case DataTypes.ENTITY:
                                            dialog_create_refid_list(node, custom_data_list[0], function(element) {
                                                var node = element.root.node;
                                                var index = element.root.index;
                                                var type = element.root.el_type.value;
                                                
                                                switch (type) {
                                                    case 0:
                                                        node.custom_data[@ index][@ 0] = REFID_PLAYER;
                                                        break;
                                                    case 1:
                                                        node.custom_data[@ index][@ 0] = REFID_SELF;
                                                        break;
                                                    case 2:
                                                        var selection = ui_list_selection(element.root.el_list);
                                                        if (selection + 1) {
                                                            node.custom_data[@ index][@ 0] = element.root.el_list.entries[| selection].REFID;
                                                        } else {
                                                            node.custom_data[@ index][@ 0] = REFID_SELF;
                                                        }
                                                        break;
                                                }
                                                
                                                dmu_dialog_commit(element);
                                            }, node, i);
                                            break;
                                        case DataTypes.MAP:
                                            show_error("okay you actually need to implement this soon, please", true);
                                            break;
                                        case DataTypes.ASSET_FLAG:
                                            emu_dialog_notice("please make an Asset Flag button at some point");
                                            break;
                                    }
                                } else {
                                    attainment(noone, node, i);
                                }
                            }
                        }
                    }
                    
                    var message = type.name + " ";
                    
                    if (array_length(custom_data_list) == 1) {
                        var output_script = type.data_output;
                        var output_string = "";
                        
                        switch (type.type) {
                            case DataTypes.INT:
                                message = message + "(int): ";
                                output_string = string(custom_data_list[0]);
                                break;
                            case DataTypes.FLOAT:
                                message = message + "(float): ";
                                output_string = string(custom_data_list[0]);
                                break;
                            case DataTypes.STRING:
                                message = message + "(string): ";
                                output_string = "";
                                break;
                            case DataTypes.BOOL:
                                message = message + "(boolean): ";
                                output_string = (custom_data_list[0] ? "True" : "False");
                                break;
                            case DataTypes.ENUM:
                            case DataTypes.DATA:
                                var datadata = guid_get(type.type_guid);
                                var setdata = guid_get(custom_data_list[0]);
                            
                                if (!datadata) {
                                    message = message + "(<no type set>)";
                                } else if (!setdata) {
                                    message = message + "(" + datadata.name + "): ";
                                    output_string = "<null>";
                                } else {
                                    message = message + "(" + datadata.name+"): ";
                                    output_string = setdata.name;
                                }
                                break;
                            case DataTypes.CODE:
                                message = message + "(code): ";
                                output_string = "...";
                                break;
                            case DataTypes.COLOR:
                                message = message + "(color): ";
                                var color_value = custom_data_list[0];
                                output_string = "#" + string_hex(color_value, 6);
                                draw_rectangle_colour(x2 - 64, entry_yy + 8, x2 - 32, entry_yy + eh - 8, color_value, color_value, color_value, color_value, false);
                                draw_rectangle_colour(x2 - 64, entry_yy + 8, x2 - 32, entry_yy + eh - 8, c_black, c_black, c_black, c_black, true);
                                break;
                            case DataTypes.MESH:
                                var setdata = guid_get(custom_data_list[0]);
                                message = message + "(mesh): ";
                                output_string = setdata ? setdata.name : "<null>";
                                break;
                            case DataTypes.MESH_AUTOTILE:
                                var setdata = guid_get(custom_data_list[0]);
                                message = message + "(mesh autotile): ";
                                output_string = setdata ? setdata.name : "<null>";
                                break;
                            case DataTypes.TILE:
                                message = message + "(tile): ";
                                output_string = "TBD";
                                break;
                            case DataTypes.IMG_TEXTURE:
                                var setdata = guid_get(custom_data_list[0]);
                                message = message + "(tileset): ";
                                output_string = setdata ? setdata.name : "<null>";
                                break;
                            case DataTypes.IMG_BATTLER:
                                var setdata = guid_get(custom_data_list[0]);
                                message = message + "(battler): ";
                                output_string = setdata ? setdata.name : "<null>";
                                break;
                            case DataTypes.IMG_OVERWORLD:
                                var setdata = guid_get(custom_data_list[0]);
                                message = message + "(OW): ";
                                output_string = setdata ? setdata.name : "<null>";
                                break;
                            case DataTypes.IMG_PARTICLE:
                                var setdata = guid_get(custom_data_list[0]);
                                message = message + "(particle): ";
                                output_string = setdata ? setdata.name : "<null>";
                                break;
                            case DataTypes.IMG_UI:
                                var setdata = guid_get(custom_data_list[0]);
                                message = message + "(ui): ";
                                output_string = setdata ? setdata.name : "<null>";
                                break;
                            case DataTypes.IMG_ETC:
                                var setdata = guid_get(custom_data_list[0]);
                                message = message + "(misc): ";
                                output_string = setdata ? setdata.name : "<null>";
                                break;
                            case DataTypes.IMG_SKYBOX:
                                var setdata = guid_get(custom_data_list[0]);
                                message = message + "(sky): ";
                                output_string = setdata ? setdata.name : "<null>";
                                break;
                            case DataTypes.IMG_TILE_ANIMATION:
                                var setdata = guid_get(custom_data_list[0]);
                                message = message + "(tile animation): ";
                                output_string = setdata ? setdata.name : "<null>";
                                break;
                            case DataTypes.AUDIO_BGM:
                                var setdata = guid_get(custom_data_list[0]);
                                message = message + "(bgm): ";
                                output_string = setdata ? setdata.name : "<null>";
                                break;
                            case DataTypes.AUDIO_SE:
                                var setdata = guid_get(custom_data_list[0]);
                                message = message + "(se): ";
                                output_string = setdata ? setdata.name : "<null>";
                                break;
                            case DataTypes.ANIMATION:
                                var setdata = guid_get(custom_data_list[0]);
                                message = message + "(animation): ";
                                output_string = setdata ? setdata.name : "<null>";
                                break;
                            case DataTypes.EVENT:
                                var setdata = guid_get(custom_data_list[0]);
                                message = message + "(event): ";
                                output_string = setdata ? setdata.name : "<null>";
                                break;
                            case DataTypes.ENTITY:
                                var refid = custom_data_list[0];
                                message = message + "(entity): ";
                                switch (refid) {
                                    case REFID_PLAYER:
                                        output_string = "<player>";
                                        break;
                                    case REFID_SELF:
                                        output_string = "<self>";
                                        break;
                                    default:
                                        var setdata = refid_get(refid);
                                        output_string = (setdata ? setdata.name : "<not loaded>") + ":" + string(refid);
                                        break;
                                }
                                break;
                            case DataTypes.MAP:
                                var setdata = guid_get(custom_data_list[0]);
                                message = message + "(map): ";
                                output_string = setdata ? setdata.name : "<null>";
                                break;
                            case DataTypes.ASSET_FLAG:
                                message = message + "(flags): ";
                                output_string = string(custom_data_list[0]);
                                break;
                        }
                        
                        message += "\n" + ((output_script == null) ? output_string : output_script(node, i));
                    } else {
                        message += "\n" + ": multiple values (" + string(array_length(custom_data_list)) + ")";
                    }
                    
                    if (type.type == DataTypes.STRING && array_length(custom_data_list) == 1) {
                        draw_text(x1 + 16, entry_yy + 12, string(message));
                        draw_text_ext(x1 + 16, mean(entry_yy + 12, entry_yy + eh), string(custom_data_list[0]), -1, EVENT_NODE_CONTACT_WIDTH - 16);
                    } else {
                        draw_text_ext(x1 + 16, mean(entry_yy, entry_yy + eh), string(message), -1, EVENT_NODE_CONTACT_WIDTH - 16);
                    }
                    
                    entry_yy = entry_yy + eh;
                }
            }
            break;
            #endregion
    }
    
    entry_yy = y1 + EVENT_NODE_CONTACT_HEIGHT;
    var node_spr_width = sprite_get_width(spr_event_outbound);
    var node_spr_height = sprite_get_height(spr_event_outbound);
    
    switch (node.type) {
        case EventNodeTypes.COMMENT:
            // no outbound node allowed
            break;
        case EventNodeTypes.TEXT:
        case EventNodeTypes.SHOW_SCROLLING_TEXT:
        case EventNodeTypes.ENTRYPOINT:
            #region single-output nodes
            entry_yy = y1 + EVENT_NODE_CONTACT_HEIGHT;
            var outbound = guid_get(node.outbound[0]);
            
            var by = entry_yy;
            
            if (!outbound) {
                draw_event_node_outbound(x2 + ext_node_padding, by, node, 0, true);
            } else {
                var bnx = outbound.x;
                var bny = outbound.y + 16;
                
                draw_event_node_outbound(x2 + ext_node_padding, by, node, 0);
                draw_sprite(spr_event_dot, 0, x2 + ext_node_padding, by);
                // node is not being dragged
                if (Stuff.event.canvas_active_node != node || Stuff.event.canvas_active_node_index != 0) {
                    if (bnx > x2 + ext_node_padding && outbound.event == node.event) {
                        draw_bezier(x2 + ext_node_padding, by, bnx - 8, bny);
                    } else {
                        draw_event_ghost(x2 + ext_node_padding, by, x2 + 64, by, node, outbound);
                    }
                }
            }
            // the node is currently being dragged
            if (Stuff.event.canvas_active_node == node) {
                bezier_y = by;
            }
            #endregion
            break;
        case EventNodeTypes.CONDITIONAL:
            #region Conditional
            // it'd be real nice if this could just be in the default case, but
            // the outbound nodes are spaced slightly differently for this so it
            // wouldn't really work
            var by = entry_yy + entry_height - ext_node_padding;
            var n = array_length(node.outbound);
            
            for (var i = 0; i < n; i++) {
                var outbound = guid_get(node.outbound[i]);
                if (!outbound) {
                    draw_event_node_outbound(x2 + ext_node_padding, by, node, i, true);
                } else {
                    var bx2 = outbound.x;
                    var by2 = outbound.y + 16;
                    
                    draw_event_node_outbound(x2 + ext_node_padding, by, node, i);
                    draw_sprite(spr_event_dot, 0, x2 + ext_node_padding, by);
                    // the node is not currently being dragged
                    if (Stuff.event.canvas_active_node != node || Stuff.event.canvas_active_node_index != i) {
                        if (bx2 > x2 && outbound.event == node.event) {
                            draw_bezier(x2 + ext_node_padding, by, bx2 - 8, by2);
                        } else {
                            draw_event_ghost(x2 + ext_node_padding, by, x2 + 64, by, node, outbound);
                        }
                    }
                }
                // the node is currently being dragged
                if (Stuff.event.canvas_active_node == node && Stuff.event.canvas_active_node_index == i) {
                    bezier_y = by;
                }
                
                by += eh + ((i < n - 2) ? rh : (rh + eh) / 2);
            }
            break;
            #endregion
        case EventNodeTypes.SHOW_CHOICES:
            #region Choices
            var n = array_length(node.outbound);
            
            for (var i = 0; i < n; i++) {
                var outbound = guid_get(node.outbound[i]);
                var by = entry_yy + eh / 2;
                
                if (!outbound) {
                    draw_event_node_outbound(x2 + ext_node_padding, by, node, i, true);
                } else {
                    var bx2 = outbound.x;
                    var by2 = outbound.y + ext_node_padding;
                    
                    draw_event_node_outbound(x2 + ext_node_padding, by, node, i);
                    draw_sprite(spr_event_dot, 0, x2 + ext_node_padding, by);
                    // node is NOT currently being dragged
                    if (Stuff.event.canvas_active_node != node || Stuff.event.canvas_active_node_index != i) {
                        if (bx2 > x2 && outbound.event == node.event) {
                            draw_bezier(x2 + ext_node_padding, by, bx2 - 8, by2);
                        } else {
                            draw_event_ghost(x2 + ext_node_padding, by, x2 + 64, by, node, outbound);
                        }
                    }
                }
                // the node IS currently being dragged
                if (Stuff.event.canvas_active_node == node && Stuff.event.canvas_active_node_index == i) {
                    bezier_y = entry_yy + eh / 2;
                }
                
                entry_yy = entry_yy + eh;
            }
            break;
            #endregion
        default:
            #region other node types (usually)
            entry_yy = y1 + EVENT_NODE_CONTACT_HEIGHT;
            
            for (var i = 0; i < array_length(node.outbound); i++) {
                var outbound = guid_get(node.outbound[i]);
                var by = entry_yy + 32 * i;
                
                if (!outbound) {
                    draw_event_node_outbound(x2 + ext_node_padding, by, node, i, true);
                } else {
                    var bnx = outbound.x;
                    var bny = outbound.y + 16;
                    
                    draw_event_node_outbound(x2 + ext_node_padding, by, node, i);
                    draw_sprite(spr_event_dot, 0, x2 + ext_node_padding, by);
                    // node is not being dragged
                    if (Stuff.event.canvas_active_node != node || Stuff.event.canvas_active_node_index != i) {
                        if (bnx > x2 + ext_node_padding && outbound.event == node.event) {
                            draw_bezier(x2 + ext_node_padding, by, bnx - 8, bny);
                        } else {
                            draw_event_ghost(x2 + ext_node_padding, by, x2 + 64, by, node, outbound);
                        }
                    }
                }
                // the node is currently being dragged
                if (Stuff.event.canvas_active_node == node && Stuff.event.canvas_active_node_index == i) {
                    bezier_y = by;
                }
            }
            break;
            #endregion
    }
    
    if (Stuff.event.canvas_active_node == node) {
        var cx = camera_get_view_x(camera);
        var cy = camera_get_view_y(camera);
        draw_bezier(x2 + ext_node_padding, bezier_y, mouse_x + cx, mouse_y + cy);
        if (!dialog_exists()) {
            if (Controller.release_left) {
                Controller.release_left = false;
                // if the mouse is contacting another entrypoint, connect it
                var contacted_node = undefined;
                for (var i = 0; i < array_length(Stuff.event.active.nodes); i++) {
                    var test = Stuff.event.active.nodes[i];
                    if (mouse_within_rectangle(test.x, test.y, test.x + EVENT_NODE_CONTACT_WIDTH, test.y + EVENT_NODE_CONTACT_HEIGHT)) {
                        contacted_node = test;
                        break;
                    }
                }
                
                if (contacted_node) {
                    node.Connect(contacted_node, Stuff.event.canvas_active_node_index);
                }
                Stuff.event.request_cancel_active_node = true;
            }
        }
    }
}