function serialize_load_event_prefabs(buffer, version) {
    var addr_next = buffer_read(buffer, buffer_u64);
    var n_prefabs = buffer_read(buffer, buffer_u32);
    
    repeat (n_prefabs) {
        var prefab = instance_create_depth(0, 0, 0, DataEventNode);
        // serialize_load_generic needs to be unwrapped here
        var name = buffer_read(buffer, buffer_string);
        buffer_read(buffer, buffer_string);
        buffer_read(buffer, buffer_u32);
        var guid = buffer_read(buffer, buffer_datatype);
        buffer_read(buffer, buffer_string);
        
        var type = buffer_read(buffer, buffer_u16);
        
        var prefab = event_create_node(noone, type);
        prefab.name = name;
        guid_set(prefab, guid);
        prefab.type = type;
        ds_list_add(Stuff.all_event_prefabs, prefab);
        ds_list_clear(prefab.data);
        var n_data = buffer_read(buffer, buffer_u8);
        
        repeat (n_data) {
            ds_list_add(prefab.data, buffer_read(buffer, buffer_string));
        }
        
        switch (prefab.type) {
            // is_root is set in the constructor already
            case EventNodeTypes.ENTRYPOINT:
            case EventNodeTypes.TEXT:
            case EventNodeTypes.SHOW_CHOICES:
                break;
            case EventNodeTypes.CONDITIONAL:
                var list_types = prefab.custom_data[| 0];
                var list_indices = prefab.custom_data[| 1];
                var list_comparisons = node.custom_data[| 2];
                var list_values = prefab.custom_data[| 3];
                var list_code = prefab.custom_data[| 4];
                
                ds_list_clear(list_types);
                ds_list_clear(list_indices);
                ds_list_clear(list_comparisons);
                ds_list_clear(list_values);
                ds_list_clear(list_code);
                
                var n = buffer_read(buffer, buffer_u8);
                repeat (n) {
                    ds_list_add(list_types, buffer_read(buffer, buffer_u8));
                    ds_list_add(list_indices, buffer_read(buffer, buffer_s32));
                    ds_list_add(list_comparisons, buffer_read(buffer, buffer_u8));
                    ds_list_add(list_values, buffer_read(buffer, buffer_f32));
                    ds_list_add(list_code, buffer_read(buffer, buffer_string));
                }
                break;
            case EventNodeTypes.CUSTOM:
            default:
                prefab.custom_guid = buffer_read(buffer, buffer_get_datatype(version));
                if (prefab.type != EventNodeTypes.CUSTOM) {
                    // other types also save the custom guid, even though there's really no reason
                    // for them to do so
                    prefab.custom_guid = Stuff.event_prefab[prefab.type].GUID;
                }
                
                var custom = guid_get(prefab.custom_guid);
                
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
                        case DataTypes.COLOR:
                            var buffer_type = buffer_u32;
                            break;
                        case DataTypes.ENUM:
                        case DataTypes.DATA:
                        case DataTypes.AUDIO_BGM:
                        case DataTypes.AUDIO_SE:
                        case DataTypes.ANIMATION:
                        case DataTypes.ENTITY:
                        case DataTypes.MAP:
                        case DataTypes.EVENT:
                        case DataTypes.MESH:
                        case DataTypes.IMG_TEXTURE:
                        case DataTypes.IMG_BATTLER:
                        case DataTypes.IMG_ETC:
                        case DataTypes.IMG_OVERWORLD:
                        case DataTypes.IMG_PARTICLE:
                        case DataTypes.IMG_UI:
                        case DataTypes.IMG_SKYBOX:
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
                    if (prefab.type == EventNodeTypes.CUSTOM) {
                        repeat (n_custom_data) {
                            ds_list_add(sub_list, buffer_read(buffer, buffer_type));
                        }
                        ds_list_add(prefab.custom_data, sub_list);
                    } else {
                        var sub_list = prefab.custom_data[| i];
                        ds_list_clear(sub_list);
                        repeat (n_custom_data) {
                            ds_list_add(sub_list, buffer_read(buffer, buffer_type));
                        }
                    }
                }
                break;
        }
    }
}