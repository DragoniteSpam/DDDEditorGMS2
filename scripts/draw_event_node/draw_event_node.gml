/// @param DataEventNode

// color is set to black, font to FDefault12, alignment to left/middle
// if you change any of these in this script, you need to change them
// back when youre done

var node = argument0;

var x1 = node.x;
var y1 = node.y;
var x2 = x1;
var y2 = y1;

var entry_height = 4 * 16 + 32;
var entry_offset = 16;
var eh = 0;
var tolerance = 4;
var entry_yy = y1 + EVENT_NODE_CONTACT_HEIGHT;

var custom = noone;

switch (node.type) {
    case EventNodeTypes.ENTRYPOINT:
    #region entrypoint
        x2 = x1 + EVENT_NODE_CONTACT_WIDTH;
		y2 = y1 + max(16 + string_height(string(node.name)) + entry_offset, ds_list_size(node.outbound) * EVENT_NODE_CONTACT_HEIGHT * 2 / 3);
        
        if (rectangle_within_view(view_current, x1, y1, x2, y2)) {
            var c = colour_mute(c_ev_init);
            draw_event_drag_handle(node, x1+16, y1-16, x2-16, y1+16, c);
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
		y2 = y1 + max(24 + 32 + ds_list_size(node.data) * entry_height + entry_offset, ds_list_size(node.outbound) * EVENT_NODE_CONTACT_HEIGHT * 2 / 3);
        
        if (rectangle_within_view(view_current, x1, y1, x2, y2)) {
            var c = colour_mute(c_ev_comment);
            draw_event_drag_handle(node, x1 + 16, y1 - 16, x2 - 16, y1 + 16, c);
            draw_roundrect_colour(x1, y1, x2, y2, c_ev_comment, c_ev_comment, false);
            draw_roundrect(x1, y1, x2, y2, true);
            draw_event_node_title(node, c);
            
            draw_line(x1 + 16, entry_yy, x2 - 16, entry_yy);
            if (mouse_within_rectangle_adjusted(x1 + tolerance, entry_yy + tolerance, x2 - tolerance, entry_yy + entry_height - tolerance)) {
                draw_rectangle_colour(x1 + tolerance, entry_yy + tolerance, x2 - tolerance, entry_yy + entry_height - tolerance, c, c, c, c, false);
                if (!dialog_exists()) {
                    if (Controller.release_left) {
                        node.data[| 0] = get_string("Comment contents?", node.data[| 0]);
                    }
                }
            }
                
            draw_text_ext(x1 + 16, mean(entry_yy, entry_yy + entry_height), string(node.data[| 0]), -1, EVENT_NODE_CONTACT_WIDTH - 16);
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
		y2 = y1 + max(24 + 32 + ds_list_size(node.data) * entry_height + entry_offset, ds_list_size(node.outbound) * EVENT_NODE_CONTACT_HEIGHT * 2 / 3);
        
        if (rectangle_within_view(view_current, x1, y1, x2, y2)) {
            var c = colour_mute(c_ev_basic);
            draw_event_drag_handle(node, x1 + 16, y1 - 16, x2 - 16, y1 + 16, c);
            draw_roundrect_colour(x1, y1, x2, y2, c_ev_basic, c_ev_basic, false);
            draw_roundrect(x1, y1, x2, y2, true);
            // this is the inbound node, which we don't really care about other than displaying
            // it so that the user knows which nodes can be attached to other nodes
            draw_sprite(spr_event_outbound, 2, x1, y1 + 16);
            draw_event_node_title(node, c);
            draw_event_node_custom_info(x2 - 24, y1, node);
			draw_event_node_prefabinate(x2 - 48, y1, node);
            
            for (var i = 0; i < ds_list_size(node.data); i++) {
                draw_line(x1 + 16, entry_yy, x2 - 16, entry_yy);
                if (mouse_within_rectangle_adjusted(x1 + tolerance, entry_yy + tolerance, x2 - tolerance, entry_yy + entry_height - tolerance)) {
                    draw_rectangle_colour(x1 + tolerance, entry_yy + tolerance, x2 - tolerance, entry_yy + entry_height - tolerance, c, c, c, c, false);
                    if (!dialog_exists()) {
                        if (Controller.release_left) {
                            node.data[| i] = get_string("Data in this node?", node.data[| i]);
                        }
                    }
                }
                
                draw_text_ext(x1 + 16, mean(entry_yy, entry_yy + entry_height), string(node.data[| i]), -1, EVENT_NODE_CONTACT_WIDTH - 16);
                var yy_center = mean(entry_yy, entry_yy + entry_height);
                if (i > 0) {
                    // this works out nicely because the outbound node is going to be in the same place at index 0,
                    // and the delete icon is going to be everywhere except index 0
                    draw_event_node_text_remove(x2, yy_center, node, i);
                    draw_event_node_text_move(x2, yy_center - 24, node, i, -1, 0);
                }
                if (i < ds_list_size(node.data) - 1) {
                    draw_event_node_text_move(x2, yy_center + 24, node, i, 1, 2);
                }
                
                entry_yy = entry_yy + entry_height;
            }
            
            draw_event_node_delete(x2, y1, node);
            
            if (ds_list_size(node.outbound) < 250) {
                draw_event_node_text_add(mean(x1, x2), y2, node);
            }
        }
        break;
    #endregion
    case EventNodeTypes.CONDITIONAL:
    #region if-else if-else
        var size = ds_list_size(node.custom_data[| 0]);
        eh = 32;
        var rh = ((ui_get_radio_array_height(node.ui_things[| 0]) div eh) * eh) + 16;
        x2 = x1 + EVENT_NODE_CONTACT_WIDTH;
		y2 = y1 + max(24 + 32 + (eh + rh + 1) * size + entry_offset, ds_list_size(node.outbound) * EVENT_NODE_CONTACT_HEIGHT * 2 / 3);
        
        if (rectangle_within_view(view_current, x1, y1, x2, y2)) {
            var ncolor = c_ev_basic;
            var c = colour_mute(ncolor);
            draw_event_drag_handle(node, x1 + 16, y1 - 16, x2 - 16, y1 + 16, c);
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
                
                var list_type = node.custom_data[| 0];
                var list_index = node.custom_data[| 1];
                var list_comparison = node.custom_data[| 2];
                var list_value = node.custom_data[| 3];
                var list_code = node.custom_data[| 4];
                
                // not sure why the value of the radio array is getting reset somewhere that i can't find,
                // but you need to do this if you want it to not be changed
                var radio = node.ui_things[| i];
                radio.value = list_type[| i];
                script_execute(radio.render, radio, x1, y1);
                
                // this should be in an onvaluechange script but that's a huge hassle for something really minor
                list_type[| i] = radio.value;
                
                if (!dialog_exists()) {
                    if (mouse_within_rectangle_adjusted(x1 + tolerance, entry_yy + tolerance + rh, x2 - tolerance, entry_yy + eh + rh - tolerance)) {
                        draw_rectangle_colour(x1 + tolerance, entry_yy + tolerance + rh, x2 - tolerance, entry_yy - tolerance + rh + eh, c, c, c, c, false);
                        if (Controller.release_left) {
                            switch (list_type[| i]) {
                                case ConditionBasicTypes.SWITCH: dialog_create_event_condition_switch(node, i); break;
                                case ConditionBasicTypes.VARIABLE: dialog_create_event_condition_variable(node, i); break;
                                case ConditionBasicTypes.SELF_SWITCH: dialog_create_condition_switch_self_data(node, i); break;
                                case ConditionBasicTypes.SELF_VARIABLE: dialog_create_condition_variable_self_data(node, i); break;
                                case ConditionBasicTypes.SCRIPT:
                                    if (node.editor_handle == noone) {
                                        var location = get_temp_code_path(node);
                                        var buffer = buffer_create(1, buffer_grow, 1);
                                        buffer_write(buffer, buffer_text, list_code[| i]);
                                        buffer_save_ext(buffer, location, 0, buffer_tell(buffer));
                                        buffer_delete(buffer);
                                    
                                        node.editor_handle = ds_stuff_open_local(location);
                                        node.editor_handle_index = i;
                                    }
                                    break;
                            }
                        }
                    }
                }
                
                #region what gets drawn in the Data spot
                switch (list_type[| i]) {
                    case ConditionBasicTypes.SWITCH:
                        var index = list_index[| i];
                        if (index > -1) {
                            var switch_data = Stuff.switches[| index];
                            var str = "Switch " + switch_data[0] + " is " + Stuff.on_off[list_value[| i]];
                        } else {
                            var str = "Switch data not set";
                        }
                        break;
                    case ConditionBasicTypes.VARIABLE:
                        var index = list_index[| i];
                        if (index > -1) {
                            var variable_data = Stuff.variables[| index];
                            var str = "Variable " + variable_data[0] + " " + Stuff.comparison_text[list_comparison[| i]] + " " + string(list_value[| i]);
                        } else {
                            var str = "Variable data not set";
                        }
                        break;
                    case ConditionBasicTypes.SELF_SWITCH:
                        var index = list_index[| i];
                        if (index > -1) {
                            var str = "Self switch " + chr(ord("A") + index) + " is " + Stuff.on_off[list_value[| i]];
                        } else {
                            var str = "Self switch data not set";
                        }
                        break;
                    case ConditionBasicTypes.SELF_VARIABLE:
                        var index = list_index[| i];
                        if (index > -1) {
                            var str = "Self variable " + chr(ord("A") + index) + " " + Stuff.comparison_text[list_comparison[| i]] + " " + string(list_value[| i]);
                        } else {
                            var str = "Self variable data not set";
                        }
                        break;
                    case ConditionBasicTypes.SCRIPT:
                        var str = "Code: " + string_comma(string_length(list_code[| i])) + " bytes";
                        
                        if (node.editor_handle_index == i) {
                            draw_rectangle_colour(x1 + tolerance, entry_yy + tolerance + rh, x2 - tolerance, entry_yy - tolerance + rh + eh, c, c, c, c, false);
                        }
                        break;
                }
                
                draw_text_ext(x1 + 16, mean(entry_yy, entry_yy + eh) + rh, str, -1, EVENT_NODE_CONTACT_WIDTH - 16);
                #endregion
                
                var entry_yy_previous = entry_yy;
                entry_yy = entry_yy + rh + eh;
                
                if (i > 0) {
                    draw_event_node_condition_remove(x2, mean(entry_yy_previous, entry_yy) + 16, node, i);
                }
            }
            
            if (node.editor_handle) {
                list_code[| node.editor_handle_index] = uios_code_text(node, list_code[| node.editor_handle_index]);
                if (ds_stuff_process_complete(node.editor_handle)) {
                    node.editor_handle = noone;
                    node.editor_handle_index = -1;
                    file_delete(get_temp_code_path(node));
                }
            }
            
            var n = ds_list_size(node.outbound);
            
            if (n < 250) {
                draw_event_node_condition_add(mean(x1, x2), y2, node);
            }
        }
        break;
    #endregion
    case EventNodeTypes.SHOW_CHOICES:
    #region list of choices
        var size = ds_list_size(node.data);
        eh = 64;
        x2 = x1 + EVENT_NODE_CONTACT_WIDTH;
		y2 = y1 + max(24 + 32 + eh * (size + 1) + entry_offset, ds_list_size(node.outbound) * EVENT_NODE_CONTACT_HEIGHT * 2 / 3);
        
        if (rectangle_within_view(view_current, x1, y1, x2, y2)) {
            var ncolor = c_ev_basic;
            var c = colour_mute(ncolor);
            draw_event_drag_handle(node, x1 + 16, y1 - 16, x2 - 16, y1 + 16, c);
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
                
                var text = node.data[| i];
                
                if (mouse_within_rectangle_adjusted(x1 + tolerance, entry_yy + tolerance, x2 - tolerance, entry_yy + eh - tolerance)) {
                    draw_rectangle_colour(x1 + tolerance, entry_yy + tolerance, x2 - tolerance, entry_yy + eh - tolerance, c, c, c, c, false);
                    if (!dialog_exists()) {
                        if (Controller.release_left) {
                            node.data[| i] = get_string("Option text?", node.data[| i]);
                        }
                    }
                }
                
                draw_text_ext(x1 + 16, mean(entry_yy, entry_yy + eh), node.data[| i], -1, EVENT_NODE_CONTACT_WIDTH - 16);
                
                if (i > 0) {
                    draw_event_node_choice_remove(x2, entry_yy + 16, node, i);
                }
                
                entry_yy = entry_yy + eh;
            }
            
            var n = ds_list_size(node.outbound);
            
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
        y2 = y1 + max(24 + 32 + entry_offset, ds_list_size(node.outbound) * EVENT_NODE_CONTACT_HEIGHT * 2 / 3);
        var ncolor = (node.type == EventNodeTypes.CUSTOM) ? c_ev_custom : c_ev_basic;
        
        for (var i = 0; i < ds_list_size(custom.types); i++) {
            var custom_data_list = node.custom_data[| i];
            var type = custom.types[| i];
            switch (type[1]) {
                case DataTypes.INT:
                case DataTypes.FLOAT:
                case DataTypes.BOOL:
                case DataTypes.ENUM:
                case DataTypes.DATA:
                case DataTypes.AUDIO_BGM:
                case DataTypes.AUDIO_SE:
                case DataTypes.ANIMATION:
                // @todo data types
                case DataTypes.CODE:
                case DataTypes.COLOR:
                case DataTypes.MESH:
                case DataTypes.TILE:
                case DataTypes.TILESET:
                case DataTypes.AUTOTILE:
                case DataTypes.ENTITY:
                case DataTypes.MAP:
                    y2 = y2 + 32;
                    break;
                case DataTypes.STRING:
                    y2 = y2 + ((ds_list_size(custom_data_list) == 1) ? entry_height + 24 : 32);
                    break;
            }
        }
        
        if (rectangle_within_view(view_current, x1, y1, x2, y2)) {
            var c = colour_mute(ncolor);
            draw_event_drag_handle(node, x1 + 16, y1 - 16, x2 - 16, y1 + 16, c);
            draw_roundrect_colour(x1, y1, x2, y2, ncolor, ncolor, false);
            draw_roundrect(x1, y1, x2, y2, true);
            draw_sprite(spr_event_outbound, 2, x1, y1 + 16);
            draw_event_node_title(node, c);
            draw_event_node_custom_info(x2 - 24, y1, node);
			draw_event_node_prefabinate(x2 - 48, y1, node);
            draw_event_node_delete(x2, y1, node);
            
            var entry_yy = y1 + EVENT_NODE_CONTACT_HEIGHT;
            
            for (var i = 0; i < ds_list_size(custom.types); i++) {
                var custom_data_list = node.custom_data[| i];
                var type = custom.types[| i];
                
                switch (type[1]) {
                    case DataTypes.INT:
                    case DataTypes.FLOAT:
                    case DataTypes.BOOL:
                    case DataTypes.ENUM:
                    case DataTypes.DATA:
                    case DataTypes.AUDIO_BGM:
                    case DataTypes.AUDIO_SE:
                    case DataTypes.ANIMATION:
                    case DataTypes.CODE:
                        eh = 32;
                        break;
                    case DataTypes.STRING:
                        eh = (ds_list_size(custom_data_list) == 1) ? entry_height + 24 : 32;
                        break;
                    case DataTypes.COLOR:
                    case DataTypes.MESH:
                    case DataTypes.TILE:
                    case DataTypes.TILESET:
                    case DataTypes.AUTOTILE:
                    case DataTypes.ENTITY:
                    case DataTypes.MAP:
                        eh = 32;
                        break;
                }
                
                draw_line(x1 + 16, entry_yy, x2 - 16, entry_yy);
                if (!dialog_exists()) {
                    if (mouse_within_rectangle_adjusted(x1 + tolerance, entry_yy + tolerance, x2 - tolerance, entry_yy + eh - tolerance)) {
                        draw_rectangle_colour(x1 + tolerance, entry_yy + tolerance, x2 - tolerance, entry_yy + eh - tolerance, c, c, c, c, false);
                        if (Controller.release_left) {
                            var attainment = type[EventNodeCustomData.ATTAINMENT];
                            if (attainment == null) {
                                switch (type[EventNodeCustomData.TYPE]) {
                                    case DataTypes.INT:
                                        custom_data_list[| 0] = get_integer(type[0] + "?", custom_data_list[| 0]);
                                        break;
                                    case DataTypes.FLOAT:
                                        var parse_me = get_string(type[0] + "?", string(custom_data_list[| 0]));
                                        if (validate_double(parse_me)) {
                                            custom_data_list[| 0] = real(parse_me);
                                        }
                                        break;
                                    case DataTypes.STRING:
                                        custom_data_list[| 0] = get_string(type[0] + "?", string(custom_data_list[| 0]));
                                        break;
                                    case DataTypes.BOOL:
                                        custom_data_list[| 0] =! custom_data_list[| 0];
                                        break;
                                    case DataTypes.ENUM:
                                    case DataTypes.DATA:
                                        if (guid_get(type[EventNodeCustomData.TYPE_GUID])) {
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
                                        if (node.editor_handle == noone) {
                                            var location = get_temp_code_path(node);
                                            var buffer = buffer_create(1, buffer_grow, 1);
                                            buffer_write(buffer, buffer_text, custom_data_list[| i]);
                                            buffer_save_ext(buffer, location, 0, buffer_tell(buffer));
                                            buffer_delete(buffer);
                                    
                                            node.editor_handle = ds_stuff_open_local(location);
                                        }
                                        break;
                                    case DataTypes.COLOR:
										var picker = dialog_create_color_picker_options(node, custom_data_list[| 0], uivc_color_picker_event_node);
										picker.node = node;
										picker.index = i;
										break;
                                    // @todo data types
                                    case DataTypes.MESH:
                                    case DataTypes.TILE:
                                    case DataTypes.TILESET:
                                    case DataTypes.AUTOTILE:
										not_yet_implemented();
                                    case DataTypes.ENTITY:
										var dialog = dialog_create_refid_list(node, custom_data_list[| 0], uivc_refid_picker_event_node);
										dialog.node = node;
										dialog.index = i;
                                        break;
                                    case DataTypes.MAP:
                                        show_error("okay you actually need to implement this soon, please", true);
                                        break;
                                }
                            } else {
                                script_execute(attainment, noone, node, i);
                            }
                        }
                    }
                }
                
                if (node.editor_handle && type[EventNodeCustomData.TYPE] == DataTypes.CODE) {
                    custom_data_list[| i] = uios_code_text(node, custom_data_list[| i]);
                    draw_rectangle_colour(x1 + tolerance, entry_yy + tolerance, x2 - tolerance, entry_yy - tolerance + eh, c, c, c, c, false);
                    if (ds_stuff_process_complete(node.editor_handle)) {
                        node.editor_handle = noone;
                        file_delete(get_temp_code_path(node));
                    }
                }
                
                var message = type[0] + " ";
                
                if (ds_list_size(custom_data_list) == 1) {
                    var output_script = type[EventNodeCustomData.OUTPUT];
                    var output_string = "";
                    
                    switch (type[1]) {
                        case DataTypes.INT:
                            message = message + "(int): ";
                            output_string = string(custom_data_list[| 0]);
                            break;
                        case DataTypes.FLOAT:
                            message = message + "(float): ";
                            output_string = string(custom_data_list[| 0]);
                            break;
                        case DataTypes.STRING:
                            message = message + "(string): ";
                            output_string = "";
                            break;
                        case DataTypes.BOOL:
                            message = message + "(boolean): ";
                            output_string = Stuff.tf[custom_data_list[| 0]];
                            break;
                        case DataTypes.ENUM:
                        case DataTypes.DATA:
                            var datadata = guid_get(type[EventNodeCustomData.TYPE_GUID]);
                            var setdata = guid_get(custom_data_list[| 0]);
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
							var color_value = custom_data_list[| 0];
                            output_string = "#" + string_hex(color_value, 6);
							draw_rectangle_colour(x2 - 64, entry_yy + 8, x2 - 32, entry_yy + eh - 8, color_value, color_value, color_value, color_value, false);
							draw_rectangle_colour(x2 - 64, entry_yy + 8, x2 - 32, entry_yy + eh - 8, c_black, c_black, c_black, c_black, true);
                            break;
                        case DataTypes.MESH:
                            message = message + "(mesh): ";
                            output_string = "TBD";
                            break;
                        case DataTypes.TILE:
                            message = message + "(tile): ";
                            output_string = "TBD";
                            break;
                        case DataTypes.TILESET:
                            message = message + "(tileset): ";
                            output_string = "TBD";
                            break;
                        case DataTypes.AUTOTILE:
                            message = message + "(autotile): ";
                            output_string = "TBD";
                            break;
                        case DataTypes.AUDIO_BGM:
                            var setdata = guid_get(custom_data_list[| 0]);
                            message = message + "(bgm): ";
                            output_string = setdata ? setdata.name : "<null>";
                            break;
                        case DataTypes.AUDIO_SE:
                            var setdata = guid_get(custom_data_list[| 0]);
                            message = message + "(se): ";
                            output_string = setdata ? setdata.name : "<null>";
                            break;
                        case DataTypes.ANIMATION:
                            var setdata = guid_get(custom_data_list[| 0]);
                            message = message + "(animation): ";
                            output_string = setdata ? setdata.name : "<null>";
                            break;
                        case DataTypes.ENTITY:
							var refid = custom_data_list[| 0];
                            var setdata = refid_get(refid);
							var strh = string_hex(refid);
                            message = message + "(entity): ";
							// If the value is 0, it's automatically "this". If it has a value, it's
							// an entity reference somewhere (which could also be self, but probably not)
							if (custom_data_list[| 0]) {
								output_string = (setdata ? setdata.name : "<not loaded>") + ":" + strh;
							} else {
								output_string = "<self>:" + strh;
							}
                            break;
                        case DataTypes.MAP:
                            var setdata = guid_get(custom_data_list[| 0]);
                            message = message + "(map): ";
                            output_string = setdata ? setdata.name : "<null>";
                            break;
                    }
                    
                    message = message + ((output_script == null) ? output_string : script_execute(output_script, node, i));
                } else {
                    message = message + ": multiple values (" + string(ds_list_size(custom_data_list)) + ")";
                }
                
                if (type[1] == DataTypes.STRING && ds_list_size(custom_data_list) == 1) {
                    draw_text(x1 + 16, entry_yy + 12, string(message));
                    draw_text_ext(x1 + 16, mean(entry_yy + 12, entry_yy + eh), string(custom_data_list[| 0]), -1, EVENT_NODE_CONTACT_WIDTH - 16);
                } else {
                    draw_text_ext(x1 + 16, mean(entry_yy, entry_yy + eh), string(message), -1, EVENT_NODE_CONTACT_WIDTH - 16);
                }
                
                entry_yy = entry_yy + eh;
            }
        }
        break;
    #endregion
}

// different node types may put the outbound nodes in different places - not all use more than one output node
var bezier_override = false;
switch (node.type) {
    case EventNodeTypes.ENTRYPOINT:
	#region Entrypoint
        // vertical middle of the box; entrypoints will only ever have one outbound node so we can cheat
        var by = entry_yy + eh / 2;
        var outbound = node.outbound[| 0];
        
        if (!outbound) {
            draw_event_node_outbound(x2, by, node, 0, true);
        } else {
            var bx2 = outbound.x;
            var by2 = outbound.y + 16;
            
            draw_event_node_outbound(x2, by, node);
            draw_sprite(spr_event_dot, 0, x2, by);
            
            if (event_canvas_active_node != node) {
                if (bx2 > x2) {
                    draw_bezier(x2 + 8, by, bx2 - 8, by2);
                } else {
                    draw_event_ghost(x2 + 8, by, x2 + 64, by, outbound);
                }
            }
        }
        break;
	#endregion
    case EventNodeTypes.COMMENT:
        // no outbound node allowed
        break;
    case EventNodeTypes.CONDITIONAL:
	#region Conditional
        // it'd be real nice if this could just be in the default case, but the outbound nodes
        // are spaced slightly differently for this so it wouldn't really work
        bezier_override = true;
        var by = entry_yy + entry_height - 16;
        var n = ds_list_size(node.outbound);
        var bezier_y = 0;
        
        for (var i = 0; i < n; i++) {
            var outbound = node.outbound[| i];
            if (!outbound) {
                draw_event_node_outbound(x2, by, node, i, true);
            } else {
                var bx2 = outbound.x;
                var by2 = outbound.y + 16;
                
                draw_event_node_outbound(x2, by, node, i);
                draw_sprite(spr_event_dot, 0, x2, by);
                
                if (event_canvas_active_node != node || event_canvas_active_node_index != i) {
                    if (bx2 > x2) {
                        draw_bezier(x2 + 8, by, bx2 - 8, by2);
                    } else {
                        draw_event_ghost(x2 + 8, by, x2 + 64, by, outbound);
                    }
                }
            }
            
            if (event_canvas_active_node == node && event_canvas_active_node_index == i) {
                bezier_y = by;
            }
            
            // this is seriously screwing with scope but it works since nodes can't change type
            by = by + eh + ((i < n - 2) ? rh : (rh + eh) / 2);
        }
        
        if (event_canvas_active_node == node) {
            if (!dialog_exists()) {
                if (Controller.release_left) {
                    // if the mouse is contacting another entrypoint, connect it
                    var contacted_node = event_seek_node();
                    if (contacted_node) {
                        event_connect_node(node, contacted_node, event_canvas_active_node_index);
                    }
                    event_canvas_active_node = noone;
                    event_canvas_active_node_index = 0;
                }
            }
            
            draw_bezier(x2 + 8, bezier_y, mouse_x_view, mouse_y_view);
        }
        break;
	#endregion
    case EventNodeTypes.SHOW_CHOICES:
	#region Choices
        bezier_override = true;
        var by = entry_yy + eh / 2;
        var n = ds_list_size(node.outbound);
        var bezier_y = 0;
        
        for (var i = 0; i < n; i++) {
            var outbound = node.outbound[| i];
            if (!outbound) {
                draw_event_node_outbound(x2, by, node, i, true);
            } else {
                var bx2 = outbound.x;
                var by2 = outbound.y + 16;
                
                draw_event_node_outbound(x2, by, node, i);
                draw_sprite(spr_event_dot, 0, x2, by);
                
                if (event_canvas_active_node != node || event_canvas_active_node_index != i) {
                    if (bx2 > x2) {
                        draw_bezier(x2 + 8, by, bx2 - 8, by2);
                    } else {
                        draw_event_ghost(x2 + 8, by, x2 + 64, by, outbound);
                    }
                }
            }
            
            if (event_canvas_active_node == node && event_canvas_active_node_index == i) {
                bezier_y = by;
            }
            
            by = by + eh;
        }
        
        if (event_canvas_active_node == node) {
            if (!dialog_exists()) {
                if (Controller.release_left) {
                    // if the mouse is contacting another entrypoint, connect it
                    var contacted_node = event_seek_node();
                    if (contacted_node) {
                        event_connect_node(node, contacted_node, event_canvas_active_node_index);
                    }
                    event_canvas_active_node = noone;
                    event_canvas_active_node_index = 0;
                }
            }
            
            draw_bezier(x2 + 8, bezier_y, mouse_x_view, mouse_y_view);
        }
        break;
	#endregion
    default:
	#region Custom (usually)
        var entry_yy = y1 + EVENT_NODE_CONTACT_HEIGHT;
		
		for (var i = 0; i < ds_list_size(node.outbound); i++) {
	        var outbound = node.outbound[| i];
			var by = entry_yy + i * EVENT_NODE_CONTACT_HEIGHT * 2 / 3;
			
	        if (!outbound) {
	            draw_event_node_outbound(x2, by, node, i, true);
	        } else {
	            var bnx = outbound.x;
	            var bny = outbound.y + 16;
				
	            draw_event_node_outbound(x2, by, node, i);
	            draw_sprite(spr_event_dot, 0, x2, by);
				
	            if (event_canvas_active_node != node || event_canvas_active_node_index != i) {
	                if (bnx > x2) {
	                    draw_bezier(x2 + 8, by, bnx - 8, bny);
	                } else {
	                    draw_event_ghost(x2 + 8, by, x2 + 64, by, outbound);
	                }
	            }
	        }
		}
        break;
	#endregion
}

// condition nodes have them located in strange places so i'm not going to try
// to come up with a general solution
if (!bezier_override) {
    if (event_canvas_active_node == node) {
	    var camera = view_get_camera(view_current);
	    draw_bezier(x2 + 8, entry_yy + event_canvas_active_node_index * EVENT_NODE_CONTACT_HEIGHT * 2 / 3, Camera.MOUSE_X + camera_get_view_x(camera), Camera.MOUSE_Y + camera_get_view_y(camera));
        if (!dialog_exists()) {
            if (Controller.release_left) {
                // if the mouse is contacting another entrypoint, connect it
                var contacted_node = event_seek_node();
                if (contacted_node) {
                    event_connect_node(node, contacted_node, event_canvas_active_node_index);
                }
                event_canvas_active_node = noone;
                event_canvas_active_node_index = 0;
				Controller.release_left = false;
            }
        }
    }
}