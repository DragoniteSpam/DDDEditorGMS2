/// @param buffer

buffer_write(argument0, buffer_datatype, SerializeThings.DATADATA);

var n_datadata = ds_list_size(Stuff.all_data);
buffer_write(argument0, buffer_u16, n_datadata);

for (var i = 0; i < n_datadata; i++) {
    var datadata = Stuff.all_data[| i];
    
    // is_enum is looked at to determine if you're a data type or enum, so save it first
    buffer_write(argument0, buffer_u8, pack(datadata.is_enum, datadata.deleted));
    serialize_save_generic(argument0, datadata);
    buffer_write(argument0, buffer_string, datadata.summary);
    
    var n_properties = ds_list_size(datadata.properties);
    buffer_write(argument0, buffer_u16, n_properties);
    
    for (var j = 0; j < n_properties; j++) {
        var property = datadata.properties[| j];
        
        serialize_save_generic(argument0, property);
        buffer_write(argument0, buffer_u8, pack(property.deleted));
        
        if (datadata.is_enum) {
            // then nothing else matters besides the name and other basic things
        } else {
            buffer_write(argument0, buffer_u8, property.type);
            buffer_write(argument0, buffer_f32, property.range_min);
            buffer_write(argument0, buffer_f32, property.range_max);
            buffer_write(argument0, buffer_u8, property.number_scale);
            buffer_write(argument0, buffer_u16, property.char_limit);
            buffer_write(argument0, buffer_u32, property.type_guid);
            buffer_write(argument0, buffer_string, property.default_code);
            buffer_write(argument0, buffer_u8, property.max_size);
            buffer_write(argument0, buffer_string, property.default_string);
            buffer_write(argument0, buffer_s32, property.default_int);
            buffer_write(argument0, buffer_f32, property.default_real);
        }
    }
    
    // instances are saved in a loop later
}