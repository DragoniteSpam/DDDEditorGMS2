/// @param buffer

var buffer = argument0;

buffer_write(buffer, buffer_u32, SerializeThings.EVENT_PREFAB);
var addr_next = buffer_tell(buffer);
buffer_write(buffer, buffer_u64, 0);

var n_prefabs = ds_list_size(Stuff.all_event_prefabs);
buffer_write(buffer, buffer_u32, n_prefabs);

for (var i = 0; i < n_prefabs; i++) {
    var prefab = Stuff.all_event_prefabs[| i];
    serialize_save_generic(buffer, prefab);
    buffer_write(buffer, buffer_u16, prefab.type);
    
    var n_data = ds_list_size(prefab.data);
    
    buffer_write(buffer, buffer_u8, n_data);
    for (var j = 0; j < n_data; j++) {
        buffer_write(buffer, buffer_string, prefab.data[| j]);
    }
    
    // I like the event prefab idea less than i did before i realized
    // that i was going to have to do this
    switch (prefab.type) {
        case EventNodeTypes.ENTRYPOINT:
        case EventNodeTypes.TEXT:
        case EventNodeTypes.SHOW_CHOICES:
            break;
        case EventNodeTypes.CONDITIONAL:
            var list_types = prefab.custom_data[| 0];
            var list_indices = prefab.custom_data[| 1];
            var list_comparisons = prefab.custom_data[| 2];
            var list_values = prefab.custom_data[| 3];
            var list_code = prefab.custom_data[| 4];
                
            buffer_write(buffer, buffer_u8, ds_list_size(list_types));
            for (var j = 0; j < ds_list_size(list_types); j++) {
                buffer_write(buffer, buffer_u8, list_types[| j]);
                buffer_write(buffer, buffer_s32, list_indices[| j]);
                buffer_write(buffer, buffer_u8, list_comparisons[| j]);
                buffer_write(buffer, buffer_f32, list_values[| j]);
                buffer_write(buffer, buffer_string, list_code[| j]);
            }
            break;
        case EventNodeTypes.CUSTOM:
        default:
            buffer_write(buffer, buffer_datatype, prefab.custom_guid);
            // the size of this list should already be known by the custom event node
            var custom = guid_get(prefab.custom_guid);
            
            for (var j = 0; j < ds_list_size(prefab.custom_data); j++) {
                var type = custom.types[| j];
                switch (type[EventNodeCustomData.TYPE]) {
                    case DataTypes.INT:
                        var save_type = buffer_s32;
                        break;
                    case DataTypes.FLOAT:
                        var save_type = buffer_f32;
                        break;
                    case DataTypes.BOOL:
                        var save_type = buffer_u8;
                        break;
                    case DataTypes.STRING:
                    case DataTypes.CODE:
                        var save_type = buffer_string;
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
                    case DataTypes.IMG_TILESET:
                    case DataTypes.IMG_BATTLER:
                    case DataTypes.IMG_ETC:
                    case DataTypes.IMG_OVERWORLD:
                    case DataTypes.IMG_PARTICLE:
                    case DataTypes.IMG_UI:
                        var save_type = buffer_datatype;
                        break;
                    case DataTypes.COLOR:
                        var save_type = buffer_u32;
                        break;
                    case DataTypes.TILE:
                    case DataTypes.AUTOTILE:
                        not_yet_implemented();
                        break;
                }
                
                var n_custom_data = ds_list_size(prefab.custom_data[| j]);
                buffer_write(buffer, buffer_u8, n_custom_data);
                for (var k = 0; k < n_custom_data; k++) {
                    buffer_write(buffer, save_type, ds_list_find_value(prefab.custom_data[| j], k));
                }
            }
            break;
    }
}

buffer_poke(buffer, addr_next, buffer_u64, buffer_tell(buffer));

return buffer_tell(buffer);