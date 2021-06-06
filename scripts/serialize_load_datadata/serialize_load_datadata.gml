function serialize_load_datadata(buffer, version) {
    var addr_next = buffer_read(buffer, buffer_u64);
    var n_datadata = buffer_read(buffer, buffer_u16);
    
    repeat (n_datadata) {
        var type = buffer_read(buffer, buffer_u16);
        var data = new SDataClass("");
        data.type = type;
        
        guid_remove(data.GUID);
        
        serialize_load_generic(buffer, data, version);
        
        var n_properties = buffer_read(buffer, buffer_u16);
        repeat (n_properties) {
            var property = new SDataProperty("");
            ds_list_add(data.properties, property);
            
            serialize_load_generic(buffer, property, version);
            
            switch (data.type) {
                case DataTypes.ENUM:
                    break;
                case DataTypes.DATA:
                    property.type = buffer_read(buffer, buffer_u8);
                    property.range_min = buffer_read(buffer, buffer_f32);
                    property.range_max = buffer_read(buffer, buffer_f32);
                    property.number_scale = buffer_read(buffer, buffer_u8);
                    property.char_limit = buffer_read(buffer, buffer_u16);
                    property.type_guid = buffer_read(buffer, buffer_datatype);
                    property.default_code = buffer_read(buffer, buffer_string);
                    
                    property.max_size = buffer_read(buffer, buffer_u8);
                    property.size_can_be_zero = buffer_read(buffer, buffer_u8);
                    property.default_string = buffer_read(buffer, buffer_string);
                    property.default_int = buffer_read(buffer, buffer_s32);
                    property.default_real = buffer_read(buffer, buffer_f32);
                    break;
            }
        }
    }
}