/// @param buffer
/// @param version

var buffer = argument0;
var version = argument1;

var addr_next = buffer_read(buffer, buffer_u64);

var n_datadata = buffer_read(buffer, buffer_u16);

repeat (n_datadata) {
    var type = buffer_read(buffer, buffer_u16);
    var data = instance_create_depth(0, 0, 0, (type == DataTypes.ENUM ? DataEnum : DataData));
    
    if (version >= DataVersions.NUKE_UNUSED_BOOLS) {
    } else {
        buffer_read(buffer, buffer_u8);
    }
    
    guid_remove(data.GUID);
    
    serialize_load_generic(buffer, data, version);
    
    guid_set(data);
    
    var n_properties = buffer_read(buffer, buffer_u16);
    
    repeat (n_properties) {
        var property = instance_create_depth(0, 0, 0, DataProperty);
        ds_list_add(data.properties, property);
        guid_remove(property.GUID);
        
        serialize_load_generic(buffer, property, version);
        
        if (version >= DataVersions.NUKE_UNUSED_BOOLS) {
        } else {
            buffer_read(buffer, buffer_u8);
        }
        
        switch (data.type) {
            case DataTypes.ENUM:
                break;
            case DataTypes.DATA:
                property.type = buffer_read(buffer, buffer_u8);
                property.range_min = buffer_read(buffer, buffer_f32);
                property.range_max = buffer_read(buffer, buffer_f32);
                property.number_scale = buffer_read(buffer, buffer_u8);
                property.char_limit = buffer_read(buffer, buffer_u16);
                property.type_guid = buffer_read(buffer, buffer_u32);
                property.default_code = buffer_read(buffer, buffer_string);
                
                property.max_size = buffer_read(buffer, buffer_u8);
                property.default_string = buffer_read(buffer, buffer_string);
                property.default_int = buffer_read(buffer, buffer_s32);
                property.default_real = buffer_read(buffer, buffer_f32);
                
                if (version >= DataVersions.NUKE_UNUSED_BOOLS) {
                } else {
                    buffer_read(buffer, buffer_u32);
                }
                break;
        }
    }
}