function serialize_save_data_instances(buffer) {
    // i'd do this in serialize_save_datadata but i'd prefer to keep these
    // things separated - for now
    buffer_write(buffer, buffer_u32, SerializeThings.DATA_INSTANCES);
    var addr_next = buffer_tell(buffer);
    buffer_write(buffer, buffer_u64, 0);
    
    var n_datadata = ds_list_size(Stuff.all_data);
    
    for (var i = 0; i < n_datadata; i++) {
        var datadata = Stuff.all_data[| i];
        
        if (datadata.type == DataTypes.DATA) {
            var n_properties = array_length(datadata.properties);
            var n_instances = array_length(datadata.instances);
            
            buffer_write(buffer, buffer_u16, n_instances);
            for (var j = 0; j < n_instances; j++) {
                var instance = datadata.instances[j];
                
                serialize_save_generic(buffer, instance);
                
                for (var k = 0; k < n_properties; k++) {
                    var property = datadata.properties[k];
                    switch (property.type) {
                        case DataTypes.INT:
                            var btype = buffer_s32;
                            break;
                        case DataTypes.FLOAT:
                            var btype = buffer_f32;
                            break;
                        case DataTypes.STRING:
                        case DataTypes.CODE:
                            var btype = buffer_string;
                            break;
                        case DataTypes.BOOL:
                            var btype = buffer_u8;
                            break;
                        case DataTypes.COLOR:
                            var btype = buffer_u32;
                            break;
                        case DataTypes.ASSET_FLAG:
                            var btype = buffer_flag;
                            break;
                        case DataTypes.ENUM:
                        case DataTypes.DATA:
                        case DataTypes.MESH:
                        case DataTypes.MESH_AUTOTILE:
                        case DataTypes.IMG_TEXTURE:
                        case DataTypes.IMG_BATTLER:
                        case DataTypes.IMG_OVERWORLD:
                        case DataTypes.IMG_PARTICLE:
                        case DataTypes.IMG_UI:
                        case DataTypes.IMG_ETC:
                        case DataTypes.IMG_SKYBOX:
                        case DataTypes.IMG_TILE_ANIMATION:
                        case DataTypes.AUDIO_BGM:
                        case DataTypes.AUDIO_SE:
                        case DataTypes.ANIMATION:
                        case DataTypes.MAP:
                        case DataTypes.EVENT:
                        case DataTypes.ENTITY:
                            var btype = buffer_datatype;
                            break;
                        case DataTypes.TILE:
                            not_yet_implemented();
                            break;
                    }
                    
                    var vlist = instance.values[k];
                    var n_vlist = array_length(vlist);
                    buffer_write(buffer, buffer_u8, n_vlist);
                    
                    for (var l = 0; l < n_vlist; l++) {
                        buffer_write(buffer, btype, vlist[l]);
                    }
                }
            }
        }
    }
    
    buffer_poke(buffer, addr_next, buffer_u64, buffer_tell(buffer));
    
    return buffer_tell(buffer);
}