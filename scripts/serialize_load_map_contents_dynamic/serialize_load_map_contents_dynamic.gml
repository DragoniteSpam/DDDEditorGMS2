/// @param buffer
/// @param version

var buffer = argument0;
var version = argument1;

var n_things = buffer_read(buffer, buffer_u32);

repeat(n_things) {
    var type = buffer_read(buffer, buffer_u16);
    var thing = instantiate(Stuff.etype_objects[type]);
    script_execute(thing.load_script, buffer, thing, version);
    
    map_add_thing(thing);
}