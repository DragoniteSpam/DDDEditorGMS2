/// @param buffer
/// @param version

var buffer = argument0;
var version = argument1;

var n_datadata = buffer_read(buffer, buffer_u16);
repeat (n_datadata) {
    var bools = buffer_read(buffer, buffer_u8);
    
    var data = instantiate(unpack(bools, 0) ? DataEnum : DataData);
    guid_remove(data.GUID);
    
    serialize_load_generic(buffer, data, version);
    
    data.deleted = unpack(bools, 1);
    
    guid_set(data);
    
    var n_properties = buffer_read(buffer, buffer_u16);
    
    repeat (n_properties) {
        var property = instantiate(DataProperty);
        ds_list_add(data.properties, property);
        guid_remove(property.GUID);
        
        serialize_load_generic(buffer, property, version);
        
        var pbools = buffer_read(buffer, buffer_u8);
        property.deleted = unpack(pbools, 0);
        
        if (data.is_enum) {
            // nothing special was saved
        } else {
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
        }
    }
}