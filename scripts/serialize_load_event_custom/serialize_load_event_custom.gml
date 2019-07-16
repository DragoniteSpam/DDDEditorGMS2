/// @param buffer
/// @param version

var n_custom = buffer_read(argument0, buffer_u16);

repeat(n_custom) {
    var custom = instantiate(DataEventNodeCustom);
    serialize_load_generic(argument0, custom, argument1);
    
    var n_types = buffer_read(argument0, buffer_u8);
    repeat(n_types) {
        var name = buffer_read(argument0, buffer_string);
        var type = buffer_read(argument0, buffer_u8);
        var guid = buffer_read(argument0, buffer_u32);
        var max_size = buffer_read(argument0, buffer_u8);
        var required = buffer_read(argument0, buffer_u8);
        
        // @todo if you decide to allow the user to define default values,
        // remember to save them here
        ds_list_add(custom.types, [name, type, guid, max_size, required, 0, null]);
    }
    
    ds_list_add(Stuff.all_event_custom, custom);
}