function serialize_load_events(buffer, version) {
    var addr_next = buffer_read(buffer, buffer_u64);
    
    var n_events = buffer_read(buffer, buffer_u32);
    
    Stuff.event.active = noone;
    
    repeat (n_events) {
        // this was written in pieces before serialize_load_generic was
        // so don't use it here otherwise things will break
        var event_name = buffer_read(buffer, buffer_string);
        var event = event_create(event_name);
        ds_list_add(Game.evenst, event);
        guid_set(event, buffer_read(buffer, buffer_datatype));
        
        // events are created with an entrypoint by default - you could pass an optional
        // parameter to the constructor to have it not do this, but this is the only place
        // where it's going to happen, so there's not really a point
        instance_destroy(event.nodes[| 0]);
        ds_list_clear(event.nodes);
        
        var n_nodes = buffer_read(buffer, buffer_u32);
        
        repeat (n_nodes) {
            var node_name = buffer_read(buffer, buffer_string);
            var node_type = buffer_read(buffer, buffer_u16);
            var node_x = buffer_read(buffer, buffer_s32);
            var node_y = buffer_read(buffer, buffer_s32);
            var node = event_create_node(event, node_type, node_x, node_y);
            event_rename_node(event, node, node_name);
            node.event = event;
            
            guid_set(node, buffer_read(buffer, buffer_datatype));
            
            node.prefab_guid = buffer_read(buffer, buffer_datatype);
            
            // some preliminary data may be created
            ds_list_clear(node.data);
            node.outbound = [];
            
            // read out the GUIDs and link them later
            var n_outbound = buffer_read(buffer, buffer_u8);
            repeat (n_outbound) {
                array_push(node.outbound, buffer_read(buffer, buffer_datatype));
            }
            
            var n_data = buffer_read(buffer, buffer_u8);
            repeat (n_data) {
                ds_list_add(node.data, buffer_read(buffer, buffer_string));
            }
            
            // special code for different node types
            switch (node_type) {
                // is_root is set in the constructor already
                case EventNodeTypes.ENTRYPOINT:
                case EventNodeTypes.TEXT:
                case EventNodeTypes.SHOW_CHOICES:
                    break;
                case EventNodeTypes.CONDITIONAL:
                    var list_types = node.custom_data[0];
                    var list_indices = node.custom_data[1];
                    var list_comparisons = node.custom_data[2];
                    var list_values = node.custom_data[3];
                    var list_code = node.custom_data[4];
                    
                    list_types = [];
                    list_indices = [];
                    list_comparisons = [];
                    list_values = [];
                    list_code = [];
                    
                    var n = buffer_read(buffer, buffer_u8);
                    repeat (n) {
                        var condition_type = buffer_read(buffer, buffer_u8);
                        array_push(list_types, condition_type);
                        array_push(list_indices, buffer_read(buffer, buffer_s32));
                        array_push(list_comparisons, buffer_read(buffer, buffer_u8));
                        array_push(list_values, buffer_read(buffer, buffer_f32));
                        array_push(list_code, buffer_read(buffer, buffer_string));
                        
                        var eh = 32;
                        var radio = create_radio_array(16, 48, "If condition:", EVENT_NODE_CONTACT_WIDTH - 32, 24, null, condition_type, node);
                        radio.adjust_view = true;
                        create_radio_array_options(radio, ["Variable", "Switch", "Self Variable", "Self Switch", "Code"]);
                        radio.y = radio.y + (((ui_get_radio_array_height(radio) div eh) * eh) + eh + 16) * array_length(node.ui_things);
                        
                        array_push(node.ui_things, radio);
                    }
                    break;
                case EventNodeTypes.CUSTOM:
                default:
                    node.custom_guid = buffer_read(buffer, buffer_datatype);
                    
                    if (node_type != EventNodeTypes.CUSTOM) {
                        // other types also save the custom guid, even though there's really no reason
                        // for them to do so
                        node.custom_guid = Stuff.event_prefab[node_type].GUID;
                    }
                    var custom = guid_get(node.custom_guid);
                    
                    for (var i = 0; i < ds_list_size(custom.types); i++) {
                        var sub_list = [];
                        var type = custom.types[| i];
                        var buffer_type;
                        
                        switch (type[EventNodeCustomData.TYPE]) {
                            case DataTypes.INT:
                                buffer_type = buffer_s32;
                                break;
                            case DataTypes.FLOAT:
                                buffer_type = buffer_f32;
                                break;
                            case DataTypes.BOOL:
                                buffer_type = buffer_u8;
                                break;
                            case DataTypes.STRING:
                            case DataTypes.CODE:
                                buffer_type = buffer_string;
                                break;
                            case DataTypes.ASSET_FLAG:
                                buffer_type = buffer_flag;
                                break;
                            case DataTypes.ENUM:
                            case DataTypes.DATA:
                            case DataTypes.AUDIO_BGM:
                            case DataTypes.AUDIO_SE:
                            case DataTypes.IMG_TEXTURE:
                            case DataTypes.IMG_BATTLER:
                            case DataTypes.IMG_OVERWORLD:
                            case DataTypes.IMG_PARTICLE:
                            case DataTypes.IMG_UI:
                            case DataTypes.IMG_ETC:
                            case DataTypes.IMG_SKYBOX:
                            case DataTypes.ANIMATION:
                            case DataTypes.COLOR:
                            case DataTypes.ENTITY:
                            case DataTypes.MAP:
                            case DataTypes.MESH:
                            case DataTypes.MESH_AUTOTILE:
                            case DataTypes.EVENT:
                            case DataTypes.IMG_TILE_ANIMATION:
                                buffer_type = buffer_datatype;
                                break;
                            case DataTypes.TILE:
                                not_yet_implemented();
                                break;
                        }
                        
                        var n_custom_data = buffer_read(buffer, buffer_u8);
                        
                        // custom event types don't seem to be pre-populated with values, for
                        // some reason - although as far as i can tell they ought to be?
                        if (node_type == EventNodeTypes.CUSTOM) {
                            repeat (n_custom_data) {
                                array_push(sub_list, buffer_read(buffer, buffer_type));
                            }
                            array_push(node.custom_data, sub_list);
                        } else {
                            sub_list = node.custom_data[i];
                            sub_list = [];
                            repeat (n_custom_data) {
                                array_push(sub_list, buffer_read(buffer, buffer_type));
                            }
                        }
                    }
                    break;
            }
            
            // don't add the node to event.nodes because it already does it for you
            // in the constructor (how nice!)
        }
    }
    
    for (var i = 0; i < ds_list_size(Game.evenst); i++) {
        for (var j = 0; j < ds_list_size(Game.evenst[| i].nodes); j++) {
            var node = Game.evenst[| i].nodes[| j];
            
            for (var k = 0; k < array_length(node.outbound); k++) {
                var dest = guid_get(node.outbound[k]);
                node.outbound[k] = dest;
                if (dest) {
                    dest.parents[$ node] = true;
                }
            }
        }
    }
    
    // by default, set the 0th event as the active event
    if (ds_list_empty(Game.evenst)) {
        ds_list_add(all_events, event_create("DefaultEvent"));
    }
    
    Stuff.event.active = Game.evenst[| 0];
}