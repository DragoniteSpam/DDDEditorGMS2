function serialize_load_event_prefabs(buffer, version) {
    var addr_next = buffer_read(buffer, buffer_u64);
    var n_prefabs = buffer_read(buffer, buffer_u32);
    
    repeat (n_prefabs) {
        var prefab = new DataEventNode();
        // serialize_load_generic needs to be unwrapped here
        var name = buffer_read(buffer, buffer_string);
        buffer_read(buffer, buffer_string);
        buffer_read(buffer, buffer_u32);
        var guid = buffer_read(buffer, buffer_datatype);
        buffer_read(buffer, buffer_string);
        
        var type = buffer_read(buffer, buffer_u16);
        
        prefab = event_create_node(noone, type);
        prefab.name = name;
        guid_set(prefab, guid);
        prefab.type = type;
        ds_list_add(Game.events.prefabs, prefab);
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
                var list_types = prefab.custom_data[0];
                var list_indices = prefab.custom_data[1];
                var list_comparisons = prefab.custom_data[2];
                var list_values = prefab.custom_data[3];
                var list_code = prefab.custom_data[4];
                
                list_types = [];
                list_indices = [];
                list_comparisons = [];
                list_values = [];
                list_code = [];
                
                var n = buffer_read(buffer, buffer_u8);
                repeat (n) {
                    array_push(list_types, buffer_read(buffer, buffer_u8));
                    array_push(list_indices, buffer_read(buffer, buffer_s32));
                    array_push(list_comparisons, buffer_read(buffer, buffer_u8));
                    array_push(list_values, buffer_read(buffer, buffer_f32));
                    array_push(list_code, buffer_read(buffer, buffer_string));
                }
                break;
            case EventNodeTypes.CUSTOM:
            default:
                prefab.custom_guid = buffer_read(buffer, buffer_datatype);
                if (prefab.type != EventNodeTypes.CUSTOM) {
                    // other types also save the custom guid, even though there's really no reason
                    // for them to do so
                    prefab.custom_guid = Stuff.event_prefab[prefab.type].GUID;
                }
                
                var custom = guid_get(prefab.custom_guid);
                
                for (var i = 0; i < ds_list_size(custom.types); i++) {
                    var sub_list = ds_list_create();
                    type = custom.types[| i];
                    
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
                        case DataTypes.ASSET_FLAG:
                            var buffer_type = buffer_flag;
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
                        case DataTypes.MESH_AUTOTILE:
                        case DataTypes.IMG_TEXTURE:
                        case DataTypes.IMG_BATTLER:
                        case DataTypes.IMG_ETC:
                        case DataTypes.IMG_OVERWORLD:
                        case DataTypes.IMG_PARTICLE:
                        case DataTypes.IMG_UI:
                        case DataTypes.IMG_SKYBOX:
                        case DataTypes.IMG_TILE_ANIMATION:
                            var buffer_type = buffer_datatype;
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
                            array_push(sub_list, buffer_read(buffer, buffer_type));
                        }
                        array_push(prefab.custom_data, sub_list);
                    } else {
                        var sub_list = prefab.custom_data[i];
                        sub_list = [];
                        repeat (n_custom_data) {
                            array_push(sub_list, buffer_read(buffer, buffer_type));
                        }
                    }
                }
                break;
        }
    }
}