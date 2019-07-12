/// @param buffer

buffer_write(argument0, buffer_datatype, SerializeThings.EVENT_CUSTOM);

var n_custom = ds_list_size(Stuff.all_event_custom);
buffer_write(argument0, buffer_u16, n_custom);

for (var i = 0; i < n_custom; i++) {
    var custom = Stuff.all_event_custom[| i];
    serialize_save_generic(argument0, custom);
    
    var n_types = ds_list_size(custom.types);
    buffer_write(argument0, buffer_u8, n_types);
    for (var j = 0; j < n_types; j++) {
        var type = custom.types[| j];
        buffer_write(argument0, buffer_string, type[0]);    // name
        buffer_write(argument0, buffer_u8, type[1]);        // data type
        buffer_write(argument0, buffer_u32, type[2]);       // data guid
        buffer_write(argument0, buffer_u8, type[3]);        // max list size
        buffer_write(argument0, buffer_u8, type[4]);        // all elements required?
    }
}

// plus the prefabs

var n_prefabs = array_length_1d(Stuff.event_prefab);
buffer_write(argument0, buffer_u16, n_prefabs);

for (var i = 0; i < n_prefabs; i++) {
    var prefab = Stuff.event_prefab[i];
    serialize_save_generic(argument0, prefab);
    
    var n_types = ds_list_size(prefab.types);
    buffer_write(argument0, buffer_u8, n_types);
    for (var j = 0; j < n_types; j++) {
        var type = prefab.types[| j];
        buffer_write(argument0, buffer_string, type[0]);    // name
        buffer_write(argument0, buffer_u8, type[1]);        // data type
        buffer_write(argument0, buffer_u32, type[2]);       // data guid
        buffer_write(argument0, buffer_u8, type[3]);        // max list size
        buffer_write(argument0, buffer_u8, type[4]);        // all elements required?
    }
}