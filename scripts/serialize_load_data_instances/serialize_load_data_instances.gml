function serialize_load_data_instances(buffer, version) {
    var addr_next = buffer_read(buffer, buffer_u64);
    
    var n_datadata = ds_list_size(Stuff.all_data);
    
    for (var i = 0; i < n_datadata; i++) {
        var datadata = Stuff.all_data[| i];
        
        if (datadata.type == DataTypes.DATA) {
            var n_properties = ds_list_size(datadata.properties);
            var n_instances = buffer_read(buffer, buffer_u16);
            
            for (var j = 0; j < n_instances; j++) {
                var instance = instance_create_depth(0, 0, 0, DataInstantiated);
                instance.base_guid = datadata.GUID;
                ds_list_add(datadata.instances, instance);
                
                serialize_load_generic(buffer, instance, version);
                
                for (var k = 0; k < n_properties; k++) {
                    var property = datadata.properties[| k];
                    switch (property.type) {
                        case DataTypes.INT:
                            // constraining this to the range allowed by the property (u8, s8,
                            // s16, etc) sounds fun but probably not worth the time
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
                            var btype = buffer_get_datatype(version);
                            break;
                        case DataTypes.TILE:
                            not_yet_implemented();
                            break;
                    }
                    var plist = ds_list_create();
                    var n = buffer_read(buffer, buffer_u8);
                    repeat (n) {
                        ds_list_add(plist, buffer_read(buffer, btype));
                    }
                    ds_list_add(instance.values, plist);
                }
            }
        }
    }
    
    instance_deactivate_object(DataInstantiated);
}