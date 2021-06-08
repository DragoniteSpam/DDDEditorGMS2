function serialize_load_data_instances(buffer, version) {
    var addr_next = buffer_read(buffer, buffer_u64);
    
    var n_datadata = array_length(Game.data);
    
    for (var i = 0; i < n_datadata; i++) {
        var datadata = Game.data[i];
        
        if (datadata.type == DataTypes.DATA) {
            var n_properties = array_length(datadata.properties);
            var n_instances = buffer_read(buffer, buffer_u16);
            
            for (var j = 0; j < n_instances; j++) {
                var instance = new SDataInstance("");
                instance.parent = datadata.GUID;
                datadata.AddInstance(instance);
                var btype;
                
                serialize_load_generic(buffer, instance, version);
                
                instance.values = array_create(n_properties);
                
                for (var k = 0; k < n_properties; k++) {
                    var property = datadata.properties[k];
                    switch (property.type) {
                        case DataTypes.INT:
                            // constraining this to the range allowed by the property (u8, s8,
                            // s16, etc) sounds fun but probably not worth the time
                            btype = buffer_s32;
                            break;
                        case DataTypes.FLOAT:
                            btype = buffer_f32;
                            break;
                        case DataTypes.STRING:
                        case DataTypes.CODE:
                            btype = buffer_string;
                            break;
                        case DataTypes.BOOL:
                            btype = buffer_u8;
                            break;
                        case DataTypes.COLOR:
                            btype = buffer_u32;
                            break;
                        case DataTypes.ASSET_FLAG:
                            btype = buffer_flag;
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
                            btype = buffer_datatype;
                            break;
                        case DataTypes.TILE:
                            not_yet_implemented();
                            break;
                    }
                    
                    var n = buffer_read(buffer, buffer_u8);
                    var plist = array_create(n);
                    for (var l = 0; l < n; l++) {
                        plist[@ l] = buffer_read(buffer, btype);
                    }
                    instance.values[@ k] = plist;
                }
            }
        }
    }
}