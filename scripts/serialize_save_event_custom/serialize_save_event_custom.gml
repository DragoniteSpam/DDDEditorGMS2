/// @param buffer
function serialize_save_event_custom(argument0) {

    var buffer = argument0;

    buffer_write(buffer, buffer_u32, SerializeThings.EVENT_CUSTOM);
    var addr_next = buffer_tell(buffer);
    buffer_write(buffer, buffer_u64, 0);

    var n_custom = ds_list_size(Stuff.all_event_custom);
    buffer_write(buffer, buffer_u16, n_custom);

    for (var i = 0; i < n_custom; i++) {
        var custom = Stuff.all_event_custom[| i];
        serialize_save_generic(buffer, custom);
    
        var n_types = ds_list_size(custom.types);
        buffer_write(buffer, buffer_u8, n_types);
        for (var j = 0; j < n_types; j++) {
            var type = custom.types[| j];
            buffer_write(buffer, buffer_string, type[0]);    // name
            buffer_write(buffer, buffer_u8, type[1]);        // data type
            buffer_write(buffer, buffer_datatype, type[2]);  // data guid
            buffer_write(buffer, buffer_u8, type[3]);        // max list size
            buffer_write(buffer, buffer_u8, type[4]);        // all elements required?
        }
    
        var n_outbound = ds_list_size(custom.outbound);
        buffer_write(buffer, buffer_u8, n_outbound);
        for (var j = 0; j < n_outbound; j++) {
            buffer_write(buffer, buffer_string, custom.outbound[| j]);
        }
    }

    buffer_poke(buffer, addr_next, buffer_u64, buffer_tell(buffer));

    return buffer_tell(buffer);


}
