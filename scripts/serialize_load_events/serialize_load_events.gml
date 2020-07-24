/// @param buffer
/// @param version

var buffer = argument0;
var version = argument1;

var addr_next = buffer_read(buffer, buffer_u64);

var n_events = buffer_read(buffer, buffer_u32);

Stuff.event.active = noone;

repeat (n_events) {
    // this was written in pieces before serialize_load_generic was
    // so don't use it here otherwise things will break
    var event_name = buffer_read(buffer, buffer_string);
    var event = event_create(event_name);
    ds_list_add(Stuff.all_events, event);
    guid_set(event, buffer_read(buffer, buffer_get_datatype(version)));
    
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
        
        guid_set(node, buffer_read(buffer, buffer_get_datatype(version)));
        
        node.prefab_guid = buffer_read(buffer, buffer_get_datatype(version));
        
        // some preliminary data may be created
        ds_list_clear(node.data);
        ds_list_clear(node.outbound);
        
        // read out the GUIDs and link them later
        var n_outbound = buffer_read(buffer, buffer_u8);
        repeat (n_outbound) {
            if (version >= DataVersions.UPDATED_EVENT_NODE_CONNECTIONS) {
                ds_list_add(node.outbound, buffer_read(buffer, buffer_datatype));
            } else {
                ds_list_add(node.outbound, buffer_read(buffer, buffer_string));
            }
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
                var list_types = node.custom_data[| 0];
                var list_indices = node.custom_data[| 1];
                var list_comparisons = node.custom_data[| 2];
                var list_values = node.custom_data[| 3];
                var list_code = node.custom_data[| 4];
                
                ds_list_clear(list_types);
                ds_list_clear(list_indices);
                ds_list_clear(list_comparisons);
                ds_list_clear(list_values);
                ds_list_clear(list_code);
                
                var n = buffer_read(buffer, buffer_u8);
                repeat (n) {
                    var condition_type = buffer_read(buffer, buffer_u8);
                    ds_list_add(list_types, condition_type);
                    ds_list_add(list_indices, buffer_read(buffer, buffer_s32));
                    ds_list_add(list_comparisons, buffer_read(buffer, buffer_u8));
                    ds_list_add(list_values, buffer_read(buffer, buffer_f32));
                    ds_list_add(list_code, buffer_read(buffer, buffer_string));
                    
                    var eh = 32;
                    var radio = create_radio_array(16, 48, "If condition:", EVENT_NODE_CONTACT_WIDTH - 32, 24, null, condition_type, node);
                    radio.adjust_view = true;
                    create_radio_array_options(radio, ["Variable", "Switch", "Self Variable", "Self Switch", "Code"]);
                    radio.y = radio.y + (((ui_get_radio_array_height(radio) div eh) * eh) + eh + 16) * ds_list_size(node.ui_things);
                    
                    ds_list_add(node.ui_things, radio);
                }
                break;
            case EventNodeTypes.CUSTOM:
            default:
                node.custom_guid = buffer_read(buffer, buffer_get_datatype(version));
                
                if (node_type != EventNodeTypes.CUSTOM) {
                    // other types also save the custom guid, even though there's really no reason
                    // for them to do so
                    node.custom_guid = Stuff.event_prefab[node_type].GUID;
                }
                var custom = guid_get(node.custom_guid);
                
                for (var i = 0; i < ds_list_size(custom.types); i++) {
                    var sub_list = ds_list_create();
                    var type = custom.types[| i];
                    
                    switch (type[EventNodeCustomData.TYPE]) {
                        case DataTypes.INT:
                            var buffer_type = buffer_s32;
                            break;
                        case DataTypes.FLOAT:
                            var buffer_type = buffer_f32;
                            break;
                        case DataTypes.BOOL:
                            var buffer_type = buffer_u8;
                            break;
                        case DataTypes.STRING:
                        case DataTypes.CODE:
                            var buffer_type = buffer_string;
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
                        case DataTypes.EVENT:
                        case DataTypes.IMG_TILE_ANIMATION:
                            var buffer_type = buffer_get_datatype(version);
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
                            ds_list_add(sub_list, buffer_read(buffer, buffer_type));
                        }
                        ds_list_add(node.custom_data, sub_list);
                    } else {
                        var sub_list = node.custom_data[| i];
                        ds_list_clear(sub_list);
                        repeat (n_custom_data) {
                            ds_list_add(sub_list, buffer_read(buffer, buffer_type));
                        }
                    }
                }
                break;
        }
        
        // don't add the node to event.nodes because it already does it for you
        // in the constructor (how nice!)
    }
}

for (var i = 0; i < ds_list_size(Stuff.all_events); i++) {
    for (var j = 0; j < ds_list_size(Stuff.all_events[| i].nodes); j++) {
        var node = Stuff.all_events[| i].nodes[| j];
        
        for (var k = 0; k < ds_list_size(node.outbound); k++) {
            if (node.outbound[| k] == "") {
                node.outbound[| k] = noone;
                continue;
            }
            
            if (version >= DataVersions.UPDATED_EVENT_NODE_CONNECTIONS) {
                var dest = guid_get(node.outbound[| k]);
                dest.parents[? node] = true;
                node.outbound[| k] = dest;
            // the trials and tribulations of backwards compatibility
            } else {
                var dest = event_get_node(Stuff.all_events[| i], node.outbound[| k]);
                if (dest) {
                    dest.parents[? node] = true;
                    node.outbound[| k] = dest;
                } else {
                    for (var inefficient = 0; inefficient < ds_list_size(Stuff.all_events); inefficient++) {
                        var dest = event_get_node(Stuff.all_events[| inefficient], node.outbound[| k]);
                        if (dest) {
                            dest.parents[? node] = true;
                            node.outbound[| k] = dest;
                        }
                    }
                    if (typeof(node.outbound[| k]) == typeof(NULL)) {
                        node.outbound[| k] = noone;
                    }
                }
            }
        }
    }
}

// by default, set the 0th event as the active event
if (ds_list_empty(Stuff.all_events)) {
    ds_list_add(all_events, event_create("DefaultEvent"));
}

Stuff.event.active = Stuff.all_events[| 0];