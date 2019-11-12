/// @param buffer

var buffer = argument0;

buffer_write(buffer, buffer_datatype, SerializeThings.DATADATA);

var n_datadata = ds_list_size(Stuff.all_data);
buffer_write(buffer, buffer_u16, n_datadata);

for (var i = 0; i < n_datadata; i++) {
    var datadata = Stuff.all_data[| i];
    
    buffer_write(buffer, buffer_u16, datadata.type);
    // type is looked at to determine if you're a data type or enum, so save it first
    buffer_write(buffer, buffer_u8, pack(datadata.deleted));
    serialize_save_generic(buffer, datadata);
    
    var n_properties = ds_list_size(datadata.properties);
    buffer_write(buffer, buffer_u16, n_properties);
    
    for (var j = 0; j < n_properties; j++) {
        var property = datadata.properties[| j];
        
        serialize_save_generic(buffer, property);
        buffer_write(buffer, buffer_u8, pack(property.deleted));
        
        if (datadata.type == DataTypes.DATA) {
            buffer_write(buffer, buffer_u8, property.type);
            buffer_write(buffer, buffer_f32, property.range_min);
            buffer_write(buffer, buffer_f32, property.range_max);
            buffer_write(buffer, buffer_u8, property.number_scale);
            buffer_write(buffer, buffer_u16, property.char_limit);
            buffer_write(buffer, buffer_u32, property.type_guid);
            buffer_write(buffer, buffer_string, property.default_code);
            buffer_write(buffer, buffer_u8, property.max_size);
            buffer_write(buffer, buffer_string, property.default_string);
            buffer_write(buffer, buffer_s32, property.default_int);
            buffer_write(buffer, buffer_f32, property.default_real);
			
			var bools = 0;
			
			buffer_write(buffer, buffer_u32, bools);
        } else {
            // then nothing else matters besides the name and other basic things
        }
    }
    
    // instances are saved in a loop later
}

return buffer_tell(buffer);