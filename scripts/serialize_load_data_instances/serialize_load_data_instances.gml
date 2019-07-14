/// @param buffer
/// @param version

var version = argument1;

var n_datadata = ds_list_size(Stuff.all_data);

for (var i = 0; i < n_datadata; i++) {
    var datadata = Stuff.all_data[| i];
    
    if (!datadata.is_enum) {
        var n_properties = ds_list_size(datadata.properties);
        var n_instances = buffer_read(argument0, buffer_u16);
        
        for (var j = 0; j < n_instances; j++) {
            var instance = instantiate(DataInstantiated);
            ds_list_add(datadata.instances, instance);
            
            serialize_load_generic(argument0, instance, version);
            
            for (var k = 0; k < n_properties; k++) {
                var property = datadata.properties[| k];
                switch (property.type) {
                    case DataTypes.INT:
                        // constraining this to the range allowed by the property (u8, s8,
                        // s16, etc) sounds fun but probably not worth the time
                        var btype = buffer_s32;
                        break;
                    case DataTypes.ENUM:
                    case DataTypes.DATA:
                    case DataTypes.MESH:
                    case DataTypes.TILESET:
                    case DataTypes.AUTOTILE:
                    case DataTypes.AUDIO_BGM:
                    case DataTypes.AUDIO_SE:
                    case DataTypes.ANIMATION:
                        var btype = buffer_u32;
                        break;
                    case DataTypes.FLOAT:
                        var btype = buffer_f32;
                        break;
                    case DataTypes.STRING:
                    case DataTypes.CODE:
                        var btype = buffer_string;
                        break;
                    case DataTypes.BOOL:
                        // could pack these but the savings are honestly just not
                        // significant enough for me to dedicate time to this if it's
                        // not as simple as just using pack/unpack
                        var btype = buffer_u8;
                        break;
                    case DataTypes.COLOR:
                        var btype = buffer_u32;
                        break;
                    case DataTypes.TILE:
                        stack_trace();
                        break;
                }
                var plist = ds_list_create();
                if (argument1 >= DataVersions.DATADATA_SAVE_LISTS) {
                    var n = buffer_read(argument0, buffer_u8);
                    repeat (n) {
                        ds_list_add(plist, buffer_read(argument0, btype));
                    }
                } else {
                    ds_list_add(plist, buffer_read(argument0, btype));
                }
                ds_list_add(instance.values, plist);
            }
        }
    }
}

instance_deactivate_object(DataInstantiated);