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
        
        ds_list_add(custom.types, [name, type, guid, max_size, required]);
    }
    
    ds_list_add(Stuff.all_event_custom, custom);
}

if (argument1 >= DataVersions.EVENT_NODE_PREFAB) {
    var n_prefabs = buffer_read(argument0, buffer_u16);

    for (var i = 0; i < n_prefabs; i++) {
        var prefab = instantiate(DataEventNodeCustom);
        serialize_load_generic(argument0, prefab, argument1);
        
        var n_types = buffer_read(argument0, buffer_u8);
        repeat(n_types) {
            var name = buffer_read(argument0, buffer_string);
            var type = buffer_read(argument0, buffer_u8);
            var guid = buffer_read(argument0, buffer_u32);
            var max_size = buffer_read(argument0, buffer_u8);
            var required = buffer_read(argument0, buffer_u8);
        
            ds_list_add(prefab.types, [name, type, guid, max_size, required]);
        }
        
        instance_destroy(Stuff.event_prefab[i]);
        Stuff.event_prefab[i] = prefab;
        // if there are more prefabs that are read out of the file than there is space
        // for, the game will start to slow down as it resizes the array, so don't do that
    }
}