/// @param buffer
// i'd do this in serialize_save_datadata but i'd prefer to keep these things
// separated - for now

buffer_write(argument0, buffer_datatype, SerializeThings.DATA_INSTANCES);

var n_datadata = ds_list_size(Stuff.all_data);

for (var i = 0; i < n_datadata; i++) {
    var datadata = Stuff.all_data[| i];
    
    if (!datadata.is_enum) {
        var n_properties = ds_list_size(datadata.properties);
        var n_instances = ds_list_size(datadata.instances);
        
        buffer_write(argument0, buffer_u16, n_instances);
        for (var j = 0; j < n_instances; j++) {
            var instance = datadata.instances[| j];
            
            serialize_save_generic(argument0, instance);
            
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
                    case DataTypes.MAP:
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
                        not_yet_implemented();
                        break;
                    case DataTypes.ENTITY:
                        // not sure how this happened but
                        var btype = buffer_u32;
                        break;
                    
                }
                
                var vlist = instance.values[| k];
                var n_vlist = ds_list_size(vlist);
                buffer_write(argument0, buffer_u8, n_vlist);
                
                for (var l = 0; l < ds_list_size(vlist); l++) {
                    buffer_write(argument0, btype, ds_list_find_value(vlist, l));
                }
            }
        }
    }
}