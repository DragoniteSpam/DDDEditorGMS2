/// @param buffer
// i'd do this in serialize_save_datadata but i'd prefer to keep these things
// separated - for now

var buffer = argument0;

buffer_write(buffer, buffer_u32, SerializeThings.DATA_INSTANCES);
var addr_next = buffer_tell(buffer);
buffer_write(buffer, buffer_u64, 0);

var n_datadata = ds_list_size(Stuff.all_data);

for (var i = 0; i < n_datadata; i++) {
    var datadata = Stuff.all_data[| i];
    
    if (datadata.type == DataTypes.DATA) {
        var n_properties = ds_list_size(datadata.properties);
        var n_instances = ds_list_size(datadata.instances);
        
        buffer_write(buffer, buffer_u16, n_instances);
        for (var j = 0; j < n_instances; j++) {
            var instance = datadata.instances[| j];
            
            serialize_save_generic(buffer, instance);
            
            for (var k = 0; k < n_properties; k++) {
                var property = datadata.properties[| k];
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
                    case DataTypes.ENUM:
                    case DataTypes.DATA:
                    case DataTypes.MESH:
                    case DataTypes.IMG_TILESET:
                    case DataTypes.IMG_BATTLER:
                    case DataTypes.IMG_OVERWORLD:
                    case DataTypes.IMG_PARTICLE:
                    case DataTypes.IMG_UI:
                    case DataTypes.IMG_ETC:
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
                
                var vlist = instance.values[| k];
                var n_vlist = ds_list_size(vlist);
                buffer_write(buffer, buffer_u8, n_vlist);
                
                for (var l = 0; l < ds_list_size(vlist); l++) {
                    buffer_write(buffer, btype, ds_list_find_value(vlist, l));
                }
            }
        }
    }
}

buffer_poke(buffer, addr_next, buffer_u64, buffer_tell(buffer));

return buffer_tell(buffer);