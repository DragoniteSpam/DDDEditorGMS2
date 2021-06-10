function serialize_load_event_custom(buffer, version) {
    var addr_next = buffer_read(buffer, buffer_u64);
    
    var n_custom = buffer_read(buffer, buffer_u16);
    
    repeat (n_custom) {
        var custom = instance_create_depth(0, 0, 0, DataEventNodeCustom);
        serialize_load_generic(buffer, custom, version);
        
        var n_types = buffer_read(buffer, buffer_u8);
        repeat (n_types) {
            var name = buffer_read(buffer, buffer_string);
            var type = buffer_read(buffer, buffer_u8);
            var guid = buffer_read(buffer, buffer_datatype);
            var max_size = buffer_read(buffer, buffer_u8);
            var required = buffer_read(buffer, buffer_u8);
            
            // @todo if you decide to allow the user to define default values, or other things,
            // remember to save them here
            ds_list_add(custom.types, [name, type, guid, max_size, required, 0, null, null]);
        }
        
        var n_outbound = buffer_read(buffer, buffer_u8);
        
        custom.outbound = array_create(n_outbound);
        for (var i = 0; i < n_outbound; i++) {
            custom.outbound[i] = buffer_read(buffer, buffer_string);
        }
        
        ds_list_add(Stuff.Game.events.custom, custom);
    }
}