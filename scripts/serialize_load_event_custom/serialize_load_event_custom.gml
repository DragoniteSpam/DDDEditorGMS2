/// @description  void serialize_load_event_custom(buffer, version);
/// @param buffer
/// @param  version

var n_custom=buffer_read(argument0, buffer_u16);

repeat(n_custom){
    var custom=instance_create(0, 0, DataEventNodeCustom);
    serialize_load_generic(argument0, custom, argument1);
    
    var n_types=buffer_read(argument0, buffer_u8);
    repeat(n_types){
        var name=buffer_read(argument0, buffer_string);
        var type=buffer_read(argument0, buffer_u8);
        var guid=buffer_read(argument0, buffer_u32);
        var max_size=buffer_read(argument0, buffer_u8);
        var required=buffer_read(argument0, buffer_u8);
        
        ds_list_add(custom.types, array_compose(name, type, guid, max_size, required));
    }
    
    ds_list_add(Stuff.all_event_custom, custom);
}
