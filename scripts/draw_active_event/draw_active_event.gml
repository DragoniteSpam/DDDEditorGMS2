if (Stuff.active_event) {
    draw_set_font(FDefault12);
    draw_set_halign(fa_left);
    draw_set_valign(fa_middle);
    draw_set_color(c_black);
    
    Stuff.event_node_info = noone;
    
    for (var i = 0; i < ds_list_size(Stuff.active_event.nodes); i++) {
        draw_event_node(Stuff.active_event.nodes[| i]);
    }
    
    // if you're hovering over an event to show info for, draw it at
    // the end otherwise another event might get drawn on top of it
    if (Stuff.event_node_info) {
        switch (Stuff.event_node_info.type) {
            case EventNodeTypes.CONDITIONAL:
                var n = 3;
                var x1 = Stuff.event_node_info.x;
                var y1 = Stuff.event_node_info.y - 64 - 16 * max(n, 1);
                var x2 = x1 + EVENT_NODE_CONTACT_WIDTH;
                var y2 = Stuff.event_node_info.y - 32;
                var vertical_padding = 8;
        
                draw_roundrect_colour(x1, y1 - vertical_padding, x2, y2 + vertical_padding, c_white, c_white, false);
                draw_roundrect(x1, y1 - vertical_padding, x2, y2 + vertical_padding, true);
            
                draw_text(x1 + 16, mean(y1, y2), "Conditional branch -\n" +
                "select a condition type, or evaluate\n" +
                "some code");
                break;
            case EventNodeTypes.SHOW_CHOICES:
                var n = 3;
                var x1 = Stuff.event_node_info.x;
                var y1 = Stuff.event_node_info.y - 64 - 16 * max(n, 1);
                var x2 = x1 + EVENT_NODE_CONTACT_WIDTH;
                var y2 = Stuff.event_node_info.y - 32;
                var vertical_padding = 8;
        
                draw_roundrect_colour(x1, y1 - vertical_padding, x2, y2 + vertical_padding, c_white, c_white, false);
                draw_roundrect(x1, y1 - vertical_padding, x2, y2 + vertical_padding, true);
            
                draw_text(x1 + 16, mean(y1, y2), "Show choices -\n" +
                "each choice can link to a different node;\n" +
                "if no node is selected the default is used");
                break;
            default:
                var base = guid_get(Stuff.event_node_info.custom_guid);
                var n = ds_list_size(base.types);
                var x1 = Stuff.event_node_info.x;
                var y1 = Stuff.event_node_info.y - 64 - 16 * max(n, 1);
                var x2 = x1 + EVENT_NODE_CONTACT_WIDTH;
                var y2 = Stuff.event_node_info.y - 32;
                var vertical_padding = 8;
        
                draw_roundrect_colour(x1, y1 - vertical_padding, x2, y2 + vertical_padding, c_white, c_white, false);
                draw_roundrect(x1, y1 - vertical_padding, x2, y2 + vertical_padding, true);
        
                draw_text(x1 + 16, y1 + 8, string(base.name));
                draw_line(x1 + 16, y1 + 24, x2 - 16, y1 + 24);
        
                if (n == 0) {
                    draw_text_colour(x1 + 16, y1 + 40, string("No data properties"), c_gray, c_gray, c_gray, c_gray, 1);
                } else {
                    for (var i = 0; i < n; i++) {
                        var type = base.types[| i];
                        switch (type[1]) {
                            case DataTypes.INT:
                                var type_name = "int";
                                break;
                            case DataTypes.FLOAT:
                                var type_name = "float";
                                break;
                            case DataTypes.STRING:
                                var type_name = "string";
                                break;
                            case DataTypes.BOOL:
                                var type_name = "boolean";
                                break;
                            case DataTypes.ENUM:
                            case DataTypes.DATA:
                                var datadata = guid_get(type[EventNodeCustomData.TYPE_GUID]);
                                if (datadata) {
                                    var type_name = datadata.name;
                                } else {
                                    var type_name = "<no type set>";
                                }
                                break;
                            case DataTypes.AUDIO_BGM:
                                var type_name = "background music";
                                break;
                            case DataTypes.AUDIO_SE:
                                var type_name = "sound effect";
                                break;
                            case DataTypes.ANIMATION:
                                var type_name = "animation";
                                break;
                            case DataTypes.CODE:
                                var type_name = "code";
                                break;
                            case DataTypes.COLOR:
                                var type_name = "color";
                                break;
                            case DataTypes.MESH:
                                var type_name = "mesh";
                                break;
                            case DataTypes.TILE:
                                var type_name = "tile";
                                break;
                            case DataTypes.TILESET:
                                var type_name = "tileset";
                                break;
                            case DataTypes.AUTOTILE:
                                var type_name = "autotile";
                                break;
                            case DataTypes.ENTITY:
                                var type_name = "entity";
                                break;
                        }
                        draw_text(x1 + 16, y1 + 40 + i * 16, string(string(i + 1) + ". " + type[EventNodeCustomData.NAME] + " (" + type_name + ")"));
                    }
                }
            break;
        }
    }
}