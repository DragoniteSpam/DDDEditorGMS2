/// @param buffer
/// @param version

var n_datadata = buffer_read(argument0, buffer_u16);
repeat (n_datadata) {
    var bools = buffer_read(argument0, buffer_u8);
    
    if (unpack(bools, 0)) {
        // is enum?
        var data = instantiate(DataEnum);
    } else {
        // is data?
        var data = instantiate(DataData);
    }
    guid_remove(data.GUID);
    
    serialize_load_generic(argument0, data, argument1);
    data.summary = buffer_read(argument0, buffer_string);
    
    data.deleted = unpack(bools, 1);
    
    guid_set(data);
    
    var n_properties = buffer_read(argument0, buffer_u16);
    
    repeat (n_properties) {
        var property = instantiate(DataProperty);
        ds_list_add(data.properties, property);
        guid_remove(property.GUID);
        
        serialize_load_generic(argument0, property, argument1);
        
        guid_set(property);
        
        var pbools = buffer_read(argument0, buffer_u8);
        property.deleted = unpack(pbools, 0);
        
        if (data.is_enum) {
            // nothing special was saved
        } else {
            property.type = buffer_read(argument0, buffer_u8);
            property.range_min = buffer_read(argument0, buffer_f32);
            property.range_max = buffer_read(argument0, buffer_f32);
            property.number_scale = buffer_read(argument0, buffer_u8);
            property.char_limit = buffer_read(argument0, buffer_u16);
            property.type_guid = buffer_read(argument0, buffer_u32);
            
            if (argument1 >= DataVersions.DATA_INSTANCE_CODE) {
                property.default_code = buffer_read(argument0, buffer_string);
            }
        }
    }
}