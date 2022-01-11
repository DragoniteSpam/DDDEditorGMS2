function draw_active_event() {
    if (Stuff.event.active) {
        draw_set_font(FDefault);
        draw_set_halign(fa_left);
        draw_set_valign(fa_middle);
        draw_set_color(c_black);
        
        Stuff.event.node_info = noone;
        
        for (var i = 0; i < array_length(Stuff.event.active.nodes); i++) {
            draw_event_node(Stuff.event.active.nodes[i]);
        }
        
        // if you're hovering over an event to show info for, draw it at
        // the end otherwise another event might get drawn on top of it
        if (Stuff.event.node_info) {
            switch (Stuff.event.node_info.type) {
                case EventNodeTypes.CONDITIONAL:
                    var n = 3;
                    var x1 = Stuff.event.node_info.x;
                    var y1 = Stuff.event.node_info.y - 64 - 16 * max(n, 1);
                    var x2 = x1 + EVENT_NODE_CONTACT_WIDTH;
                    var y2 = Stuff.event.node_info.y - 32;
                    var vertical_padding = 8;
                    
                    draw_roundrect_colour(x1, y1 - vertical_padding, x2, y2 + vertical_padding, c_white, c_white, false);
                    draw_roundrect(x1, y1 - vertical_padding, x2, y2 + vertical_padding, true);
                    
                    draw_text(x1 + 16, mean(y1, y2), "Conditional branch -\n" +
                    "select a condition type, or evaluate\n" +
                    "some code");
                    break;
                case EventNodeTypes.SHOW_CHOICES:
                    var n = 3;
                    var x1 = Stuff.event.node_info.x;
                    var y1 = Stuff.event.node_info.y - 64 - 16 * n;
                    var x2 = x1 + EVENT_NODE_CONTACT_WIDTH;
                    var y2 = Stuff.event.node_info.y - 32;
                    var vertical_padding = 8;
                    
                    draw_roundrect_colour(x1, y1 - vertical_padding, x2, y2 + vertical_padding, c_white, c_white, false);
                    draw_roundrect(x1, y1 - vertical_padding, x2, y2 + vertical_padding, true);
                    
                    draw_text(x1 + 16, mean(y1, y2), "Show choices -\n" +
                    "each choice can link to a different node;\n" +
                    "if no node is selected the default is used");
                    break;
                case EventNodeTypes.TEXT:
                    var n = 5;
                    var x1 = Stuff.event.node_info.x;
                    var y1 = Stuff.event.node_info.y - 64 - 16 * n;
                    var x2 = x1 + EVENT_NODE_CONTACT_WIDTH;
                    var y2 = Stuff.event.node_info.y - 32;
                    var vertical_padding = 8;
                    
                    draw_roundrect_colour(x1, y1 - vertical_padding, x2, y2 + vertical_padding, c_white, c_white, false);
                    draw_roundrect(x1, y1 - vertical_padding, x2, y2 + vertical_padding, true);
                    
                    draw_text(x1 + 16, mean(y1, y2), "Show text -\n" +
                    "each block of text will be shown in its\n" +
                    "own box (this way you can write long\n" +
                    "conversations without having a million\n" +
                    "Show Text actions");
                    break;
                case EventNodeTypes.SHOW_SCROLLING_TEXT:
                    var n = 3;
                    var x1 = Stuff.event.node_info.x;
                    var y1 = Stuff.event.node_info.y - 64 - 16 * n;
                    var x2 = x1 + EVENT_NODE_CONTACT_WIDTH;
                    var y2 = Stuff.event.node_info.y - 32;
                    var vertical_padding = 8;
                    
                    draw_roundrect_colour(x1, y1 - vertical_padding, x2, y2 + vertical_padding, c_white, c_white, false);
                    draw_roundrect(x1, y1 - vertical_padding, x2, y2 + vertical_padding, true);
                    
                    draw_text(x1 + 16, mean(y1, y2), "Show text crawl -\n" +
                    "each block of text will be its own\n" +
                    "paragraph");
                    break;
                default:
                    var base = guid_get(Stuff.event.node_info.custom_guid);
                    var n = array_length(base.types);
                    var x1 = Stuff.event.node_info.x;
                    var y1 = Stuff.event.node_info.y - 64 - 16 * max(n, 1);
                    var x2 = x1 + EVENT_NODE_CONTACT_WIDTH;
                    var y2 = Stuff.event.node_info.y - 32;
                    var vertical_padding = 8;
                    
                    draw_roundrect_colour(x1, y1 - vertical_padding, x2, y2 + vertical_padding, c_white, c_white, false);
                    draw_roundrect(x1, y1 - vertical_padding, x2, y2 + vertical_padding, true);
                    
                    draw_text(x1 + 16, y1 + 8, string(base.name));
                    draw_line(x1 + 16, y1 + 24, x2 - 16, y1 + 24);
                    
                    if (n == 0) {
                        draw_text_colour(x1 + 16, y1 + 40, string("No data properties"), c_gray, c_gray, c_gray, c_gray, 1);
                    } else {
                        for (var i = 0; i < n; i++) {
                            var type = base.types[i];
                            var type_name;
                            switch (type.type) {
                                case DataTypes.INT: type_name = "int"; break;
                                case DataTypes.FLOAT: type_name = "float"; break;
                                case DataTypes.STRING: type_name = "string"; break;
                                case DataTypes.BOOL: type_name = "boolean"; break;
                                case DataTypes.ENUM:
                                case DataTypes.DATA:
                                    var datadata = guid_get(type.type_guid);
                                    type_name = datadata ? datadata.name : "<no type set>";
                                    break;
                                case DataTypes.AUDIO_BGM: type_name = "background music"; break;
                                case DataTypes.AUDIO_SE: type_name = "sound effect"; break;
                                case DataTypes.ANIMATION: type_name = "animation"; break;
                                case DataTypes.CODE: type_name = "code"; break;
                                case DataTypes.COLOR: type_name = "color"; break;
                                case DataTypes.MESH: type_name = "mesh"; break;
                                case DataTypes.MESH_AUTOTILE: type_name = "mesh autotile"; break;
                                case DataTypes.TILE: type_name = "tile"; break;
                                case DataTypes.IMG_TEXTURE: type_name = "tileset"; break;
                                case DataTypes.IMG_BATTLER: type_name = "battler"; break;
                                case DataTypes.IMG_OVERWORLD: type_name = "overworld"; break;
                                case DataTypes.IMG_PARTICLE: type_name = "particle"; break;
                                case DataTypes.IMG_UI: type_name = "UI"; break;
                                case DataTypes.IMG_SKYBOX: type_name = "sky"; break;
                                case DataTypes.IMG_ETC: type_name = "misc"; break;
                                case DataTypes.IMG_TILE_ANIMATION: type_name = "tile animation"; break;
                                case DataTypes.ENTITY: type_name = "entity"; break;
                                case DataTypes.MAP: type_name = "map"; break;
                                case DataTypes.EVENT: type_name = "event"; break;
                            }
                            draw_text(x1 + 16, y1 + 40 + i * 16, string(string(i + 1) + ". " + type.name + " (" + type_name + ")"));
                        }
                    }
                break;
            }
        }
    }
}