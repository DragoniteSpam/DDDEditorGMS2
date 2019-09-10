/// @param buffer
/// @param version
/// @param DataMapContainer

var buffer = argument0;
var version = argument1;
var map = argument2.contents;

var n_things = buffer_read(buffer, buffer_u32);

repeat(n_things) {
    var type = buffer_read(buffer, buffer_u16);
    var thing = instance_create_depth(0, 0, 0, Stuff.etype_objects[type]);
    script_execute(thing.load_script, buffer, thing, version);
    
    map_add_thing(thing);
}