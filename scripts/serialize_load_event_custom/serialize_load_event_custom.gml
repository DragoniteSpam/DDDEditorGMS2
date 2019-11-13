/// @param buffer
/// @param version

var buffer = argument0;
var version = argument1;

if (version >= DataVersions.DATA_CHUNK_ADDRESSES) {
    var addr_next = buffer_read(buffer, buffer_u64);
}

var n_custom = buffer_read(buffer, buffer_u16);

repeat (n_custom) {
    var custom = instance_create_depth(0, 0, 0, DataEventNodeCustom);
    serialize_load_generic(buffer, custom, version);
    
    var n_types = buffer_read(buffer, buffer_u8);
    repeat (n_types) {
        var name = buffer_read(buffer, buffer_string);
        var type = buffer_read(buffer, buffer_u8);
        var guid = buffer_read(buffer, buffer_u32);
        var max_size = buffer_read(buffer, buffer_u8);
        var required = buffer_read(buffer, buffer_u8);
        
        // @todo if you decide to allow the user to define default values, or other things,
        // remember to save them here
        ds_list_add(custom.types, [name, type, guid, max_size, required, 0, null, null]);
    }
	
	if (version >= DataVersions.CUSTOM_EVENT_OUTBOUND) {
		var n_outbound = buffer_read(buffer, buffer_u8);
		ds_list_clear(custom.outbound);
		repeat (n_outbound) {
			ds_list_add(custom.outbound, buffer_read(buffer, buffer_string));
		}
	}
    
    ds_list_add(Stuff.all_event_custom, custom);
}