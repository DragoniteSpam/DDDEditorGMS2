/// @param buffer
/// @param version

var buffer = argument0;
var version = argument1;
var n_events = buffer_read(buffer, buffer_u32);

Stuff.active_event = noone;

repeat (n_events) {
    // this was written in pieces before serialize_load_generic was
    // so don't use it here otherwise things will break
    var event_name = buffer_read(buffer, buffer_string);
    var event = event_create(event_name);
    guid_set(event, buffer_read(buffer, buffer_u32));
    
    ds_list_add(Stuff.all_events, event);
    // events are created with an entrypoint by default - you could pass an optional
    // parameter to the constructor to have it not do this, but this is the only place
    // where it's going to happen, so there's not really a point
    instance_destroy(event.nodes[| 0]);
    ds_list_clear(event.nodes);
    
    var connections = ds_list_create();
    
    var n_nodes = buffer_read(buffer, buffer_u32);
    
    repeat (n_nodes) {
        var node_name = buffer_read(buffer, buffer_string);
        var node_type = buffer_read(buffer, buffer_u16);
        var node_x = buffer_read(buffer, buffer_s32);
        var node_y = buffer_read(buffer, buffer_s32);
        var node = event_create_node(event, node_type, node_x, node_y);
        node.name = node_name;
        node.event = event;
        
        guid_set(node, buffer_read(buffer, buffer_u32));
		
		if (version >= DataVersions.EVENT_PREFABS) {
			node.prefab_guid = buffer_read(buffer, buffer_datatype);
		}
        
        // some preliminary data may be created
        ds_list_clear(node.data);
		ds_list_clear(node.outbound);
        
        // node connections are stored until all of the nodes (and their names)
        // have been read out of the file
        
        var node_connections = ds_list_create();
        ds_list_add(connections, node_connections);
        
        var n_outbound = buffer_read(buffer, buffer_u8);
        repeat (n_outbound) {
            ds_list_add(node_connections, buffer_read(buffer, buffer_string));
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
                    var radio = create_radio_array(16, 32, "If condition:", EVENT_NODE_CONTACT_WIDTH - 32, 24, null, condition_type, node);
                    radio.adjust_view = true;
                    create_radio_array_options(radio, ["Variable", "Switch", "Self Variable", "Self Switch", "Code"]);
                    radio.y = radio.y + (((ui_get_radio_array_height(radio) div eh) * eh) + eh + 16) * ds_list_size(node.ui_things);
                    
                    ds_list_add(node.ui_things, radio);
                }
                break;
            case EventNodeTypes.CUSTOM:
            default:
                node.custom_guid = buffer_read(buffer, buffer_u32);
				
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
                        case DataTypes.ANIMATION:
                        case DataTypes.ENTITY:
                        case DataTypes.MAP:
                            var buffer_type = buffer_u32;
                            break;
                        case DataTypes.COLOR:
                        case DataTypes.MESH:
                        case DataTypes.TILESET:
                        case DataTypes.TILE:
                        case DataTypes.AUTOTILE:
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
    
    for (var i = 0; i < n_nodes; i++) {
        var node = event.nodes[| i];
        var node_connection = connections[| i];
        
        for (var j = 0; j < ds_list_size(node_connection); j++) {
			ds_list_add(node.outbound, noone);
            if (string_length(node_connection[| j]) > 0) {
                event_connect_node(node, event_get_node(event, node_connection[| j]), j);
            }
        }
        
        ds_list_destroy(node_connection);
    }
    
    ds_list_destroy(connections);
}

// by default, set the 0th event as the active event
if (ds_list_empty(Stuff.all_events)) {
    ds_list_add(all_events, event_create("DefaultEvent"));
}

Stuff.active_event = Stuff.all_events[| 0];