/// @description void serialize_load_map_contents_dynamic(buffer, version);
/// @param buffer
/// @param version

var version=argument1;

var n_things=buffer_read(argument0, buffer_u32);

repeat(n_things) {
    var type=buffer_read(argument0, buffer_u16);
    var thing=instantiate(Stuff.etype_objects[type]);
    script_execute(thing.load_script, argument0, thing, version);
    
    map_add_thing(thing);
}
